#!/bin/bash
sudo apt update
sudo echo "install dotnet"
sudo apt install -y aspnetcore-runtime-8.0
sudo apt install -y dotnet-sdk-8.0

#install git
sudo echo "install git"
sudo apt install git
sudo apt install unzip

#install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
./aws/install
aws --version

#configure git
sudo sudo -u ubuntu git config --global credential.helper '!aws codecommit credential-helper $@'
sudo sudo -u ubuntu git config --global credential.UseHttpPath true


#clone repo from code commit
cd /home/ubuntu
echo "git clone"
sudo -u ubuntu git clone https://github.com/hamedahmed100/srv-02.git
cd srv-02

#build the dot net service
echo "dotnet build"
echo 'DOTNET_CLI_HOME=/temp' | sudo tee -a /etc/environment
export DOTNET_CLI_HOME=/temp
sudo dotnet publish -c Release --self-contained=false --runtime linux-x64


sudo tee /etc/systemd/system/srv-02.service > /dev/null <<EOL
[Unit]
Description=Dotnet S3 info service

[Service]
ExecStart=/usr/bin/dotnet /home/ubuntu/srv-02/bin/Release/net8.0/linux-x64/srv02.dll
SyslogIdentifier=srv-02

Environment=DOTNET_CLI_HOME=/temp

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload

#run it
sudo systemctl start srv-02

# Check the service status
sudo systemctl status srv-02
# Check the service logs
sudo journalctl -f -u srv-02