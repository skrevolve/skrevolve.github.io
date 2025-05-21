#!/bin/bash

# Vimwiki HTML 생성
sh vimwiki/md_to_html.sh

# 현재 브랜치 이름 저장
current_branch=$(git symbolic-ref --short HEAD)

# 메인 브랜치 변경사항 커밋 및 푸시
git add .
git commit -m 'deploy'
git push -u origin $current_branch

# 현재 변경사항 저장
echo "메인 브랜치 업데이트 완료, GitHub Pages 배포 시작..."

# gh-pages 브랜치로 전환 (없으면 생성)
if git show-ref --verify --quiet refs/heads/gh-pages; then
    git checkout gh-pages
else
    git checkout -b gh-pages
fi

# 브랜치 초기화 (모든 파일 제거)
git rm -rf .

# vimwiki/src/html 디렉토리 내용 복구
git checkout $current_branch -- vimwiki/src/html

# 내용을 루트 디렉토리로 이동
git mv vimwiki/src/html/* .

# 빈 디렉토리 제거
git rm -rf vimwiki

# Jekyll 비활성화 (선택사항)
touch .nojekyll

# GitHub Pages 브랜치 커밋 및 푸시
git add .
git commit -m "GitHub Pages 자동 배포 $(date)"
git push -f origin gh-pages

# 원래 브랜치로 돌아가기
git checkout $current_branch

echo "GitHub Pages 배포 완료! 몇 분 내에 사이트가 업데이트됩니다."