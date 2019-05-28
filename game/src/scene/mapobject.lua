
MapObject = Object:new{
	heavy = true, -- Heavy objects can't be pushed around.
	solid = true,  -- Solid objects can't move through solid objects.
	moving = false, -- Moving objects move around the screen.
	combatant = false, -- Interesting to the damage quadtree due to being harmable, or harmful.
	interactive = false, -- Interesting to the coll quadtree as an active actor that needs to know whether it is touching other objects.
	spritesheet = false,
	position = Vec2:new{0, 0},
	momentum = Vec2:new{0, 0}, 
	speed = 0, 
	sideways_speed_cap = 50,
	rising_speed_cap = 50,
	falling_speed_cap = 50,
	masterbox_coll = {0, 0, 0, 0},
	masterbox_damage = {0, 0, 0, 0}, -- Later, pre-bake master Collbox/Hitbox/Hurtbox as soon as the anim itself is initialized.
	collboxes = {},
	hitboxes = {},
	hurtboxes = {},
	color = {0, 0, 255, 255},
	frame = 1,
	team = 3,
	hitstop = 0 -- in frames
}


Actor = MapObject:new{
	id = false,
	moving = true, 
	heavy = false, 
	color = {255, 0, 0, 255}, 
	gravity = 30, 
	combatant = true, 
	interactive = true, 
	state = State, 
	facing = 1,
	queued_turn = false,
	team = 2,
	hits = {},
	solid = false,
	--floatstop = 0,
	hitstop = 0,
	HP = 100,
	gracejump = 0,
	previous_state = {id = "State", frame = 1},
	chain = {},
	standardOrigin = {97, 217},
	forces = {},
	deltaMovement = {0, 0},
	comboLevel = false,
} 



	
function Actor:updateMasterboxes()
	local cf = self:getFrame()
	local base_mb_coll = self.generateMasterbox(cf.collboxes)
	self.masterbox_coll = self:alignBox(base_mb_coll)
	local base_mb_damage = self.generateMasterbox({self.generateMasterbox(cf.hurtboxes), self.generateMasterbox(cf.hitboxes)})
	self.masterbox_damage = self:alignBox(base_mb_damage)
end

function Actor:onLeavingGround()
	-- snap to x pixels above ground when leaving it (15~20?)
end

function Actor:onHittingGround()
	-- snap to the ground when y pixels above the ground (10?)
end

function Actor:isAerial()
	return self:getFrame().aerial
end

function Actor:isStateAerial()
	return (self.state.animation.default_frame.aerial and true or false)
end

function MapObject:getFrame()
	return AnimFrame:new()
end

function MapObject:getCompositeForceMomentum()
	return {0, 0} -- moving platforms need something else here...
end

function MapObject:getCompositeMovement()
	return {0, 0}
end

function Actor:getCompositeForceMomentum(updateForces)
	local fv = {0, 0}
	local cfv = {0, 0}
	for _, v in pairs(self.forces) do
		if v.active then 
			local cfv = v:update(updateForces)
			fv[1] = fv[1] + cfv[1] * self.facing
			fv[2] = fv[2] + cfv[2]
		end
	end
	return fv
end

function Actor:getCompositeMovement(updateForces)
	if (self.hitstop > 0) then return {0, 0} end
	local fv = self:getCompositeForceMomentum(updateForces)
	local mv = self.state:getMovement(self.frame)
	return {fv[1] + (mv[1] * self.facing), fv[2] + mv[2]}
end


function Actor:getStateFromID(stateID, defaultID)
	assert(self.id, "Error in getStateFromID: Actor ID must be set")
	assert(States[self.id], "Error in getStateFromID: States table doesn't have an entry matching the actor ID")
	defaultID = defaultID or "Stand"
	return (States[self.id][stateID]) or (States[self.id][defaultID])
end

function Actor:changeStateByID(stateID)
	local state = self:getStateFromID(stateID)
	self:changeState(state)
end


function Actor:getConditionCancelState(state, key)
	local val = state.onConditionCancels[key]
	if type(val) == "string" then
		return self:getStateFromID(val)
	elseif val then
		local reTable = {land = "LandRecovery", fall = "Jump", wall = state.id, finish = "Stand"}
		return self:getStateFromID(reTable[key])
	else
		return false
	end
end

function Actor:getFrame()
	return self.state.animation.frames[self.frame]
end

function Actor:getHitEffect(attacker)
	-- combo state: 
		-- 0 or below is minimal
		-- 1, 2, 3 are low
		-- 4, 5, 6 are normal
		-- 7+ are CH		
		
	local attackerFacing = attacker.facing
	local attackerFrame = attacker:getFrame()
	
		
	local cLv = self.comboLevel or 5
	local aLv = attackerFrame.attacklevel or 1
	
	local getComboLevelString = function(i)
		if i < 1 then return "Minimal"
		elseif i < 4 then return "Weak"
		elseif i < 7 then return "Normal"
		else return "Counter"
		end
 	end
	
	-- Override order:
	-- Animation combo level prop > Animation general level prop > Attack levels combo level prop > Attack levels general level prop
	
	local attackerHitEffect = (attackerFrame.hitEffect.byHitType == nil) and AttackEffect:new(attackerFrame.hitEffect) or attackerFrame.hitEffect
	
	local compHitstop = attackerHitEffect.hitstop or AttackLevels[aLv].hitstop
	local compAddedHitstop = attackerHitEffect.addedHitstop or AttackLevels[aLv].byHitType[getComboLevelString(cLv)].addedHitstop
	local compSFX = attackerHitEffect.sfx or AttackLevels[aLv].sfx
	
	
	local baseEffect = Hitstun:new{hitstop = compHitstop, addedHitstop = compAddedHitstop, sfx = compSFX, facing = attackerFacing}
	local hsString = (self:getFrame().aerial and "hsAir" or "hsGround")
	
	local frameBase = attackerHitEffect[hsString]
	local frameScaled = attackerHitEffect.byHitType[getComboLevelString(cLv)][hsString]
	
	
	local levelBase = AttackLevels[aLv][hsString]
	local levelScaled = AttackLevels[aLv].byHitType[getComboLevelString(cLv)][hsString]
	
	local cleanHitEffectParabola = function (hfx)
		if not (hfx[__index]) then
			hfx = Parabola:fromTimeAndHeight(hfx.pTime, hfx.pHeight)
		end
		return hfx
	end
	
	if frameScaled then
		for k, v in pairs(frameScaled) do
			baseEffect[k] = rawget(baseEffect, k) or v
			if k == "parabola" then
				baseEffect[k] = cleanHitEffectParabola(baseEffect[k])
			end
		end
	end
	for k, v in pairs(frameBase) do
		baseEffect[k] = rawget(baseEffect, k) or v
		if k == "parabola" then
			baseEffect[k] = cleanHitEffectParabola(baseEffect[k])
		end
	end
	if levelScaled then
		for k, v in pairs(levelScaled) do
			baseEffect[k] = rawget(baseEffect, k) or v
		end
	end
	for k, v in pairs(levelBase) do
		baseEffect[k] = rawget(baseEffect, k) or v
	end
	
	return baseEffect
	
end

function Actor:evaluateHitAttacker(hitstun)
	self.hitstop = hitstun.hitstop
	
end

function Actor:evaluateHitDefender(hitstun)
	self.hitstop = hitstun.hitstop + hitstun.addedHitstop
	
	self.facing = hitstun.facing * -1
	self.untechable = hitstun.duration
	
	
	self:changeStateByID(hitstun.forceState)
	SFX[hitstun.sfx]:stop()
	SFX[hitstun.sfx]:play()
	ComboCounter = ComboCounter + 1
	self.comboLevel = self.comboLevel - 1
	
	self.forces.impact.power = hitstun.pushback
	self.forces.impact.decay = 0.88
	self.forces.impact:activate()
	
	
	if self:getFrame().aerial then
		self.forces.impact.decay = 0.997
		self.forces.impact.power = self.forces.impact.power * 0.82
		local parab = hitstun.parabola
		self.forces.gravity.parabola = parab
		self.forces.gravity:activate()
		if hitstun.speedY and type(hitstun.speedY) == "number" then
			local _, i = self.forces.gravity.parabola:getNextDelta(hitstun.speedY)
			self.forces.gravity.i = i
		else
			self.forces.gravity.i = 1
		end
	
	end
	
end


function MapObject:getCollboxes()
	return self:alignBoxes(self.collboxes)
end

function Actor:getCollboxes()
	return self:alignBoxes(self:getFrame().collboxes)
end


ComboCounter = 0
	
PlayerCharacter = Actor:new{color = {0, 0, 255, 255}, team = 1, standardOrigin = {104, 200}}

-- nun_sheet = love.graphics.newImage("NunSheet.png")

APC = PlayerCharacter:new{
	id = "Nun",
	spritesheet = {love.graphics.newImage("gfx/NunSpriteSheet1.png"), love.graphics.newImage("gfx/NunSpriteSheet2.png")},
	quad = love.graphics.newQuad(0, 0, 32, 32, 4096, 4096), 
	active_sheet = 1,
	position = {200, 200},
	momentum = {0, 0}, 
	masterbox_coll = {0, 0, 0, 0}, 
	masterbox_damage = {0, 0, 0, 0}, 
	state = false, 
	frame = 1, 
	facing = 1, 
	queued_turn = false, 
	hitstop = 0, 
	--floatstop = 0, 
	previous_state = {id = "NunIdle", frame = 1}, 
	HP = 100,
	chain = {},
	free_actions = {},
	standardOrigin = {97, 217},
	forces = {gravity = ForceGravity:new(), momentum = ForceMomentum:new()},
	untechable = 0
}

function MapObject:getPosition()
	--local so = self.standardOrigin or {0, 0}
	local so = {0, 0}
	return {self.position[1] + so[1], self.position[2] + so[2]}
end

