#!/usr/bin/env bash
# Helper script for building stuff

dist_foldername="pdf-reader-dist"

yarn build
rm -rf $dist_foldername
mkdir $dist_foldername

function mkdist {
  f="$(basename -- $1)"
  f="$(echo "$f" | sed 's/^\([^\.]*\)\.\([^\.]*\)\.\(.*\)$/\1.\3/')"
  ie=$(printf '%s\n' "$(basename -- $1)" | sed -e 's/[]\/$*.^[]/\\&/g')
  fe=$f #$(printf '%s\n' "$f" | sed -e 's/[]\/$*.^[]/\\&/g')
  echo "$ie --> $fe"
  grep "$1" -rl  $(dirname $1) | xargs sed -i "s/$ie/$f/g"
  cp $1 $dist_foldername/$f
}

for i in build/static/js/*.js
do
  mkdist "$i"
done

for i in build/static/css/*.css
do
  mkdist "$i"
done

cp build/static/css/*.map $dist_foldername
cp build/static/js/*.map $dist_foldername

echo "-----------------------------------------------------------------------------------"
echo "Copy this to your <head>:"
for i in $dist_foldername/*.css
do
  echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"$i\" />"
done
echo
echo "Copy this to your body after the div to embed the script on:"
for i in $dist_foldername/*.js
do
  echo "<script src=\"./$i\"></script>"
done
