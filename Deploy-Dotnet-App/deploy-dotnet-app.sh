#!/bin/bash
set -e

function clone_repo(){
    echo "Cloning the repo..."
    read -p "Enter the Github URL: " github_url

    repo_name=$(basename -s .git "$github_url")

    if git clone "$github_url"; then
        echo "✅ Repo cloned: $repo_name"
        cd "$repo_name" || { echo "Failed to cd into repo"; exit 1; }
    else
        echo "Git clone failed"
        exit 1
    fi
}

function install_dependencies(){
    echo "Installing .NET SDK..."
    wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y apt-transport-https
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-8.0

    echo "Restoring project dependencies..."
    if [ -f *.csproj ]; then
        dotnet restore
    else
        echo "No .csproj file found"
        exit 1
    fi
}

function build_and_run(){
    echo "Building the project..."
    dotnet build --configuration Release

    echo "Running the application..."
    nohup dotnet run --configuration Release --urls "http://127.0.0.1:5000" > dotnet-app.log 2>&1 &
    echo "✅ .NET app started on 127.0.0.1:5000"
}

clone_repo
install_dependencies
build_and_run
echo ".NET app deployed!"