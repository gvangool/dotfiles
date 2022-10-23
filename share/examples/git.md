# Git snippets

Some random snippets that got created over the years, but are not always as correct as I want them to be :)

These assume you have [`gh`](https://cli.github.com/), [`jq`](https://stedolan.github.io/jq/) and recent bash (not built-in macOS)

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

## Deleting packages

```bash
#!/bin/bash -eu
set -o pipefail

org=${1:-XXX}
if [ "${org}" = "XXX" ] ; then
    echo "Please specify a user or organization: ${0} gvangool"
    exit 1
fi
repos=${@:2}
if [ -z "${repos}" ] ; then
    echo "Please specify a list of repositories: ${0} ${org} my-repo-1 my-repo-2"
    exit 1
fi
dryrun="${DRY_RUN:-1}"
if [ "${dryrun}" != "0" ] ; then
    echo "If you want to write the changes: DRY_RUN=0 ${0} ${org} ${repos}"
    echo ""
fi
temp_file="ghcr_prune.ids"
rm -rf "${temp_file}"

for container in ${repos} ; do
    echo "${org}/${container} - Fetching dangling images from GHCR..."
    gh api /orgs/${org}/packages/container/${container}/versions --paginate > ${temp_file}

    # Dangling images (no tags)
    ids_to_delete=$(cat "${temp_file}" | jq -r '.[] | select(.metadata.container.tags==[]) | .id')
    # Images tagged with pr-...
    #ids_to_delete=$(cat "${temp_file}" | jq -r '.[] | select(.metadata.container.tags[] | startswith("pr-")) | .id')

    if [ "${ids_to_delete}" = "" ]
    then
        echo "${org}/${container} - There are no dangling images to remove for this package"
        continue
    fi

    echo -e "\n${org}/${container} - Deleting dangling images..."
    while read -r line; do
        id="$line"
        ## Workaround for https://github.com/cli/cli/issues/4286 and https://github.com/cli/cli/issues/3937
        if [ "${dryrun}" = "0" ] ; then
            echo -n | gh api --method DELETE /orgs/${org}/packages/container/${container}/versions/${id} --input -
        fi
        echo "${org}/${container} - Dangling image with ID ${id} deleted successfully"
    done <<< $ids_to_delete

    rm -rf "${temp_file}"
done

echo -e "\nAll the dangling images have been removed successfully"
exit 0
```
