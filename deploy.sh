#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "--- Git Status ---"
git status

echo ""
echo "Staging all changes..."
git add .

# Prompt user for commit message
echo -n "Enter commit message: "
read -r commit_msg

if [ -z "$commit_msg" ]; then
    echo "Error: Commit message cannot be empty."
    exit 1
fi

# Commit and Push
git commit -m "$commit_msg"
echo "Pushing to remote..."
git push

# Hosting Update
echo "Deploying index.html to /var/www/html/..."
sudo cp index.html /var/www/html/

# Access Report Generation
echo "Generating access report via GoAccess..."
sudo goaccess /var/log/nginx/access.log -o /var/www/html/report.html --log-format=COMBINED

echo ""
echo "------------------------------------------------"
echo "SUCCESS: Changes pushed, site updated, and report generated."
echo "Location: /var/www/html/index.html"
echo "Report: /var/www/html/report.html"
echo "------------------------------------------------"
