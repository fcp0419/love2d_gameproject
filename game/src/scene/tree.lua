RTree = Object:new{
	nodes = {},
	root = -1,
	master_name = "test",
	nodeMapping = {}
}

RTreeNode = Object:new{
	left = -1,
	right = -1,
	parent = -1,
	index = -1,
	AABB = {0, 0, 0, 0},
	object = false
}

function RTreeNode:isLeaf()
	return (self.left == -1)
end

function RTreeNode:isRoot()
	return (self.parent == -1)
end

function RTree:getNextEmptyIndex()
	for i = 1, #self.nodes do
		if (not (self.nodes[i])) then
			return i 
		end
	end
	return #self.nodes + 1
end

function RTree:insertObject(o)
	
	local function masterboxExists(mastername)
		local mbox = o[mastername]
		if ((mbox[3] == 0) and (mbox[4] == 0)) then return false end
		return true
	end
	
	
	if masterboxExists(self.master_name) then

		local attachNode = self.nodes[self:getBestAttachByHeuristic(o[self.master_name], self.root)]
		local newNode = self:insertNodeByObject(o)
		
		if attachNode then
			self:mergeLeafIntoTree(attachNode, newNode)
		end
	end
	
	
	
	-- Create a leaf node for the object and assign it an AABB based on it’s associated object.
	-- Find the best existing node (leaf or branch) in the tree to make the new leaf a sibling of.
	-- Create a new branch node for the located node and the new leaf and assign it an AABB that contains both nodes (essentially combine the AABBs of the two located node and the new leaf).
	-- Attach the new leaf to the new branch node.
	-- Remove the existing node from the tree and attach it to the new branch node.
	-- Attach the new branch node as a child of the existing nodes previous parent node.
	-- Walk back up the tree adjusting the AABB of all of our ancestors to ensure they still contain the AABBs of all of their descendants.

end

function RTree:dumpSelf()
	print("Dumping RTree w/ master", self.master_name)
	print("Root", self.root)
	for i = 1, #self.nodes do
		local node = self.nodes[i]
		print("")
		if node then
			print("Index", node.index)
			print("Parent", node.parent)
			print("Left", node.left)
			print("Right", node.right)
			if node.object then print("Node has an object.") end
		else
			print("No node at index " .. i)
		end
	end
	print("")
	print("Finished dumping the RTree.")
	print("")
end

function RTree:insertNodeByObject(o)
	local newNodeIndex = self:insertNodeRaw()
	local newNode = self.nodes[newNodeIndex]
	newNode.object = o
	newNode.AABB = o[self.master_name]
	self.nodeMapping[o] = newNode.index
	return newNode
end

function RTree:insertNodeRaw()
	local newNode = RTreeNode:new{left = -1, right = -1, parent = -1, index = -1}
	newNode.index = self:getNextEmptyIndex()
	if self:isEmpty() then self.root = newNode.index end
	self.nodes[newNode.index] = newNode
	
	return newNode.index
end

function RTree:mergeLeafIntoTree(attachNode, leafNode)

	-- print("Merge leaf into tree, index:", leafNode.index)
	
	local parentNodeIndex = self:insertNodeRaw()
	local parentNode = self.nodes[parentNodeIndex]
	-- print("Parent/Attach indices:", parentNode.index, attachNode.index)
	
	if attachNode.index == self.root then
		-- print("Attach node is the root.")
		self.root = parentNodeIndex
	else
		parentNode.parent = attachNode.parent
		local grandparentNode = self.nodes[parentNode.parent]
		for _, v in pairs({"left", "right"}) do
			-- print("GP check", v, grandparentNode[v])
			if grandparentNode[v] == attachNode.index then
				grandparentNode[v] = parentNode.index
			end
		end
	end
	attachNode.parent = parentNodeIndex
	leafNode.parent = parentNodeIndex
	parentNode.left = attachNode.index
	parentNode.right = leafNode.index
	self:maintainCoveringBoxesAscending(parentNode.index)
	-- print("Current root:", self.root)
	-- print("")
end

function RTree:removeLeafFromTree(leafNodeIndex)

	-- print("Removing leaf from tree, index:", leafNodeIndex)
	-- print("Master name:", self.master_name)
	-- print("Tree size:", #self.nodes)
	-- self:dumpSelf()

	if leafNodeIndex == self.root then
		-- print("Leaf is root", self.root)
		self.nodes[leafNodeIndex] = nil
		self.root = -1	
	else
		local leafNode = self.nodes[leafNodeIndex]
		local parentNode = self.nodes[leafNode.parent]	
		if parentNode.index == self.root then
			-- print("Parent is root", self.root)
			local siblingIsLeft = (parentNode.right == leafNodeIndex)
			local siblingNode = self.nodes[parentNode[siblingIsLeft and "left" or "right"]]
			self.nodes[parentNode.index] = nil
			self.nodes[leafNode.index] = nil
			self.root = siblingNode.index
		else
			-- print("Parent isn't root, dumping", leafNode.parent, parentNode.parent)
			local grandparentNode = self.nodes[parentNode.parent]
			local parentIsLeft = (grandparentNode.left == leafNode.parent)
			local siblingIsLeft = (parentNode.right == leafNodeIndex)
			local siblingNode = self.nodes[parentNode[siblingIsLeft and "left" or "right"]]

			grandparentNode[(parentIsLeft and "left" or "right")] = siblingNode.index
			siblingNode.parent = grandparentNode.index
			self.nodes[parentNode.index] = nil
			self.nodes[leafNode.index] = nil
			self:maintainCoveringBoxesAscending(grandparentNode.index)
		end
	end
end

function RTree:maintainCoveringBoxesAscending(index)
	local currentNode = self.nodes[index]
	if (currentNode:isLeaf() == false) then
		for i = 1, #self.nodes do
			-- print(self.nodes[i].AABB)
		end
		local newAABB = Rect.getCoveringRect(self.nodes[currentNode.left].AABB, self.nodes[currentNode.right].AABB)
		currentNode.AABB = newAABB
	end
	if (currentNode:isRoot() == false) then
		self:maintainCoveringBoxesAscending(currentNode.parent)
	end
end

function RTree:isEmpty()
	return self.root == -1
end

function RTree:getBestAttachByHeuristic(box, index) -- returns the heuristically best insertion point for a certain box.
	if self:isEmpty() then return -1 end
	
	local function heuristic(r)
		return r[3] + r[4] -- total circumference
	end

	local currentNode = self.nodes[index]
	
	if currentNode:isLeaf() then
		return index
	end
	
	local currentPerimeter = heuristic(currentNode.AABB)
	local combinedPerimeter = heuristic(Rect.getCoveringRect(currentNode.AABB, box))
	
	local currentCost = 2 * combinedPerimeter
	local combinedCost = 2 * (combinedPerimeter - currentPerimeter)
	
	local leftNode = self.nodes[currentNode.left]
	local rightNode = self.nodes[currentNode.right]
	
	local lCombinedRect = Rect.getCoveringRect(leftNode.AABB, box)
	local leftCost = combinedCost + heuristic(lCombinedRect) - (leftNode:isLeaf() and 0 or heuristic(leftNode.AABB))
	
	local rCombinedRect = Rect.getCoveringRect(rightNode.AABB, box)
	local rightCost = combinedCost + heuristic(rCombinedRect) - (rightNode:isLeaf() and 0 or heuristic(rightNode.AABB))
	
	if ((currentCost < leftCost) and (currentCost < rightCost)) then
		return index
	else
		return self:getBestAttachByHeuristic(box, ((leftCost < rightCost) and currentNode.left or currentNode.right))
	end
	
	-- heuristic should work by total boundary, I think
end

function RTree:deleteObject(o)
	local objectIndex = self:findObject(o)
	if objectIndex then
		self:removeLeafFromTree(objectIndex)
		self.nodeMapping[o] = nil
	end
end

function RTree:updateObject(o)
	self:deleteObject(o)
	self:insertObject(o)
end

function RTree:findObject(o)
	return (self.nodeMapping[o] or false)
end



--[[
function RTree:findObject(o)

	print("findObject diagnostics starting", o)
	print("Master name:", self.master_name)
	print("Size:", #self.nodes)
	

	-- given an object, return the (index of the) node the object resides in
	
	-- print("Entering find object, with obj = ", o)
	
	local objectBox = o[self.master_name]
	local nodeStack = Stack:new()
	
	nodeStack:push(self.nodes[self.root])
	
	while nodeStack:isEmpty() == false do
		
		local workingNode = nodeStack:pop()
		-- print("Stack size/index", #nodeStack - nodeStack.pointer + 2, workingNode.index)
		-- print("Left/Right indices", workingNode.left, workingNode.right)
		
		if workingNode:isLeaf() then
			-- print("Leaf", o, workingNode.object)
			if o == workingNode.object then
				print("Found object at node:", workingNode.index)
				print("")
				return workingNode.index
			end
		else
			local leftBox = self.nodes[workingNode.left].AABB
			local rightBox = self.nodes[workingNode.right].AABB
			-- print("Object box", objectBox[1], objectBox[2], objectBox[3], objectBox[4])
			-- print("Left box", leftBox[1], leftBox[2], leftBox[3], leftBox[4])
			-- print("Right box", rightBox[1], rightBox[2], rightBox[3], rightBox[4])
			if Rect.AABB(self.nodes[workingNode.left].AABB, objectBox) then 
				nodeStack:push(self.nodes[workingNode.left])
			end
			if Rect.AABB(self.nodes[workingNode.right].AABB, objectBox) then 
				nodeStack:push(self.nodes[workingNode.right])
			end
		end
	end
	print("Object could not be found. Returning false.")
	print("")
	
	return false
end
]]

function RTree:queryObject(o)
	return self:queryRectangle(o[self.master_name], o)
end

function RTree:queryRectangle(rect, object)
	local nodeStack = Stack:new()
	local queryResults = {}
	
	nodeStack:push(self.nodes[self.root])
	
	while nodeStack:isEmpty() == false do
		local workingNode = nodeStack:pop()
		if workingNode:isLeaf() then
			if object ~= workingNode.object then
				queryResults[#queryResults+1] = workingNode.object
			end
		else
			if Rect.AABB(self.nodes[workingNode.left].AABB, rect) then 
				nodeStack:push(self.nodes[workingNode.left])
			end
			if Rect.AABB(self.nodes[workingNode.right].AABB, rect) then 
				nodeStack:push(self.nodes[workingNode.right])
			end
		end
	end
	return queryResults
end

CollisionTree = RTree:new{master_name = "masterbox_coll", nodes = {}, root = -1, nodeMapping = {}}
DamageTree = RTree:new{master_name = "masterbox_damage", ndoes = {}, root = -1, nodeMapping = {}}


-- How movement is supposed to work
--[[

+ For all moving objects
  - Apply this frame's projected movement to the object. It consists of innate movement & any movement-modifying effects (like conveyor belts). Jot down the movement vector, update position.
  - Am I intersecting with any solid object & am I not solid myself? 
     * If so, modify my minimum translation vector, depending on my own momentum vs. the surface of impact.
  - Handle collision according to my minimum translation vector, and adjust my momentum accordingly.
+ For all moving, actor-type objects
  - Am I intersecting with any nonsolid object?
	 * Take the movement vectors of both nonsolids as well as their intersection MTV. Work out a solution proportional to their respective movement speeds.
]]

-- Dummy function

function DamageTree:step(mobj_table, dt)
	for i = 1, #mobj_table do
		local o = mobj_table[i]
		-- if o.hitstop == 0 then
			o:updateMasterboxes()
			self:updateObject(mobj_table[i])
		-- end
	end

	for i = 1, #mobj_table do
		local o = mobj_table[i]
		if o.hitstop == 0 then 
			local hit_events = self:checkHitboxEvents(o)
			
			for k1, v1 in pairs(hit_events) do
				for k2, v2 in pairs(v1) do
					if v2 then 
						genericHitFunction(k2:getHitEffect(k1), k1, k2) 
					end
				end
			end
			
			-- Find out what enemy hurtboxes this object's hitboxes are colliding with.
			-- Trigger onHit events for all enemies which are hit.
			-- (Later: Filter based on whether the hit has already hit once.)
		end
	end
end





function RTree:checkHitboxEvents(o)
	local box_a = o[self.master_name]
	local testObjects = self:queryObject(o)
	local hit_events = {}
	
	for i = 1, #testObjects do
		local obj_b = testObjects[i]
		if ((o ~= obj_b) and (o.team ~= obj_b.team) and (o.combatant and obj_b.combatant)) then
			local oaf = o:getFrame().hitboxes
			local obf = obj_b:getFrame().hurtboxes
			for k = 1, #oaf do
				for l = 1, #obf do
					local box_a = o:alignBox(oaf[k])
					local box_b = obj_b:alignBox(obf[l])
					if Rect.AABB(box_a, box_b) then -- if the attacker's hitboxes and the defender's hurtboxes intersect:
						hit_events[o] = hit_events[o] or {}
						hit_events[o][obj_b] = true -- set hit_events[attacker][defender] to true
					end
				end
			end
		end
	end
	return hit_events
	
end

function MapObject:checkHitbox(box)
	box = self:alignBox(box)
	local hitObjects = ActiveStage.damagetree:queryRectangle(box)
	local isHit = false
	for i = 1, #hitObjects do
		local obj_b = hitObjects[i]
		if ((self ~= obj_b) and (self.team ~= obj_b.team) and (obj_b.combatant)) then
			local obf = obj_b:getFrame().hurtboxes
			for l = 1, #obf do
				local box_b = obj_b:alignBox(obf[l])
				if Rect.AABB(box, box_b) then
					return true
				end
			end
		end
	end
	return false
end
	


function CollisionTree:fixCollisions(mobj_table, dt)
	for i = 1, #mobj_table do
		local o = mobj_table[i]
		local mtv = self:getHeavyMTV(o)
		if mtv[1] ~= 0 or mtv[2] ~= 0 then
			self:moveObject(o, mtv)
		end
		local lmtv = self:getLightMTV(o)
		if (lmtv[1] ~= 0 or lmtv[2] ~= 0) and o:getFrame().actor_collision then
			self:moveObject(o, lmtv)
		end
	end

end

function CollisionTree:step(mobj_table, dt) 
	-- Handle collisions with heavy objects
	for i = 1, #mobj_table do 
		local o = mobj_table[i]
		local oldPos = {o.position[1], o.position[2]}
		self:sweptMovement(o) 

		local mtv = self:getHeavyMTV(o) -- Find minimum translation vector with level geometry
		if mtv[1] ~= 0 or mtv[2] ~= 0 then 
			self:moveObject(o, mtv)
		end
		
		local lmtv = self:getLightMTV(o) -- Find minimum translation vector with other actors
		if (lmtv[1] ~= 0 or lmtv[2] ~= 0) and o:getFrame().actor_collision then 
			self:moveObject(o, lmtv)
		end
		
		o.deltaMovement = {(o.position[1] - oldPos[1]) * o.facing, o.position[2] - oldPos[2]}
	end
end

function RTree:getBroadphaseCandidates(o, cMV) -- input: mapobject, quadtree. output: all things overlapping the broadphase box of the object
	local box_a1 = o[self.master_name]
	local box_a2 = {box_a1[1] + cMV[1], box_a1[2] + cMV[2], box_a1[3], box_a1[4]}
	local box_a = o.generateMasterbox{box_a1, box_a2} -- this is the broadphase box
	return self:queryRectangle(box_a)
end

function sgn(x) -- sign function
	return (x < 0 and -1) or 1
end

-- Swept AABB patterned after a gamedev.net article on the topic

function RTree:getEntryTime(box1, box2, speed)
	local i_timings = {0, 0, 0, 0} -- in order: (inverse) x entry, y entry, x exit, y exit
	for j = 1, 2 do
		i_timings[j + ((1-sgn(speed[j])) % 3)] = box2[j] - (box1[j] + box1[j+2]) 
		i_timings[j + ((1+sgn(speed[j])) % 3)] = (box2[j] + box2[j+2]) - box1[j]
	end
	local timings = {0, 0, 0, 0} -- in order: x entry, y entry, x exit, y exit
	for k = 1, 2 do
		for l = 0, 1 do
			timings[k + 2*l] = (speed[k] ~= 0 and i_timings[k+2*l] / speed[k]) or (2*l-1)/0
		end
	end
	local entry_time = math.max(timings[1], timings[2])
	local exit_time = math.min(timings[3], timings[4])
	if (entry_time > exit_time or (timings[1] < 0 and timings[2] < 0) or (timings[1] > 1) or (timings[2] > 1)) then
		return 1, 0, 0 -- no collision
	else -- get collided normal and entry time. Axis-aligned only.
		return entry_time, 
		sgn(-i_timings[1]) * ((timings[1] > timings[2]) and 1 or 0), 
		sgn(-i_timings[2]) * ((timings[1] < timings[2]) and 1 or 0)
	end
end

function RTree:checkBPCandidate(o1, o2, cMV)
	local et, xx1, yy1 = self:getEntryTime(o1[self.master_name], o2[self.master_name], cMV)
	if o1 ~= o2 and et < 1 then
		local r = 1
		local xn, yn = 0, 0
		local c1 = o1:getCollboxes()
		local c2 = o2:getCollboxes()
		for i = 1, #c1 do --#TODO prolly need to change this if I want swept hit/hurt. Unlikely I will need swept hit/hurt though.
			if o2.heavy then
				for j = 1, #c2 do
					r1, xn1, yn1 = self:getEntryTime(c1[i], c2[j], cMV)
					if r1 < r then
						r, xn, yn = r1, xn1, yn1
					end
				end
			end
		end
		return r, xn, yn
	else 
		return 1, 0, 0
	end
end

function RTree:sweptMovement(o)
	-- o  == object to move
	-- fv == composite forces vector?
	-- mv == frame-based movement
	-- do NOT adjust the vector afterwards.

	local cMV = o:getCompositeMovement(true)

	local bpc_list = self:getBroadphaseCandidates(o, cMV)
	local a = 0
	while (a < 10) do -- should loop until it's done, a is max loops before forceful break
		local cc = 0
		local coll_time = 1
		local x_normal, y_normal = 0, 0
		for i = 1, #bpc_list do
			local cct, xxn, yyn = self:checkBPCandidate(o, bpc_list[i], cMV)
			if cct < coll_time then 
				coll_time, x_normal, y_normal = cct, xxn, yyn 
				cc = i
			end
		end
		self:moveObject(o, {cMV[1] * coll_time, cMV[2] * coll_time})
		if coll_time < 1 then
			local remtime = 1 - coll_time
			local dotprod = remtime * (x_normal * cMV[2] + y_normal * cMV[1])
			cMV[1] = dotprod * y_normal
			cMV[2] = dotprod * x_normal
			-- do the whole thing again
		else
			a = 10
		end
	end 
end

function RTree:getHeavyMTV(o) -- Given a full quadtree and an object, this function returns the composite MTV that shifts the object into a position of no collision. (usually)
	local mtv = {0, 0}
	local box_a = o[self.master_name]
	local objects = self:queryObject(o)
	for i = 1, #objects do
		local obj_b = objects[i]
		if ((o ~= obj_b) and (obj_b.heavy)) then
			if Rect.AABB(box_a, obj_b[self.master_name]) then				
				mtv = o:updateMTV(obj_b, mtv)
			end
		end
	end
	return mtv
end

function RTree:getLightMTV(o)
	local mtv1 = {0, 0}
	local box_a = o[self.master_name]
	local objects = self:queryObject(o)
	for i = 1, #objects do
		local obj_b = objects[i]		
		if ((o ~= obj_b) and (not (obj_b.heavy))) then 
			if Rect.AABB(box_a, obj_b[self.master_name]) then
				mtv1, mtv2 = o:getMTVPartition(obj_b, mtv1)
				if obj_b:getFrame().actor_collision and o:getFrame().actor_collision then
					self:moveObject(obj_b, mtv2)
				end
			end
		end
	end
	return mtv1
end

function MapObject:getMTVPartition(o2, mtv)
	local max_length_per_tick = 6

	local mtv = self:updateMTV(o2, mtv or {0, 0}, true)
	local partition = {0, 0}
	if mtv[1] ~= 0 or mtv[2] ~= 0 then
		-- Properly partition the MTV, depending on momentum
		-- for k = 1, 2 do
			-- if self.momentum[k] == o2.momentum[k] then
				-- partition = {0.5, 0.5}
			-- elseif math.abs(self.momentum[k]) > math.abs(o2.momentum[k]) then
				-- partition = {0, 1}
			-- else
				-- partition = {1, 0}
			-- elseif self.momentum[k] == 0 then
				-- partition = {1, 0}
			-- elseif o2.momentum[k] == 0 then
				-- partition = {0, 1}
				
			-- else
				-- local p = self.momentum[k] + o2.momentum[k] -- absolutes!
				-- partition = {self.momentum[k] / p, o2.momentum[k] / p}
			-- end
		-- end
		
		partition = {0, -1}
		-- This is coding in a nutshell.
		
	end
	-- for i = 1, 2 do
		-- if math.abs(mtv[1]) > max_length_per_tick then mtv[i] = (mtv[i] / math.abs(mtv[i])) * max_length_per_tick end
	-- end
	
	local mtv1 = {mtv[1] * partition[1], mtv[2] * partition[1]}
	local mtv2 = {mtv[1] * partition[2], mtv[2] * partition[2]}
	return mtv1, mtv2
end


function RTree:moveObject(obj, dv)
	obj.position[1] = obj.position[1] + dv[1]
	obj.position[2] = obj.position[2] + dv[2]
	obj:updateMasterboxes()
	self:updateObject(obj)
end

function MapObject:updateMTV(collider, old_mtv, force_horizontal)
	force_horizontal = force_horizontal or false
	old_mtv = old_mtv or {0, 0}
	
	local minabs = function (x, y) if math.abs(x) < math.abs(y) then return x else return y end end
	
	local cbox1 = self.masterbox_coll
	local cbox2 = collider.masterbox_coll
	local x_mtv = 0
	local y_mtv = 0
	local xd1 = cbox2[1] - cbox1[1] - cbox1[3]
	local xd2 = cbox2[1] + cbox2[3] - cbox1[1]
	local yd1 = cbox2[2] - cbox1[2] - cbox1[4]
	local yd2 = cbox2[2] + cbox2[4] - cbox1[2]
	local x_mtv = minabs(xd1, xd2)
	local y_mtv = minabs(yd1, yd2)

	if (math.abs(x_mtv) < math.abs(y_mtv)) or force_horizontal then y_mtv = 0 else x_mtv = 0 end
	if math.abs(x_mtv) > math.abs(old_mtv[1]) then old_mtv[1] = x_mtv end
	if math.abs(y_mtv) > math.abs(old_mtv[2]) then old_mtv[2] = y_mtv end
	
	return old_mtv
end

function RTree:testHorizontalLineObjects(x, w, y)
	local rect1 = {x, y, w, 1}
	local rect2 = {x, y-1, w, 1}

	local objs1 = self:queryRectangle(rect1)
	local objs2 = self:queryRectangle(rect2)

	local sumObjs = {}
	
	for k1, v1 in pairs(objs1) do
		for k2, v2 in pairs(objs2) do
			if (v1 == v2) and (v1.heavy) then
				table.insert(sumObjs, v1)
			end
		end
	end
	
	return sumObjs

	--line/object intersections happen


end





function MapObject:isGrounded()
	if self.interactive then
		local feet = Rect:new{self.position[1] - 10, self.position[2], 20, 5} -- This may apply to the feet too! Any 
		local objs = TestStage.colltree:queryRectangle(feet) -- remember to generalize this to the stage var at some point
		for i = 1, #objs do
			if objs[i].solid and objs[i] ~= self and Rect.AABB(objs[i].masterbox_coll, feet) then 
				return true
			end
		end
		return false
	end
	return true
end


function Rect.AABB(r1, r2) -- AABB for use in collision detection for when both rectangles are known to be unrotated

	-- is AABB stable with negative sides?
	-- r1 = 40, 0, -20, 20
	-- r2 = 30, 0, 5, 20
	-- 40 >= 30+5, terminate with false. Unstable.
	
	-- To stabilize: The following, inefficient algorithm. Whee
	-- Do that thing elsewhere instead. In the box placement - negative facing should mean that ox is shifted to the box breadth.
	
	for _, v in pairs{r1, r2} do
		for i = 3, 4 do
			if v[i] < 0 then 
				v[i-2] = v[i-2] + v[i]
				v[i] = v[i] * -1
			end
		end
	end
	
	
	

	if r1[1] >= r2[1] + r2[3] then
		return false
	end
	if r2[1] >= r1[1] + r1[3] then
		return false
	end
	if r1[2] >= r2[2] + r2[4] then
		return false
	end
	if r2[2] >= r1[2] + r1[4] then
		return false
	end
	return true
end

-- MapObjects are supposed to eventually have animation functionality, so they need to be converted to an state/frame-based system. Maybe differentiate between static/1anim/dynamically animated.

function MapObject:updateMasterboxes() -- as stated above, updating this at runtime might be inefficient, ever so slightly
	local base_mb_coll = self.generateMasterbox(self.collboxes)
	self.masterbox_coll = self:alignBox(base_mb_coll)
	if self.combatant then -- the reason to set your fucking combatant flag right
		--self.generateMasterbox({{0, 0, 0, 0}, {0, 0, 0, 0}})
		local base_mb_damage = self.generateMasterbox({self.generateMasterbox(self.hitboxes), self.generateMasterbox(self.hurtboxes)})
		self.masterbox_damage = self:alignBox(base_mb_damage)
	end
end


function MapObject.generateMasterbox(subboxes)
	if #subboxes > 0 then
		local masterbox = {unpack(subboxes[1])}
		for i = 1, #subboxes do
			local mb1 = subboxes[i]
			local mb2 = masterbox
			masterbox[1] = math.min(mb2[1], mb1[1])
			masterbox[2] = math.min(mb2[2], mb1[2])
			masterbox[3] = math.max(mb2[1] + mb2[3], mb1[1] + mb1[3]) - masterbox[1]
			masterbox[4] = math.max(mb2[2] + mb2[4], mb1[2] + mb1[4]) - masterbox[2]
		end
		return masterbox
	end
	return {0, 0, 0, 0}
end