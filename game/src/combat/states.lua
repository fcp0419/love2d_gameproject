function Actor:addToChain(state_id)
	table.insert(self.chain, 1, state_id)
end

function APC:addToChain(state_id)
	if (isInTable(self.free_actions, state_id) == false) then
		Actor.addToChain(self, state_id)	
	else
	end
end

function Actor:resetChain()
	if #self.chain > 0 then
		-- print("Reset the chain.", #self.chain)
		-- for k, v in pairs(self.chain) do print(k, v) end
		self.chain = {}
		
		SFX.chain_end:stop()
		SFX.chain_end:play()
	end
end

-- Function receives a list of moves that the working set of inputs could produce, checks it vs. the moves our current move could cancel into and returns one choice -- the move to be canceled into -- or false if there are none.
function Actor:getOptimalCancel(cancellist) -- Do update this with state strings or other state ID methods as soon as the system is solid.
	cancellist = cancellist or {}

	-- print("Hits", #self.hits)
	
	local whiffcancels = self:getFrame().on_whiff
	local hitcancels = (#self.hits > 0) and self:getFrame().on_hit or {}
	
	local commonFlags = {movement = false, stance = false, normal = false, special = false, cmdnormal = false}
	
	-- print("Initial commonFlags test")
	for k, v in pairs(commonFlags) do
		-- print(k, v)
	end
	
	if type(whiffcancels["_flags"]) == "table" then
		for k, v in pairs(commonFlags) do
			commonFlags[k] = whiffcancels["_flags"][k] or v
		end
	end
	
	if type(hitcancels["_flags"]) == "table" then
		for k, v in pairs(commonFlags) do
			commonFlags[k] = hitcancels["_flags"][k] or v
		end
	end
	
	local pHitcancels = Set.sanitize(hitcancels)
	local pWhiffcancels = Set.sanitize(whiffcancels)
	local tc_cancels = Set.merge(pHitcancels, pWhiffcancels)
	
	if self.id == "Nun" then -- super hacky
		for k, v in pairs(commonFlags) do
			if v then 

				tc_cancels = Set.merge(tc_cancels, CancelList[(self:getFrame().aerial and "aerial" or "grounded")][k])
			end
		end
		
	end
	
		for i = 1, #cancellist do				  
		-- Potentially n²-tier ugly and does not account for property-modified states.
			for j = 1, #tc_cancels do
				if     (self.state.rapidfire or (cancellist[i].id ~= self.state.id)) 
					and (cancellist[i].id == tc_cancels[j]) and (isInTable(self.chain, cancellist[i].id) == false) then -- Do not allow for moves cancelling into themselves.
					return cancellist[i]
				end
			end
		end
	return false
end

function Actor:hasAlreadyHit(target, hitnr)
	if self.hits[hitnr] ~= nil then
		local hx = self.hits[hitnr]
		return true
	end
	return false
end

function Actor:recordHit(target)
	local af = self:getFrame()
	self.hits[af.hit] = self.hits[af.hit] or {}
	self.hits[af.hit][#self.hits[af.hit] + 1] = target 
end


function MapObject:stepAnimation()
	-- Map objects are supposed to have no active cancels. Just go to the next frame
end

function Actor:stepAnimation()
	self.state.onStepStart(self) -- callback that happens before anything happens.
	self:advanceFrame(self.state)
	-- Same as map object, but there might be AI-based decisions on what thing to try and cancel into.
end

function Actor:advanceFrameRaw()
	self.frame = self.frame + 1
	if self.frame > #self.state.animation.frames then
		self.frame = 1
	end
end

function PlayerCharacter:stepAnimation()
	self.state.onStepStart(self) -- callback that happens before anything happens.
	local nextState = self:getOptimalCancel(self:parseInputs(InputTable))
	self:advanceFrame(nextState)
end


function Actor:advanceFrame(nextState)
	if ((nextState ~= false) and (nextState.id ~= self.state.id)) then
		self:changeState(nextState)
	else
		local nextFrame, forcedState = self.state.onStepEnd(self)
		if forcedState and forcedState.id ~= self.state.id then
			self:changeState(forcedState)
			self.frame = (type(nextFrame == "number") and nextFrame or 1)
		elseif type(nextFrame) == "number" then
			self.frame = nextFrame
		else
			self.frame = self.frame + 1
		end
		if ((self.frame < 1) or (self.frame > #self.state.animation.frames)) then
			-- print(self.id, self.state.id, self.frame, "Finishing animation.")
			self:changeState(self:getConditionCancelState(self.state, "finish")) 
		end
	end
	self.queued_turn = false
end

function Actor:stepFLWCancels()
	if ((self:getFrame().aerial ~= true) and (self:isGrounded() == false)) then 
		self.gracejump = self.gracejump + 1 
	else self.gracejump = 0
	end
	if self.gracejump > 3 then 
		local ccs = self:getConditionCancelState(self.state, "fall")
		if ccs then
			self.state = self:getStateFromID("DummyFall")
			-- print(self.id, self.state.id, self.frame, ccs.id, "Entering fall cancel.")
			self:changeState(ccs)
			self.gracejump = 0
		end
	else
		-- print(self.id, self.deltaMovement[2])
		if (self:getFrame().aerial and self:isGrounded() and self.deltaMovement[2] >= 0) then 
			-- print(self.id, self.state.id, self.frame, "Entering land cancel.")
			local ccs = self:getConditionCancelState(self.state, "land")
			if ccs then self:changeState(ccs) end
		end
	end
end

function Actor:stepState(dt)

	-- Something about the order in this function is off, I think. Remember that there's currently a forced 1f of new state time.
	-- The fix is probably:
		-- If canceled for some reason other than going over max frames, instantly run stepState again.
	
	self.state.onStepStart(self)
	local ps = self:parseInputs(InputTable) or {}
	local next_move = self:getOptimalCancel(ps)

	-- replace THIS with an State.advanceFrame(actor) function that picks a cancel or returns a frame to go to 
	
	if next_move.id ~= self.state.id then
		self:changeState(next_move) 
	else	-- Stay in move.
		self.frame = self.frame + 1
	end
	-- Parse inputs. 
	
	if self.frame > #self.state.animation.frames then 
		self:changeState(self:getConditionCancelState(self.state, "finish")) 
	end -- if an animation is over - cancel into the next anim
	self.queued_turn = false
	
	self.state.onStepEnd(self)
end

function Actor:changeState(state)
	if not Interface.animEditActive then 
		self.state.onStateEnd(self, state)
		self.previous_state = {id = self.state.id, frame = self.frame}
		state = state or self.state
		self.state = state
		self.frame = 1	
		self.hits = {}
		self:addToChain(self.previous_state.id)
		if self.queued_turn then self.facing = self.facing * -1 end
		state.onStateStart(self)
	else
		self.frame = 1
	end
end



function Actor:turn()
	self.facing = -self.facing
end

function Actor:parseInputs(inputtable)
	return false -- AI goes here.
end


function Actor:stepMomentum(dt)
	local usedMomentum = self.state:getMovement(self.frame)
	for k, v in pairs(self.forces) do
		if v.active then
			local val = v:update()
			usedMomentum[1] = usedMomentum[1] + val[1]
			usedMomentum[2] = usedMomentum[2] + val[2]
		end
	end

	local orientedMomentum = {usedMomentum[1] * self.facing, usedMomentum[2]}
	
end

function Actor:changeMomentum(m)
end

function MapObject:changeMomentum(m)
end
