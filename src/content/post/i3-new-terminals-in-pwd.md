+++
date = "2016-03-30T15:00:00-07:00"
title = "Opening new i3 terminals in the same working directory"
author = "AJ Bowen"
description = "My simple solution."
draft = false
+++

I love i3, and often have multiple split panes open when working on a project. I was tired of opening a new pane and having to `cd` to the directory I was in.

<!--more-->

I came across a lot of proposed solutions, but they were all too complicated or didn't work. Here's my hack.

Note: I use roxterm. I doubt this will work with other terms.

### Use bash's `PROMPT_COMMAND` to keep track of your current directory

This will update `/tmp/whereami` every time you hit enter in a shell.

In my `~/.bash_profile`:

    export PROMPT_COMMAND="pwd > /tmp/whereami"


### Create a tiny shell script 

This just opens a new terminal (i3-sensible-terminal evaluates to $TERMINAL which evaluates to `urxvt` in my case) in the directory located in `/tmp/whereami`.

In `$HOME/.i3/i3_shell.sh`:

    #!/bin/bash
    WHEREAMI=$(cat /tmp/whereami)
    i3-sensible-terminal --directory="$WHEREAMI"


### i3 bindsym to open a new term

In my `~/.i3/config`:

    bindsym $mod+Return exec $HOME/.i3/i3_shell.sh

<!--more-->
