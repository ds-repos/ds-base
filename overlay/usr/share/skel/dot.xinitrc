#!/bin/sh

picom --config /opt/etc/picom.conf

# exec dubstep-x11
case $WINDOW_MANAGER in 
    "wmaker")
      exec wmaker --static & openapp GWorkspace
    ;;
    "GWorkspace")
      exec GWorkspace &
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac
