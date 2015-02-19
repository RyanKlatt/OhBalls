-----------------------------------------------------------------------------------------
--
-- level19.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--physics.setDrawMode("hybrid")


local widget = require "widget"
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

local prevFrameTime, currentFrameTime --both nil
local deltaFrameTime = 0
local totalTime = 0
local number = 0
levelSelect = "levelSelect2"

local function roundDec(n, X)
		local d = 10 ^ X  
   
		return math.round(n * d) / d 
	end


	local function enterFrame(e)
     local currentFrameTime = system.getTimer() 

    --if this is still nil, then it is the first frame 
    --so no need to perform calculation 
    if prevFrameTime then 
        --calculate how many milliseconds since last frame 
        deltaFrameTime = currentFrameTime - prevFrameTime
     end 
    prevFrameTime = currentFrameTime 
    --this is the total time in milliseconds 
    totalTime = totalTime + deltaFrameTime 

    --multiply by 0.001 to get time in seconds 
    txt_counter.text = roundDec(totalTime * 0.001, 3)
	number = tonumber(txt_counter.text)
	
	txt_counter:setReferencePoint(display.TopLeftReferencePoint)
	
	txt_counter.x = 170
	txt_counter.y = 288
	
end

local function buttonBack(event)
	storyboard.gotoScene ( event.target.destination, {effect = "slideUp"} )
	print( event.target.destination)
		return true
end

local function buttonStart(event)
	physics.setGravity(4, 0)
	physics.start()
	
end

local function buttonRetry(event)
	storyboard.gotoScene ( event.target.destination, {effect = "slideUp"} )
	print( event.target.destination)
		return true
end

local function onBlueCollision(event)
	local collision = event.other
    if collision.myName == "blueBall" then
        event.contact.isEnabled = true
		blueRedTarget.isVisible = true
		blueBall:removeSelf()
		blueBallRemoved = true
    end
	if (greenBallRemoved == true) and (blueBallRemoved == true) then
		storyboard.gotoScene (  "lvlComplete2" , {effect = "fade", time = 800} )
		lvl1Time = number
		levelNumber = 19
		return lvl1Time
	end
return true
end

local function onGreenCollision(event)
	local collision = event.other
    if collision.myName == "greenBall" then
        event.contact.isEnabled = true
		greenRedTarget.isVisible = true
		greenBall:removeSelf()
		greenBallRemoved = true
    end
	if (greenBallRemoved == true) and (blueBallRemoved == true) then
	storyboard.gotoScene (  "lvlComplete2" , {effect = "fade", time = 800} )
	lvl1Time = number
	levelNumber = 19
	return lvl1Time
	end
return true
end

local function onUpGravityCollision(event)
	local collision = event.other
	if collision.myName == "blueBall" then
	event.contact.isEnabled = true
	blueBall:applyLinearImpulse( 0, -2, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( 0, -2, greenBall.x, greenBall.y )
	end
	
end

local function onDownGravityCollision(event)
	local collision = event.other
	if collision.myName == "blueBall" then
	event.contact.isEnabled = true
	blueBall:applyLinearImpulse( 0, 0.6, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( 0, 0.6, greenBall.x, greenBall.y )
	end
	
end

local function onRightGravityCollision(event)
	local collision = event.other
	if collision.myName == "blueBall" then
	event.contact.isEnabled = true
	blueBall:applyLinearImpulse( 1.2, 0, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( 1.2, 0, greenBall.x, greenBall.y )
	end
	
end

local function onLeftGravityCollision(event)
	local collision = event.other
	if collision.myName == "blueBall" then
	event.contact.isEnabled = true
	blueBall:applyLinearImpulse( -0.6, 0, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( -0.6, 0, greenBall.x, greenBall.y )
	end
	
end

local function onTouch( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		-- Make target the top-most object
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )

		-- Spurious events can be sent to the target, e.g. the user presses 
		-- elsewhere on the screen and then moves the finger over the target.
		-- To prevent this, we add this flag. Only when it's true will "move"
		-- events be sent to the target.
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			t.x = event.x - t.x0
			t.y = event.y - t.y0
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end

	-- Important to return true. This tells the system that the event
	-- should not be propagated to listeners of any objects underneath.
	return true
end

	

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "level1Background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	group:insert( background )
	
	blueTarget = display.newImageRect( "blueTarget.png", 20, 20 )
	blueTarget.x, blueTarget.y = 380, 60
	physics.addBody( blueTarget, "static", {isSensor=true, radius=10})
	blueTarget:addEventListener("collision", onBlueCollision)
	group:insert( blueTarget )
	
	blueRedTarget = display.newImageRect( "redTarget.png", 20, 20 )
	blueRedTarget.x, blueRedTarget.y = 380, 60
	physics.addBody( blueRedTarget, "static", {isSensor=true, radius=10})
	blueRedTarget.isVisible = false
	group:insert( blueRedTarget )
	
	greenTarget = display.newImageRect( "greenTarget.png", 20, 20 )
	greenTarget.x, greenTarget.y = 410, 235
	physics.addBody( greenTarget, "static",  {isSensor=true, radius=10})
	greenTarget:addEventListener("collision", onGreenCollision)
	group:insert( greenTarget )
	
	greenRedTarget = display.newImageRect( "redTarget.png", 20, 20 )
	greenRedTarget.x, greenRedTarget.y = 410, 235
	physics.addBody( greenRedTarget, "static", {isSensor=true, radius=10})
	greenRedTarget.isVisible = false
	group:insert( greenRedTarget )
	
	-- make a ball
	blueBall = display.newCircle( 30, 50, 8 )
	blueBall:setFillColor( 0, 0, 255)
	blueBall.myName = "blueBall"
	physics.addBody( blueBall, { density=1.0, friction=0.5, bounce=0.5, radius=8 } )
	group:insert( blueBall )
	
		-- make a ball
	greenBall = display.newCircle( 25, 170, 8)
	greenBall:setFillColor( 0, 255, 0)
	greenBall.myName = "greenBall"
	physics.addBody( greenBall, { density=1.0, friction=0.5, bounce=0.5, radius=8 } )
	group:insert( greenBall )
	
	local levelPart = display.newRect( 25, 10, 40, 20)
	levelPart:setFillColor( 255, 255, 255)
	levelPart.rotation = 90
	physics.addBody( levelPart, { density=1, friction=0.5, bounce=0.1} )
	levelPart:addEventListener( "touch", onTouch )
	group:insert( levelPart )
	
	local levelPart2 = display.newRect( 25, 220, 40, 20)
	levelPart2:setFillColor( 255, 255, 255)
	levelPart2.rotation = 90
	physics.addBody( levelPart2, { density=1, friction=0.5, bounce=0.1} )
	levelPart2:addEventListener( "touch", onTouch )
	group:insert( levelPart2 )
	
	local levelPart3 = display.newRect( 75, 220, 30, 20)
	levelPart3:setFillColor( 255, 255, 255)
	levelPart3.rotation = 0
	physics.addBody( levelPart3, { density=1, friction=0.5, bounce=0.1} )
	levelPart3:addEventListener( "touch", onTouch )
	group:insert( levelPart3 )
	
	local redBall = display.newCircle( 290, 180, 20)
	redBall.strokeWidth = 5
	redBall:setStrokeColor( 128, 0, 0)
	redBall:setFillColor( 0, 0, 0)
	physics.addBody( redBall, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall )
	
	local redBall2 = display.newCircle( 290, 80, 10)
	redBall2.strokeWidth = 5
	redBall2:setStrokeColor( 128, 0, 0)
	redBall2:setFillColor( 0, 0, 0)
	physics.addBody( redBall2, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall2 )
	
	local redBall3 = display.newCircle( 250, 20, 20)
	redBall3.strokeWidth = 5
	redBall3:setStrokeColor( 128, 0, 0)
	redBall3:setFillColor( 0, 0, 0)
	physics.addBody( redBall3, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall3 )
	
	local redBall4 = display.newCircle( 250, 220, 10)
	redBall4.strokeWidth = 5
	redBall4:setStrokeColor( 128, 0, 0)
	redBall4:setFillColor( 0, 0, 0)
	physics.addBody( redBall4, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall4 )
	
	local redBall5 = display.newCircle( 150, 160, 20)
	redBall5.strokeWidth = 5
	redBall5:setStrokeColor( 128, 0, 0)
	redBall5:setFillColor( 0, 0, 0)
	physics.addBody( redBall5, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall5 )
	
	local redBall6 = display.newCircle( 170, 80, 20)
	redBall6.strokeWidth = 5
	redBall6:setStrokeColor( 128, 0, 0)
	redBall6:setFillColor( 0, 0, 0)
	physics.addBody( redBall6, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall6 )
	
	local redBall7 = display.newCircle( 240, 120, 20)
	redBall7.strokeWidth = 5
	redBall7:setStrokeColor( 128, 0, 0)
	redBall7:setFillColor( 0, 0, 0)
	physics.addBody( redBall7, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall7 )
	
	local redBall8 = display.newCircle( 110, 30, 20)
	redBall8.strokeWidth = 5
	redBall8:setStrokeColor( 128, 0, 0)
	redBall8:setFillColor( 0, 0, 0)
	physics.addBody( redBall8, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall8 )
	
	local redBall9 = display.newCircle( 80, 190, 20)
	redBall9.strokeWidth = 5
	redBall9:setStrokeColor( 128, 0, 0)
	redBall9:setFillColor( 0, 0, 0)
	physics.addBody( redBall9, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall9 )
	
	local redBall10 = display.newCircle( 350, 125, 20)
	redBall10.strokeWidth = 5
	redBall10:setStrokeColor( 128, 0, 0)
	redBall10:setFillColor( 0, 0, 0)
	physics.addBody( redBall10, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall10 )
	
	local redBall11 = display.newCircle( 410, 25, 20)
	redBall11.strokeWidth = 5
	redBall11:setStrokeColor( 128, 0, 0)
	redBall11:setFillColor( 0, 0, 0)
	physics.addBody( redBall11, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall11 )
	
	local redBall12 = display.newCircle( 420, 170, 20)
	redBall12.strokeWidth = 5
	redBall12:setStrokeColor( 128, 0, 0)
	redBall12:setFillColor( 0, 0, 0)
	physics.addBody( redBall12, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	group:insert( redBall12 )
	
	local redBall13 = display.newCircle( 100, 120, 10)
	redBall13.strokeWidth = 5
	redBall13:setStrokeColor( 128, 0, 0)
	redBall13:setFillColor( 0, 0, 0)
	physics.addBody( redBall13, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall13 )
	
	local redBall14 = display.newCircle( 150, 215, 10)
	redBall14.strokeWidth = 5
	redBall14:setStrokeColor( 128, 0, 0)
	redBall14:setFillColor( 0, 0, 0)
	physics.addBody( redBall14, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall14 )
	
	local redBall15 = display.newCircle( 220, 180, 10)
	redBall15.strokeWidth = 5
	redBall15:setStrokeColor( 128, 0, 0)
	redBall15:setFillColor( 0, 0, 0)
	physics.addBody( redBall15, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall15 )
	
	local redBall16 = display.newCircle( 360, 185, 10)
	redBall16.strokeWidth = 5
	redBall16:setStrokeColor( 128, 0, 0)
	redBall16:setFillColor( 0, 0, 0)
	physics.addBody( redBall16, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall16 )
	
	local redBall17 = display.newCircle( 340, 210, 10)
	redBall17.strokeWidth = 5
	redBall17:setStrokeColor( 128, 0, 0)
	redBall17:setFillColor( 0, 0, 0)
	physics.addBody( redBall17, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall17 )
	
	local redBall18 = display.newCircle( 410, 90, 10)
	redBall18.strokeWidth = 5
	redBall18:setStrokeColor( 128, 0, 0)
	redBall18:setFillColor( 0, 0, 0)
	physics.addBody( redBall18, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall18 )
	
	local redBall19 = display.newCircle( 310, 20, 10)
	redBall19.strokeWidth = 5
	redBall19:setStrokeColor( 128, 0, 0)
	redBall19:setFillColor( 0, 0, 0)
	physics.addBody( redBall19, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall19 )
	
	local redBall20 = display.newCircle( 185, 25, 10)
	redBall20.strokeWidth = 5
	redBall20:setStrokeColor( 128, 0, 0)
	redBall20:setFillColor( 0, 0, 0)
	physics.addBody( redBall20, "static", { density=10.0, friction=0.5, bounce=0, radius=10 } )
	group:insert( redBall20 )
	
	-- create a grass object and add physics (with custom shape)
	local levelFloor = display.newImageRect( "staticFloor.png", 1200, 65 )
	levelFloor.x, levelFloor.y = 0, 290
	physics.addBody( levelFloor, "static", { friction=0.3 } )
	group:insert( levelFloor )
	
	local startBtn = display.newImageRect(  "startBtn.png", 50, 50 )
	startBtn.x = 450
	startBtn.y = display.contentHeight  - 30
	startBtn:addEventListener("tap", buttonStart)
	group:insert( startBtn)
	
	local retryBtn = display.newImageRect(  "retryOrExit.png", 50, 50 )
	retryBtn.x = display.screenOriginX + 30
	retryBtn.y = display.contentHeight  - 30
	retryBtn.destination = "retryLevels"
	retryBtn:addEventListener("tap",  buttonRetry)
	group:insert( retryBtn )
	
	local testBtn = display.newImageRect(  "testGravity.png", 50, 50 )
	testBtn.x = 390
	testBtn.y = display.contentHeight  - 30
	testBtn:addEventListener("tap", buttonStart)
	group:insert( testBtn)
	
	txt_counter = display.newText( number, 0, 0, native.systemFont, 20 )
	txt_counter.x = 170
	txt_counter.y = 300
	txt_counter:setTextColor( 255, 255, 255 )
	group:insert( txt_counter )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	storyboard.removeAll()
	lvl1Time = 0
		
	Runtime:addEventListener( "enterFrame", enterFrame )
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	
	blueBallRemoved = false
	greenBallRemoved = false
	
	Runtime:removeEventListener( "enterFrame", enterFrame )
	
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