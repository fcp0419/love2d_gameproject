function Interface:toggleAnimationEditor()
	if self.animEditActive == false then
		AnimationEditor:getNumberMapping()
		
		self.animEditActive = true
		
		EditorStage:add(APC:new{position = {0, 0}, frame = 1, facing = 1, state = AnimationEditor:getActiveAnimation()})
		
		GameStateManager:setActiveStage(EditorStage)

		self.toggleDebug()
		
		Interface.layers.main_game.camera = CameraFixed
		Interface:activateLayer("animation_editor_UI")
		
	else
		GameStateManager:setActiveStage(TestStage)
		APC.state = States.Nun.Stand
		
		Interface.layers.main_game.camera = CameraFollowPlayer
		Interface:deactivateLayer("animation_editor_UI")
		
		self.animEditActive = false
	end
end

AnimationEditor = {
	anims = States.Nun,
	animString = "States.Nun",
	animOrder = {},
	activeIndex = 1,
	activeFrame = 1,
	playback = false,
	templateActive = false,
	textbox = '',
	selection = {name = {""}, value = 0},
	localAnims = {},
	lastIndex = 1,
	stdout = "/output.lua",
	inputMode = false,
	localCancels = {},
	consoleMode = false,
	hardcodedTemplates = {
		grounded = {
			sx = 0, sy = 0, sw = 256, sh = 256, ox = 0, oy = 0, sheet = 1, aerial = false,
			hitboxes = {}, hurtboxes = {{-15, -93, 35, 93}}, collboxes = {{-13, -85, 26, 85}}, 
			rapidfire = false, on_whiff = {}, on_hit = {}, hiteffect = {}},
		aerial = {
			sx = 0, sy = 0, sw = 256, sh = 256, ox = 0, oy = 0, sheet = 2, aerial = true,
			hitboxes = {}, hurtboxes = {{-15, -93, 35, 93}}, collboxes = {{-13, -85, 26, 70}}, 
			rapidfire = false, on_whiff = {}, on_hit = {}, hiteffect = {}}
		
	
	},
	
	serializationOrder = {
		"sx", "sy", "ox", "oy", "sheet", "sh", "sw", "aerial", "hit", "rapidfire", "attacklevel", "damage", "hitboxes", "hurtboxes", "collboxes", "on_whiff", "on_hit", "hitEffect", "actor_collision", "flags"
	}
}



function AnimationEditor:exportHardcodedToString()
	local ret = {}
	ret[#ret+1] = ''
	for k, v in self.hardcodedTemplates do end
	for k, v in self.hardcodedCancelLists do end
	ret[#ret+1] = ''
	return ret
end

function AnimationEditor:compileCancelLists()
	local cancelLists = {}

	for k, v in pairs({"grounded", "aerial"}) do
		cancelLists[v] = {}
	
		for k2, v2 in pairs({"movement", "stance", "normal", "special", "cmdnormal"}) do
			cancelLists[v][v2] = {}			
			
			for i = 1, #self.animOrder do	
				local frameOne = self.localAnims[i].template
				if ((not ((v == "grounded") and (frameOne.aerial))) and ((v == "grounded") or (frameOne.aerial))) and frameOne.flags[v2] then
					table.insert(cancelLists[v][v2], self.animOrder[i])
				end
				
			end
 		end
	end
	-- print("Ending bullshit.")
	
	return cancelLists
end

function AnimationEditor:setCancelLists()
	local cList = self:compileCancelLists()
	self.localCancels = cList
	self:setCancelDifferences()
end

function AnimationEditor:exportCancelListsToString()
	local ret = {}

	ret[#ret+1] = "CancelList = {"
	for k, v in pairs(self.localCancels) do -- grounded/aerial
		if type(v) == "table" then
			ret[#ret+1] = "\t" .. k .. " = {"
			for k2, v2 in pairs(v) do -- flags: movement/stance/normal/special
				local inRet = '\t\t' .. k2 .. ' = {'
				if type(v2) == "table" then
					for i = 1, #v2 do
						inRet = inRet .. '"' .. v2[i] .. '", '
					end
				end
				if string.sub(inRet, -1) ~= '{' then inRet = string.sub(inRet, 1, -3) end -- remove extra ", " 
				inRet = inRet .. '},'				
				ret[#ret+1] = inRet
			end
			ret[#ret+1] = "\t}, "
		end
	end	
	ret[#ret+1] = "}"
	
	for i = 1, #ret do
		ret[i] = "\t" .. ret[i]
	end
	return ret
end

function AnimationEditor:setCancelDifferences()
	-- For each animation, type of cancel, individual frame in the animation and flag category do:
		-- Look at all cancels in the unsorted list (ie. all entries in the table that aren't tables themselves)
		-- Find out if the flag category is a subset of this cancel list. If so, set the newFlags entry to true.
		-- After iterating over all flag categories, set the unsorted list to 
	local newFlags = {}
	local realList = {}
	local aerialGrounded = false
	local listOfFrames = {}
	for k0, anim in pairs(self.localAnims) do
		for _, v in pairs({"on_whiff", "on_hit"}) do
			listOfFrames = {}
			table.insert(listOfFrames, anim.template)
			for sk, sv in pairs(anim.frames) do
				table.insert(listOfFrames, sv.frame)
			end
			for _, frame in pairs(listOfFrames) do
				if type(frame[v]) == "table" then
					newFlags = {movement = false, stance = false, normal = false, special = false}
					realList = {}
					aerialGrounded = (anim.template.aerial and "aerial" or "grounded")
					for k2, v2 in pairs(newFlags) do -- instantiate flags with already existing cancel flags
						newFlags[k2] = v2 or (type(frame[v]["_flags"]) == "table" and frame[v]["_flags"][k2] or false)
					end
					for _, v3 in pairs(frame[v]) do 		-- pre-existing hit/whiff cancels
						if type(v3) ~= "table" then 		-- if v3 is not the flags table, but just a normal thing:
							table.insert(realList, v3) 	-- put v3 in the real list
						end
					end
					for k2, v2 in pairs(newFlags) do		
						if Set.subset(CancelList[aerialGrounded][k2], realList) then
							newFlags[k2] = true
							realList = Set.diff(realList, CancelList[aerialGrounded][k2])
							realList["_flags"] = nil
							realList = Set.compress(realList)
						end
					end
					realList["_flags"] = newFlags
					frame[v] = realList
				end
			end			
		end
	end
end

function AnimationEditor:getCancelDifference(input)

	local maxDiff = 5
	local list = {}

	list[1] = {name = "empty", cancels = {}}
	
	for k, v in pairs(self.hardcodedCancelLists) do
		list[#list+1] = {name = k, cancels = v}
	end
	
	for i = 1, #list do
		list[i].adds = input - list[i].cancels		-- the set of cancels present in input, but not in list
		list[i].subs =	list[i].cancels - input		-- the set of cancels present in list, but not in input
	end

	-- how to determine the ultimately chosen base template?
	
	local r = 1
	
	if (self.sizeof(list[1].adds) == 0 and self.sizeof(list[1].subs) == 0) then return list[1] end
	
	for i = 2, #list do
		local addI = self.sizeof(list[i].adds)
		local addR = self.sizeof(list[r].adds)
		local subI = self.sizeof(list[i].subs)
		local subR = self.sizeof(list[r].subs)
	
	
		if (addI == 0 and subI == 0) then
			return list[i]
		elseif (addI + subI > maxDiff) then
			-- continue
		elseif (not (addR == 0 or subR == 0)) and (addI == 0 or subI == 0) then
			r = i
		elseif (addR == 0 or subR == 0) and (not (addI == 0 or subI == 0)) then
			-- continue
		elseif (addR + subR) > (addI + subI) then 
			r = i
		end	
	end
	
	return list[r]
end

function AnimationEditor.sizeof(t)
	local i = 0
	for k, v in pairs(t) do
		if string.sub(k, 1, 2) ~= "__" then i = i + 1 end
	end
	return i
end

function AnimationEditor:getTemplateDifference(anim)
	local maxDiff = 5
	local leastDifference = nil
	local chosenTemplate = nil
	
	
	
	if sizeof(anim) <= maxDiff then return {{}} end
	
	for k, v in pairs(self.hardcodedTemplates) do
		local diffTable = self.hardcodedTemplates[i] - anim
		-- condititons
		-- leastDiff is undefined, and sizeof difftable is <= cap. OR:
		-- leastDiff is defined, sizeof difftable is <= cap and sizeof difftable <= sizeof leastDiff
		
		if (sizeof(diffTable) < maxDiff) and not (leastDiff and sizeof(diffTable) > sizeof(leastDifference)) then
			leastDifference = diffTable
		end	
	end
	
	if chosenTemplate then return end
	
		
end

function AnimationEditor:getSelectionSize(i, f)
	i = (i or 1) - 1
	f = f or self:getFrame(self:getActiveAnimation(false), self.activeFrame)
	return #(self.unpackProperty(f, i))
end

function AnimationEditor:getSelectionName(i)
	i = i or 1
	if type(self.selection.name) == "table" then
		return self.selection.name[i] or false
	else
		return self.selection.name
	end
end


function AnimationEditor:setSelection(s)
	local inputModes = {
		hitboxes = "Box",
		hurtboxes = "Box",
		collboxes = "Box",
		flags = "Flag"
	}

	self.selection.value = 0
	s = s or self.selection.name or {""}
	if type(s) ~= "table" then s = {s} end
	
	local oldName = self.selection.name
	if type(self.selection.name) ~= "table" then self.selection.name = {self.selection.name} end
	
	for i = 1, #s do
		s[i] = s[i] or self.selection.name[i] or (self.selection.name[i] == false and 1 or nil)
	end
	
	self.selection.name = s
	self.selection.value = self:getProperty(s)
	self.inputMode = (inputModes[self:getSelectionName()] or false)
	return true
end


function AnimationEditor:getActiveAnimation(b)
	if (b == nil) then b = true end
	if b then
		return self.anims[self.animOrder[self.activeIndex]]
	else
		return self.localAnims[self.activeIndex]
	end
end

function AnimationEditor:getActiveFrame(b)
	if (b == nil) then b = true end
	
	if b then
		if self.templateActive then
			return self:getActiveAnimation().animation.default_frame
		else
			return self:getActiveAnimation().animation.frames[self.activeFrame]
		end
	else
		if self.templateActive then
			return self:getActiveAnimation(b).template
		else
			return self:getFrame()
		end
	end
end

function getShift(i, l, s)
	-- parameters: i = current index, l = length
	if s < 0 then
		for j = 1, -s do
			i = ((i == 1) and l or (i - 1))
		end
	end
	if s > 0 then
		for j = 1, s do
			i = ((i == l) and 1 or (i + 1))
		end
	end
	return i
end

AnimationEditor.keyCheatSheet = {
	"Left/Right: Advance frame forward/back",
	"Up/Down: Switch animations",
	"F1: Display/hide hitboxes",
	"F2: Toggle playback speed",
	"F3: Change scale",
	-- "F1: Toggle help",
	"L: Toggle looping playback",
	"W: Deletes a property value or sets it to default. Shift deletes the property from the entire animation.",
	"M: Sets the selection to movement",
	"O: Sets selection to origin",
	"S: Sets selection to sheet position",
	"N: Negates the selection value",
	"Q: Sets selection to nothing",
	"H: Sets selection to hit number",
	"B: Sets selection to hitboxes, and enters box mode",
	"C: Sets selection to collboxes, and enters box mode",
	"U: Sets selection to hurtboxes, and enters box mode",
	"F: Sets selection to flags, and enters flag mode",
	"D: Sets selection to damage",
	"L: Sets selection to attack level",
	"+: Lenghtens current frame duration by 1",
	"-: Shortens current frame duration by 1",
	"T: Toggles template selection. While in template mode, switches to frame 1",
	"C: Copies the active property from the previous frame to the current frame",
	"Digits: Types digits in selection.",
	"Backspace: Deletes last selection digit.",
	"Return: Commits selection value. If shift is down, commits to all frames of current anim. If alt is down, commits to all anims.",
	"Tab: Toggle between first animation and current animation.",
	"Insert: If alt is down, adds a frame. If shift is down, adds an animation.",
	"Delete: Delete an unique frame.",
	"Spacebar: Pause/unpause playback",
	"F7: Exports animation to standard output",
	-- "F8: Unbound",
	"F9: Enter frame import mode",
	"F10: Toggles the console mode",
	"F12: Exit the animation editor",
	"In flag edit mode:",
	"M: Toggle movement property",
	"T: Toggle stance property",
	"N: Toggle normal property",
	"S: Toggle special property",
	"C: Toggle command normal property",
	"In box edit mode:",
	"X: Commit to 1st value of current box (x top left)",
	"Y: Commit to 2nd value of current box (y top left)",
	"W: Commit to 3rd value of current box (width)",
	"H: Commit to 4th value of current box (height)",
	"+: Go to next box",
	"-: Go to previous box",
	"Insert: Add another (empty) box",
	"Delete: Remove the last box",
}


function AnimationEditor:scanAnimation(i)
	local targetAnim = nil
	if type(i) == "number" then
		targetAnim = self.anims[self.animOrder[i]] or self.anims[self.animOrder[1]]
	elseif type(i) == "string" then
		targetAnim = self.anims[i] or self.anims[self.animOrder[1]]
	else return false end

	local templateFrame = targetAnim.animation.default_frame
	local uniqueFrames = {}
	
	uniqueFrames[1] = {frame = self.copyFrame(targetAnim, 1), duration = 1}
	for i = 2, #targetAnim.animation.frames do
		local tf = self.copyFrame(targetAnim, i)
		if self.compareFrames(uniqueFrames[#uniqueFrames].frame, tf) then
			uniqueFrames[#uniqueFrames].duration = uniqueFrames[#uniqueFrames].duration + 1
		else
			uniqueFrames[#uniqueFrames + 1] = {frame = tf, duration = 1}
		end		
	end
	
	local scannedAnimation = {
		template = templateFrame,
		frames = uniqueFrames,
		movement = targetAnim.movement,
		cancels = targetAnim.onConditionCancels
	}
	
	return scannedAnimation
end

function AnimationEditor:cleanHitEffects(scannedAnim)	
	for i = 1, #scannedAnim.frames do
	
		for k, v in pairs(scannedAnim.frames[i].frame) do
			if k == "hitEffect" then
				for k2, v2 in pairs(v) do
					for k3, v3 in pairs(v) do
						if (k2 ~= k3) then
							for k4, v4 in pairs(v2) do
								v3[k4] = v3[k4] or v4
							end
							for k4, v4 in pairs(v3) do
								v2[k4] = v2[k4] or v4
							end
						end
					end
				end
			end
		end
	end
	return scannedAnim
end

function AnimationEditor.getMovementRuns(movement, length)
	local ret = {}
	for i = 1, length do
		local m = movement[i]
		if m then
		
			if (ret[#ret] == nil) or ((m[1] ~= ret[#ret].vector[1]) or (m[2] ~= ret[#ret].vector[2])) then
				ret[#ret+1] = {vector = m, start = i, duration = 1}
			else
				ret[#ret].duration = ret[#ret].duration + 1
			end
		end
	end
	return ret	
end

function AnimationEditor.copyFrame(tAnim, i)
	
	local tFrame = tAnim.animation.frames[i]
	local rFrame = {}
	for k, v in pairs(tFrame) do
		local addCondition = ((k ~= "__index") and (tAnim.animation.default_frame[k] ~= v))

		if addCondition then
			rFrame[k] = v
		end
	end
	return rFrame
end

function AnimationEditor:exportAnimationToString(i)
	local targetAnim = self.localAnims[i] or self.localAnims[1]
	local ret = {}
	local tableDepth = 20
	
	local reverseOrder = function ()
		local tt = {}
		for i = 1, #self.serializationOrder do
			tt[self.serializationOrder[i]] = i
		end
		return tt
	end
	
	local function tableToString (t, d)
		local str = ''
		d = d or 1
		if (d == 1) then
			for n = 1, #self.serializationOrder do
				local k = self.serializationOrder[n]
				local v = t[k]
				if ((v ~= nil) and (type(v) ~= 'function')) then
					str = str .. (type(k) == 'string' and (k .. ' = ') or '') -- number indices are implicit
					if (d > tableDepth) or (type(v) ~= 'table') then
						str = str .. (type(v) == 'string' and ('"' .. v .. '"') or tostring(v)) .. ', '
					else
						str = str .. tableToString(v, d+1) .. ', '
					end
				end
			end
		else
			for k, v in pairs(t) do
				if ((v ~= nil) and (type(v) ~= 'function') and (k ~= "__index")) then
					str = str .. (type(k) == 'string' and (k .. ' = ') or '')
					if (d > tableDepth) or (type(v) ~= 'table') then
						str = str .. (type(v) == 'string' and ('"' .. v .. '"') or tostring(v)) .. ', '
					else
						str = str .. tableToString(v, d+1) .. ', '
					end
				end
			end
		end
		str = string.sub(str, 1, -3)  -- remove trailing ', '
		return '{' .. str .. '}'
	end
	
	local templateToString = function()
		local str = tableToString(targetAnim.template)
		str = string.sub(str, 2, -2) -- remove extra set of curly braces
		return str
	end
	
	local frameToString = function(l)
		local str = tableToString(targetAnim.frames[l].frame)
		str = '{' .. str .. ', ' .. targetAnim.frames[l].duration .. '},'
		return str
	end
	
	local nextStateToString = function()
		return (self.anims[self.animOrder[i]].next_state) and self.animString ..  '.' .. self.animOrder[i] .. '.next_state = ' .. self.animString ..  '.' .. self.anims[self.animOrder[i]].next_state.id or ''
	end
	
	
	local movementToString = function ()
		local runs = self.getMovementRuns(targetAnim.movement, 600)
	
		local strs = {}
		strs[#strs+1] = self.animString .. '.' .. self.animOrder[i] .. ':setMovements{' 
		for i = 1, #runs do
			strs[#strs+1] = '\t{{' .. runs[i].vector[1] .. ', ' .. runs[i].vector[2] .. '}, ' .. runs[i].duration .. ', ' .. runs[i].start .. '},'
		end		
		strs[#strs+1] = '}'
		return strs
	end
	
	--ret[#ret+1] = ''
	ret[#ret+1] = self.animString .. '.' .. self.animOrder[i] .. ' = State:initTemplate("' .. self.animOrder[i] .. '", {' .. templateToString() .. '})'
	ret[#ret+1] = self.animString .. '.' .. self.animOrder[i] .. ':setFrames{' 
	for j = 1, #targetAnim.frames do
		ret[#ret+1] = '\t' .. frameToString(j)
	end
	ret[#ret+1] = '}'
	
	local sret = movementToString()
	for s = 1, #sret do
		ret[#ret+1] = sret[s]
	end
	
	--ret[#ret+1] = nextStateToString()
	ret[#ret+1] = ''
	
	for j = 1, #ret do
		ret[j] = '\t' .. ret[j]
	end
	
	return ret	
end

function AnimationEditor:recordLandFallCancels()
	local ret = {}
	local str = ''
	local nonempty = false
	
	for i = 1, #self.localAnims do
		str = '\t\t' ..  self.animString ..  '.' .. self.animOrder[i] .. '.onConditionCancels = {'
		nonempty = false
		for k, v in pairs(self.localAnims[i].cancels) do
			str = str .. k .. ' = ' .. (type(v) == 'string' and ('"' .. v .. '"') or (v and 'true' or 'false')) .. ', '
			nonempty = true
		end
		if nonempty then
			str = string.sub(str, 1, -3) -- remove last comma and space
		end
		str = str .. '}'
		ret[#ret+1] = str
	end
	return ret
end

function AnimationEditor:writeAnimationsToStdout()

	self:setCancelLists()
	self:eliminateDuplicateProperties()
	
	local writeArray = {}
	for i = 1, #self.localAnims do
		writeArray[i] = self:exportAnimationToString(i)
	end
	writeArray[#writeArray+1] = self:recordLandFallCancels()
	writeArray[#writeArray+1] = self:exportCancelListsToString()
	
	
	table.insert(writeArray, 1, {"function initializeNunStates()", "\tStates.Nun = {}"})
	table.insert(writeArray, {"end"})
	
	local gamePath = love.filesystem.getSource()
	local file = assert(io.open(gamePath .. "/script/Nun_Generated.lua", "w"))
		
	for i = 1, #writeArray do
		for j = 1, #writeArray[i] do
			file:write(writeArray[i][j])
			file:write("\n")
		end
		file:write("\n")
	end
	file:close()
	
	print("Finished generating animation scripts.")
end


function AnimationEditor:getNumberMapping()
	-- Arrange the animations in correct order, based on mapping below.
	local i = 1
	for k, v in pairs(self.anims) do
		self.animOrder[i] = k
		i = i + 1
	end
	self:correctNumberMapping()
	
	self.localAnims = {}
	for i = 1, #self.animOrder do
		self.localAnims[i] = self:scanAnimation(i)
	end	
end

function AnimationEditor:correctNumberMapping()
	local valueTable = {
		"Stand",
		"Duck",
		"Guard",
		"Walk",
		
		"Dash",
		"Crouchdash",
		"AssaultJump",
		
		"SwayShort",
		"SwayLong",
		"Microdash",
		"EscapeJump",
		
		"Jump",
		"JumpHop",
		"SuperJump",
		"Prejump",
		"LandRecovery",
		
		"LeftJolt",
		"RightStraight",
		"LeftSwing",

		"RightHookStand",
		"RightHookSway",
		"LeftDownpunch",
		
		"LeftUpper",
		"ShoulderTackle",
		
		"DashLeftJolt",
		"DashRightStraight",
		
		"RightUpper",
		"ShoulderThrow",
		
		"FrontKick",
		"FrontKickCharged",
		"HeelKick",
		"HeelKickCharged",
		
		"Sweep",
		"SweepSlideKick",
		
		"RightKnee",
		"KneeHop",
		
		
		"CrouchdashShoulderTackle",
		"CrouchdashSlideKick",
		-- "SpinKick",
		
		"DeathFist",
		"RisingUpper",
		"KneeRevolver",
		"DoubleUpkicks",
		
		
		-- "JumpBackFist",
		-- "JumpElbowDrop",
		-- "JumpAxeKick",
		-- "JumpDiveKick",
		-- "JumpStomp",
		"DummyFall",
		"JumpLeftRightPunches",
		"JumpHammerFist",
		"JumpPowerPunch",
		"JumpFlyingKick",
		"JumpHeelKick",
		"JumpDiveKick",
		"JumpDiveKickCharge1",
		"JumpDiveKickCharge2",
		"JumpDiveKickCharge3",
		"JumpAxeKick",
		
		"AxeKick",
		"AxeKickCharged",
	}
	
	local inTable = function(tab, x)
		for _, v in pairs(tab) do
			if x == v then return true end
		end
		return false		
	end
	
	for i = 1, #self.animOrder do
		if not inTable(valueTable, self.animOrder[i]) then table.insert(valueTable, self.animOrder[i]) end
	end
	
	for i = 1, #valueTable do
		self.animOrder[i] = valueTable[i]
	end
end



function AnimationEditor.compareFrames(f1, f2)
	if	type(f1) ~= type(f2) then return false end
	if type(f1) ~= "table" then return false end
	
	local compareProps = {"sx", "sy", "ox", "oy", "hit"}
	
	for i = 1, #compareProps do
		if f1[compareProps[i]] ~= f2[compareProps[i]] then 
			--print("Breaking on property", compareProps[i])
			--print("Values", f1[compareProps[i]], f2[compareProps[i]])
			return false 
		end
	end
	
	return true
end


EditorStage = Stage:new()

function EditorStage:draw()

	love.graphics.setColor(1, 1, 1, 1)
	Interface:setLayer("background")
	
	
	-- love.graphics.setCanvas(EditorCanvas)
	self:drawBackground()
	love.graphics.setColor(0.8, 1, 0, 1)
	
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle("rough")
	love.graphics.line(-1000, 400,  1000, 400)
	love.graphics.line(300, -1000,  300, 1000)
	
	love.graphics.setColor(1, 1, 1, 1)
	

	self.all_objects[1]:drawFromLocal(AnimationEditor.templateActive)
	
	-- love.graphics.setCanvas()
	-- love.graphics.draw(EditorCanvas, 0, 0, 0, 2, 2)
	-- love.graphics.setColor(255, 255, 255, 255)
end

function Actor:drawFromLocal(isTemplate)
	
	local ILMG = Interface.layers.main_game
	
	ILMG:setComponent("player")

	love.graphics.setColor(0.8, 0.75, 0.75, 1)
	local aframe = (isTemplate and AnimationEditor:getTemplate() or AnimationEditor:getFrame())

	local sht = (self.spritesheet[aframe.sheet] or self.spritesheet)	
	local sxx = aframe.sx 
	local syy = aframe.sy
	local oxx, oyy = self:getOrigin(aframe.ox, aframe.oy)
		
	sxx = (sxx < 32) and sxx * aframe.sw or sxx
	syy = (syy < 32) and syy * aframe.sh or syy
	self.quad:setViewport(sxx, syy, aframe.sw, aframe.sh)
	self.drawSpriteQ(sht, self.quad, self.position[1], self.position[2], oxx, oyy, self.facing)
	
	love.graphics.setColor(255, 255, 255, 255)
	
	love.graphics.setLineWidth(2)
	
	ILMG:setComponent("overlay")

	self:drawBoxes(aframe.collboxes, Colors.blue, 255)
	--self.drawBox(MapObject.getExtendedBox(self.masterbox_coll, 0), Colors.dark_blue, 255)
	self:drawBoxes(aframe.hitboxes, Colors.red, 255)
	self:drawBoxes(aframe.hurtboxes, Colors.green, 255)
	-- self.drawBox(MapObject.getExtendedBox(self.masterbox_damage, 0), Colors.yellow, 255)
	self:drawPivot()
	
	love.graphics.setLineWidth(1)
end


--[[

	Editor shortcut data
	
	F1 -> display list of commands
	F2 -> toggle hitbox/debug info display
	F3 -> toggle FPS
	F4 -> toggle FPS (opposite dir)
	
	F7 -> save changes
	
	m -> edit movement x
	m, m -> edit movement y

	o -> edit offset x
	o, o -> edit offset y
	
	s -> edit sheet x
	s, s -> edit sheet y

	g -> Input a frame number, go to that frame
	
	q -> Exit current edit mode.
	
	z -> Undo last action? (Sounds hard to implement.)
	
	l -> Toggle looping between play once / play 
	
	e -> Extend the current frame's duration by 1
	r -> Reduce the current frame's duration by 1
	
	t -> Go to template frame
	t, t -> Go to frame 1
	
	n -> Edit the name of the current animation
	
	
	
	+ -> Increment current edit value by 1 (using rollover if needed, i.e. sheet coords are bound to 0-15)
	- -> Decrement current edit value by 1
	If no edit value is selected: Instead advance/go back by single frame
	
	
	
	Numbers -> Set current edit value when a textbox is active
	Backspace -> Backspace, when textbox is active.
	
	w -> Delete current value. For template frame: set to 0, otherwise: delete so template value is used
	Shift+w -> Delete the current value from all frames except the template.
	
	Space -> Pause/unpause playback
	
	Arrow keys -> Switch between animations, or frame advance
	Dot -> Toggle frame-by-frame versus frame grouping mode for arrow keys
	
	
	Insert -> Make a new animation
	Delete -> Remove the current animation?
	
]]



function EditorStage:step(dt)

	local o = self.all_objects[1]

	-- o.state.next_state = o.state
	if o.frame == 1 then
		-- o.momentum = {0, 0}
		o.position = {300, 400}
	end
	-- local previousY = o.position[2]
	if AnimationEditor.playback then 
		local movement = AnimationEditor:getMovement()
		-- o:getMovementVector(AnimationEditor.activeFrame)
	
		-- o:stepMomentum(dt)
		if movement ~= {0, 0} then
			o.position[1] = o.position[1] + movement[1]
			o.position[2] = o.position[2] + movement[2]
		end
		AnimationEditor:advanceActorFrameRaw(o)
		-- o:advanceFrameRaw()
		AnimationEditor.activeFrame = o.frame
	end
end

function AnimationEditor:advanceActorFrameRaw(actor)
	actor.frame = actor.frame + 1
	if actor.frame > self:getAttackData() then actor.frame = 1 end
	-- self.activeFrame = o.frame
end

function EditorStage:add(o)
	o.position = {300, 400}
	self.all_objects[1] = o
end

function AnimationEditor:setSelectionValue()
	self.selection.value = (tonumber(self.textbox) or 0)
end

function AnimationEditor:commitSelectionValue()
	self:setProperty(self.selection.name, self.selection.value)
end


function love.directorydropped(dir)
	local maxSheets = 2
	local maxLength = 16
	local maxRows = 16
	local gamePath = love.filesystem.getSource()
	local gridSize = 256
	
	if Interface.animEditActive and AnimationEditor.selection.name[1] == "Frame Import" then
		local row = tonumber(AnimationEditor.textbox) or 0
		local sheet = math.ceil((row+1) / maxRows)
		row = row - (sheet-1)*maxRows
		
		print("Row/Sheet", row, sheet)
		print(dir)
		
		local dir2 = "workingDirectory/" .. (dir:match('(%w+)$') or "DEFAULT") .. "/"
		
		love.filesystem.mount(dir, dir2)
		if sheet <= maxSheets then
			local sheetPath = "gfx/NunSpriteSheet" .. sheet .. ".png"
		
			local workingSheet = love.graphics.newImage("gfx/NunSpriteSheet" .. sheet .. ".png"):getData()
			local files = love.filesystem.getDirectoryItems(dir2)
			--print(files, #files)
			
			local ttt = os.time(os.date("!*t")) -- unix timestamp, for the backup
			
			table.sort(files, -- sort by filenames, by lexical byte order
			function(a, b) 
				for i = 1, #a do
					if b:byte(i) then
						if a:byte(i) < b:byte(i) then return true
						elseif b:byte(i) < a:byte(i) then return false end
					else return false end
				end
				return true
			end
			)
						
			for i = 1, #files do
				print("Printing file", files[i])
				print("Printing dirs", dir, dir2)
				local cFile = love.graphics.newImage(dir2 .. files[i]):getData()
				if i < maxLength then
					workingSheet:paste(cFile, (i-1)*gridSize, row*gridSize, 0, 0, gridSize, gridSize)
				end
			end
			
			love.filesystem.write(sheetPath, workingSheet:encode("png"))
		end
		love.filesystem.unmount(dir2)
	end
end

function updateWhiteUnderlays(maxSheets, maxLength, maxRows)
	local hasWhite = function(i)
		for x = 0, i:getWidth() - 1 do
			for y = 0, i:getHeight() - 1 do
				local r, g, b, a = i:getPixel(x, y)
				if r == 255 and g == 255 and b == 255 and a == 255 then return true end
			end
 		end
		return false
	end
	
	local isEmpty = function(i)
		for x = 0, i:getWidth() - 1 do
			for y = 0, i:getHeight() - 1 do
				local r, g, b, a = i:getPixel(x, y)
				if a > 0 then return false end
			end
 		end
		return true
	end

	for i = 1, maxSheets do
		local workingSheet = love.graphics.newImage("gfx/NunSpriteSheet" .. i .. ".png"):getData()
		for x = 1, maxLength do
			for y = 1, maxRows do
				local workingImg = love.image.newImageData(256, 256)
				print(workingImg, x, y)
				workingImg:paste(workingSheet, 0, 0, (x-1)*256, (y-1)*256, 256, 256)
				if not ((isEmpty(workingImg)) or (hasWhite(workingImg))) then
					workingImg = createWhiteUnderlay(workingImg)
					workingSheet:paste(workingImg, (x-1)*256, (y-1)*256, 0, 0, 256, 256)
				end
			end
		end
		love.filesystem.write("gfx/NunSpriteSheet" .. i .. ".png", workingSheet:encode("png"))
	end
end

function createWhiteUnderlay(imgdata)
	--start with 256x256 sub-image w/ colors green, white, alpha
	--create new 256x256 working image filled with color X
	--for each green pixel: make 3x3 white square centered on that pixel in working image
	--for each line and column:
		--set all pixels of color x w/ coord less than first white or greater than last white to transparent
	--set all remaining color X pixels to white
	--copy over all green pixels to working image
	--return working image
	
	local workingImage = love.image.newImageData(imgdata:getWidth(), imgdata:getHeight())
	
	local cWhite = {255, 255, 255, 255}
	local cTransparent = {0, 0, 0, 0}
	local isTransparent = function(c) return c[4] == 0 end
	local cGreen = {0, 85, 1, 255}
	local extraOutlineWidth = 2
	
	local iRows = {}
	local iColumns = {}

	local isSameColor = function(c, r, g, b, a)
		return (c[1] == r and c[2] == g and c[3] == b and c[4] == a)
	end
	
	local withinBoundaries = function(w, h, x, y) 
		return (x >= 0 and x < w and y >= 0 and y < h)
	end
	
	local getWhiteBand = function (i, coords)
		local x = coords.x
		local y = coords.y
		local ret = {}
		if x or y then
			if x then
				for c = 0, i:getHeight() - 1 do
					if isSameColor(cWhite, i:getPixel(x, c)) then
						ret[1] = c
						break
					end
				end
				for c = i:getHeight() - 1, 0, -1 do
					if isSameColor(cWhite, i:getPixel(x, c)) then
						ret[2] = c
						break
					end
				end
				if not (ret[1] and ret[2]) then return false end
				return ret
			elseif y then
				for c = 0, i:getWidth() - 1 do
					if isSameColor(cWhite, i:getPixel(c, y)) then
						ret[1] = c
						break
					end
				end
				for c = i:getWidth() - 1, 0, -1 do
					if isSameColor(cWhite, i:getPixel(c, y)) then
						ret[2] = c
						break
					end
				end
				if not (ret[1] and ret[2]) then return false end
				return ret
			end
		end
		return false
	end
	
	-- draw white "outline" around where green is on original image, without copying the green
	for x = 0, workingImage:getWidth() - 1 do
		for y = 0, workingImage:getHeight() - 1 do
			if isSameColor(cGreen, imgdata:getPixel(x, y)) then
				for cx = x - extraOutlineWidth, x + extraOutlineWidth do
					for cy = y - extraOutlineWidth, y + extraOutlineWidth do
						if withinBoundaries(workingImage:getWidth(), workingImage:getHeight(), cx, cy) then
							workingImage:setPixel(cx, cy, unpack(cWhite))
						end
					end
				end
			end
		end
	end
	
	-- init the white band
	for s = 0, workingImage:getHeight() - 1 do
		iRows[s] = getWhiteBand(workingImage, {y = s})
	end
	for s = 0, workingImage:getWidth() - 1 do
		iColumns[s] = getWhiteBand(workingImage, {x = s})
	end		
	
	-- fill the transparency "inside" of white bands
	workingImage:mapPixel(function (xx, yy, r, g, b, a) 
		if (iRows[yy] and iColumns[xx]) then
			--print(iRows[yy], iColumns[xx])
			if ((iRows[yy][1] < xx) and (xx < iRows[yy][2]) and (iColumns[xx][1] < yy) and (yy < iColumns[xx][2])) then
				return unpack(cWhite)
			end
		end
		return r, g, b, a
	end)
	
	-- copy green lines from original
	workingImage:mapPixel(function (x, y, r, g, b, a)
		if isSameColor(cGreen, imgdata:getPixel(x, y)) then return unpack(cGreen)
		else return r, g, b, a 
		end
	end)

	-- return original
	return workingImage
end

function AnimationEditor:toggleProperty(p, a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self.activeFrame
	-- local ff = self:uniqueFrameByIndex(a.frames, f)
	
	local ff, pp = self.unpackProperty(self:getFrameRaw(a, f), p)
	ff[pp] = not ff[pp]
end

function AnimationEditor:togglePropertyTemplate(p, a)
	a = a or self:getActiveAnimation(false)
	-- print("Opening anim", p, a)
	local ff, pp = self.unpackProperty(a.template, p)
		-- print("Inner check", ff, pp, ff[pp])
		if ff[pp] then ff[pp] = false
		else ff[pp] = true
	end
end


function AnimationEditor:handleReservedInputs(key)
	-- What we need: A function that takes the f (self.setSelection), the params (a table, optional), 
	
	local inputModeReservations = {
		Box = {
			x = {self.setSelection, {false, false, 1}}, 
			y = {self.setSelection, {false, false, 2}}, 
			w = {self.setSelection, {false, false, 3}}, 
			h = {self.setSelection, {false, false, 4}}, 
			i = {self.initBoxes, self.selection.name},
			["+"] = {self.setSelection, {false, getShift(self:getSelectionName(2) or 1, self:getSelectionSize(1), 1), false}}, 
			["-"] = {self.setSelection, {false, getShift(self:getSelectionName(2) or 1, self:getSelectionSize(1), -1), false}}, 
			insert = {self.addUniqueBox}, 
			delete = {self.deleteUniqueBox},
		},
		
		Flag = {
			m = {self.togglePropertyTemplate, {"flags", "movement"}},
			t = {self.togglePropertyTemplate, {"flags", "stance"}},
			n = {self.togglePropertyTemplate, {"flags", "normal"}},
			s = {self.togglePropertyTemplate, {"flags", "special"}},
			c = {self.togglePropertyTemplate, {"flags", "cmdnormal"}},
		},
	}
	
	
	
	local usedReservedInput = false
	for k, v in pairs(inputModeReservations) do
		if k == self.inputMode then
			--print("Proper input mode achieved.")
			for kk, vv in pairs(v) do
				--print(kk, vv)
				if key == kk then
					--print("Inner function is being executed")
					local func = vv[1]
					func(self, vv[2])
					usedReservedInput = true
				end
			end
		end
	end
	
	return usedReservedInput
end

function AnimationEditor:addUniqueBox(i)
	local p = self:getSelectionName(1)
	local pos = self:getSelectionName(2)
	local boxes = self:getProperty(p) -- should return the hitboxes table
	table.insert(boxes, pos, {0, 0, 0, 0})
	self:setProperty(p, boxes)
end

function AnimationEditor:deleteUniqueBox(i)
	local p = self:getSelectionName(1)
	local pos = self:getSelectionName(2)
	local boxes = self:getProperty(p) -- should return the hitboxes table
	if #boxes > 0 then
		table.remove(boxes, pos)
	end
	self:setProperty(p, boxes)
end

function AnimationEditor.compareProperties(p1, p2)
	-- print("Entered compareProperties.", type(p1), type(p2))
	if (type(p1) ~= type(p2)) then return false 
	else
		-- print("Else", type(p1))
		if type(p1) == "table" then
			for k, v in pairs(p1) do
				-- print(k, v, p2[k])
				if ((k ~= "__index") and (AnimationEditor.compareProperties(v, p2[k]) == false)) then
					return false
				end
			end
			return true
		else
			return (p1 == p2)
		end
	end
end

function AnimationEditor:eliminateDuplicateProperties() -- this isn't a function, it's a gesture of surrender
	-- I can't find the bug that causes duplication so I can't do anything but clean up after it
	
	for k, v in pairs(self.localAnims) do
		-- print(v.frames, v.template, v.movement, v.cancels)
	
		for k2, v2 in pairs(v.frames) do
			local newFrame = {}
			for k3, v3 in pairs(v2.frame) do
				if k3 ~= "__index" then
					if self.compareProperties(v3, v.template[k3]) == false then
						newFrame[k3] = v3
					end
				end
			end
			v.frames[k2].frame = newFrame
		end
	end
	
end

function AnimationEditor:handleKey(key)
	if (self:handleReservedInputs(key) == false) then
		-- shift+arrows does different steps.
		-- shift+up/down - jump through categories
		-- shift+left/right - single frame jump or same property jump, whichever is not the normal behavior rn
		if ((self.consoleMode) and (#key == 1)) then
			-- print("First case happened for no reason")
			self.textbox = self.textbox .. key
		elseif key == "up" then
			self:pausePlayback()
			self:switchAnimation(-1)
			self:setSelection()
		elseif key == "down" then
			self:pausePlayback()
			self:switchAnimation(1)
			self:setSelection()
		elseif key == "left" then
			self:pausePlayback() 
			if love.keyboard.isDown("lshift") then
				self:switchUniqueFrame(-1)
			else
				self.activeFrame = self.activeFrame - 1
				if self.activeFrame < 1 then
					self.activeFrame = self:getAttackData()
				end
			end
			self:setSelection()
		elseif key == "right" then
			self:pausePlayback() 
			if love.keyboard.isDown("lshift") then
				self:switchUniqueFrame(1)
			else
				self.activeFrame = self.activeFrame + 1
				if self.activeFrame > self:getAttackData() then
					self.activeFrame = 1
				end
			end
			self:setSelection()
		elseif key == "space" then
			if self.templateActive then
				self:pausePlayback()
				self.activeFrame = 1
				EditorStage.all_objects[1].frame = 1
			end
			self:togglePlayback()
		elseif key == "l" then -- Toggle loop.
			self.loopPlayback = not self.loopPlayback
		elseif key == "f7" then -- Export the current animation
			self:writeAnimationsToStdout()	
		elseif key == "f8" then
			updateWhiteUnderlays(2, 16, 16)	
		elseif key == "f9" then
			self:setSelection("Frame Import")
		elseif key == "f10" then -- I don't think this does anything
			self.consoleMode = not self.consoleMode
		elseif key == "return" then -- Commit the current value. (Should this be automatic?)
			self:setSelectionValue()
			if self:getSelectionName() ~= "Frame Import" then
				if love.keyboard.isDown("lalt") then
					for k, v in pairs(self.localAnims) do -- set prop across ALL anims
						self:setPropertyAnimwide(self.selection.name, self.selection.value, v) 
					end
				elseif love.keyboard.isDown("lshift") then -- set prop across one anim
					self:setPropertyAnimwide(self.selection.name, self.selection.value)
				else -- set prop for this one frame
					self:setProperty(self.selection.name, self.selection.value)
				end
			end
		elseif string.find(key, "%d") and #key == 1 then -- Digits.
			self.textbox = self.textbox .. key
		elseif key == "backspace" then
			self.textbox = love.keyboard.isDown("lshift") and '' or string.sub(self.textbox, 1, -2)
		elseif key == "tab" then 	-- switch between the first animation and the current animation, for quick comp. to idle
			if self.activeIndex ~= 1 then
				self.lastIndex = self.activeIndex
				self:switchAnimation(1, true)
			else
				self:switchAnimation(self.lastIndex, true)
			end	
		elseif key == "insert" then
			self:insertUniqueFrame()
		elseif key == "delete" then
			if self:getSelectionName() == "Delete Frame" then
				self:deleteUniqueFrame()
			else
				self:setSelection("Delete Frame")
			end
		elseif key == "w" then	-- delete active property
			if self.templateActive then
				self:setPropertyTemplate(self.selection.name, 0) -- TODO should properly respect lower limits.
			else
				if love.keyboard.isDown("lshift") then
					self:deletePropertyAnimwide()
				else
					self:deleteProperty(activeFrame)
				end	
			end
		elseif key == "m" then 	-- set selection to movement edit
			self:setSelection((self:getSelectionName() == "mx") and "my" or "mx")
		elseif key == "o" then 	-- set selection to origin edit
			self:setSelection((self:getSelectionName() ==  "ox") and "oy" or "ox")
		elseif key == "s" then 	-- set selection to sheet position edit
			self:setSelection((self:getSelectionName() == "sx") and ((self:getSelectionName() ==  "sy") and "sheet" or "sy") or "sx")
		elseif key == "n" then -- Negate the input.
			self.textbox = (string.sub(self.textbox, 1, 1) == '-' and string.sub(self.textbox, 2) or '-' .. self.textbox)
		elseif key == "q" then -- Remove the active selection
			self:setSelection()
		elseif key == "h" then -- Set hit number
			self:setSelection("hit")
		elseif key == "b" then -- Set hitbox
			self:setSelection({"hitboxes", 1, 1})
		elseif key == "c" then -- Set collbox
			self:setSelection({"collboxes", 1, 1})
		elseif key == "u" then -- Set hurtbox
			self:setSelection({"hurtboxes", 1, 1})
		elseif key == "a" then
			self:setSelection("attackEffect")
		elseif key == "f" then -- set flags
			self:setSelection("flags")
		elseif key == "d" then
			self:setSelection("damage")
		elseif key == "l" then
			self:setSelection("attacklevel")
		elseif key == "+" then -- lengthen active frame by 1
			self:lengthenFrame(1)
		elseif key == "-" then -- shorten active frame by 1. Can't delete.
			self:lengthenFrame(-1)
		elseif key == "t" then -- Toggle between editing normal frames & the template.
			if self.templateActive then
				self.activeFrame = 1
				EditorStage.all_objects[1].frame = 1
				self.templateActive = false
			else
				self:pausePlayback()
				self.templateActive = true
			end
			self:setSelection()
		elseif key == "c" then	-- copies the active property from the previous frame to the current frame.
			if love.keyboard.isDown("shift") then -- shift+c copies all properties.
				for i = 1, #self.serializationOrder do
					self:copyProperty({self.serializationOrder[i]})
				end			
			else
				self:copyProperty()
			end			
		end
	end
end

function AnimationEditor:copyProperty(p, index1, index2, anim1, anim2)
	p = p or self.selection.name

	index2 = index2 or self.activeIndex
	anim2 = anim2 or self:getActiveAnimation(false)
	anim1 = anim1 or self:getActiveAnimation(false)
	
	index1 = index1 or getShift(index2, #anim2, -1)
	
	local copyProp = self:getProperty(p, anim1, index1)
	self:setProperty(p, copyProp, anim2, index2)
end

function AnimationEditor:getFrameLength(i, anim)
	local l = 1
	
	local currentIndex = getShift(i, #anim, 1)
	local lastIndex = i
	while (self.compareFrames(anim[currentIndex], anim[lastIndex])) do
		if currentIndex == 1 then 
			return l
		end
		l = l + 1
		lastIndex = currentIndex
		currentIndex = getShift(currentIndex, #anim, 1)
	end
	return l
end

function AnimationEditor:togglePlayback()
	self.playback = not (self.playback)
end

function AnimationEditor:pausePlayback()
	self.playback = false
end


function AnimationEditor:switchAnimation(i, set)
	i = i or 1
	set = set or false
	self.activeIndex = set and i or getShift(self.activeIndex, #self.animOrder, i)
	self.activeFrame = 1
	EditorStage.all_objects[1].frame = self.activeFrame
	EditorStage.all_objects[1].state = self:getActiveAnimation()
end

function AnimationEditor:switchUniqueFrame(i)
	local anim = self:getActiveAnimation().animation.frames
	local currentIndex = self.activeFrame
	
	
	i = i or 1
	if i < 0 then
		for j = 1, -i do
			currentIndex = getShift(currentIndex, #anim, -1)
			local lastIndex = self.activeFrame
			while (self.compareFrames(anim[currentIndex], anim[lastIndex])) do
				if currentIndex == #anim then break end
				lastIndex = currentIndex
				currentIndex = getShift(currentIndex, #anim, -1)
			end
		end
	
	end
	if i > 0 then
		for j = 1, i do
			currentIndex = getShift(currentIndex, #anim, 1)
			local lastIndex = self.activeFrame
			while (self.compareFrames(anim[currentIndex], anim[lastIndex])) do
				--print("Step")
				if currentIndex == 1 then break end
				lastIndex = currentIndex
				currentIndex = getShift(currentIndex, #anim, 1)
			end
		end
	end
	
	self.activeFrame = currentIndex
	EditorStage.all_objects[1].frame = self.activeFrame
end



function AnimationEditor.draw()
	EditorStage:draw()
end

function deepPrint(o, l, pk)
	l = l or 0
	pk = pk or "No key"
	if type(o) == "table" then
		for k, v in pairs(o) do
			if l <= 0 then
				print(l, k, v)
			elseif k ~= "next_state" then
				print(l, k, v)
				deepPrint(v, l-1, k)
			end
		end
	else
		print(l, pk, o)
	end
end

function AnimationEditor:getAttackData(a, h)
	-- returns startup, active and recovery frames, which sum up to total frames, for a given hit

	a = a or self:getActiveAnimation(false)
	h = h or 1
	
	local startup, active, recovery = 0, 0, 0
	local noHit = true
	
	
	for i = 1, #a.frames do
		if a.frames[i].frame.hit == h then
			noHit = false
			active = active + a.frames[i].duration
		elseif noHit then
			startup = startup + a.frames[i].duration
		else
			recovery = recovery + a.frames[i].duration
		end
	end
	return (startup + active + recovery), startup, active, recovery
end

function AnimationEditor:getTemplate(a)
	a = a or self:getActiveAnimation(false)
	return a.template
end

function AnimationEditor:getFrame(a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self.activeFrame
	
   local ff = self:uniqueFrameByIndex(a.frames, f)
	local tFrame = a.template:new(a.frames[ff].frame)
	return tFrame
end

function AnimationEditor:getFrameRaw(a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self.activeFrame
	
   local ff = self:uniqueFrameByIndex(a.frames, f)
	local tFrame = a.frames[ff].frame
	return tFrame
end

function AnimationEditor:getMovement(a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self.activeFrame

	-- local ff = self:uniqueFrameByIndex(a.frames, f)
	return a.movement[f] or {0, 0}
end

function AnimationEditor:setMovement(m, a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self.activeFrame
	local mOld = self:getMovement(a, f)
	
	local m2 = {0, 0}
	for i = 1, 2 do
		m2[i] = (m[i] or mOld[i] or 0)
	end
	a.movement[f] = m2
end

function AnimationEditor:getProperty(p, a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self.activeFrame
	local ff, pp = self.unpackProperty(self:getFrame(a, f), p)
	-- print(ff, pp)
	
	
	if pp == "Frame Import" then return "0"
	elseif pp == "mx" then
		return self:getMovement(a, f)[1]
	elseif pp == "my" then
		return self:getMovement(a, f)[2]
	else
		if type(ff) ~= "table" then return 0 end
		if (ff[pp] ~= nil) then
			return ff[pp]
		else
			return self:getPropertyTemplate(p, a)
		end
	end
end

function AnimationEditor:getPropertyTemplate(p, a)
	a = a or self:getActiveAnimation(false)
	if p == "Frame Import" then return "0"
	else
		local ff, pp = self.unpackProperty(self:getTemplate(a), p)
		if type(ff) ~= "table" then return "0" end
		return ff[pp]
	end
end

function AnimationEditor.unpackProperty(frame, p)
	if type(p) == "table" then
		for i = 1, #p - 1 do
			-- if frame[p[i]] == nil then print(i, frame[p[i]], p[i]) end
			frame = frame[p[i]]
		end
		return frame, p[#p]
	end
	return frame, p
end

function AnimationEditor:initBoxes(p, a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self.activeFrame
	local ff = self:uniqueFrameByIndex(a.frames, f)
	
	a.frames[ff].frame[p[1]] = {{0, 0, 0, 0}}
	-- print("#TST", a, f, ff, p[1], p[2], p[3])
	-- print("#TST2", a.frames[ff], a.frames[ff][p[1]], a.frames[ff][p[1]][1], a.frames[ff][p[1]][1][1])
end

function AnimationEditor:setProperty(p, v, a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self.activeFrame
	-- local ff = self:uniqueFrameByIndex(a.frames, f)

	-- print(a, f)
	-- print("")
	print("K/V check", a, f)
	
	for k, v in pairs(self:getFrame(a, f)) do
		print(k, v)
	end
	
	local ff, pp = self.unpackProperty(self:getFrame(a, f), p)
	print(a, f, ff, pp)
	
	if pp == "mx" then
		self:setMovement({v, false}, a, f)
	elseif pp == "my" then
		self:setMovement({false, v}, a, f)
	else
		-- local ff, pp = self.unpackProperty(self:getFrameRaw(a, f), p)
		ff[pp] = v
	end
end

function AnimationEditor:setPropertyTemplate(p, v, a)
	p = p or self.selection.name or mx
	v = v or self.selection.value or 0
	a = a or self:getActiveAnimation(false)
	if (p ~= "mx" and p ~= "my") then
		local ff, pp = self.unpackProperty(a.template, p)
		ff[pp] = v
	end
end

function AnimationEditor:setPropertyAnimwide(p, v, a)
	if p == "mx" or p == "my" then
		for i = 1, self:getAttackData(a) do
			self:setMovement(v, a, i)
		end
	else
		self:deletePropertyAnimwide(p, a)
		self:setPropertyTemplate(p, v, a)
	end
end

function AnimationEditor:lengthenFrame(t, f, a)
	t = t or 1
	f = f or self.activeFrame
	a = a or self:getActiveAnimation(false)
	
	local ff = self:uniqueFrameByIndex(a.frames, f)
	local d = a.frames[ff].duration
	
	local dd = math.max(d + t, 1)
	a.frames[ff].duration = dd	
end

function AnimationEditor:deleteProperty(p, a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self:uniqueFrameByIndex(a.frames, self.activeFrame)
	
	if p == "mx" or p == "my" then
		a.movement[f] = {0, 0}
	else
		a.frames[f].frame[p] = nil	
	end
end

function AnimationEditor:deletePropertyAnimwide(p, a)
	a = a or self:getActiveAnimation(false)
	for i = 1, #a.frames do
		self:deleteProperty(p, a, i)
	end
end

function AnimationEditor:uniqueFrameByIndex(a, i)
	for j = 1, #a do
		i = i - a[j].duration
		if (i <= 0) then return j end
	end
	return 1
end

function AnimationEditor:insertUniqueFrame(a, f)
	a = a or self:getActiveAnimation(false)
	f = f or self.activeFrame
	local ff = self:uniqueFrameByIndex(a.frames, f)
	
	table.insert(a.frames, ff, {frame = a.template:new(), duration = 1})
	
	-- local ff = self:uniqueFrameByIndex(a.frames, f)

	-- table.insert(a.frames, ff+1, {frame = AnimFrame:new(), duration = 1})
end

function AnimationEditor:deleteUniqueFrame(a, f)
	f = f or self.activeFrame
	a = a or self:getActiveAnimation(false)
	local ff = self:uniqueFrameByIndex(a.frames, f)
	
	if #a.frames > 1 then
		table.remove(a.frames, ff)
	end	
end

function AnimationEditor:addAnimation(name, tFrame)
	tFrame = tFrame or self.hardcodedTemplates.grounded
	if name then
		local tIndex = #self.localAnims + 1
		self.animOrder[tIndex] = name
		self.localAnims[tIndex] = {
			template = templateFrame,
			frames = {},
			movement = {}
		}
		self:insertUniqueFrame(self.localAnims[tIndex], 1)
	end
end

-- function Interface:drawEditorDebug()
	-- self:setLayer("ui")
	-- love.graphics.setColor(1, 1, 1, 1)

-- end