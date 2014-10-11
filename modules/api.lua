----------------------------------------------------------------------------------
--
-- Vince Games API 2013-2014
--
----------------------------------------------------------------------------------

api = {}

local mCeil = math.ceil
local mAtan2 = math.atan2
local mPi = math.pi
local mSqrt = math.sqrt
math.randomseed(os.time())	--> make random more random
local mRand = math.random
local tInsert = table.insert
local tRemove = table.remove
local tForEach = table.foreach

W, H = display.viewableContentWidth, display.viewableContentHeight 
centerX = W / 2
centerY = H / 2

function getVesion()
	local ver = tostring(Version) .. "." .. tostring(Build)
	return ver
end

function setPos(obj, x, y)
	obj.x = x
	obj.y = y

	return
end

function getPos(obj)
	x = obj.x
	y = obj.y

	return x, y
end

function getSize(obj)
	w = obj.viewableContentWidth
	h = obj.viewableContentHeight

	return w, h
end

function setScale(obj, aScale)
	obj.xScale = aScale
	obj.yScale = aScale

	return
end

function randomImage(folder, suffix)
	img = tostring(folder) .. "/" .. tostring(suffix) .. tostring(math.random(2, 5)) .. ".png"

	return img    
end

function cancelTween(obj)
	if obj.tween ~= nil then
		transition.cancel(obj.tween)
		obj.tween = nil
	end
end

function cancelTimer(timerName)
	timerName:cancel()
	timerName = nil
end

function sleep(amount, action)
	local sleepT = timer.performWithDelay(amount, action, 1)

	return
end

function rect(name, x, y, w, h, c, v)			-- Create a rect
	local name = display.newRect( x, y, w, h )
	name:setFillColor( c[1], c[2], c[3] )
	name.isVisible = v
	return name
end

--=====================================================
-- Data saving and loading

function saveValue( strFilename, strValue )
	-- will save specified value to specified file
	local theFile = strFilename
	local theValue = strValue
	
	local path = system.pathForFile( theFile, system.DocumentsDirectory )
	
	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "w+" )
	if file then
	   -- write game score to the text file
	   file:write( theValue )
	   io.close( file )
	end
end

function loadValue( strFilename )
	-- will load specified file, or create new file if it doesn't exist
	
	local theFile = strFilename
	
	local path = system.pathForFile( theFile, system.DocumentsDirectory )
	
	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "r" )
	if file then
	   -- read all contents of file into a string
	   local contents = file:read( "*a" )
	   io.close( file )
	   return contents
	else
	   -- create file b/c it doesn't exist yet
	   file = io.open( path, "w" )
	   file:write( "0" )
	   io.close( file )
	   return "0"
	end
end

--=====================================================
-- Timers, Pause, Resume, and Cancel All Timers

isActive = true		--> when set to false, all animation stops (great for game pausing)

activeTimers = {}	--> table that will hold active timers created with performAfterDelay()
objectsTable = {}	--> table that will hold all objects created with newObject()

function performAfterDelay( secondsToWait, functionToCall, howManyTimes, isFps60, timerNameString )
	
	-- USAGE: performAfterDelay( secondsToWait, functionToCall, howManyTimes, isFps60 )
	
	local newTimer = {}
	local theFPS
	local iterations
	local isInfinite = false
	
	local frameCounter = 1
	local timerIsActive = true
	
	local maxFrameCount
	
	local theEvent = {}
	theEvent.name = "timer"
	theEvent.count = 0
	
	--newTimer.myPosition = #activeTimers + 1
	
	if timerNameString then
		newTimer.myName = timerNameString
	else
		newTimer.myName = "unnamed timer"
	end
	
	if not secondsToWait then
		secondsToWait = 1.0
	end
	
	if not howManyTimes then
		iterations = 1
	else
		iterations = howManyTimes
		
		if iterations == 0 then
			iterations = -1
			isInfinite = true
		end
	end
	
	if isFps60 then
		theFPS = 60
		maxFrameCount = mCeil(secondsToWait * 60)
	else
		theFPS = 30
		maxFrameCount = mCeil(secondsToWait * 30)
	end
	
	local timerListener = function( event )
		if timerIsActive then
			
			if not isInfinite then
				-- FINITE Amount of Timer Fires:
				
				if frameCounter >= maxFrameCount and iterations > 0 then
					frameCounter = 1				--> reset frame counter
					iterations = iterations - 1		--> decrement iterations
					
					theEvent.count = theEvent.count + 1	--> increment event count
					
					-- execute function passed as 'functionToCall'
					if functionToCall and type(functionToCall) == "function" then
						functionToCall( theEvent )
					end
					
				elseif frameCounter < maxFrameCount and iterations > 0 then
					-- increment frame count
					frameCounter = frameCounter + 1
				elseif iterations == 0 then
					
					-- stop counter
					newTimer:cancel()
				end
				
			else
				-- INFINITE Amount of Timer Fires:
				
				if frameCounter >= maxFrameCount then
					frameCounter = 1		--> reset frame counter
					theEvent.count = theEvent.count + 1	--> increment event count
					
					-- execute function passed as 'functionToCall'
					if functionToCall and type(functionToCall) == "function" then
						functionToCall( theEvent )
					end
				else
					frameCounter = frameCounter + 1
				end
				
			end
		end
	end
	
	function newTimer:enterFrame( event )
		self:repeatFunction( event )
	end
	
	function newTimer:cancel()
		frameCounter = 1
		timerIsActive = false
		Runtime:removeEventListener( "enterFrame", self )
		
		local removeEntry = function( _index )
			if activeTimers[_index] == self then
				tRemove( activeTimers, _index )
			end
		end
		
		--tRemove( activeTimers, self.myPosition )
		tForEach( activeTimers, removeEntry )
		
		--self.myPosition = nil
		self = nil
	end
	
	function newTimer:pause()
		-- These timers will be paused/resumed outside of normal game.isActive pausing features.
		-- They must be started, stoped, paused, and resumed individually.
		
		timerIsActive = false
	end
	
	function newTimer:resume()
		timerIsActive = true
	end
	
	newTimer.repeatFunction = timerListener
	Runtime:addEventListener( "enterFrame", newTimer )
	
	--activeTimers[ newTimer.myPosition ] = newTimer
	tInsert( activeTimers, newTimer )
	
	return newTimer
end

function pauseAllTimers()
	
	local i
	local activeTimerCount = #activeTimers
	
	if activeTimerCount > 0 then
		for i = activeTimerCount,1,-1 do
			local child = activeTimers[i]
			child:pause()
		end
	end
end

function resumeAllTimers()
	
	local i
	local activeTimerCount = #activeTimers
	
	if activeTimerCount > 0 then
		for i = activeTimerCount,1,-1 do
			local child = activeTimers[i]
			child:resume()
		end
	end
end

function cancelAllTimers()
	
	local i
	local activeTimerCount = #activeTimers
	
	if activeTimerCount > 0 then
		
		for i = activeTimerCount,1,-1 do
			local child = activeTimers[i]
			child:cancel()
			child = nil
		end
		
	end
end

function unrequire(m)
    package.loaded[m] = nil
    _G[m] = nil
end

--=====================================================

return api