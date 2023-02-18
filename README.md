CI/CD Automation Pipeline using GitHub Actions
This repository contains an example of how to set up a CI/CD automation pipeline for multiple GitHub repositories using GitHub Actions.

Docker Compose File
The docker-compose.yml file contains the Docker commands to create images of multiple code repositories. You can modify the build section for each service to point to the respective repositories and Dockerfile locations

Deployment Record
To keep a record for each deployment, this pipeline adds a new record entry in a Google Sheet or any database table with the following information:

Start date/time
Service name
Completed date/time
Status
You can modify the record-deployment.sh script to use a different method for keeping a record of each deployment.

Deployment Orchestration
The main.yml file in the .github/workflows directory contains the deployment orchestration using GitHub Actions. It defines the workflow for the following tasks:

Build and push Docker images for each service to Docker Hub
Deploy the services using the Docker Compose file
Record the deployment information in a Google Sheet or any database table
You can modify the workflow to fit your specific needs..
