FROM debian as builder

# For security reasons we pass the gpg key and passphrase 
# from an external (temporary) URL 
ARG GPG_KEY_URL
ARG GPG_PASS_URL

ADD ${GPG_KEY_URL} /gpg/key
ADD ${GPG_PASS_URL} /gpg/secret

# install dependencies 
# and import gpg key 
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        ant \
        dpkg-dev \
        gnupg2 \
        libsaxonhe-java \ 
    && echo /gpg/secret | gpg --batch --import /gpg/key

WORKDIR /TEI-apt-repo
COPY . .

# run the ANT build script 
# and delete the gpg related files to make sure
# they are not copied into the second stage
RUN ant -lib /usr/share/java \
    && rm -Rf /gpg /root/.gnupg 


# second stage:
# run webserver
FROM nginx:alpine

WORKDIR /usr/share/nginx/html/deb

COPY --from=builder /TEI-apt-repo/ .
