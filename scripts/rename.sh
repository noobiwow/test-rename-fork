#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="$1"
PLACEHOLDER="__REPO_NAME__"

echo "================================================"
echo " Initializing repository: $REPO_NAME"
echo "================================================"

# 1. Renommer les fichiers dont le nom contient le placeholder
echo ""
echo "→ Renaming files..."
find . \
  -not -path './.git/*' \
  -not -path './scripts/*' \
  -name "*${PLACEHOLDER}*" | while read -r file; do
    new_name="${file//$PLACEHOLDER/$REPO_NAME}"
    mkdir -p "$(dirname "$new_name")"
    mv "$file" "$new_name"
    echo "   [renamed] $file → $new_name"
done

# 2. Remplacer le placeholder dans le contenu des fichiers
echo ""
echo "→ Replacing placeholders in file contents..."
grep -rl "$PLACEHOLDER" . \
  --exclude-dir='.git' | while read -r file; do
    sed -i "s/${PLACEHOLDER}/${REPO_NAME}/g" "$file"
    echo "   [updated] $file"
done

echo ""
echo "✓ Done."
