# This is my blog.

There are many like it, but this one is mine.

## Usage

### Local development

```
  $ echo "DEVELOPMENT=true" >> .env
  $ echo "HUGO_BASEURL=localhost" >> .env
```

With Docker Compose:

  * `docker-compose build`
  * `docker-compose up`

With Convox:

  * `convox start`

### Deployment

With Convox:

  * Install a Rack
  * `convox switch personal/<your Rack name>`
  * From the project root, run `mkdir .convox`
  * `echo $(convox switch) > .convox/rack`
  * `convox apps create`
  * Create a CNAME with your DNS provider to your Rack load balancer URL
  * Run `convox env set HUGO_BASEURL=blog.example.com` (replace `blog.example.com` with the URL of your blog)
  * `convox deploy`

## Hat tip

This repo looks a lot like @jfrazelle's [blog](https://github.com/jfrazelle/blog), because that's where I got it.

