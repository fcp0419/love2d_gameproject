-- Note that this file is a separate thread, and therefore a separate environment. It shares no functions at all with the main environment.

-- The thread automatically requires filesystem and thread modules.

Baton = require("libs/baton/baton")
Joystick = require("love.joystick")
Timer = require("love.timer")

activeJoystick = 1

InputChannel = love.thread.getChannel("Input")
InputRequestChannel = love.thread.getChannel("InputRequest")




-- first, note that this method is not Object:new, but the constructor of Baton
-- second, note that Baton is initialized with the argument passed to the thread, which in this case is the exact button configuration
Player = Baton.new(unpack(...))

initial_time, elapsed_time, sleep_time = 0, 0, 0




function newCompiledInput()
	local cpi = {}
	for input_code, _ in pairs(Player.config.controls) do
		cpi[input_code] = {}
	end
	cpi.direction = {}
	
	return compiledInputs
end

function hasDirectionChanged()
	for k, v in ipairs({"left", "right", "up", "down"}) do
		if Player:pressed(v) or Player:released(v) then
			return true
		end
	end
	return false
end

function getDirection()
	local left_right = (Player:down("left") and -1 or 0) + (Player:down("right") and 1 or 0)
	local up_down = (Player:down("down") and -1 or 0) + (Player:down("up") and 1 or 0)
	
	return ((left_right + 2)  + 3*(up_down + 1))
end


function appendInputs(compiledInput)
	compiledInput = compiledInput or newCompiledInput()

	for input_code, _ in pairs(Player.config.controls) do
		if Player:pressed(input_code) then
			table.insert(compiledInput[input_code], 1)
		end
		if Player:released(input_code) then
			table.insert(compiledInput[input_code], -1)
		end
	end
	
	if hasDirectionChanged() then
		table.insert(compiledInput[direction], getDirection())
	end
	
	return compiledInput
end


-- create a channel connection to the main thread

polling_interval = 0.001	-- update inputs every X seconds - in this case, every millisecond.

while true do 	-- Constantly poll for inputs, as following:
	initial_time = love.timer.getTime()
	
	Player:update()	-- Update the input object, getting which buttons are down in the current time step.
	compiledInput = appendInputs(compiledInput)	-- Append any button information that has changed to the compiled input.
	
	if InputRequestChannel:pop() then		-- Should we have received a request to supply the input data to the main thread:
		InputChannel:supply(compiledInput)	-- Supply the data
		compiledInput = newCompiledInput()	-- Reset the compiled input
	end
	
	elapsed_time = love.timer.getTime() - initial_time
	sleep_time = math.max(0, polling_interval - elapsed_time)
	
	love.timer.sleep(sleep_time)				-- Limit the execution rate to polling_interval, ie to once every millisecond.
end