
InputTable = Object:new{depth = 100}

function InputTable.getReverse()
	rt = {}
	for i = 0, love.joystick.getJoystickCount() do
		rt[i] = {}
		for k, v in pairs(ButtonConfig[i]) do rt[i][v] = k end
	end
	return rt
end

ReverseButtonConfig = InputTable.getReverse(ButtonConfig)

function InputTable:getLR(depth) -- Forward/Back. Forward = +1 Neutral = 0 Back = -1
	depth = depth or 2
	rv = 0
	if self[depth] == nil then return 0 end
	if self[depth].left then rv = rv - 1 end
	if self[depth].right then rv = rv + 1 end
	return rv
end

function InputTable:getUD(depth) -- Up/Down. Down = +1 Neutral = 0 
	depth = depth or 2
	rv = 0
	if self[depth] == nil then return 0 end
	if self[depth].up then rv = rv - 1 end
	if self[depth].down then rv = rv + 1 end
	return rv
end

function InputTable:match(pattern, depth)
	depth = depth or 2
	local offset = 0
	for i = 2, 2 + depth do
		local j = i + offset
		if self[j] ~= nil and pattern(self[j]) then
			return true
		end
		if self[j] ~= nil and self[j].hitstop then
			offset = offset + 1 
			i = i - 1 
		end
	end
	return false
end


InputTable.controller = 0

function InputTable.newInput()
	return {up = false, down = false, left = false, right = false, light = false, heavy = false, jump = false, dash = false, start = false, option = false, sway = false, turn = false, hitstop = false, lt = -1, rt = -1}
end

function InputTable:cycleController()
	self.controller = self.controller >= love.joystick.getJoystickCount() and 0 or self.controller + 1
end

function InputTable:isKB()
	return self.controller == 0
end

function InputTable:isActiveController(controller_ID)
	return (controller_ID == self.controller)
end


function InputTable:handleKeyInput(key)
	if self:isKB() then
		if ButtonConfig[self.controller][key] ~= nil then
			local i = self.newInput()
			i[ButtonConfig[self.controller][key]] = true
			self:pushInput(i)
		end
	end
end

function InputTable:handleJoyInput(joystick, button)
	if joystick:getID() == self.controller then
		if ButtonConfig[self.controller][button] then
			local i = self.newInput()
			i[ButtonConfig[self.controller][button]] = true
			self:pushInput(i)
		end
	end
end


function InputTable:getActiveController()
	if self:isKB() then return love.keyboard
	elseif love.joystick.getJoysticks()[self.controller] then
		return love.joystick
	end
	return love.keyboard
end

function InputTable:pushInput(input)
	for k, v in pairs(input) do
		self[1][k] = self[1][k] or v
	end
end

function InputTable:isDown(button)
	local rb = ReverseButtonConfig[InputTable.controller][button]
	local stick_mappings = {left = {-1, 1}, right = {1, 1}, up = {-1, 2}, down = {1, 2}}
	local hat_mappings = {left = "l", right = "r", up = "u", down = "d"}
	local trigger_mappings = {lt = 3, rt = 6}
	
	local tolerance = 0.3
	local t_tolerance = -0.8
	if rb ~= nil then
		-- print(button, rb)
	
		if self:isKB() then
			if love.keyboard.isDown(rb) then
				return true
			end
		else
			local joy = love.joystick.getJoysticks()[InputTable.controller]
			if self.isDirection(button) then
				if joy:getAxis(stick_mappings[button][2]) and joy:getAxis(stick_mappings[button][2]) * stick_mappings[button][1] > tolerance then
					return true
				end
				local hat = joy:getHat(1)
				if string.find(hat, hat_mappings[button]) then
					return true
				end
				
			elseif self.isTrigger(rb) and joy:getAxisCount() >= 6 then
				if joy:getAxis(trigger_mappings[rb]) > t_tolerance then
					return true
				end
			else
				if joy:isDown(rb) then
					return true
				end
			end
		end
	end
	
	return false
end

function InputTable.isDirection(button)
	return (button == "up" or button == "down" or button == "left" or button == "right")
end

function InputTable.isTrigger(button)
	return (button == "lt" or button == "rt")
end

function InputTable:cycleInputs() 
	
	local joy = love.joystick.getJoysticks()[self.controller]
	if (not self:isKB()) then

		if joy:getAxisCount() >= 6 then
			self[1].lt = joy:getAxis(3)
			self[1].rt = joy:getAxis(6)
			
			if self[1].lt > -0.3 and ButtonConfig[InputTable.controller]["lt"] and self[2] and self[2].lt <= 0.3 then
				self[1][ButtonConfig[InputTable.controller]["lt"]] = true
			end
			
			if self[1].rt > -0.3 and ButtonConfig[InputTable.controller]["rt"] and self[2] and self[2].rt <= 0.3 then
				self[1][ButtonConfig[InputTable.controller]["rt"]] = true
			end
		end
	end
	
	local dirs = {"up", "down", "left", "right"}
	for i = 1, #dirs do
		if self:isDown(dirs[i]) then
			self[1][ButtonConfig[InputTable.controller][dirs[i]]] = true
		end
	end
	if self[1].up and self[1].down then -- opposed inputs cancel out each other
		self[1].up = false
		self[1].down = false
	end
	if self[1].left and self[1].right then
		self[1].left = false
		self[1].right = false
	end
	local inp = self.newInput()
	inp.hitstop = (APC.hitstop > 0)
	table.insert(self, 1, inp)
	if #self > self.depth then self[#self] = nil end
end

function InputTable:getKeyHoldLength(button) -- adjust for pad
	if InputTable:isDown(button) then
		local l = 0
		while (l < 60 and InputTable[2+l] ~= nil and InputTable[2+l][button] == false) do
			l = l + 1
		end
		return l		
	end
	return 0
end

Input = Object:new{
	dir = 5,
	maxhold = -1,
	optional = false
}

Sequence_QCF = {
	Input:new{dir = 2},
	Input:new{dir = 3, maxhold = 6},
	-- Input:new{dir = 2, maxhold = 4, optional = true},
	Input:new{dir = 6, maxhold = 4},
	Input:new{dir = 9, maxhold = 4, optional = true},
	Input:new{dir = 5, maxhold = 4, optional = true},
}

Sequence_DP = {
	Input:new{dir = 6},
	Input:new{dir = 5, maxhold = 4, optional = true},
	Input:new{dir = 2, maxhold = 6},
	Input:new{dir = 3, maxhold = 1},
	Input:new{dir = 6, maxhold = 2, optional = true},
	Input:new{dir = 5, maxhold = 2, optional = true},
}

Sequence_66 = {
	Input:new{dir = 5},
	Input:new{dir = 6, maxhold = 10},
	Input:new{dir = 5, maxhold = 8},
	Input:new{dir = 6, maxhold = 3}
}

function InputTable:getNumericDirection(depth)
	local lr = self:getLR(depth) * APC.facing
	local ud = self:getUD(depth) * -1
	
	local numpad = 2 + lr + (1+ud)*3
	return numpad	
end

function InputTable:hasInputSequence(sequence, depth, totalbuffer)
	local m = depth
	local i = 1
	local j = 0
	while m < (depth + totalbuffer) do -- For each part of the sequence.
		
		
		if self:getNumericDirection(m) == sequence[#sequence - i + 1].dir then
			if i == #sequence then return true 
			else j = j + 1 end
		else
			if ((j > 0) or sequence[#sequence - i + 1].optional) then
				i = i + 1
				j = 0
				-- print("i advance", i, "numeric dir", self:getNumericDirection(m), "seq dir", sequence[#sequence - i + 1].dir)
			else 
				return false 
			end
		end
		
		m = m + 1
	end
	return false
	
end

function InputTable:pressed(button, d, buffer)
	buffer = buffer or 6
	buffer = (APC.frame < buffer) and APC.frame or buffer
	local khl = self:getKeyHoldLength(button)
	return (khl > 0 and khl <= buffer) 
end

function InputTable:dumpLog(d)

	d = d or self.depth
	if #self < d then d = #self end
	
	local writeArray = {}
	local gamePath = love.filesystem.getSource()
	local file = assert(io.open(gamePath .. "/log/buttonlog.lua", "w"))
	

	for i = d, 2, -1 do
		writeArray[i] = 'F' .. (i < 10 and '0' or '') .. i .. ' - ' .. InputTable:getNumericDirection(i) .. (InputTable:pressed("light", i, 2) and 'P' or '')	
	end
	
	for i = 2, #writeArray do
		file:write(writeArray[i] or '')
		file:write("\n")
	end
	file:close()
	
	
	print("#######")	
	print("Finished logging the inputtable.")
end

function InputTable:parseSystemInputs()
	if self:match(function (t) return t.start end) then
		love.event.push("quit")
	end
	
	if self:match(function (t) return t.option end) then
		Paused = not Paused
		MenuSystem:toggleCommandListMenu()
	end
end

