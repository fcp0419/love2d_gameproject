-- This file defines basic file structures.



Stack = Object:new{pointer = 1} -- first in, first out

function Stack:reset()
	local l = #self
	for i = 1, l do
		self[i] = nil
	end
	self.pointer = 1
end

function Stack:copy(proto_stack)

	stack_to_copy = Stack:new(proto_stack)
	-- print(stack_to_copy.pointer, #stack_to_copy)

	self:reset()
	-- print(stack_to_copy.pointer, #stack_to_copy)
	
	while (stack_to_copy:isEmpty() == false) do
		local value = stack_to_copy:pop()
		-- print("Popped value", val)
		self:push(stack_to_copy:pop())
	end
end


function Stack:compress()
	self:copy(self)
end

function Stack:isEmpty()
	if self[self.pointer] then return false end
	return true
end

function Stack:push(x)
	self[#self+1] = x
end

function Stack:pop()
	-- I am severely questioning whether I implemented a stack or a queue here
	if self[self.pointer] then
		local p = self[self.pointer]
		self.pointer = self.pointer + 1
		return p
	end
	return nil
end


LinkedList = Object:new{max_size = false, size = 0, head = false, tail = false, data = {}, insertion_index = 1}
-- We refer to the head as the first node - which is the last node inserted - where the linked list "starts".
-- Symmetrically, the tail is the last node == the first, oldest node inserted.
-- Technically, the list is double linked.

function LinkedList:append(obj)
	local i = self.insertion_index
	local node = {content = obj, index = i, prev = nil, next = nil}
	if self:getHead() then
		local head_node = self:getHead()
		head_node.prev = node
		node.next = head_node
	else
		self.head = node
	end
	
	if self.data[i] and self.maxSize then
		self:pruneNode(i)
	end
	
	self.data[i] = node
	
	-- 
	self.size = self.size + 1
	self.insertion_index = self.insertion_index + 1
	
	if maxSize and maxSize > 1 then
		self.insertion_index = ((self.insertion_index - 1) % self.maxSize) + 1
	end
	
	
	if size > maxSize then 
	
		size = size - 1
	
	else
	end
end

function LinkedList:getHead()
	return self.head or false
end

function LinkedList:getTail()
	return self.tail or false
end

function LinkedList:getFirstN(n)
	local contents = {}
	local node = self:getHead()
	for do
		if node then
			append(contents, node.data)
			node = node.next
		end
	end
	
end

function LinkedList:pruneNode(index)
	assert(self.data[index].next == nil) -- this function should never be used to prune the node that isn't the head
	assert(index == self.head.index)
	
	self.data[index].previous.next = nil
	self.data[index] = nil
	-- this should remove all references to node 
end


Set = {}

Set.mt = {
	__add = function(m, n)
		local isTableM = (type(m) == "table")
		local isTableN = (type(n) == "table")
		
		local r = {}
		local x = (isTableM and m or n)
		
		for k, v in pairs(x) do
			r[k] = v
		end
		
		if isTableM and isTableN then
			for k, v in pairs(n) do
				r[k] = v
			end
			return r -- guaranteed to have set structure. Pairs also iterates over the metamethods
		elseif isTableM then
			table.insert(r, n)	
			return r
		elseif isTableN then
			table.insert(n, m, 1)
			return n
		else
			assert(false, "Set.add metamethod failed")
		end	
	end,
	
	__sub = function(m, n)
		local isTableM = (type(m) == "table")
		local isTableN = (type(n) == "table")
		
		local r = {}
		local x = (isTableM and m or n)
		
		for k, v in pairs(x) do
			r[k] = v
		end
		
		if isTableM and isTableN then
			for k, v in pairs(n) do
				if string.sub(k, 1, 2) == "__" then --metamethod
					-- do NOT sub the metamethods. those get added
					r[k] = v
				elseif type(k) == "number" then
					for i = #r, 1, -1 do
						if r[i] == v then table.remove(r, i) end
					end
				else
					r[k] = nil
				end	
			end
			return m
		elseif isTableM then
			for i = #m, 1, -1 do
				if m[i] == n then table.remove(m, i) end
			end
			return r
		elseif isTableN then
			return r
		else
			assert(false, "Set.sub metamethod failed")
		end	
	end
}

function Set.init(t)
	setmetatable(t, Set.mt)
	return t
end

function Set.copy(set1)
	assert(type(set1) == "table", "set1 is not a table value")
	local set2 = {}
	for k, v in pairs(set1) do
		set2[k] = v
	end
	return set2
end

function Set.sanitize(set1)
	local t = {}
	assert(type(set1) == "table", "set1 is not a table value")
	for k, v in pairs(set1) do
		if type(k) == "number" and type(v) ~= "table" then
			t[#t+1] = v
		end
	end
	return t
end

function Set.union(set1, set2) -- For dictionaries. Fucks up with lists
	assert(type(set1) == "table", "set1 is not a table value")
	assert(type(set2) == "table", "set2 is not a table value")
	local t = Set.copy(set1)
	for k, v in pairs(set2) do
		t[k] = v
	end
	return t
end

function Set.merge(set1, set2) -- For lists. Ignores dict values.
	assert(type(set1) == "table", "set1 is not a table value")
	assert(type(set2) == "table", "set2 is not a table value")
	local t = {}
	for i = 1, #set1 do
		t[#t+1] = set1[i]
	end
	for j = 1, #set2 do
		t[#t+1] = set2[j]
	end
	return t
end

function Set.diff(set1, set2)
	assert(type(set1) == "table", "set1 is not a table value")
	assert(type(set2) == "table", "set2 is not a table value")
	local t = Set.copy(set1)
	for k, v in pairs(set1) do
		for kk, vv in pairs(set2) do
			if v == vv then t[k] = nil end
		end
	end
	return t
end

function Set.compress(set1)
	local set2 = {}
	for k, v in pairs(set1) do
		set2[#set2+1] = v
	end
	return set2
end

-- while this should probably be doable more efficiently, I'm not changing this particular running system right now
function Set.subset(set1, set2)
	assert(type(set1) == "table", "set1 is not a table value")
	assert(type(set2) == "table", "set2 is not a table value")
	
	-- set 1 is a subset of set 2 if and only if every value in set1 is also in set2
	if #set1 == 0 then return false end
	
	local valueContained = false
	
	for k1, v1 in pairs(set1) do
		valueContained = false
		for k2, v2 in pairs(set2) do
			if v1 == v2 then 
				valueContained = true
			end
		end
		if valueContained == false then return false end
	end
	return true
end


Colors = Object:new{
	red = {1, 0, 0, 1},
	blue = {0.5, 0.5, 1, 1},
	green = {0.5, 1, 0.5, 1},
	white = {1, 1, 1, 1},
	yellow = {1, 0.75, 0, 1},
	dark_blue = {0.1875, 0, 0.5, 1},
	black = {0, 0, 0, 1}
}


-- Vector math

-- Goal: Generic vector object, any length.
-- Time: Implement later. Maybe use some prebuilt math module instead.

-- Vec2, Rect may be special cases.

-- Vec = Object:new()

-- as vec is an object, its metatable exists

-- setmetatable(Vec, function()

	-- mt = getmetatable(Vec)

	-- mt.__add = function(v1, v2)
		-- return Vec:new()
	-- end
		
-- end)




Vec2 = Object:new{
	x = 0,
	y = 0
}

mt = getmetatable(Vec2)

mt.__add = function (v1, v2) 
	return Vec2:new{x = v1.x + v2.x, y = v1.y + v2.y} 
end

mt.__sub = function (v1, v2) 
	return Vec2:new{x = v1.x - v2.x, y = v1.y - v2.y} 
end

mt.__mult = function (v1, v2)
	if type(v1) == "number" then return Vec2:new{x = v1 * v2.x, y = v1 * v2.y} end
	if type(v2) == "number" then return Vec2:new{x = v2 * v1.x, y = v2 * v1.y} end
	return (v1.x * v2.x) + (v1.y * v2.y)
end

mt.__div = function (v1, v2)
	if ((type(v2) == "number") and (v2 ~= 0)) then return Vec2:new{x = v1.x / v2, y = v1.y / v2}
	elseif type(v1) == "table" then return v1
	else return v2 end
end

mt.__unm = function (v) 
	v.x = -v.x 
	v.y = -v.y
	return v
end

setmetatable(Vec2, mt)
	
function Vec2:set(v)
	if v then
		x = v.x or v[0] or self.x
		y = v.y or v[1] or self.y
	else
		x, y = 0, 0
	end
	return Vec2:new{x = x, y = y}
end

function Vec2:getNormal()
	return Vec2:new{x = -self.y, y = self.x}
end

function Vec2:length()
end




Rect = Object:new{0, 0, 0, 0}

function Rect.getCoveringRect(r1, r2)
	local mR = {0, 0, 0, 0}
	mR[1] = math.min(r1[1], r2[1])
	mR[2] = math.min(r1[2], r2[2])
	mR[3] = math.max(r2[1] + r2[3], r1[1] + r1[3]) - mR[1]
	mR[4] = math.max(r2[2] + r2[4], r1[2] + r1[4]) - mR[2]
	return mR
end

function Rect.translate(r, dv, f) -- Translates a rectangle by some delta vector dv. f is facing.
	f = f or 1
	return {((f == -1) and (-r[3] - r[1]) or r[1]) + dv[1], r[2] + dv[2], r[3], r[4]}
end	



Util = {} -- table containing basic helper functions

function Util.tableSum(tab, att, sigma, a, b) -- basically just for fun. a for loop would be more intelligent.
	assert(type(tab) == "table")
	sigma = sigma or 0
	a = a or 1
	b = b or #tab
	c = math.floor((a+b)/2)
	return (a == b) and (sigma + (tab[a][att] or 0)) or (sigma + tableSum(tab, att, sigma, a, c) + tableSum(tab, att, sigma, c+1, b))
end


function Util.invert(i, size) -- for inverse sequence of i that run from 1 to size
	-- DEPRECATED: Use reverse_ipairs instead
	return (size + 1 - i)
end

function Util.isWhole(num)
	return (math.floor(num) == num)
end

function Util.getKey(tab, val)
	return Util.getKeyOfValueInTable(tab, val)
end

function Util.getKeyOfValueInTable(tab, val)
	for k, v in pairs(tab) do
		if val == v then
			return k
		end
	end
	return false
end

function Util.logb(num, base) -- logarithm with arbitrary base
	assert(num >= 0, "Can't take the logarithm of a negative number")
	assert(base > 1, "Can't take the logarithm of base 1 or less")

	local ret = 0
	
	-- ensure that the algorithm yields whole numbers when it should:
	-- that is, when the base and the number are both whole
	if Util.isWhole(base) then 
		while Util.isWhole(num) and (num >= base) do
			num = num / base
			ret = ret + 1
		end
	end
	
	assert(num >= 1, "Something went wrong in the algorithm: Num should never be below 1 at this point")
	
	-- log_b x = (log_a x / log_a b)
	ret = ret + (math.log(num) / math.log(base))
	return ret
end

function Util.getTimestamp(t, fmt)
	
	t = t or os.time()
	
	local padNr = function (n)
		n = (n < 10 and "0" .. tostring(n) or tostring(n))
		return n
	end
	
	local formats = {
		plain = {
			pref = "",
			suff = "",
			sep1 = "",
			sep2 = "",
			sep3 = "",
		},
		filename = {
			pref = "",
			suff = "",
			sep1 = "_",
			sep2 = "_",
			sep3 = "_",
		},
		timestamp = {
			pref = "[",
			suff = "",
			sep1 = "",
			sep2 = "",
			sep3 = "]",
		},
	}
	
	fmt = (formats[fmt] and fmt or "plain") -- sensible default for format string
	
	formatTable = formatTable or {}
	
	formatted = formatted or false
	local pref = formatted and "[" or ""
	local suff = formatted and "]" or ""
	local sep1 = formatted and "-" or ""
	local sep2 = formatted and ":" or ""
	local sep3 = formatted and " " or ""

	local odt = os.date("*t", t)
	local ods = pref .. padNr(odt.year) .. sep1 .. padNr(odt.month) .. sep1 .. padNr(odt.day) .. sep3 .. padNr(odt.hour) .. sep2 .. padNr(odt.min) .. sep2 .. padNr(odt.sec) .. suff
	return ods 
end



Textbox = Object:new{
	text = "",
	cursorPos = 0,
}

function Textbox:splitAtCursor()
	-- given current text and cursor position, this function returns 
	local prefix = string.sub(self.text, 1, self.cursorPos)
	local suffix = string.sub(self.text, self.cursorPos + 1, -1)
	return prefix, suffix
end

function Textbox:clear()
	self.text = ""
	self.cursorPos = 0
end

function Textbox:getTextLength()
	return string.len(self.text)
end

function Textbox:moveCursor(delta)
	self.cursorPos = self.cursorPos + delta
	self.cursorPos = (self.cursorPos < 0) and 0 or self.cursorPos
	self.cursorPos = (self.cursorPos > #self.text) and #self.text or self.cursorPos
end

function Textbox:moveCursorToEnd()
	self.cursorPos = self:getTextLength()
end

function Textbox:setText(t)
	self:clear()
	self.text = t
	self:moveCursorToEnd()
end

function Textbox:getText()
	return self.text
end

function Textbox:getCursorPosition()
	return self.cursorPos
end

function Textbox:insertTextAtCursor(t)
	t = t or ""
	local prefix, suffix = self:splitAtCursor()
	self.text = prefix .. t .. suffix
	self:moveCursor(string.len(t))
end

function Textbox:handleTextInput(key, scancode, isrepeat)
	--	Accepts key, scancode, and whether the input is a repeat.
	-- Returns whether the key was consumed. Also returns the textbox string if enter was pressed.

	if key == "space" then key = " " end
	
	if string.len(key) == 1 then 
		-- typable character.
		-- add key to the right of the cursor, then increment cursor
		
		self:insertTextAtCursor(key)
	
	elseif scancode == "left" then
		self:moveCursor(-1)
	elseif scancode == "right" then
		self:moveCursor(1)
	elseif scancode == "backspace" then
		local prefix, suffix = self:splitAtCursor()
		prefix = string.sub(prefix, 1, -2)
		self.text = prefix .. suffix
		self:moveCursor(-1)
		
	elseif scancode == "delete" then
		local prefix, suffix = self:splitAtCursor()
		suffix = string.sub(suffix, 2, -1)
		self.text = prefix .. suffix
		self:moveCursor(0) -- normalize cursor pos
	
	elseif scancode == "return" then		
	
		local output = self.text
		self:clear()
		return true, output
	else 
		return false
	end
	return true
	
end





Parabola = Object:new{a = 1, c = 0, offset = 1}

function Parabola:fromTimeAndHeight(t, h)
	h = (h < 1) and 1 or h
	t = (t < 2) and 2 or t
	t = math.floor(t)
	local p = self:new()
	p.c = h
	p.offset = t/2
	p.a = -4*h/(t^2)
	return p
end

function Parabola:fromTimeAndLength(t, l)
	
	t = (t < 2) and 2 or t
	l = (l < 1) and 1 or l

	local p = self:new()
	p.c = t/4 --	arbitrarily chosen, adjust this and see what feels best
	p.offset = 0
	
	local sigmaX = function (lim1, lim2) -- why do math on paper when you can let the computer do it
		local sum = 0
		for i = lim1, lim2 do
			sum = sum + i^2
		end
		return sum
	end
	
	p.a = (l - (t+1)*c) / (2* sigmaX(1, t/2))
	
	if p.a > 0 then
		print("Formula is doing some stupid shit") -- if this is ever printed I really fucked up the math
		p.a = -p.a
	end
	
	p.offset = 0
	
	return p
end

function Parabola:getDelta(i)
	return self:getHeight(i-1) - self:getHeight(i)
end

function Parabola:getHeight(i)
	return self.a * (i - self.offset)^2 + self.c
end

function Parabola:getNextDelta(d)
	for i = 1, self.offset*2 do
		print(self:getDelta(i+1), d)
		if self:getDelta(i+1) + 0.0001 > d then
			return self:getDelta(i+1), i+1
		end
	end
	return self:getDelta(self.offset*2), self.offset*2
end



Force = Object:new{i = 1, active = false}

function Force:getCurrent()
	return {0, 0}
end

function Force:update(incrementFrame)
	local v = false
	if (self.active) then
		v = self:getCurrent()
		self.i = self.i + (incrementFrame and 1 or 0)
	else
		v = {0, 0}
	end
	return v
end

function Force:activate(i)
	self.i = i or 1
	self.active = true 
end

function Force:deactivate()
	self.active = false
end

ForceGravity = Force:new{parabola = Parabola:fromTimeAndHeight(28, 100)}

function ForceGravity:getCurrent()
	return {0, math.min(self.parabola:getDelta(self.i), 20)}
end

function ForceGravity:activate(v)
	local i = 1
	if v then _, i = self.parabola:getNextDelta(v[2]) end
	self.i = i
	self.active = true
end

ForceMomentum = Force:new{speed = 0, decay = 1, cutoff = 0}

function ForceMomentum:getCurrent()
	return {self.speed, 0}
end

function ForceMomentum:update()
	local f = (self.active and self:getCurrent() or {0, 0})
	self.speed = self.speed * self.decay
	if math.abs(self.speed) < self.cutoff then self.speed = 0 end
	return f
	-- return (self.active and self:getCurrent() or {0, 0})
end

ForceImpact = Force:new{decay = 0.99, power = 1, cutoff = 0.04}

function ForceImpact:getCurrent()
	return {-self.power, 0}
end

function ForceImpact:update()
	local v = self:getCurrent()
	self.power = self.power * self.decay
	if self.power < self.cutoff then self.power = 0 end
	return v
end
