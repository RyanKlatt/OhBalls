--howTo.lua

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local MainBtn
local LearnBtn

-- 'onRelease' event listener for levelSelectBtn
local function onMainBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "menu", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onLearnBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "howTo2", "fade", 500 )
	
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "howToBackground.png", display.contentWidth, display.contentHeight*.9 )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	
	-- create a widget button (which will loads level selection on release)
	mainBtn = widget.newButton{
		label="Main Menu",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=134, height=30,
		onRelease = onMainBtnRelease	-- event listener function
	}
	mainBtn:setReferencePoint( display.CenterReferencePoint )
	mainBtn.x = display.contentWidth*0.5
	mainBtn.y = 305
	
	learnBtn = widget.newButton{
		label="Learn More",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=134, height=30,
		onRelease = onLearnBtnRelease	-- event listener function
	}
	learnBtn:setReferencePoint( display.CenterReferencePoint )
	learnBtn.x = display.contentWidth*0.5 + 160
	learnBtn.y = 305
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( mainBtn )
	group:insert( learnBtn )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	storyboard.removeAll()
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene