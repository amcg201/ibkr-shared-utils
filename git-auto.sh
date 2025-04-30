#!/bin/bash

# Move into your shared folder
cd "/Users/aaronmcgilligan/Documents/Trading Bots/Shared for IBKR" || exit

# Show Git status
echo "📄 Current Git status:"
git status
echo ""

# Ask user to confirm
read -p "✅ Proceed with committing and pushing all changes? (y/n): " confirm

if [[ $confirm == "y" || $confirm == "Y" ]]; then
    git add .

    echo "Enter your Git commit message:"
    read commit_message

    git commit -m "$commit_message"
    git push

    echo "✅ Shared folder pushed to GitHub successfully!"
else
    echo "❌ Cancelled. No changes were pushed."
fi

