
MFTable = {}

function MFTable.generic(cm, tm)
	local decel_factor = 1
	local accel_factor = 1
	local gravity = 1
	local gravity_cap = 20
	
	-- If BELOW target momentum:
	-- If ABOVE target momentum:

	return {
		math.min(cm[1] + accel_factor, math.max(tm[1], cm[1] - decel_factor)),
		math.min(cm[2] + gravity, gravity_cap)
		}
end

-- function MFTable.jump(cm, tm)
	-- local gravity = 0.7
	-- return {
		-- cm[1],
		-- math.min(tm[2], cm[2] + gravity)
		-- }
-- end

function MFTable.setBoost(cm, tm)
	return tm
end

function MFTable.maintainBoost(cm, tm)
	return cm
end

function MFTable.ghitstun(cm, tm)
	-- maintain x momentum, more than normal
	local decel_factor = 1.5 -- Dritter Parameter?
	local accel_factor = 1
	local gravity = 1 -- Vierter Parameter?
	local gravity_cap = 12
	
	return {
		math.min(cm[1] + accel_factor, math.max(tm[1], cm[1] - decel_factor)),
		math.min(cm[2] + gravity, gravity_cap)
	}
	
	
end

function MFTable.hitstun(cm, tm)
	-- maintain x momentum, more than normal
	local decel_factor = 0.02 -- Dritter Parameter?
	local accel_factor = 1
	local gravity = 1.6 -- Vierter Parameter?
	local gravity_cap = 20
	
	return {
		math.min(cm[1] + accel_factor, math.max(tm[1], cm[1] * (1 - decel_factor))),
		math.min(cm[2] + gravity, gravity_cap)
	}
	
	
end



Hitstun = Object:new{
	forceState = "",
	duration = 20,
	untechable = 25,
	pushback = false,
	parabola = false
}

AttackEffect = Object:new{
	facing = 1, 
	hsGround = Hitstun:new(), 
	hsAir = Hitstun:new(),
	byHitType = {
		Minimal = {},
		Weak = {},
		Normal = {},
		Counter = {}
	}
}



AttackLevelMapping = {"Minimal", "Weak", "Normal", "Counter"}

AttackLevels = {
	{	-- attack level 1: Weak attacks, no real CH properties
	
		hitstop = 9,
		sfx = "light",
		
		hsGround = Hitstun:new{
			forceState = "HitstunLight",
			duration = 14,
			otgtime = 0,
			pushback = 4,
				-- Pushback uses the parabola height as the current movement.
				-- What the flying fuck does that imply for total pushback distance?
				-- How do I generate a parabola from pushback dist and total time?
				-- Is this always the best idea? What for big air blowback shit?
			parabola = Parabola:fromTimeAndHeight(12, 35)
		},
		hsAir = Hitstun:new{
			forceState = "JuggleFloat",
			duration = 10,
			otgtime = 0,
			pushback = 5,
			parabola = Parabola:fromTimeAndHeight(12, 35)
		},
		byHitType = {
			Minimal = {
				hsGround = {duration = 10},
				hsAir = {duration = 10},
				addedHitstop = 0
			},
			Weak = {
				hsGround = {duration = 12},
				hsAir = {duration = 13},
				addedHitstop = 0
			},
			Normal = {
				hsGround = {duration = 14, otgtime = 15},
				hsAir = {duration = 16, otgtime = 15},
				addedHitstop = 0
			},
			Counter = {
				hsGround = {duration = 16, otgtime = 30},
				hsAir = {duration = 25, otgtime = 30},
				addedHitstop = 9,
			}
		
		}
	},
	{	-- attack level 2: stuff with decent counter hits 
	
		hitstop = 11,
		sfx = "medium",
	
		hsGround = Hitstun:new{
			forceState = "HitstunHigh",
			duration = 16,
			otgtime = 0,
			pushback = 5,
			parabola = Parabola:fromTimeAndHeight(13, 45)
		},
		hsAir = Hitstun:new{
			forceState = "JuggleFloat",
			duration = 12,
			otgtime = 0,
			pushback = 6,
			parabola = Parabola:fromTimeAndHeight(13, 45)
		},
		byHitType = {
			Minimal = {
				hsGround = false,
				hsAir = false,
				addedHitstop = 0
			},
			Weak = {
				hsGround = false,
				hsAir = false,
				addedHitstop = 0
			},
			Normal = {
				hsGround = {otgtime = 15},
				hsAir = {otgtime = 15},
				addedHitstop = 0
			},
			Counter = {
				hsGround = {duration = 14, otgtime = 30},
				hsAir = {duration = 25, otgtime = 30},
				addedHitstop = 11,
			}
		
		}
	
	
	
	},
	{	-- attack level 3: powerful punches and shit
	
		hitstop = 12,
		sfx = "medium",
	
		hsGround = Hitstun:new{
			forceState = "HitstunHigh",
			duration = 19,
			otgtime = 0,
			pushback = 6,
				-- Pushback uses the parabola height as the current movement.
				-- What the flying fuck does that imply for total pushback distance?
				-- How do I generate a parabola from pushback dist and total time?
				-- Is this always the best idea? What for big air blowback shit?
			parabola = Parabola:fromTimeAndHeight(15, 50)
		},
		hsAir = Hitstun:new{
			forceState = "JuggleFloat",
			duration = 15,
			otgtime = 0,
			pushback = 7,
				-- Pushback uses the parabola height as the current movement.
				-- What the flying fuck does that imply for total pushback distance?
				-- How do I generate a parabola from pushback dist and total time?
				-- Is this always the best idea? What for big air blowback shit?
			parabola = Parabola:fromTimeAndHeight(15, 50)
		},
		byHitType = {
			Minimal = {
				hsGround = false,
				hsAir = false,
				addedHitstop = 0
			},
			Weak = {
				hsGround = {otgtime = 15},
				hsAir = {otgtime = 15},
				addedHitstop = 0
			},
			Normal = {
				hsGround = {otgtime = 30},
				hsAir = {otgtime = 30},
				addedHitstop = 0
			},
			Counter = {
				hsGround = {duration = 14, otgtime = 30},
				hsAir = {duration = 25, otgtime = 30},
				addedHitstop = 15,
			}
		
		}
	
	
	},
	{	-- really clean hits. Significant hitstun and hitstop here.
	
		hitstop = 14,
		sfx = "fierce",
	
		hsGround = Hitstun:new{
			forceState = "HitstunHigh",
			duration = 22,
			otgtime = 0,
			pushback = 7, 
			parabola = Parabola:fromTimeAndHeight(16, 55)
		},
		hsAir = Hitstun:new{
			forceState = "JuggleFloat",
			duration = 14,
			otgtime = 0,
			pushback = 8, 
			parabola = Parabola:fromTimeAndHeight(16, 55)
		},
		byHitType = {
			Minimal = {
				hsGround = false,
				hsAir = false,
				addedHitstop = 0
			},
			Weak = {
				hsGround = {otgtime = 15},
				hsAir = {otgtime = 15},
				addedHitstop = 0
			},
			Normal = {
				hsGround = {otgtime = 30},
				hsAir = {otgtime = 30},
				addedHitstop = 0
			},
			Counter = {
				hsGround = {duration = 14, otgtime = 30},
				hsAir = {duration = 25, otgtime = 30},
				addedHitstop = 14,
			}
		
		}
	
	},
	{	-- the absolute haymakers, like Deathfist etc.
	
		hitstop = 16,
		sfx = "heavy",
	
		hsGround = Hitstun:new{
			forceState = "HitstunHigh",
			duration = 25,
			otgtime = 0,
			pushback = 8, 
			parabola = Parabola:fromTimeAndHeight(18, 65)
		},
		hsAir = Hitstun:new{
			forceState = "JuggleFloat",
			duration = 20,
			otgTime = 0,
			pushback = 9,
			parabola = Parabola:fromTimeAndHeight(18, 65)
		},
		byHitType = {
			Minimal = {
				hsGround = false,
				hsAir = false,
				addedHitstop = 0
			},
			Weak = {
				hsGround = {otgtime = 15},
				hsAir = {otgtime = 15},
				addedHitstop = 0
			},
			Normal = {
				hsGround = {otgtime = 30},
				hsAir = {otgtime = 30},
				addedHitstop = 0
			},
			Counter = {
				hsGround = {duration = 14, otgtime = 30},
				hsAir = {duration = 25, otgtime = 30},
				addedHitstop = 16
			}
		
		}
	
	}

}

local screenshake = {
	light = {duration = 7, func = function(i) local a = {-9, 9, -6, -4, -3, -2} return a[i] end},
	medium = {duration = 7, func = function(i) local a = {-16, 16, -12, -9, -7, -4} return a[i] end},
	heavy = {duration = 7, func = function(i) local a = {-30, 30, -23, -18, -13, -7} return a[i] end},
	fierce = {duration = 9, func = function(i) local a = {-30, 30, -25, 4, -8, -11, 8, -5} return a[i] end},
}

function genericHitFunction(attackEffect, actor, target)

	if not actor:hasAlreadyHit(target, actor:getFrame().hit) then
		Interface:setShake(screenshake[attackEffect.sfx])
		actor:recordHit(target)
		actor:evaluateHitAttacker(attackEffect)
		target:evaluateHitDefender(attackEffect) 	
	end
end


-- Vector2 math end






-- Hitstun = Object:new{
	-- state = "None",
	-- length = 100,
	-- float_length = 0,
	-- velocity = {0, 0},
	-- damage = 0, 
	-- hitstop = 0,
	-- screenshake = {duration = 0, func = function(i) return 0 end},
	-- sfx = "medium"
-- }


AnimSprite = Object:new{gfx = "", ox = 0, oy = 0}

AnimFrame = Object:new{
	sx = 0,
	sy = 0,
	sw = 0,
	sh = 0,
	ox = 0,
	oy = 0,
	actor_collision = true,
	sprite = AnimSprite:new(), 
	collboxes = {{0, 0, 0, 0}}, 
	hitboxes = {{0, 0, 0, 0}}, 
	hurtboxes = {{0, 0, 0, 0}}, 
	hitEffect = AttackEffect:new(),
	-- hiteffect = AttackEffect:new(), 
	on_whiff = {}, 
	on_hit = {},
	hit = false,
	attacklevel = false,
	rapidfire = false,
	flags = {movement = false, stance = false, normal = false, special = false, cmdnormal = false}
}

-- function AnimFrame.hitEffect(actor, target)
	-- Here's how a generic hit effect works.
	-- The effect itself tells the target how it gets hit, IE standing hitstun 24 frames or launch with velocity x|y until it hits the ground.
	-- The target takes its evaluateHit function and consults how it reacts to such a hit, then reacts as necessary.
	-- Evaluator step is needed because player & enemy react fairly differently to things. The player's not supposed to be interrupted by most attacks, as an example, and air/ground have different hitstun necessities.
	-- This will be fiddly labor, but oh well.
-- end


-- the default frame is set as the parent object of any frames in the anim. In simple terms, any properties not provided by the specific frame are provided by the default.
Animation = Object:new{frames = {}, default_frame = AnimFrame:new()}


State = Object:new{
	--frame = 1,
	onConditionCancels = {land = true, fall = true, wall = true, finish = true},
	animation = {}, -- frames
	default_frame = AnimFrame:new(),
	movement = {}
}


States = {}



function State:setAnim(presets)
	local df = AnimFrame:init(presets)
	self.animation = Animation:new{frames = {}, default_frame = df}
end

function State:setFrames(params)
	for i = 1, #params do
		self:setFrame(unpack(params[i]))
	end
end

function State:setFrame(presets, duration, start) -- params is a table of tables.
	presets = presets or {}
	duration = duration or 1
	start = start or #self.animation.frames + 1
	for i = start, (start + duration - 1) do
		self.animation.frames[i] = (self.animation.frames[i] or self.animation.default_frame):init(presets)
	end	
end

function State:setMovement(movement, duration, start)
	if type(movement) ~= "table" then movement = {0, 0} end
	
	duration = duration or 1
	start = start or 1
	
	--print(self.id, movement, duration, start)
	for i = start, duration + start - 1 do 
		self.movement[i] = movement
	end
end

function State:setMovements(moveTable)
	for i = 1, #moveTable do
		self:setMovement(moveTable[i][1], moveTable[i][2], moveTable[i][3])
	end
end

function State:getMovement(i)
	local ret = (self.movement[i] or {0, 0})
	ret = (self.movement[i] and (#self.movement > 0 and self.movement[i] or {0, 0}) or {0, 0})
	return ret
end

function State:initTemplate(i, t)
	local s = self:new(self.init{id = i})
	s:setAnim{t}
	return s
end



function AnimFrame:init(presets)
	presets = presets or {}
	local template = Set.copy(self)
	for k2, v2 in ipairs(presets) do -- numerical table indices are always tables
		for k, v in pairs(v2) do
			template[k] = v
		end
	end
	for k, v in pairs(presets) do
		if type(k) == "string" then -- syntactic sugar for if you have only one table
			template[k] = v
		end
	end
	return self:new(template)
end

function State:getDeltaMomentum(momentum)
	dm = self.momentum_function(momentum, self.target_momentum)
	dm[1] = dm[1] - momentum[1]
	dm[2] = dm[2] - momentum[2]
	return dm
end


function State.init(t)
	t.animation = {}
	t.movement = {}
	t.stepEvents = {}
	t.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
	--t.next_state = false
	return t
end

-- dummy functions. 

function State.onStateStart(actor)
end

function State.onStateEnd(actor)
end

function State.onStepStart(actor)
end

function State.onStepEnd(actor)
end



function AttackEffect:fromHitstuns(ground, air)
	-- Ground and Air are assumed to be a table of hitstuns. 
	
	local g1 = Hitstun:new(ground)
	local a1 = g1:new(air)

	local ae = self:new{hitstun_ground = g1, hitstun_air = a1}
	return ae
end

function initializeStates()
	initializeNunStates()
	initializeNunStatesCustom()
	initializeDemonbredStatesCustom()
end

