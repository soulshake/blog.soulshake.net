#!/usr/bin/env python
import sys
import os
import click
from collections import OrderedDict
import arrow

posts = OrderedDict()
keys = [
    "title",
    "tags",
    "summary",
    "description",
    "date",
    "url",
    "categories",
]

target_dir = sys.argv[1] if len(sys.argv) > 1 else "/src/content/post/"

for root, dirs, files in os.walk(target_dir):
    for filename in files:
        if filename.endswith('.swp'):
            continue
        f = open(target_dir + filename).read()

        post = OrderedDict()
        post["filename"] = filename

        chunks =  f.split('+++')
        f = chunks[1]

        for x in f.split('\n'):
            if ' = ' in x:
                key, value = x.split(' = ', 1)

                if key == 'title':
                    value = click.style(value, bold=True)

                if key == 'date':
                    value = arrow.get(value)

                if key == "tags":
                    value = [x.replace('"', '').replace(',', '') for x in value.split() if x not in ['[', ']']]
                    value = " ".join(["#{}".format(x) for x in value])
                    value = click.style(value, fg='green')

                post[key] = value

        # blog.soulshake.net/post/command-line-resume.md
        curl_url = "blog.soulshake.net/post/{}".format(post["filename"])
        #if url.endswith(".md"):
            #url = url[:-3]
        post["curl_url"] = click.style(curl_url, fg='cyan')

        if "date" not in post:
            continue
        #post.setdefault("date", arrow.now())

        path = "/post/{}".format(post["filename"])
        #post["path"] = path

        real_url = "http://blog.soulshake.net/{}/{}".format(
            post["date"].format('YYYY/MM'),
            post["filename"],
        )

        if real_url.endswith(".md"):
            real_url = real_url[:-3]
        real_url = click.style(real_url + "/", fg='cyan')

        post["date"] = "{} ({})".format(
            post["date"].format('MMMM D, YYYY'),
            post["date"].humanize(),
            )
        post["real_url"] = real_url


        posts[filename] = post

skip_keys = [
    "author",
    "draft",
    "filename",
    "project_url",
    "slug",
    "series"
    ]

for post in posts:
    if posts[post].get("draft") == 'true':
        continue

    for key in posts[post]:
        if key in skip_keys or not posts[post][key]:
            continue
        print("{}: {}".format(key, posts[post][key]))
    print
    


