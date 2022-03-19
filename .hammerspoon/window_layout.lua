laptopScreenName = 'Color LCD'

local positions = {
  full = {x=0, y=0, w=1, h=1},
  centered = {x=0.25, y=0.15, w=0.5, h=0.7},
  left25 = {x=0, y=0, w=0.25, h=1},
  left34 = {x=0, y=0, w=0.34, h=1},
  left50 = hs.layout.left50,
  left66 = {x=0, y=0, w=0.66, h=1},
  right25 = {x=0.75, y=0, w=0.25, h=1},
  right34 = {x=0.66, y=0, w=0.34, h=1},
  right50 = hs.layout.right50,
  right66 = {x=0.34, y=0, w=0.66, h=1},
  middle50 = {x=0.25, y=0, w=0.50, h=1},
  upper50 = {x=0, y=0, w=1, h=0.5},
  upper50Left50 = {x=0, y=0, w=0.5, h=0.5},
  upper50Right50 = {x=0.5, y=0, w=0.5, h=0.5},
  lower50 = {x=0, y=0.5, w=1, h=0.5},
  lower50Left50 = {x=0, y=0.5, w=0.5, h=0.5},
  lower50Left30 = {x=0, y=0.5, w=0.3, h=0.5},
  lower50Right50 = {x=0.5, y=0.5, w=0.5, h=0.5},
  lower50Right30 = {x=0.7, y=0.5, w=0.3, h=0.5},
}

function getPrimaryScreenName()
  return hs.screen.primaryScreen():name()
end

function getScreenNameLeftOfPrimary()
  return hs.screen.find{x=-1, y=0}:name()
end

function getScreenNameRightOfPrimary()
  return hs.screen.find{x=1, y=0}:name()
end

function getExternalScreenName()
  local screens = hs.screen.allScreens()
  
  if screens[1]:name() == laptopScreenName then
    return screens[2]:name()
  end

  return screens[1]:name()
end

function getDuetScreenName()
  local screens = hs.screen.allScreens()
  
  if screens[1]:name() == laptopScreenName then
    return screens[3]
  end

  return screens[2]
end

function undockedLayout()
  return {
    {"Spotify", nil, laptopScreenName, hs.layout.left70, nil, nil},
    {"Mail", nil, laptopScreenName, hs.layout.left70, nil, nil},
    {"Messages", nil, laptopScreenName, hs.layout.right70, nil, nil},
    {"Slack", nil, laptopScreenName, hs.layout.right70, nil, nil},
    {"Google Chrome", nil, laptopScreenName, hs.layout.maximized, nil, nil},
    {"iTerm2", nil, laptopScreenName, hs.layout.maximized, nil, nil},
  }
end

function dockedLayout()
  return {
    {"Spotify", nil, laptopScreenName, hs.layout.left50, nil, nil},
    {"Mail", nil, laptopScreenName, hs.layout.left50, nil, nil},
    {"Messages", nil, laptopScreenName, hs.layout.right50, nil, nil},
    {"Slack", nil, laptopScreenName, hs.layout.right50, nil, nil},
    {"Google Chrome", nil, laptopScreenName, hs.layout.left30, nil, nil},
    {"iTerm2", nil, laptopScreenName, hs.layout.right70, nil, nil},
  }
end

function dockedClamshellLayout()
  local externalScreenName = getExternalScreenName();
  return {
    {"Spotify", nil, externalScreenName, hs.layout.left30, nil, nil},
    {"Mail", nil, externalScreenName, hs.layout.left30, nil, nil},
    {"Messages", nil, externalScreenName, positions.lower50Right30, nil, nil},
    {"Slack", nil, externalScreenName, positions.right25, nil, nil},
    {"Google Chrome", nil, externalScreenName, positions.left25, nil, nil},
    {"iTerm2", nil, externalScreenName, positions.middle50, nil, nil},
  }
end

function dockedClamshellPipLayout()
  local primaryScreenName = getPrimaryScreenName();
  local leftScreenName = getScreenNameLeftOfPrimary();
  local rightScreenName = getScreenNameRightOfPrimary();
  return {
    {"Spotify", nil, leftScreenName, hs.layout.full, nil, nil},
    {"Mail", nil, leftScreenName, hs.layout.full, nil, nil},
    {"Messages", nil, rightScreenName, positions.lower50, nil, nil},
    {"Slack", nil, rightScreenName, positions.full, nil, nil},
    {"Google Chrome", nil, leftScreenName, positions.full, nil, nil},
    {"iTerm2", nil, primaryScreenName, positions.full, nil, nil},
  }
end

function applyLayout()
  local numScreens = #hs.screen.allScreens()
  local layout = {}
  local screens = hs.screen.allScreens()

  if numScreens == 1 then
    if screens[1]:name() == laptopScreenName then
      hs.alert.show("Applying 'Undocked' Layout")
      layout = undockedLayout()
    else
      hs.alert.show("Applying 'Docked Clamshell' Layout")
      layout = dockedClamshellLayout()
    end
  elseif numScreens == 2 then
    hs.alert.show("Applying 'Docked' Layout")
    layout = dockedLayout()
  elseif numScreens == 3 then
    hs.alert.show("Applying 'Docked Clamshell PIP' Layout")
    layout = dockedClamshellPipLayout()
  end

  hs.layout.apply(layout)
end

hs.hotkey.bind(cmdshift, "1", function()
  applyLayout()
end)

hs.screen.watcher.new(applyLayout):start()
