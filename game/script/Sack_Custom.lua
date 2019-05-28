-- Hitstuns


-- Weak grounded hitstun: Character Loses their balance slightly
-- High grounded hitstun: Head reels back
-- Low grounded hitstun: Abdomen reels back, character almost falls over
	
-- Trip: Character is swept off their legs, flying a short distance before landing on the ground on their stomach.


-- Float: Character is sent flying into the air in a small arc, landing on their back. They will usually be able to recover relatively fast.
-- Screw Float: Character is floated in the air in a long arc. Momentum remains constant during the screw part, then functions normally after. 
-- Launch: Character is sent flying into the air in an high arc, and lands on the ground on their head. They might lie down for further OTG or get up faster.
-- Tumble: Character is blown back a short distance, landing on their ass. After some time they stand up and recover. Considered airborne? Grounded?
-- Blowback: Character is blown back some distance, landing on their back. Optionally wallbounces or wallsticks.

-- Wallbounce: Property of blowback anims. When hitting a wall, hit the back with it, then bounce off it in the trip animation.
-- Wallstick: Same as wallbounce, but sticks to the wall, slides down and transitions to tumble animation. 
-- Groundbounce: Uses launch anim until ground impact, then bounces back up in a float anim. Speed up depends on speed 

-- Face-Up OTG: Also known as on-back OTG. Head's last, behind the body.
-- Face-Down OTG: Also known as on-stomach OTG. Head's first, in front of the body.

-- Getups from face-down and face-up OTG



-- Other universal animations


-- Idle
-- Walk/Movement
-- Death?



-- Basic Enemies 
-- Note that each of these guys has their own idle too, its just hitstuns that are copied over.

-- Spear Demonbred: Defensive, footsies-based enemy.
	-- Identified by a large-ass spear. Cautious, leaned-back stance.

-- Movement options: Forward & backward walk.
-- Attacks
	-- Fast, straight spear thrust. He uses this as his primary spacing tool to keep you out. Does not have a lot of recovery. Crouchable, but only at the tip. Inflicts normal hitstun only, maybe CH properties?
	-- Retreating slash. Very fast and used as sort of a panic move. Recovery is punishable if you're looking out for it. Also a combo ender.
	-- Spear upward swing. Relatively fast. Two hits, the first can scoop up anything on the ground and the second hits as a great anti-air. Lots of recovery. Launches.
	-- Forward slide kick. Somewhat low to the ground, kills cheeky lowprofiles and has somewhat more range than the fast thrust. Easy to go over, rear hurtbox is not low. Sorta slow?
	-- Far thrust. Spins the spear overhead before attacking. Completely reactable, and can always be ducked. 

	
-- Caster Demonbred: Zoner/support enemy.
	-- Identified by his pair of large horns, possibly also robes of some sort. Straight, confident stance.

-- Movement options: Teleport only (also his tech)

-- Attacks
	-- High fireball, hard to jump over but can be easily ducked.
	-- Low fireball, easy to jump or hop over but hits ducking.
	-- Lightning Call, strikes a specific area after a delay. Two versions: One tracks but is slower, one hits right in front of the caster and is faster.
	-- Teleport, goes a set distance. Two versions: One has short vulnerable startup and leaves behind a magic seal that detonates. The other is faster, possibly more invulnerable and only teleports, it also chains into the seal teleport.
	
	
-- Hatchet Demonbred: Rushdown enemy.
	-- Identified by his hatchet. Low, restless stance.
	
-- Movement options: Forward dash, backward walk, jump.

-- Attacks
	-- Jump-in hatchet. Becomes active only when it hits the ground, so it's antiairable by anything despite being rather fast.
	-- Delayed jump-in hatchet. Pauses in mid air then comes crashing down.
	-- Running axe. A wild spinning swing that hits both sides. High recovery, but hard to make it whiff, need to interrupt it.
	-- The same swing, but while standing in place.
	
	
-- The properties of a hitstun:
	-- onWallImpact: Can be false. If nonfalse, will transition to this state upon hitting a wall
	-- onGroundImpact: Can be false (but will default to OTG). If nonfalse, will transition to this state upon hitting the ground.
	
	-- Untechable Time: If the character can tech out of that specific hitstun, allows teching if untechable time has passed
	

function initializeDemonbredStatesCustom()


	Demonbred_Spear = Actor:new{
		id = "Demonbred",
		spritesheet = {love.graphics.newImage("gfx/DemonbredSpriteSheet1.png")}, 
		quad = love.graphics.newQuad(0, 0, 32, 32, 4096, 4096), 
		active_sheet = 1,
		position = {500, 250}, 
		momentum = {0, 0}, 
		masterbox_coll = {0, 0, 0, 0}, 
		masterbox_damage = {0, 0, 0, 0}, 
		state = State:new(), 
		frame = 1, 
		facing = -1, 
		queued_turn = false, 
		hitstop = 0, 
		HP = 100,
		chain = {},
		free_actions = {},
		standardOrigin = {97, 217},
		comboLevel = 5,
		untechable = 0,
		gracejump = 0,
		forces = {gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(40, 100)}, impact = ForceImpact:new{decay = 0.85}}
	}	


	-- State sequence plotting
	
	-- Hitstuns: 
		-- Light/High/Low -> Stand
	-- Juggles:
		-- Tumble (-> Sit) -> Stand. Sit state counts as OTG?
		-- Trip -> Face-Down OTG
		-- Float -> Face-Up Impact 
		-- Launch -> Face-Down Impact  
		-- Blowback -> Face-Up Impact
		-- Knockdown -> Face-Up OTG
		
		-- Face-Up Impact -> Face-Up OTG -> Face-Up Getup
		-- Face-Down Impact -> Face-Down OTG -> Face-Down Getup
		-- Wallbounce -> Trip
		-- Groundbounce -> Float
		-- Sliding Impact? FD-Impact with extra momentum
		
		-- Screw Float -> Launch (from peak) -> Face-Up Impact
		
	-- Notes
		-- First frame of trip is only used for trip, wallbounce has its own shit
		-- Blowback anim also starts off first frame of Float
		-- OTG includes the frame before it.
		-- Fast knockdown-causing moves should start right at the end of float and not use bounces. Use a sep. state, I guess.
	
	local demonbredTemplate = {sx = 0, sy = 0, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hitboxes = {}, hurtboxes = {{-30, -120, 60, 120}}, collboxes = {{-20, -100, 40, 100}}, on_whiff = {_flags = {}}, on_hit = {_flags = {}}, actor_collision = true, flags = {}}
	local demonbredTemplateAir = {sx = 0, sy = 0, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, aerial = true, hitboxes = {}, hurtboxes = {{-50, -130, 100, 130}}, collboxes = {{-20, -100, 40, 85}}, on_whiff = {_flags = {}}, on_hit = {_flags = {}}, actor_collision = true, flags = {}}
	
	
	States.Demonbred = {}
	
	
	States.Demonbred.Stand = State:initTemplate("Stand", demonbredTemplate)
	
	
	
	
	States.Demonbred.HitstunLight = State:initTemplate("HitstunLight", demonbredTemplate)
	States.Demonbred.HitstunHigh = State:initTemplate("HitstunHigh", demonbredTemplate)
	States.Demonbred.HitstunLow = State:initTemplate("HitstunLow", demonbredTemplate)
	
	States.Demonbred.JuggleTrip = State:initTemplate("JuggleTrip", demonbredTemplateAir)
	States.Demonbred.JuggleFloat = State:initTemplate("JuggleFloat", demonbredTemplateAir)
	States.Demonbred.JuggleLaunch = State:initTemplate("JuggleLaunch", demonbredTemplateAir)
	States.Demonbred.JuggleTumble = State:initTemplate("JuggleTumble", demonbredTemplateAir)
	States.Demonbred.JuggleBlowback = State:initTemplate("JuggleBlowback", demonbredTemplateAir)
	States.Demonbred.JuggleKnockdown = State:initTemplate("JuggleKnockdown", demonbredTemplateAir)

	States.Demonbred.ImpactWallBounce = State:initTemplate("ImpactWallBounce", demonbredTemplateAir)
	--States.Demonbred.ImpactWallStick = {}
	States.Demonbred.ImpactTumble = State:initTemplate("ImpactTumble", demonbredTemplate)
	States.Demonbred.ImpactGroundBounce = State:initTemplate("ImpactGroundBounce", demonbredTemplateAir)
	States.Demonbred.ImpactGroundFaceDown = State:initTemplate("ImpactGroundFaceDown", demonbredTemplateAir)
	States.Demonbred.ImpactGroundFaceUp = State:initTemplate("ImpactGroundFaceUp", demonbredTemplateAir)
	
	
	States.Demonbred.OTGFaceDown = State:initTemplate("OTGFaceDown", demonbredTemplateAir)
	States.Demonbred.OTGFaceUp = State:initTemplate("OTGFaceUp", demonbredTemplateAir)
	
	States.Demonbred.RiseFaceDown = State:initTemplate("RiseFaceDown", demonbredTemplate)
	States.Demonbred.RiseFaceUp = State:initTemplate("RiseFaceUp", demonbredTemplate)
	
	States.Demonbred.DummyFall = State:initTemplate("DummyFall", demonbredTemplate)
	
	States.Demonbred.Stand:setFrames{
		{{sx = 0, sy = 0}, 10},
	}
	
	States.Demonbred.DummyFall:setFrames{
		{{sx = 0, sy = 0}, 10},
	}
	
	
	States.Demonbred.HitstunLight:setFrames{	
		{{sx = 1, sy = 0}, 6},
		{{sx = 2, sy = 0}, 6}, -- Duration of this frame depends on total hitstun length.
	}

	States.Demonbred.HitstunHigh:setFrames{	
		{{sx = 3, sy = 0}, 2},
		{{sx = 4, sy = 0}, 6}, -- Duration of this frame depends on total hitstun length.
		{{sx = 5, sy = 0}, 4},
		{{sx = 2, sy = 0}, 3},
	}
	
	States.Demonbred.HitstunLow:setFrames{		
		{{sx = 6, sy = 0}, 2},
		{{sx = 7, sy = 0}, 6}, -- Duration of this frame depends on total hitstun length.
		{{sx = 0, sy = 1}, 4},
		{{sx = 2, sy = 0}, 3},
	}
	
	States.Demonbred.JuggleTrip:setFrames{ 	
		{{sx = 0, sy = 3, oy = 15}, 4},
		{{sx = 1, sy = 3, oy = 13}, 4},
		{{sx = 2, sy = 3, oy = 10}, 20}, -- Loops infinitely until reaching ground.
	}
	
	States.Demonbred.JuggleFloat:setFrames{ 	-- frames advance depending on vertical velocity.
		{{sx = 1, sy = 4}, 6}, -- -2 or less
		{{sx = 2, sy = 4}, 6}, -- around 0
		{{sx = 3, sy = 4}, 8}, -- +2 or more
	}
	
	States.Demonbred.JuggleLaunch:setFrames{ 	-- frames advance depending on vertical velocity.
		{{sx = 3, sy = 3}, 2}, -- initial frames
		{{sx = 4, sy = 3}, 10}, -- -3 or below
		{{sx = 5, sy = 3}, 10}, -- -3 to -1
		{{sx = 6, sy = 3}, 10}, -- -1 to +1
		{{sx = 7, sy = 3}, 10}, -- +1 to +3
		{{sx = 0, sy = 4}, 10}, -- +3 or above
	}
	
	States.Demonbred.JuggleTumble:setFrames{ 	-- first frame is held until ground is hit.
		{{sx = 6, sy = 0}, 2},
		{{sx = 7, sy = 0}, 4},
		{{sx = 1, sy = 4}, 10}, -- Held until reaching ground
	}
	
	States.Demonbred.JuggleBlowback:setFrames{ -- second frame is held until hitting something.
		{{sx = 1, sy = 4, ox = 10}, 3},
		{{sx = 6, sy = 2}, 10},
	}
	
	States.Demonbred.JuggleKnockdown:setFrames{ -- frame is held until hitting ground.
		{{sx = 3, sy = 4}, 10},
	}
	
	States.Demonbred.ImpactWallBounce:setFrames{
		{{sx = 7, sy = 2}, 8},
	}
	
	States.Demonbred.ImpactTumble:setFrames{
		{{sx = 4, sy = 4}, 3},
		{{sx = 5, sy = 4}, 12},
	}
	
	States.Demonbred.ImpactGroundBounce:setFrames{
		{{sx = 1, sy = 1}, 3},
		{{sx = 2, sy = 1}, 1},
		{{sx = 3, sy = 1}, 1},
	}
	
	States.Demonbred.ImpactGroundFaceDown:setFrames{
		{{sx = 1, sy = 1}, 3},
		{{sx = 2, sy = 1}, 3},
		{{sx = 3, sy = 1}, 3},
	}
	
	States.Demonbred.ImpactGroundFaceUp:setFrames{
		{{sx = 0, sy = 2}, 3},
		{{sx = 1, sy = 2}, 3},
		{{sx = 2, sy = 2}, 3},
	}
	
	--  {{-55, -30, 110, 30}}
	
	States.Demonbred.OTGFaceDown:setFrames{
		{{sx = 4, sy = 1, hurtboxes = {}, collboxes = {{-13, -65, 26, 65}}}, 3},
		{{sx = 5, sy = 1, hurtboxes = {}, collboxes = {{-13, -65, 26, 65}}}, 17}, -- possibly holdable depending on untechable time.
	}
	
	States.Demonbred.OTGFaceUp:setFrames{
		{{sx = 3, sy = 2, hurtboxes = {}, collboxes = {{-13, -65, 26, 65}}}, 3},
		{{sx = 4, sy = 2, hurtboxes = {}, collboxes = {{-13, -65, 26, 65}}}, 13}, -- possibly holdable depending on untechable time.
	}
	
	States.Demonbred.RiseFaceDown:setFrames{
		{{sx = 6, sy = 1, hurtboxes = {}, collboxes = {{-13, -65, 26, 65}}}, 9},
		{{sx = 7, sy = 1, hurtboxes = {}, collboxes = {{-13, -65, 26, 65}}}, 5},
	}
	
	States.Demonbred.RiseFaceUp:setFrames{
		{{sx = 4, sy = 2, hurtboxes = {}, collboxes = {{-13, -65, 26, 65}}}, 7},
		{{sx = 5, sy = 2, hurtboxes = {}, collboxes = {{-13, -65, 26, 65}}}, 4},
	}
	
	--States.Demonbred.JuggleScrewFloat = {}
	
	-- States.Demonbred.GroundRecoveryForward = {}
	-- States.Demonbred.GroundRecoveryBackward = {}
	
	-- States.Demonbred.WalkForward = {}
	-- States.Demonbred.WalkBack = {}

	-- States.Demonbred.QuickThrust = {}
	-- States.Demonbred.RetreatSwing = {}
	-- States.Demonbred.UpwardSwing = {}
	-- States.Demonbred.SlideKick = {}
	-- States.Demonbred.LongThrust = {}
	
	States.Demonbred.Stand.onConditionCancels	= {land = true, fall = true, wall = true, finish = true}
	
	States.Demonbred.HitstunLight.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
	States.Demonbred.HitstunHigh.onConditionCancels	= {land = true, fall = true, wall = true, finish = true}
	States.Demonbred.HitstunLow.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
	
	States.Demonbred.JuggleTrip.onConditionCancels = {land = "OTGFaceDown", fall = true, wall = true, finish = "OTGFaceDown"}
	States.Demonbred.JuggleFloat.onConditionCancels = {land = "ImpactGroundFaceUp", fall = true, wall = true, finish = "ImpactGroundFaceUp"}
	States.Demonbred.JuggleLaunch.onConditionCancels = {land = "ImpactGroundFaceDown", fall = true, wall = true, finish = "ImpactGroundFaceDown"}
	States.Demonbred.JuggleTumble.onConditionCancels = {land = "ImpactTumble", fall = false, wall = true, finish = "ImpactTumble"}
	States.Demonbred.JuggleBlowback.onConditionCancels = {land = "ImpactGroundFaceUp", fall = true, wall = "ImpactWallBounce", finish = "ImpactGroundFaceUp"}
	States.Demonbred.JuggleKnockdown.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
	
	States.Demonbred.ImpactTumble.onConditionCancels = {land = false, fall = false, wall = true, finish = "RiseFaceUp"}
	States.Demonbred.ImpactWallBounce.onConditionCancels = {land = false, fall = false, wall = true, finish = "JuggleTrip"}
	States.Demonbred.ImpactGroundBounce.onConditionCancels = {land = true, fall = true, wall = true, finish = "JuggleFloat"}
	States.Demonbred.ImpactGroundFaceUp.onConditionCancels = {land = false, fall = true, wall = true, finish = "OTGFaceUp"}
	States.Demonbred.ImpactGroundFaceDown.onConditionCancels = {land = false, fall = true, wall = true, finish = "OTGFaceDown"}
	
	States.Demonbred.OTGFaceUp.onConditionCancels = {land = false, fall = true, wall = true, finish = "RiseFaceUp"}
	States.Demonbred.OTGFaceDown.onConditionCancels = {land = false, fall = true, wall = true, finish = "RiseFaceDown"}
	
	States.Demonbred.RiseFaceUp.onConditionCancels = {land = false, fall = true, wall = true, finish = true}
	States.Demonbred.RiseFaceDown.onConditionCancels = {land = false, fall = true, wall = true, finish = true}

	States.Demonbred.DummyFall.onConditionCancels = {land = true, fall = "Jump", wall = true, finish = "Jump"}
	
	
	States.Demonbred.Stand.onStateStart = function(actor)
		actor.forces.impact:deactivate()
		actor.forces.gravity:deactivate()
		actor.comboLevel = 5
		ComboCounter = 0
	end
	
	States.Demonbred.OTGFaceUp.onStateStart = function(actor)
		actor.forces.impact.decay = 0.5
		SFX.impact:stop()
		SFX.impact:play()
	end
	
	States.Demonbred.OTGFaceDown.onStateStart = function(actor)
		actor.forces.impact.decay = 0.5
		SFX.impact:stop()
		SFX.impact:play()
	end
	
	States.Demonbred.ImpactGroundFaceDown.onStateStart = function(actor)
		actor.forces.impact.decay = 0.7
		
	end
	
	States.Demonbred.ImpactGroundFaceUp.onStateStart = function(actor)
		actor.forces.impact.decay = 0.7
	end
	
	
	States.Demonbred.HitstunLight.onStepEnd = function(actor) 
		if actor.frame == 12 then
			if actor.untechable > 0 then
				return actor.frame
			else
				return false
			end
		end
	end
	
	
	States.Demonbred.HitstunHigh.onStepEnd = function(actor) 
		if actor.frame > 2 and actor.frame < 9 then
			if actor.untechable > 7 then
				return actor.frame
			else
				return 18 - actor.untechable
			end
		end
	end
	
	States.Demonbred.HitstunLow.onStepEnd = function(actor) 
		if actor.frame > 2 and actor.frame < 9 then
			if actor.untechable > 7 then
				return actor.frame
			else
				return 18 - actor.untechable
			end
		end
	end
	
	States.Demonbred.JuggleTrip.onStateStart = function(actor)
		-- actor.position[2] = actor.position[2] - 20
	end
	
	States.Demonbred.JuggleTrip.onStepEnd = function(actor)
		if actor.frame == 10 then
			return actor.frame
		end
	end
	
	States.Demonbred.JuggleTumble.onStepEnd = function(actor) 
		if actor.frame == 8 then
			return actor.frame
		end
	end
	
	States.Demonbred.ImpactTumble.onStateStart = function(actor) 
		actor.forces.impact.decay = 0.6
		SFX.impact:stop()
		SFX.impact:play()
	end
	
	States.Demonbred.JuggleBlowback.onStepEnd = function(actor) 
		if actor.frame == 8 then
			return actor.frame
		end
	end
	
	
	States.Demonbred.JuggleFloat.onStepEnd = function(actor)
		local cGravity = actor.forces.gravity:getCurrent()[2]
		if cGravity < -2 then return 1 
		elseif cGravity > 2 then return 13
		else return 7 end
	end
	
	
	States.Demonbred.JuggleLaunch.onStepEnd = function(actor) 
		if actor.frame > 2 then
			local cGravity = actor.forces.gravity:getCurrent()[2]
			local gEvents = {
				{-1000, -3, 3},
				{-3, -1, 13},
				{-1, 1, 23},
				{1, 3, 33},
				{3, 1000, 43}
			}
			for _, v in pairs(gEvents) do
				if ((cGravity > v[1]) and (cGravity <= v[2])) then return v[3] end
			end
			return 23
		end
	end
	
end







--[[

function initSackStates()

	Sack = Actor:new{
	spritesheet = sack_sheet, 
	quad = love.graphics.newQuad(0, 0, 32, 32, sack_sheet:getDimensions()), 
	position = {500, 150}, 
	momentum = {0, 0}, 
	masterbox_coll = {0, 0, 0, 0}, 
	masterbox_damage = {0, 0, 0, 0}, 
	state = State:new(), 
	frame = 1, 
	facing = 1, 
	queued_turn = false, 
	hitstop = 0, 
	floatstop = 0, 
	HP = 100,
	forces = {gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(40, 100)}, impact = ForceImpact:new{decay = 0.9}}
}	


	local template_sack = {sx = 0, sy = 0, sw = 256, sh = 256, ox = 123, oy = 185, hitboxes = {}, collboxes = {{-30, -70, 60, 70}}, hurtboxes = {{-40, -110, 80, 110}}, aerial = false}
	
	State_SackIdle = State:initTemplate("SaIdle", template_sack)
	
	State_SackIdle:setFrames{
		{{sy = 0}, 1}
	}
	
	State_SackIdle.onStateStart = function(actor)
		ComboCounter = 0
	end
	
	
	State_SackHurt = State:initTemplate("SaHurt", template_sack)
	State_SackJuggle = State:initTemplate("SaJugg", template_sack)
	
	State_SackHurt.momentum_function = MFTable.ghitstun
	
	
	State_SackSmallLaunch = State:initTemplate("SaMiniJugg", template_sack)
	
	State_SackGroundSlam = State:initTemplate("SaGSlam", template_sack)
	State_SackOTGBounce = State:initTemplate("SaGBounce", template_sack)

	State_SackOTG = State:initTemplate("SaOTG", template_sack)
	
	
	
	
	State_SackIdle.next_state = State_SackIdle
	
	
	
	State_SackHurt:setFrames{
		{{sy = 256}, 100}
	}

	State_SackHurt.next_state = State_SackIdle
	State_SackHurt.duration = 100
	
	function State_SackHurt.onStepStart(actor)
		if actor.frame > actor.state.duration then	
			actor:changeState(State_SackIdle)
		else
			-- print("Actual duration", actor.state.duration)
		end
	end
	
	function State_SackHurt.onStateEnd(actor)
		for k, v in pairs(actor.forces) do
			v:deactivate()
		end
	end
	
	State_SackJuggle:setFrames{
		{{sy = 512, sx = 256}, 50},	
		{{sy = 512}, 50}
	}
	
	State_SackJuggle.momentum_function = MFTable.hitstun
	
	function State_SackJuggle.onStateStart(actor)
		actor.position[2] = actor.position[2] - 10
		if actor.previous_state.id == "SaGSlam" then
			actor.momentum[2] = -10
			actor.momentum[1] = 6 * actor.facing 
			actor.floatstop = 3
		end
	end
	
	function State_SackJuggle.onStepStart(actor)
		if actor:isGrounded() then
			actor:changeState(State_SackOTG)
		end
	end
	
	function State_SackJuggle.onStepEnd(actor)
		if actor.frame <= 50 then
			if actor.momentum[2] < 0 then
				actor.frame = 51
			elseif actor.frame == 50 then actor.frame = 1 end
		else
			if actor.momentum[2] > 0 then
				actor.frame = 1
			elseif actor.frame == 100 then actor.frame = 51 end
		end
	end
	
	State_SackJuggle.target_momentum = {0, -8}
	State_SackJuggle.next_state = State_SackIdle
	
	State_SackGroundSlam:setFrames{
		{{sy = 768}, 10}
	}	
	
	State_SackGroundSlam.onStateStart = function(actor)
		SFX.impact:play()

	end
	
	State_SackGroundSlam.onStateEnd = function(actor)
		actor.position[2] = actor.position[2] - 10
		actor.momentum[1] = actor.facing * 2
		actor.momentum[2] = -7
		actor.floatstop = 8
	end
	
	
	State_SackGroundSlam.next_state = State_SackJuggle
	
	
	State_SackBlowback = State:initTemplate("SaGBlowback", template_sack)
	State_SackWallSlam = State:initTemplate("SaWSlam", template_sack)
	
	
	

	State_SackOTG:setFrames{
		{{sy = 768, hurtboxes = {{-40, -50, 120, 50}}}, 12},
		{{sy = 768, hurtboxes = {}}, 6},
		{{sy = 768, hurtboxes = {}, sx = 256}, 12}
	}
	
	State_SackOTG.onStateStart = function(actor)
		SFX.impact:rewind()
		SFX.impact:play()
		-- actor.position[2] = actor.position[2] - 10
		-- actor.momentum[1] = actor.facing * 4
		-- actor.momentum[2] = -3
		-- actor.floatstop = 8

	end
	
	
	
	State_SackOTG.onStateEnd = function(actor)
		
	end
	
	State_SackOTG.next_state = State_SackIdle
	
end
]]