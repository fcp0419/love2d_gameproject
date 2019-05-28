GameStateManager = {
	activeStage = false,
	activePC = false,
}

function GameStateManager:getActiveStage()
	local activeStage = self.activeStage
	assert(activeStage, "The active stage must exist!")
	return activeStage	
end

function GameStateManager:getActivePlayer()
	local activePC = self.activePC
	assert(activeStage, "The active player must exist!")
	return activePC
end

function GameStateManager:setActiveStage(stage)
	self.activeStage = stage or false
end

function GameStateManager:setActivePlayer(player)
	self.activePlayer = player or false
end


Stage = Object:new{  -- A stage is defined as a collection of map objects.
	bg_color = Colors.black,
	size = {0, 0, 1280, 720},
	all_objects = {},
	moving_objects = {},
	colltree = CollisionTree:new{size = size}, 
	damagetree = DamageTree:new{size = size}
}

ActiveStage = Stage:new()

function Stage.stepMovementCancels(mobjs)
	for i = 1, #mobjs do
		if mobjs[i].hitstop < 1 then
			mobjs[i]:stepFLWCancels()
		end
	end
end

function Stage.stepHitstops(mobjs)
	for i = 1, #mobjs do
		if mobjs[i].hitstop == 0 then
			mobjs[i].untechable = mobjs[i].untechable or 0
			mobjs[i].untechable = math.max(mobjs[i].untechable - 1, 0)
		end
		mobjs[i].hitstop = math.max(mobjs[i].hitstop - 1, 0)
	end
end

function Stage.stepAnimations(mobjs)
	for i = 1, #mobjs do
		if mobjs[i].hitstop and (mobjs[i].hitstop == 0) then
			mobjs[i]:stepAnimation()
		end
	end
end




function Stage:add(o)
	self.all_objects[#self.all_objects + 1] = o
	o:updateMasterboxes()
	if o.moving then
		self.moving_objects[#self.moving_objects + 1] = o
	end
	if o.solid then
		self.colltree:insertObject(o)
	end
	if o.combatant then
		self.damagetree:insertObject(o)
	end
end

function Stage:step(dt)

	-- First step: Update all framestates/animations
	self.stepAnimations(self.moving_objects) -- goes first to minimize input delay.
	self.colltree:step(self.moving_objects, dt)
	
	self.stepMovementCancels(self.moving_objects) -- land/fall/wall cancels. Any cancel here is instantly executed after the fact.
	self.colltree:fixCollisions(self.moving_objects, dt)
	
	self.stepHitstops(self.moving_objects) -- decrement hitstop values of everything by 1.
	
	self.damagetree:step(self.moving_objects, dt)
	self.colltree:fixCollisions(self.moving_objects, dt)
	
end




-- function love.joy

Movelist = {
	{"This is a placeholder", "Please wait warmly"}
}


FPS = 60

test_music = love.audio.newSource("sound/04sisca.mp3", "stream")

SFX = {
	light = love.audio.newSource("sound/001_hit_p04.wav", "static"),
	medium = love.audio.newSource("sound/002_hit_s11_c.wav", "static"),
	fierce = love.audio.newSource("sound/017_hit_p03_c.wav", "static"),
	-- fierce = love.audio.newSource("sound/003_hit_s13.wav"),
	heavy = love.audio.newSource("sound/030_bom28_b.wav", "static"),
	impact = love.audio.newSource("sound/015_bosu15.wav", "static"),
	step = love.audio.newSource("sound/005_step07.wav", "static"),
	chain_end = love.audio.newSource("sound/049_chari04.wav", "static")
}

SFX.chain_end:setVolume(0.4)


function initTestStage()
	TestStage = Stage:new()
	
	APC.state = States.Nun.Stand
	TestStage:add(APC)
	
	--Sack.state = State_SackIdle
	
	--TestStage:add(Sack)
	
	
	
	Demonbred_Spear.state = States.Demonbred.JuggleFloat
	TestStage:add(Demonbred_Spear)
	
	Demonbred_Spear.frame = 1
	Demonbred_Spear.forces.gravity:activate()
	
	TestStage:add(MapObject:new{position = {0, 0}, collboxes = {{0, 0, 2000, 40}}})
	TestStage:add(MapObject:new{position = {0, 0}, collboxes = {{0, 0, 40, 460}}})
	TestStage:add(MapObject:new{position = {0, 490}, collboxes = {{0, 0, 5000, 40}}})
	TestStage:add(MapObject:new{position = {620, 500}, collboxes = {{0, 0, 40, 200}}}) -- walls
	
	TestStage:add(MapObject:new{position = {620, 0}, collboxes = {{0, 0, 1000, 40}}})
	TestStage:add(MapObject:new{position = {620, 560}, collboxes = {{0, 0, 1000, 40}}}) -- walls
	TestStage:add(MapObject:new{position = {1620, 0}, collboxes = {{0, 0, 40, 600}}}) -- walls
	
	-- TestStage:add(MapObject:new{position = {250, 270}, collboxes = {{-50, -50, 20, 140}}})
	-- TestStage:add(MapObject:new{position = {250, 230}, collboxes = {{50, 50, 100, 20}}}) -- test obstacles
end
