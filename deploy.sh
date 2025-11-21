#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/sj5384763/hosting"
VENV_DIR="$APP_DIR/venv"

# ensure repo is present and up-to-date
if [ ! -d "$APP_DIR" ]; then
  mkdir -p "$(dirname "$APP_DIR")"
  git clone https://github.com/Venu5198/hosting.git "$APP_DIR"
fi

cd "$APP_DIR"
git fetch --all
git reset --hard origin/main

# create venv if missing
if [ ! -d "$VENV_DIR" ]; then
  python3 -m venv "$VENV_DIR"
fi

# install dependencies
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install -r requirements.txt

# reload systemd service
sudo systemctl daemon-reload
sudo systemctl restart backend || sudo systemctl start backend
