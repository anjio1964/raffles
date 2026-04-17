#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "--- Git Status ---"
git status

echo ""
if git diff-index --quiet HEAD --; then
    echo "No changes to commit, skipping git push."
else
    echo "Staging all changes..."
    git add .
    echo -n "Enter commit message: "
    read -r commit_msg
    if [ -z "$commit_msg" ]; then
        echo "Error: Commit message cannot be empty."
        exit 1
    fi
    git commit -m "$commit_msg"
    echo "Pushing to remote..."
    git push
fi

# Hosting Update
echo "Deploying index.html to /var/www/html/..."
sudo cp index.html /var/www/html/

# Access Report Generation
echo "Generating access report via GoAccess..."
sudo goaccess /var/log/nginx/access.log -o /var/www/html/report.html --log-format=COMBINED

echo ""
echo "================================================================"
echo "🚀 DEPLOYMENT COMPLETE"
echo "================================================================"
echo "✅ Changes pushed to Git"
echo "✅ index.html deployed to /var/www/html/"
echo "✅ Access report generated at /var/www/html/report.html"
echo ""
echo "🌐 LIVE URLS:"
echo "   Main Site:   https://raffles.345321.xyz/"
echo "   Analytics:   https://raffles.345321.xyz/report.html"
echo "================================================================"
