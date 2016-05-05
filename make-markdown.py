#!/usr/bin/env python
import sys
import os
import click
from collections import OrderedDict
import arrow

pages = OrderedDict()
posts = OrderedDict()

"""
The purpose of this script is to generate a file "index.md" that serves a similar purpose to an index.html file, but served to curl user agents.

It should write files in a similar structure as hugo so that the same URLs can be accessed via the web browser or curl.

It should be called with two arguments, as follows:

./make-markdown.py INPUT_DIR OUTPUT_DIR

"""

source_dir = sys.argv[1]
target_dir = sys.argv[2]
#target_dir = sys.argv[1] if len(sys.argv) > 1 else "/src/content/"

for root, dirs, files in os.walk(source_dir):
    for filename in files:
        if filename.startswith('.'):
            continue
        if filename.endswith('.swp'):
            continue
        if not root.endswith('/'):
            root = "{}/".format(root)
        if not source_dir.endswith('/'):
            source_dir = "{}/".format(source_dir)
        if not target_dir.endswith('/'):
            target_dir = "{}/".format(target_dir)

        source = os.path.join(root, filename)
        target = os.path.join(root.replace(source_dir, target_dir), filename)
        index_filename = os.path.join(target_dir, 'index.md')
        #print(root)
        #print(source_dir)
        #print(target)
        #print(uri)
        path = target.replace(target_dir, '')
        uri = "blog.soulshake.net/{}".format(path)
        assert os.path.exists(source)
        if not os.path.exists(os.path.dirname(target)):
            os.mkdir(os.path.dirname(target))
        source_file = open(source).read()
        target_file = open(target, 'w')
        target_file.write(source_file)

        chunks =  source_file.split('+++')
        # If we don't have any frontmatter, treat this as a page rather than a post
        if len(chunks) < 2:
            posts[filename] = {'body': source_file}
            continue

        post = OrderedDict()
        post["filename"] = filename
        source_file = chunks[1]

        for x in source_file.split('\n'):
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

        curl_url = "blog.soulshake.net/post/{}".format(post["filename"])
        post["curl_url"] = click.style(curl_url, fg='cyan')

        if "date" not in post:
            continue

        path = "/post/{}".format(post["filename"])

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
    'body',
    "draft",
    "filename",
    "project_url",
    "slug",
    "series"
    ]

index = open(index_filename, 'w')
for post in posts:
    if posts[post].get("draft") == 'true':
        continue

    for key in posts[post]:
        if key in skip_keys or not posts[post][key]:
            continue
        index.write("{}: {}\n".format(key, posts[post][key]))
        #print("{}: {}".format(key, posts[post][key]))
    index.write('\n')
    #print
    


