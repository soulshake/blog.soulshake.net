+++
date = "2016-02-30"
title = "Weird zooming after changing tabs in Chromium on Debian with i3"
author = "AJ Bowen"
description = "Shortly after switching from OSX, I noticed that I would get unexpected (and extremely annoying) zooming after changing tabs in Chrome."
tags = [ "Chrome", "Debian" ]
draft = false
+++

Shortly after switching from OSX, I noticed that I would get unexpected (and extremely annoying) zooming after changing tabs in Chrome.

<!--more-->

After a while, it became apparent that it only happened when I had scrolled up or down just before changing tabs with Ctrl Up/Down.

In other words, the steps to reproduce were:

- scroll a bit in tab A (the faster the scroll, the longer the coast)
- while tab A is still coasting, change tabs to tab B

The result is if you had pressed `ctrl+=` or `ctrl+-` a bunch of times.

After fooling around with `xinput`, `xev`, `xserver-xorg-input-synaptics`, `xorg.conf`, etc, I realized the scrolling/coasting action was being interpreted as keypresses even after changing contexts.

The solution:

    $ sudo apt-get install xserver-xorg-input-synaptics

This package provides `synclient`, a commandline utility to query and modify Synaptics driver options.

The culprit was the default settings for the Synaptics touchpad:


    $ synclient -l | grep -i coast
    CornerCoasting          = 0
    CoastingSpeed           = 20
    CoastingFriction        = 50

I played with the settings until I found a combination that allowed a reasonable amount of coasting.

Changing CoastingSpeed to 0 disabled the smooth scrolling effect-thing completely. Any value higher than 0, and the behavior was still present.

Increasing `CoastingFriction` to 255 slowed down the scrolling effect enough so that the coasting would stop before I could change tabs.

## TL;DR

Install `xserver-xorg-input-synaptics` and add the following lines to your profile:

    CoastingSpeed           = 10
    CoastingFriction        = 255

Ahh, much better.

<!--more-->
