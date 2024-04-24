# Steps To Deploy the Architecture
## Create the DynamoDB
- Create a S3 bucket 
- upload the file merged_data.csv that you will find on this repo
- In DynamoDB use import from S3 feature , from CSV , let the default parameters for import and put subject as primary key
- The table name should be : tweet-politics

### Create AMI Compute Custom Image

In order to create our AMI Image with all dependecies we need to deploy an EC2 instance.

To do that :
- Spawn an EC2 t3.large ( for internet speed) with 20 GB of storage with public IP so you can connect with SSH
- Run the following commands :
```bash
sudo yum install -y python3-pip
sudo yum install git
pip install --upgrade pip
pip install flask
pip install pysentimiento
git clone https://github.com/tristanff/Sentimental-Analysis
```
- On EC2 Console , click on the Instance , go to Actions , create Image
- Verify that the Image has been correctly genererated.
## Create Load Balancer with Auto Scalling Groups using Spot Instances 
Follow this tutorial : https://aws.amazon.com/fr/tutorials/ec2-auto-scaling-spot-instances/
- Choose your own AMI Image that we just made as AMI in Launch Template
- In User Data section put the following code
```bash
#!/bin/bash
sudo -u ec2-user /bin/bash << 'EOF'
cd /home/ec2-user/Sentimental-Analysis/Compute
python3 server.py
EOF
```
- Set the Load Balancer Redirect HTTP traffic from port 80 to port 5000 
- You can change Healthy checks to check on /analyze_tweets and wait for 405 response
- In Auto Scaling group set the instance type of c5a.large




## Configure EC2 Back End
-Deploy an EC2 instance Amazon Linux with public address IP of type t2.micro
- Connect to ssh
### Install all dependecies
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo yum install git
sudo yum install pip
pip install flask
pip install boto3
git clone https://github.com/tristanff/Sentimental-Analysis
```

### Configure AWS-CLI
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
### Change the dns name of Load Balancer :
- In /Back-End server.py , change localy the line 83
  ```
  analyze_endpoint = "http://internal-Compute-Load-Balancer-1877743732.us-east-1.elb.amazonaws.com/analyze_tweets"
  ```
with the endpoint of your Load Balancer DNS name
### Start Server
```
cd Sentimental-Analysis/Back-End
python3 server.py
```
You might need to change manually in the code the dns name of the load balancer

### Test the the BackEnd Server
```
curl -X GET "http://{InstanceIP}/user?username=LMaledetta"
```

## Test the infra
```
curl -X GET "http://{BackEnd-PublicIP}:5000/analysis?word=ukraine"
```



