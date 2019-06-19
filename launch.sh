#!/bin/bash
VERSIONINFO=20190619.1
echo "Starting $0 v$VERSIONINFO ..."

echo "USAGE $0 GIT_REPO_URL [PROJECT_TITLE [LOGO_URL]]"
echo

GIT_REPO_URL=$1
PROJECT_TITLE=$2
LOGO_URL=$3

if [ -z "$GIT_REPO_URL" ]; then
	echo "ERROR missing required GIT repo URL!"
	exit 2
fi
if [ -z "$PROJECT_TITLE" ]; then
	PROJECT_TITLE=$GIT_REPO_URL
fi
if [ -z "$LOGO_URL" ]; then
	LOGO_URL="NONE"
	LOGO_URL_ARG="-e LOGO_URL=$LOGO_URL"
else
	LOGO_URL_ARG=""
fi

DOCKER_IMAGE=jamesbrink/envisaged
VIDEO_RESOLUTION=720p
H264_PRESET=superfast

echo "GIT_REPO_URL     = $GIT_REPO_URL"
echo "PROJECT_TITLE    = $PROJECT_TITLE"
echo "LOGO_URL         = $LOGO_URL"
echo "DOCKER_IMAGE     = $DOCKER_IMAGE"
echo "H264_PRESET      = $H264_PRESET"
echo "VIDEO_RESOLUTION = $VIDEO_RESOLUTION"
echo
echo "Press CTRL-C to abort, else any other key to start"
read
echo

echo "Starting the run ..."
docker run --rm -p 8080:80 --name envisaged \
       -e GIT_URL=$GIT_REPO_URL $LOGO_URL_ARG \
       -e GOURCE_TITLE="$PROJECT_TITLE" \
       -e VIDEO_RESOLUTION=$VIDEO_RESOLUTION \
       -e H264_PRESET=$H264_PRESET \
       $DOCKER_IMAGE

echo
echo "Finished!"

