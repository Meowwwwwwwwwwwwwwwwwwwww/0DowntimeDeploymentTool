#!/bin/bash

URL=$1
echo "🩺 Checking health of $URL..."

if curl --fail --silent "$URL" > /dev/null; then
  echo "✅ Health check passed."
  exit 0
else
  echo "❌ Health check failed!"
  exit 1
fi
