--fs.open("simulate","w").write(http.post("http://pastebin.com/raw/Th40FmCz").readAll())
--estimation needs rework

turtle = {}
gRuntime = 0
selectTime = 0

runtimeHistory = {}
select = 1
inventory = {
	[1] = {name = "minecraft:wool",damage = 4,count = 32},
	[2] = {name = "minecraft:fence",damage = 0,count = 6},
	[3] = {name = "minecraft:wool",damage = 0,count = 64},
	[4] = {name = "minecraft:wool",damage = 0,count = 64},
	[5] = {name = "minecraft:wool",damage = 0,count = 64},
	[6] = {name = "minecraft:wool",damage = 0,count = 64},
	[7] = {name = "minecraft:wool",damage = 0,count = 64},
	[8] = {name = "minecraft:wool",damage = 0,count = 1},
	[9] = {name = "minecraft:wooden_slab",damage = 0,count = 2},
	[10] = {name = "minecraft:torch",damage = 0,count = 4},
	[11] = {name = "minecraft:wool",damage = 14,count = 14},
	[12] = {name = "minecraft:planks",damage = 0,count = 48},
	[13] = {name = "minecraft:snow_layer",damage = 0,count = 8},
	[14] = {name = "minecraft:wool",damage = 15,count = 2},
	[15] = nil,
	[16] = nil,
}

function getRuntime()
	local estimatedRuntime = (gRuntime-1*.4) + .05 + (selectTime * .05)
	return estimatedRuntime
end

function turtle.getItemDetail(i)
	if i then
		return inventory[i]
	else
		return inventory[select]
	end
end

function turtle.inspect()
	return true
end

function turtle.inspectDown()
	return true
end

function turtle.getItemCount()
	if inventory[select] then
		return inventory[select].count
	else
		return 0
	end
end

function turtle.digDown()
	gRuntime = gRuntime + 1
	return true
end

function turtle.dig()
	gRuntime = gRuntime + 1
	return true
end


function turtle.forward()
	gRuntime = gRuntime + 1
	return true
end

function turtle.back()
	gRuntime = gRuntime + 1
	return true
end

function turtle.up()
	gRuntime = gRuntime + 1
	return true
end

function turtle.down()
	gRuntime = gRuntime + 1
	return true
end

function turtle.turnLeft()
	gRuntime = gRuntime + 1
	return true
end

function turtle.turnRight()
	gRuntime = gRuntime + 1
	return true
end

function turtle.placeDown()
	gRuntime = gRuntime + 1
	return true
end

function turtle.place()
	gRuntime = gRuntime + 1
	return true
end

function turtle.refuel()
	return true
end

function turtle.transferTo()
	return true
end

function turtle.getFuelLevel()
	return 15000
end

function turtle.select(n)
	select = n
	selectTime = selectTime + 1
	return select
end

function turtle.getSelectedSlot()
	return select
end

function turtle.getRuntime()
	return tostring(gRuntime).." seconds"
end