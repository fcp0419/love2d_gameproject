function initializeNunStatesCustom() -- everything that can't be edited by editor yet is going here
	
	APC.free_actions = {"Stand", "Duck", "Walk", "Dash", "SwayShort", "SwayLong", "Guard", "Roll", "Prejump", "Jump", "LandRecovery"}
	
	States.Nun.Stand.onStateStart = function(actor)
		actor.forces.momentum:deactivate()
		actor.forces.gravity:deactivate()
		actor:resetChain()
	end
	
	States.Nun.Walk.onStepStart = function(actor)
		if actor.frame == 8 then SFX.step:play() end
	end
	
	States.Nun.Walk.onStepEnd = function(actor)
		if actor.frame == 12 then actor:resetChain() end
		if InputTable:getLR() == actor.facing then 
			if actor.frame == #actor.state.animation.frames then
				return 1
			end
		else
			return 1, States.Nun.Stand
		end
		return false
	end
	
	States.Nun.Crouchdash.onStepEnd = function(actor)
		if actor.frame == 12 then actor:resetChain() end
	end
	
	States.Nun.SwayShort.onStepStart = function(actor)
		if actor.frame == 8 then
			actor.forces.momentum.speed = -10
			actor.forces.momentum.decay = 0.7
			actor.forces.momentum.cutoff = 1
			actor.forces.momentum:activate()
		end
	end
	
	States.Nun.SwayShort.onStepEnd = function(actor)
		-- if actor.frame == 12 then actor:resetChain() end
	end
	
	States.Nun.SwayShort.onStateEnd = function(actor, nextState)
		if actor.frame < 20 then 
			actor.queued_turn = false 
		end
		local nFlags = nextState.animation.default_frame.flags
		if (nextState.id == "RightHookSway") then 
			actor.forces.momentum.speed = 12 + (9 + actor.forces.momentum.speed) * 1.1
			actor.forces.momentum.decay = 0.81
			actor.forces.momentum.cutoff = 2
			actor.forces.momentum:activate()
		elseif (nextState.id == "CrouchdashSlideKick") then
			actor.forces.momentum.speed = 4
			actor.forces.momentum.decay = 0.98
			actor.forces.momentum.cutoff = 1
			actor.forces.momentum:activate()
		elseif (nFlags.normal or nFlags.special) then
			actor.forces.momentum.speed = 4 + (9 + actor.forces.momentum.speed)
			actor.forces.momentum.decay = 0.81
			actor.forces.momentum.cutoff = 1
			actor.forces.momentum:activate()
		else
			actor.forces.momentum.speed = 0
		end
		

	end
	
	States.Nun.SwayLong.onStepStart = function(actor)
		if actor.frame == 9 then
			actor.forces.momentum.speed = -12
			actor.forces.momentum.decay = 0.85
			actor.forces.momentum.cutoff = 1
			actor.forces.momentum:activate()
		end
	end
	
	States.Nun.SwayLong.onStepEnd = function(actor)
		-- if actor.frame == 12 then actor:resetChain() end
	end
	
	States.Nun.SwayLong.onStateEnd = function(actor, nextState)
		if actor.frame < 30 then 
			actor.queued_turn = false 
		end
		local nFlags = nextState.animation.default_frame.flags
		if (nextState.id == "RightHookSway") then 
			actor.forces.momentum.speed = 15 + (10 + actor.forces.momentum.speed) * 1.1
			actor.forces.momentum.decay = 0.81
			actor.forces.momentum.cutoff = 2
			actor.forces.momentum:activate()
		elseif (nextState.id == "CrouchdashSlideKick") then
			actor.forces.momentum.speed = 6
			actor.forces.momentum.decay = 0.98
			actor.forces.momentum.cutoff = 1
			actor.forces.momentum:activate()
		elseif (nFlags.normal or nFlags.special) then
			actor.forces.momentum.speed = 5 + (9 + actor.forces.momentum.speed)
			actor.forces.momentum.decay = 0.81
			actor.forces.momentum.cutoff = 1
			actor.forces.momentum:activate()
		else
			actor.forces.momentum.speed = 0
		end
	end
	
	
	States.Nun.Duck.onStepEnd = function(actor)
		if actor.frame == 12 then
			if InputTable:getUD() == 1 then 
				return 12
			else 
				actor:resetChain()
				return false 
			end
		end
		return false
	end
	
	States.Nun.Guard.onStepEnd = function(actor)
		if actor.frame == 12 then
			if InputTable:getUD() == -1 then 
				return 12
			else 
				actor:resetChain()
				return false 
			end
		end
		return false
	end
	
	States.Nun.Dash.onStepEnd = function(actor)
		if actor.frame == 15 then actor:resetChain() end
	end
	
	States.Nun.Dash.onStateEnd = function(actor, nextState)
		local nFlags = nextState.animation.default_frame.flags
		if nFlags.normal or nFlags.special or nFlags.cmdnormal then
			actor.forces.momentum = ForceMomentum:new()
			actor.forces.momentum.speed = 8
			actor.forces.momentum.decay = 0.8
			actor.forces.momentum.cutoff = 0.5
			actor.forces.momentum:activate()
		end
	end
	
	States.Nun.Prejump.onStateStart = function(actor)
		-- actor.forces.momentum:activate()
	end
	
	States.Nun.Jump.onStateStart = function(actor)
		actor.forces.momentum = ForceMomentum:new()
		actor.forces.momentum.decay = 1
		actor.forces.momentum.cutoff = 0.05
		if actor.previous_state.id == "Dash" then
			actor.forces.momentum.speed = 12
		elseif InputTable:getLR() == actor.facing then
			actor.forces.momentum.speed = 7
		else
			actor.forces.momentum.speed = 0
		end
		
		actor:resetChain()
		actor.forces.momentum:activate()
		
		-- actor.forces.gravity:activate()
		if actor.previous_state.id == "DummyFall" then
			actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(32, 125)}
			actor.forces.gravity:activate({0, 0})
		else
			if not actor.forces.gravity.active then
				actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(32, 125)}
				actor.forces.gravity:activate()
			end
		end
	end
	
	States.Nun.Jump.onStepEnd = function(actor)
		local cGravity = actor.forces.gravity:getCurrent()[2]
		if cGravity < -3 then return 1 
		elseif cGravity > 3 then return 21
		else return 11 end
	end
	
	States.Nun.RightKnee.onStepEnd = function(actor)
		if actor.frame == 14 and actor.hits[1] and (InputTable:getKeyHoldLength("heavy") > 13) then
			return 5, States.Nun.KneeHop
		end
	end
	
	States.Nun.KneeHop.onStateStart = function(actor)
		actor.forces.momentum.decay = 1
	end
	
	States.Nun.KneeHop.onStepStart = function(actor)
		if actor.frame == 5 then
			actor.forces.momentum.cutoff = 0.05
			actor.forces.momentum.speed = math.max(3, actor.forces.momentum.speed)
			actor.forces.momentum:activate()
			actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(18, 45)}
			actor.forces.gravity:activate()
		end
		if actor.frame > 46 then
			actor.forces.momentum.speed = 0
		end
	end
	
	States.Nun.KneeHop.onStateEnd = function(actor, nextState)
		if nextState.animation.default_frame.aerial and actor:getFrame().aerial then
			actor.forces.momentum.cutoff = 0.05
			actor.forces.momentum.decay = 1
			actor.forces.momentum.speed = 5.5
			-- actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(10, 20)}
			-- actor.forces.gravity:activate()
		end
	end
	
	States.Nun.KneeHop.onStepEnd = function(actor)
		if actor.frame > 6 and actor.frame < 47 then
			local cGravity = actor.forces.gravity:getCurrent()[2]
			if actor:isGrounded() and actor.frame > 30 then return 47 end
			if cGravity < -5 then return 10
			elseif cGravity < 0 then return 20
			elseif cGravity < 5 then return 30
			else return 40
			end
		end
	end
	
	States.Nun.KneeHopAssault.onStepEnd = function(actor)
		if actor.frame < 41 then
			local cGravity = actor.forces.gravity:getCurrent()[2]
			if actor:isGrounded() and actor.frame > 30 then return 41 end
			if cGravity < -5 then return 5
			elseif cGravity < 0 then return 15
			elseif cGravity < 5 then return 25
			else return 35
			end
		end
	end
	
	
	
	States.Nun.LeftJolt.onStepEnd = function(actor)
		if actor.frame > 1 and actor.frame < 7 and actor:checkHitbox({0, -100, 80, 60}) then
			return 7
		elseif (actor.frame == 8) and actor.hits[1] and (InputTable:getKeyHoldLength("light") > 7) then
			return 1, States.Nun.RightStraight
		end
	end
	
	States.Nun.LeftUpper.onStepEnd = function(actor)
		if (actor.frame == 10 and actor.hits[1]) and (InputTable:getKeyHoldLength("light") > 10) then
			return 1, States.Nun.ShoulderTackle
		end
	end
	
	States.Nun.ShoulderTackle.onStepEnd = function(actor)
		if actor.frame > 9 and actor.frame < 13 and actor:checkHitbox({-15, -140, 75, 140}) then
			return 13
		end
	end
	
	States.Nun.Sweep.onStepEnd = function(actor)
		if ((actor.frame > 8 and actor.frame < 21) and actor.hits[1]) and (InputTable:getKeyHoldLength("heavy") > actor.frame) then
			return 1, States.Nun.SweepSlideKick
		end
	end
	
	States.Nun.RightHookSway.onStepEnd = function(actor)
		if (actor.frame == 13 and actor.hits[1]) and (InputTable:getKeyHoldLength("light") > 13) then
			return 1, States.Nun.LeftDownpunch
		end
	end
	
	States.Nun.RightHookSway.onStepEnd = function(actor)
		if (actor.frame == 13 and actor.hits[1]) and (InputTable:getKeyHoldLength("light") > 13) then
			return 1, States.Nun.LeftDownpunch
		end
	end
	
	States.Nun.FrontKick.onStepEnd = function(actor)
		if actor.frame == 9 and InputTable:getKeyHoldLength("heavy") > 9 then
			return 1, States.Nun.FrontKickCharged
		end
	end
	
	States.Nun.SplitKickHop.onStateStart = function(actor)
		actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(20, 40)}
		actor.forces.gravity:activate({0, -4})
		actor.forces.momentum.decay = 0.5
	end
	
	States.Nun.DoubleUpkicks.onStepStart = function(actor)
		if actor.frame == 7 then
			actor.forces.momentum.decay = 1
			actor.forces.momentum.speed = 8
			actor.forces.momentum.cutoff = 0.05
			actor.forces.momentum:activate()
			-- actor.forces.gravity = ForceGravity:new({parabola = fromTimeAndHeight(30, 80)})
			-- actor.forces.gravity:activate()
		end
		if actor.frame == 25 then
			actor.forces.momentum.decay = 0.96
			actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(30, 105)}
			actor.forces.gravity:activate({0, 0})
		end		
	end
	
	States.Nun.DoubleUpkicks.onStepEnd = function(actor)
		if actor.frame > 35 then
			if actor:isGrounded() then return 1, States.Nun.LandRecovery end
			return 36 
		end
	end
	
	
	States.Nun.DashLeftJolt.onStateStart = function(actor)
		actor.forces.momentum.speed = 20
		actor.forces.momentum.decay = 0.8
	end
	
	States.Nun.DashHeelKick.onStateStart = function(actor)
		actor.forces.momentum.speed = 15
		actor.forces.momentum.decay = 0.75
	end
	
	States.Nun.DashLeftJolt.onStepEnd = function(actor)
		if actor.frame > 7 and actor.frame < 15 then 
			if	actor.hits[1] and InputTable:getKeyHoldLength("light") > 7 then
				return 1, States.Nun.DashRightStraight
			end
		end
	end
	
	States.Nun.DashRightStraight.onStateStart = function(actor)
		actor.chain[#actor.chain + 1] = "RightStraight"
		actor.forces.momentum.decay = 0.5
	end
	
	States.Nun.AssaultJump.onStateStart = function(actor)
		actor.forces.momentum = ForceMomentum:new()
		actor.forces.momentum.decay = 1
		actor.forces.momentum.cutoff = 2
		actor.forces.momentum.speed = 11.5
		
		actor:resetChain()
		actor.forces.momentum:activate()
		actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(30, 70)}
		actor.forces.gravity:activate()

	end
	
	States.Nun.AssaultJump.onStepStart = function(actor)
		if actor.frame >= 31 then
			actor.forces.momentum.decay = 0.85
		elseif actor.frame >= 21 then
			actor.forces.momentum.decay = 0.96
		elseif actor.frame >= 11 then
			actor.forces.momentum.decay = 0.97
		end
	end
	
	States.Nun.AssaultJump.onStepEnd = function(actor)
		if actor.frame < 31 then
			local cGravity = actor.forces.gravity:getCurrent()[2]
			if (cGravity > 0 and actor:isGrounded()) then return 31
			elseif cGravity < -4 then return 1 
			elseif cGravity > 0 then return 21
			else return 11 end
		end
	end
	
	
	States.Nun.JumpHop.onStateStart = function(actor)
		actor.forces.momentum = ForceMomentum:new()
		actor.forces.momentum.decay = 1
		actor.forces.momentum.cutoff = 0.05
		if actor.previous_state.id == "Dash" then
			actor.forces.momentum.speed = 12
		elseif InputTable:getLR() == actor.facing then
			actor.forces.momentum.speed = 7
		else
			actor.forces.momentum.speed = 0
		end
		
		actor:resetChain()
		actor.forces.momentum:activate()
		actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(25, 90)}
		-- actor.forces.gravity:activate()
		if actor.previous_state.id == "DummyFall" then
			actor.forces.gravity:activate({0, 0})
		else
			actor.forces.gravity:activate()
		end
	end
	
	
	States.Nun.JumpHop.onStepEnd = function(actor)
		local cGravity = actor.forces.gravity:getCurrent()[2]
		if cGravity < -3 then return 1 
		elseif cGravity > 3 then return 21
		else return 11 end
	end
	
	States.Nun.SuperJump.onStateStart = function(actor)
		actor.forces.momentum = ForceMomentum:new()
		actor.forces.momentum.decay = 1
		actor.forces.momentum.cutoff = 0.05
		if actor.previous_state.id == "Dash" then
			actor.forces.momentum.speed = 12
		elseif InputTable:getLR() == actor.facing then
			actor.forces.momentum.speed = 8
		else
			actor.forces.momentum.speed = 0
		end
		
		actor:resetChain()
		actor.forces.momentum:deactivate()
		actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(42, 180)}
		-- actor.forces.gravity:activate()
		-- actor.forces.gravity:activate({0, 0})
		-- actor.forces.gravity:activate()
	end
	
	States.Nun.SuperJump.onStepStart = function(actor)
		if actor.frame == 4 then 
			actor.forces.momentum:activate()
			actor.forces.gravity:activate()
		end
	end
	
	States.Nun.SuperJump.onStepEnd = function(actor)
		if actor.frame > 3 then
			if actor.frame > 25 and actor:isGrounded() then
				return 1, States.Nun.Stand
			end			
			local cGravity = actor.forces.gravity:getCurrent()[2]
			if cGravity < -3 then return 10 
			elseif cGravity > 3 then return 30
			else return 20 end
		else
			if InputTable:getUD() ~= -1 then
				return 1, States.Nun.Jump
				-- carry over jump momentum here
			end
		end
	end
	
	States.Nun.KneeRevolver.onStepStart = function(actor)
		if actor.frame == 7 then
			actor.forces.momentum = ForceMomentum:new()
			actor.forces.momentum.speed = 14
			actor.forces.momentum.decay = 0.975
			actor.forces.momentum.cutoff = 2
			actor.forces.momentum:activate()
			actor.forces.gravity = ForceGravity:new()
			actor.forces.gravity.parabola = Parabola:fromTimeAndHeight(25, 60)
			actor.forces.gravity:activate()
		elseif actor.frame == 37 then
			actor.forces.gravity:deactivate()
			actor.forces.momentum:deactivate()
		end
		
	end
	
	States.Nun.KneeRevolver.onStepEnd = function(actor)
		if (actor.frame == 9 and actor.hits[1] and (InputTable:getKeyHoldLength("heavy") < 9)) then
			return 1, States.Nun.KneeRevolverFall
		elseif (actor.frame > 26 and actor.frame < 37) then
			if actor:isGrounded() then
				return 37
			else
				return 30
			end
		end
	
	end
	
	States.Nun.KneeRevolverFall.onStateStart = function(actor)
		actor.forces.momentum.speed = 8
		actor.forces.momentum.decay = 0.99
		actor.forces.gravity:activate({0, -6})
	end
	
	States.Nun.KneeRevolverFall.onStepStart = function(actor)
		if actor:isGrounded() then actor.forces.momentum.speed = 0 end
	end
	
	States.Nun.KneeRevolverFall.onStepEnd = function(actor)
		if actor.frame < 21 then
			local cGravity = actor.forces.gravity:getCurrent()[2]
			if (cGravity > 0 and actor:isGrounded()) then return 21
			elseif cGravity < 0 then return 1 
			else return 11 end
		end
	end
	
	
	States.Nun.RisingUpper.onStepStart = function(actor)
		if actor.frame == 5 then
			actor.forces.momentum = ForceMomentum:new()
			actor.forces.momentum.speed = 5
			actor.forces.momentum.decay = 0.98
			actor.forces.momentum.cutoff = 0.1
			actor.forces.momentum:activate()
			actor.forces.gravity = ForceGravity:new()
			actor.forces.gravity.parabola = Parabola:fromTimeAndHeight(25, 85)
			actor.forces.gravity:activate()
		end
	end
	
	States.Nun.RisingUpper.onStepEnd = function(actor)
		if actor.frame > 4 and actor.frame < 74 then
			local cGravity = actor.forces.gravity:getCurrent()[2]
			if actor:isGrounded() and actor.frame > 50 then return 75 end
			-- print(cGravity, actor.frame)
		
			if cGravity < -6 then
				return 10 
			elseif cGravity < -1 then
				return 20 
			elseif cGravity < 0 then
				return 30 
			elseif cGravity < 2 then
				return 40 
			elseif cGravity < 3 then
				return 50 
			elseif cGravity < 6 then
				return 60 
			else
				return 70 
			end			
		end
	end
	
	States.Nun.JumpAxeKick.onStepStart = function(actor)
		if actor.frame == 1 then
			actor.forces.gravity:deactivate()
			actor.forces.momentum.decay = 0.85
		end
		if actor.frame == 5 then
			actor.forces.momentum.speed = 0
			actor.forces.momentum.decay = 0.94
			actor.forces.gravity:activate({0, -11})
		end
		if actor.frame >= 5 and actor.frame <= 7 then
			actor.forces.momentum.speed = actor.forces.momentum.speed + 4
		end
		if actor.frame == 17 then
			actor.forces.gravity:activate({0, 0})
			-- actor.forces.momentum.decay = 0.94
			-- actor.forces.momentum.speed = 6
		end
		if actor.frame == 22 then
			-- actor.forces.gravity.i = 20
			
		end
	end
	
	States.Nun.JumpAxeKick.onStateEnd = function(actor)
		if not actor.forces.gravity.active then
			actor.forces.gravity:activate({0, 0})
		end
	end
	
	

	States.Nun.EscapeJump.onStepStart = function(actor)
		if actor.frame == 7 then
			if (InputTable:getLR() * actor.facing) == 1 then
				actor.facing = actor.facing * -1
			end
			actor.forces.momentum = ForceMomentum:new()
			actor.forces.momentum.speed = -8
			actor.forces.momentum.decay = 0.995
			actor.forces.momentum.cutoff = 0.1
			actor.forces.momentum:activate()
			actor.forces.gravity = ForceGravity:new()
			actor.forces.gravity.parabola = Parabola:fromTimeAndHeight(30, 145)
			actor.forces.gravity:activate()
		end
	end
	
	States.Nun.EscapeJump.onStepEnd = function(actor)
		if actor.frame > 6 and actor.frame < 87 then
			if actor:isGrounded() and actor.frame > 60 then 
				actor.forces.momentum.decay = 0.5
				return 87 
			end
			local cGravity = actor.forces.gravity:getCurrent()[2]
			
			if cGravity < -10 then
				return 10 
			elseif cGravity < -5 then
				return 20 
			elseif cGravity < -2 then
				return 30 
			elseif cGravity < 0 then
				return 40 
			elseif cGravity < 2 then
				return 50 
			elseif cGravity < 4 then
				return 60 
			elseif cGravity < 7 then
				return 70 
			else
				return 80 
			end		
		elseif actor.frame < 5 then
			if InputTable:getUD() ~= -1 then
				return 1, States.Nun.SwayShort
			end
		end
	end
	

	
	
	States.Nun.HeelKick.onStepEnd = function(actor)
		if actor.frame == 14 and InputTable:getKeyHoldLength("heavy") > 11 then
			return 1, States.Nun.HeelKickCharged
		end
	end
	
	States.Nun.DashHeelKick.onStepEnd = function(actor)
		if actor.frame == 12 and InputTable:getKeyHoldLength("heavy") > 11 then
			return 1, States.Nun.HeelKickCharged
		end
	end
	
	States.Nun.HeelKickCharged.onStepEnd = function(actor)
		-- if actor.frame < 5 and InputTable:getKeyHoldLength("heavy") == 0 then
			-- return 15, States.Nun.HeelKick
		-- end
	end
	
	States.Nun.AxeKick.onStepEnd = function(actor)
		if actor.frame == 11 and InputTable:getKeyHoldLength("heavy") > 10 and Interface.animEditActive == false then
			return 1, States.Nun.AxeKickCharged
		end
	
	end
	
	States.Nun.AxeKickCharged.onStepStart = function(actor)
		if actor.frame < 7 and InputTable:getKeyHoldLength("heavy") == 0 and Interface.animEditActive == false then
			return 14, States.Nun.AxeKick
		end
	end
	
	States.Nun.JumpLeftRightPunches.onStepEnd = function(actor)
		if actor.frame < 11 and actor.hits[1] then
			return 11
		end
	end
	
	States.Nun.JumpFlyingKick.onStepEnd = function(actor)
		if (actor.frame == 13 and InputTable:getKeyHoldLength("heavy") > 13) or (actor.hits[1] and actor.frame > 7 and InputTable:getKeyHoldLength("heavy") > 7) then
			return 1, States.Nun.JumpHeelKick
		end
	end
	
	States.Nun.JumpHeelKick.onStateStart = function(actor)
		-- actor.forces.momentum.speed = 11
		-- actor.forces.momentum.decay = 0.98
		-- actor.forces.momentum.cutoff = 0.5
		-- actor.forces.momentum:activate()
		
		-- actor.forces.gravity = ForceGravity:new{parabola = Parabola:fromTimeAndHeight(20, 40)}
		-- actor.forces.gravity:activate()
	end
	
	States.Nun.JumpHeelKick.onStepStart = function(actor)
		-- if actor.frame == 9 then
			-- actor.forces.momentum.decay = 0.91
		-- end
	end
	
	States.Nun.JumpDiveKick.onStateStart = function(actor)
		actor.forces.momentum.decay = 0.5
		actor.forces.gravity:deactivate()
	end
	
	States.Nun.JumpDiveKick.onStepEnd = function(actor)
		actor.queued_turn = false
		if actor.frame == 10 and InputTable:getKeyHoldLength("heavy") > 9 and Interface.animEditActive == false then
			local lr = (InputTable:getLR() * actor.facing)
			if lr == -1 then return 4, States.Nun.JumpDiveKickCharge1 end
			if lr == 0 then return 4, States.Nun.JumpDiveKickCharge2 end
			if lr == 1 then return 4, States.Nun.JumpDiveKickCharge3 end
		elseif actor.frame > 11 then
			return 15
		end
	end
	
	
	
	States.Nun.JumpDiveKickCharge1.onStepEnd = function(actor)
		if actor.frame < 4 and InputTable:getKeyHoldLength("heavy") == 0 then
			return 15, States.Nun.JumpDiveKick
		end
		if actor.frame < 11 then
			local lr = InputTable:getLR() * actor.facing
			if lr == -1 then return actor.frame + 1, States.Nun.JumpDiveKickCharge1 end
			if lr == 0 then return actor.frame + 1, States.Nun.JumpDiveKickCharge2 end
			if lr == 1 then return actor.frame + 1, States.Nun.JumpDiveKickCharge3 end
		end
	end
	
	States.Nun.JumpDiveKickCharge2.onStepEnd = function(actor)
		if actor.frame < 4 and InputTable:getKeyHoldLength("heavy") == 0 then
			return 15, States.Nun.JumpDiveKick
		end
		if actor.frame < 11 then
			local lr = InputTable:getLR() * actor.facing
			if lr == -1 then return actor.frame + 1, States.Nun.JumpDiveKickCharge1 end
			if lr == 0 then return actor.frame + 1, States.Nun.JumpDiveKickCharge2 end
			if lr == 1 then return actor.frame + 1, States.Nun.JumpDiveKickCharge3 end
		end
	end
	
	States.Nun.JumpDiveKickCharge3.onStepEnd = function(actor)
		if actor.frame < 4 and InputTable:getKeyHoldLength("heavy") == 0 then
			return 15, States.Nun.JumpDiveKick
		end
		if actor.frame < 11 then
			local lr = InputTable:getLR() * actor.facing
			if lr == -1 then return actor.frame + 1, States.Nun.JumpDiveKickCharge1 end
			if lr == 0 then return actor.frame + 1, States.Nun.JumpDiveKickCharge2 end
			if lr == 1 then return actor.frame + 1, States.Nun.JumpDiveKickCharge3 end
		end
	end
	
	States.Nun.LandRecovery.onStateStart = function(actor)
		--actor.momentum[1] = 0
		print("Started land rec")
		actor.forces.momentum:deactivate()
		actor.forces.gravity:deactivate()
		actor:resetChain()
	end

	
end



-- new states: LeftJolt, RightKidney, LeftSwing, LeftHook, RightHook, LeftKidney, DoubleUpkick, KneeHop, SplitKickHop, ShoulderTackle, RightUpperTall, RightUpperShort
-- obsolete states: JumpStomp, JumpElbowDrop, RisingUpper, FlyingKnee, HopKick, Rekka1/2/3, Jab
-- rename: Straight to RightStraight

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
		if inputtable:pressed("dash", d) then
			if udd == 1 then 
				ps[#ps+1] = States.Nun.Crouchdash
			elseif udd == -1 then 
				ps[#ps+1] = States.Nun.AssaultJump
			end
			ps[#ps+1] = States.Nun.Dash 
		end

		if inputtable:pressed("sway", d) then 
			if udd == -1 then
				ps[#ps+1] = States.Nun.EscapeJump
			elseif udd == 1 then
				ps[#ps+1] = States.Nun.SwayLong 
			end
			ps[#ps+1] = States.Nun.SwayShort 
		end
		
		
		
		if inputtable:pressed("jump", d) then 
			if udd == -1 then
				ps[#ps+1] = States.Nun.SuperJump
			elseif udd == 1 then
				ps[#ps+1] = States.Nun.JumpHop
			end
			ps[#ps+1] = States.Nun.Jump 
			-- ps[#ps+1] = States.Nun.JumpStomp
		end
		if inputtable:pressed("heavy", d) then
		
			if inputtable:hasInputSequence(Sequence_DP, d, 20) then
				ps[#ps+1] = States.Nun.DoubleUpkicks
			end
		
			if inputtable:hasInputSequence(Sequence_QCF, d, 20) then
				ps[#ps+1] = States.Nun.KneeRevolver
			end
		
			if udd == -1 then
				ps[#ps+1] = States.Nun.RightKnee
				ps[#ps+1] = States.Nun.JumpAxeKick
			end
			if udd == 1 then 
				if self.state.id == "Crouchdash" then
					ps[#ps+1] = States.Nun.CrouchdashSlideKick
				end
				ps[#ps+1] = States.Nun.Sweep 
				ps[#ps+1] = States.Nun.JumpDiveKick
			end
			if lrd == 1 and self.hits[1] then 
				-- ps[#ps+1] = States.Nun.AxeKick
				ps[#ps+1] = States.Nun.HeelKick
			end
			
			
			if self.state.id == "Dash" and inputtable:isDown("dash") then ps[#ps+1] = States.Nun.DashHeelKick end
			if (self.state.id == "SwayShort" or self.state.id == "SwayLong") and inputtable:isDown("sway") then ps[#ps+1] = States.Nun.CrouchdashSlideKick end
			-- ps[#ps+1] = States.Nun.HopKick
			if self.state.id == "FrontKick" then 
				ps[#ps+1] = States.Nun.HeelKick
			end
			ps[#ps+1] = States.Nun.JumpFlyingKick
			ps[#ps+1] = States.Nun.JumpHeelKick	
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
				ps[#ps+1] = States.Nun.LeftDownpunch
				ps[#ps+1] = States.Nun.RightHookStand
				ps[#ps+1] = States.Nun.JumpPowerPunch
			end
			if udd == 1 then 
				if self.state.id == "Crouchdash" then
					ps[#ps+1] = States.Nun.CrouchdashShoulderTackle	
				end
				if self.state.id == "RightHookCrouch" then
					ps[#ps+1] = States.Nun.LeftSwing
				end
				
				ps[#ps+1] = States.Nun.LeftUpper
				ps[#ps+1] = States.Nun.ShoulderTackle
				ps[#ps+1] = States.Nun.JumpHammerFist
			end
			if lrd == 1 and self.hits[1] then 		
				ps[#ps+1] = States.Nun.RightUpper
			end
			
			if self.state.id == "Sway" and lrd == 1 then
				ps[#ps+1] = States.Nun.DeathFist
			end
			
			if self.state.id == "Dash" and inputtable:isDown("dash") then ps[#ps+1] = States.Nun.DashLeftJolt end
			if (self.state.id == "SwayShort" or self.state.id == "SwayLong") and inputtable:isDown("sway") then ps[#ps+1] = States.Nun.RightHookSway end
			
			ps[#ps+1] = States.Nun.LeftDownpunch
			if self.state.id == "RightStraight" or self.state.id == "DashRightStraight" then
				ps[#ps+1] = States.Nun.LeftSwing
			end
			ps[#ps+1] = States.Nun.DashRightStraight
			ps[#ps+1] = States.Nun.RightStraight
			ps[#ps+1] = States.Nun.LeftJolt		
			ps[#ps+1] = States.Nun.JumpLeftRightPunches
		end
		end
	end
	
	if self.state.id == "AssaultJump" then
		if inputtable:pressed("heavy", d) then ps[#ps+1] = States.Nun.KneeHopAssault end
		if inputtable:pressed("light", d) then ps[#ps+1] = States.Nun.JumpHammerFist end
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
	
	if lr == -1 and not (self:getFrame().aerial) then
		self.queued_turn = true
	end
	
	return ps
end