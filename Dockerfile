FROM 173487324533.dkr.ecr.ap-northeast-1.amazonaws.com/kagutsuchi_elixir_base:1.11.2 as app_builder
WORKDIR /app

COPY . ./
RUN mix deps.get
RUN npm install --prefix ./apps/kagutsuchi_web/assets && npm run deploy --prefix ./apps/kagutsuchi_web/assets && mix phx.digest
RUN mix release

# ---- Application Stage ----
FROM alpine AS kagutsuchi

ENV LANG=C.UTF-8

# Install openssl
RUN apk add --no-cache openssl ncurses-libs

# Copy over the build artifact from the previous step and create a non root user
RUN adduser -h /home/app -D app
WORKDIR /home/app
COPY --from=app_builder --chown=app /app/_build .
USER app

# Set the default entry point.
# In almost all cases we'll want to run the Elixir release, when starting the container
# and it's more convenient to run the app like this:
#
# docker run --network iml_private -e DATABASE_URL="ecto://postgres:password@kagutsuchi-db/kagutsuchi_prod" \
#   -e SECRET_KEY_BASE=exampe -e SECRET_LIVEVIEW_SALT=example -e GOOGLE_OAUTH_CLIENT_ID=example \
#   -e GOOGLE_OAUTH_CLIENT_SECRET=example -e GOOGLE_OAUTH_REDIRECT_URI=https://example.com/ \
#   kagutsuchi start
#
# than it is to type every element of the path to the release executable
# before the "start" argument.
#
# Or to run migrations:
# docker run --network iml_private -e DATABASE_URL="ecto://postgres:password@kagutsuchi-db/kagutsuchi_prod" \
#   -e SECRET_KEY_BASE=example -e SECRET_LIVEVIEW_SALT=example -e GOOGLE_OAUTH_CLIENT_ID=example \
#   -e GOOGLE_OAUTH_CLIENT_SECRET=example -e GOOGLE_OAUTH_REDIRECT_URI=https://example.com/ \
#   kagutsuchi eval "Kagutsuchi.Release.migrate"
#
# If you want to run, say, a shell, invoke docker run with --entrypoint /bin/sh/

ENTRYPOINT ["./prod/rel/kagutsuchi_web/bin/kagutsuchi_web"]