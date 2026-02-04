# .NET Application Deployment Scripts

This project contains a set of shell scripts for deploying and managing .NET applications. Below is a brief description of each script included in this project.

## Scripts Overview

### `deploy-dotnet-app.sh`
This script is responsible for deploying a .NET application. It includes commands to build the application, publish it, and start the application on a server. Ensure that your .NET application is ready for deployment before running this script.

### `install-ssl.sh`
This script installs SSL certificates to secure the .NET application. It includes commands to obtain certificates from a certificate authority and configure the web server (e.g., Nginx) to use them. Make sure you have the necessary permissions and access to the certificate authority.

### `nginx-setup.sh`
This script sets up Nginx as a reverse proxy for the .NET application. It includes commands to install Nginx, configure server blocks, and set up necessary routing. Ensure that Nginx is not already installed on your server before running this script.

## Prerequisites
- A server with a compatible operating system (e.g., Ubuntu, CentOS).
- .NET SDK installed on the server.
- Nginx installed (if not using the `nginx-setup.sh` script).
- Access to a certificate authority for SSL certificates.

## Usage
1. Clone this repository to your server.
2. Navigate to the `dotnet` directory.
3. Run the scripts in the following order:
   - `./install-ssl.sh` (if SSL is needed)
   - `./nginx-setup.sh` (if Nginx is not already set up)
   - `./deploy-dotnet-app.sh` to deploy your application.

Make sure to review and modify the scripts as necessary to fit your specific deployment environment and application requirements.