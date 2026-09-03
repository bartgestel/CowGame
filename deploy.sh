#!/usr/bin/env bash
# Run this on the VPS, from the project directory (/opt/cowgame), after
# copying over updated files (rsync/git pull) — rebuilds the image and
# replaces the running container.
set -euo pipefail

IMAGE=cowgame
CONTAINER=cowgame
NETWORK=proxy-net

echo "Building image..."
docker build -t "$IMAGE" .

if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  echo "Stopping and removing existing container..."
  docker stop "$CONTAINER" >/dev/null
  docker rm "$CONTAINER" >/dev/null
fi

echo "Starting container on network '$NETWORK'..."
docker run -d --name "$CONTAINER" --restart unless-stopped --network "$NETWORK" "$IMAGE"

echo "Done. Container status:"
docker ps --filter "name=$CONTAINER"
