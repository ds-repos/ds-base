# State of Wayland

Currently there is a way to start Wayland with a Hyprland session and some additional tooling. GNUstep's Wayland support will eventually be added when it is ready. Until then DUBstep developers can use this session to make progress. GNUstep apps can be launched either in rootless mode in the general area or in a rootful Xwayland window. Refer to the list of keyboard shortcuts in the next section.

### Wayland tips

This environment is keyboard and config driven. A have set the mod key to Alt (command key) but made the shortcuts generally use Alt+SUPER (Command + Option) to avoid conflicts with GNUstep shortcuts

- `Cmd+Opt T` Launches Kitty Terminal
- `Cmd V` toggles between floating mode
- `Cmd C` Closes the focused window
- `Cmd Arrow keys` In tiled mode will cycle through the windows and give it focus
- `Cmd+Opt Q` Exits the Wayland session
- `Cmd 1-9` Switches to workspace
- `Cmd+Shift 1-9` Moves focused window to workspace
- `Cmd+Opt G` Launches GWorkspace contained in an Xwayland window running in rootful mode. Workspace 2 is set to make everything float by default except the Xwayland window. Best to launch this on workspace 2 (`Cmd 2`)

#### Other Behaviors
Hovering over the window will bring it into focus
Cmd drag will temporarily put the window into float mode so you can swap places with another tiled window
