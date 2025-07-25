-- 
-- Utility Functions
--

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


-- 
-- Screen Names (that we know of; used to call out specific screens in physical space)
--

laptopScreenName = 'Built-in Retina Display'
externalPrimaryScreenName = 'LG HDR DQHD'
externalSecondaryScreenName = 'LG ULTRAGEAR+'

-- 
-- Regions (slots where windows can be)
--

local regions = {
  -- By geometric segmentation
  full = { x = 0, y = 0, w = 1, h = 1 },
  centered = { x = 0.25, y = 0.15, w = 0.5, h = 0.7 },
  center50 = { x = 0.25, y = 0, w = 0.50, h = 1 },
  center30Left = { x = 0.25, y = 0, w = 0.30, h = 1 },
  center50Left = { x = 0.25, y = 0, w = 0.50, h = 1 },
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
  -- By workspace priority
  modalPrimary = { x = 0, y = 0, w = 0.30, h = 1 },
  modalSecondary = { x = 0.30, y = 0, w = 0.50, h = 1 },
  focalPrimary = { x = 0.25, y = 0, w = 0.40, h = 1 },
  focalSecondary = { x = 0, y = 0, w = 0.25, h = 1 },
  peripheralPrimary = { x = 0.65, y = 0, w = 0.15, h = 1 },
  peripheralSecondary = { x = 0.80, y = 0, w = 0.20, h = 1 },
  peripheralTertiary = { x = 0.80, y = 0.5, w = 0.20, h = 0.5 },
}

-- 
-- Screen Finders
--

-- The main screen is the screen containing the currently focused window (https://www.hammerspoon.org/docs/hs.screen.html#mainScreen)
function findMainScreen()
  return hs.screen.mainScreen()
end

-- The primary screen is the screen designated as the "Main Display" in System Preferences Display settings (https://www.hammerspoon.org/docs/hs.screen.html#primaryScreen)
function findPrimaryScreen()
  return hs.screen.primaryScreen()
end

function findScreenLeftOfPrimary()
  return hs.screen.find { x = -1, y = 0 }
end

function findScreenRightOfPrimary()
  return hs.screen.find { x = 1, y = 0 }
end

function findFirstExtendedScreen()
  return find(hs.screen.allScreens(), function(screen) return (screen:id() ~= findPrimaryScreen():id()) end)
end

function findWidestScreen()
  return max(hs.screen.allScreens(), function(a, b) return a:fullFrame().w < b:fullFrame().w end)
end

function findNarrowestScreen()
  return max(hs.screen.allScreens(), function(a, b) return a:fullFrame().w > b:fullFrame().w end)
end

function findLaptopScreen()
  return find(hs.screen.allScreens(), function(screen) return (screen:name() == laptopScreenName) end)

end

function findExternalPrimaryScreen()
  return find(hs.screen.allScreens(), function(screen) return (screen:name() == externalPrimaryScreenName) end)

end

function findExternalSecondaryScreen()
  return find(hs.screen.allScreens(), function(screen) return (screen:name() == externalSecondaryScreenName) end)
end

-- 
-- Layouts
--

-- Macbook Pro undocked with no external screens
function undockedLayout()
  local laptopScreen = getLaptopScreen()
  return {
    { "Arc", nil, externalScreen, regions.full, nil, nil },
    { "WebStorm", nil, laptopScreen, regions.full, nil, nil },
    { "RubyMine", nil, laptopScreen, regions.full, nil, nil },
    { "Rider", nil, laptopScreen, regions.full, nil, nil },
    { "Code", nil, laptopScreen, regions.full, nil, nil },
    { "Fork", nil, laptopScreen, regions.full, nil, nil },
    { "Kaleidoscope", nil, laptopScreen, regions.full, nil, nil },
    { "iTerm2", nil, laptopScreen, regions.full, nil, nil },
    { "BambuStudio", nil, laptopScreen, regions.full, nil, nil },
    { "OrcaSlicer", nil, laptopScreen, regions.full, nil, nil },
    { "Adobe Lightroom", nil, laptopScreen, regions.full, nil, nil },
    { "Blender", nil, laptopScreen, regions.full, nil, nil },
    { "Silhouette Studio", nil, laptopScreen, regions.full, nil, nil },
    { "Slack", nil, laptopScreen, regions.right, nil, nil },
    { "Messages", nil, laptopScreen, regions.rightb25, nil, nil },
      { "Spotify", nil, laptopScreen, regions.modalPrimary, nil, nil },
      { "Mail", nil, laptopScreen, regions.modalPrimary, nil, nil },
  }
end

-- Macbook Pro undocked with one external screen, typically just above the laptop screen
function undockedSidecar()
  local laptopScreen = findLaptopScreen();
  local externalScreen = findFirstExtendedScreen();

  return {
    -- Laptop
    { "WebStorm", nil, laptopScreen, regions.full, nil, nil },
    { "RubyMine", nil, laptopScreen, regions.full, nil, nil },
    { "Rider", nil, laptopScreen, regions.full, nil, nil },
    { "Code", nil, laptopScreen, regions.full, nil, nil },
    { "Fork", nil, laptopScreen, regions.full, nil, nil },
    { "Kaleidoscope", nil, laptopScreen, regions.full, nil, nil },
    { "iTerm2", nil, laptopScreen, regions.full, nil, nil },
    { "BambuStudio", nil, laptopScreen, regions.full, nil, nil },
    { "OrcaSlicer", nil, laptopScreen, regions.full, nil, nil },
    { "Adobe Lightroom", nil, laptopScreen, regions.full, nil, nil },
    { "Blender", nil, laptopScreen, regions.full, nil, nil },
    { "Silhouette Studio", nil, laptopScreen, regions.full, nil, nil },
    { "Slack", nil, laptopScreen, regions.right, nil, nil },
    { "Messages", nil, laptopScreen, regions.rightb25, nil, nil },
      { "Spotify", nil, laptopScreen, regions.modalPrimary, nil, nil },
      { "Mail", nil, laptopScreen, regions.modalPrimary, nil, nil },

    -- External
    { "Arc", nil, externalScreen, regions.full, nil, nil },
  }
end

-- Macbook Pro undocked with two external screens, typically one to each side of the laptop screen
function undockedTriScreen()
  local laptopScreen = findLaptopScreen();
  local leftScreen = findSCreenLef();
  local rightScreen = getScreenRightOfPrimary();

  return {
    -- Left
    { "Arc", nil, leftScreen, regions.full, nil, nil },

    -- Laptop
    { "WebStorm", nil, laptopScreen, regions.full, nil, nil },
    { "RubyMine", nil, laptopScreen, regions.full, nil, nil },
    { "Rider", nil, laptopScreen, regions.full, nil, nil },
    { "Code", nil, laptopScreen, regions.full, nil, nil },
    { "Fork", nil, laptopScreen, regions.full, nil, nil },
    { "Kaleidoscope", nil, laptopScreen, regions.full, nil, nil },
    { "iTerm2", nil, laptopScreen, regions.full, nil, nil },
    { "BambuStudio", nil, laptopScreen, regions.full, nil, nil },
    { "OrcaSlicer", nil, laptopScreen, regions.full, nil, nil },
    { "Adobe Lightroom", nil, laptopScreen, regions.full, nil, nil },
    { "Blender", nil, laptopScreen, regions.full, nil, nil },
    { "Silhouette Studio", nil, laptopScreen, regions.full, nil, nil },
      { "Spotify", nil, laptopScreen, regions.modalPrimary, nil, nil },
      { "Mail", nil, laptopScreen, regions.modalPrimary, nil, nil },

    -- Right
    { "Slack", nil, rightScreen, regions.full, nil, nil },
    { "Messages", nil, rightScreen, regions.right, nil, nil },
  }
end

-- Macbook Pro docked with two external ultrawide screens stacked vertically
function dockedWithDualVerticalUlrawideLayout()
  local externalPrimaryScreen = findExternalPrimaryScreen()
  local externalSecondaryScreen = findExternalSecondaryScreen()

  return {
    -- Ultrawide Lower
    { "Arc", nil, externalPrimaryScreen, regions.focalSecondary, nil, nil },
      { "Spotify", nil, externalPrimaryScreen, regions.modalPrimary, nil, nil },
      { "Mail", nil, externalPrimaryScreen, regions.modalPrimary, nil, nil },
    { "WebStorm", nil, externalPrimaryScreen, regions.focalPrimary, nil, nil },
    { "RubyMine", nil, externalPrimaryScreen, regions.focalPrimary, nil, nil },
    { "Rider", nil, externalPrimaryScreen, regions.focalPrimary, nil, nil },
    { "Code", nil, externalPrimaryScreen, regions.focalPrimary, nil, nil },
      { "Fork", nil, externalPrimaryScreen, regions.modalSecondary, nil, nil },
      { "Kaleidoscope", nil, externalPrimaryScreen, regions.modalSecondary, nil, nil },
    { "iTerm2", nil, externalPrimaryScreen, regions.peripheralPrimary, nil, nil },
    { "Slack", nil, externalPrimaryScreen, regions.peripheralSecondary, nil, nil },
    { "Messages", nil, externalPrimaryScreen, regions.peripheralTertiary, nil, nil },

    -- Ultrawide Upper
    { "BambuStudio", nil, externalSecondaryScreen, regions.focalPrimary, nil, nil },
    { "OrcaSlicer", nil, externalSecondaryScreen, regions.focalPrimary, nil, nil },
    { "Adobe Lightroom", nil, externalSecondaryScreen, regions.focalPrimary, nil, nil },
    { "Blender", nil, externalSecondaryScreen, regions.focalPrimary, nil, nil },
    { "Silhouette Studio", nil, externalSecondaryScreen, regions.focalPrimary, nil, nil },
  }
end

function applyLayout()
  local numScreens = #hs.screen.allScreens()
  local layout = {}
  local screens = hs.screen.allScreens()

  if numScreens == 1 then
    hs.alert.show("⇝ Layout: Undocked")
    layout = undockedLayout()
  elseif numScreens == 2 then
    local undocked = find(hs.screen.allScreens(), function(screen) return (screen:name() == laptopScreenName) end)

    if unocked then
      hs.alert.show("⇝ Layout: Undocked Sidecar")
      layout = undockedSidecar()
    else
      hs.alert.show("⇝ Layout: Docked Dual Vertical Ultrawide")
      layout = dockedWithDualVerticalUlrawideLayout()
    end
  elseif numScreens == 3 then
    hs.alert.show("⇝ Layout: Tri-screen")
    layout = undockedTriScreen()
  end

  hs.layout.apply(layout)
end

hs.hotkey.bind(cmdshift, "1", function()
  applyLayout()
end)

hs.screen.watcher.new(applyLayout):start()
