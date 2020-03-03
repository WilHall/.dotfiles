hs.hints.showTitleThresh = 0
hs.hints.style = "vimperator"
hs.hints.fontName = "Fira Code Bold"
hs.hints.fontSize = 30.0

function appWindowHints()
  hs.hints.windowHints(hs.window.focusedWindow():application():allWindows())
end

hs.hotkey.bind(hyper, '.', hs.hints.windowHints)
hs.hotkey.bind(hyper, ',', appWindowHints)
