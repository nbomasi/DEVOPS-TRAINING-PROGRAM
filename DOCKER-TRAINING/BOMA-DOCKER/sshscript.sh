#!/bin/bash

if [ $1 = 1 ]; then
  ssh -i "D:\bomasi.pem" ubuntu@ec2-54-160-87-195.compute-1.amazonaws.com
elif [ $1 = 2 ]; then
  ssh -i "D:\bomasi.pem" ubuntu@ec2-3-237-179-222.compute-1.amazonaws.com
elif [ $1 = 3 ]; then
  ssh -i "D:\bomasi.pem" ubuntu@ec2-44-203-241-192.compute-1.amazonaws.com
fi

  