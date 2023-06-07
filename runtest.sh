#!/bin/bash
if test -f ~/ok-by-run; then
  echo "::notice title=Commit Previously Passed::See $(cat ~/ok-by-run) (cache key 'commit-ok-${{ matrix.go }}-${{ github.sha }}')"
  exit 0
fi
printf '%s/%s/actions/runs/%s/attempts/%s\n'\
"${GITHUB_SERVER_URL}" "${GITHUB_REPOSITORY}" "${GITHUB_RUN_ID}" "${GITHUB_RUN_ATTEMPT}"\
> ~/ok-by-run
find . -name .git -prune -o -name testdata -prune -o -name go.mod -printf '%h\n' |
while read -r dir; do (
  cd "$dir"
  go list -m
  go mod download
  go test -race ${RUNNER_DEBUG:+-v} ./...
); done