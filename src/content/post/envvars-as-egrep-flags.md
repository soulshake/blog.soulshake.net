+++
title = "Storing command line flags as environment variables"
summary = "Storing a flag like --foo={a,b,c} in an environment variable is complicated."
tags = [ "bash" ]
categories = [ "Development" ]
draft = "false"
date = "2017-01-12T15:00:00-07:00"
+++

When searching through our [site repo](https://github.com/convox/site), I find myself frequently excluding the same directories, due to my search results being flooded by maddeningly long ugly lines of CSS, javascript and other pointless crap:

<!--more-->

```
egrep -ri SomeSearchTerm \
  --exclude-dir=assets
  --exclude-dir=_site \
  --exclude-dir=vendor \
  ./*
```

I found that I was able to shorten this considerably by excluding multiple directories at the same time:

`$ egrep -ri SomeSearchTerm --exclude-dir={assets,_site,vendor} ./*`

But I still got tired of typing that over and over, so I thought I'd export it as an environment variable:

`$ export EXCLUDE_DIRS="--exclude-dir={assets,_site,vendor}"`

To my surprise, it didn't work, but the reason it didn't work turned out to be pretty interesting.

This gives me the results I want (excluding search results from the `assets`, `_site` and `vendor` directories):

`$ egrep -r SearchTerm --exclude-dir={assets,_site,vendor} ./*`

Lo, to my confusion, this does not:

```
$ export EXCLUDE_DIRS="--exclude-dir={assets,_site,vendor}"
$ egrep -r SearchTerm $EXCLUDE_DIRS ./
```

## Why doesn't it work?!

Behold:

```
$ echo --exclude-dir={a,b,c}
--exclude-dir=a --exclude-dir=b --exclude-dir=c
```

Smart right? The shell performs brace expansion on `{a,b,c}`. Except it only does this when passed directly, not when it's stored as an environment variable. Foiled!

## eval $() to the rescue

The solution:

```
$ export EXCLUDE_DIRS="eval $(echo --exclude-dir={assets,_site,vendor,_posts,api})"
$ egrep -r Service $EXCLUDE_DIRS ./*
```

No more stupid scrolling walls of minified CSS!

## There's more

As [pointed out by @Matthieu_xyz](https://twitter.com/Matthieu_xyz/status/819656237814083585), spaces will try to ruin everything:

```
$ echo --exclude-dir={w,t,f}                        # yay :)
--exclude-dir=w --exclude-dir=t --exclude-dir=f

$ echo --exclude-dir={w, t, f}                      # nay :(
--exclude-dir={w, t, f}
```

So if you really need a space, just escape it:

```
$ echo --exclude-dir={y,\ a,\ y}
--exclude-dir=a --exclude-dir= b --exclude-dir= c
```
