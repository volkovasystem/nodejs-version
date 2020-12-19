#!/bin/bash

NODEJS_VERSION=$1;
NV=$NODEJS_VERSION;

[[ -z "$NV" ]] &&\
echo "cannot setup nodejs version, undefined version number" &&\
exit 1;

[[ -z "$PLATFORM_ROOT_DIRECTORY_PATH" ]] &&\
[[ $PLATFORM_ROOT_DIRECTORY_PATH == $PRDP ]] &&\
PLATFORM_ROOT_DIRECTORY_PATH=$HOME &&\
PRDP=$PLATFORM_ROOT_DIRECTORY_PATH;

NODEJS_VERSION_PATH_NAMESPACE="nodejs-version";
NVPN=$NODEJS_VERSION_PATH_NAMESPACE;

NODEJS_VERSION_PATH="$PRDP/$NVPN";
NVP=$NODEJS_VERSION_PATH;

NODEJS_PACKAGE_NAMESPACE="node-v$NODEJS_VERSION-linux-x64";
NPN=$NODEJS_PACKAGE_NAMESPACE;

NODEJS_DOWNLOAD_URL_PATH="https://nodejs.org/download/release/v$NODEJS_VERSION/$NPN.tar.gz";
NDUP=$NODEJS_DOWNLOAD_URL_PATH;

NODEJS_PACKAGE_FILE_PATH="$NVP/$NPN.tar.gz";
NPFP=$NODEJS_PACKAGE_FILE_PATH;

NODEJS_PACKAGE_DIRECTORY_PATH="$NVP/$NPN";
NPDP=$NODEJS_PACKAGE_DIRECTORY_PATH;

[ ! -d $NVP ] &&\
mkdir $NVP;

[ ! -f $NPFP ] &&\
curl $NDUP > $NPFP;

[ ! -d $NPDP ] &&\
tar -xzvf $NPFP -C $NVP;

NODEJS_PATH="$(ls -d $NVP/$(ls $NVP | grep $NV) 2>/dev/null)/bin";
NP=$NODEJS_PATH;

[[ $(echo $PATH | grep -oP $NVPN | head -1) == $NVPN ]] &&\
export PATH="$(echo $PATH | tr ":" "\n" | grep -v $NVPN | tr "\n" ":" | sed "s/:\{2,\}/:/g" | sed "s/:$//")";

[[ $(echo $PATH | grep -oP $NP ) != $NP ]] &&\
export PATH="$PATH:$NP";

[ -x /usr/bin/python ] &&\
npm config set python /usr/bin/python;

export NPM_BINARY_DIRECTORY_PATH="$(npm bin --global)";
export NBDP=$NPM_BINARY_DIRECTORY_PATH;

npm install --global npm;

echo "node@$(echo $($(which node) --version | head -n 1) | grep -Po '[0-9]+\.[0-9]+\.[0-9]+')";

echo "npm@$(echo $($(which npm) --version | head -n 1) | grep -Po '[0-9]+\.[0-9]+\.[0-9]+')";
