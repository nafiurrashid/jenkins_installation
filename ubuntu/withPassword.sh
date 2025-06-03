#!/bin/bash

set -e

echo "Updating package index..."
sudo apt update

echo "Installing Java (JDK 11)..."
sudo apt install -y openjdk-11-jdk

echo "Adding Jenkins GPG key and repository..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "Adding Jenkins apt repository..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Updating package index again..."
sudo apt update

echo "Installing Jenkins..."
sudo apt install -y jenkins

echo "Creating initial Groovy script to auto-create admin user..."

sudo mkdir -p /var/lib/jenkins/init.groovy.d

sudo tee /var/lib/jenkins/init.groovy.d/basic-security.groovy > /dev/null << 'EOF'
#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

println "--> creating local user 'admin'"

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "qwerty")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

instance.save()
EOF

echo "Setting ownership of Jenkins files..."
sudo chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d

echo "Enabling and starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl restart jenkins

echo "✅ Jenkins installation complete!"
echo "Access it at: http://<your-server-ip>:8080"
echo "Login with:"
echo "  Username: admin"
echo "  Password: qwerty"
