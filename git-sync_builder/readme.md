How to use
==========

This script is just a simple shortcut to build a git-sync container.
If it goes right, you should find the container image on your build machine (docker image ls).

**Building example:** ./build.sh v4.2.2

The build makefile generate a tag like "<version>__<os>_<cpu>", eg. "v4.2.2__linux_amd64"

**Saving example:** docker save --output git-sync-v4.2.2__linux_amd64.tar "gcr.io/k8s-staging-git-sync/git-sync:v4.2.2__linux_amd64"