#!/bin/bash
for dir in `find -type d -empty`; do
   echo "*\n!.gitignore" > ${dir}/.gitignore
   git add ${dir}/.gitignore
done
