# Push to GitHub - Quick Guide

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (e.g., "predict-and-win")
3. **DO NOT** initialize with README, .gitignore, or license (we already have these)
4. Copy the repository URL (e.g., `https://github.com/yourusername/predict-and-win.git`)

## Step 2: Add Remote and Push

Run these commands (replace `YOUR_USERNAME` and `REPO_NAME` with your actual values):

```bash
# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# Push to GitHub
git push -u origin main
```

## Alternative: Using SSH

If you prefer SSH:

```bash
git remote add origin git@github.com:YOUR_USERNAME/REPO_NAME.git
git push -u origin main
```

## After Pushing

Once pushed, your code will be on GitHub and the CI/CD pipeline will automatically run on pushes and pull requests!

