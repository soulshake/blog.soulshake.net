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

I thought it would be an appropriate use of time to make my resume viewable on the command line.

<!--more-->


## Requirements

- Docker ([how to install](https://docs.docker.com/engine/installation/))
- A [Github](https://github.com/) account
- A [Docker Hub](https://hub.docker.com/) account
- A [Docker Cloud](https://cloud.docker.com/) account

### Optional

- A domain name


## How to

Fork [this repo](https://github.com/soulshake/cv.soulshake.net.git) and clone it to your machine.

### Create an automated build on Docker Hub

Log into your [Docker Hub](https://hub.docker.com) account and create a new Automated Build that will be triggered every time you push to your GitHub or BitBucket repo.

In your Docker Hub account, click the "Create" dropdown menu in the upper right and select "Automated build."

This is fairly straightforward, and you shouldn't need to change anything here. For more info, see [Automated Builds on Docker Hub](https://docs.docker.com/docker-hub/builds/).

### Launch a new node cluster

In your Docker Cloud dashboard, select the Nodes tab, then click the "Launch a new node cluster" button.

Create a 1-node cluster with a provider of your choice.

### Create a CNAME

Once the node has been created, you can get its URL from the Nodes tab. Create a CNAME with your domain provider to this address.

### Create a stack on Docker Cloud

In the "Stacks" tab, click the "Create Stack" button.

In my case, I called my stack `cv` (as in resume) and defined a service named `wopr` (as in the name of the software it's running on).

Here's the stackfile:

```
wopr:
  image: 'soulshake/cv.soulshake.net:latest'
  ports:
    - '1337'
```

Click the "Create Stack" button at the bottom. You'll be taken to the stack overview page, where you'll see a list of services associated with that stack (in our case, there's only one). Click the service name.

Currently the service has no containers. Before we deploy it, click the "Triggers" tab.

### Create a deployment trigger

Specify a trigger name like `autodeploy`, choose "Redeploy" from the dropdown menu, then click "Add."

A "New trigger created" popup will appear. Copy the URL that appears just under "Make a POST request to the following URL to call the trigger."

Go back to your `cv` repo in your Docker Hub account:

https://hub.docker.com/r/soulshake/cv.soulshake.net/

Select the "Webhooks" tab, and click the `+` to add a new webhook. Pick a name, then paste the URL you copied after creating the trigger for your stack.

You may need to manually trigger the first build, which you can do from the "Build Settings" tab in the Hub repo.

### Create a reverse proxy

Repeat the above steps to create an automated build-and-deploy for [aiguillage](https://github.com/soulshake/aiguillage). This is a fork of @jpetazzo's repo of a super simple reverse proxy using nginx.

The stackfile can be found in `docker-cloud.yml` and looks like this:

```
aiguillage:
  image: 'soulshake/aiguillage:latest'
  autoredeploy: true
  deployment_strategy: high_availability
  links:
    - 'hugo.blog:blog'
    - 'wopr.cv:cv'
  ports:
    - '80:80'
  tags:
    - nodecluster-name=soulshake-production
```

As you can see, this stack serves as a reverse proxy for both my wopr server (cv.soulshake.net) and my blog (you're looking at it).

#### Link the stacks

After you enter the Stackfile, click "Next: Environment variables." Select your wopr service from the "Link services" dropdown, then click the Add button.

Click Save.

### Deploy

Now go back to your Stacks tab, and click the green Start button next to each stack.

At this point, cv.soulshake.net resolves to 1b4cc34f-6039-4038-bce4-99c98bf1ec0b.node.dockerapp.io, and running `curl cv.soulshake.net` should serve up your resume in all its command-line glory. \o/
