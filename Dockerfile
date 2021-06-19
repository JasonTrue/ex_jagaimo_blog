FROM hexpm/elixir:1.12.1-erlang-24.0.2-alpine-3.13.3 as app_builder
# Set environment variables for building the application
ENV MIX_ENV=prod \
    LANG=C.UTF-8

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Create the application build directory
RUN mkdir /app
WORKDIR /app
RUN apk add --update --virtual .gyp npm nodejs-current python2 make g++ git

COPY . ./
RUN mix deps.get
RUN npm install --prefix ./assets && npm run deploy --prefix ./assets && mix phx.digest
RUN mix release

# ---- Application Stage ----
FROM alpine AS jagaimoblog

ENV LANG=C.UTF-8

# Install openssl
RUN apk add --no-cache openssl ncurses-libs

# Copy over the build artifact from the previous step and create a non root user
RUN adduser -h /home/jagaimo -D jagaimo
WORKDIR /home/app
COPY --from=app_builder --chown=app /app/_build .
USER jagaimo

# Set the default entry point.
# In almost all cases we'll want to run the Elixir release, when starting the container
# and it's more convenient to run the app like this:
#
# docker run --network iml_private -e DATABASE_URL="ecto://postgres:password@jagaimob-db/ex_jagaimo_blog_prod" \
#   -e SECRET_KEY_BASE=exampe -e SECRET_LIVEVIEW_SALT=example -e GOOGLE_OAUTH_CLIENT_ID=example \
#   -e GOOGLE_OAUTH_CLIENT_SECRET=example -e GOOGLE_OAUTH_REDIRECT_URI=https://example.com/ \
#   ex_jagaimo_blog start
#
# than it is to type every element of the path to the release executable
# before the "start" argument.
#
# Or to run migrations:
# docker run --network iml_private -e DATABASE_URL="ecto://postgres:password@ex_jagaimo_blog-db/ex_jagaimo_blog_prod" \
#   -e SECRET_KEY_BASE=example -e SECRET_LIVEVIEW_SALT=example -e GOOGLE_OAUTH_CLIENT_ID=example \
#   -e GOOGLE_OAUTH_CLIENT_SECRET=example -e GOOGLE_OAUTH_REDIRECT_URI=https://example.com/ \
#   ex_jagaimo_blog eval "ex_jagaimo_blog.Release.migrate"
#
# If you want to run, say, a shell, invoke docker run with --entrypoint /bin/sh/

ENTRYPOINT ["./prod/rel/ex_jagaimo_blog/bin/ex_jagaimo_blog"]
