#!/bin/sh

# exec dubstep-x11
case $WINDOW_MANAGER in 
    "x11")
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
