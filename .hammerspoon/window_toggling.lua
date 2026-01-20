function toggleAppWindow(appName)
  local app = hs.appfinder.appFromName(appName)
  if app == nil then
    hs.application.launchOrFocus(appName)
  else
    local systemFocusedWindow = hs.window.focusedWindow()

    if systemFocusedWindow == app:focusedWindow() then
      app:hide()
    else
      app:unhide()
      app:activate()
      app:setFrontmost(true)
    end
  end
end

hs.hotkey.bind(optshift, "`", function() toggleAppWindow("Finder") end)
hs.hotkey.bind(cmdshift, "`", function() toggleAppWindow("Mail") end)
hs.hotkey.bind(hyper, "N", function() toggleAppWindow("Notes") end)
hs.hotkey.bind(hyper, "T", function() toggleAppWindow("GoodTask") end)
hs.hotkey.bind(hyper, "M", function() toggleAppWindow("Music") end)
hs.hotkey.bind(hyper, "/", function() toggleAppWindow("Linear") end)
hs.hotkey.bind(hyper, "C", function() toggleAppWindow("WebStorm") end)
hs.hotkey.bind(hyper, "E", function() toggleAppWindow("Entity Pro") end)
