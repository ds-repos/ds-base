#!/bin/sh

# exec dubstep-x11
case $WINDOW_MANAGER in 
    "wmaker")
      exec wmaker --static & GWorkspace
    ;;
    "GWorkspace")
      exec GWorkspace
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac
