#!/bin/bash

sh vimwiki/md_to_html.sh

current_branch=$(git symbolic-ref --short HEAD)

git add .
git commit -m 'deploy'
git push -u origin $current_branch

if git show-ref --verify --quiet refs/heads/gh-pages; then
    git checkout gh-pages
else
    git checkout -b gh-pages
fi

git rm -rf .

git checkout $current_branch -- vimwiki/src/md

git mv vimwiki/src/md/* .

git rm -rf vimwiki

touch .nojekyll

git add .
git commit -m "GitHub Pages 자동 배포 $(date)"
git push -f origin gh-pages

git checkout $current_branch