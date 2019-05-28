Console = Object:new{
	history = Stack:new(),
	textbox = Textbox:new(),
}

function Console:init()
	self.history:push("")
end

function Console:parseCommand(text)
	-- stub.
end

function Console:handleTextInput(key, scancode, isrepeat)
	local keyConsumed, textOutput = self.textbox:handleTextInput(key, scancode, isrepeat)
	
	if textOutput then	
		self.history:push("")
		self:parseCommand(textOutput)
	elseif keyConsumed then
		self.history[#self.history] = self.textbox.text
	else
		return false
	end
	return true
end

ScriptConsole = Console:new{}
ScriptConsole:init()

function ScriptConsole:parseCommand(text)
	print("Received command to parse:", text)
	-- actually execute the fucking command
	
	local components = self:separateText(text)
	if components[1] then
		
	end
	
	
	-- arguments are separated by spaces
	
end

function ScriptConsole.separateText(text)

	local words = {}
	for w in string.gmatch(str, "%S+") do
		table.insert(words, w)
	end
	return words
	
end


--[[

InterfaceLayer_Debug = InterfaceLayer:new{
	activeConsole = false,
	shortcutTable = {},
}

function InterfaceLayer_Debug:drawToCanvas()
end

function InterfaceLayer_Debug:handleKeyboard(key, scancode, isrepeat)
	
end


function InterfaceLayer_Debug:executeShortcut(func)
	-- dummy
	
	-- stuff to do:
	
	-- while in console
		-- ctrl-c, ctrl-v, ctrl-z: copy/paste/cut as expected
		-- f1 <-> prints a list of common commands
		
		-- (command) -h, or invalid command input:
			-- output help
		-- generally hyphen denotes extra modifiers
		
		--
		-- f2 <-> gets your own character ID
		-- f3 <-> gets character ID of moused-over tile
	

	
end

function InterfaceLayer_Debug:toggleConsole()
	if self.activeConsole then
		self.activeConsole = ScriptConsole
	else
		self.activeConsole = false
	end
end

function InterfaceLayer_Debug:handleKeyInput(key, scancode, isrepeat)
	-- general debug keys
	
	local keyConsumed = false
	
	if scancode == "`" then
		self:toggleConsole()
		return true
	else
		-- handle other debug keys first, if I add some
		for k, v in pairs(self.shortcutTable) do
			if k == key then
				self:executeShortcut(v)
			end
		end
	
		local console = self:getActiveConsole()
		if console then
			console:handleTextInput(key, scancode, isrepeat)
			return true	-- open console consumes all other inputs
		end
	end
	
end

]]

