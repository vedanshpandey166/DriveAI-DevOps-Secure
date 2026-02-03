#!/bin/bash
set -e

echo "Starting DriveAI deployment..."

# Expect GROQ_API_KEY to be provided via .env
docker compose pull
docker compose up -d

echo "Deployment complete"
