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
- Test the compute server by sending the following http request
```bash
  curl -X POST -H "Content-Type: application/json" -d '[{"sentiment": "neutral", "text": "#2Abril Van 37 días de invasión rusa en #Ucrania, 37 días de guerra, destrucción, dolor, desplazados, muerte, y tod… https://t.co/e2DcggQgpL", "user": "PioVona", "subject": "StopTheWar"}, {"sentiment": "positive", "text": "#Anonymous, guys, it would be nice to make the locations of the #Russian #Navy open. How do you like this idea?… https://t.co/Q0AT14BpHx", "user": "ComicsGram", "subject": "russian navy"}, {"sentiment": "negative", "text": "#BREAKING #Anonymous hacks Russian Orthodox Church & Lipetsk Company.\n\n#Russia #RussianArmy\n#RussiaUkraineConflict… https://t.co/VS8LB8j5jx", "user": "Internl_Leaks", "subject": "russianarmy"}]' http://{EC2-PublicIP}:5000/analyze_tweets
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


### Test the the BackEnd Server
```
curl -X GET "http://{InstanceIP}/user?username=LMaledetta"
```

## Test the infra
```
curl -X GET "http://{BackEnd-PublicIP}:5000/analysis?word=ukraine"
```

## Create DB
Create a new DynamoDb called tweets-raw with PK id and SK subject and let it empty.
## Configure API and Lambdas
1.) Create all lambdas functions and copy paste the code you will find in lambdas for all 4 functions
2.) Create and API Gateway with every endpoint u can find in postman collections
3.) Associate the endpoints with lambdas
4.) Import the postman_collection to PostMan test to : add a tweet , get raw_tweets and copy the response body, paste it into to the update_db body and verify that the tweets were deleted from tweets-raw db and added tweets-processed.

## Configure Compute Task Running

### 2.) Build the image and Config container Registry

In order to give our cluster a base Image that will be used to compute the data and make the analysis we need to build an Image using docker , and store it on container Registry.

## A) Create container Registry

In ECR Service on AWS Console , create the container registry _sentimental-analysis_

## B) Build and push Image 
Configure aws cli on your local machine so it has access to the lab (see Configure AWS CLI part)

In the DockerFile change API_URL env variable with ur own api endpoint url.

In ECR Service , click on view push commands.

On your local machine , go the driectory where our Dockerfile is stored and copy past all commands

( Building and pushing the image will take a long time , have a coffee)

Verify that the image is in the repository

## 2.) Create Cluster and configure tasks 

Create a cluster

Create a task defintion with Fargate , LabRole, 4 CPUs and 8Gb of memory. Copy paste the IMAGE URI your ECR and save.

Using Postman add new tweets to the DB so you can test the task.

Go to your clusters , tasks, run new task and in family choose the task definition u created.

Check in tweets in tweets-raw db were moved to tweets-processed.

# Terraform

The labrole arn needs to be changed for everybody





