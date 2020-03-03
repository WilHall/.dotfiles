laptopScreenName = 'Color LCD'

function getSecondaryExternalScreenName()
  local screens = hs.screen.allScreens()
  
  if screens[1] == laptopScreenName then
    return screens[2]:name()
  end

  return screens[1]:name()
end

function undockedLayout()
  return {
    {"TIDAL", nil, laptopScreenName, hs.layout.left70, nil, nil},
    {"Airmail", nil, laptopScreenName, hs.layout.left70, nil, nil},
    {"Messages", nil, laptopScreenName, hs.layout.right70, nil, nil},
    {"Basecamp 3", nil, laptopScreenName, hs.layout.right70, nil, nil},
    {"Slack", nil, laptopScreenName, hs.layout.right70, nil, nil},
    {"Firefox Developer Edition", nil, laptopScreenName, hs.layout.maximized, nil, nil},
    {"kitty", nil, laptopScreenName, hs.layout.maximized, nil, nil},
  }
end

function dockedLayout()
  return {
    {"TIDAL", nil, laptopScreenName, hs.layout.left50, nil, nil},
    {"Airmail", nil, laptopScreenName, hs.layout.left50, nil, nil},
    {"Messages", nil, laptopScreenName, hs.layout.right50, nil, nil},
    {"Basecamp 3", nil, laptopScreenName, hs.layout.right50, nil, nil},
    {"Slack", nil, laptopScreenName, hs.layout.right50, nil, nil},
    {"Firefox Developer Edition", nil, getSecondaryExternalScreenName(), hs.layout.left30, nil, nil},
    {"kitty", nil, getSecondaryExternalScreenName(), hs.layout.right70, nil, nil},
  }
end

function applyLayout()
  local numScreens = #hs.screen.allScreens()
  local layout = {}

  if numScreens == 1 then
    hs.alert.show("Applying 'Undocked' Layout")
    layout = undockedLayout()
  elseif numScreens == 2 then
    hs.alert.show("Applying 'Docked' Layout")
    layout = dockedLayout()
  end

  hs.layout.apply(layout)
end

hs.hotkey.bind(cmdshift, "1", function()
  applyLayout()
end)

hs.screen.watcher.new(applyLayout):start()
