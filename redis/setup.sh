#!/bin/sh

check_exists_and_create_symlink()
{
    path="$1"

    if ! test -d workdir/"$path"; then
        if ! test -d ../repos/"$path"; then
            echo "No directory ../repos/$path. Run the top-level setup.sh script first." 1>&2
            exit 1
        fi
        depth=$(echo "$path" | awk -F / '{ print NF }')
        if test "$depth" -eq 1; then
            ln -sfn ../../repos/"$path" workdir/"$path"
        elif test "$depth" -eq 2; then
            ln -sfn ../../../repos/"$path" workdir/"$path"
        else
            echo "Unknown depth of path $path." 1>&2
            exit 1
        fi
    fi
}

if ! test -d workdir; then
    mkdir workdir
fi

if ! test -d workdir/libs; then
    mkdir workdir/libs
fi

git clone https://github.com/SalarSamani/unikraft_newlib.git workdir/unikraft
cd workdir/unikraft
git checkout port-PTE-GSOC2025
cd ../..

git clone https://github.com/SalarSamani/lib-newlib.git workdir/libs/newlib
cd workdir/libs/newlib
git checkout port-newlib-4.5
cd ../../..

git clone https://github.com/SalarSamani/lib-pthread-embedded.git workdir/libs/pthread_embedded
cd workdir/libs/pthread_embedded
git checkout port-PTE-GSOC2025
cd ../../..

git clone https://github.com/SalarSamani/lib-lwip.git workdir/libs/lwip
cd workdir/libs/lwip
git checkout port-newlib-4.5
cd ../../..

git clone https://github.com/SalarSamani/lib-redis.git workdir/libs/redis
cd workdir/libs/redis
git checkout port-PTE-GSOC2025
cd ../../..
