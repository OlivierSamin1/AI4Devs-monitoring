#!/bin/bash

# Make sure we have a backup of the repo
echo "Creating a backup of your repository..."
cd ..
cp -r AI4Devs-monitoring AI4Devs-monitoring-backup
cd AI4Devs-monitoring

# Remove the sensitive file from Git history
echo "Removing sensitive files from Git history..."
git filter-repo --path tf/correct-access-key.sh --invert-paths

# Make sure the file is deleted locally
rm -f tf/correct-access-key.sh

echo "Git history has been cleaned."
echo ""
echo "IMPORTANT: Next steps:"
echo "1. You need to force push to update the remote repository:"
echo "   git push -f origin monitoring-OS"
echo ""
echo "2. Anyone else using this repository needs to clone it again or run:"
echo "   git fetch origin"
echo "   git reset --hard origin/monitoring-OS"
echo ""
echo "3. Make sure to update your AWS credentials by rotating them in the AWS console"
echo "   since the old ones are now compromised." 