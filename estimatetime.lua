function formatTime(seconds)
	local hours,minutes = 0,0
	if seconds > 60 then
		minutes = math.floor(seconds/60)
		seconds = seconds%60
	end
	if minutes > 60 then
		hours = math.floor(minutes/60)
		minutes = minutes%60
	end
	if hours == 0 then
		if minutes == 0 then
			return tostring(seconds).." seconds"
		else
			return tostring(minutes).." minutes "..tostring(seconds).." seconds"
		end
	else
		if minutes == 0 then
			return tostring(hours).." hours "..tostring(seconds).." seconds"
		else
			return tostring(hours).." hours "..tostring(minutes).." minutes "..tostring(seconds).." seconds"
		end
	end
end

local function getCost(x1,y1,z1,x2,y2,z2)
	local deltax,deltay,deltaz = math.abs(x2-x1),math.abs(y2-y1),math.abs(z2-z1)
	local turnCost = 1
	if deltay == 0 or deltaz == 0 then
		turnCost = 0	
	end
	local timeCost = deltax + deltay + deltaz + turnCost
	local fuelCost = deltax + deltay + deltaz
	return timeCost,fuelCost
end

function estimate(nObjective,instructions,x,y,z)
	assert(x,y,z)
	local fuelCost = 0
	local timeCost = 0
	--time to get from x,y,z to instructions[nObjective]
	local x0,y0,z0 = unpack(instructions[nObjective])
	local addTime0,addFuel0 = getCost(x,y,z,x0,y0,z0)
	fuelCost = addFuel0 + fuelCost
	timeCost = addTime0 + timeCost + 1
	
	for n = nObjective,#instructions-1 do
		--time to get from instructions[nObjective] to instructions[nObjective+1]
		local x1,y1,z1 = unpack(instructions[n],1,3)
		local x2,y2,z2 = unpack(instructions[n+1],1,3)
		local addTime,addFuel = getCost(x1,y1,z1,x2,y2,z2)
		local placeCost = 1
		fuelCost = fuelCost + addFuel
		timeCost = timeCost + addTime + placeCost
	end
	return fuelCost,timeCost*0.4
end

--local fuel,time = time_estimate(1,instructions,0,0,0)
--print(fuel," ",formatTime(time))