-- during command list mode, this is your inputs:

-- Up/Down: Change active command, one at a time.
-- Left/Right: Goes to next/previous header.
-- RB/LB: Switches through categories. (?)
-- Punch:
-- Kick:
-- Select: Exits command list mode.
--
--
--
--
--
--



MenuCommandList = Object:new{
	activeIndex = 1,
	topIndex = 1,
	dataList = CommandList,
	extendedInfoList = CommandExtendedInfo,
	lineWidth = 473,
	lineHeight = 40,
	indentWidth = 16,
	attackNameSpacing = 4,
	interGlyphDistance = 2,
	standardGlyphSize = 32,
	inputPosition = 320,
	commandDisplaySize = 13,
	colors = {
		text = {0, 0, 0, 1},
		white = {1, 1, 1, 1},
		background = {0.7, 0.62, 0.55, 1},
		activeLine = {1, 0.9, 0.8, 1},
		headerLine = {0.9, 0.8, 0.6, 1},
		inactiveLine = {0.85, 0.75, 0.55, 1},
		darkIndent = {0.6, 0.5, 0.4, 1}
	},
	maxDisplayLevel = 1,
	
}

MenuCommandList.moveLiveFeedPos = {960 - MenuCommandList.lineWidth + 12, 540 - 256 - 6}
MenuCommandList.remarkListPos = {MenuCommandList.lineWidth + 21, 12}


MenuCommandList.glyphs = {
	["D"] = love.graphics.newImage("gfx/Button_Dash.png"),
	["E"] = love.graphics.newImage("gfx/Button_Evade.png"),
	["J"] = love.graphics.newImage("gfx/Button_Jump.png"),
	["K"] = love.graphics.newImage("gfx/Button_Kick.png"),
	["P"] = love.graphics.newImage("gfx/Button_Punch.png"),
	["1"] = love.graphics.newImage("gfx/Arrow_DL.png"),
	["2"] = love.graphics.newImage("gfx/Arrow_D.png"),
	["3"] = love.graphics.newImage("gfx/Arrow_DR.png"),
	["4"] = love.graphics.newImage("gfx/Arrow_L.png"),
	["5"] = love.graphics.newImage("gfx/Arrow_C.png"),
	["6"] = love.graphics.newImage("gfx/Arrow_R.png"),
	["7"] = love.graphics.newImage("gfx/Arrow_UL.png"),
	["8"] = love.graphics.newImage("gfx/Arrow_U.png"),
	["9"] = love.graphics.newImage("gfx/Arrow_UR.png"),
}

function MenuCommandList:parseCommandList()
	self.textList = {}
	self.remarkList = {}
	for i = 1, #self.dataList do
		local moveName = self.dataList[i].movename
	
		self.textList[i] = love.graphics.newText(FontBenegraphicLarge)
		self.textList[i]:set(moveName)
		
		self.remarkList[i] = love.graphics.newText(FontAccidentialSmall)
	end
	
end


function MenuCommandList:drawSelf()

	-- background color
	love.graphics.setColor(self.colors.background)
	love.graphics.rectangle("fill", 0, 0, 960, 540)

	-- a line
	love.graphics.setColor(self.colors.inactiveLine)
	love.graphics.rectangle("fill", 6, 0, 8, 540)
	
	-- draw command list
	self:drawCommandList(20, 10)
	love.graphics.setColor(self.colors.white)
	
	-- extrainfo section
	love.graphics.setColor(self.colors.background)
	love.graphics.rectangle("fill", 20, 0, self.lineWidth + 5, 10)
	love.graphics.rectangle("fill", 20, 530, self.lineWidth + 5, 10)
	
	-- draw remark list bright background
	love.graphics.setColor(self.colors.activeLine)
	love.graphics.rectangle("fill", MenuCommandList.remarkListPos[1], MenuCommandList.remarkListPos[2], 500, 255)

	-- draw remark text
	self:drawRemarks(MenuCommandList.remarkListPos[1] + 8, MenuCommandList.remarkListPos[2] + 4, 450)	
	
	-- move "live feed" section, draw 256x256 dark triangle
	love.graphics.setColor(self.colors.darkIndent)
	love.graphics.rectangle("fill", self.moveLiveFeedPos[1], self.moveLiveFeedPos[2], 256, 256)
	APC:drawContentCmdList(self.dataList[self.activeIndex].moveID, self.dataList[self.activeIndex].displayFrame)
	
	-- some lines for aesthetics
	love.graphics.setColor(self.colors.darkIndent)
	love.graphics.rectangle("fill", self.lineWidth + 15, 0, 6, 540)
	love.graphics.rectangle("fill", self.lineWidth + 15, 267, 500, 6)
	
end

function MenuCommandList:drawRemarks(x, y, w)
	local activeCommand = self.dataList[self.activeIndex]
	
	local moveName = activeCommand.movename
	self.remarkList[self.activeIndex]:setf((self.extendedInfoList[moveName] or self.extendedInfoList["Default"]), w, "left")
	
	love.graphics.setColor(self.colors.text)
	love.graphics.draw(self.remarkList[self.activeIndex], x, y)
end

function Actor:drawContentCmdList(state, frame)
	state = state or "Stand"
	state = States.Nun[state]
	frame = frame or 1
	
	love.graphics.setColor(1, 1, 1, 1)
	
	local aframe = state.animation.frames[frame]
	
	local sht = (self.spritesheet[aframe.sheet] or self.spritesheet)	
	local sxx = aframe.sx 
	local syy = aframe.sy
	local oxx, oyy = self:getOrigin(aframe.ox, aframe.oy)
	
	sxx = (sxx < 32) and sxx * aframe.sw or sxx
	syy = (syy < 32) and syy * aframe.sh or syy
	self.quad:setViewport(sxx, syy, aframe.sw, aframe.sh)
	self.drawSpriteQ(sht, self.quad, MenuCommandList.moveLiveFeedPos[1], MenuCommandList.moveLiveFeedPos[2], 0, 0, 1)
	
	
end

function MenuCommandList:drawCommandList(x, y)
	local tlTable = {}
	
	for i = 1, #self.dataList do
		if ((self.maxDisplayLevel < 0) or (self.maxDisplayLevel >= self.dataList[i].indent)) then
			table.insert(tlTable, i)
		end
	end
	
	local modTopIndex = 1
	
	for i = 1, #tlTable do
		if tlTable[i] > self.topIndex then
			modTopIndex = tlTable[(i == 1 and 1 or i-1)]
			break
		end
	end

	for i = 1, #tlTable do
		local j = tlTable[i]
		local offsetIndex = i + 1 - modTopIndex
		self:drawLine(j, x, y + (offsetIndex - 1) * self.lineHeight) 
	end
end




function MenuCommandList:drawLine(index, x, y)
	
	local activeHeaderColor = self.colors.activeLine
	local activeColor = self.colors.activeLine
	local headerColor = self.colors.headerLine
	local inactiveColor = self.colors.inactiveLine
	
	
	
	local bgColor = (index == self.activeIndex and (self.dataList[index].isHeader and activeHeaderColor or activeColor) or (self.dataList[index].isHeader and headerColor or inactiveColor))
	love.graphics.setColor(bgColor)
	love.graphics.rectangle("fill", x+1, y+1, self.lineWidth, self.lineHeight - 2)
	
	love.graphics.setColor(self.colors.darkIndent)
	love.graphics.rectangle("fill", x+1, y+1, self.dataList[index].indent * self.indentWidth, self.lineHeight - 2)
	
	local offsetX = x + (self.dataList[index].indent * self.indentWidth)
	
	love.graphics.setColor(self.colors.text)
	love.graphics.draw(self.textList[index], offsetX + 8, y + 4)
	
	love.graphics.setColor(self.colors.white)
	
	local standardGlyphX = x + self.lineWidth - 10
	
	for j = 1,  #self.dataList[index].command do
		self:drawInputGlyph(self.dataList[index].command[j], standardGlyphX - ((#self.dataList[index].command - j + 1) * (self.standardGlyphSize + self.interGlyphDistance*2)), y)
	end
	
	-- for j = 1, #self.dataList[index].command do
		-- self:drawInputGlyph(self.dataList[index].command[j], x + self.inputPosition + (j-1)*(self.standardGlyphSize + self.interGlyphDistance*2), y)
	-- end
	
end

function MenuCommandList:drawInputGlyph(str, x, y)
	local glyph = self.glyphs[str] or self.glyphs["5"]
	local offset = math.floor((self.lineHeight - glyph:getHeight()) / 2)
	
	love.graphics.draw(glyph, x + offset, y + offset)	
end

function MenuCommandList:handleKeyInput(key)
	if key == "up" then
		self.activeIndex = (self.activeIndex <= 1 and #self.dataList or self.activeIndex - 1)
		if self.activeIndex == #self.dataList then self.topIndex = #self.dataList - self.commandDisplaySize + 1 		
		elseif self.topIndex > self.activeIndex then
			self.topIndex = (self.topIndex <= 1 and #self.dataList or self.topIndex - 1)
			self:setTopIndex(self.topIndex)
		end
	elseif key == "down" then
		self.activeIndex = (self.activeIndex >= #self.dataList and 1 or self.activeIndex + 1)
		if self.activeIndex == 1 then self.topIndex = 1
		elseif self.topIndex < self.activeIndex - self.commandDisplaySize + 1 then
			self.topIndex = (self.topIndex >= #self.dataList and 1 or self.topIndex + 1)
			self:setTopIndex(self.topIndex)
		end
	elseif key == "left" then
	elseif key == "right" then
	end
end

function MenuCommandList:setTopIndex(i)
	local tIndex = i
	if tIndex > (#self.dataList - self.commandDisplaySize + 1) then tIndex = #self.dataList - self.commandDisplaySize + 1 end
	self.topIndex = tIndex
end


MenuCommandList:parseCommandList()