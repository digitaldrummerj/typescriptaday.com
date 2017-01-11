#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"
TARGET_DIR="_site"

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`



# Clone the existing gh-pages for this repo into out/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deply)
git clone $REPO _site
cd $TARGET_DIR
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
git config user.name "Travis CI"
git config user.email "cideploy@travisci.com"
cd ..

# Clean out existing contents
rm -rf $TARGET_DIR/**/* || exit 0

# Run our compile script
npm run build

# _config-dj.yml is to make everything work correctly as a folder under my CNAME.  Remove if running on typescriptaday.com
JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_config-dj.yml

# Now let's go have some fun with the cloned repo

cd $TARGET_DIR
# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add . --all
git commit -m "Deploy to GitHub Pages: ${SHA}. Travis build: $TRAVIS_BUILD_NUMBER"


# Now that we're all set up, we can push.
git push $SSH_REPO $TARGET_BRANCH

