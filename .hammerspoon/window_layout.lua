laptopScreenName = 'Built-in Retina Display'

local positions = {
  full = { x = 0, y = 0, w = 1, h = 1 },
  centered = { x = 0.25, y = 0.15, w = 0.5, h = 0.7 },
  center50 = { x = 0.25, y = 0, w = 0.50, h = 1 },
  center30Left = { x = 0.25, y = 0, w = 0.30, h = 1 },
  center20Right = { x = 0.55, y = 0, w = 0.20, h = 1 },
  right25b = { x = 0.75, y = 0.5, w = 0.25, h = 0.5 },
  left25 = { x = 0, y = 0, w = 0.25, h = 1 },
  left34 = { x = 0, y = 0, w = 0.34, h = 1 },
  left50 = hs.layout.left50,
  left66 = { x = 0, y = 0, w = 0.66, h = 1 },
  right25 = { x = 0.75, y = 0, w = 0.25, h = 1 },
  right34 = { x = 0.66, y = 0, w = 0.34, h = 1 },
  right50 = hs.layout.right50,
  right66 = { x = 0.34, y = 0, w = 0.66, h = 1 },
  upper50 = { x = 0, y = 0, w = 1, h = 0.5 },
  lower50 = { x = 0, y = 0.5, w = 1, h = 0.5 },
}

function find(array, fn)
  for i, v in ipairs(array) do
    if fn(v) == true then
      return v
    end
  end
  return nil
end

function max(t, fn)
  if #t == 0 then return nil, nil end
  local key, value = 1, t[1]
  for i = 2, #t do
    if fn(value, t[i]) then
      key, value = i, t[i]
    end
  end
  return value
end

function getWidestScreen()
  return max(hs.screen.allScreens(), function(a, b) return a:fullFrame().w < b:fullFrame().w end)
end

function getNarrowestScreen()
  return max(hs.screen.allScreens(), function(a, b) return a:fullFrame().w > b:fullFrame().w end)
end

function getPrimaryScreen()
  return hs.screen.primaryScreen()
end

function getScreenLeftOfPrimary()
  return hs.screen.find { x = -1, y = 0 }
end

function getScreenRightOfPrimary()
  return hs.screen.find { x = 1, y = 0 }
end

function getLaptopScreen()
  local screens = hs.screen.allScreens()

  if screens[1]:name() == laptopScreenName then
    return screens[1]
  end

  return screens[2]
end

function getExternalScreen()
  local screens = hs.screen.allScreens()

  if screens[1]:name() == laptopScreenName then
    return screens[2]
  end

  return screens[1]
end

function undockedMonoLayout()
  local laptopScreen = getLaptopScreen()
  return {
    { "Spotify",         nil, laptopScreen, positions.full,    nil, nil },
    { "Mail",            nil, laptopScreen, positions.full,    nil, nil },
    { "Linear",          nil, laptopScreen, positions.full,    nil, nil },
    { "Messages",        nil, laptopScreen, positions.lower50, nil, nil },
    { "Slack",           nil, laptopScreen, positions.right66, nil, nil },
    { "Google Chrome",   nil, laptopScreen, positions.full,    nil, nil },
    { "WebStorm",        nil, laptopScreen, positions.full,    nil, nil },
    { "BambuStudio",     nil, laptopScreen, positions.full,    nil, nil },
    { "OrcaSlicer",      nil, laptopScreen, positions.full,    nil, nil },
    { "Adobe Lightroom", nil, laptopScreen, positions.full,    nil, nil },
    { "Blender",         nil, laptopScreen, positions.full,    nil, nil },
    { "Copilot",         nil, laptopScreen, positions.full,    nil, nil },
    { "iTerm2",          nil, laptopScreen, positions.full,    nil, nil },
  }
end

function dockedMonoLayout()
  local externalScreen = getExternalScreen()
  return {
    { "Spotify",         nil, externalScreen, positions.left25,   nil, nil },
    { "Mail",            nil, externalScreen, positions.left25,   nil, nil },
    { "Linear",          nil, externalScreen, positions.left25,   nil, nil },
    { "Messages",        nil, externalScreen, positions.right25b, nil, nil },
    { "Slack",           nil, externalScreen, positions.right25,  nil, nil },
    { "Google Chrome",   nil, externalScreen, positions.left25,   nil, nil },
    { "WebStorm",        nil, externalScreen, positions.center50, nil, nil },
    { "BambuStudio",     nil, externalScreen, positions.center50, nil, nil },
    { "OrcaSlicer",      nil, externalScreen, positions.center50, nil, nil },
    { "Adobe Lightroom", nil, externalScreen, positions.center50, nil, nil },
    { "Blender",         nil, externalScreen, positions.center50, nil, nil },
    { "Fork",            nil, externalScreen, positions.center50, nil, nil },
    { "Copilot",         nil, externalScreen, positions.center50, nil, nil },
    { "Code",   nil, externalScreen, positions.center30Left, nil, nil },
    { "iTerm2",          nil, externalScreen, positions.center20Right, nil, nil },
  }
end

function dockedClamshellPipArrangementLeft()
  local newPrimary = getWidestScreen()
  local newRight = find(hs.screen.allScreens(), function(screen) return (screen:id() ~= newPrimary:id()) end)
  local newLeft = find(hs.screen.allScreens(),
    function(screen) return (screen:id() ~= newPrimary:id()) and (screen:id() ~= newRight:id()) end)
  local primaryFrame = newPrimary:fullFrame()
  local leftFrame = newLeft:fullFrame()
  local rightFrame = newRight:fullFrame()
  newPrimary:setPrimary()
  newLeft:setOrigin(primaryFrame.x - leftFrame.w, primaryFrame.y)
  newRight:setOrigin(primaryFrame.w + rightFrame.w, primaryFrame.y)
end

function dockedClamshellPipArrangementRight()
  local newPrimary = getWidestScreen()
  local newLeft = find(hs.screen.allScreens(), function(screen) return (screen:id() ~= newPrimary:id()) end)
  local newRight = find(hs.screen.allScreens(),
    function(screen) return (screen:id() ~= newPrimary:id()) and (screen:id() ~= newLeft:id()) end)
  local primaryFrame = newPrimary:fullFrame()
  local leftFrame = newLeft:fullFrame()
  local rightFrame = newRight:fullFrame()
  newPrimary:setPrimary()
  newLeft:setOrigin(primaryFrame.x - leftFrame.w, primaryFrame.y)
  newRight:setOrigin(primaryFrame.w + rightFrame.w, primaryFrame.y)
end

function triScreenArrangementLeft()
  local newPrimary = getNarrowestScreen()
  local newRight = find(hs.screen.allScreens(), function(screen) return (screen:id() ~= newPrimary:id()) end)
  local newLeft = find(hs.screen.allScreens(),
    function(screen) return (screen:id() ~= newPrimary:id()) and (screen:id() ~= newRight:id()) end)
  local primaryFrame = newPrimary:fullFrame()
  local leftFrame = newLeft:fullFrame()
  local rightFrame = newRight:fullFrame()
  newPrimary:setPrimary()
  newLeft:setOrigin(primaryFrame.x - leftFrame.w, primaryFrame.y)
  newRight:setOrigin(primaryFrame.w + rightFrame.w, primaryFrame.y)
end

function triScreenArrangementRight()
  local newPrimary = getNarrowestScreen()
  local newLeft = find(hs.screen.allScreens(), function(screen) return (screen:id() ~= newPrimary:id()) end)
  local newRight = find(hs.screen.allScreens(),
    function(screen) return (screen:id() ~= newPrimary:id()) and (screen:id() ~= newLeft:id()) end)
  local primaryFrame = newPrimary:fullFrame()
  local leftFrame = newLeft:fullFrame()
  local rightFrame = newRight:fullFrame()
  newPrimary:setPrimary()
  newLeft:setOrigin(primaryFrame.x - leftFrame.w, primaryFrame.y)
  newRight:setOrigin(primaryFrame.w + rightFrame.w, primaryFrame.y)
end

function dockedClamshellPipLayout()
  local primaryScreen = getPrimaryScreen();
  local leftScreen = getScreenLeftOfPrimary();
  local rightScreen = getScreenRightOfPrimary();
  return {
    { "Spotify",       nil, leftScreen,    hs.layout.full,    nil, nil },
    { "Mail",          nil, leftScreen,    hs.layout.full,    nil, nil },
    { "Linear",        nil, leftScreen,    hs.layout.full,    nil, nil },
    { "Messages",      nil, rightScreen,   positions.lower50, nil, nil },
    { "Slack",         nil, rightScreen,   positions.full,    nil, nil },
    { "Google Chrome", nil, leftScreen,    positions.full,    nil, nil },
    { "Linear",        nil, leftScreen,    positions.full,    nil, nil },
    { "WebStorm",      nil, primaryScreen, positions.full,    nil, nil },
    { "iTerm2",        nil, primaryScreen, positions.full,    nil, nil },
  }
end

function triScreenLayout()
  local primaryScreen = getPrimaryScreen();
  local leftScreen = getScreenLeftOfPrimary();
  local rightScreen = getScreenRightOfPrimary();
  return {
    { "Spotify",       nil, leftScreen,    hs.layout.full,    nil, nil },
    { "Mail",          nil, leftScreen,    hs.layout.full,    nil, nil },
    { "Messages",      nil, rightScreen,   positions.lower50, nil, nil },
    { "Slack",         nil, rightScreen,   positions.full,    nil, nil },
    { "Google Chrome", nil, leftScreen,    positions.full,    nil, nil },
    { "Linear",        nil, leftScreen,    positions.full,    nil, nil },
    { "WebStorm",      nil, primaryScreen, positions.full,    nil, nil },
    { "iTerm2",        nil, primaryScreen, positions.full,    nil, nil },
  }
end

function applyLayout()
  local numScreens = #hs.screen.allScreens()
  local layout = {}
  local screens = hs.screen.allScreens()

  if numScreens == 1 then
    if screens[1]:name() == laptopScreenName then
      hs.alert.show("Applying 'Undocked Mono' Layout")
      layout = undockedMonoLayout()
    else
      hs.alert.show("Applying 'Docked Mono' Layout")
      layout = dockedMonoLayout()
    end
  elseif numScreens == 3 then
    local isTriScreen = find(hs.screen.allScreens(), function(screen) return (screen:name() == "RTK HDR (1)") end)
    if isTriScreen then
      hs.alert.show("Applying 'Tri-screen' Layout")
      layout = triScreenLayout()
    else
      hs.alert.show("Applying 'Docked Clamshell PIP' Layout")
      layout = dockedClamshellPipLayout()
    end
  end

  hs.layout.apply(layout)
end

hs.hotkey.bind(cmdshift, "2", function()
  local numScreens = #hs.screen.allScreens()
  if numScreens == 3 then
    local isTriScreen = find(hs.screen.allScreens(), function(screen) return (screen:name() == "RTK HDR (1)") end)
    if isTriScreen then
      triScreenArrangementLeft()
    else
      dockedClamshellPipArrangementLeft()
    end
  end

  applyLayout()
end)

hs.hotkey.bind(cmdshift, "3", function()
  local numScreens = #hs.screen.allScreens()
  if numScreens == 3 then
    local isTriScreen = find(hs.screen.allScreens(), function(screen) return (screen:name() == "RTK HDR (1)") end)
    if isTriScreen then
      triScreenArrangementRight()
    else
      dockedClamshellPipArrangementRight()
    end
  end

  applyLayout()
end)

hs.hotkey.bind(cmdshift, "1", function()
  applyLayout()
end)

hs.screen.watcher.new(applyLayout):start()
