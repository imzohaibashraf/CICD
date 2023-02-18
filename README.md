CI/CD Automation Pipeline using GitHub Actions
This repository contains an example of how to set up a CI/CD automation pipeline for multiple GitHub repositories using GitHub Actions.

Docker Compose File
The docker-compose.yml file contains the Docker commands to create images of multiple code repositories. You can modify the build section for each service to point to the respective repositories and Dockerfile locations.

yaml
Copy code
version: '3.8'

services:
  service1:
    build:
      context: ./service1
    image: your-docker-hub-username/service1
    restart: always
    ports:
      - "8080:8080"

  service2:
    build:
      context: ./service2
    image: your-docker-hub-username/service2
    restart: always
    ports:
      - "8081:8081"
Step 2: Create Github Actions Workflow
In each of the repositories for the services that will be deployed, create a .github/workflows directory.
Create a new YAML file in this directory, such as deploy.yml.
In the YAML file, define a Github Actions workflow that will build and push the Docker image to Docker Hub.
name: Deploy Service
on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Login to Docker Hub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v2
        with:
          context: .
          push: true
          tags: your-docker-hub-username/${{ github.repository }}:latest

      - name: Notify deployment repository
        uses: wei/git-push@v1
        with:
          directory: ../deployment-repository
          repository: deployment-repository
          branch: main
          commit_message: "Update deployment"
This workflow is triggered when a push is made to the main branch of the repository. It checks out the code, logs in to Docker Hub, builds and pushes the Docker image to Docker Hub, and then notifies the deployment repository of the change.

Note that we are using secrets to store the Docker Hub username and password. These secrets can be added to the repository by going to the repository settings and clicking on "Secrets".
Step 3: Record Deployment Information
To record deployment information, we can use a Google Sheet or any database table. For this example, we will use a Google Sheet to store the deployment records.

Create a new Google Sheet and name it "Deployment Records".
In the first row of the sheet, add the following column headings: "Start Time", "Service Name", "Completed Time", "Status".
In the deployment repository, create a new script file named record-deployment.sh to record the deployment information.
The script should look something like this:
#!/bin/bash

# Record start time
start_time=$(date "+%Y-%m-%d %H:%M:%S")

# Deploy services
docker-compose -f docker-compose.yml up -d

# Record completed time and status
if [ $? -eq 0 ]; then
  completed_time=$(date "+%Y-%m-%d %H:%M:%S")
  status="Success"
else
  completed_time=""
  status="Failure"
fi

# Add deployment record to Google Sheet
curl -X POST -H "Content-Type: application/json" -d '{
  "values": [
    ["'$start_time'", "Service Name", "'$completed_time'", "'$status'"]
  ]
}' "https://sheets.googleapis.com/v4/spreadsheets/<spreadsheet-id>/values/A2:append?valueInputOption=USER_ENTERED&insertDataOption=INSERT_ROWS&access_token=<access-token>"

Note that you will need to replace <spreadsheet-id> and <access-token> with the appropriate values for your Google Sheet. You can get these values by following the instructions on the Google Sheets API documentation.

Step 4: Trigger Deployment and Record Information

In the deployment repository, create a new Github Actions workflow named deploy.yml.
In the workflow, define the steps to trigger the deployment and record the information.

