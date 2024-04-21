#!/bin/bash
sudo yum install -y python3-pip
pip install --upgrade pip
pip install flask pysentimiento
git clone https://github.com/tristanff/Sentimental-Analysis || {
  cd Sentimental-Analysis
  git pull
  cd Compute
}
python3 server.py