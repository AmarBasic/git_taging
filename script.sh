#!/bin/bash

major_max=1;
minor_max=0;
micro_max=0;

branch_name="${BRANCH_NAME}"

$(git fetch --tags)

last_tag=$(git describe --abbrev=0 --tags --exact-match)

if [[ $last_tag ]]; then

    version=$(echo $last_tag | grep -o '[^-]*$')
    major=$(echo $version | cut -d. -f1)
    minor=$(echo $version | cut -d. -f2)
    micro=$(echo $version | cut -d. -f3)


    if [ "$major_max" -lt "$major" ]; then
        let major_max=$major
    fi

    if [ "$minor_max" -lt "$minor" ]; then
        let minor_max=$minor
    fi

    if [ "$micro_max" -lt "$micro" ]; then
        let micro_max=$micro
    fi

    echo 'Latest version:' $major_max'.'$minor_max'.'$micro_max

    let micro_max=($micro_max+1)
fi

if [ "$major_max" -ne "${MAJOR_VERSION}" ] || [ "$minor_max" -ne "${MINOR_VERSION}" ]; then
    major_max="${MAJOR_VERSION}"
    minor_max="${MINOR_VERSION}"
    micro_max=0
fi

echo 'Switching to new version:' $major_max'.'$minor_max'.'$micro_max
$(git tag -a $branch_name-$major_max.$minor_max.$micro_max $branch_name -m "Version $major_max.$minor_max.$micro_max")
echo 'Push tag to remote'
$(git push origin $branch_name-$major_max.$minor_max.$micro_max $branch_name)
