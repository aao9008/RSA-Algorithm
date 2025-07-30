# 👥 Team Collaboration Guide (GitHub Workflow)

This document outlines how we will collaborate on this RSA project using Git and GitHub.

---

## Step 1: Accept Invite as Collaborator

1. Check your GitHub notifications or email for an invite to this repository.
2. Accept the invitation so you can push directly to this repo.

## Step 2: Clone the Repository

Use this command to download the project to your local machine:

```bash
git clone https://github.com/aao9008/RSA-Algorithm.git
cd rsa-project
```

## Step 3: Create a New Branch for Your Work

Before coding, create your own branch so we don’t conflict with each other’s work:

```bash
git checkout -b add-your-feature-name
```
Example: 

```bash
git checkout -b add-gcd-function
```
## Step 4: Work on Your Assigned Function

Make your changes in your branch. Use clear commit messages when saving:

```bash
git add .
git commit -m "Implement gcd function"
```
## Step 5: Push Your Branch to Github

```bash
git push origin add-your-feature-name
```

## Step 6: Open a Pull request

1. Go to the GitHub repo in your browser

2. Click the "Compare & pull request" button

3. Make sure:

    - Base branch = main

    - Compare branch = your branch (e.g., add-gcd-function)

4. Add a clear description of your changes

5. Click "Create pull request"

## Step 7: Merge (Repo Owner Only)

Once reviewed and approved by group, the repo owner will:
    
- Merge the pull request

- Delete the feature branch on GitHub

## Notes

- Always create a new branch for each task or feature.

- Do not push directly to the main branch.

- Pull frequently from main to stay up to date:

    ``` bash
    git checkout main
    git pull origin main
    ```

> 🛡️ **Branch Safety Tip:**
  
Before starting your work, make sure you're on your own branch using:

```bash
git branch
```

If it shows main with an asterisk (*), create and/or switch to your feature branch:

**Create and Switch Branch**

```bash
git checkout -b your-branch-name
```

**Switch to Existing Branch**

```bash
git checkout your-branch-name
```
### Learn more about Git and branches here:

- [Interactive Git Practice](https://learngitbranching.js.org/)

- [GitHub Branching Guide](https://docs.github.com/en/get-started/using-github/github-flow#branching)

- [Git Basics](https://www.theodinproject.com/paths/foundations/courses/foundations#git-basics)