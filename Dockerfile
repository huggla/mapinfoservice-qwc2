ARG TAG="20181204"
ARG CONTENTIMAGE1="huggla/pyinstaller-alpine:$TAG"
ARG CONTENTDESTINATION1="/"
ARG BUILDDEPS="dash"
ARG BUILDCMDS=\
"   head -33 /buildfs/src/mapinfo.py.org > /src/mapinfo.py "\
"&& tail -26 /buildfs/src/mapinfo.py.add >> /src/mapinfo.py "\
"&& sed -i 's/# Copyright 2018, Sourcepole AG/# Copyright 2018, Sourcepole AG, Henrik Uggla/' /src/mapinfo.py "\
"&& cp /buildfs/src/requirements.txt /src/ "\
"&& cp -a /usr/bin/dash /usr/local/bin/ "\
"&& sed -i 's|shell=True,|shell=True, executable=\"/usr/local/bin/dash\",|g' /usr/local/lib/python2.7/ctypes/util.py "\
"&& cd /src "\
"&& /pyinstaller/pyinstaller.sh --onefile --noconfirm --clean --exclude-module Werkzeug --distpath /imagefs/usr/local/bin mapinfo.py"
ARG EXECUTABLES="/usr/local/bin/mapinfo"
ARG REMOVEFILES="/sbin /usr/include /usr/share /usr/sbin" 

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build:$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
COPY --from=build /imagefs /
#-----------------------------------------

ENV VAR_LINUX_USER="mapinfo" \
    VAR_GUNICORN_PARAMS="bind=0.0.0.0:8093" \
    VAR_FINAL_COMMAND="mapinfo \$VAR_GUNICORN_PARAMS"

#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------
