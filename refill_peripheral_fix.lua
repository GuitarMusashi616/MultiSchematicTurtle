--slots = textutils.unserialize( fs.open("slots","r").readAll() )
--nObjective = 1
--instructions = textutils.unserialize( fs.open("instructions","r").readAll() )



--instructions[n] = {x,y,z,id,data}

function getLength(checklist)
	local c = 0
	for i,v in pairs(checklist) do
		for k,l in pairs(v) do
			if l then
				c = c + 1
			end
		end
	end
	return c
end

function getSlotsUsed(checklist)
	local c = 0
	local count = 0
	for id,table in pairs(checklist) do
		for data,count in pairs(table) do
			c = c + math.ceil(count/64)
		end
	end
	return c
end

function sort()
	items = {}
	for i = 1,16 do
		local item = turtle.getItemDetail(i)
		if item then
			local pSlot = nil
			if items[item.name] then
				pSlot = items[item.name][item.damage]
			end
			if pSlot then
				turtle.select(i)
				turtle.transferTo(pSlot)
				if turtle.getItemCount(pSlot) == 64 then
					if turtle.getItemCount(i) > 0 then
						items[item.name][item.damage] = i
					else
						items[item.name][item.damage] = nil
					end
				end
			elseif turtle.getItemCount(i) < 64 then
				if not items[item.name] then
					items[item.name] = {}
				end
				items[item.name][item.damage] = i	
			end
		end
	end
end

local function add2checklist(checklist,name,damage,slots_available)
	--checklist[id][data] = count version
	--INPUT: item, checklist
	--OUTPUT: added to checklist if there's space
	slots_available = slots_available or 15
	local numCheckList = getSlotsUsed(checklist)
	
	if name == nil then
		return checklist
	end
	
	if checklist[name] and checklist[name][damage] then
		checklist[name][damage] = checklist[name][damage] + 1
		if getSlotsUsed(checklist) > slots_available then
			checklist[name][damage] = checklist[name][damage] - 1
			return checklist,true
		else
			return checklist
		end
	end
	
	if numCheckList < slots_available then
		if checklist[name] then
			checklist[name][damage] = 1
		else
			checklist[name] = {}
			checklist[name][damage] = 1
		end
	else
		--error("checklist full")
		return checklist,true
	end
	return checklist
end

function checklistMaker(nObjective,instructions,slots)
	--INPUT: nObjective,instructions,slots
	--OUTPUT: next 15 invo spaces worth of blocks required in checklist[id][data] = count
	local checklist = {}
	
	for i = nObjective,#instructions do
		local name,damage  = unpack(slots[ instructions[i][4] ][ instructions[i][5] ])
		checklist,bFull = add2checklist(checklist,name,damage,15)
		if bFull then
			return checklist
		end
	end

	return checklist
end

local function insert_rubbish(rubbishList,id,data,count)
	if not id then
			return
	end
	if not rubbishList[id] then
		rubbishList[id]= {}
	end
	if not rubbishList[id][data] then
		rubbishList[id][data] = 0
	end
	rubbishList[id][data] = rubbishList[id][data] + count
	return rubbishList
end

local function flatten_checklist(checklist,rubbishList)
	--get rid of negative count in checklist
	for id,table in pairs(checklist) do
		for data,count in pairs(table) do
			if count < 0 then
				rubbishList = insert_rubbish(rubbishList,id,data,math.abs(count))
				checklist[id][data] = 0
			end
		end
	end
	return checklist,rubbishList
end

function subtractInventory(checklist)
	local rubbishList = {}
	for i = 1,16 do
		local deets = turtle.getItemDetail(i)
		
		if deets then
			if checklist[deets.name] and checklist[deets.name][deets.damage] then
				checklist[deets.name][deets.damage] = checklist[deets.name][deets.damage] - deets.count
			elseif (not deets.name:lower():find("wrench")) and (not deets.name:lower():find("hammer")) then
			--not a wrench, not on the list
				insert_rubbish(rubbishList,deets.name,deets.damage,deets.count)
			end
		end
	end
	checklist,rubbishList = flatten_checklist(checklist,rubbishList)
	return checklist,rubbishList
end

function find_in_turtle(id,data)
	for i = 1,16 do
		local deets = turtle.getItemDetail(i)
		if deets and (deets.name == id and deets.damage == data) then
			return i,deets.count
		end
	end
	return nil
end

function throw_away(rubbishList,intoSlot)
	for id,table in pairs(rubbishList) do
		for data,count in pairs(table) do
			if count > 0 then
				local slot, amount = find_in_turtle(id,data)
				if amount >= count then
					--peripheral.call("bottom","pushItem","down",slot,count,intoSlot)
					rubbishList[id][data] = 0
				else
					local mem = turtle.getSelectedSlot()
					while amount < count do
						local i,amount_transferred = find_in_turtle(id,data)
						if i then
							turtle.select(i)
							turtle.transferTo(mem)
							local remainder = turtle.getItemCount()
							amount = amount + (amount_transferred-remainder)
						end
						
					end
					turtle.select(mem)
				end
			--pushItem(direction,slot,maxAmount?,intoSlot?)
			peripheral.call("bottom","pushItem","down",slot,amount,intoSlot)
			end
		end
	end
end



function save(table,filename)
	local h = fs.open(filename,"w")
	if fs.exists("textutilsFIX") then
		os.loadAPI("textutilsFIX")
		h.write(textutilsFIX.serialize(table))
	else
		h.write(textutils.serialize(table))
	end
	h.close()
end
--throwAway file 

function db(entity,name)
	local h = fs.open("console","a")
	name = name or ""
	os.loadAPI("textutilsFIX")
	if type(entity) == "table" then
		h.writeLine(name..": "..textutilsFIX.serialize(table))
	else
		h.writeLine(name..": "..tostring(entity))
	end
	h.close()
end

function find_in_turtle(id,data)
	for i = 1,16 do
		local deets = turtle.getItemDetail(i)
		if deets and (deets.name == id and deets.damage == data) then
			return i,deets.count
		end
	end
	return nil
end

function findEmptySlots(chest)
	local randomTable = {}
	for i,v in pairs(chest) do
		table.insert(randomTable,i)
	end
	return #randomTable
end

function findEmptySlotsOLD(chest,inv)
	local emptySlots = 0
	for i = 1,inv do
		if chest[i] == nil then
			emptySlots = emptySlots + 1
		end
	end
	return emptySlots
end

function throwAway2(rubbishList,chest,invType)
	local emptySlots = findEmptySlots(chest)
	assert(emptySlots)
	--print("emptySlots = ",emptySlots)
	for i = 1,16 do
		local count = nil
		local deets = turtle.getItemDetail(i)
		if rubbishList and deets and rubbishList[deets.name] then
			count = rubbishList[deets.name][deets.damage]
		end
		if (count and count > 0) and (emptySlots > 0 or invType == "TileInterface") then
			turtle.select(i)
			local amount = turtle.getItemCount(i)
			if amount > count then
				turtle.dropDown(count)
				count = 0
			elseif count <= 64 then
				turtle.dropDown(count)
				count = 0
			else
				turtle.dropDown()
				count = count - 64
			end
			emptySlots = emptySlots - 1
			rubbishList[deets.name][deets.damage] = count
		end
	end
	return rubbishList
end

function take(chest_slot,amount,me,chest)
	sort()
	if me then
		peripheral.call("bottom","exportItem",chest[chest_slot].fingerprint,"up",amount)
	else
		peripheral.call("bottom","pushItem","up",chest_slot,amount)
	end
end

function take2(chest_slot,amount)
	assert(chest_slot)
	amount = amount or 64
	peripheral.call("bottom","swapStacks",chest_slot,1)
	turtle.suckDown(amount)
end

function pullBlocks(checklist,chest,invType)
	local me = false
	if invType == "TileInterface" then
		me = true
	end
	assert(checklist)
	assert(chest)
	for chest_slot,func in pairs(chest) do
		local name,damage,qty
		if me then
			name = func.fingerprint.id
			damage = func.fingerprint.dmg
			qty = func.size
		else
			name = func.basic().id
			db(name,chest_slot)
			damage = func.basic().dmg
			db(damage,"dmg")
			qty = func.basic().qty
			db(qty,"qty")
		end
		local checklist_count = nil
		if checklist and checklist[name] then
			checklist_count = checklist[name][damage]
		end
		if checklist_count and checklist_count > 0 then
			if checklist_count <= qty then
				--take checklist_count amount
				take(chest_slot,checklist_count,me,chest)
				checklist_count = 0
				db(name,"    name")
				db(checklist_count,"    checklist_count")
				db(qty,"    qty")
			elseif checklist_count>=64 then
				--take 64
				take(chest_slot,64,me,chest)
				checklist_count = checklist_count - 64
				db(name,"    name")
				db(checklist_count,"    checklist_count")
				db(qty,"    qty")
			elseif checklist_count > qty then
				--take qty
				take(chest_slot,qty,me,chest)
				checklist_count = checklist_count - qty
				db(name,"    name")
				db(checklist_count,"    checklist_count")
				db(qty,"    qty")
			else
				db(name,"    NOT COUNTED")
				db(damage)
				db(qty)
			end
			
			
			checklist[name][damage] = checklist_count
		end
	end
	return checklist
end

function check_chests(checklist,rubbishList)	
	goto(reference.finalx+1,reference.returny,reference.returnz)
	goto(reference.returnx,reference.returny,reference.returnz)

	local i = 1
	local noInvo = 0
	local numChests = 0
	while true do
		goto(reference.returnx,reference.returny,reference.returnz-i+1)		

		local invType = false 
		local lookSee,lookData = turtle.inspectDown()
		if lookSee then
			if lookData.name:find("chest") then
				invType = true
			elseif lookData.name:find("tile.BlockInterface") then
				invType = "TileInterface"
			end
		end


		if invType then
			local bool,chest
			if invType == "TileInterface" then
				bool,chest = pcall(peripheral.call,"bottom","getAvailableItems")
			else
				bool,chest = pcall(peripheral.call,"bottom","getAllStacks")
			end
			if not bool then
				print(chest)
				if invType == "TileInterface" then
					turtle.select(1)
					turtle.dropDown(64)
					turtle.digDown()
					turtle.placeDown()
					sleep(0.5)
				end
				os.reboot()
			end
			rubbishList = throwAway2(rubbishList,chest,invType)
			checklist = pullBlocks(checklist,chest,invType)
			noInvo = 0
			numChests = numChests + 1
			if invType == "TileInterface" and not reference.numChests then
				reference.numChests = numChests
				updateVar(reference.filename,"reference.numChests",numChest) 
				break
			end
			
			if reference.numChests == numChests then
				--print("ok stop here")
				break
			end
			
		else
			noInvo = noInvo + 1
			if noInvo == 2 and numChests == 0 then
				error("needs refill chest within 2 blocks behind start location under the turtle")
			end
			if noInvo == 3 then
				reference.numChests = numChests
				updateVar(reference.filename,"reference.numChests",numChest) --needs testing
				break
			end
		end
		
		i = i + 1
	end
	save(rubbishList,"rubbishList")
	save(checklist,"checklist")	
	--local x,y,z,id,data = unpack(instructions[nObjective])
	--goto(reference.finalx+1,y,z)
end


--checklist = checklistMaker(1,instructions,slots)
--checklist, rubbishList = subtractInventory(checklist)

--save(checklist,"checklist")
--save(rubbishList,"rubbishList")