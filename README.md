# DUBstep
DUBstep is an experimental project intended for developers (for now).

DUBstep stands for:

- D for desktop
- U for Unix
- B for BSD
- step for GNUstep

It is essentially a GNUstep build wrapper for FreeBSD. The way to use it is to take a FreeBSD installation, clone the repo and install it on top.
While it can be installed on a running system with users already created, ideally you should have a fresh FreeBSD installation with no users and install it from the root account. More installation instructions are below.

## Overview

The `DUBstep` project aims to build GNUstep on FreeBSD, providing a platform with a modern look and feel inspired by macOS. It includes optimizations and customization for a seamless user experience.

## Installation

To install `DUBstep`, follow these steps:

1. Install FreeBSD 14.0-RELEASE, setup networking, set a password for root, do not create a user
2. Login as the root user
3. Fetch the zip archive:
   ```
   fetch https://codeload.github.com/ds-repos/ds-base/zip/refs/heads/main -o ds-bsbase.zip
   ```
4. Extract the archive and navigate to the project directory:
   ```
   unzip ds-base.zip
   cd ds-base-main
   ```
5. Build and install the project as root:
   ```
   make install
   ```
6. Create a user:
   ```
   adduser
   ```

   This will install essential packages like cmake, ninja, mdnsresponder, and build GNUstep along with customized applications.

   ## Customization

   The interface is customized to resemble a modern macOS layout, including a global menu panel and dock. bsdstep utilizes GNUstep for handling window decorations without the need for an external window manager.

   ## Building GNUstep Applications

   * GWorkspace
   * Terminal
   * TextEdit
   * System Preferences

   ## Target Audience

   This project is geared towards developers and enthusiasts who want to develop Objective-C based software on FreeBSD. It will provide a development environment with a macOS-like experience for those interested in Objective-C programming on the FreeBSD platform.

   ## Origins and Compatibility

   macOS, with its roots in NeXTSTEP, has historical ties to FreeBSD. Both macOS and NeXTSTEP leveraged FreeBSD components. The bsdstep project aims to carry forward this legacy and create a synergistic environment for FreeBSD users interested in a macOS-like experience.
