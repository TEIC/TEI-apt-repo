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


How to run
-------

Simply clone this repository to the server directory where you want the APT repository to be created an run `ant`.
The script will 

* download the latest (stable) deb packages from the TEI Jenkins server 
* create the repository files `Packages` and `Release`
* sign the `Release` file with the default key from the default keyring found under `~/.gnupg/` 
* create an `index.html` from the template `index.tmpl` with a current list of available packages  
	
	
License
-------

This work is available under dual license: [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause) and [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)
