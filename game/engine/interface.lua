FontBenegraphicLarge = love.graphics.newFont("font/beneg___.ttf", 32)
FontAccidentialSmall = love.graphics.newFont("font/accid___.ttf", 20)

-- Controls (keyboard only for now?)


-- Graphical User Interface


-- GameCanvas = love.graphics.newCanvas(unpack(__gamesize))
-- GameCanvas:setFilter("nearest", "nearest")	-- use nearest neighbour scaling for up/downscale

Interface = Object:new{
	gameSize = __gamesize,
	activeLayers = {},
	layers = {},
}



function Interface:getActiveLayersInDrawOrder()
	local orderedLayers = {}
	for k, v in ipairs(self.activeLayers) do
		orderedLayers[k] = v
	end
	return orderedLayers
end

function Interface:getActiveLayersInInputOrder()
	local orderedLayers = {}
	for k, v in reverse_ipairs(self.activeLayers) do
		orderedLayers[k] = v
	end
	return orderedLayers
end


function Interface:draw()
	
	self:drawStack()
	if __DEBUGMODE then
		Interface.layers.debug:cycleDraw()
	end
end


function Interface:drawStack()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setCanvas()
	
	for _, layer in ipairs(self:getActiveLayersInDrawOrder()) do	
		-- print("XXX", layer.ID, layer)
		layer:cycleDraw()
	end

end


function Interface:updateScreenSizePos() -- center the game window on screen
	local baseGameSize = __gamesize
	local _, _, wFlags = love.window.getMode()
	if (wFlags.fullscreen == false) then
		local displayID = wFlags.display or 1
		local dw, dh = love.window.getDesktopDimensions(displayID)
		
		local sx = baseGameSize[1] * self.scaleFactor
		local sy = baseGameSize[2] * self.scaleFactor
		
		love.window.setMode(sx, sy, {centered = true})
	end

end


function Interface:toggleDebug(forceDebugOn)
	-- forceDebugOn = forceDebugOn or false
	-- local no_debug = true
	
	-- self:activateLayer(InterfaceLayer)
	
end

function Interface:clean()
	love.graphics.setColor(1, 1, 1, 1)
end

function Interface:setShake(s)	-- dummied out, re-enable later
	-- s.frame = 1
	-- table.insert(self.fx, s)
end

function Interface:handleKeyboard(key, scancode, isrepeat)
	local input_consumed = false
	
	input_consumed = self:handleSystemInputs(key, scancode, isrepeat)
	
	if __DEBUGMODE and (not input_consumed) then
		input_consumed = Interface.layers.debug:handleKeyboard(key, scancode, isrepeat)
	end
	

	for _, layer in ipairs(self:getActiveLayersInInputOrder()) do
		if (not input_consumed) then
			input_consumed = layer:handleKeyboard(key, scancode, isrepeat)
		end
	end
	
	-- if MenuSystem:isInterceptingInput() then
			-- MenuSystem:handleKeyboard(key)
		-- else
			-- if InputTable:isKB() then
				-- if ButtonConfig[InputTable.controller][key] ~= nil then
					-- local i = InputTable.newInput()
					-- i[ButtonConfig[InputTable.controller][key]] = true
					-- InputTable:pushInput(i)
				-- end
			-- end
			-- if Interface.animEditActive then
				-- AnimationEditor:handleKey(key)
			-- end	
		-- end			
		-- Interface:handleDebugKeys(key)
	
end



function Interface:handleSystemInputs(key, scancode, isRepeat)
	if key == "f12" then
		self:toggleAnimationEditor()
	elseif key == "escape" then
		love.event.push("quit")
	elseif key == "f1" then
		self.toggleDebug()
	elseif key == "f2" then -- slowdown options
		local fpstable = {60, 30, 15}
		local tempFPS = 60
		for i = 1, #fpstable do
			if FPS == fpstable[i] then tempFPS = fpstable[(i % #fpstable) + 1] end
		end
		FPS = tempFPS
		print("Tick rate changed to " .. FPS .. " frames per second.")
	elseif key == "f3" then
		InputTable:cycleController()
	elseif key == "f4" then
		-- toggle thru zooms.
		local zoomtable = {1, 1.5, 2}
		local tempZoom = 1
		for i = 1, #zoomtable do
			if self.scaleFactor == zoomtable[i] then tempZoom = zoomtable[(i % #zoomtable) + 1] end
		end
		self.scaleFactor = tempZoom
		self:updateScreenSizePos()	
		print("Game scale factor changed to " .. self.scaleFactor)
	end
	return false
end

function Interface:handleJoystick(joystick, button)

	local input_consumed = false
	
	for _, layer in ipairs(self:getActiveLayersInInputOrder()) do
		if (not input_consumed) then
			input_consumed = layer:handleJoystick(joystick, button)
		end
	end
end


function Interface:updateCameraPosition()
	local p = APC:getPosition()
	for _, layer in ipairs(self:getActiveLayersInDrawOrder()) do
		layer:updateCameraPosition(p)
	end
end

function Interface:getMainLayer()
	return self.layers.main_game
end

function Interface:getCamera()
	return self.layers.main_game.camera
end



Camera = Object:new{viewpoint = {0, 0}}

function Camera:getNewPosition(p)
	return {0, 0}
end

function Camera:updatePosition(p)
	local newPos = self:getNewPosition(p) or {0, 0}
	newPos2 = {round(newPos[1]), round(newPos[2])}
	
	self.viewpoint = newPos2
	return newPos2
end



-- for god's sake, don't change the viewpoint of this at any point.
CameraFixed = Camera:new()

CameraFollowPlayer = Camera:new{
	movements = {},
	constraints = {150, 90},
	viewpointOffset = {__gamesize[1]/2, __gamesize[2]*3/4},
	-- panSplitTable = {0.05, 0.25, 0.4, 0.25, 0.05}
}

function CameraFollowPlayer:getDistPlayerToViewpoint(p)
	return {
		p[1] - (self.viewpoint[1] + self.viewpointOffset[1]), 
		p[2] - (self.viewpoint[2] + self.viewpointOffset[2])
	}
end

function CameraFollowPlayer:getNewPosition(p)
	
	local dP = self:getDistPlayerToViewpoint(p)
	
	local fixedMovement = 2
	local variableMovementPercentage = 0.3
	
	for j = 1, 2 do
		local dPV = dP[j]
		dPV = math.max(math.abs(dPV - (fixedMovement * sgn(dPV))), 0) * sgn(dPV) * variableMovementPercentage
		dP[j] = dPV
	end
	
	local newPosition = {self.viewpoint[1] + dP[1], self.viewpoint[2] + dP[2]}

	return newPosition
end


InterfaceLayer = Object:new{
	canvas = love.graphics.newCanvas(unpack(__gamesize)),
	components = {},
	default_component = love.graphics.newCanvas(unpack(__gamesize)),
	camera = CameraFixed,
	scaleFactor = 2,
	actorScaleFactor = 1,
	viewpoint = {0, 0},
	fx = {},
}

function Interface:initLayer(layerID, ordered_components)
	local setcanvas = function () return love.graphics.newCanvas(unpack(__gamesize))	end
	ordered_components = ordered_components or {}

	canvases = zip(ordered_components, imap(setcanvas, ordered_components))
	
	for k, v in pairs(canvases) do
		print("Canvas", k, v)
	end
	
	new_layer = InterfaceLayer:new{ID = layerID, draworder = ordered_components, components = canvases}
	self.layers[layerID] = new_layer
end

function InterfaceLayer:getOrderedComponents()
	layers = {}
	
	for k, v in ipairs(self.draworder) do
		layers[k] = self.components[v]
	end

	table.insert(layers, self.default_component)
	return layers
end



function InterfaceLayer:getScreenPositionFromGame(x, y, useScaling)
	--INPUT: game x/y

	useScaling = useScaling or false
	return {(x - self.viewpoint[1]) * (useScaling and self.scaleFactor or 1), (y - self.viewpoint[2]) * (useScaling and self.scaleFactor or 1)}
end


function InterfaceLayer:getGamePositionFromScreen(x, y, useScaling)

	useScaling = useScaling or false
	return {(x / (useScaling and self.scaleFactor or 1)) + self.viewpoint[1], (y / (useScaling and self.scaleFactor or 1)) + self.viewpoint[2]}
	
	--INPUT: mouse x/y
end


function InterfaceLayer:updateCameraPosition(player_position)
	local new_position = self.camera:updatePosition(player_position)
	self.viewpoint[1] = math.floor(new_position[1])
	self.viewpoint[2] = math.floor(new_position[2])
end

-- deprecated function
function InterfaceLayer:setCameraPosition(x, y)
	self:centerCameraOnPoint(x, y)
end

function InterfaceLayer:centerCameraOnPoint(x, y)
	-- using floor prevents aliasing
	self.viewpoint[1] = math.floor(x + 0.5 - (__gamesize[1]/2))
	self.viewpoint[2] = math.floor(y + 0.5 - (__gamesize[2]*3/4))
end


function InterfaceLayer:moveCameraPosition(dx, dy)
	dx = dx or 0
	dy = dy or 0
	self.viewpoint[1] = self.viewpoint[1] + dx
	self.viewpoint[2] = self.viewpoint[2] + dy
end

function InterfaceLayer:getRelativePosition(x, y) 
	-- relative to camera. Camera center is 0/0
	x = x or 0
	y = y or 0
	local xx = x - (self.viewpoint[1] + __gameSize[1]/2)
	local yy = y - (self.viewpoint[2] + __gameSize[2]/2)
	
	return {xx, yy}
end

function InterfaceLayer:setShake(s)
	s.frame = 1
	table.insert(self.fx, s)
end

function InterfaceLayer:cycleDraw()
	self:clearCanvasComponents()
	self:drawToCanvas()
	self:refreshCanvas()
	self:drawCanvasToScreen()
end

function InterfaceLayer:clearCanvasComponents()
	local ordered_layers = self:getOrderedComponents()

	for _, component in ipairs(ordered_layers) do
		love.graphics.setColor(1, 1, 1, 1)
		
		love.graphics.setCanvas(component)
		love.graphics.clear()
	end
end

function InterfaceLayer:drawToCanvas()
	-- stub function: code where layer draws to itself
end

function InterfaceLayer:refreshCanvas()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
	
	local ordered_layers = self:getOrderedComponents()

	for _, layer in ipairs(ordered_layers) do
		-- print("fug", _, layer)
		love.graphics.draw(layer, 0, 0, 0, 1, 1)
	end
end

function InterfaceLayer:drawCanvasToScreen()
	love.graphics.setCanvas()
	love.graphics.draw(self.canvas, 0, 0, 0, self.scaleFactor, self.scaleFactor)
end

function Interface:updateFX()
	-- stub
end

function InterfaceLayer:updateFX()
	newEffects = {}
	for k, effect in ipairs(self.fx) do
		effect.frame = effect.frame + 1
		if effect.frame <= effect.duration then
			table.insert(newEffects, effect)		
		end
	end
	self.fx = newEffects
end

-- Deprecated, use setComponent
function InterfaceLayer:setLayer(str)
	self:setComponent(str)
end

function InterfaceLayer:setComponent(component)
	love.graphics.setCanvas(self.components[component] or self.default_component)
end





function InterfaceLayer:getFX()
	return self.fx[1] and -(self.fx[1].func(self.fx[1].frame)) or 0
end




function Interface:getLayer(layerID)
	return self.layers[layerID]
end

function InterfaceLayer:getID()
	return self.ID
end

function Interface:getKeyOfLayer(layerID)
	for k, v in ipairs(self) do
		if v:getID() == layerID then
			return k
		end
	end
	return false
end


function Interface:activateLayer(layerID)
	if not self:getKeyOfLayer(layerID) then
		table.insert(self.activeLayers, self.layers[layerID])
	end
end

function Interface:deactivateLayer(layerID)
	if self:getKeyOfLayer(layerID) then
		key = self:getKeyOfLayer(layerID)
		table.remove(self.activeLayers, key)
	end
end



function InterfaceLayer:handleKeyboard(key, scancode, isrepeat)
	return false
end

function InterfaceLayer:handleJoystick(joystick, button)
	return false
end
