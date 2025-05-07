# RUBY_VERSION set by build.sh based on .ruby-version file
ARG RUBY_VERSION
FROM public.ecr.aws/docker/library/ruby:${RUBY_VERSION}-alpine

# DataDog logs source
LABEL com.datadoghq.ad.logs='[{"source": "ruby"}]'

# Create web application user to run as non-root
RUN addgroup -g 1000 webapp \
    && adduser -u 1000 -G webapp -s /bin/sh -D webapp \
    && mkdir -p /home/webapp/app
WORKDIR /home/webapp/app

# Upgrade alpine packages (useful for security fixes)
RUN apk upgrade --no-cache

# Install rails/app dependencies
RUN apk --no-cache add libc6-compat git postgresql-libs tzdata nodejs yarn shared-mime-info yaml-dev

# Copy dependency definitions and lock files
COPY Gemfile Gemfile.lock .ruby-version ./

# Install bundler version which created the lock file and configure it
ARG SIDEKIQ_CREDS
RUN gem install bundler -v $(awk '/^BUNDLED WITH/ { getline; print $1; exit }' Gemfile.lock) \
    && bundle config --global gems.contribsys.com $SIDEKIQ_CREDS

# Install build-dependencies, then install gems, subsequently removing build-dependencies
RUN apk --no-cache add --virtual build-deps build-base postgresql-dev \
    && bundle install --jobs 20 --retry 2 \
    && apk del build-deps

# Copy the application
COPY . .

# Environment required to build the application
ARG PROJECT_NAME
ARG RAILS_ENV=production
ARG BASE_URL=http://localhost:3000
ARG CAS_URL=https://thekey.me/cas
ARG CAS_ACCESS_TOKEN=test
ARG DB_ENV_POSTGRESQL_USER=postgres
ARG DB_ENV_POSTGRESQL_PASS=password
ARG DB_ENV_POSTGRESQL_DB=cru
ARG DB_PORT_5432_TCP_ADDR=localhost
ARG SESSION_REDIS_DB_INDEX=1
ARG SESSION_REDIS_HOST=redis
ARG SESSION_REDIS_PORT=6379
ARG STORAGE_REDIS_DB_INDEX=1
ARG STORAGE_REDIS_HOST=redis
ARG STORAGE_REDIS_PORT=6379
ARG SECRET_KEY_BASE=b12374ce07c365986c3be4fa417fe9248242c64bb4aec0dc04c6562a08b0afb8ff52fc209aa5e4a3f1fefd9d0121ade9d0ccf948512751db1a52070aea4e5d30
ARG IDP_SSO_TARGET_URL="https://dev-54692893.okta.com/app/dev-54692893_cruconfdev_1/exk9ofqjjbx7hfHkr5d7/sso/saml"
ARG SP_ENTITY_ID="SCO"
ARG IDP_CERT= "-----BEGIN CERTIFICATE-----
MIIDqDCCApCgAwIBAgIGAYhKTMlXMA0GCSqGSIb3DQEBCwUAMIGUMQswCQYDVQQGEwJVUzETMBEG
A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
MBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDGRldi01NDY5Mjg5MzEcMBoGCSqGSIb3DQEJ
ARYNaW5mb0Bva3RhLmNvbTAeFw0yMzA1MjMyMDI3NDZaFw0zMzA1MjMyMDI4NDZaMIGUMQswCQYD
VQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsG
A1UECgwET2t0YTEUMBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDGRldi01NDY5Mjg5MzEc
MBoGCSqGSIb3DQEJARYNaW5mb0Bva3RhLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALWSMdkXgvRy/rscLFp0ZuHIGNvpo0CBr7iKA3Lfq1WVDr5irDCd4czB51FgWOZlpKIww1Sq
dREliyhyjvpJg+KtD9In/hmVK3+4lir7VtLwCvZ24OelGcbkccqzcXXqAT8aR6HGhdRciIKE6QZq
PHA7dNdR8+kotsGEYWTsZfYYUyQ7w1BoLYnnFh0QRKPqWeBeuxuHyOH3+vwhCmaCd8LDypp1tAil
UoeZdPArcJqinFIpHmJz0OwQAGLjC29BWNZN0teET/9BSnSQBjBPiBF+x7nBTTQD5yqWT23I9d2/
7QBfWMBOQMTubN8Fy7fT6sfe20OwaUMShThKGVwEkccCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEA
Atohe4p9Celz3A29cBDWu2WIubANDFrc4O7Y421I7tXHqwbmbt+cAzN8PkvKdXBoIrGCslaIFm7k
ZhljQRBadIqMQ8BlvdlhP3oQTsyJUfUQKmz+OQUtebUYV511kOF8xq+nbWKvBwDxJ6+NuJlZgdnz
ss3VA9kylvaxtNcnABjkmF+e+WcCQoxSiadDKCJmqYG/Vd+lcU6EWXy5hOLw0vsg3tu6sF1t/qUV
LuML9PW55KdO0BzPsTlfMJNeLSjSyTSqgqyeWP7PGlsIQROzsof7ygGfWIvvP3yueXlKnyJlSgVd
16CdISQ6jj+pLzQvzUdN2ZBqbr2uiLvZXX9/CA==
-----END CERTIFICATE-----"


# Compile assets
RUN RAILS_ENV=${RAILS_ENV} bundle exec rake assets:clobber assets:precompile \
  && chown -R webapp:webapp /home/webapp/

# Define volumes used by ECS to share public html and extra nginx config with nginx container
VOLUME /home/webapp/app/public
VOLUME /home/webapp/app/nginx-conf

# Run container process as non-root user
USER webapp

# Command to start rails
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
