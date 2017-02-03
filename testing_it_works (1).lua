--no pastebin? no problem!
--fs.open("setup","w").write(http.post("http://pastebin.com/raw/8Th5VpE5").readAll())

local tArgs = {...}
--local filename

function get(name,address)
    local response = nil
    local tmp = fs.open(name,"w")
    local function setColor(color)
        if term.isColor() then
            term.setTextColor(color)
        end
    end
    setColor(colors.yellow)
    if address:sub(1,4) == "http" then
        write("Connecting to Github.com... ")
        response = http.get(address)
    else
        write("Connecting to Pastebin.com... ")
        response = http.get("http://pastebin.com/raw/"..tostring(address))
    end
    if response then
        setColor(colors.green)
        print("Success")
        tmp.write( response.readAll() )
        tmp.close()
        setColor(colors.white)
        return true
    else
        setColor(colors.red)
        print("Failed")
        setColor(colors.white)
        return false
    end
end

if tArgs[1] == "download" or tArgs[1] == "dl" then
	get("market","BztihKh3")
	get("refill","cds0sp3C")
	get("time","6zRMTLyF")
	get("turtle","7mnsWVwz")
	get("blueprint","kQ7xueqL")
	get("simulate","Th40FmCz")
	get("multisetup","y7t1FUbY")
	return
else
	assert(tArgs[1],"no tArgs[1]")
	if not fs.exists(tArgs[1]) then
		error("File non existent")
	end
end

if not fs.exists("turtle") then
	error("dont forget to dl the api skrub")
end
	--shell.run("turtle reset")

function file2table(filename)
	local h = fs.open(filename,"r")
	local sOutput = h.readAll()
	sOutput = textutils.unserialize(sOutput)
	h.close()
	return sOutput
end

--slots = textutils.unserialize(fs.open("slots","r").readAll())



--  dynamic method  --

function recordStep(n)
    local h = fs.open("nObjective",'w')
    h.writeLine("nObjective = "..tostring(n))
    h.close()
end

--  deprecated  --


local startup = [[
	
--  reference  --

	shell.run("]]..tostring(tArgs[1])..[[")
	reference.filename = "]]..tostring(tArgs[1])..[["

--  startup  --

	shell.run("turtle") --runs position
	shell.run("nObjective")
	shell.run("time")

	--if nObjective <= #instructions then --goes to height on startup so it doesnt break other blocks
		--could also try refilling first
		local x,y,z,id,data = unpack(instructions[nObjective])
		goto(reference.finalx+1,y,z)
	--end
	
	local function setLine(n)
		term.setCursorPos(1,n)
		term.clearLine()
		term.setCursorPos(1,n)
	end
	
	local function setColor(c)
		if term.isColor() then
			term.setTextColor(c)
		end
	end

	local function a1()
		while true do
			--break and return when finished
			if nObjective > #instructions then
				return true
			end
			--repeat 
			local x,y,z,id,data = unpack(instructions[nObjective])
			goto(x+1,y,z)
			findAndPlace(id,data,slots,reference.wrench)
			nObjective = nObjective + 1
			recordStep(nObjective)
		end
	end

	local function b1()
		while true do
			setLine(1)
			setColor(colors.yellow)
			term.write("CurrentPosition: ")
			setColor(colors.white)
			term.write(heightPos..","..widthPos..","..lengthPos..","..face)
			setLine(2)
			if nObjective > #instructions then
				return true
			end
			local id,data = unpack(instructions[nObjective],4,5)
			local name,dmg = nil,nil
			if slots[id] and slots[id][data] then
				name,dmg = unpack(slots[id][data])
			end
			setColor(colors.yellow)
			term.write("NextBlock: ")
			setColor(colors.white)
			term.write(tostring(name)..","..tostring(dmg))
			setLine(4)
			local fuelCost,timeRemaining = estimate(nObjective,instructions,heightPos,widthPos,lengthPos)
			setColor(colors.yellow)
			term.write("Time Remaining: ")
			setColor(colors.white)
			term.write(formatTime(timeRemaining))
			setLine(5)
			setColor(colors.yellow)
			term.write("fuelCost: ")
			setColor(colors.white)
			term.write(fuelCost)
			setLine(6)
			setColor(colors.yellow)
			term.write("fuelLevel: ")
			setColor(colors.white)
			term.write(turtle.getFuelLevel())
			sleep(0.4)
		end
	end

	parallel.waitForAny(a1,b1)

	shell.run("clr")
	print("finished")
	goto(reference.finalx+1,reference.returny,reference.returnz)
	turn("south")
	goto(reference.returnx,reference.returny,reference.returnz)

	shell.run("rm startup")
]]

local h = fs.open("startup","w")
h.write(startup)
h.close()

if fs.exists("time") then
	shell.run(tArgs[1])
	shell.run("time")
	local fuelCost,timeRemaining = estimate(1,instructions,0,0,0)
	print("Estimated Time: "..formatTime(timeRemaining))
	print("Fuel Cost: "..fuelCost)
	if fuelCost > turtle.getFuelLevel() then
		error("requires at least"..tostring( tonumber(fuelCost)-turtle.getFuelLevel() ).." more fuel")
	end
end
recordStep(1)
shell.run("turtle")
for i = 1,2 do
	term.scroll(i)
	sleep(0)
end
print("all set, reboot to start")