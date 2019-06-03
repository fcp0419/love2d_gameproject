Baton = require("libs/baton/baton")
Joystick = require("love.joystick")

activeJoystick = 1

InputChannel = love.thread.getChannel("Input")
ButtonConfigChannel = love.thread.getChannel("ButtonConfig")

-- first, note that this method is not Object:new, but the constructor of Baton
-- second, note that Baton is initialized with the argument passed to the thread
Player = Baton.new(unpack(...))


function cleanAxis(x)
	local sign = 0
	if x < 0 then sign = -1
	elseif x > 0 then sign = 1 end
	
	return sign	
end

function compileInputs()
	compiledInputs = {}
	
	for input_code, _ in pairs(Player.config.controls) do
		compiledInputs[input_code] = Player:down(input_code)
	end

	return compiledInputs
end


-- create a channel connection to the main thread

while true do 						-- at the highest possible polling rate, do:
	Player:update() 				-- Update the input object.
	inputs = compileInputs()	-- Compile the current inputs.
	InputChannel:push(inputs)	-- Pass these inputs to the main channel.
end