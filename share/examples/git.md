# Git snippets

Some random snippets that got created over the years, but are not always as correct as I want them to be :)

## Create a PR from an issue

```bash
#!/bin/bash -eu

BASE="${1:-main}"
ISSUE=${2}
branch_name="issues/${ISSUE}"

if [ "$(git branch --show-current)" != "${branch_name}" ] ; then
    # if branch doesn't exist
    git checkout ${BASE} && git checkout -b ${branch_name} && git ci -m "trigger" --allow-empty
    git push
fi
# create new PR
gh api repos/:owner/:repo/pulls -f "head=${branch_name}" -f "base=${BASE}" -F "issue=${ISSUE}"
```

## Show all open PRs in all repos of an org

```bash
#!/bin/bash -eu
set -o pipefail

org=${1:-XXX}
if [ "${org}" = "XXX" ] ; then
    echo "Please specify a user or organization: ${0} gvangool"
    exit 1
fi

repos=$(gh repo list ${org} --no-archived --json nameWithOwner --jq '.[] | .nameWithOwner')

for repo in ${repos} ; do
  gh pr list --repo="${repo}"
done
```
