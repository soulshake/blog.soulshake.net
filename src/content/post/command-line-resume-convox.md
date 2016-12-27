+++
title = "Serving your resume over curl like a badass, v2"
tags = [ "Docker", "node.js", "command line", "nginx", "GitHub", "Convox"]
categories = [ "Development" ]
series = [ "Nerdery" ]
slug = "command-line-resume-with-convox"
project_url = "https://github.com/soulshake/cv.soulshake.net"
summary = "Running a wopr server with an automated deployment workflow with Docker, GitHub and Convox"
draft = "false"
date = "2016-12-26"

+++

I found a much simpler deployment workflow for my command line resume.

<!--more-->

## Requirements

- Docker ([how to install](https://docs.docker.com/engine/installation/))
- A [Github](https://github.com/) account
- <strike>A [Docker Hub](https://hub.docker.com/) account</strike>
- <strike>A [Docker Cloud](https://cloud.docker.com/) account</strike>
- Convox

### Optional

- A domain name

## How to

Fork [this repo](https://github.com/soulshake/cv.soulshake.net.git) and clone it to your machine.

### Run `convox start`

### Set up Convox

- Install a Rack
- Create a Convox app
- Run `convox deploy`


### Create a workflow

### Create a CNAME

Once the Rack has been created, you can get its URL from the AWS console. Create a CNAME with your domain provider to this address.

