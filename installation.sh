#!/bin/bash

# Copyright 2010-2014 Ivan Perez Dominguez & Keera Studios Ltd (UK)
# BSD3

# This script is ad-hoc. As such, it will install keera-posture, but
# it will not create any DEB for it. That being said, you may want
# to use it in order to install it in your $HOME and take the program
# out for a spin

# Check out all necessary repositories
echo -n Cloning
git clone --quiet --depth=1 git://github.com/keera-studios/gtk-helpers.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-i18n.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-mvc-controller.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-mvc-environment-gtk.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-mvc-model-protectedmodels.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-mvc-solutions-config.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-mvc-solutions-gtk.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-mvc-view.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-mvc-view-gtk.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-reactive-gtk.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/hails-reactivevalues.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/keera-hails.git
echo -n .
# git clone --quiet --depth=1 git://github.com/keera-studios/keera-posture.git
# Private repo for pre-releases
git clone --quiet --depth=1 https://bitbucket.org/iperezdominguez/keera-posture-prerelease keera-posture # Make sure we use the right dir name
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/MissingK.git
echo -n .
# # OpenCV 2.0 is not backwards compatible
git clone --quiet --depth=1 git://github.com/keera-studios/HOpenCV.git
echo -n .
git clone --quiet --depth=1 git://github.com/keera-studios/cv-combinators.git
echo -n .
# git clone --quiet git://github.com/sinelaw/HOpenCV.git
# pushd HOpenCV > /dev/null
# git checkout --quiet 99e3ffd # Revert to 0.1.2.4
# popd > /dev/null
# echo [DONE]

# Why cabal-dev does not do this automatically, I don't know
export PATH=$HOME/.cabal/bin:$PWD/cabal-dev/bin:$PATH

# Installation requires three things: auxiliary tools, haskell dependencies and
# the program itself. There are four necessary tools: alex, happy, gtk2hs,
# hails.  Because of the way cabal-dev adds packages to the DB (it runs cabal
# configure first, I believe) it is necessary to add some sources, install some
# tools, add more sources and so on and so forth, until every dependency is
# installed.
#
# Too bad, I know.
which cabal
if [[ "$?" -gt "0" ]] ; then
  apt-get install -y cabal-install
fi

cabal update ;

which cabal-dev
if [[ "$?" -gt "0" ]] ; then
   apt-get install -y zlib1g-dev
   cabal install cabal-dev ;
fi

# Install alex and happy if they are not installed.
# It would be better to create a tool that checks if the programs
# exist, otherwise gives a choice to install them from
# binaries or from cabal. But there isn't.

git clone --depth=1 git://github.com/keera-studios/gtk-helpers.git
git clone --depth=1 git://github.com/keera-studios/hails-i18n.git
git clone --depth=1 git://github.com/keera-studios/hails-mvc-controller.git
git clone --depth=1 git://github.com/keera-studios/hails-mvc-environment-gtk.git
git clone --depth=1 git://github.com/keera-studios/hails-mvc-model-protectedmodels.git
git clone --depth=1 git://github.com/keera-studios/hails-mvc-solutions-config.git
git clone --depth=1 git://github.com/keera-studios/hails-mvc-solutions-gtk.git
git clone --depth=1 git://github.com/keera-studios/hails-mvc-view.git
git clone --depth=1 git://github.com/keera-studios/hails-mvc-view-gtk.git
git clone --depth=1 git://github.com/keera-studios/hails-reactive-gtk.git
git clone --depth=1 git://github.com/keera-studios/hails-reactivevalues.git
git clone --depth=1 git://github.com/keera-studios/keera-hails.git
git clone --depth=1 git://github.com/keera-studios/MissingK.git
git clone --depth=1 git://github.com/keera-studios/HOpenCV.git
git clone --depth=1 git://github.com/keera-studios/cv-combinators.git

export PATH=$PATH:`pwd`/cabal-dev/bin

# Install alex and happy
which alex
if [[ "$?" -gt "0" ]] ; then
   cabal-dev install alex ;
fi

which happy
if [[ "$?" -gt "0" ]] ; then
   cabal-dev install happy;
fi

# Add some packages to cabal-dev's local package DB
cabal-dev add-source gtk-helpers
cabal-dev add-source hails-i18n
cabal-dev add-source hails-mvc-controller
cabal-dev add-source hails-mvc-environment-gtk
cabal-dev add-source hails-mvc-model-protectedmodels
cabal-dev add-source hails-mvc-solutions-config
cabal-dev add-source hails-mvc-solutions-gtk
cabal-dev add-source hails-mvc-view
cabal-dev add-source hails-mvc-view-gtk
cabal-dev add-source hails-reactive-gtk
cabal-dev add-source hails-reactivevalues
cabal-dev add-source keera-hails
cabal-dev add-source MissingK
cabal-dev add-source HOpenCV
cabal-dev add-source cv-combinators

# Install more dependencies
which gtk2hsC2hs
if [[ "$?" -gt "0" ]] ; then
   cabal-dev install gtk2hs-buildtools;
fi

which hails
if [[ "$?" -gt "0" ]] ; then
   cabal-dev install keera-hails;
fi

# Keera Posture
cabal-dev add-source keera-posture

# Normal installation (even if we want to build a DEB, we install
# so that we can later copy only the data files we really need
# (FIXME: this is a bit ugly)
cabal-dev install keera-posture

if [[ ! -z "$DEBIAN_BUILD" ]]; then
  PACKAGE_NAME=keera-posture
  DEBIAN_LIB_DIR=/usr/lib/$PACKAGE_NAME
  DEBIAN_BIN_DIR=/usr/bin
  DEBIAN_DATA_DIR=/usr/share/$PACKAGE_NAME/
  DEBIAN_DATA_SUBDIR=""
  # Prepare debian build
  pushd keera-posture
  cabal-dev -s ../cabal-dev/ install-deps
  cabal-dev -s ../cabal-dev/ configure --libdir=$DEBIAN_LIB_DIR --bindir=$DEBIAN_BIN_DIR --datadir=$DEBIAN_DATA_DIR --datasubdir=$DEBIAN_DATA_SUBDIR
  cabal-dev -s ../cabal-dev/ build
  popd
fi
