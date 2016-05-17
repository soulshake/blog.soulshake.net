+++
date = "2016-03-30T15:00:00-07:00"
title = "Opening new i3 terminals in the same working directory"
author = "AJ Bowen"
description = "My simple solution."
draft = false
+++

I love [i3](https://i3wm.org/), and often have multiple split panes open when working on a project. I got tired of opening a new pane and having to `cd` to the directory I was in.

I came across a lot of proposed solutions, but they were all too complicated or didn't work. Here's my hack.

<!--more-->

Note: I use roxterm. YMMV with other terms.

### Step 1: Use bash's `PROMPT_COMMAND` to keep track of your current directory

Bash provides an environment variable called `PROMPT_COMMAND`. The contents of this variable are executed as a regular Bash command just before Bash displays a prompt. ([Source](http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x264.html))

Add this line to your `~/.bash_profile`:

    export PROMPT_COMMAND="pwd > /tmp/whereami"

Now, your current working directory will be written to `/tmp/whereami` every time you hit enter in a shell:

```
$ cat /tmp/whereami 
/home/aj/git/blog.soulshake.net/src/content/post
```


### Step 2: Create a tiny shell script 

In `$HOME/.i3/i3_shell.sh`:

    #!/bin/bash
    WHEREAMI=$(cat /tmp/whereami)
    i3-sensible-terminal --directory="$WHEREAMI"

This just opens a new terminal in the directory located in `/tmp/whereami`.

(`i3-sensible-terminal` evaluates to `$TERMINAL` which evaluates to `urxvt` in my case.)

### Step 3: Set up i3 bindsym to i3_shell.sh to open a new term

Add this line to your `~/.i3/config`:

    bindsym $mod+Return exec $HOME/.i3/i3_shell.sh

Reload i3 (`Ctrl+meta+R`). Now, new terminals should open in whatever directory you last pressed `enter` in.
<!--more-->
