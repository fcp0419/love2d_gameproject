function initializeNunStates()
	States.Nun = {}

	States.Nun.Stand = State:initTemplate("Stand", {sx = 0, sy = 0, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {"Walk", _flags = {normal = true, stance = true, special = true, movement = true}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.Stand:setFrames{
		{{}, 1},
	}
	States.Nun.Stand:setMovements{
	}
	

	States.Nun.Duck = State:initTemplate("Duck", {sx = 0, sy = 0, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -45, 70, 45}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = true, stance = true, special = true, movement = true}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {movement = true}})
	States.Nun.Duck:setFrames{
		{{sy = 2, ox = 8}, 15},
	}
	States.Nun.Duck:setMovements{
	}
	

	States.Nun.Guard = State:initTemplate("Guard", {sx = 0, sy = 0, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {"Walk", _flags = {normal = true, stance = true, special = true, movement = true}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {movement = true}})
	States.Nun.Guard:setFrames{
		{{sy = 3}, 1},
		{{sx = 1, sy = 3}, 2},
		{{sx = 2, sy = 3}, 12},
	}
	States.Nun.Guard:setMovements{
	}
	

	States.Nun.Walk = State:initTemplate("Walk", {sx = 0, sy = 7, ox = 16, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = true, stance = true, special = true, movement = true}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.Walk:setFrames{
		{{sx = 3}, 10},
		{{}, 7},
		{{sx = 1}, 10},
		{{sx = 2}, 7},
	}
	States.Nun.Walk:setMovements{
		{{7.5, 0}, 34, 1},
	}
	

	States.Nun.Dash = State:initTemplate("Dash", {sx = 0, sy = 1, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = true, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {stance = true}})
	States.Nun.Dash:setFrames{
		{{}, 2},
		{{sx = 1}, 2},
		{{sx = 2, on_whiff = {"DashLeftJolt", "DashHeelKick", _flags = {normal = false, stance = true, special = true, movement = false}}}, 10},
		{{sx = 3, on_whiff = {_flags = {normal = true, stance = true, special = true, movement = true}}}, 2},
		{{sx = 4, on_whiff = {_flags = {normal = true, stance = true, special = true, movement = true}}}, 2},
		{{sx = 5, on_whiff = {_flags = {normal = true, stance = true, special = true, movement = true}}}, 2},
	}
	States.Nun.Dash:setMovements{
		{{8, 0}, 2, 3},
		{{16, 0}, 12, 5},
		{{6, 0}, 2, 17},
	}
	

	States.Nun.SwayShort = State:initTemplate("SwayShort", {sx = 0, sy = 0, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-40, -93, 30, 93}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = true, special = true, movement = true}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {stance = true}})
	States.Nun.SwayShort:setFrames{
		{{sy = 3, oy = -1, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}}, 8},
		{{sx = 1, oy = -4, sy = 3, on_whiff = {"RightHookSway", "CrouchdashSlideKick", _flags = {normal = false, stance = false, special = false, movement = false}}}, 4},
		{{sx = 2, oy = -4, sy = 3, on_whiff = {"Microdash", _flags = {normal = true, stance = true, special = true, movement = false}}}, 12},
	}
	States.Nun.SwayShort:setMovements{
		{{-20, 0}, 1, 1},
		{{-12, 0}, 7, 2},
		{{0, 0}, 4, 9},
	}
	

	States.Nun.SwayLong = State:initTemplate("SwayLong", {sx = 0, sy = 0, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-40, -93, 30, 93}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = true, special = true, movement = true}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {stance = true}})
	States.Nun.SwayLong:setFrames{
		{{sy = 3, oy = -1, ox = -5, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, actor_collision = false}, 12},
		{{sx = 1, oy = -4, sy = 3, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, actor_collision = false}, 4},
		{{sx = 2, oy = -4, sy = 3, on_whiff = {_flags = {normal = true, stance = true, special = true, movement = false}}}, 14},
	}
	States.Nun.SwayLong:setMovements{
		{{-30, 0}, 1, 1},
		{{-12, 0}, 11, 2},
		{{0, 0}, 4, 13},
	}
	

	States.Nun.Crouchdash = State:initTemplate("Crouchdash", {sx = 0, sy = 6, ox = 0, oy = -4, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -45, 70, 45}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {"CrouchdashShoulderTackle", "CrouchdashSlideKick", _flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = false, flags = {stance = true}})
	States.Nun.Crouchdash:setFrames{
		{{actor_collision = true, on_whiff = {}}, 5},
		{{sx = 1, actor_collision = true}, 3},
		{{sx = 2}, 3},
		{{sx = 3}, 3},
		{{sx = 2}, 3},
		{{sx = 3}, 3},
		{{sx = 2}, 3},
		{{sx = 3}, 3},
		{{sx = 11, ox = -10, actor_collision = true, on_whiff = {}}, 5},
	}
	States.Nun.Crouchdash:setMovements{
		{{0, 0}, 1, 1},
		{{0, 0}, 1, 2},
		{{35, 0}, 1, 9},
		{{15, 0}, 14, 10},
		{{7, 0}, 3, 25},
		{{4, 0}, 3, 28},
	}
	

	States.Nun.LeftJolt = State:initTemplate("LeftJolt", {sx = 0, sy = 8, ox = 0, oy = -3, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {"RightStraight", _flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.LeftJolt:setFrames{
		{{sx = 5}, 1},
		{{sx = 7, ox = -6, oy = 2}, 5},
		{{sx = 9, oy = -6, ox = -8, hit = 1, attacklevel = 1, hitboxes = {{20, -90, 65, 40}}}, 2},
		{{sx = 10, oy = -5, ox = -4}, 8},
		{{sx = 11, oy = -5, ox = -4}, 4},
		{{sx = 12, ox = -4}, 2},
		{{sx = 13}, 2},
	}
	States.Nun.LeftJolt:setMovements{
		{{0, 0}, 1, 1},
		{{14, 0}, 5, 2},
		{{4, 0}, 1, 7},
		{{0, 0}, 1, 8},
	}
	

	States.Nun.RightStraight = State:initTemplate("RightStraight", {sx = 0, sy = 8, ox = -20, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {"LeftSwing", _flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.RightStraight:setFrames{
		{{}, 1},
		{{sx = 1, oy = -2}, 1},
		{{sx = 2, oy = -4, ox = -25, hit = 1, attacklevel = 1, hitboxes = {{0, -110, 100, 60}}}, 5},
		{{sx = 3, oy = -6, ox = -25}, 5},
		{{sx = 4, oy = -5, ox = -5}, 3},
	}
	States.Nun.RightStraight:setMovements{
	}
	

	States.Nun.LeftSwing = State:initTemplate("LeftSwing", {sx = 0, sy = 9, ox = 0, oy = -5, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.LeftSwing:setFrames{
		{{sx = 6, ox = -25}, 2},
		{{sx = 7, ox = -25}, 3},
		{{sx = 8, hit = 1, attacklevel = 3, hitboxes = {{10, -130, 90, 130}}, hitEffect = {hsGround = {pushback = 9, parabola = {pHeight = 45, pTime = 18}, forceState = "JuggleFloat"}, hsAir = {pushback = 9, forceState = "JuggleFloat", parabola = {pHeight = 38, pTime = 18}}}}, 2},
		{{sx = 9}, 2},
		{{sx = 10}, 2},
		{{sx = 11}, 6},
		{{sx = 12}, 3},
		{{sx = 13}, 3},
		{{sx = 14}, 3},
	}
	States.Nun.LeftSwing:setMovements{
		{{4, 0}, 1, 3},
		{{0, 0}, 1, 4},
		{{5, 0}, 1, 5},
		{{7, 0}, 1, 6},
		{{0, 0}, 5, 8},
	}
	

	States.Nun.RightHookStand = State:initTemplate("RightHookStand", {sx = 0, sy = 10, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {"LeftDownpunch", _flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.RightHookStand:setFrames{
		{{sx = 3, sy = 3}, 4},
		{{sx = 8}, 1},
		{{sx = 9, ox = -16}, 1},
		{{sx = 10, ox = -21, hit = 1, attacklevel = 2, hitboxes = {{20, -110, 96, 110}}, hitEffect = {hsGround = {forceState = "HitstunLow"}, hsAir = {pushback = 4, parabola = {pTime = 13, pHeight = 20}}}}, 4},
		{{sx = 11, ox = -24}, 8},
		{{sx = 12, ox = -17}, 3},
	}
	States.Nun.RightHookStand:setMovements{
		-- {{0, 0}, 3, 3},
		-- {{24, 0}, 1, 6},
		-- {{0, 0}, 2, 7},
	}
	

	States.Nun.RightHookCrouch = State:initTemplate("RightHookCrouch", {sx = 0, sy = 10, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {"LeftSwing", _flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.RightHookCrouch:setFrames{
		{{sx = 8}, 2},
		{{sx = 9}, 4},
		{{sx = 10, ox = -8, hit = 1, hitboxes = {{10, -110, 80, 110}}, hitEffect = {hsGround = {forceState = "HitstunLow"}, hsAir = {pushback = 4, parabola = {pTime = 13, pHeight = 20}}}}, 6},
		{{sx = 11}, 5},
		{{sx = 12}, 4},
	}
	States.Nun.RightHookCrouch:setMovements{
		{{0, 0}, 4, 3},
		{{11, 0}, 1, 7},
		{{0, 0}, 2, 8},
	}
	

	States.Nun.RightHookSway = State:initTemplate("RightHookSway", {sx = 0, sy = 10, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.RightHookSway:setFrames{
		{{sy = 13, ox = 24, oy = -2}, 2},
		-- {{sx = 3, sy = 3, ox = 16}, 2},
		{{sx = 8, ox = 0, oy = -8}, 2},
		{{sx = 9, ox = -2, oy = -6}, 2},
		{{sx = 10, ox = -10, oy = -3, hit = 1, attacklevel = 2, hitboxes = {{10, -110, 80, 110}}, hitEffect = {hsGround = {forceState = "HitstunLow"}, hsAir = {pushback = 4, parabola = {pTime = 13, pHeight = 20}}}}, 6},
		{{sx = 11, ox = -10}, 8},
		{{sx = 12, ox = -10}, 3},
	}
	States.Nun.RightHookSway:setMovements{
		{{20, 0}, 4, 3},
		{{0, 0}, 1, 8},
	}
	

	States.Nun.LeftDownpunch = State:initTemplate("LeftDownpunch", {sx = 0, sy = 13, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.LeftDownpunch:setFrames{
		{{sx = 1}, 1},
		{{sx = 2}, 1},
		{{sx = 3}, 1},
		{{sx = 4, oy = -4, hit = 1, attacklevel = 4, hitboxes = {{15, -140, 75, 140}}, hitEffect = {hsGround = {pushback = 2}, hsAir = {pushback = 2, forceState = "JuggleFloat", speedY = 30}}}, 3},
		{{sx = 5, oy = -3}, 8},
		{{sx = 6}, 4},
		{{sx = 7}, 4},
	}
	States.Nun.LeftDownpunch:setMovements{
		{{12, 0}, 3, 1},
		{{18, 0}, 1, 4},
	}
	

	States.Nun.LeftUpper = State:initTemplate("LeftUpper", {sx = 0, sy = 11, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -45, 70, 45}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {"ShoulderTackle", _flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.LeftUpper:setFrames{
		{{sy = 13}, 3},
		{{ox = -10}, 1},
		{{sx = 2, ox = -10, hit = 1, attacklevel = 3, hitboxes = {{-5, -100, 60, 100}}, hitEffect = {hsGround = {pushback = 3, forceState = "JuggleFloat", parabola = {pTime = 21, pHeight = 75}}, hsAir = {pushback = 2.5, parabola = {pTime = 18, pHeight = 70}}}}, 1},
		{{sx = 3, ox = -10, hit = 1, attacklevel = 3, hitboxes = {{5, -135, 65, 80}}, hitEffect = {hsAir = {pushback = 2.5, parabola = {pTime = 18, pHeight = 60}}}}, 5},
		{{sx = 4, ox = -13}, 6},
		{{sx = 5}, 6},
	}
	States.Nun.LeftUpper:setMovements{
		{{15, 0}, 1, 4},
		{{0, 0}, 1, 5},
	}
	

	States.Nun.ShoulderTackle = State:initTemplate("ShoulderTackle", {sx = 0, sy = 11, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.ShoulderTackle:setFrames{
		{{sx = 6}, 1},
		{{sx = 7, ox = 5, oy = -1}, 1},
		{{sx = 8, ox = 18, oy = -3}, 2},
		{{sx = 9, ox = 24, oy = -4}, 5},
		{{sx = 10, ox = 40, oy = -15}, 4},
		{{sx = 11, hit = 1, attacklevel = 3, hitboxes = {{-15, -140, 75, 140}}, hitEffect = {hsGround = {pushback = 8, forceState = "JuggleTumble"}, hsAir = {pushback = 9, parabola = {pTime = 12, pHeight = 15}}}}, 7},
		{{sx = 12, ox = -7, oy = -2}, 5},
		{{sx = 13, ox = -10}, 10},
		{{sx = 14}, 4},
	}
	States.Nun.ShoulderTackle:setMovements{
		{{0, 0}, 9, 1},
		{{25, 0}, 4, 10},
		{{30, 0}, 1, 14},
		{{12, 0}, 1, 15},
		{{3, 0}, 5, 16},
		{{0, 0}, 4, 21},
	}
	

	States.Nun.RightUpper = State:initTemplate("RightUpper", {sx = 0, sy = 12, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = true, movement = false}}, hitEffect = {}, actor_collision = true, flags = {special = true}})
	States.Nun.RightUpper:setFrames{
		{{ox = 24}, 1},
		{{sx = 1, ox = 24}, 4},
		{{sx = 2}, 1},
		{{sx = 3}, 1},
		{{sx = 4}, 1},
		{{sx = 5, ox = 15}, 1},
		{{sx = 6, ox = 15, hit = 1, attacklevel = 4, hitboxes = {{5, -150, 75, 150}}, hitEffect = {hsGround = {pushback = 4, forceState = "JuggleLaunch", parabola = {pHeight = 160, pTime = 34}}, hsAir = {pushback = 3, parabola = {pHeight = 40, pTime = 15}, forceState = "JuggleFloat"}}}, 3},
		{{sx = 6, ox = 15}, 5},
		{{sx = 7, ox = 15}, 4},
		{{sx = 8, ox = 15}, 3},
		{{sx = 9, ox = 20}, 5},
	}
	States.Nun.RightUpper:setMovements{
		{{24, 0}, 4, 5},
	}
	

	States.Nun.CrouchdashShoulderTackle = State:initTemplate("CrouchdashShoulderTackle", {sx = 0, sy = 11, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.CrouchdashShoulderTackle:setFrames{
		{{sx = 9, ox = -24, oy = -4}, 5},
		{{sx = 10, ox = -36, oy = -8}, 2},
		{{sx = 11, ox = -56, hit = 1, attacklevel = 3, hitboxes = {{30, -120, 100, 120}}, hitEffect = {hsGround = {pushback = 12, forceState = "JuggleTumble"}, hsAir = {pushback = 15, parabola = {pTime = 15, pHeight = 25}}}}, 8},
		{{sx = 12, ox = -50, oy = -2}, 11},
		{{sx = 13, ox = -50}, 5},
		{{sx = 14, ox = -15}, 2},
	}
	States.Nun.CrouchdashShoulderTackle:setMovements{
		{{0, 0}, 1, 1},
		{{30, 0}, 2, 6},
		{{0, 0}, 1, 11},
	}
	

	States.Nun.HeelKick = State:initTemplate("HeelKick", {sx = 0, sy = 3, ox = 2, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {special = true}})
	States.Nun.HeelKick:setFrames{
		{{}, 2},
		{{sx = 1}, 2},
		{{sx = 2}, 1},
		{{sx = 3}, 2},
		{{sx = 4}, 2},
		{{sx = 5, ox = -10, oy = 1}, 1},
		{{sx = 6, ox = -30, oy = 5, hit = 1, attacklevel = 4, hitEffect = {hsGround = {forceState = "JuggleFloat", pushback = 9, parabola = {pHeight = 75, pTime = 20}}, hsAir = {forceState = "JuggleFloat", pushback = 9, parabola = {pHeight = 65, pTime = 20}}}, hitboxes = {{10, -140, 120, 140}}}, 2},
		{{sx = 7, ox = -30, oy = 5}, 6},
		{{sx = 8, ox = -25, oy = 2}, 6},
	}
	States.Nun.HeelKick:setMovements{
		{{0, 0}, 1, 8},
		{{20, 0}, 1, 10},
		{{25, 0}, 1, 11},
		{{0, 0}, 1, 12},
		{{0, 0}, 1, 13},
	}
	

	States.Nun.HeelKickCharged = State:initTemplate("HeelKickCharged", {sx = 0, sy = 3, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = true, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.HeelKickCharged:setFrames{
		{{sx = 9}, 4},
		-- {{sx = 10}, 4},
		{{sx = 11, hit = 1, attacklevel = 4, hitboxes = {{0, -150, 130, 150}}, hitEffect = {hsAir = {pushback = 12, forceState = "JuggleFloat", speedY = 50}}}, 2},
		{{sx = 11, hit = 1, attacklevel = 4, hitboxes = {{0, -40, 135, 40}}, hitEffect = {hsAir = {pushback = 12, forceState = "JuggleFloat", speedY = 50}}}, 6},
		{{sx = 12}, 4},
		{{sx = 13}, 2},
	}
	States.Nun.HeelKickCharged:setMovements{
		{{24, 0}, 1, 1},
		{{0, 0}, 1, 2},
	}
	
	
	States.Nun.DashHeelKick = State:initTemplate("DashHeelKick", {sx = 0, sy = 3, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.DashHeelKick:setFrames{
		{{ox = 16}, 2},
		{{ox = 16, sx = 1}, 2},
		{{ox = 16, sx = 2}, 1},
		{{ox = 16, sx = 3}, 2},
		{{sx = 4}, 2},
		{{sx = 5, ox = -36}, 1},
		{{sx = 6, ox = -24, hit = 1, attacklevel = 4, hitboxes = {{10, -130, 105, 120}}}, 2},
		{{sx = 7, ox = -24, hit = 1, attacklevel = 4, hitboxes = {{10, -130, 105, 120}}}, 4},
		{{sx = 8, ox = -8}, 6},
	}
	States.Nun.DashHeelKick:setMovements{
		{{4, 0}, 1, 1},
		{{0, 0}, 1, 9},
		{{30, 0}, 1, 10},
		{{20, 0}, 1, 11},
		{{6, 0}, 1, 12},
		{{0, 0}, 1, 13},
	}
	

	States.Nun.FrontKick = State:initTemplate("FrontKick", {sx = 0, sy = 15, ox = 40, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.FrontKick:setFrames{
		{{ox = 50, oy = -2}, 1},
		{{sx = 1, ox = 57}, 1},
		{{sx = 3, ox = 60}, 6},
		{{sx = 4, ox = 62, oy = -2}, 1},
		{{sx = 6}, 2},
		{{sx = 6, hit = 1, attacklevel = 4, hitboxes = {{20, -100, 90, 60}}}, 1},
		{{sx = 7, ox = 55, hit = 1, attacklevel = 4, hitboxes = {{20, -100, 90, 60}}}, 8},
		{{sx = 8, ox = 50}, 5},
		{{sx = 9, ox = 55, oy = -5}, 3},
		{{sx = 10, ox = 55, oy = -5}, 3},
		{{sx = 11, ox = 70, oy = -9}, 2},
	}
	States.Nun.FrontKick:setMovements{
		{{-12, 0}, 1, 1},
		{{0, 0}, 8, 2},
		{{35, 0}, 2, 10},
		{{0, 0}, 1, 12},
		{{0, 0}, 2, 21},
		{{0, 0}, 1, 23},
		{{0, 0}, 1, 24},
	}
	

	States.Nun.FrontKickCharged = State:initTemplate("FrontKickCharged", {sx = 0, sy = 15, ox = 30, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = true, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.FrontKickCharged:setFrames{
		{{sx = 5, ox = 65}, 10},
		{{sx = 6}, 2},
		{{sx = 6, hit = 1, attacklevel = 5, hitboxes = {{5, -110, 105, 110}}}, 6},
		{{sx = 7}, 8},
		{{sx = 8}, 6},
		{{sx = 9, oy = -5}, 3},
		{{sx = 10, ox = 34, oy = -7}, 5},
		{{sx = 11, ox = 57, oy = -7}, 5},
	}
	States.Nun.FrontKickCharged:setMovements{
		{{0, 0}, 11, 1},
		{{20, 0}, 4, 12},
		{{0, 0}, 1, 16},
	}
	

	States.Nun.Sweep = State:initTemplate("Sweep", {sx = 0, sy = 2, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -45, 70, 45}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.Sweep:setFrames{
		{{}, 2},
		{{sx = 1}, 3},
		{{sx = 2}, 2},
		{{sx = 3}, 1},
		{{sx = 4, hit = 1, attacklevel = 3, hitboxes = {{20, -10, 125, 20}}, hitEffect = {hsGround = {pushback = 2, forceState = "JuggleTrip"}, hsAir = {pushback = 2, forceState = "JuggleTrip"}}}, 1},
		{{sx = 5, hit = 1, attacklevel = 3, hitboxes = {{20, -10, 125, 20}}, hitEffect = {hsGround = {pushback = 2, forceState = "JuggleTrip"}, hsAir = {pushback = 2, forceState = "JuggleTrip"}}}, 11},
		{{sx = 6}, 3},
		{{sx = 7}, 2},
		{{sx = 8}, 2},
		{{sx = 9}, 2},
	}
	States.Nun.Sweep:setMovements{
		{{25, 0}, 2, 8},
		{{-25, 0}, 2, 27},
	}
	

	States.Nun.SpinningSweep = State:initTemplate("SpinningSweep", {sx = 0, sy = 0, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {"Walk", _flags = {normal = true, stance = true, special = true, movement = true}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.SpinningSweep:setFrames{
		{{}, 1},
	}
	States.Nun.SpinningSweep:setMovements{
	}
	

	States.Nun.KneeHop = State:initTemplate("KneeHop", {sx = 0, sy = 4, ox = -25, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.KneeHop:setFrames{
		{{}, 2},
		{{sx = 1}, 2},
		{{sx = 2, aerial = true}, 2},
		{{sx = 3, aerial = true, hit = 1, attacklevel = 2, hitboxes = {{0, -100, 80, 70}}, hitEffect = {hsGround = {pushback = 7, forceState = "JuggleFloat", parabola = {pHeight = 36, pTime = 20}}, hsAir = {pushback = 7, forceState = "JuggleFloat", parabola = {pHeight = 36, pTime = 20}}}}, 10},
		{{sx = 4, aerial = true, hit = 1, attacklevel = 2, hitboxes = {{0, -100, 80, 70}}, hitEffect = {hsGround = {pushback = 7, forceState = "JuggleFloat", parabola = {pHeight = 36, pTime = 20}}, hsAir = {pushback = 7, forceState = "JuggleFloat", parabola = {pHeight = 36, pTime = 20}}}}, 10},
		{{sx = 5, aerial = true, hit = 1, attacklevel = 2, hitboxes = {{0, -100, 80, 70}}, hitEffect = {hsGround = {pushback = 7, forceState = "JuggleFloat", parabola = {pHeight = 36, pTime = 20}}, hsAir = {pushback = 7, forceState = "JuggleFloat", parabola = {pHeight = 36, pTime = 20}}}}, 10},
		{{sx = 6, aerial = true}, 10},
		{{sx = 7, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}}, 4},
	}
	States.Nun.KneeHop:setMovements{
	}
	
	States.Nun.KneeHopAssault = State:initTemplate("KneeHopAssault", {sx = 0, sy = 4, ox = -20, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.KneeHopAssault:setFrames{
		{{sx = 3, aerial = true}, 10},
		{{sx = 3, aerial = true, oy = -4, ox = -22}, 10},
		{{sx = 4, aerial = true, hit = 1, attacklevel = 2, hitboxes = {{30, -108, 50, 35}}, hitEffect = {hsGround = {pushback = 11}, hsAir = {pushback = 11, parabola = {pHeight = 45, pTime = 20}}}}, 10},
		{{sx = 5, aerial = true, hit = 1, attacklevel = 2, hitboxes = {{30, -80, 40, 50}}, hitEffect = {hsGround = {pushback = 11}, hsAir = {pushback = 11, parabola = {pHeight = 45, pTime = 20}}}}, 10},
		{{sx = 7}, 4},
	}
	States.Nun.KneeHopAssault:setMovements{
	}
	

	States.Nun.SplitKickHop = State:initTemplate("SplitKickHop", {sx = 0, sy = 4, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.SplitKickHop:setFrames{
		{{sx = 8}, 3},
		{{sx = 9}, 3},
		{{sx = 10, attacklevel = 4, hitboxes = {{-105, -105, 210, 120}}, hitEffect = {hsGround = {forceState = "JuggleTumble"}, hsAir = {pushback = 12}}}, 2},
		{{sx = 11}, 4},
		{{sx = 12}, 5},
		{{sx = 13}, 4},
		{{sx = 14}, 3},
		{{sx = 7}, 2},
		{{}, 2},
	}
	States.Nun.SplitKickHop:setMovements{
		{{-12, 0}, 1, 1},
	}
	

	States.Nun.AxeKick = State:initTemplate("AxeKick", {sx = 0, sy = 6, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = true, movement = false}}, hitEffect = {}, actor_collision = true, flags = {special = true}})
	States.Nun.AxeKick:setFrames{
		{{}, 2},
		{{sx = 1}, 2},
		{{sx = 2}, 3},
		{{sx = 3}, 5},
		{{sx = 4, ox = -8}, 3},
		{{sx = 5, hit = 1, attacklevel = 4, hitboxes = {{0, -150, 105, 150}}, hitEffect = {hsAir = {pushback = 2, forceState = "JuggleFloat", speedY = 50}}}, 3},
		{{sx = 6}, 7},
		{{sx = 7}, 5},
		{{sx = 8}, 1},
	}
	States.Nun.AxeKick:setMovements{
		{{15, 0}, 1, 2},
		{{4, 0}, 1, 14},
		{{35, 0}, 1, 16},
		{{0, 0}, 1, 17},
	}
	

	States.Nun.AxeKickCharged = State:initTemplate("AxeKickCharged", {sx = 0, sy = 6, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.AxeKickCharged:setFrames{
		{{sx = 3}, 8},
		{{sx = 4, hit = 1, attacklevel = 4, hitboxes = {{0, -125, 100, 125}}, hitEffect = {hsGround = {pushback = -2}, hsAir = {pushback = -2, forceState = "JuggleFloat", speedY = 0}}}, 3},
		{{sx = 5, hit = 2, attacklevel = 4, hitboxes = {{0, -125, 100, 125}}, hitEffect = {hsGround = {pushback = -2, forceState = "JuggleFloat", speedY = 50}, hsAir = {pushback = -2, forceState = "JuggleFloat", speedY = 50}}}, 4},
		{{sx = 5}, 2},
		{{sx = 6}, 6},
		{{sx = 7}, 5},
		{{sx = 8}, 3},
	}
	States.Nun.AxeKickCharged:setMovements{
		{{12, 0}, 1, 9},
		{{40, 0}, 1, 12},
		{{8, 0}, 1, 18},
	}
	

	States.Nun.CrouchdashSlideKick = State:initTemplate("CrouchdashSlideKick", {sx = 0, sy = 6, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = true, movement = false}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.CrouchdashSlideKick:setFrames{
		{{sx = 4, ox = -6}, 5},
		{{sx = 5}, 1},
		{{sx = 6, hit = 1, attacklevel = 3, hitboxes = {{0, -25, 85, 30}}, hitEffect = {hsGround = {forceState = "JuggleTrip"}}}, 3},
		{{sx = 7, hit = 1, attacklevel = 3, hitboxes = {{0, -25, 85, 30}}, hitEffect = {hsGround = {forceState = "JuggleTrip"}}}, 3},
		{{sx = 6, hit = 1, attacklevel = 3, hitboxes = {{0, -25, 85, 30}}, hitEffect = {hsGround = {forceState = "JuggleTrip"}}}, 3},
		-- {{sx = 7, hit = 1, attacklevel = 3, hitboxes = {{0, -30, 90, 30}}, hitEffect = {hsGround = {forceState = "JuggleTrip"}}}, 3},
		{{sx = 8}, 3},
		{{sx = 9}, 7},
		{{sx = 10}, 5},
	}
	States.Nun.CrouchdashSlideKick:setMovements{
		{{10, 0}, 3, 1},
		{{0, 0}, 2, 4},
		{{30, 0}, 1, 6},
		{{22, 0}, 3, 7},
		{{17, 0}, 3, 10},
		{{12, 0}, 3, 13},
		-- {{10, 0}, 3, 16},
		{{6, 0}, 3, 16},
		-- {{1, 0}, 3, 19},
	}
	

	States.Nun.DeathFist = State:initTemplate("DeathFist", {sx = 0, sy = 14, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {special = true}})
	States.Nun.DeathFist:setFrames{
		{{ox = 20}, 1},
		{{sx = 1, ox = 20}, 3},
		{{sx = 2, ox = 20}, 2},
		{{sx = 3, ox = 10}, 1},
		{{sx = 4, oy = -5, ox = -5}, 1},
		{{sx = 5, oy = -10, hit = 1, attacklevel = 5, hitboxes = {{0, -120, 110, 60}}, hitEffect = {hsAir = {pushback = 30, forceState = "JuggleBlowback", parabola = {pTime = 16, pHeight = 8}}, hsGround = {pushback = 30, forceState = "JuggleBlowback", parabola = {pTime = 14, pHeight = 20}}}}, 3},
		{{sx = 5, oy = -10}, 7},
		{{sx = 6, oy = -10}, 4},
		{{sx = 7, oy = -10}, 4},
		{{sx = 8, oy = -10}, 3},
		{{sx = 9, oy = -8}, 3},
	}
	States.Nun.DeathFist:setMovements{
		{{5, 0}, 1, 2},
		{{1, 0}, 1, 3},
		{{25, 0}, 1, 6},
		{{30, 0}, 2, 7},
		{{14, 0}, 2, 9},
	}
	

	States.Nun.RisingUpper = State:initTemplate("RisingUpper", {sx = 0, sy = 15, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {special = true}})
	States.Nun.RisingUpper:setFrames{
		{{ox = -12, oy = -8, hit = 1, attacklevel = 3, hitboxes = {{15, -90, 60, 100}}, hitEffect = {hsGround = {pushback = 12, forceState = "JuggleFloat", parabola = {pHeight = 130, pTime = 26}}, hsAir = {pushback = 12, forceState = "JuggleFloat", parabola = {pHeight = 130, pTime = 25}}}}, 4},
		{{sx = 1, aerial = true, hit = 2, attacklevel = 3, hitboxes = {{-5, -170, 60, 130}}, hitEffect = {hsGround = {pushback = 7, forceState = "JuggleLaunch", parabola = {pHeight = 130, pTime = 26}}, hsAir = {pushback = 7, forceState = "JuggleLaunch", parabola = {pHeight = 160, pTime = 25}}}}, 10},
		{{sx = 2, aerial = true, hit = 2, attacklevel = 2, hitboxes = {{-5, -170, 60, 130}}, hitEffect = {hsGround = {pushback = 7, forceState = "JuggleLaunch", parabola = {pHeight = 130, pTime = 26}}, hsAir = {pushback = 7, forceState = "JuggleLaunch", parabola = {pHeight = 160, pTime = 25}}}}, 10},
		{{sx = 3, aerial = true}, 10},
		{{sx = 4, aerial = true}, 10},
		{{sx = 5, aerial = true}, 10},
		{{sx = 6, aerial = true}, 10},
		{{sx = 7, aerial = true}, 10},
		{{sx = 3, sy = 5}, 3},
	}
	States.Nun.RisingUpper:setMovements{
		{{9, 0}, 1, 1},
		{{30, -10}, 1, 5},
	}
	

	States.Nun.SpinKick = State:initTemplate("SpinKick", {sx = 0, sy = 1, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.SpinKick:setFrames{
		{{ox = 20}, 6},
		{{sx = 1, ox = 28}, 2},
		{{sx = 2, ox = 30, hit = 1, attacklevel = 4, hitboxes = {{20, -100, 80, 100}, {45, -125, 110, 75}}, hitEffect = {hsGround = {pushback = 16, parabola = {pHeight = 50, pTime = 20}, forceState = "JuggleFloat"}, hsAir = {pushback = 16, parabola = {pHeight = 50, pTime = 18}, forceState = "JuggleFloat"}}}, 4},
		{{sx = 3, ox = 30}, 9},
		{{sx = 4, ox = 15}, 11},
	}
	States.Nun.SpinKick:setMovements{
	}
	

	States.Nun.KneeRevolver = State:initTemplate("KneeRevolver", {sx = 0, sy = 1, ox = 0, oy = 8, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {special = true}})
	States.Nun.KneeRevolver:setFrames{
		{{sx = 5, collboxes = {{-18, -100, 36, 100}}}, 6},
		{{sx = 6, ox = -16, oy = 16, aerial = true, hit = 1, attacklevel = 5, hitboxes = {{20, -140, 110, 160}}, hitEffect = {hsGround = {pushback = 16, parabola = {pHeight = 50, pTime = 20}, forceState = "JuggleFloat"}, hsAir = {pushback = 16, parabola = {pHeight = 50, pTime = 18}, forceState = "JuggleFloat"}}}, 2},
		{{sx = 7, aerial = true}, 6},
		{{sx = 8, aerial = true}, 2},
		{{sx = 9, aerial = true}, 2},
		{{sx = 10, aerial = true , hit = 2, attacklevel = 1, hitboxes = {{0, -140, 55, 90}}}, 2},
		{{sx = 11, aerial = true}, 2},
		{{sx = 12, aerial = true}, 2},
		{{sx = 13, aerial = true, hit = 3, attacklevel = 3, hitboxes = {{10, -170, 110, 170}}}, 2},
		{{sx = 14, aerial = true}, 10},
		{{sx = 3, sy = 5, sheet = 1, collboxes = {{-18, -100, 36, 100}}}, 5},
		{{sx = 4, sy = 5, sheet = 1, collboxes = {{-18, -100, 36, 100}}}, 2},
	}
	States.Nun.KneeRevolver:setMovements{
		{{30, -30}, 2, 7}
	}
	
	States.Nun.KneeRevolverFall = State:initTemplate("KneeRevolverFall", {sx = 0, sy = 4, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	
	States.Nun.KneeRevolverFall:setFrames{
		{{sx = 6, sy = 1, ox = -16, oy = 16, sheet = 2, aerial = true}, 10},
		{{sx = 1, aerial = true}, 10},
		{{sx = 3, sy = 5, collboxes = {{-18, -100, 36, 100}}}, 3},
		{{sx = 4, sy = 5, collboxes = {{-18, -100, 36, 100}}}, 1}
	}
	
	States.Nun.KneeRevolverFall:setMovements{
	}
	

	States.Nun.DoubleUpkicks = State:initTemplate("DoubleUpkicks", {sx = 0, sy = 7, ox = -15, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {special = true}})
	States.Nun.DoubleUpkicks:setFrames{
		{{ox = 0}, 3},
		{{sx = 1, ox = 0}, 3},
		{{sx = 2, hit = 1, attacklevel = 2, hitboxes = {{0, -155, 100, 180}}, hitEffect = {hsAir = {forceState = "JuggleLaunch", parabola = {pTime = 24, pHeight = 80}}, hsGround = {forceState = "JuggleLaunch", parabola = {pTime = 24, pHeight = 80}}}}, 3},
		{{sx = 3}, 5},
		{{sx = 4}, 2},
		{{sx = 6, hit = 2, attacklevel = 2, hitboxes = {{0, -155, 100, 100}}, hitEffect = {hsAir = {pushback = 12, parabola = {pTime = 23, pHeight = 80}, forceState = "JuggleLaunch"}, hsGround = {pushback = 8, parabola = {pTime = 23, pHeight = 80}, forceState = "JuggleLaunch"}}}, 10},
		{{sx = 7}, 7},
		{{sx = 8, ox = -4}, 29},
	}
	States.Nun.DoubleUpkicks:setMovements{
		{{0, 0}, 2, 1},
		{{5, 0}, 1, 4},
		{{0, -7}, 14, 7},
	}
	

	States.Nun.Jump = State:initTemplate("Jump", {sx = 0, sy = 4, ox = -6, oy = 0, sheet = 1, sh = 256, sw = 256, aerial = false, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = true, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {stance = true}})
	States.Nun.Jump:setFrames{
		{{aerial = true}, 10},
		{{sx = 1, aerial = true}, 10},
		{{sx = 2, aerial = true}, 10},
	}
	States.Nun.Jump:setMovements{
	}
	

	States.Nun.Prejump = State:initTemplate("Prejump", {sx = 0, sy = 0, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {stance = true}})
	States.Nun.Prejump:setFrames{
		{{sx = 4, sy = 5}, 1},
	}
	States.Nun.Prejump:setMovements{
	}
	

	States.Nun.LandRecovery = State:initTemplate("LandRecovery", {sx = 0, sy = 5, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.LandRecovery:setFrames{
		{{sx = 3}, 1},
		{{sx = 4}, 1},
	}
	States.Nun.LandRecovery:setMovements{
		{{0, 3}, 12, 1},
	}
	

	States.Nun.DummyFall = State:initTemplate("DummyFall", {sx = 0, sy = 4, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.DummyFall:setFrames{
		{{}, 1},
	}
	States.Nun.DummyFall:setMovements{
	}
	

	States.Nun.JumpLeftRightPunches = State:initTemplate("JumpLeftRightPunches", {sx = 0, sy = 8, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.JumpLeftRightPunches:setFrames{
		{{}, 1},
		{{sx = 1}, 1},
		{{sx = 2, hit = 1, attacklevel = 1, hitboxes = {{0, -120, 65, 85}}}, 2},
		{{sx = 3, hit = 1, attacklevel = 1, hitboxes = {{0, -120, 65, 85}}}, 5},
		{{sx = 4}, 1},
		{{sx = 5}, 2},
		{{sx = 6, hit = 2, attacklevel = 1, hitboxes = {{10, -125, 75, 120}}}, 4},
		{{sx = 7}, 3},
		{{sx = 8}, 8},
		{{sx = 9}, 8},
	}
	States.Nun.JumpLeftRightPunches:setMovements{
	}
	

	States.Nun.JumpHammerFist = State:initTemplate("JumpHammerFist", {sx = 0, sy = 9, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = true, stance = true, special = true, movement = true}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.JumpHammerFist:setFrames{
		{{sx = 2}, 7},
		{{sx = 4}, 1},
		{{sx = 5, hit = 1, attacklevel = 4, hitboxes = {{-20, -120, 85, 150}}, hitEffect = {hsAir = {pushback = 4, speedY = 10}}}, 3},
		{{sx = 6}, 4},
		{{sx = 7}, 4},
		{{sx = 8}, 4},
		{{sx = 9}, 4},
	}
	States.Nun.JumpHammerFist:setMovements{
	}
	

	States.Nun.JumpPowerPunch = State:initTemplate("JumpPowerPunch", {sx = 0, sy = 10, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.JumpPowerPunch:setFrames{
		{{}, 1},
		{{sx = 1}, 3},
		{{sx = 2, ox = -15}, 1},
		{{sx = 3, ox = -18, oy = 4, hit = 1, attacklevel = 4, hitboxes = {{25, -160, 80, 110}}, hitEffect = {hsGround = {pushback = 13, forceState = "JuggleFloat"}, hsAir = {pushback = 13, forceState = "JuggleFloat"}}}, 4},
		{{sx = 4, ox = -15, oy = 4}, 10},
	}
	States.Nun.JumpPowerPunch:setMovements{
	}
	

	States.Nun.JumpFlyingKick = State:initTemplate("JumpFlyingKick", {sx = 0, sy = 11, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {"JumpHeelKick", _flags = {normal = true, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.JumpFlyingKick:setFrames{
		{{}, 4},
		{{sx = 1}, 1},
		{{sx = 2, hit = 1, attacklevel = 3, hitboxes = {{-50, -85, 150, 60}}, hitEffect = {hsAir = {pushback = 9, parabola = {pHeight = 60, pTime = 18}}}}, 8},
		{{sx = 3}, 4},
		{{sx = 4}, 6},
		{{sx = 5}, 4},
	}
	States.Nun.JumpFlyingKick:setMovements{
	}
	

	States.Nun.JumpHeelKick = State:initTemplate("JumpHeelKick", {sx = 0, sy = 11, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.JumpHeelKick:setFrames{
		{{sx = 6, ox = 10}, 2},
		{{sx = 7, ox = 5}, 2},
		{{sx = 8}, 1},
		{{sx = 9}, 1},
		{{sx = 10}, 1},
		{{sx = 11, hit = 1, attacklevel = 2, hitboxes = {{0, -110, 100, 90}}}, 7},
		{{sx = 12}, 18},
	}
	States.Nun.JumpHeelKick:setMovements{
	}
	

	States.Nun.JumpDiveKick = State:initTemplate("JumpDiveKick", {sx = 0, sy = 12, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.JumpDiveKick:setFrames{
		{{}, 5},
		{{sx = 1}, 5},
		{{sx = 2, hit = 1, attacklevel = 2, hitboxes = {{-10, -95, 50, 120}, {-10, 0, 65, 25}}, hitEffect = {hsAir = {speedY = 25}}}, 12},
	}
	States.Nun.JumpDiveKick:setMovements{
		{{0, -4}, 5, 1},
		{{0, -10}, 5, 6},
		{{10, 23}, 10, 11},
	}
	

	States.Nun.JumpDiveKickCharge1 = State:initTemplate("JumpDiveKickCharge1", {sx = 0, sy = 12, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.JumpDiveKickCharge1:setFrames{
		{{sx = 1}, 5},
		{{sx = 3, ox = 10}, 5},
		{{sx = 4, hit = 1, attacklevel = 4, hitboxes = {{-10, -75, 60, 90}}}, 10},
	}
	States.Nun.JumpDiveKickCharge1:setMovements{
		{{0, -8}, 5, 1},
		{{0, -3}, 5, 6},
		{{4, 25}, 10, 11},
	}
	

	States.Nun.JumpDiveKickCharge2 = State:initTemplate("JumpDiveKickCharge2", {sx = 0, sy = 12, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.JumpDiveKickCharge2:setFrames{
		{{sx = 1}, 5},
		{{sx = 3, ox = 10}, 5},
		{{sx = 5, hit = 1, attacklevel = 4, hitboxes = {{0, -75, 60, 90}}}, 10},
	}
	States.Nun.JumpDiveKickCharge2:setMovements{
		{{0, -8}, 5, 1},
		{{0, -3}, 5, 6},
		{{11, 25}, 10, 11},
	}
	

	States.Nun.JumpDiveKickCharge3 = State:initTemplate("JumpDiveKickCharge3", {sx = 0, sy = 12, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.JumpDiveKickCharge3:setFrames{
		{{sx = 1}, 5},
		{{sx = 3, ox = 10}, 5},
		{{sx = 6, hit = 1, attacklevel = 4, hitboxes = {{10, -75, 60, 90}}}, 10},
	}
	States.Nun.JumpDiveKickCharge3:setMovements{
		{{0, -8}, 5, 1},
		{{0, -3}, 5, 6},
		{{18, 25}, 10, 11},
	}
	

	States.Nun.JumpAxeKick = State:initTemplate("JumpAxeKick", {sx = 0, sy = 13, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.JumpAxeKick:setFrames{
		{{}, 4},
		{{sx = 1}, 2},
		{{sx = 2, hit = 1, attacklevel = 3, hitboxes = {{0, -160, 50, 125}, {0, -160, 100, 75}}, hitEffect = {hsGround = {parabola = {pHeight = 70, pTime = 15}, forceState = "JuggleLaunch"}, hsAir = {parabola = {pHeight = 65, pTime = 15}, forceState = "JuggleLaunch"}}}, 3},
		{{sx = 3}, 1},
		{{sx = 4}, 1},
		{{sx = 5}, 6},
		{{sx = 6}, 1},
		{{sx = 7, ox = -9, hit = 2, attacklevel = 3, hitboxes = {{-15, -150, 95, 100}}, hitEffect = {hsGround = {forceState = "JuggleFloat", parabola = {pHeight = 50, pTime = 10}, speedY = 20}, hsAir = {forceState = "JuggleFloat", parabola = {pHeight = 40, pTime = 10}, speedY = 12}}}, 5},
		{{sx = 8, ox = -5}, 11},
		{{sx = 9}, 19},
	}
	States.Nun.JumpAxeKick:setMovements{
		{{0, 0}, 20, 1},
	}
	

	States.Nun.RightKnee = State:initTemplate("RightKnee", {sx = 0, sy = 5, ox = 30, oy = 0, sheet = 2, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.RightKnee:setFrames{
		{{ox = 0}, 2},
		{{sx = 1, ox = 0}, 4},
		{{sx = 2, ox = 30, oy = 8}, 2},
		{{sx = 3, ox = 35, oy = 10, hit = 1, attacklevel = 3, hitboxes = {{0, -105, 80, 115}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {hsGround = {pushback = 9, forceState = "JuggleFloat", parabola = {pHeight = 50, pTime = 23}}, hsAir = {pushback = 8, forceState = "JuggleFloat", parabola = {pHeight = 40, pTime = 22}}}}, 8},
		{{sx = 4, ox = 35, oy = 10, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}}, 2},
		{{sx = 5, ox = 35, oy = 10, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}}, 2},
		{{sx = 6, ox = 70, oy = -6}, 3},
		{{sx = 7, ox = 60, oy = -4}, 2},
		{{sx = 8, ox = 60, oy = -6}, 3},
		{{sx = 9, ox = 62, oy = -8}, 3},
	}
	States.Nun.RightKnee:setMovements{
		{{15, 0}, 2, 5},
		{{8, 0}, 10, 7},
		{{6, 0}, 5, 17},
		{{20, 0}, 1, 24},
		{{0, 0}, 1, 25},
	}
	

	States.Nun.AssaultJump = State:initTemplate("AssaultJump", {sx = 0, sy = 4, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, aerial = false, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {stance = true}})
	States.Nun.AssaultJump:setFrames{
		{{aerial = true}, 10},
		{{sx = 1, aerial = true}, 10},
		{{sx = 2, aerial = true, on_whiff = {"KneeHopAssault", "JumpHammerFist", _flags = {}}}, 10},
		{{sy = 5, ox = 3, collboxes = {{-18, -100, 36, 100}}}, 4},
	}
	States.Nun.AssaultJump:setMovements{
	}
	

	States.Nun.EscapeJump = State:initTemplate("EscapeJump", {sx = 0, sy = 14, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = false, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {stance = true}})
	States.Nun.EscapeJump:setFrames{
		{{collboxes = {{-18, -100, 36, 100}}}, 6},
		{{sx = 1, aerial = true, collboxes = {{-18, -100, 36, 60}}}, 10},
		{{sx = 2, aerial = true, collboxes = {{-18, -100, 36, 60}}}, 10},
		{{sx = 3, oy = -8, aerial = true, collboxes = {{-18, -100, 36, 60}}}, 10},
		{{sx = 4, aerial = true, collboxes = {{-18, -100, 36, 60}}, on_whiff = {_flags = {normal = true, stance = false, special = false, movement = false}}}, 10},
		{{sx = 5, aerial = true, collboxes = {{-18, -100, 36, 60}}, on_whiff = {_flags = {normal = true, stance = false, special = false, movement = false}}}, 10},
		{{sx = 6, aerial = true, collboxes = {{-18, -100, 36, 60}}, on_whiff = {_flags = {normal = true, stance = false, special = false, movement = false}}}, 10},
		{{sx = 7, aerial = true, collboxes = {{-18, -100, 36, 60}}, on_whiff = {_flags = {normal = true, stance = false, special = false, movement = false}}}, 10},
		{{sx = 8, aerial = true, collboxes = {{-18, -100, 36, 60}}, on_whiff = {_flags = {normal = true, stance = false, special = false, movement = false}}}, 10},
		{{sx = 9, collboxes = {{-18, -100, 36, 100}}}, 3},
		{{sx = 10, collboxes = {{-18, -100, 36, 100}}}, 3},
	}
	States.Nun.EscapeJump:setMovements{
	}
	

	States.Nun.SuperJump = State:initTemplate("SuperJump", {sx = 0, sy = 4, ox = -6, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = true, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {stance = true}})
	States.Nun.SuperJump:setFrames{
		{{sy = 14, sheet = 2, aerial = false, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}}, 3},
		{{aerial = true}, 10},
		{{sx = 1, aerial = true}, 10},
		{{sx = 2, aerial = true}, 10},
	}
	States.Nun.SuperJump:setMovements{
	}
	

	States.Nun.DashLeftJolt = State:initTemplate("DashLeftJolt", {sx = 0, sy = 8, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {"DashRightStraight", _flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.DashLeftJolt:setFrames{
		{{sx = 7, ox = 6}, 4},
		{{sx = 8, ox = -7}, 2},
		{{sx = 9, hit = 1, attacklevel = 2, hitboxes = {{0, -100, 100, 100}}}, 2},
		{{sx = 10, hit = 1, attacklevel = 1, hitboxes = {{0, -100, 100, 100}}}, 5},
		{{sx = 11}, 6},
		{{sx = 12}, 5},
		{{sx = 13}, 5},
	}
	States.Nun.DashLeftJolt:setMovements{
		{{11, 0}, 3, 5},
		{{0, 0}, 1, 8},
	}
	

	States.Nun.JumpHop = State:initTemplate("JumpHop", {sx = 0, sy = 4, ox = -6, oy = 0, sheet = 1, sh = 256, sw = 256, aerial = false, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = true, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {stance = true}})
	States.Nun.JumpHop:setFrames{
		{{aerial = true}, 10},
		{{sx = 1, aerial = true}, 10},
		{{sx = 2, aerial = true}, 10},
	}
	States.Nun.JumpHop:setMovements{
	}
	

	States.Nun.DashRightStraight = State:initTemplate("DashRightStraight", {sx = 0, sy = 8, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {"LeftSwing", _flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.DashRightStraight:setFrames{
		{{}, 1},
		{{sx = 1}, 1},
		{{sx = 2, oy = -2, hit = 1, attacklevel = 3, hitboxes = {{0, -110, 90, 60}}}, 5},
		{{sx = 3}, 6},
		{{sx = 4}, 6},
	}
	States.Nun.DashRightStraight:setMovements{
		{{14, 0}, 1, 2},
	}
	

	States.Nun.Microdash = State:initTemplate("Microdash", {sx = 0, sy = 8, ox = 0, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = true, stance = true, special = true, movement = true}}, on_hit = {_flags = {normal = false, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.Microdash:setFrames{
		{{sx = 7}, 8},
	}
	States.Nun.Microdash:setMovements{
		{{15, 0}, 8, 1},
	}
	

	States.Nun.DashFlyingKick = State:initTemplate("DashFlyingKick", {sx = 0, sy = 11, ox = 0, oy = 0, sheet = 2, sh = 256, sw = 256, aerial = true, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -110, 40, 80}}, collboxes = {{-18, -100, 36, 90}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = false, special = false, movement = false}}, hitEffect = {}, actor_collision = true, flags = {normal = true}})
	States.Nun.DashFlyingKick:setFrames{
		{{}, 6},
		{{sx = 1}, 2},
		{{sx = 2, hit = 1, attacklevel = 3, hitboxes = {{-50, -85, 150, 60}}}, 10},
		{{sx = 3}, 4},
		{{sx = 4}, 6},
		{{sx = 5}, 4},
	}
	States.Nun.DashFlyingKick:setMovements{
	}
	

	States.Nun.SweepSlideKick = State:initTemplate("SweepSlideKick", {sx = 0, sy = 6, ox = 10, oy = 0, sheet = 1, sh = 256, sw = 256, hit = false, rapidfire = false, attacklevel = false, hitboxes = {}, hurtboxes = {{-20, -105, 40, 105}}, collboxes = {{-18, -100, 36, 100}}, on_whiff = {_flags = {normal = false, stance = false, special = false, movement = false}}, on_hit = {_flags = {normal = true, stance = true, special = true, movement = true}}, hitEffect = {}, actor_collision = true, flags = {}})
	States.Nun.SweepSlideKick:setFrames{
		{{sx = 5, sy = 2, ox = 4, sheet = 2}, 3},
		{{sx = 4, ox = 4}, 8},
		{{sx = 5, ox = 0}, 2},
		{{sx = 6, hit = 1, attacklevel = 3, hitboxes = {{0, -30, 90, 30}}, hitEffect = {hsGround = {forceState = "JuggleTrip"}}}, 3},
		{{sx = 7, hit = 1, attacklevel = 3, hitboxes = {{0, -30, 90, 30}}, hitEffect = {hsGround = {forceState = "JuggleTrip"}}}, 3},
		{{sx = 6, hit = 1, attacklevel = 3, hitboxes = {{0, -30, 90, 30}}, hitEffect = {hsGround = {forceState = "JuggleTrip"}}}, 3},
		{{sx = 7, hit = 1, attacklevel = 3, hitboxes = {{0, -30, 90, 30}}, hitEffect = {hsGround = {forceState = "JuggleTrip"}}}, 3},
		{{sx = 8, ox = 0}, 3},
		{{sx = 9, ox = 0}, 5},
		{{sx = 10, ox = 0}, 4},
	}
	States.Nun.SweepSlideKick:setMovements{
		{{26, 0}, 2, 11},
		{{10, 0}, 3, 13},
		{{9, 0}, 3, 16},
		{{8, 0}, 3, 19},
		{{7, 0}, 3, 22},
		{{4, 0}, 3, 25},
		{{2, 0}, 3, 28},
	}
	

		States.Nun.Stand.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.Duck.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.Guard.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.Walk.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.Dash.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.SwayShort.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.SwayLong.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.Crouchdash.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.LeftJolt.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.RightStraight.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.LeftSwing.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.RightHookStand.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.RightHookCrouch.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.RightHookSway.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.LeftDownpunch.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.LeftUpper.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.ShoulderTackle.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.RightUpper.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.CrouchdashShoulderTackle.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.HeelKick.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.HeelKickCharged.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.FrontKick.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.FrontKickCharged.onConditionCancels = {finish = true, wall = true, fall = true, land = true}
		States.Nun.Sweep.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.SpinningSweep.onConditionCancels = {finish = true, wall = true, fall = true, land = true}
		States.Nun.KneeHop.onConditionCancels = {land = false, fall = false, wall = true, finish = true}
		States.Nun.KneeHopAssault.onConditionCancels = {land = false, fall = false, wall = true, finish = true}
		States.Nun.SplitKickHop.onConditionCancels = {land = false, fall = false, wall = true, finish = true}
		States.Nun.AxeKick.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.AxeKickCharged.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.CrouchdashSlideKick.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.DeathFist.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.RisingUpper.onConditionCancels = {land = false, fall = false, wall = true, finish = true}
		States.Nun.SpinKick.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.KneeRevolver.onConditionCancels = {land = false, fall = false, wall = true, finish = true}
		States.Nun.KneeRevolverFall.onConditionCancels = {land = false, fall = false, wall = true, finish = true}
		States.Nun.DoubleUpkicks.onConditionCancels = {land = true, fall = false, wall = true, finish = true}
		States.Nun.Jump.onConditionCancels = {land = "Stand", fall = true, wall = true, finish = true}
		States.Nun.Prejump.onConditionCancels = {land = true, fall = true, wall = true, finish = "Jump"}
		States.Nun.LandRecovery.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.DummyFall.onConditionCancels = {land = true, fall = true, wall = true, finish = "Jump"}
		States.Nun.JumpLeftRightPunches.onConditionCancels = {land = true, fall = true, wall = true, finish = "Jump"}
		States.Nun.JumpHammerFist.onConditionCancels = {land = true, fall = true, wall = true, finish = "Jump"}
		States.Nun.JumpPowerPunch.onConditionCancels = {land = true, fall = true, wall = true, finish = "Jump"}
		States.Nun.JumpFlyingKick.onConditionCancels = {land = true, fall = true, wall = true, finish = "Jump"}
		States.Nun.JumpHeelKick.onConditionCancels = {land = true, fall = true, wall = true, finish = "Jump"}
		States.Nun.JumpDiveKick.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.JumpDiveKickCharge1.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.JumpDiveKickCharge2.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.JumpDiveKickCharge3.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.JumpAxeKick.onConditionCancels = {land = true, fall = true, wall = true, finish = "Jump"}
		States.Nun.RightKnee.onConditionCancels = {land = false, fall = false, wall = true, finish = true}
		States.Nun.AssaultJump.onConditionCancels = {finish = true, wall = true, fall = false, land = false}
		States.Nun.EscapeJump.onConditionCancels = {land = false, fall = false, wall = true, finish = true}
		States.Nun.SuperJump.onConditionCancels = {land = false, fall = false, wall = true, finish = true}
		States.Nun.DashLeftJolt.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.JumpHop.onConditionCancels = {land = "Stand", fall = true, wall = true, finish = true}
		States.Nun.DashRightStraight.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.Microdash.onConditionCancels = {finish = true, wall = true, fall = true, land = true}
		States.Nun.DashFlyingKick.onConditionCancels = {land = true, fall = true, wall = true, finish = true}
		States.Nun.SweepSlideKick.onConditionCancels = {land = true, fall = true, wall = true, finish = true}

	CancelList = {
		grounded = {
			normal = {"LeftJolt", "RightHookStand", "RightHookSway", "LeftUpper", "CrouchdashShoulderTackle", "FrontKick", "Sweep", "SplitKickHop", "CrouchdashSlideKick", "RightKnee", "DashLeftJolt", "DashHeelKick"},
			stance = {"Dash", "SwayShort", "SwayLong", "Crouchdash", "Jump", "Prejump", "AssaultJump", "EscapeJump", "SuperJump", "JumpHop"},
			special = {"RightUpper", "HeelKick", "AxeKick", "DeathFist", "RisingUpper", "KneeRevolver", "DoubleUpkicks"},
			cmdnormal = {},
			movement = {"Duck", "Guard"},
		}, 
		aerial = {
			normal = {"JumpLeftRightPunches", "JumpHammerFist", "JumpPowerPunch", "JumpFlyingKick", "JumpHeelKick", "JumpDiveKick", "JumpAxeKick", "DashFlyingKick"},
			stance = {},
			special = {},
			cmdnormal = {},
			movement = {},
		}, 
	}

end

