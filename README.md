

Git:

# 1. Initialize a new Git repository
git init

# 2. Add all files to staging
git add .

# 3. Commit the files
git commit -m "Initial commit"

# 4. Rename the default branch to main (if needed)
git branch -M Master

# 5. Add the GitHub remote  
# Replace 'yourusername' and 'yourrepo' with your actual GitHub username and repository name.
# Note: The URL below includes your personal access token for authentication.
git remote add origin https://ghp_Th6sx725i@github.com/rhoumajeder/springjava.git

# 6. Push your commit to GitHub (you may be prompted for credentials or it will use your token)
git push -u origin Master
