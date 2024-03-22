#!/bin/sh

# exec dubstep-x11
case $WINDOW_MANAGER in 
    "wmaker")
      exec wmaker --static & GWorkspace
    ;;
    "GWorkspace")
      picom --config /opt/etc/picom.conf
      exec GWorkspace
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac
