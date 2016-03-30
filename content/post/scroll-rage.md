+++
date = "2016-01-30T23:34:00-07:00"
title = "Inexplicable zooming after changing tabs in Chrome on Debian with i3"
author = "AJ Bowen"
description = "I had a problem that was driving me insane. Today I finally got around to fixing it."
draft = true
+++

Shortly after switching from OSX, I noticed that I would get unexpected (and extremely annoying) zooming after changing tabs in Chrome.

After a while, it became apparent that it would only happen when I had scrolled just before changing tabs with Ctrl Up/Down.

Steps to reproduce:

- scroll a bit in tab A (the faster the scroll, the longer the coast)
- change tabs 

After fooling around with xinput, xev, xserver-xorg-input-synaptics, xorg.conf, etc, I finally found `synclient`.

Running `synclient -l | grep -i coast` revealed the following settings for the Synaptics touchpad:


    CornerCoasting          = 0
    CoastingSpeed           = 20
    CoastingFriction        = 50

Changing CoastingSpeed to 0 disabled the smooth scrolling effect-thing completely. Any value higher than 0, and the behavior was still present.

Increasing `CoastingFriction` to 255 slowed down the scrolling effect enough so that the coasting would stop before I could change tabs.
    CoastingSpeed           = 10
    CoastingFriction        = 255
