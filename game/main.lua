-- This file is needed for LOVE to execute the game. Aside from that, it defines the basic callbacks, and adds the most fundamental data structures/options.


_LOADTIME = 0
Paused = false
love.graphics.setLineWidth(1)

love.graphics.setDefaultFilter("nearest", "nearest", 0)
love.graphics.setFont(love.graphics.newFont(12))


utf8 = require("utf8")
__DEBUGMODE = true



__gamesize = {960, 540}


-- Add OOP to lua - very useful for games
Object = {}
setmetatable(Object, {__newindex = function(t, k, v) rawset(t, k, v) end})

function Object:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

-- define other basic, unnamespaced functions.

function isInTable(t, o)
	for k, v in pairs(t) do
		if v == o then return true end
	end
	return false
end

function sgn(x)
	if x < 0 then return -1 end
	if x > 0 then return 1 end
	return 0
end

function append(tab, item)
	tab[#tab+1] = item
send

function map(func, tab)	-- map a function onto all elements of a table.
	-- !! WARNING - this WILL produce unexpected results when applied to tables with metamethods, such as objects. Every element of a table does include its functions, in the case of an object.
	local newtab = {}
	for k, v in pairs(tab) do
		newtab[k] = func(v)
	end
	return newtab	
end

function imap(func, array) -- map a function onto all elements of an array.
	local newarray = {}
	for i, v in ipairs(array) do
		newarray[i] = func(v)
	end
	return newarray
end

function memoize(f, arg) -- bake exactly one argument into a function.
	local g = function()
		return f(arg)
	end
	return g
end

function reverse_ipairs(arr) -- ipairs, running from array end to array beginning
	-- At least I hope that's what it does since I'm really not used to iterators/closures yet
	local n = #arr
	return function()
		if arr[n] then
			n = n - 1
			return n+1, arr[n+1]
		else
			return nil, nil
		end	
	end
end

function zip(arr1, arr2) -- given two arrays, one of keys and one of values, returns a table where each key is associated to a value.
	local t = {}
	assert(#arr1 == #arr2, "Zip error: Both arrays must be of the same length!")	
	for i = 1, #arr1 do
		t[arr1[i]] = arr2[i]
	end
	return t
end

function round(i)
	return math.floor(i + 0.5)
end

function runProfi()
	profi_timer = profi_timer - dt
	if profi_timer < 0 and profi_running then
		ProFi:stop()
		ProFi:writeReport('ProfilingReport.txt')
		profi_running = false
	end	
	
end



LoadManager = {}
Knife = {}
T = function() end
profi_enabled = false



function LoadManager.loadData(file_path, exit_on_error)	
	-- loads a file, then executes it as a chunk. 
	-- If an error occurs, it returns the stack trace of the error instead and prints it to the console.

	exit_on_error = exit_on_error or false
	local success, loaded_chunk, chunk_execution_result
	local loadSpecifiedFile = memoize(love.filesystem.load, file_path)
	
	success, loaded_chunk = xpcall(loadSpecifiedFile, debug.traceback)
	if not success then
		print("The following error happened while loading file " ..  file_path .. ":")  
		print(tostring(loaded_chunk))
		if exit_on_error then
			love.event.push('quit')
		end
	else
		success, chunk_execution_result = xpcall(loaded_chunk, debug.traceback)
		if not success then
			print("The following error happened while loading file " ..  file_path .. ":")
			print(tostring(chunk_execution_result))
			if exit_on_error then
				love.event.push('quit')
			end
		else
			print("Loaded file " .. file_path .. " successfully.")
			return chunk_execution_result
		end
	end
	return nil
end


function LoadManager.loadEngine()
	-- loads the static parts of the engine, intended to be 100% reuseable between different games.
	LoadManager.loadData("engine/logging.lua")
	LoadManager.loadData("engine/basics.lua")
	LoadManager.loadData("engine/interface.lua")
	LoadManager.loadData("engine/devtools.lua")
 
end

function LoadManager.loadLibraries()
	-- load, and bind, all used 3rd party libraries
	Knife.serialize = require("libs/knife/serialize")
	Knife.test = require("libs/knife/test")
	T = Knife.test

	Baton = require("libs/baton/baton")
end


function LoadManager.loadGame()
	LoadManager.loadData("_loadorder.lua")
	for k, v in ipairs(loadOrder) do
		LoadManager.loadData(v)
	end
end


function LoadManager.initInputThread()

	InputHandlingThread = love.thread.newThread("engine/thread_inputhandler.lua")
	
	local configTable = {
		controls = {
			left = {'key:left', 'axis:leftx-', 'button:dpleft'},
			right = {'key:right', 'axis:leftx+', 'button:dpright'},
			up = {'key:up', 'axis:lefty-', 'button:dpup'},
			down = {'key:down', 'axis:lefty+', 'button:dpdown'},
			confirm = {'key:y', 'button:a'},
			cancel = {'key:x', 'button:b'},
			menu = {'key:escape', 'button:start'},
			pause = {'key:backspace', 'key:pause', 'button:select'},
			attack = {'key:g', 'button:x'},
			special = {'key:f', 'button:y'},
			breaker = {'key:b', 'button:b'},
			dash = {'key:s', 'button:lb', 'button:rb'},
			jump = {'key:space', 'button:a'},
			enhance = {'key:v', 'axis:triggerleft', 'axis:triggerright'},
		},
		
		joystick = Joystick.getJoysticks()[activeJoystick],
	}
	
	InputChannel = love.thread.getChannel("Input")
	InputRequestChannel = love.thread.getChannel("InputRequest")
	
	InputHandlingThread:start(configTable)

end

function LoadManager.loadMods()	-- dummy, no mod support as of now.
end



function LoadManager.loadAll()
	LoadManager.loadEngine()
	LoadManager.loadLibraries()
	LoadManager.initInputThread()
	LoadManager.loadGame()
	LoadManager.loadMods()
	LoadManager.runTests()
	TestLog:writeToTextFile()
end

function LoadManager.runTests()	-- runs all tests in the /tests/ folder. Since this is a legacy project, however, there's barely any tests written.
	testfilelist = love.filesystem.getDirectoryItems("tests")
	for k, v in ipairs(testfilelist) do
		if string.match(v, "%.lua$") then -- for all lua files
			TestLog:record("")
			TestLog:record("### Testing file " .. v)
			LoadManager.loadData("tests/" .. v)
			TestLog:record("")
			TestLog:record("")
		end
	end
end

function initInputTable()
	InputTable[1] = InputTable.newInput()
	InputTable[2] = InputTable.newInput()
	if not love.joystick.getJoysticks()[InputTable.controller] then
		InputTable.controller = 0
	end
end

function LoadManager.runMiscStartup()
	love.filesystem.setIdentity("Nunpuncher")

	initializeStates()
	tick_timer = 1 / 60 -- silky smooth 60 fps.

	next_time = love.timer.getTime()
	
	-- onceonly = true
		-- onceonly does not appear to be used at the moment, even though I

	initTestStage()
	initInputTable()

	GameStateManager:setActiveStage(TestStage)
	
	Interface:activateLayer("main_game")
	Interface:activateLayer("main_game_UI")

	test_music:setLooping(true)
	test_music:setVolume(0.55)	
end


-- LOVE callbacks start here




function love.load()
	LoadManager.loadAll()
	LoadManager.runMiscStartup()
end


function love.keypressed(key, scancode, isrepeat)
	Interface:handleKeyboard(key, scancode, isrepeat)
end

function love.joystickpressed(joystick, button)	
	Interface:handleJoystick(joystick, button)
end






function love.update(dt)
	constantFPS(FPS, 0.2)
		-- Note that despite taking a variable DT, this game runs at a fixed 60 fps, that is, 60 ticks per second.
		-- 
	
	InputTable:recordInputs()

	if not Paused then	
		ActiveStage:step(tick_timer)
	end
	
	Interface:updateCameraPosition()
	Interface:updateFX()
end



-- function love.update(dt)
	--	stuff relating to the main game loop
-- end

function love.draw()
	Interface:draw()
end


 
local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

-- with thanks to the LÖVE forums
-- it may be necessary to spin off input handing into its own thread, so that constantFPS doesn't sleep it either
function constantFPS(fps_constantFPS, tolerance_constantFPS)
    do
        local fps, tolerance, loopTime, loopDelay = fps_constantFPS, tolerance_constantFPS, loopTime_constantFPS, loopDelay
        if loopTime == nil then loopTime = 0 end
        love.timer.sleep((1/fps)*tolerance)
        local loopTime = loopTime - love.timer.getTime()
        local loopDelay = love.timer.getTime() + loopTime
        while love.timer.getTime() - loopDelay < (1/fps) do end
    end
    loopTime_constantFPS = love.timer.getTime()
end


-- misc system callbacks

function love.errorhandler(msg)
	msg = tostring(msg)
 
	error_printer(msg, 2)
 
	if not love.window or not love.graphics or not love.event then
		return
	end
 
	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end
 
	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
 
	love.graphics.reset()
	local font = love.graphics.setNewFont(14)
 
	love.graphics.setColor(1, 1, 1, 1)
 
	local trace = debug.traceback()
 
	love.graphics.origin()
 
	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)
 
	local err = {}
 
	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)
 
	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end
 
	table.insert(err, "\n")
 
	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end
 
	local p = table.concat(err, "\n")
 
	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")
 
	local function draw()
		local pos = 70
		love.graphics.clear(89/255, 157/255, 220/255)
		love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.present()
	end
 
	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
		draw()
	end
 
	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end
 
	return function()
		love.event.pump()
 
		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end
 
		draw()
 
		if love.timer then
			love.timer.sleep(0.1)
		end
	end
 
end

