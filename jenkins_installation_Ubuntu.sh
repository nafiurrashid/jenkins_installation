#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Step 1: Updating package list..."
sudo apt update

echo "Step 2: Installing Java (OpenJDK 21)..."
sudo apt install -y fontconfig openjdk-21-jre

echo "Checking Java version..."
java -version

echo "Step 3: Adding Jenkins GPG key..."
# Create the keyrings directory if it doesn't exist
sudo mkdir -p /etc/apt/keyrings

# Download and save Jenkins key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "Step 4: Adding Jenkins repository to APT sources..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Step 5: Updating package list after adding Jenkins repo..."
sudo apt update

echo "Step 6: Installing Jenkins..."
sudo apt install -y jenkins

echo "Step 7: Enabling Jenkins to start on system boot..."
sudo systemctl enable jenkins

echo "Step 8: Starting Jenkins service..."
sudo systemctl start jenkins

echo "Step 9: Checking Jenkins service status..."
systemctl status jenkins --no-pager

echo ""
echo " Jenkins installation is complete!"echo "👉 Visit http://localhost:8080 to access Jenkins."
echo "############################################"
echo " Here is your initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "############################################"


