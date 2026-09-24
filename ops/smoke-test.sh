set -euo pipefail

IMAGE="${1:?usage: $0 <image>}"
NAME="${SMOKE_CONTAINER:-solr-smoke}"
CORE="smoke"
BASE="http://localhost:8983/solr"
TIMEOUT="${SMOKE_TIMEOUT:-120}"

cleanup() { docker rm -f "$NAME" >/dev/null 2>&1 || true; }
fail() {
  echo "SMOKE TEST FAILED: $*" >&2
  echo "--- container logs ---" >&2
  docker logs "$NAME" >&2 || true
  exit 1
}
trap cleanup EXIT

get()  { docker exec "$NAME" wget -qO- "$1"; }
post() { docker exec "$NAME" wget -qO- --header='Content-Type: application/json' --post-data="$2" "$1"; }

cleanup
docker run -d --name "$NAME" -e SOLR_HEAP=512m "$IMAGE" \
  bash -c "precreate-core $CORE /opt/config && exec solr-foreground" >/dev/null

echo "Waiting up to ${TIMEOUT}s for core '$CORE' to load..."
for ((i = 0; i < TIMEOUT; i++)); do
  if get "$BASE/$CORE/admin/ping?wt=json" 2>/dev/null | grep -q '"status":"OK"'; then
    break
  fi
  if [ -z "$(docker ps -q --filter "name=^/${NAME}$")" ]; then
    fail "container exited before the core came up"
  fi
  sleep 1
done
get "$BASE/$CORE/admin/ping?wt=json" | grep -q '"status":"OK"' \
  || fail "core '$CORE' did not answer ping within ${TIMEOUT}s"

status="$(get "$BASE/admin/cores?action=STATUS&wt=json")"
echo "$status" | grep -q "\"$CORE\"" || fail "core '$CORE' missing from STATUS: $status"
echo "$status" | grep -Eq '"initFailures":\{[[:space:]]*\}' || fail "core init failures reported: $status"

# Index a document with accented text and find it with a plain ASCII query.
# Success proves the ICU tokenizer/folding filters from the analysis-extras
# module are loaded, not merely that Solr started.
post "$BASE/$CORE/update?commit=true&wt=json" '[{"id":"smoke-1","title_tsim":"Ünïcödé Tést"}]' \
  | grep -q '"status":0' || fail "indexing a document failed"

result="$(get "$BASE/$CORE/select?qt=search&q=unicode+test&wt=json")"
echo "$result" | grep -q '"numFound":1' \
  || fail "'search' handler did not find the document (ICU folding broken?): $result"

result="$(get "$BASE/$CORE/select?qt=iiif_search&q=test&wt=json")"
echo "$result" | grep -q '"status":0' || fail "'iiif_search' handler failed: $result"

echo "SMOKE TEST PASSED: $IMAGE"
