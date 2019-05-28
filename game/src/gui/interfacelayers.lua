	
	-- debuginfo = love.graphics.newCanvas(unpack(__gamesize)),
	-- menu = love.graphics.newCanvas(unpack(__gamesize))

Interface:initLayer("debug")
Interface.layers.debug.scaleFactor = 2


function Interface.layers.debug:drawToCanvas()
	self:setComponent()
	
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.print(CameraFollowPlayer.viewpoint[1], Interface.gameSize[1] - 100, 20)
	love.graphics.print(CameraFollowPlayer.viewpoint[2], Interface.gameSize[1] - 100, 40)
	love.graphics.print(1 / love.timer.getAverageDelta(), 0, 60) -- display FPS
	-- if InputTable:hasInputSequence(Sequence_QCF, 2, 45) then
	love.graphics.print(APC.state.id, 0, 80)
	local chainstr = ""
	for i = 1, #APC.chain do
		chainstr = chainstr .. APC.chain[i] .. "  "
	end
	love.graphics.print(chainstr, 0, 100)
	
	local joysticks = love.joystick.getJoysticks()
	for i, joystick in ipairs(joysticks) do
	
		love.graphics.print(joystick:getName(), 0, i * 15)
		love.graphics.print(joystick:getHat(i), 160, i * 15)
		local axes = joystick:getAxisCount()
		for j = 1, axes do
			love.graphics.print(math.floor((joystick:getAxis(j) + 0.0005) * 1000) / 1000, 180 + 60*j, i * 15)
		end
	end

end


Interface:initLayer("command_list")


function Interface.layers.command_list:drawToCanvas()
	self:setComponent()
	MenuCommandList:drawSelf()
end

function Interface.layers.command_list:handleKeyboard(key, scancode, isrepeat)
	if key == "up" then
		self.activeIndex = (self.activeIndex <= 1 and #self.dataList or self.activeIndex - 1)
		if self.activeIndex == #self.dataList then 
			self.topIndex = #self.dataList - self.commandDisplaySize + 1 		
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
	
	return true
end

function Interface.layers.command_list:handleJoystick(joystick, button)
	return true
end


Interface:initLayer("animation_editor_UI")

function Interface.layers.animation_editor_UI:drawToCanvas()
	self:setComponent()	
	-- Interface:drawEditorDebug()
	
	local descList = {
		"Animation",
		"Frame",
		"Sheet Nr",
		"Sheet X",
		"Sheet Y",
		"Origin X",
		"Origin Y",
		"Move X",
		"Move Y",
		"Startup",
		"Active",
		"Recovery",
		"Total"
	}
	
	ae = AnimationEditor
	aAnim = AnimationEditor:getActiveAnimation()
	aFrame = AnimationEditor:getActiveFrame(false)

	assert(aFrame, "aFrame should REALLY be defined")

	-- if aFrame == nil then
		-- print("Here we fucking go")
		-- print(ae:getActiveAnimation(false), ae:getActiveAnimation(false).frames)
		-- for k, v in pairs(ae:getActiveAnimation(false).frames) do
			-- print(k, v)
			-- for k2, v2 in pairs(v) do
				-- print(k, k2, v2)
			-- end
		-- end
	-- end
	
	--local x = ae:getProperty("sx", true)
	
	local displayList = {
		function() return aAnim.id end,
		function() return AnimationEditor.activeFrame end,
		function() return aFrame.sheet end,
		function() return ae:getProperty("sx") end,
		function() return ae:getProperty("sy") end,
		function() return ae:getProperty("ox") end,
		function() return ae:getProperty("oy") end,
		function() return ae:getProperty("mx") end,
		function() return ae:getProperty("my") end,
		function() local _, s, _, _ = ae:getAttackData() return s end,
		function() local _, _, s, _ = ae:getAttackData() return s end,
		function() local _, _, _, s = ae:getAttackData() return s end,
		function() local s, _, _, _ = ae:getAttackData() return s end,
	}
	
	love.graphics.print("Input Mode", 10, 520)
	love.graphics.print(tostring(ae.inputMode), 100, 520)
	
	for i = 1, #descList do
		love.graphics.print(descList[i], 10, 10+15*i)
		love.graphics.print(tostring(displayList[i]()), 100, 10+15*i)
	end

	love.graphics.print("Selection Name", 490, 10)
	love.graphics.print("Selection Value", 490, 25)
	love.graphics.print("Textbox", 490, 40)
	
	
	love.graphics.print(tostring(ae.selection.name[1]), 620, 10)
	love.graphics.print(tostring(ae.selection.name[2]), 720, 10)
	love.graphics.print(tostring(ae.selection.name[3]), 820, 10)
	love.graphics.print(tostring(ae.selection.value), 620, 25)
	
	love.graphics.print(ae.textbox, 620, 40)

	if ae.inputMode == "Box" then
		local vals = {"x", "y", "w", "h"}
		love.graphics.print("Extended Values", 490, 55)
		love.graphics.print("Box dimensions", 540, 70)
		for i = 1, 4 do
			love.graphics.print(vals[i], 540 + 80*i, 70)
			love.graphics.print(tostring(ae:getProperty({ae.selection.name[1], ae.selection.name[2], i})), 540 + 80*i, 85)
		end
	elseif ae.inputMode == "Flag" then
		local vals = {"movement", "stance", "normal", "special", "cmdnormal"}
		
		love.graphics.print("Extended Values", 490, 55)
		love.graphics.print("Move flags", 540, 70)
		for i = 1, 4 do
		
			love.graphics.print(vals[i], 540 + 80*i, 70)
			love.graphics.print(tostring(ae:getProperty({ae.selection.name[1], vals[i]})), 540 + 80*i, 85)
		end
	end
end

function Interface.layers.animation_editor_UI:handleKeyboard(key, scancode, isrepeat)
	AnimationEditor:handleKey(key)
	return true
end





Interface:initLayer("main_game_UI")

function Interface.layers.main_game_UI:drawToCanvas()
	self:setComponent()
	
	-- whatever the hell happened here
end

function Interface.layers.main_game_UI:handleKeyboard(key, scancode, isrepeat)
	-- write appropriate stuff to the inputtable
	return true
end

function Interface.layers.main_game_UI:handleJoystick(joystick, button)
	return true
end


Interface:initLayer("main_game", {"parallax", "background", "foreground", "player", "overlays"})
Interface.layers.main_game.camera = CameraFollowPlayer

function Interface.layers.main_game:clean()
	love.graphics.setColor(1, 1, 1, 1)
	self:setComponent("background")
end

function Interface.layers.main_game:drawToCanvas()
	self:clean()
	ActiveStage:draw()
end

function Interface.layers.main_game:handleKeyboard(key, scancode, isrepeat)
	InputTable:handleKeyInput(key)
	return true
end

function Interface.layers.main_game:handleJoystick(joystick, button)
	InputTable:handleJoyInput(joystick, button)
	return true
end


Interface.layers.main_game.backgroundCanvas = (function()
	
	local bgcanvas = love.graphics.newCanvas(2048, 2048)
	
	local light_color = {0.0625, 0.08, 0.0575, 1}
	local dark_color = {0.04, 0.05, 0.04, 1}
	local line_color = {0.15625, 0.28125, 0.15625, 1}
	local tile_size = 96
	local line_dist = 198
	
	love.graphics.setCanvas(bgcanvas)
	
	for i = 0, 16 do
		for j = 0, 16 do
			if (i + j) % 2 == 1 then
				love.graphics.setColor(light_color)
			else 
				love.graphics.setColor(dark_color)
			end
			love.graphics.rectangle(
				"fill", 
				tile_size * (i-1), 
				tile_size * (j-1), 
				tile_size, tile_size
			)
		end
	end
	
	love.graphics.setCanvas()
	
	return bgcanvas
end)()
-- immediate execution of the function. backgroundCanvas is the return value of the anonymous function, instead of the function itself.


function Interface.layers.main_game:drawBackground()
	self:setComponent("parallax")
	local tileSize = 96
	local topLeft = {self.camera.viewpoint[1] % (tileSize * 2), self.camera.viewpoint[2] % (tileSize * 2)}
	love.graphics.draw(self.backgroundCanvas, -topLeft[1], -topLeft[2])
end

function Interface.layers.main_game:drawToCanvas()
	self:drawBackground()
	
	for _, obj in ipairs(GameStateManager:getActiveStage().all_objects) do
		-- print("XXX", _, obj)
	
		obj:draw()
	end
end

-- function Stage:draw()
	
	-- for i = 1, #self.all_objects do
		-- self.all_objects[i]:draw()
	-- end
-- end


function MapObject.getExtendedBox(box, i)
	return {box[1] - i, box[2] - i, box[3] + 2*i, box[4] + 2*i}
end


function MapObject:getOrigin(ox, oy)
	local ofs = self.standardOrigin or {0, 0}
	return ofs[1] + ox, ofs[2] + oy
end

function MapObject.drawSprite(sprite, x, y, ox, oy, facing)
	facing = facing or 1
	love.graphics.draw(sprite, math.floor(x + 0.5), math.floor(y + 0.5), 0, facing * Interface:getMainLayer().actorScaleFactor, Interface:getMainLayer().actorScaleFactor, ox, oy)
end

function MapObject.drawSpriteQ(sprite, quad, x, y, ox, oy, facing)
	facing = facing or 1
	love.graphics.draw(sprite, quad, math.floor(x + 0.5), math.floor(y + 0.5), 0, facing * Interface:getMainLayer().actorScaleFactor, Interface:getMainLayer().actorScaleFactor, ox, oy)
end


function MapObject:draw()
	Interface.layers.main_game:setComponent("background")
	
	for _, collbox in ipairs(self.collboxes) do
		self.drawBox(self:alignBox(collbox), Colors.blue, 255)
	end
	-- self.drawBox(self.masterbox_coll, Colors.blue, 255)
	--self.drawBox(self.masterbox_damage, Colors.green, 255)
	-- self:drawPivot()
end

function MapObject:drawBoxes(boxes, color, alpha)
	for i = 1, #boxes do
		local defBox = {0, 0, 0, 0}
		for j = 1, 4 do
			defBox[j] = boxes[i][j] or defBox[j]
		end
		self.drawBox(self:alignBox(defBox), color, alpha)
	end
end

function MapObject:alignBox(box)
	return Rect.translate(box, self.position, self.facing or 1)
end

function MapObject:alignBoxes(boxes)
	local b = {}
	for i = 1, #boxes do
		b[i] = self:alignBox(boxes[i])
	end
	return b
end

function MapObject.drawBox(box, color, alpha)
	-- color[4] = math.ceil(alpha / 4)
	-- love.graphics.setColor(color)
	-- love.graphics.rectangle("fill", box[1], box[2], box[3], box[4])
	color[4] = alpha
	love.graphics.setColor(color)

	love.graphics.setLineStyle("rough")
	love.graphics.rectangle("line", box[1] - Interface:getCamera().viewpoint[1], box[2] - Interface:getCamera().viewpoint[2], box[3], box[4])
	color[4] = 255
end

function MapObject:drawPivot() -- Pivot := Position where the map object actually "is", in engine terms. Typically somewhere between the feet.
	local px, py = math.floor(self.position[1] + 0.5), math.floor(self.position[2] + 0.5)
	local radius = 4
	local vp = Interface:getCamera().viewpoint
	
	local vertices = {px + radius - vp[1], py - vp[2], px - vp[1], py - radius - vp[2], px - radius - vp[1], py - vp[2], px - vp[1], py + radius - vp[2]}
	love.graphics.setColor(self.color)
	love.graphics.polygon("fill", vertices)
end



function Actor:drawContent()
	love.graphics.setColor(1, 1, 1, 1)
	local aframe = self:getFrame()
	assert(aframe, "Aframe SHOULD NOT BE NIL")

	if self.spritesheet == false then
		self.drawSprite(aframe.sprite.gfx, self.position[1] - Interface:getCamera().viewpoint[1], self.position[2] - Interface:getCamera().viewpoint[2], aframe.sprite.ox, aframe.sprite.oy, self.facing)
	else
		local sht = (self.spritesheet[aframe.sheet] or self.spritesheet)	
		local sxx = aframe.sx 
		local syy = aframe.sy
		local oxx, oyy = self:getOrigin(aframe.ox, aframe.oy)
		
		sxx = (sxx < 32) and sxx * aframe.sw or sxx
		syy = (syy < 32) and syy * aframe.sh or syy
		self.quad:setViewport(sxx, syy, aframe.sw, aframe.sh)
		
		self.drawSpriteQ(sht, self.quad, self.position[1] - Interface:getCamera().viewpoint[1], self.position[2] - Interface:getCamera().viewpoint[2], oxx, oyy, self.facing)
	end

end

function Actor:drawBoxOverlay()
	Interface.layers.main_game:setComponent("overlays")
	self:drawBoxes(aframe.collboxes, Colors.blue, 255)
	--self.drawBox(MapObject.getExtendedBox(self.masterbox_coll, 0), Colors.dark_blue, 255)
	self:drawBoxes(aframe.hitboxes, Colors.red, 255)
	self:drawBoxes(aframe.hurtboxes, Colors.green, 255)
	-- self.drawBox(MapObject.getExtendedBox(self.masterbox_damage, 0), Colors.yellow, 255)
	self:drawPivot()

end

function Actor:draw()
	Interface.layers.main_game:setComponent("foreground")
	self:drawContent()
end

function PlayerCharacter:draw()
	Interface.layers.main_game:setComponent("player")
	self:drawContent()
end