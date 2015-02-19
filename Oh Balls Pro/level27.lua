-----------------------------------------------------------------------------------------
--
-- level27.lua
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
	physics.setGravity(0, 9.8)
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
		levelNumber = 27
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
	levelNumber = 27
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
	blueBall:applyLinearImpulse( -1.8, 0, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( -1.8, 0, greenBall.x, greenBall.y )
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
	blueTarget.x, blueTarget.y = 120, 30
	physics.addBody( blueTarget, "static", {isSensor=true, radius=10})
	blueTarget:addEventListener("collision", onBlueCollision)
	group:insert( blueTarget )
	
	blueRedTarget = display.newImageRect( "redTarget.png", 20, 20 )
	blueRedTarget.x, blueRedTarget.y = 120, 30
	physics.addBody( blueRedTarget, "static", {isSensor=true, radius=10})
	blueRedTarget.isVisible = false
	group:insert( blueRedTarget )
	
	greenTarget = display.newImageRect( "greenTarget.png", 20, 20 )
	greenTarget.x, greenTarget.y = 220, 245
	physics.addBody( greenTarget, "static",  {isSensor=true, radius=10})
	greenTarget:addEventListener("collision", onGreenCollision)
	group:insert( greenTarget )
	
	greenRedTarget = display.newImageRect( "redTarget.png", 20, 20 )
	greenRedTarget.x, greenRedTarget.y = 220, 245
	physics.addBody( greenRedTarget, "static", {isSensor=true, radius=10})
	greenRedTarget.isVisible = false
	group:insert( greenRedTarget )
	
	-- make a ball
	blueBall = display.newCircle( 65, 200, 8 )
	blueBall:setFillColor( 0, 0, 255)
	blueBall.myName = "blueBall"
	physics.addBody( blueBall, { density=1.0, friction=0.5, bounce=0.5, radius=8 } )
	group:insert( blueBall )
	
		-- make a ball
	greenBall = display.newCircle( 435, 180, 8)
	greenBall:setFillColor( 0, 255, 0)
	greenBall.myName = "greenBall"
	physics.addBody( greenBall, { density=1.0, friction=0.5, bounce=0.5, radius=8 } )
	group:insert( greenBall )
	
	local redBall = display.newCircle( 59, 10, 25)
	redBall:setFillColor( 128, 0, 0)
	physics.addBody( redBall, { density=10.0, friction=0.5, bounce=0, radius=25 } )
	redBall.gravityScale = 0.1
	group:insert( redBall )
	
	local redBall2 = display.newCircle( 445, 25, 25)
	redBall2:setFillColor( 128, 0, 0)
	physics.addBody( redBall2, { density=10.0, friction=0.5, bounce=0, radius=25 } )
	redBall2.gravityScale = 0.1
	group:insert( redBall2 )
	
	local smallLevelPart = display.newImageRect( "smallLevelPart.png", 40, 20 )
	smallLevelPart.x, smallLevelPart.y = 120, 50
	smallLevelPart.rotation = 0
	physics.addBody( smallLevelPart, "static", { density= 0.1, friction=0.1, bounce=1 } )
	smallLevelPart:addEventListener( "touch", onTouch )
	group:insert( smallLevelPart )
	
	local smallLevelPart2 = display.newImageRect( "smallLevelPart.png", 40, 20 )
	smallLevelPart2.x, smallLevelPart2.y = 320, 50
	smallLevelPart2.rotation = 0
	physics.addBody( smallLevelPart2, "static", { density= 0.1, friction=0.1, bounce=1 } )
	smallLevelPart2:addEventListener( "touch", onTouch )
	group:insert( smallLevelPart2 )
	
	local accelUp = display.newImageRect( "accelUp.png", 25, 25 )
	accelUp.x, accelUp.y = 15, 160
	accelUp.rotation = 360
	physics.addBody( accelUp, "static", { isSensor=true, radius = 11} )
	accelUp.isSleepingAllowed = false
	accelUp:addEventListener("collision", onUpGravityCollision)
	accelUp:addEventListener( "touch", onTouch )
	group:insert( accelUp )
	
	local accelUp2 = display.newImageRect( "accelUp.png", 25, 25 )
	accelUp2.x, accelUp2.y = 380, 160
	accelUp2.rotation = 360
	physics.addBody( accelUp2, "static", { isSensor=true, radius = 11} )
	accelUp2.isSleepingAllowed = false
	accelUp2:addEventListener("collision", onUpGravityCollision)
	accelUp2:addEventListener( "touch", onTouch )
	group:insert( accelUp2 )
	
	
	local levelPart = display.newRect( 200, 170, 100, 20)
	levelPart:setFillColor( 128, 0, 0)
	levelPart.rotation = 90
	physics.addBody( levelPart, { density=0.9, friction=0.5, bounce=0} )
	group:insert( levelPart )
	
	local levelPart2 = display.newRect( 280, 170, 100, 20)
	levelPart2:setFillColor( 128, 0, 0)
	levelPart2.rotation = 90
	physics.addBody( levelPart2, { density=0.9, friction=0.5, bounce=0} )
	group:insert( levelPart2 )
	
	local levelPart3 = display.newRect( 120, 170, 100, 20)
	levelPart3:setFillColor( 128, 0, 0)
	levelPart3.rotation = 90
	physics.addBody( levelPart3, { density=0.9, friction=0.5, bounce=0} )
	group:insert( levelPart3 )
	
	local levelPart4 = display.newRect( 40, 170, 100, 20)
	levelPart4:setFillColor( 128, 0, 0)
	levelPart4.rotation = 90
	physics.addBody( levelPart4, { density=0.9, friction=0.5, bounce=0} )
	group:insert( levelPart4 )
	
	local levelPart5 = display.newRect( 360, 170, 100, 20)
	levelPart5:setFillColor( 128, 0, 0)
	levelPart5.rotation = 90
	physics.addBody( levelPart5, { density=0.9, friction=0.5, bounce=0} )
	group:insert( levelPart5 )
	
	local levelPart6 = display.newRect( 380, 90, 70, 20)
	levelPart6:setFillColor( 255, 255, 255)
	levelPart6.rotation = 0
	physics.addBody( levelPart6, { density=1.0, friction=0.5, bounce=0} )
	levelPart6.isBullet = true
	levelPart6:addEventListener( "touch", onTouch )
	group:insert( levelPart6 )
	
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