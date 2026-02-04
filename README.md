# ⚙️ DevOps Bash Automation Scripts

Welcome to the **Daily DevOps Scripts** — a structured collection of modular scripts to help you **automate** and **accelerate** your day-to-day DevOps workflows. From app **deployment** to **server setup**, **reverse-proxy** and **SSL configuration**, each script is ready to save you time and effort.


## 🚀 What's Available

### 📁 `Deploy-react-app/`

| Script               | Description                                                                |
|----------------------|----------------------------------------------------------------------------|
| `deploy-react.sh`    | Clones and deploys a React.js app using PM2                                |
| `nginx-setup.sh`     | Installs and configures Nginx as a reverse proxy for React                 |
| `install-ssl.sh`     | Installs SSL (Let's Encrypt) for your domain using Certbot + Nginx plugin  |

### 📁 `Docker-apps/`



| Script               | Description                                                                |
|----------------------|----------------------------------------------------------------------------|
| `deploy-docker-app.sh`    | Clones and deploys a Docker-based application using Docker or Docker Compose                                |
| `nginx-setup.sh`     | Installs and configures Nginx as a reverse proxy for the running Docker app                |
| `install-ssl.sh`     | Installs SSL (Let's Encrypt) for your Docker app domain using Certbot + Nginx  |

### 📁 `Node-backends/`


| Script               | Description                                                                |
|----------------------|----------------------------------------------------------------------------|
| `deploy_node_app.sh`    | Clones and deploys a Node.js app using PM2                                |
| `nginx-setup.sh`     | Installs and configures Nginx as a reverse proxy for Node                 |
| `install-ssl.sh`     | Installs SSL (Let's Encrypt) for your domain using Certbot + Nginx plugin  |

### 📁 `Deploy Wordpress Site/`

| Script              | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `deploy-wordpress.sh` | Installs WordPress along with Apache, MySQL, PHP, and sets up wp-config     |
| `apache-setup.sh`     | Configures Apache virtual host for the WordPress domain                     |
| `install-ssl.sh`      | Installs SSL (Let's Encrypt) for your WordPress site using Certbot + Apache |

### 📁 `Python-scripts/`

| Script               | Description                                                                       |
|----------------------|-----------------------------------------------------------------------------------|
| `deploy-python-app.sh` | Clones and deploys a Python (Flask/FastAPI) app using Gunicorn and virtual-env    |
| `nginx-setup.sh`     | Installs and configures Nginx as a reverse proxy to Gunicorn                      |
| `install-ssl.sh`     | Installs SSL (Let's Encrypt) for your domain using Certbot + Nginx plugin         |


### 📁 `Dotnet-app/`

| Script               | Description                                                                       |
|----------------------|-----------------------------------------------------------------------------------|
| `deploy-dotnet-app.sh` | Clones and deploys a Dotnet app using nohup    |
| `nginx-setup.sh`     | Installs and configures Nginx as a reverse proxy                      |
| `install-ssl.sh`     | Installs SSL (Let's Encrypt) for your domain using Certbot + Nginx plugin         |

### 📁 `Java-apps/`

| Script               | Description                                                                       |
|----------------------|-----------------------------------------------------------------------------------|
| `deploy-java-app.sh` | Clones and deploys a Java app using nohup    |
| `nginx-setup.sh`     | Installs and configures Nginx as a reverse proxy                      |
| `install-ssl.sh`     | Installs SSL (Let's Encrypt) for your domain using Certbot + Nginx plugin         |

---

## 🧑‍💻 How to Use

```bash
# Clone the repository
git clone https://github.com/thatdevopsengineer/daily-devops-scripts.git
cd daily-devops-scripts

# Navigate to the folder you need
cd Deploy-React-app

# Make scripts executable
chmod +x *.sh

# Run the required script
./deploy-react.sh
./nginx-setup.sh
./install-ssl.sh

```

## Contributing
If you'd like to contribute to this project, please open an **issue** or submit a **pull request**.
Give it a **Star** if you liked it!

## Contributer
<a href = "https://thatdevopsengineer.com/">
  <img src = "https://contrib.rocks/image?repo=thatdevopsengineer/daily-devops-scripts"/>
</a>
