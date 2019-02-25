TEI apt repo
================

This is a simple ANT build file for creating and updating the TEI Debian packages repository.
Documentation about the TEI Debian packages can be found on the [TEI Wiki](https://wiki.tei-c.org/index.php/TEIDebian).

This GitHub repository is only for the administrative task of maintaining the TEI APT repository! 


Dependencies
--------

* Apache ANT with Saxon (for XSLT2) in its classpath
* GnuPG2 for signing the repository
* `dpkg-scanpackages` for inspecting the deb packages


How it works
-------

Simply clone this repository to the server directory where you want the APT repository to be created and run `ant`.
The script will 

* download the latest (stable) deb packages from the TEI Jenkins server 
* create the repository files `Packages` and `Release`
* sign the `Release` file with the default key from the default keyring found under `~/.gnupg/` 
* create an `index.html` from the template `index.tmpl` with a current list of available packages  


Docker
-------

A multi stage Dockerfile is provided that will 
a) build the artifacts and create the apt repository, and
b) run a nginx webserver for publishing the apt repo.

The tricky bit in building the image is providing the GPG key and passphrase
because we do not want these to end up in the public image.
Therefore they are injected through HTTP and only visible in the build stage (of the multi stage dockerfile). 
So, for building the image you'll need

* a private GPG key (with a passphrase)
* make these accessible via HTTP (e.g. by running a nginx webserver via Docker)
* pass these to the Docker build command as `GPG_PASS_URL` and `GPG_KEY_URL` via `--build-arg`, e.g.

```
docker build -t tei-apt-repo --build-arg GPG_PASS_URL=http://localhost:9090/secret.pass  --build-arg GPG_KEY_URL=http://localhost:9090/secret.key  .
```

License
-------

This work is available under dual license: [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause) and [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)
