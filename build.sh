#!/bin/bash
time docker build \
        --build-arg VCS_REF=`git rev-parse --short HEAD` \
        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
        -t grodrigo/php:8.2.9-apache-bullseye-laravel . | tee build.log
