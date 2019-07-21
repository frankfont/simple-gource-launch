#!/bin/bash
VERSIONINFO=20190721.1
echo "Starting $0 v$VERSIONINFO ..."

echo "USAGE $0 GIT_REPO_PATH [PROJECT_TITLE [LOGO_URL]]"
echo
echo "  GIT_REPO_PATH = A local directory containing repo logs or a URL to a git repo."
echo "  PROJECT_TITLE = Optional title to display in the generated movie."
echo "  LOGO_URL      = A URL to a graphic file to show in the movie as a logo."
echo

GIT_REPO_PATH=$1
PROJECT_TITLE=$2
LOGO_URL=$3

if [ -z "$GIT_REPO_PATH" ]; then
	echo "ERROR missing required GIT_REPO_PATH!"
	exit 2
fi
if [ -z "$PROJECT_TITLE" ]; then
	PROJECT_TITLE=$GIT_REPO_PATH
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
WEB_PORT=8080

if [ -d "$GIT_REPO_PATH" ]; then
	IS_DIR="YES"
	PATH_ARG=" -v ${GIT_REPO_PATH}:/visualization/git_repo:ro"
else
	IS_DIR="NO"
	PATH_ARG=" -e GIT_URL=$GIT_REPO_PATH"	
fi

echo "GIT_REPO_PATH    = $GIT_REPO_PATH"
if [ "YES" == "$IS_DIR" ]; then
	echo "                   (Filesystem directory)"
else
	echo "                   (Internet resource)"
fi

echo
echo "PROJECT_TITLE    = $PROJECT_TITLE"
echo "LOGO_URL         = $LOGO_URL"
echo "DOCKER_IMAGE     = $DOCKER_IMAGE"
echo "H264_PRESET      = $H264_PRESET"
echo "VIDEO_RESOLUTION = $VIDEO_RESOLUTION"
echo "Browser URL      = http://localhost:${WEB_PORT}"
echo
echo "Press CTRL-C to abort, else any other key to start"
read
echo

echo "Starting the run ..."
docker run --rm -p ${WEB_PORT}:80 --name envisaged \
       ${PATH_ARG} ${LOGO_URL_ARG} \
       -e GOURCE_TITLE="$PROJECT_TITLE" \
       -e VIDEO_RESOLUTION=$VIDEO_RESOLUTION \
       -e H264_PRESET=$H264_PRESET \
       $DOCKER_IMAGE

echo
echo "Finished!"
echo

