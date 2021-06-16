# ExJagaimoBlog

I'm playing around with a blogging application. As of the time of this
writing, I've only spent a couple of partial days hacking on this, so it's not very
interesting yet.

The initial goals are to replace a half-completed Rails app that I started ages
ago and never had time to finish. That repository is [here](https://github.com/JasonTrue/jagaimoblog)
but is private.

I figure making the repo public is worthwhile just because almost all of my other Elixir
code is owned by employers or consulting clients, and I'd like to at least have some
sort of public demonstration of the programming language I spend most of my work hours
writing in.

That said, this codebase isn't expected to ever be particularly robust; it's a side
project whose predecessor I'd largely been neglecting.

The current features:

- Models blogs, posts, comments.
- Has a sort of "magazine" view see (LandingController) that's routed by
domain name.
- Has some sort of historical archive view (organized by year/month/day)
- Not important to you, but migrates my old Rails-based database schema to use
Ecto conventions, while still (hopefully) having decent-ish greenfield migrations.
- A tag cloud view (needs to be a bit more flexible.)
- Filtering the archive by tags (Easy-ish! yay! may have some performance issues with larger databases)
  
Things that I'm hoping to work on soon:
- Atom feed
- Styling
- ElasticSearch full-text search

Things that I'm hoping to work on eventually:
- Blog post editing features
- Blog configuration code (not important to me because legacy schema)
- Opengraph support for Twitter/Facebook cards

# License

Please consider this "proprietary" for now, but if you're interested
in leveraging this code for your own projects please file an [issue](https://github.com/JasonTrue/ex_jagaimo_blog/issues)

I'm probably open to converting this to a MIT or similar license but I'm only
likely to do that if a couple of people show interest in the code.

# Running

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

This won't get you very far though; you'll need to create at least one Blog record
for the app to be of any use. (The ExJagaimoBlog context doesn't yet help for that very much)

