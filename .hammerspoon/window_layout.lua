laptopScreenName = 'Color LCD'

local positions = {
  centered = {x=0.15, y=0.15, w=0.7, h=0.7},
  left34 = {x=0, y=0, w=0.34, h=1},
  left50 = hs.layout.left50,
  left66 = {x=0, y=0, w=0.66, h=1},
  right34 = {x=0.66, y=0, w=0.34, h=1},
  right50 = hs.layout.right50,
  right66 = {x=0.34, y=0, w=0.66, h=1},
  upper50 = {x=0, y=0, w=1, h=0.5},
  upper50Left50 = {x=0, y=0, w=0.5, h=0.5},
  upper50Right50 = {x=0.5, y=0, w=0.5, h=0.5},
  lower50 = {x=0, y=0.5, w=1, h=0.5},
  lower50Left50 = {x=0, y=0.5, w=0.5, h=0.5},
  lower50Right50 = {x=0.5, y=0.5, w=0.5, h=0.5}
}

function getExternalScreenName()
  local screens = hs.screen.allScreens()
  
  if screens[1] == laptopScreenName then
    return screens[2]:name()
  end

  return screens[1]:name()
end

function undockedLayout()
  return {
    {"Spotify", nil, laptopScreenName, hs.layout.left70, nil, nil},
    {"Spark", nil, laptopScreenName, hs.layout.left70, nil, nil},
    {"Messages", nil, laptopScreenName, hs.layout.right70, nil, nil},
    {"Basecamp 3", nil, laptopScreenName, hs.layout.right70, nil, nil},
    {"NetNewsWire", nil, laptopScreenName, hs.layout.right70, nil, nil},
    {"Slack", nil, laptopScreenName, hs.layout.right70, nil, nil},
    {"Firefox Developer Edition", nil, laptopScreenName, hs.layout.maximized, nil, nil},
    {"kitty", nil, laptopScreenName, hs.layout.maximized, nil, nil},
  }
end

function dockedLayout()
  return {
    {"Spotify", nil, laptopScreenName, hs.layout.left50, nil, nil},
    {"Spark", nil, laptopScreenName, hs.layout.left50, nil, nil},
    {"Messages", nil, laptopScreenName, hs.layout.right50, nil, nil},
    {"Basecamp 3", nil, laptopScreenName, hs.layout.right50, nil, nil},
    {"NetNewsWire", nil, laptopScreenName, hs.layout.right50, nil, nil},
    {"Slack", nil, laptopScreenName, hs.layout.right50, nil, nil},
    {"Firefox Developer Edition", nil, laptopScreenName, hs.layout.left30, nil, nil},
    {"kitty", nil, laptopScreenName, hs.layout.right70, nil, nil},
  }
end

function dockedClamshellLayout()
  local externalScreenName = getExternalScreenName();
  return {
    {"Spotify", nil, externalScreenName, hs.layout.left30, nil, nil},
    {"Spark", nil, externalScreenName, hs.layout.left30, nil, nil},
    {"Messages", nil, externalScreenName, positions.lower50Right50, nil, nil},
    {"Basecamp 3", nil, externalScreenName, hs.layout.right34, nil, nil},
    {"NetNewsWire", nil, externalScreenName, hs.layout.right34, nil, nil},
    {"Slack", nil, externalScreenName, positions.centered, nil, nil},
    {"Firefox Developer Edition", nil, externalScreenName, positions.left34, nil, nil},
    {"kitty", nil, externalScreenName, positions.right66, nil, nil},
  }
end

function applyLayout()
  local numScreens = #hs.screen.allScreens()
  local layout = {}

  if numScreens == 1 then
    local screens = hs.screen.allScreens()
    
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
  end

  hs.layout.apply(layout)
end

hs.hotkey.bind(cmdshift, "1", function()
  applyLayout()
end)

hs.screen.watcher.new(applyLayout):start()
