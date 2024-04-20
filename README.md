# Configure EC2
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo yum install git
sudo yum install pip
pip install flask
pip install boto3
```

# Configure AWS-CLI
```
aws configure
```
Leave None for all parameters
```
nano .aws/credentials
```
Paste the credentials from https://labs.vocareum.com/main/main AWS Details
```
nano .aws/config
```
Add the following lines
```
[default]
region = us-east-1
```

Test connection
```
aws dynamodb list-tables
```

-> Edit the security group of the instance to allow Custom TCP on Port 5000 from anywhere

## Start Server
```
git clone https://github.com/tristanff/Sentimental-Analysis
cd Sentimental-Analysis/Back-End
python3 server.py
```

## Test the server
```
curl -X GET "http://{InstanceIP}/user?username=LMaledetta"
```
