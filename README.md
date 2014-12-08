# linux-packaging-docker

I decided to take a stab at linux packaging.  I was inspired by
OpenSUSE's open build service.  I wanted to see if I could leverage
docker to do something similar for a single developer.

This is really just a Demo / Template for linux rpm and deb packaging using docker.  I'm not sure how far beyond this proof of concept it will be developed.

## Prerequisites

Must have docker (or boot2docker) installed (http://docker.io)

## Quickstart

This packages a sample hello program that installs in /opt/hello

1.  Install docker if you don't already have it

2.  Open terminal and run make

3.  The resulting files if successful will be in the output directory

## Taking to the next level

If using this as a template, all the files are under src-root.  Edit all the debian/*  files, and edit the .spec file.  Next edit the Makefile and make changes there.

## What is going on behing the scenes?

Two images are created (build-deb:wheezy and build-rpm:centos6) with the debian and rpm development environments respectively.  wheezy and centos6 where chosen as baselines.  Depending on your requirements, most deb and rpm based distributions should be able to install them.

## Future

As time permits / I feel like it.

* Build archlinux pkg files

* Capable of handling all the rpm and deb derivatives to allow for native packages built using the actual distribution,  e.g Ubuntu 12.04, 14.04, etc.  and Fedora 21, etc.  Should be able to use mock on Fedora, possibly debroot on Ubuntu?

* Capable of building 32-bit .deb and .rpm - using multiarch capabilities withing 64-bit OS?  once again mock on fedora would work.