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
hs.hotkey.bind(hyper, "M", function() toggleAppWindow("Spotify") end)
hs.hotkey.bind(hyper, "B", function() toggleAppWindow("Basecamp 3") end)
