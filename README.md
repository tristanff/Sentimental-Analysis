# Sentimental-Analysis

Install AWS-CLI on EC2 Linux 

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


aws configure
(dejar None para todo los parametros)
nano .aws/credientals
past the credientials from https://labs.vocareum.com/main/main AWS Details
nano .aws/config 
[default]
region = us-east-1

Test connection : aws dynamodb list-tables 
