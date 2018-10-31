display.setStatusBar( display.HiddenStatusBar )


local storyboard = require "composer"
audio.reserveChannels(1)
audio.setVolume(0.5, { channel=1 })
storyboard.gotoScene( "game" )

