hs.hotkey.bind(hyper, 'L', function()
  local result = hs.caffeinate.toggle("displayIdle")
  if result == true then
    hs.alert.show("Preventing display sleep")
  else
    hs.alert.show("Allowing display sleep")
  end
end)

hs.hotkey.bind(ctrlopt, 'L', hs.caffeinate.lockScreen)

