function curry(f)
	return function(x)
		return function(y)
			return f(x, y)
		end
	end
end

-- Example syntax
-- Actor:callEvent()

function Actor:changeStateIfGrounded(state)
	if self:isGrounded() then self:changeState(state) end
end


-- OK so which func programming concept do I need.

-- I want to store inside the frameEvents table a function that requires no arguments.
-- This function is a "packed"
-- Also the actor is introduced externally first.


-- Actor:callEvent(Actor.changeState(self, ))

-- example syntax

-- 

function Actor:addScript(i, con, scr)
	self.state.events[i] = self.state.events[i] or {}
	local ssi = self.state.events[i]
	ssi[#ssi+1] = {condition = self:closure(self.con(self), {})}

end


function Actor:callEvents(i)
	local f = self.state.events[i]
	local sustain = true
	
	if f and (type(f) == "table") then
		for k, v in pairs(f) do
			if sustain and v.condition(self) then
				sustain = self:call(v.action)
			end
		end
	end
end

function Actor:call(str, verbose)
	verbose = false or verbose

	local func = string.match(str, "^(.*)%(")
	local argStr = string.match(str, "%((.*)%)")
	local args = {}

	argStr = string.gsub(str, "%s", "") .. "," -- trim spaces
	for arg in string.gmatch(str, "([%w_]+)%s?,") do args[#args+1] = arg end

	if verbose then
		print("")
		print("Function", func)
		print("ArgStrng", argStr)
		print("Separated Arguments")
		for k, v in pairs(args) do
			print(type(v), v)
		end
		print("Finished logging.")
		print("")
	end
	
	return self[func](self, unpack(args))
end

function Actor:closure(func, args)
	return function (self)
		return func(self, args)
	end
end

function scriptEventTests()
	APC_call("changeState(States.Nun.)", true)
end

-- example scripts in the exec.
--[[

conditions:
	if (Actor.hits[1])
	if (Actor:isGrounded())
	if (not Actor:isGrounded())
	
	

execut
	



]]