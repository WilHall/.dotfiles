function toggleAppWindow(appName)
   local app = hs.appfinder.appFromName(appName)
   if app == nil then
      hs.application.launchOrFocus(appName)
   else
      local focusedWindow = hs.window.focusedWindow()
      local toggleWindow = app:allWindows()[1]

      if focusedWindow:id() == toggleWindow:id() then
        toggleWindow:application():hide()
      else
        toggleWindow:raise()
        toggleWindow:focus()
      end
   end
end

hs.hotkey.bind(cmdshift, "`", function() toggleAppWindow("Airmail") end)
hs.hotkey.bind(hyper, "M", function() toggleAppWindow("Spotify") end)
hs.hotkey.bind(hyper, "B", function() toggleAppWindow("Basecamp 3") end)
