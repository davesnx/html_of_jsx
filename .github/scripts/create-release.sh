#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.0"
    exit 1
fi

VERSION=$1

echo "Creating tag $VERSION..."
git tag -a "$VERSION" -m "Release version $VERSION"

echo "Pushing tag to GitHub..."
git push origin "$VERSION"

echo ""
echo "✅ Tag $VERSION pushed successfully!"
echo ""
