#!/bin/bash
time docker build \
        --build-arg VCS_REF=`git rev-parse --short HEAD` \
        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
        -t grodrigo/php:7.4-ecosistema2 . | tee build.log
