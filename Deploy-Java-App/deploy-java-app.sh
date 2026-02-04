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
    echo "Installing OpenJDK and Maven..."
    sudo apt update
    sudo apt install -y openjdk-17-jdk maven

    echo "Building the project with Maven..."
    if [ -f pom.xml ]; then
        mvn clean package -DskipTests
    else
        echo "No pom.xml found"
        exit 1
    fi
}

function run_jar(){
    jar_file=$(find target -type f -name "*.jar" | head -n 1)
    if [ -z "$jar_file" ]; then
        echo "No JAR file found in target directory"
        exit 1
    fi

    echo "Running the JAR file..."
    nohup java -jar "$jar_file" > java-app.log 2>&1 &
    echo "✅ Java app started in background"
}

clone_repo
install_dependencies
run_jar
echo "Java app deployed!"