
name: Build & Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Install dependencies and restart app
        run: |
          cd ${{github.workspace}}
          npm install
          npx pm2 restart src/app.js
        env:
          PM2_HOME: ${{github.workspace}}/.pm2

      - name: SSH into theserver and deploy
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{secrets.SERVER_IP}}
          username: ${{secrets.SERVER_USERNAME}}
          key: ${{secrets.SSH_PRIVATE_KEY}}
          script: |
            cd /home/runner/work/digital-ocean-cicd/digital-ocean-cicd/
            git pull origin main 
            npm install 
            pm2 restart src/app.js 