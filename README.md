# bsdstep
GNUstep build wrapper for FreeBSD

## Overview

The `bsdstep` project aims to build GNUstep on FreeBSD, providing a platform with a modern look and feel inspired by macOS. It includes optimizations and customization for a seamless user experience.

## Installation

To install `bsdstep`, follow these steps:

1. Switch to root user
   ```
   su -
   ```
2. Fetch the zip archive:
   ```
   fetch https://codeload.github.com/pkgdemon/bsdstep/zip/refs/heads/main -o bsdstep.zip
   ```
3. Extract the archive and navigate to the project directory:
   ```
   unzip bsdstep.zip
   cd bsdstep-main
   ```
4. Build and install the project as root:
   ```
   make install
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