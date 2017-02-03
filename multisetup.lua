local tArgs = {...}

if #tArgs == 0 then
	error("please select blueprint file")
end

if not fs.exists(tArgs[1]) then
	error(tArgs[1].. " does not exists")
end

if not fs.exists("turtle") then
	shell.run("pastebin get 7mnsWVwz turtle")
end

if fs.exists("startLocations") then
	startLocations = textutils.unserialize( fs.open("startLocations","r").readAll() )
end

rs.setOutput("left",false)
local function find(keyword)
	for i = 1,16 do
		local item = turtle.getItemDetail(i)
		if item and item.name:lower():find(keyword:lower()) then
			return i
		end
	end
end

function countBlocks(instructions)
	uniqueblocks={}
    for n = 1,#instructions do
		local blockID,data = unpack(instructions[n],4,5)
        found = false
        for j,w in ipairs(uniqueblocks) do
 
            if (w.blockID==blockID) and (w.data==data) then
                found = true
                w.amount = w.amount + 1
                break
            end
        end
 
        if found==false then
            uniqueblocks[#uniqueblocks+1] = {}
            uniqueblocks[#uniqueblocks].blockID = blockID
            uniqueblocks[#uniqueblocks].data = data
            uniqueblocks[#uniqueblocks].amount = 1
        end
    end
	return uniqueblocks
end

function printMaterials(uniqueblocks,slots)
	local w,h = term.getSize()
	local buffer = {}

	buffer[#buffer+1] = "Controls:"
	buffer[#buffer+1] = ""
	buffer[#buffer+1] = "use arrowkeys or scrollwheel to scroll"
	buffer[#buffer+1] = "press x to refuel"
	buffer[#buffer+1] = "press a when all materials are accounted for"
	buffer[#buffer+1] = ""

	for i,v in pairs(uniqueblocks) do
		--print(v.blockID,",",v.data,"=",v.amount)
		local t = slots[v.blockID][v.data]
		buffer[#buffer+1] = "- "..tostring(t[1])..","..tostring(t[2])
		buffer[#buffer+1] = "    "..tostring(v.amount)
		if v.amount > 64 then
			buffer[#buffer] = buffer[#buffer] .. " ("..tostring(math.ceil(v.amount/64)).." stacks)"
		end
	end
	
	local function displayTime(instructions,reference,buffer)
		if fs.exists("time") then
			shell.run("time")
			local fuel,time = estimate(1,instructions,reference.startx,reference.starty,reference.startz)
			buffer[#buffer+1] = ""
			buffer[#buffer+1] = "estimated_time: "..formatTime(time)
			buffer[#buffer+1] = "minimum_fuel_cost: "..tostring(fuel)
		end
	end
				
	displayTime(instructions,reference,buffer)
	buffer[#buffer+1] = ""
	if reference.wrench then
		buffer[#buffer+1] = "make sure I have a wrench"
	else
		buffer[#buffer+1] = "no wrench required"
	end
	
	local function display(buffer,n)
		shell.run("clr")
		local a = 1
		for i = n,#buffer do
			term.setCursorPos(1,a)
			--term.clearLine()
			term.write(buffer[i])
			a = a + 1
		end
	end

	local n = 1
	display(buffer,n)
	while true do
		local event = {os.pullEvent()}
		if event[1] == "mouse_scroll" then
			if event[2] == 1 and n < #buffer then
				n = n + 1
				display(buffer,n)
			elseif event[2] == -1 and n > 1 then
				n = n - 1 
				display(buffer,n)
			end
		end
		if event[2] == "x" then
			shell.run("refuel 64")
			buffer[#buffer+1] = "fuel: "..tostring(turtle.getFuelLevel())
			display(buffer,n)
		end
		if event[2] == "a" then
			shell.run("clr")
			break
		end
	end
end
		

function files2disk()
	local files = {"refill","setup","textutilsFIX","time","turtle"}
	
	for _,v in pairs(files) do
		if fs.exists(v) and fs.exists("disk/"..tostring(v)) == false then
			shell.run("copy "..tostring(v).." disk")
		end
	end
end

function transferBlueprint(nTurtle)
	
	assert(nTurtle~=1,"nTurtle = 1!")
	local v = startLocations[nTurtle]
	assert(v)
	local ref = {}
	for i,v in pairs(reference) do
		 ref[i] = v
	end
	assert(ref)
	ref.starty = v.starty
	ref.startz = v.startz
	ref.finaly = v.finaly
	ref.finalz = v.finalz
	assert(ref.startx)
	assert(v.starty)
	assert(ref.finalx)
	assert(v.finaly)
	local ins = blueprint(ref.startx,v.starty,v.startz,ref.finalx,v.finaly,v.finalz)
	if tArgs[2] == "tsp" then
		ins = improveBlueprint(ins,ref.startx,ref.starty,ref.startz,ref.finalx,ref.finaly,ref.finalz)
	end
	local fname = saveBlueprint(ref,slots,ins,uniqueblocks,nTurtle)
	print(fname," saved")
	
	shell.run("copy "..tostring(fname).." disk")
	shell.run("rm "..tostring(fname))
	--[[for i,v in pairs(fs.list(shell.dir())) do
		if v:find("["..tostring(nTurtle).."]") then
			shell.run("copy "..tostring(v).." disk")
			if nTurtle ~= 1 and not v:find("[1]") then
				shell.run("rm "..tostring(v))
			end
		end
	end]]
end

function setPosition(nTurtle,heightPos,widthPos,lengthPos,face)
	nTurtle = tostring(nTurtle)
	local h = fs.open("pos"..nTurtle,"w")
	h.writeLine("heightPos = "..tostring(heightPos)..";")
	h.writeLine("widthPos = "..tostring(widthPos)..";")
	h.writeLine("lengthPos = "..tostring(lengthPos)..";")
	h.writeLine("face = "..tostring(face)..";")
	h.close()
	shell.run("copy pos"..nTurtle.." disk")
end

function Main()
	shell.run("turtle reset")
	if turtle.getFuelLevel() < 200 then
		error("more fuel required")
	end

	shell.run(tArgs[1])

	print("Please put ...\n"..tonumber(reference.multiturtle).." turtles(any type),\n1 disk, and \n1 diskDrive in inventory\n")
	print("press any key to continue")
	os.pullEvent("char")
	for i = 2,reference.multiturtle do
		turtle.select(find("turtle"))
		local nTurtle = i
		goto(reference.startx,reference.starty+i-1,reference.startz-1)
		turn("south")
		turtle.place()
		turtle.select(find("peripheral"))
		goto(reference.startx+1,reference.starty+i-1,reference.startz-1)
		turn("south")
		turtle.place()
		turtle.select(find("computercraft:disk"))
		turtle.drop()
		--copyFiles(i)
		do
			files2disk()
			transferBlueprint(nTurtle)
			--setPosition(nTurtle,heightPos-1,widthPos,lengthPos-1,face)
			local disk = fs.open("disk/startup","w")
			disk.write([[
			local function disk2turtle(nTurtle)
				local files = {"refill","setup","textutilsFIX","time","turtle"}
				for i,v in pairs(fs.list("disk")) do
					if v:find("["..tostring(nTurtle).."]") then
						shell.run("copy disk/"..tostring(v).." "..tostring(v))
						shell.run("rm disk/"..tostring(v))
					end
				end
				for i,v in pairs(files) do
					if fs.exists("disk/"..tostring(v)) then
						shell.run("copy disk/"..tostring(v).." "..tostring(v))
					end
				end
			end
			
			local function checkWrench()
				for i = 1,16 do
					local item = turtle.getItemDetail(i)
					if item then
						local possible = item.name:lower()
						print(possible)
						if possible:find("wrench") or possible:find("hammer") then
							return true
						end
					end
				end
				return false
			end

			function countBlocks(instructions)
				uniqueblocks={}
				for n = 1,#instructions do
					local blockID,data = unpack(instructions[n],4,5)
					found = false
					for j,w in ipairs(uniqueblocks) do
			 
						if (w.blockID==blockID) and (w.data==data) then
							found = true
							w.amount = w.amount + 1
							break
						end
					end
			 
					if found==false then
						uniqueblocks[#uniqueblocks+1] = {}
						uniqueblocks[#uniqueblocks].blockID = blockID
						uniqueblocks[#uniqueblocks].data = data
						uniqueblocks[#uniqueblocks].amount = 1
					end
				end
				return uniqueblocks
			end

			function printMaterials(uniqueblocks,slots)
				local w,h = term.getSize()
				local buffer = {}

				buffer[#buffer+1] = "Controls:"
				buffer[#buffer+1] = ""
				buffer[#buffer+1] = "use arrowkeys or scrollwheel to scroll"
				buffer[#buffer+1] = "press x to refuel"
				buffer[#buffer+1] = "press a when all materials are accounted for"
				buffer[#buffer+1] = ""

				for i,v in pairs(uniqueblocks) do
					--print(v.blockID,",",v.data,"=",v.amount)
					local t = slots[v.blockID][v.data]
					buffer[#buffer+1] = "- "..tostring(t[1])..","..tostring(t[2])
					buffer[#buffer+1] = "    "..tostring(v.amount)
					if v.amount > 64 then
						buffer[#buffer] = buffer[#buffer] .. " ("..tostring(math.ceil(v.amount/64)).." stacks)"
					end
				end
				
				local function displayTime(instructions,reference,buffer)
					if fs.exists("time") then
						shell.run("time")
						local fuel,time = estimate(1,instructions,reference.startx,reference.starty,reference.startz)
						buffer[#buffer+1] = ""
						buffer[#buffer+1] = "estimated_time: "..formatTime(time)
						buffer[#buffer+1] = "minimum_fuel_cost: "..tostring(fuel)
					end
				end
				
				displayTime(instructions,reference,buffer)
				
				buffer[#buffer+1] = ""
				if reference.wrench then
					buffer[#buffer+1] = "make sure I have a wrench"
				else
					buffer[#buffer+1] = "no wrench required"
				end

				local function display(buffer,n)
					shell.run("clr")
					local a = 1
					for i = n,#buffer do
						term.setCursorPos(1,a)
						--term.clearLine()
						term.write(buffer[i])
						a = a + 1
					end
				end
			
				local n = 1
				display(buffer,n)
				while true do
					local event = {os.pullEvent()}
					if event[1] == "mouse_scroll" then
						if event[2] == 1 and n < #buffer then
							n = n + 1
							display(buffer,n)
						elseif event[2] == -1 and n > 1 then
							n = n - 1 
							display(buffer,n)
						end
					end
					if event[2] == "x" then
						shell.run("refuel 64")
						buffer[#buffer+1] = "fuel: "..tostring(turtle.getFuelLevel())
						display(buffer,n)
					end
					if event[2] == "a" then
						local ready = true
						if turtle.getFuelLevel() < 200 then
							buffer[#buffer+1] = "needs more fuel to start"
							ready = false
						end
						if not checkWrench() then
							buffer[#buffer+1] = "needs a wrench"
							ready = false
						end
						if ready then
							buffer[#buffer+1] = "ready to go!, waiting on rs signal"
						end
						display(buffer,n)
					end
					if event[1] == "redstone" then
						shell.run("clr")
						break
					end
				end
			end


			if not fs.exists("refill") and not fs.exists("turtle") then 
				disk2turtle(]]..nTurtle..[[)
				shell.run("copy disk/startup startup")
				rs.setOutput("back",true)
				sleep(5)
				rs.setOutput("back",false)
			end
			shell.run("turtle ]]..tostring(heightPos-1).." "..tostring(widthPos).." "..tostring(lengthPos+1).." "..tostring(face)..[[")
			local filename
			for _,v in pairs(fs.list(shell.dir())) do
				if v:find("blueprint") then
					filename = v
					shell.run(v)
				end
			end
			assert(updateVar)
			assert(filename)
			assert(reference.returnx)
			assert(heightPos)
			updateVar(filename,"reference.returnx",]]..tostring(heightPos-1)..[[)
			updateVar(filename,"reference.returny",]]..tostring(widthPos)..[[)
			updateVar(filename,"reference.returnz",]]..tostring(lengthPos)..[[)


			local ublocks = countBlocks(instructions)
			printMaterials(ublocks,slots)
			
			--send pulse through turtles to start
			--turtles only start if all are ready
			
			shell.run("setup "..filename)
			rs.setOutput("left",true)
			sleep(1)
			rs.setOutput("left",false)
			shell.run("startup")
			]])
			disk.close()
		end
		
		goto(reference.startx,reference.starty+i-1,reference.startz-1)
		turn("south")
		peripheral.call("front","turnOn")
		os.pullEvent("redstone")
		goto(reference.startx+1,reference.starty+i-1,reference.startz-1)
		turn("south")
		turtle.suck()
		turtle.dig()
	end
	goto(reference.startx,reference.starty,reference.startz-1)
	turn("south")
	goto(reference.startx,reference.starty,reference.startz)
end

function back2home()
	goto(0,0,0)
	turn("south")
end

function start()
	--shell.run(tArgs[1])
	--fuelcheck
	--materialscheck
	shell.run("setup "..tArgs[1])
	rs.setOutput("left",false)
	print("Starting... ")
	sleep(1.5)
	rs.setOutput("left",true)
	shell.run("startup")
end

Main()
local ublocks = countBlocks(instructions)
printMaterials(ublocks,slots)
print("type \"start\" when all turtles are ready")
local s = read()
if s == "start" then
	start()
end
