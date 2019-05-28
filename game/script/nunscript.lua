-- List of things that need to be done

-- # Controller support. :: DONE

-- # Rework the way hitstun works. Put the data locally, allow it to force specific kinds of states (in particular, states that lead into other states specified ahead of time), allow for attack levels.
-- # Revisit the input buffer 
-- # Add a 2f jump startup to allow better air normal buffering. Hurtboxes already off the ground
-- # Add a generous jump buffer from hitstop.
-- # Revisit animations for air normals on account of them being really terrible.

-- # Revisit animation: Air Backfist
-- # Revisit animation: Air Spinkick
-- # Revisit animation: Front kick (add a small jump to the startup)
-- # Revisit animation: Idle
-- # Revisit animation: Walk
-- # Revisit animation: Hook kick

-- # Add functionality to Stomp :: DONE

-- # Add move: Roll :: DONE
-- # Add move: Ledge cling
-- # Add move: Wall kick :: Kind of done in other game, look at how that was solved
-- # Add move: Rapid fire jabs
-- # Add move: Charged front kick
-- # Add move: Charged sweep
-- # Add move: Charged crescent
-- # Add move: Charged ground axe
-- # Add move: Charged air spinkick
-- # Add move: Charged air axekick

-- # Give the enemy some attacks and Air
-- # Add hitstun animations to nun


-- Current move list

-- Stances (while on the ground)

-- Stand: No input
-- Crouch: Hold down
-- Guard: Hold up
-- Dash: Press LB, or double tap forward 	
-- Sway: Press LT
-- Jump: Press RB

-- Punch: Press X
-- Kick: Press Y

-- Stand > P: Jab
			-- > On Hit: Straight
		-- > K: Hook Kick

-- Crouch > P: Left Uppercut
			-- > Hold P: Rising Uppercut
		 -- > K: Leg Sweep

-- Guard > P: Right Uppercut
		-- > K: Hop Kick
		
-- Dash > P: Kidney Blow
	  -- > K: Roundhouse Kick

-- Sway > P: Right Uppercut
	  -- > K: Roundhouse Kick
	  
-- Jump > P: Left-Right Punch
	  -- > K: Axe Kick
	  -- > Jump: Stomp

-- While Attacking & Forward
	  -- > P: Double Hook
	  -- > K: Roundhouse Kick

-- Special Moves
-- 236+P: Deathfist
-- 623+P: Rising Uppercut

	  
function initializeNunStates()
	States.Nun = {}
	
	local nun_hurt = {{-15, -93, 35, 93}}
	local nun_coll = {{-13, -85, 26, 85}}
	local nun_hit = {}
	
	
	APC.free_actions = {"Stand", "Duck", "Walk", "Dash", "Sway", "Guard", "Roll", "Prejump", "Jump", "LandRecovery"}
	
	
	local all_movement = {}
	local all_attacks = {"Jab", "Straight", "LeftUpper", "Sweep", "RightUpper", "SpinKick", "AxeKick", "Rekka1", "HeelKick", "Duck", "Dash", "Roll", "Sway", "Prejump", "Guard", "NunUpKick", "HopKick", "DeathFist", "RisingUpper", "FlyingKnee"}

	local all_grounded = {}
	
	local all_specials = {"DeathFist", "RisingUpper", "FlyingKnee", "Rekka1", "AxeKick"}
	local attacks = union(all_specials, 
	{"Jab", "LeftUpper", "RightUpper", "HeelKick", "FrontKick", "Sweep", "HopKick", "SpinKick"})
	
	local all_aerial = {"JumpBackFist", "JumpAxeKick", "JumpDiveKick", "JumpStomp", "JumpElbowDrop"}
	
	local cw = 256
	local ch = 256
	
	
	local ox_os = 104
	local oy_os = 200
	
	local hit_function = genericHitFunction
	
	local c_template = {sx = 0, sy = 0, sw = cw, sh = ch, ox = ox_os, oy = oy_os, sheet = 1,
	hitboxes = nun_hit, hurtboxes = nun_hurt, collboxes = nun_coll, rapidfire = false,
	on_whiff = {"Walk", "Prejump", "Dash", "Duck", "Sway", "Jab", "HeelKick", "LeftUpper", "Sweep", "Guard", "Roll", "HopKick", "DeathFist", "RisingUpper", "FlyingKnee"}, 
	on_hit = {}}
	
	
	States.Nun.Stand = State:initTemplate("Stand", union(c_template, {sy = 0}))
	States.Nun.Stand:setFrames{
		{{sx = 0}, 1}
	}
	
	States.Nun.Stand.onStateStart = function(actor)
		actor:resetChain()
	end
	
	States.Nun.Stand.onStepStart = function(actor) 
		if not actor:isGrounded() then actor:changeState(States.Nun.Jump) end 
	end
	
	-- State_NunTurn = State:initTemplate("NunTurn", union(c_template, {sx = 3*cw, sy = 1*ch}))
	-- States.Nun.Stand:setFrames{
		-- {{sx = 3*cw}, 3}
	-- }
	-- State_NunTurn.next_state = States.Nun.Stand
	
	States.Nun.Walk = State:initTemplate("Walk", union(c_template, {sy = 7, on_whiff = {"Prejump", "Dash", "Duck", "Roll", "Sway", "Jab", "HeelKick", "LeftUpper", "Sweep", "DeathFist", "RisingUpper", "FlyingKnee"}}))
	States.Nun.Walk:setFrames{
		{{sx = 3, ox = 116}, 10},
		{{sx = 0, ox = 115}, 7},
		{{sx = 1, ox = 116}, 10},
		{{sx = 2, ox = 117}, 7},
		--{{sx = 4}, 7},
		--{{sx = 5}, 7},
		--{{sx = 6}, 7},
		--{{sx = 7}, 7},
	}
	
	States.Nun.Walk:setMovements{
		{{7, 0}, 34, 1}
	}
	
	States.Nun.Walk.target_momentum = {0,0}
	States.Nun.Walk.next_state = States.Nun.Stand
	
	States.Nun.Walk.onStateStart = function(actor)
	end
	
	States.Nun.Walk.onStepStart = function(actor)
	
		if not actor:isGrounded() then
			actor:changeState(States.Nun.Jump)
		else
			if actor.frame == 8 then SFX.step:play() end
			if InputTable:getLR() == actor.facing then 
				if actor.frame == #actor.state.animation.frames then
					actor.frame = 1
				else
					actor.momentum[1] = math.min((actor.momentum[1] * actor.facing) + 2, 7) * actor.facing
					-- actor.state.target_momentum = {6, 0}
				end
			else
				actor:changeState(States.Nun.Stand)
			end
		end
	end
	
	States.Nun.Walk.onStepEnd = function(actor)
		if actor.frame == 12 then actor:resetChain() end
	end
	
	
	States.Nun.Dash = State:initTemplate("Dash", union(c_template, {sy = 1, on_whiff = {"Prejump", "Sway", "Roll"}}))
	States.Nun.Dash:setFrames{
		{{sx = 0}, 2},
		{{sx = 1}, 2},
		{{sx = 2}, 11}, 
		{{sx = 3}, 3},
		{{sx = 4}, 3},
		{{sx = 5}, 3},
		{{ on_whiff = all_attacks}, 9, 16},
		{{ on_whiff = {"Prejump", "Sway", "Roll", "Rekka1", "SpinKick", "DeathFist", "FlyingKnee", "RisingUpper"}}, 11, 5}
	}
	-- States.Nun.Dash.target_momentum = {6, 0}
	
	States.Nun.Dash.onStepEnd = function(actor)
		if actor.frame == 18 then actor:resetChain() end
		
		if actor.frame > 4 and actor.frame < 12 then
			actor.momentum[1] = 12 * actor.facing
		end
		
	end
	States.Nun.Dash.next_state = States.Nun.Stand
	
	States.Nun.Dash:setMovements{
		{{12, 0}, 10, 5},
		{{7, 0}, 7, 15},
	}
	
	local j_template = {sx = 0, sy = 0, sw = cw, sh = ch, sheet = 2, ox = ox_os, oy = oy_os, hitboxes = nun_hit, hurtboxes = nun_hurt, collboxes = {{-13, -70, 26, 50}}, on_whiff = all_aerial, on_hit = {}}
	
	States.Nun.Prejump = State:initTemplate("Prejump", union(c_template, {on_whiff = {}}))
	
	States.Nun.Prejump:setFrames{
		{{sx = 4, sy = 5}, 3}
	}
	
	States.Nun.Prejump.onStateEnd = function(actor)
		if actor:isGrounded() then
			actor.position[2] = actor.position[2] - 10
			-- actor:updateMasterboxes()	
			actor.momentum[2] = -18
		end
	end
	
	
	States.Nun.Jump = State:initTemplate("Jump", union(j_template, {sheet = 1, sy = 4}))
	States.Nun.Jump:setFrames{
		{{sx = 0}, 5},
		{{sx = 1}, 10},
		{{sx = 1}, 15}
	}
	
	States.Nun.Jump:setMovements{
		{{8, -15}, 15, 1},
		{{8, 15}, 15, 16},
	}
	
	States.Nun.Jump.target_momentum = {0, 20}	
	States.Nun.Jump.next_state = States.Nun.Jump
	
	States.Nun.Jump.onStateStart = function(actor)
		actor:resetChain()
	
		if InputTable:getLR() ~= 0 then
			actor.state.target_momentum[1] = math.min(math.max(actor.momentum[1] * actor.facing, 6), 8) 
		else
			actor.state.target_momentum[1] = 0
		end
		if actor.momentum[2] > 0 then
			actor.frame = 16
		end
		actor.momentum[1] = actor.facing * actor.state.target_momentum[1]
	end
	
	States.Nun.Jump.onStateEnd = function(actor)
		if actor.momentum[2] < -1 then
			-- if InputTable:isDown("jump") == false then
			-- actor.momentum[2] = actor.momentum[2] / 2
			-- else
				-- actor.momentum[2] = actor.momentum[2] / 2
		end
	end
	
	States.Nun.Jump.onStepStart = function(actor)
		if actor:isGrounded() then
			actor:changeState(States.Nun.Stand)
		end
	end
	
	States.Nun.Jump.onStepEnd = function(actor)
		if actor.frame <= 15 then
			if actor.frame >= 7 and actor.frame <= 12 then
				if InputTable:isDown("jump") == false then
					actor.momentum[2] = actor.momentum[2] / 2
					actor.frame = 12
				end
			elseif actor.frame > 13 then
				actor.momentum[2] = actor.momentum[2] / 2
			end
			if actor.momentum[2] >= 0 then
				actor.frame = 16
				-- actor.momentum[2] = 0
			end
		else
			if actor.momentum[2] < 0 then
				actor.frame = 1
			-- elseif actor.frame <= 22 then
				-- actor.momentum[2] = actor.momentum[2] / 2
			elseif actor.frame == 30 then
				actor.frame = 17
			end
			
		end	
		if actor.frame > 2 then
			actor.momentum[1] = actor.momentum[1] + InputTable:getLR() * 0.3
			if math.abs(actor.momentum[1]) < 5 then
				actor.state.target_momentum[1] = actor.momentum[1] * actor.facing
			elseif actor.state.target_momentum[1] > 5 and InputTable:getLR() * actor.facing == -1 then
				actor.state.target_momentum[1] = actor.state.target_momentum[1] - 0.3
			elseif math.abs(actor.momentum[1]) >= 8 then
				actor.state.target_momentum[1] = 8
			else
				actor.momentum[1] = actor.momentum[1] - InputTable:getLR() * 0.3
				actor.state.target_momentum[1] = actor.momentum[1] * actor.facing
			end
		end
	end
	
	States.Nun.Prejump.next_state = States.Nun.Jump
	
	States.Nun.Duck = State:initTemplate("Duck", union(c_template, {hurtboxes = {{-20, -45, 70, 45}}, on_whiff = {"Prejump", "Stand", "Sway", "Dash", "Guard", "Roll", "LeftUpper", "Sweep", "DeathFist", "FlyingKnee", "RisingUpper"}}))
	States.Nun.Duck:setFrames{
		{{sx = 0, sy = 2}, 12}
	}
	States.Nun.Duck.onStepEnd = function(actor) 
		if actor.frame == 12 then actor:resetChain() end
		if InputTable:getUD() == 1 and actor.frame == 12 then actor.frame = 11 end 
	end
	
	
	States.Nun.Duck.next_state = States.Nun.Stand
	
	States.Nun.Guard = State:initTemplate("Guard", union(c_template, {on_whiff = {"Prejump", "Dash", "Duck", "RightUpper", "Sway", "Roll", "HopKick", "DeathFist", "RisingUpper", "FlyingKnee",}}))
	States.Nun.Guard:setFrames{
		{{sx = 1, sy = 3}, 12}
	}
	
	States.Nun.Guard.onStepStart = function(actor) 
		if actor.frame == 12 then actor:resetChain() end
		if InputTable:getUD() == -1 and actor.frame == 12 then actor.frame = 11 end 
	end
	
	States.Nun.Guard.next_state = States.Nun.Stand
	
	States.Nun.Sway = State:initTemplate("Sway", union(c_template, {hurtboxes = {{-40, -93, 30, 93}}, collboxes = {{-40, -85, 26, 85}}, on_whiff = {"Prejump", "Dash", "Duck", "Guard", "Roll", "RightUpper", "SpinKick", "DeathFist", "FlyingKnee", "RisingUpper"}}))
	States.Nun.Sway:setFrames{
		{{sy = 3}, 7},
		{{sx = 1, sy = 3}, 23},
		{{on_whiff = {}}, 8, 1},
		{{on_whiff = {"Prejump", "Dash", "Walk", "Guard", "Duck", "RightUpper", "SpinKick", "Jab", "HeelKick", "DeathFist"}}, 18, 9}
	}
	States.Nun.Sway.target_momentum = {0, 0}
	States.Nun.Sway.onStepEnd = function(actor)
		if actor.frame == 12 then actor:resetChain() end
		if actor.frame == 1 then actor.momentum[1] = actor.facing * -5 end
		actor.state.target_momentum = {math.min(actor.frame/3 - 10, 0), 0}
	end
	
	States.Nun.Sway:setMovements{
		{{-6, 0}, 3, 1},
		{{-11, 0}, 7, 4},
		{{-4, 0}, 3, 11},
	}
	
	States.Nun.Sway.next_state = States.Nun.Stand

	
	
	States.Nun.Roll = State:initTemplate("Roll", union(c_template, {hurtboxes = {{-20, -45, 70, 45}},  on_whiff = {}, sy = 6}))
	
	States.Nun.Roll:setFrames{
		{{sx = 0}, 2},
		{{sx = 1}, 3},
		{{sx = 2}, 5},
		{{sx = 3}, 3},
		{{sx = 4}, 7},
		{{sx = 5}, 2},
		{{sx = 6}, 5},
		{{sx = 4, sy = 5}, 2},
		{{on_whiff = all_attacks}, 7, 22},
		{{actor_collision = false}, 20, 4}
	}

	States.Nun.Roll.onStepStart = function(actor)
		if actor.frame < 14 then
		actor.momentum[1] = actor.momentum[1] * actor.facing
		actor.momentum[1] = math.max(actor.momentum[1], 11)	
		actor.momentum[1] = actor.momentum[1] * actor.facing
		end
	end
	
	States.Nun.Roll.onStepEnd = function(actor)
		if actor.frame == 12 then actor:resetChain() end
	end
	
	States.Nun.Roll:setMovements{
		{{11, 0}, 13, 3},
	}
	
	States.Nun.Roll.next_state = States.Nun.Stand
	
	States.Nun.Jab = State:initTemplate("Jab", union(c_template, {on_whiff = all_movement, rapidfire = true, on_hit = all_attacks}))
	States.Nun.Jab:setFrames{
		{{sx = 0, sy = 1}, 2},
		{{sx = 0, sy = 8, ox = 98, hit = 1, hitboxes = {{0, -90, 55, 20}, {0, -70, 40, 70}}, 
		hitEffect = AttackEffect:fromHitstuns(
			Hitstun:new{state = "Hurt", length = 13, velocity = {7, 0}, hitstop = {6, 10}, sfx = "light"},
			Hitstun:new{state = "Juggle", velocity = {5, -3}, float_length = 6, sfx = "light"}
		)}, 6},
		{{sx = 0, sy = 1}, 4}
	}
	
	States.Nun.Jab.onStepStart = function(actor)
		if actor.hits[1] ~= nil then
			actor:changeState(States.Nun.Straight)
		end
	end
	
	States.Nun.Jab.target_momentum = {0, 0}
	
	States.Nun.Jab.onStepEnd = function(actor)
		-- actor.momentum[1] = (actor.frame == 2) and (math.min(math.abs(actor.momentum[1]), 4) + 4) * actor.facing or actor.momentum[1]
		-- actor.momentum[1] = (actor.frame == 7) and actor.momentum[1] -2*actor.facing or actor.momentum[1]
	end
	
	States.Nun.Straight = State:initTemplate("Straight", union(c_template, {on_whiff = all_movement, on_hit = all_attacks}))
	States.Nun.Straight:setFrames{
		{{sx = 0, sy = 9}, 5},
		{{sx = 1, sy = 9, hit = 1, ox = 100, hitboxes = {{0, -110, 70, 60}, {0, -110, 60, 110}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Hurt", length = 20, velocity = {7, 0}, hitstop = {11, 13}},
			{state = "Juggle", velocity = {4, -5}, float_length = 4}
		)}, 7},
		{{sx = 7, sy = 14}, 4},
		{{sx = 0, sy = 9}, 5},
		{{on_whiff = all_attacks}, 6, 1}
	}
	
	States.Nun.Straight.target_momentum = {0, 0}
	
	States.Nun.Straight.onStateStart = function(actor)
		actor.momentum[1] = 4*actor.facing
	end
	
	States.Nun.Straight.onStepEnd = function(actor)
		actor.momentum[1] = (actor.frame < 6) and 6*actor.facing or 0
		-- actor.momentum[1] = (actor.frame == 6) and (math.min(math.abs(actor.momentum[1]), 4) + 6) * actor.facing or actor.momentum[1]
	end
	
	States.Nun.Straight.onStateEnd = function(actor)
		actor.momentum[1] = 0
	end
	
	
	States.Nun.Straight.next_state = States.Nun.Stand
	States.Nun.Jab.next_state = States.Nun.Stand
	
	States.Nun.FrontKick = State:initTemplate("FrontKick", union(c_template, {sy = 5, ox = 60, on_whiff = all_movement, on_hit = all_attacks}))
	States.Nun.FrontKick:setFrames{
		{{}, 5},
		{{sx = 1}, 8},
		{{sx = 2, hit = 1, hitboxes = {{0, -90, 110, 80}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Hurt", length = 20, velocity = {15, 0}, hitstop = {8, 13}, sfx = "fierce"}, 
			{state = "Juggle", velocity = {8, -1}, float_length = 8}
		)}, 14},
		{{sx = 3}, 8},
		{{sx = 4}, 5}
	}
	States.Nun.FrontKick.target_momentum = {0, 0}
	States.Nun.FrontKick.onStepEnd = function(actor)
		actor.momentum[1] = (actor.frame == 11) and actor.momentum[1] + 11*actor.facing or actor.momentum[1]
	end
	
	States.Nun.FrontKick.onStateEnd = function(actor)
		actor.momentum[1] = 0
	end
	
	States.Nun.FrontKick.next_state = States.Nun.Stand
	
	
	
	
	States.Nun.LeftUpper = State:initTemplate("LeftUpper", union(c_template, {hurtboxes = {{-20, -45, 70, 45}}, sy = 11, on_whiff = all_movement, on_hit = all_attacks}))
	States.Nun.LeftUpper:setFrames{
		{{sx = 0}, 3},
		{{sx = 1}, 1},
		{{sx = 2, hit = 1, hitboxes = {{0, -130, 50, 130}, {0, -130, 75, 70}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Hurt", velocity = {6, 0}, hitstop = {11, 14}, length = 15}, 
			{state = "Juggle", velocity = {4, -7}, float_length = 5}
		)}, 14},
		{{sx = 1}, 10}
	}
	
	States.Nun.LeftUpper.onStepEnd = function(actor)
		if actor.frame == 9 and actor.hits[1] ~= nil then
			if InputTable:getKeyHoldLength("light") > 13 then
				actor.momentum[1] = actor.facing * 8
				actor:changeState(States.Nun.RisingUpper)
				actor.frame = 1
			end
		end
	end
	
	States.Nun.LeftUpper.next_state = States.Nun.Stand
	
	
	
	States.Nun.RisingUpper = State:initTemplate("RisingUpper", union(j_template, {hurtboxes = {{-20, -45, 70, 45}}, sy = 15, sheet = 1, on_whiff = all_movement, ox = 130, on_hit = {}}))
	
	
	States.Nun.RisingUpper:setFrames{
		{{sx = 0}, 2},
		{{sx = 0, hit = 1, hitboxes = {{0, -80, 20, 80}, {-10, -160, 60, 80}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {5, -18}, hitstop = {16, 16}, float_length = 2, sfx = "heavy"},
			{state = "Juggle", velocity = {7, -20}, float_length = 8}
		)}, 9},
		{{sx = 1}, 6},
		{{sx = 2}, 8},
		{{sx = 3}, 200}		
	}
	
	States.Nun.RisingUpper.onStateStart = function(actor)
		-- dum
		
		--InputTable:dumpLog(40)
	
		actor.momentum[1] = 6 * actor.facing
		if actor:isGrounded() then actor.position[2] = actor.position[2] - 10 end
		-- actor:updateMasterboxes()
		if actor.momentum[2] > -1 then
			actor.momentum[2] = -14
		end
	end
	
	States.Nun.RisingUpper.onStepStart = function(actor)
		if actor:isGrounded() and actor.frame > 17 then
			actor:changeState(States.Nun.LandRecovery)
		end
	end
	
	States.Nun.RisingUpper.onStepEnd = function(actor)
		if actor.frame <= 13 then
			actor.momentum[1] = math.max(6, actor.momentum[1] * actor.facing) * actor.facing
			-- if actor.momentum[2] >= 0 then
				-- actor.frame = 18
			-- end
		end
		if actor.momentum[2] >= 0 then
			-- actor.momentum[2] = actor.momentum[2] + 0.5
		end
	end
	
	States.Nun.RisingUpper.target_momentum = {0, 20}
	
	States.Nun.RisingUpper.next_state = States.Nun.Jump
	
	States.Nun.Sweep = State:initTemplate("Sweep", union(c_template, {sheet = 2, hurtboxes = {{-20, -45, 70, 45}}, sy = 3, on_whiff = all_movement, on_hit = all_attacks}))
	
	States.Nun.Sweep:setFrames{
		{{sx = 0}, 5},
		{{sx = 1, hit = 1, hitboxes = {{0, -40, 117, 40}, {0, -25, 132, 25}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {2, -4}, hitstop = {10, 14}, float_length = 7, sfx = "fierce"},
			{state = "Juggle", velocity = {2, -1}, float_length = 7}
		)}, 4},
		{{sx = 2}, 12},
		{{sx = 0}, 9}
	}
	States.Nun.Sweep.next_state = States.Nun.Stand
	
	
	States.Nun.RightUpper = State:initTemplate("RightUpper", union(c_template, {sy = 12, on_whiff = all_movement, on_hit = all_attacks}))
	States.Nun.RightUpper:setFrames{
		{{sx = 0, sy = 14}, 2},
		-- {{sx = 2*cw, sy = 10*ch}, 1},
		{{sx = 0}, 3},
		{{sx = 1}, 1},
		{{sx = 2, hit = 1, ox = 100, hitboxes = {{30, -100, 55, 50}, {10, -70, 60, 70}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Hurt", length = 19, velocity = {11, 0}, hitstop = {10, 13}, sfx = "fierce"}, 
			{state = "Juggle", velocity = {3.5, -5.5}, float_length = 9}
		)}, 11},
		{{sx = 7, sy = 14}, 8},
		{{sx = 9, sy = 14}, 2}
	}
	
	-- Initial momentum of these is supposed to depend on length of sway. 
	
	
	-- States.Nun.RightUpper.target_momentum = {0, 0}
	
	States.Nun.RightUpper.onStepEnd = function(actor)
		if actor.frame < 8 and actor.previous_state.id == "Sway" then 
			actor.momentum[1] = actor.facing * 12
			-- States.Nun.RightUpper.target_momentum = {3, 0}
		elseif actor.previous_state.id ~= "Sway" then
			if actor.frame == 7 then actor.momentum[1] = actor.facing * 10
			elseif actor.frame < 5 and actor.frame > 2 then actor.momentum[1] = actor.facing * -4
			elseif actor.frame == 12 then actor.momentum[1] = 0 end
			-- States.Nun.RightUpper.target_momentum = {3, 0}
			-- actor.momentum[1] = math.max(actor.momentum[1] * actor.facing, (8 - actor.frame/2)) * actor.facing
		else
			-- States.Nun.RightUpper.target_momentum = {0, 0}
		end
	end
	States.Nun.RightUpper.next_state = States.Nun.Stand
	
	--[[
	
	State_NunLKidney = State:initTemplate("NunLKidney", union(c_template, {sy = 10, on_whiff = all_movement, on_hit = diff(all_attacks, {"NunLKidney"})}))
	State_NunLKidney:setFrames{
		{{sx = 0}, 5},
		{{sx = 1, hit = 1, hitboxes = {{10, -90, 60, 90}}}, 4},
		{{sx = 1}, 4},
		{{sx = 2}, 10},
		
		{{hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {7, -3}, hitstop = 10, float_length = 4, sfx = "fierce"},
			{state = "Juggle", velocity = {7, -2}, hitstop = 10, float_length = 4, sfx = "fierce"}
		)}, 4, 6}
	}
	
	
	State_NunLKidney.onStepEnd = function(actor)
		if actor.frame < 10 then
			if actor.momentum[1] * actor.facing < 5 then actor.momentum[1] = 5 * actor.facing end
		end
		if actor.frame == 8 and actor.hits[1] ~= nil then
			if InputTable:getKeyHoldLength("light") > 13 then
				-- actor.momentum[1] = 6
				actor:changeState(States.Nun.Straight)
				actor.frame = 1
			end
		end	
		
	end
	
	State_NunLKidney.next_state = States.Nun.Stand
	
	
	
	State_NunUpkick = State:initTemplate("NunUpKick", union(c_template, {sheet = 2, sy = 2, on_whiff = all_movement, on_hit = diff(all_attacks, {"NunUpKick"})}))
	State_NunUpkick:setFrames{
		{{sx = 0}, 6},
		{{sx = 1}, 4},
		{{sx = 2}, 2},
		{{sx = 3}, 8},
		{{sx = 4}, 12},
		
		{{hit = 1, hitboxes = {{0, -140, 70, 140}, {20, -160, 70, 70}}, hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {2, -12}, hitstop = {12, 12}, float_length = 6, sfx = "fierce"},
			{state = "Juggle", velocity = {4, -7}, float_length = 6}
		)}, 4, 13}
	}
	
	State_NunUpkick.next_state = States.Nun.Stand]]
	
	States.Nun.SpinKick = State:initTemplate("SpinKick", union(c_template, {sheet = 2, sy = 1, on_whiff = all_movement, on_hit = all_attacks}))
	States.Nun.SpinKick:setFrames{
		{{sx = 0}, 7},
		{{sx = 1}, 3},
		{{sx = 2, hit = 1, hitboxes = {{0, -90, 70, 90}, {30, -110, 75, 75}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle",  velocity = {7, -11}, hitstop = {9, 11}, float_length = 5, sfx = "fierce"}, 
			{state = "Juggle", velocity = {5, -9}, float_length = 5}
		)}, 4},
		{{sx = 3}, 9},
		{{sx = 4}, 11}
		-- {{hitboxes = {{0, -90, 80, 90}}}, 2, 15}
	}
	
	
	States.Nun.SpinKick.target_momentum = {0, 0}
	
	
	States.Nun.SpinKick.onStepEnd = function(actor)
		if actor.frame == 1 and actor.previous_state.id == "Sway" then 
			actor.momentum[1] = actor.facing * 17
		elseif actor.frame < 9 then
			if actor.momentum[1] * actor.facing < 8 then actor.momentum[1] = 8 * actor.facing end
		end
		-- actor.state.target_momentum[1] = math.max(12 - actor.frame/2, 0)
	end
	States.Nun.SpinKick.next_state = States.Nun.Stand
	
	--[[
	
	State_NunWHook = State:initTemplate("NunWHook", union(c_template, {sy = 13, on_whiff = all_movement, on_hit = diff(all_attacks, {"NunWHook"})}))
	State_NunWHook:setFrames{
		{{sx = 0}, 7},
		{{sx = 1, hit = 1, hitboxes = {{0, -110, 70, 110}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {5, -9}, hitstop = {6, 16}, sfx = "light"}, 
			{state = "Juggle", velocity = {-2.5, -2}, float_length = 2, sfx = "light"}
		)}, 2},
		{{sx = 2}, 2},
		{{sx = 3, hit = 2, on_hit = {}, hitboxes = {{0, -120, 80, 120}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Groundbounce", velocity = {3, 30}, hitstop = {8, 12}, sfx = "fierce"}, 
			{state = "Groundbounce", velocity = {3, 30}}
		)}, 4},
		{{sx = 4, on_hit = {}}, 8}
	}
	State_NunWHook.next_state = States.Nun.Stand
	
	
	State_NunWHook.target_momentum = {0, 0}
	State_NunWHook.onStepEnd = function(actor)
		actor.momentum[1] = actor.facing * (2 < actor.frame and actor.frame < 7 and 8 or 0)
		if actor.frame == 11 and actor.hits[1] then
				if InputTable:getKeyHoldLength("light") > 12 then
					actor.momentum[1] = 4 * actor.facing
					actor:changeState(States.Nun.RightUpper)
					actor.frame = 4
				end
		end		
	end]]
	
	
	States.Nun.HeelKick = State:initTemplate("HeelKick", union(c_template, {sy = 0, sheet = 2, on_whiff = all_movement, on_hit = union(all_attacks, {"FrontKick"})}))
	States.Nun.HeelKick:setFrames{
		{{sx = 0, ox = 110}, 1},
		{{sx = 1, ox = 125}, 4},
		{{sx = 2, ox = 120}, 3},
		{{sx = 3, ox = 120}, 1},
		{{sx = 4, ox = 120}, 3},
		{{sx = 5, ox = 90}, 1},
		-- {{sx = 6, ox = 90}, 1},
		{{sx = 8, ox = 60}, 1},
		{{sx = 9, ox = 70}, 5}, 		
		{{sx = 10, ox = 70}, 4},
		{{sx = 11, ox = 70}, 4},
		{{sx = 12, ox = 80}, 4},
		{{sx = 13, ox = 90}, 4},
		{{sx = 14, ox = 100}, 4},
		{{hit = 1, hitboxes = {{20, -100, 108, 100}}, hitEffect = 
		AttackEffect:fromHitstuns(
			{state = "Hurt", length = 20, velocity = {7, 0}, sfx = "fierce", hitstop = {9, 14}}, 
			{state = "Juggle", velocity = {6, -4}, float_length = 5}
		)}, 5, 14},
		{{hitboxes = {{20, -95, 104, 95}}}, 3, 16},
	}
	
	States.Nun.HeelKickCharged = State:initTemplate("HeelKickCharged", union(c_template, {sheet = 2, sy = 0, on_whiff = {}, on_hit = {}}))
	States.Nun.HeelKickCharged:setFrames{
		{{sx = 4}, 3},
		{{sx = 6, ox = 90}, 2},
		{{sx = 7, ox = 75}, 2},
		{{sx = 8, ox = 60}, 2},
		{{sx = 9, ox = 60}, 1},
		{{sx = 10, ox = 60}, 3},
		{{sx = 11, ox = 70}, 10},
		{{sx = 12, ox = 80}, 4},
		{{sx = 13, ox = 90}, 3},
		{{sx = 14, ox = 100}, 2},
		
		{{hit = 1, hitboxes = {{0, -115, 75, 60}, {60, -130, 30, 40}}, hitEffect = 
		AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {4, -6}, sfx = "fierce", float_length = 5, hitstop = {10, 17}}, 
			{state = "Juggle"}
		)}, 2, 7},
		{{hit = 1, hitboxes = {{20, -80, 105, 60}}, hitEffect = 
		AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {4, -3}, sfx = "fierce", float_length = 2, hitstop = {10, 17}}, 
			{state = "Juggle"}
		)}, 4, 9}
	}
	
	
	States.Nun.HeelKick.target_momentum = {0, 0}
	States.Nun.HeelKick.onStepEnd = function(actor)
		actor.momentum[1] = actor.facing * (actor.frame > 12 and actor.frame < 17 and 8 or actor.momentum[1]*actor.facing)
		actor.momentum[1] = actor.facing * (actor.frame > 16 and actor.frame < 21 and 5 or actor.momentum[1]*actor.facing)
		
		-- actor.momentum[1] = actor.facing * (actor.frame > 9 and actor.frame < 13 and 12 or actor.momentum[1])
	end
	
	States.Nun.HeelKick.next_state = States.Nun.Stand
	
	
	
	
	States.Nun.HeelKick.onStepStart = function(actor)
		if actor.frame == 12 and InputTable:getKeyHoldLength("heavy") > 12 then
			actor:changeState(States.Nun.HeelKickCharged)
		end
	
	end
	
	States.Nun.HeelKickCharged.onStepStart = function(actor)
		if actor.frame < 6 and InputTable:getKeyHoldLength("heavy") == 0 then
			actor:changeState(States.Nun.HeelKick)
			actor.frame = 13
		end
	end
	
	States.Nun.HeelKickCharged.onStepEnd = function(actor)
		actor.momentum[1] = actor.facing * (actor.frame < 16 and 8 or actor.momentum[1]*actor.facing)
		-- actor.momentum[1] = actor.facing * (actor.frame > 9 and actor.frame < 13 and 12 or actor.momentum[1])
	end
	
	States.Nun.HeelKickCharged.next_state = States.Nun.Stand

	
	States.Nun.AxeKick = State:initTemplate("AxeKick", union(c_template, {ox = 100, sy = 6, sheet = 2, on_whiff = {}, on_hit = all_specials}))
	States.Nun.AxeKick:setFrames{
		{{sx = 0}, 2},
		{{sx = 1}, 2},
		{{sx = 2}, 3},
		{{sx = 3}, 6},
		{{sx = 4}, 3},
		{{sx = 5, ox = 90}, 5},
		{{sx = 6, ox = 92}, 5},
		{{sx = 7}, 4},
		{{sx = 8}, 2},
		{{hit = 1, hitboxes = {{0, -125, 100, 125}}, hitEffect = 
		AttackEffect:fromHitstuns(
			{state = "Hurt", length = 24, velocity = {10, 0}, sfx = "fierce", hitstop = {8, 12}}, 
			{state = "Juggle", velocity = {4, 30}, float_length = 5}
		)}, 2, 17}
	}
	
	States.Nun.AxeKickCharged = State:initTemplate("AxeKickCharged", union(c_template, {ox = 95, sy = 6, sheet = 2, on_whiff = {}, on_hit = {}}))
	States.Nun.AxeKickCharged:setFrames{
		{{sx = 3}, 8},
		{{sx = 4}, 3},
		{{sx = 5, ox = 90}, 6},
		{{sx = 6, ox = 92}, 6},
		{{sx = 7}, 5},
		{{sx = 8}, 3},
		
		{{hit = 1, hitboxes = {{0, -125, 100, 125}}, hitEffect = 
		AttackEffect:fromHitstuns(
			{state = "Juggle", length = 24, velocity = {10, 0}, sfx = "fierce", hitstop = {8, 16}}, 
			{state = "Juggle", velocity = {4, 30}, float_length = 5}
		)}, 3, 9},
		
		{{hit = 2, hitboxes = {{0, -125, 100, 125}}, hitEffect = 
		AttackEffect:fromHitstuns(
			{state = "Groundbounce", length = 24, velocity = {2, 20}, sfx = "heavy", hitstop = {12, 15}, float_length = 2}, 
			{state = "Groundbounce", velocity = {2, 20}}
		)}, 4, 12}
		
	}
	
	
	
	
	States.Nun.AxeKick.onStepStart = function(actor)
		if actor.frame == 13 and InputTable:getKeyHoldLength("heavy") > 12 and Interface.animEditActive == false then
			actor:changeState(States.Nun.AxeKickCharged)
		end
	
	end
	
	States.Nun.AxeKickCharged.onStepStart = function(actor)
		if actor.frame < 7 and InputTable:getKeyHoldLength("heavy") == 0 and Interface.animEditActive == false then
			print("State changin'")
			actor:changeState(States.Nun.AxeKick)
			actor.frame = 14
		end
	end
	
	States.Nun.AxeKick.next_state = States.Nun.Stand	
	States.Nun.AxeKickCharged.next_state = States.Nun.Stand	
	
	
	
	
	
	
	States.Nun.DeathFist = State:initTemplate("DeathFist", union(c_template, {sy = 14, on_whiff = {}, on_hit = {}}))
	States.Nun.DeathFist:setFrames{
		{{sx = 0}, 1},
		{{sx = 1}, 3},
		{{sx = 2}, 2},
		{{sx = 3, collboxes = {{-13, -85, 45, 85}}}, 1},
		{{sx = 4, ox = 80}, 1},
		{{sx = 5, hit = 1, ox = 85, hitboxes = {{20, -87, 85, 45}},
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {20, -4}, float_length = 11, hitstop = {13, 15}, sfx = "heavy"}, 
			{state = "Juggle", velocity = {20, -4}, float_length = 11}
		)}, 6},
		{{sx = 5, ox = 85}, 6},
		{{sx = 6}, 4},
		{{sx = 7}, 4},
		{{sx = 8}, 3},
		{{sx = 9}, 3},
	}
	
	States.Nun.DeathFist.onStateStart = function(actor)
		-- if actor.previous_state.id == "Sway" then actor.frame = 3 end 
	end
	
	
	States.Nun.DeathFist.onStepEnd = function(actor)
		if actor.frame < 9 and (actor.frame > 4 or actor.previous_state.id == "Sway") then
			actor.momentum[1] = 20*actor.facing
		elseif actor.frame >= 9 and actor.frame < 20 then
			actor.momentum[1] = actor.momentum[1] / 5 * 4
			if actor.momentum[1] * actor.facing < 3 then
				actor.momentum[1] = 3*actor.facing
			end
		end
	end
	
	States.Nun.DeathFist.next_state = States.Nun.Stand
	
	States.Nun.FlyingKnee = State:initTemplate("FlyingKnee", union(c_template, {sheet = 2, sy = 5, on_whiff = {}, on_hit = {}}))
	States.Nun.FlyingKnee:setFrames{
		{{sx = 0}, 1},
		{{sx = 1, ox = 110}, 5},
		{{sx = 2, ox = 120}, 3},
		{{sx = 3, collboxes = {{-13, -70, 26, 50}}}, 1},
		{{sx = 4, collboxes = {{-13, -70, 26, 50}}}, 1},
		{{sx = 5, collboxes = {{-13, -70, 26, 50}}, hit = 1, hitboxes = {{0, -90, 70, 90}, {30, -110, 75, 75}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle",  velocity = {15, -12}, hitstop = {14, 12}, float_length = 7, sfx = "heavy"}, 
			{state = "Juggle", velocity = {14, -10}, float_length = 7}
		)}, 10},
		{{sx = 6, collboxes = {{-13, -70, 26, 50}}}, 3},
		{{sheet = 1, sy = 4, sx = 1, collboxes = {{-13, -70, 26, 50}}}, 20}
	}

	States.Nun.FlyingKnee.onStepStart = function(actor)
		if actor.frame > 15 and actor:isGrounded() then
			actor:changeState(States.Nun.LandRecovery)
		end
	end
	
	States.Nun.FlyingKnee.onStepEnd = function(actor)
		if actor.frame >= 9 and actor.frame <= 11 then
			actor.momentum[1] = actor.facing * 15
			actor.momentum[2] = -5
			actor.position[2] = actor.position[2] - 10
		elseif actor.frame > 12 then
			actor.momentum[1] = (actor.momentum[1] * actor.facing > 5) and (actor.momentum[1] + actor.facing * -1/2) or actor.momentum[1]
			actor.momentum[2] = actor.momentum[2] - 0.5
		end
	end
	
	States.Nun.FlyingKnee.next_state = States.Nun.Stand
	
	
	
	
	
	States.Nun.Rekka1 = State:initTemplate("Rekka1", union(c_template, {sy = 13, on_whiff = {}, on_hit = union(all_specials, {"Rekka2"})}))
	
	States.Nun.Rekka1:setFrames{
		{{sx = 0}, 7},
		{{sx = 1}, 3},
		{{sx = 2}, 7},
		{{sx = 3}, 7},
		{{sx = 4, ox = 120}, 5},
		{{hit = 1, hitboxes = {{0, -85, 75, 30}, {0, -55, 55, 60}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Hurt", velocity = {13, 0}, length = 20, hitstop = {8, 12}, sfx = "medium"}, 
			{state = "Juggle", velocity = {5, -3}, float_length = 12}
		)}, 10, 8}
	
	}
	
	States.Nun.Rekka1.onStateStart = function(actor)
		if actor.previous_state.id == "Dash" then actor.frame = 4 end
	end
	
	States.Nun.Rekka1.onStepEnd = function(actor)
		if ((actor.frame <= 13) and ((actor.frame >= 6) or (actor.previous_state.id == "Dash"))) then
			actor.momentum[1] = actor.facing * 10
		end
	end
	
	
	States.Nun.Rekka2 = State:initTemplate("Rekka2", union(c_template, {sy = 12, on_whiff = {}, on_hit = union(all_specials, {"Rekka3"})}))
	States.Nun.Rekka2:setFrames{
		{{sx = 1, ox = 140}, 6},
		{{sx = 2, hit = 1, ox = 105, hitboxes = {{30, -100, 55, 50}, {10, -70, 60, 70}}, 	
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", length = 19, velocity = {6, -3}, hitstop = {8, 14}, float_length = 10, sfx = "medium"}, 
			{state = "Juggle", velocity = {3, -2}, float_length = 6}
		)}, 8},
		{{sx = 7, sy = 14}, 4},
		{{sx = 9, sy = 14}, 3}
	}
	
	States.Nun.Rekka2.onStepEnd = function(actor)
		if actor.frame <= 13 then
			actor.momentum[1] = actor.facing * 6
		end
	end
	
	States.Nun.Rekka3 = State:initTemplate("Rekka3", union(c_template, {sy = 10, on_whiff = {}, on_hit = {}}))
	States.Nun.Rekka3:setFrames{
		{{sx = 0, ox = 115}, 5},
		{{sx = 1, ox = 95, hit = 1, hitboxes = {{10, -120, 80, 120}}}, 4},
		{{sx = 1, ox = 95}, 7},
		{{sx = 2, ox = 110}, 10},
		
		{{hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {12, -4}, hitstop = {14, 14}, float_length = 4, sfx = "fierce"},
			{state = "Juggle", velocity = {12, -3}, sfx = "fierce"}
		)}, 4, 6}
	}
	
	States.Nun.Rekka3.onStepEnd = function(actor)
		if actor.frame <= 6 then
			actor.momentum[1] = actor.facing * 2
		end
	end
	
	States.Nun.Rekka1.next_state = States.Nun.Stand
	States.Nun.Rekka2.next_state = States.Nun.Stand
	States.Nun.Rekka3.next_state = States.Nun.Stand
	
	
	States.Nun.LandRecovery = State:initTemplate("LandRecovery", union(c_template, {sy = 5}))
	States.Nun.LandRecovery:setFrames{
		{{sx = 3, on_whiff = {}}, 4},
		{{sx = 4, on_whiff = union(diff(all_attacks, {"Rekka1", "AxeKick"}), {"Walk"})}, 8}
	}
	
	States.Nun.LandRecovery.onStateStart = function(actor)
		actor.momentum[1] = 0
		actor:resetChain()
	end
	
	States.Nun.LandRecovery.next_state = States.Nun.Stand
	

	
	States.Nun.JumpBackFist = State:initTemplate("JumpBackFist", union(j_template, {sy = 8, on_whiff = {}, on_hit = all_aerial}))
	States.Nun.JumpBackFist:setFrames{
		{{sx = 0, ox = 115}, 6},
		{{sx = 1, hit = 1, hitboxes = {{-10, -110, 90, 100}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Hurt", velocity = {8, 0}, hitstop = {9, 10}, length = 21}, 
			{state = "Juggle", velocity = {4, -5}, float_length = 6}
		)}, 4},
		{{sx = 2}, 1},	
		{{sx = 3}, 1},	
		{{sx = 4, hit = 2, hitboxes = {{-10, -110, 90, 100}},
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Hurt", velocity = {8, 0}, hitstop = {9, 12}, length = 21}, 
			{state = "Juggle", velocity = {4, -5}, float_length = 6}
		)}, 6},
		{{sx = 5}, 12}
	}
	
	States.Nun.JumpBackFist.onStepStart = function(actor)
		if actor:isGrounded() then
			actor:changeState(States.Nun.LandRecovery)
		end	
	end
	
	States.Nun.JumpBackFist.onStateStart = function(actor)
		if actor.facing * actor.momentum[1] < 0 then
			actor.state.target_momentum[1] = 2
		else
			actor.state.target_momentum[1] = math.min(actor.momentum[1] * actor.facing, 8)
		end
		actor.momentum[2] = actor.momentum[2] / 4 * 3
	end
	
	States.Nun.JumpBackFist.onStepEnd = function(actor)
		if actor.frame == 11 and actor.hits[1] ~= nil then
			if InputTable:getKeyHoldLength("light") > 13 then
				-- actor.momentum[1] = 6
				-- actor:changeState(States.Nun.RisingUpper)
				-- actor.frame = 1
			end
		end
	
	
		-- if actor.momentum[2] < 0 and not InputTable:isDown("jump") then actor.momentum[2] = actor.momentum[2] / 2 end
	end
	
	States.Nun.JumpBackFist.target_momentum = {0, 20}
	States.Nun.JumpBackFist.next_state = States.Nun.Jump
	
	States.Nun.JumpElbowDrop = State:initTemplate("JumpElbowDrop", union(j_template, {sy = 9, on_whiff = {}, on_hit = {}}))
	
	States.Nun.JumpElbowDrop:setFrames{
		{{sx = 0}, 14},
		{{sx = 1, oy = 137, hit = 1, hitboxes = {{-30, -75, 100, 75}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {1, 15}, hitstop = {8, 12}, sfx = "fierce"}, 
			{state = "Juggle", velocity = {4, 15}}
		)}, 200},
		{{sx = 2, oy = 120}, 8}	
	}
	
	States.Nun.JumpElbowDrop.onStateStart = function(actor)
		actor.momentum[2] = -12
		
	end
	
	States.Nun.JumpElbowDrop.onStepStart = function(actor)
		if actor:isGrounded() and actor.frame < 215 then
			actor.frame = 215
		end
	end
	
	States.Nun.JumpElbowDrop.onStepEnd = function(actor)
		if actor.frame < 12 then actor.momentum[1] = 3*actor.facing
		elseif actor.frame > 12 then actor.momentum[2] = actor.momentum[2] + 1.5 end
	end
	
	States.Nun.JumpElbowDrop.target_momentum = {0, 20}
	States.Nun.JumpElbowDrop.next_state = States.Nun.Stand
	
	
	States.Nun.HopKick = State:initTemplate("HopKick", union(j_template, {sy = 4, on_whiff = {}, on_hit = all_aerial}))
	States.Nun.HopKick:setFrames{
		{{sheet = 1, sx = 3, sy = 5, collboxes = nun_coll}, 3},
		{{sx = 4, sy = 2}, 5},
		{{sx = 2}, 3},
		{{sx = 0}, 2},
		{{sx = 1, hit = 1, hitboxes = {{-10, -110, 90, 55}, {-5, -110, 30, 90}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {5, -9}, hitstop = {10, 14}, float_length = 4}, 
			{state = "Juggle", velocity = {5, -5}}
		)}, 3},
		{{sx = 2}, 12},
		{{sx = 0}, 15}
	}
	States.Nun.HopKick.next_state = States.Nun.Jump
	States.Nun.HopKick.target_momentum = {0, 20}
	
	States.Nun.HopKick.onStepStart = function(actor)
		if actor:isGrounded() and actor.frame > 3 then
			actor:changeState(States.Nun.LandRecovery)
		end	
	end
	
	States.Nun.HopKick.onStateStart = function(actor)
		actor.state.target_momentum[1] = 0
	end
	
	States.Nun.HopKick.onStepEnd = function(actor)
		actor.momentum[2] = actor.frame < 15 and (actor.momentum[2] - (actor.frame / 10) + 1) or actor.momentum[2]
		if actor.frame == 3 then
			actor.state.target_momentum[1] = 2
			actor.position[2] = actor.position[2] - 17
			actor.momentum[2] = -10			
		end
		if actor.frame > 3 and actor.frame < 11 then
			actor.momentum[1] = 4 * actor.facing
			actor.momentum[2] = -4.5
		end
		if actor.frame > 10 and actor.frame < 14 then
			actor.momentum[1] = 15 * actor.facing
		end
		if actor.frame > 13 then
			actor.momentum[1] = 3 * actor.facing
		end
	end
	
	States.Nun.HopKick.onStateEnd = function(actor)
		actor.momentum[1] = 8 * actor.facing
		actor.momentum[2] = -2
	end
	

	States.Nun.JumpAxeKick = State:initTemplate("JumpAxeKick", union(j_template, {sy = 10, on_whiff = {}, on_hit = all_aerial}))
	States.Nun.JumpAxeKick:setFrames{
		{{sx = 0}, 10},
		{{sx = 1}, 3}, 
		{{sx = 1, hit = 1, hitboxes = {{0, -150, 55, 105}},
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {1, -5}, hitstop = {10, 12}, sfx = "medium", float_length = 10}, 
			{state = "Juggle", velocity = {0, -2}, float_length = 8}
		)}, 2},
		{{sx = 2}, 5},
		{{sx = 3, hit = 2, hitboxes = {{0, -170, 85, 160}, {-10, -30, 100, 45}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Hurt", velocity = {5, -15}, hitstop = {10, 12}, sfx = "fierce", length = 28}, 
			{state = "Juggle", velocity = {7, 20}, float_length = 8}
		)}, 4},
		{{sheet = 1, sx = 0, sy = 4}, 20}
	}
	States.Nun.JumpAxeKick.next_state = States.Nun.Jump
	
	States.Nun.JumpAxeKick.target_momentum = {0, 20}
	
	States.Nun.JumpAxeKick.onStateStart = function(actor)
		if actor.facing * actor.momentum[1] < 0 then
			actor.state.target_momentum[1] = 2
		else
			actor.state.target_momentum[1] = math.min(actor.momentum[1] * actor.facing, 4)
		end
		-- actor.momentum[2] = actor.momentum[2] / 2
	
		if actor.momentum[2] > -5 then actor.momentum[2] = -5 end
	end
	
	States.Nun.JumpAxeKick.onStepStart = function(actor)
		if actor:isGrounded() then
			actor:changeState(States.Nun.LandRecovery)
		end
	end
	
	States.Nun.JumpAxeKick.onStepEnd = function(actor)
		if actor.momentum[2] > 6 and actor.frame < 15 then actor.momentum[2] = 6 end
		if actor.frame == 8 then actor.momentum[2] = -5 end
	end
	
	
	States.Nun.JumpStomp = State:initTemplate("JumpStomp", union(j_template, {sy = 12, rapidfire = true, on_whiff = {}, on_hit = all_aerial}))
	States.Nun.JumpStomp:setFrames{
		{{sx = 0}, 2},
		{{sx = 1, hit = 1, hitboxes = {{-15, -70, 50, 100}}, 
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Hurt", velocity = {1, 0}, hitstop = {12, 9}, length = 16}, 
			{state = "Juggle", velocity = {4, -5}, float_length = 7}
		)}, 16},
		{{sx = 0}, 15}
	}
	
	States.Nun.JumpStomp.target_momentum = {0, 20}
	
	States.Nun.JumpStomp.onStateStart = function(actor)
		if actor.facing * actor.momentum[1] < 0 then
			actor.state.target_momentum[1] = 2
		else
			actor.state.target_momentum[1] = 6
		end
	end
	
	States.Nun.JumpStomp.onStepStart = function(actor)
		if actor:isGrounded() then
			actor:changeState(States.Nun.LandRecovery)
		elseif actor.hits[1] and actor.frame < 18 then
			actor.momentum[2] = -11
			actor.frame = 18
		end
	end
	
	States.Nun.JumpStomp.next_state = States.Nun.Jump
	
	States.Nun.JumpDiveKick = State:initTemplate("JumpDiveKick", union(j_template, {sy = 11, on_whiff = {}, on_hit = {}}))
	
	States.Nun.JumpDiveKick:setFrames{
		{{sx = 0}, 12},
		{{sx = 1, hit = 1, hitboxes = {{-15, -90, 60, 120}},
		hitEffect = AttackEffect:fromHitstuns(
			{state = "Juggle", velocity = {7, -10}, float_length = 7, hitstop = {12, 15}, sfx = "heavy"}, 
			{state = "Juggle", velocity = {7, -5}, float_length = 7}
		)}, 200}
	}
	
	States.Nun.JumpDiveKick.onStateStart = function(actor)
		if actor.facing * actor.momentum[1] < 0 then
			actor.momentum[1] = 2 * actor.facing
		else
			actor.momentum[1] = actor.facing * math.min(actor.facing * actor.momentum[1], 10)
		end
	end
	
	States.Nun.JumpDiveKick.onStepStart = function(actor)
		if actor:isGrounded() then
			actor:changeState(States.Nun.LandRecovery)
		end
	end

	States.Nun.JumpDiveKick.onStepEnd = function(actor)
		if actor.frame < 13 then 
			actor.momentum[2] = math.min(-7, actor.momentum[2])
			actor.momentum[1] = 3*actor.facing
		elseif actor.frame == 13 then actor.momentum[2] = 15 
		else 
			actor.momentum[2] = actor.momentum[2] + 3
			actor.momentum[1] = 10*actor.facing
		end
	end
	
	States.Nun.JumpDiveKick.next_state = States.Nun.Jump
	
end



function APC:parseInputs(inputtable)
	ps = {}
	
	
	lr = inputtable:getLR() * self.facing
	ud = inputtable:getUD()
	
	local buffer = 6
	
	
	
	
	-- check first for attacks.
	for d = 2, 2 + buffer do
		if inputtable[d] ~= nil then
		local udd = inputtable:getUD(d)
		local lrd = inputtable:getLR(d) * self.facing
		if inputtable:pressed("dash", d) and udd == 1 then
			ps[#ps+1] = States.Nun.Roll
		end
		if inputtable:pressed("dash", d) or inputtable:hasInputSequence(Sequence_66, d, 15) then ps[#ps+1] = States.Nun.Dash end
		if inputtable:pressed("sway", d) then ps[#ps+1] = States.Nun.Sway end
		if inputtable:pressed("jump", d) then 		
			ps[#ps+1] = States.Nun.Prejump 
			ps[#ps+1] = States.Nun.JumpStomp
		end
		if inputtable:pressed("heavy", d) then
		
			if inputtable:hasInputSequence(Sequence_QCF, d, 20) then
				ps[#ps+1] = States.Nun.FlyingKnee
			end
		
			if udd == -1 then
				ps[#ps+1] = States.Nun.HopKick
				
			end
			if udd == 1 then 
				ps[#ps+1] = States.Nun.Sweep 
				ps[#ps+1] = States.Nun.JumpDiveKick
			end
			if lrd == 1 then 
				ps[#ps+1] = States.Nun.AxeKick
			end
			if self.state.id == "Dash" and inputtable:isDown("dash") then ps[#ps+1] = States.Nun.SpinKick end
			if self.state.id == "Sway" and inputtable:isDown("sway") then ps[#ps+1] = States.Nun.SpinKick end
			-- ps[#ps+1] = States.Nun.HopKick
			ps[#ps+1] = States.Nun.JumpAxeKick
			ps[#ps+1] = States.Nun.HeelKick
			ps[#ps+1] = States.Nun.FrontKick
			
		end
		if inputtable:pressed("light", d) then
			
			if inputtable:hasInputSequence(Sequence_DP, d, 20) then
				ps[#ps+1] = States.Nun.RisingUpper
			end
			
			if inputtable:hasInputSequence(Sequence_QCF, d, 20) then
				ps[#ps+1] = States.Nun.DeathFist
			end
		
			if udd == -1 then 
				ps[#ps+1] = States.Nun.RightUpper
				-- ps[#ps+1] = States.Nun.JumpElbowDrop
			end
			if udd == 1 then 
				ps[#ps+1] = States.Nun.LeftUpper 
				ps[#ps+1] = States.Nun.JumpElbowDrop
			end
			if lrd == 1 or (self.state.id == "Straight" and self.hits[1] ~= nil) then 		
				ps[#ps+1] = States.Nun.Rekka1
			end
			
			if self.state.id == "Sway" and lrd == 1 then
				ps[#ps+1] = States.Nun.DeathFist
			end
			
			if self.state.id == "Dash" and inputtable:isDown("dash") then ps[#ps+1] = States.Nun.Rekka1 end
			if self.state.id == "Sway" and inputtable:isDown("sway") then ps[#ps+1] = States.Nun.RightUpper end
			ps[#ps+1] = States.Nun.Jab
			ps[#ps+1] = States.Nun.Rekka2
			ps[#ps+1] = States.Nun.Rekka3
			ps[#ps+1] = States.Nun.JumpBackFist
			
			
			-- States.Nun.JumpBackFist
		end
		end
	end
	for d = 2, 2 + buffer do
		if inputtable[d] ~= nil then
		local udd = inputtable:getUD(d)
		local lrd = inputtable:getLR(d) * self.facing
		local ude = inputtable:getUD(d+1)
		-- local lre = inputtable:getLR(d+1)

		if udd == -1 and ude ~= -1 and lr == 0 then ps[#ps+1] = States.Nun.Guard end
		if udd == 1 and ude ~= 1 and lr == 0 then ps[#ps+1] = States.Nun.Duck end
		if lrd == 1 and lr == 1 and not (self.state.id == "Sway" and inputtable:isDown("sway")) then ps[#ps+1] = States.Nun.Walk end
		end
	end
	
	if lr == -1 then
		self.queued_turn = true
	end
	
	return ps
end