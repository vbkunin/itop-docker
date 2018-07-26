#!/bin/bash

DOCUMENT_ROOT=/var/www/html
ITOP_RELEASE=2.5.0
ITOP_BUILD=3935
ITOP_URL="https://sourceforge.net/projects/itop/files/itop/${ITOP_RELEASE}/iTop-${ITOP_RELEASE}-${ITOP_BUILD}.zip"

[ -d $DOCUMENT_ROOT ] || mkdir -p $DOCUMENT_ROOT
cd $DOCUMENT_ROOT

# get iTOP
ls ./{pages/,data/,log/,setup/,portal/,}index.php > /dev/null 2>&1
[ $? -eq 0 ] || {
  rm -rd ./*
  _dn=$(mktemp -d)
  _fn="iTop-${ITOP_RELEASE}-${ITOP_BUILD}.zip"
  wget -O $_dn/$_fn $ITOP_URL \
  && unzip $_dn/$_fn web/* \
  && mv web/* ./ && rm -d web \
  && chown -R www-data:www-data $DOCUMENT_ROOT
}

# git init
[ -d "$DOCUMENT_ROOT"/.git ] || {
  git init
  git config user.email root@itop.loc
  git config user.name root
  cat >> .gitignore <<EOF
*.log
lib/silex/vendor/
EOF
  git add .
  git commit -m 'first commit'
}
