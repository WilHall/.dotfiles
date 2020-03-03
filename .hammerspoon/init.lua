hs.ipc.cliInstall()
hs.application.enableSpotlightForNameSearches(true)

-- initial hammerspoon configs
hs.window.animationDuration = 0

-- globals
command = '⌘'
option = '⌥'
control = '⌃'
shift = '⇧'
ctrlopt = {control, option}
cmdopt = {command, option}
cmdshift = {command, shift}
hyper = {control, option, command}

require "window_hints"
require "window_resizing"
require "window_toggling"
require "window_layout"
require "display"

