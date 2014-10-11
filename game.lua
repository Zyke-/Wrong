----------------------------------------------------------------------------------
--
-- Game
--
----------------------------------------------------------------------------------

local composer = require "composer" 
local api = require "modules.api"
local scene = composer.newScene()
local xml = require("xml").newParser()

local question
local sceneGroup = {}
local c = {1, 1, 1}
local b, s
local qbox, qrect, qset
local a1box, a1rect, a1set
local a2box, a2rect, a2set

local timeLimit = 5
local timeLeft
local score = 0
local args = {
    effect = "flip",
    time = 400,
    params = { score = score }
}

function loadXML()
	local app = xml:loadFile("xml.xml")
	question = {}
	for i = 1, #app.child do		
		question[i] = app.child[i]
	end
end

---------------------------------------------------------------------------------
function gameOver()
	--stop timer
	args.params.score = score
	composer.showOverlay("results", args)
end

function scene:create( event )
	sceneGroup = self.view
	loadXML()

	b = rect(b, centerX, centerY, W, H, c, true)
	s = rect(s, centerX, centerY, 10, H, {.9, .9, .9}, true)

	qbox = display.newGroup()
	a1box = display.newGroup()
	a2box = display.newGroup()
	
	qrect = rect(qrect, 0, 0, W-2, centerY-250, c, true) 
		qrect:setStrokeColor( .9, .9, .9 )
	a1rect = rect(a1rect, 0, 0, W/2, 500, {.1, .1, .9, .4}, true)
	a2rect = rect(a2rect, 0, 0, W/2, 500, {.9, .1, .1, .4}, true)

	qbox:insert(qrect)
	a1box:insert(a1rect)
	a2box:insert(a2rect)

	function genQuestion(first)
		if not first then
			local newRandQ = math.random(1, #question )
			while rewRandQ == randQ do
				newRandQ = math.random(1, #question )
				print( randQ )
			end
			randQ = newRandQ	
			newRandQ = nil

			q:removeSelf()
			a1:removeSelf()
			a2:removeSelf()
			q, a1, a2 = nil
		elseif first then
			randQ = math.random(1, #question )
		end
		r = question[randQ].child[4].value
		local n = math.random(2, 3)
		local m = math.random(2, 3)
		while n == m do
			m = math.random(2, 3)
		end

		local qopt = {
			parent = qbox,
		    text = tostring(question[randQ].child[1].value),     
		    x = centerX,
		    y = (centerY-250)/2,
		    width = W-10,     
		    font = native.systemFontBold,   
		    fontSize = 16,
		    align = "center"}
		local a1opt = {
			parent = a1box,
		    text = tostring(question[randQ].child[n].value),     
		    x = W/4,
		    y = centerY,
		    width = (W/2)-10,     
		    font = native.systemFontBold,   
		    fontSize = 18,
		    align = "center"}
		local a2opt = {
			parent = a2box,
		    text = tostring(question[randQ].child[m].value),     
		    x = W-(W/4),
		    y = centerY,
		    width = (W/2)-10,     
		    font = native.systemFontBold,   
		    fontSize = 18,
		    align = "center"}

		q = display.newText( qopt )
		a1 = display.newText( a1opt )
		a2 = display.newText( a2opt )
		a1.t = tostring(question[randQ].child[n].value)
		a2.t = tostring(question[randQ].child[m].value)

		q:setFillColor( 0, 0, 0 )
		a1:setFillColor( 1, 1, 1 )		
		a2:setFillColor( 1, 1, 1 )
		setPos(qrect, centerX, qrect.height/2)
		setPos(a1rect, a1rect.width/2-5, centerY+50)
		setPos(a2rect, W-(a2rect.width/2)+5, centerY+50)

		setPos(qbox, W, 0)
		setPos(a1box, -W, 0)
		setPos(a2box, W, 0)

		transition.to( qbox, { time = 500, x = 0, transition = easing.outExpo } )
		transition.to( a1box, { time = 500, x = 0, transition = easing.outExpo } )
		transition.to( a2box, { time = 500, x = 0, transition = easing.outExpo } )
	end
	genQuestion(true)

	a1box:addEventListener("touch", a1box)
	a2box:addEventListener("touch", a1box)

	function a1box:touch (e)
		local phase = e.phase
		if phase == "ended" then
			if e.target[2].t == r then
				score = score + 1
				--transition.to( qbox, { time = 500, x = -W, transition = easing.outExpo } )
				--transition.to( a1box, { time = 500, x = -W, transition = easing.outExpo } )
				--transition.to( a2box, { time = 500, x = W, transition = easing.outExpo } )
				genQuestion(false)
			else
				gameOver()
			end
		elseif phase == "cancelled" then

		end
	end
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		

	elseif phase == "did" then
	--	transition.to( qbox, { time = 1000, x = 0, transition = easing.outExpo } )
	--	transition.to( a1box, { time = 1000, x = 0, transition = easing.outExpo } )
	--	transition.to( a2box, { time = 1000, x = 0, transition = easing.outExpo } )

	timeLeft = display.newText(timeLimit, 75, 75, native.systemFontBold, 40)
	timeLeft:setFillColor(0, 0, 0)

	local function timerDown()
	  	timeLimit = timeLimit - 1
	  	timeLeft.text = timeLimit
	    if timeLimit == 0 then
	        gameOver()
	    end
	end
	timer.performWithDelay(1000,timerDown,timeLimit)
		
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene