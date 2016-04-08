+++
title = "Serving your resume over curl like a badass: Running a wopr server on an EC2 instance with Docker"
tags = [ "Docker", "node.js", "command line", "AWS", "EC2" ]
categories = [ "Development" ]
series = [ "Nerdery" ]
slug = "command-line-resume"
project_url = "https://github.com/soulshake/cv.soulshake.net"
summary = "Serving your resume over curl like a badass: Running a wopr server on an EC2 instance with Docker"
draft = "false"
date = "2016-04-03"

+++

## Requirements

- Docker ([how to install](https://docs.docker.com/engine/installation/))
- Docker Machine ([how to install](https://docs.docker.com/machine/install-machine/))
- the AWS CLI ([how to install](https://docs.aws.amazon.com/cli/latest/userguide/installing.html))
- An AWS account

### Optional

- A domain name


## How to

Clone this repo:

    $ git clone https://github.com/soulshake/cv.soulshake.net.git


Export AWS environment variables:

`````bash
export AWS_SECRET_ACCESS_KEY=your-key-here
export AWS_ACCESS_KEY_ID=your-key-id-here
export AWS_DEFAULT_REGION=your-aws-region-here
`````

By default, `machine` creates new instances in region `us-east-1`.


### Use docker-machine to create a host EC2 instance

    $ docker-machine create --driver amazonec2 aws-sandbox

    $ eval $(docker-machine env aws-sandbox)

    $ docker build -t soulshake/cv.soulshake.net .


### create a CNAME

#### Get your EC2 instance public DNS name

`````bash
aws ec2 describe-instances \
    --query  "Reservations[*].Instances[*].[{CNAME:PublicDnsName,SecurityGroups:SecurityGroups}]" \
    --output table
`````

#### And create a CNAME record with your domain provider

`````bash
gandi record create \
    --name cv \
    --type CNAME \
    --value ec2-52-58-37-111.eu-central-1.compute.amazonaws.com. \
    soulshake.net
`````

## add docker-machine to security group

You have two ways to do this:

### On the command line

`````bash
aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=docker-machine" \
    --output table

`````

### On the web interface

Log into the [EC2 console](https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#Instances:sort=publicIp) (make sure to select your region at the top right), then:

    - By "Security groups" click the "docker-machine" link
    - When the security group is selected, select the "Inbound" tab at the bottom
    - Click the "Edit" button
    - Click "Add Rule" --> All traffic --> All [protocol] --> Source: Anywhere 0.0.0.0/0 --> Save

## Run the container

`````bash
docker run -d -ti \
    --name cv.soulshake.net \
    --publish-all \
    -p 80:1337 \
    -p 1337:1337  \
    soulshake/cv.soulshake.net

`````

### Behold the magic!

`````bash
curl -N cv.soulshake.net:32769/\[0-2\]\?auto\&cols=$((COLUMNS))&rows=$((LINES))&terminal=${TERM}

curl -N cv.soulshake.net:32769/\[0-2\]\?cols=$((COLUMNS))&rows=$((ROWS))
`````


# Automated building

If you want to take it to the next level, you can set up hooks.

## Automated Docker hub builds

Log into your [Docker Hub](https://hub.docker.com) account and create a new Automated Build that will be triggered every time you push to your GitHub or BitBucket repo.

## Automated deployment of the newly built container on your EC2 instance

Then, using [conduit](https://github.com/ehazlett/conduit), you can set up your EC2 instance so the build triggers a new container to push your changes to production.

That command will look something like this:

`````bash
docker run -d \
    --name conduit \
    -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ehazlett/conduit \
    -r soulshake/cv.soulshake.net \
    -t YOUR_TOKEN_HERE

`````


