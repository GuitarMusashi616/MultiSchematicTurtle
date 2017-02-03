--made by me
--setup() made by orwell

local tArgs = { ... }
if #tArgs < 1 then
  error("Usage: blueprint <gunzipped schematic file>")
end

if not fs.exists("textutilsFIX") then
	shell.run("pastebin get 3wguFBXn textutilsFIX")
end

if not fs.exists("grid") then
	shell.run("pastebin get EjYUEQqx grid")
end

shell.run("grid")
os.loadAPI("textutilsFIX")

local filename = tArgs[1]

if not fs.exists(filename) then
  error("File does not exist.")
end

function save(table,name)
	local h = fs.open(name,"w")
	table = textutilsFIX.serialize(table)
	h.write(table)
	h.close()
end

function saveIns(name,table)
	local h = fs.open(name,"w")
	h.writeLine(name.." = {}")
	for i,coord in pairs(table) do
		h.writeLine(name.."["..i.."] = {"..table.concat(coord,",").."}")
		h.flush()
	end
	h.close()
end

function saveBlueprint(reference,slots,instructions,uniqueblocks,nTurtle)
	local fname = filename:gsub("%.(.*)","")..".blueprint"
	if nTurtle then
		fname = fname.."["..tostring(nTurtle).."]"
	end
	local h = fs.open(fname,"w")
	h.writeLine("reference ="..textutils.serialize(reference)..";")
	h.writeLine("slots = "..textutils.serialize(slots)..";")
	h.writeLine("uniqueblocks = "..textutils.serialize(uniqueblocks)..";")
	h.writeLine("instructions = "..textutilsFIX.serialize(instructions)..";")
	h.close()
	return fname
end

local block_id = {}

block_id[0] = "Air"
block_id[1] = "Stone"
block_id[2] = "Grass"
block_id[3] = "Dirt"
block_id[4] = "Cobblestone"
block_id[5] = "Wood Planks"
block_id[6] = "Sapling"
block_id[7] = "Bedrock"
block_id[8] = "Water"
block_id[9] = "Stationary water"
block_id[10] = "Lava"
block_id[11] = "Stationary lava"
block_id[12] = "Sand"
block_id[13] = "Gravel"
block_id[14] = "Gold Ore"
block_id[15] = "Iron (Ore)"
block_id[16] = "Coal Ore"
block_id[17] = "Wood"
block_id[18] = "Leaves"
block_id[19] = "Sponge"
block_id[20] = "Glass"
block_id[21] = "Lapis Lazuli (Ore)"
block_id[22] = "Lapis Lazuli (Block)"
block_id[23] = "Dispenser"
block_id[24] = "Sandstone"
block_id[25] = "Note Block Tile entity"
block_id[26] = "Bed"
block_id[27] = "Powered Rail "
block_id[28] = "Detector Rail "
block_id[29] = "Sticky Piston"
block_id[30] = "Cobweb"
block_id[31] = "Tall Grass"
block_id[32] = "Dead Bush"
block_id[33] = "Piston"
block_id[34] = "Piston Extension"
block_id[35] = "Wool"
block_id[36] = "Block moved by Piston"
block_id[37] = "Dandelionandelion"
block_id[38] = "Rose"
block_id[39] = "Brown Mushroom"
block_id[40] = "Red Mushroom"
block_id[41] = "Block of Gold"
block_id[42] = "Block of Iron"
block_id[43] = "Double Slabs"
block_id[44] = "Slabs"
block_id[45] = "Brick Block"
block_id[46] = "TNT"
block_id[47] = "Bookshelf"
block_id[48] = "Moss Stone"
block_id[49] = "Obsidian"
block_id[50] = "Torch"
block_id[51] = "Fire"
block_id[52] = "Monster Spawner"
block_id[53] = "Wooden Stairs"
block_id[54] = "Chest"
block_id[55] = "Redstone (Wire)"
block_id[56] = "Diamond (Ore)"
block_id[57] = "Block of Diamond"
block_id[58] = "Crafting Table"
block_id[59] = "Seeds"
block_id[60] = "Farland"
block_id[61] = "Furnace"
block_id[62] = "Burning Furnace"
block_id[63] = "Sign Post"
block_id[64] = "Wooden Door"
block_id[65] = "Ladders"
block_id[66] = "Rails"
block_id[67] = "Cobblestone Stairs"
block_id[68] = "Wall Sign"
block_id[69] = "Lever"
block_id[70] = "Stone Pressure Plate"
block_id[71] = "Iron Door"
block_id[72] = "Wooden Pressure Plates"
block_id[73] = "Redstone Ore"
block_id[74] = "Glowing Redstone Ore"
block_id[75] = "Redstone Torch"
block_id[76] = "Redstone Torch"
block_id[77] = "Stone Button "
block_id[78] = "Snow"
block_id[79] = "Ice"
block_id[80] = "Snow Block"
block_id[81] = "Cactus"
block_id[82] = "Clay (Block)"
block_id[83] = "Sugar Cane"
block_id[84] = "Jukebox"
block_id[85] = "Fence"
block_id[86] = "Pumpkin"
block_id[87] = "Netherrack"
block_id[88] = "Soul Sand"
block_id[89] = "Glowstone"
block_id[90] = "Portal"
block_id[91] = "Jack-O-Lantern"
block_id[92] = "Cake Block"
block_id[93] = "Redstone Repeater"
block_id[94] = "Redstone Repeater"
block_id[95] = "Stained Glass"
block_id[96] = "Trapdoors"
block_id[97] = "Hidden Silverfish"
block_id[98] = "Stone Bricks"
block_id[99] = "Huge brown and red mushroom"
block_id[100] = "Huge brown and red mushroom"
block_id[101] = "Iron Bars"
block_id[102] = "Glass Pane"
block_id[103] = "Melon"
block_id[104] = "Pumpkin Stem"
block_id[105] = "Melon Stem"
block_id[106] = "Vines"
block_id[107] = "Fence Gate"
block_id[108] = "Brick Stairs"
block_id[109] = "Stone Brick Stairs"
block_id[110] = "Mycelium"
block_id[111] = "Lily Pad"
block_id[112] = "Nether Brick"
block_id[113] = "Nether Brick Fence"
block_id[114] = "Nether Brick Stairs"
block_id[115] = "Nether Wart"
block_id[116] = "Enchantment Table"
block_id[117] = "Brewing Stand"
block_id[118] = "Cauldron"
block_id[119] = "End Portal"
block_id[120] = "End Portal Frame"
block_id[121] = "End Stone "
block_id[126] = "Wood Slabs"
block_id[128] = "Sandstone Stairs"
block_id[134] = "Spruce Wood Stairs"
block_id[135] = "Birch Wood Stairs"
block_id[136] = "Jungle Wood Stairs"
block_id[156] = "Quartz Stairs"
block_id[159] = "Stained Clay"
block_id[160] = "Stained Glass Pane"
block_id[163] = "Acacia Wood Stairs"
block_id[164] = "Dark Oak Wood Stairs"
block_id[171] = "Carpet"
block_id[172] = "Hardened Clay"
block_id[256] = "Iron Ingotron Shovel"
block_id[257] = "Iron Pickaxe"
block_id[258] = "Iron Axe"
block_id[259] = "Flint and Steel"
block_id[260] = "Red Apple"
block_id[261] = "Bow"
block_id[262] = "Arrow"
block_id[263] = "Coal"

local woolColors = {}
woolColors[0] = "White"
woolColors[1] = "Orange"
woolColors[2] = "Magenta"
woolColors[3] = "Light Blue"
woolColors[4] = "Yellow"
woolColors[5] = "Lime"
woolColors[6] = "Pink"
woolColors[7] = "Gray"
woolColors[8] = "Light Gray"
woolColors[9] = "Cyan"
woolColors[10] = "Purple"
woolColors[11] = "Blue"
woolColors[12] = "Brown"
woolColors[13] = "Green"
woolColors[14] = "Red"
woolColors[15] = "Black"

local woodTypes = {}
woodTypes[0] = "Oak"
woodTypes[1] = "Spruce"
woodTypes[2] = "Birch"
woodTypes[3] = "Jungle"
woodTypes[4] = "Acacia"
woodTypes[5] = "Dark Oak"

local stairOrientation = {}
stairOrientation[0] = "East"
stairOrientation[1] = "West"
stairOrientation[2] = "South"
stairOrientation[3] = "North"
stairOrientation[4] = "East Inverted"
stairOrientation[5] = "West Inverted"
stairOrientation[6] = "South Inverted"
stairOrientation[7] = "North Inverted"

local nonWoodenSlabs = {		
	[0] = "Stone",		
	[1] = "Sandstone",		
	[2] = "Wooden",		
	[3] = "Cobblestone",		
	[4] = "Bricks",		
	[5] = "Stone Bricks",		
	[6] = "Nether Brick",		
	[7] = "Quartz",		
	[8] = "Inverted Stone",		
	[9] = "Inverted Sandstone",		
	[10] = "Inverted Wooden",		
	[11] = "Inverted Cobblestone",		
	[12] = "Inverted Bricks",		
	[13] = "Inverted Stone Bricks",		
	[14] = "Inverted Nether Brick",		
	[15] = "Inverted Quartz",		
}

local length = 0
local height = 0
local width = 0
local blocks = {}
local data = {}

function getBlockName(id, blockData)
	blockData = blockData or nil
	local str = nil
	if(block_id[id] == nil) then
		return tostring(id)..", "..tostring(blockData)
	else
		if(blockData) then
			if(id == 35) or (id == 159) or (id == 95) or (id == 160) or (id == 171) then
				str = tostring(woolColors[blockData]) .. " " .. tostring(block_id[id])
				return str
			elseif id == 5 or id==17 or id==126 then
				str = tostring(woodTypes[blockData]).." "..tostring(block_id[id])
				return str
			elseif id == 44 or id == 43 then		
				str = tostring(nonWoodenSlabs[blockData]).." "..tostring(block_id[id])		
				return str
			end
		return block_id[id]
		end
	end
end

function getBlockId(x,y,z)
  return blocks[y + z*width + x*length*width + 1]
end

function getData(x,y,z)
  return data[y + z*width + x*length*width + 1]
end

function readbytes(h, n)
  for i=1,n do
    h.read()
  end
end

function readname(h)  
  local n1 = h.read()
  local n2 = h.read()

  if(n1 == nil or n2 == nil) then
    return ""
  end
  
  local n = n1*256 + n2
  
  local str = ""
  for i=1,n do
    local c = h.read()
    if c == nil then
      return
    end  
    str = str .. string.char(c)
  end
  return str
end

function parse(a, h, containsName)
  local containsName = containsName or true
  local i,i1,i2,i3,i4
  if a==0 then
    return
  end
  if containsName then
    name = readname(h)
  end  

  if a==1 then
    readbytes(h,1)  
  elseif a==2 then
    i1 = h.read()
    i2 = h.read()
    i = i1*256 + i2
    if(name=="Height") then
      height = i
    elseif (name=="Length") then
      length = i
    elseif (name=="Width") then
      width = i
    end
  elseif a==3 then
    readbytes(h,4)
  elseif a==4 then
    readbytes(h,8)
  elseif a==5 then
    readbytes(h,4)
  elseif a==6 then
    readbytes(h,8)
  elseif a==7 then
    i1 = h.read()
    i2 = h.read()
    i3 = h.read()
    i4 = h.read()
    i = i1*256*256*256 + i2*256*256 + i3*256 + i4
    if name == "Blocks" then
      for i=1,i do
        table.insert(blocks, h.read())
      end
    elseif name == "Data" then
      for i=1,i do
        table.insert(data, h.read())
      end
    else
      readbytes(h,i)
    end
  elseif a==8 then
    i1 = h.read()
    i2 = h.read()
    i = i1*256 + i2
    readbytes(h,i)
  elseif a==9 then
  	--readbytes(h,5)
  	local type = h.read()
  	i1 = h.read()
    i2 = h.read()
    i3 = h.read()
    i4 = h.read()
    i = i1*256*256*256 + i2*256*256 + i3*256 + i4
    for j=1,i do
      parse(h.read(), h, false)
    end
  end
end

function forward()
  while not turtle.forward() do
    turtle.dig()
  end
end

function up()
  while not turtle.up() do
    turtle.digUp()
  end
end

function down()
  while not turtle.down() do
    turtle.digDown()
  end
end

function place()
  while not turtle.placeDown() do
    turtle.digDown()
  end
end

local function show_selected_slot(n)
	local w,h = term.getCursorPos()
	local itemData = turtle.getItemDetail(newSelect)
	if itemData then
		term.clearLine()
		term.setCursorPos(1,h)
		write("    "..itemData.name..", "..itemData.damage)
	else
		term.clearLine()
		term.setCursorPos(1,h)
		write("    ")
	end
	return itemData
end

local function setColor(color)		
	if term.isColor() then		
		term.setTextColor(color)		
	end		
end
	
function setup(filename)
--input file
--returns blocks,data
--requires parse, getBlockName

	if not fs.exists(filename) then
  		error("File "..tostring(filename).." does not exist.")
	end
	h = fs.open(filename, "rb")

	local a = 0
	while (a ~= nil) do
 		a = h.read()
  		parse(a, h)
	end

	write("length: " .. length)
	write("   width: " .. width)
	write("   height: " .. height .. "\n")
	
	uniqueblocks={}
	for i,v in ipairs(blocks) do
  		found = false
  		for j,w in ipairs(uniqueblocks) do

			--[[if (w.blockID==v and (w.data==data[i] or w.blockID ~= 35)) then
      			found = true
      			w.amount = w.amount + 1
      			break
    		end]]--

    		--for now, data is only accounted for when the block is whool
    		if (w.blockID==v) and (w.data==data[i]) then
      			found = true
      			w.amount = w.amount + 1
      			break
    		end
  		end
  
  		if found==false then
    		uniqueblocks[#uniqueblocks+1] = {}
    		uniqueblocks[#uniqueblocks].blockID = v
    		uniqueblocks[#uniqueblocks].data = data[i]
    		uniqueblocks[#uniqueblocks].amount = 1
  		end
	end

	if fs.exists("slots") then
		print("slots file discovered...")
		print("skipping setup")
		h.close()
		return
	end

	print("number of block types: " .. #uniqueblocks)
	for i,v in ipairs(uniqueblocks) do
  		if (i%9)==0 then
    		read()
  		end

	    local stacks = math.ceil( (v.amount/64) )
        setColor(colors.white)
        write(" -" .. getBlockName(v.blockID, v.data))
        setColor(colors.lightGray)
        write("("..v.blockID..","..v.data..")")
        setColor(colors.white)
        write(": ")
 
        if v.amount > 64 then
            setColor(colors.magenta)
            print(stacks.." stacks")
        else
            setColor(colors.cyan)
            print(v.amount)
        end
    end
	
    setColor(colors.white)

	read()
	

	print("Use arrowKeys and enter to select slots containing block the turtle will use for the printed blockType")
	setColor(colors.gray)
	print("press x to skip(not use) the specified blockType")
	setColor(colors.white)
	slots={}
	for i,block in ipairs(uniqueblocks) do
		local n = nil
  		blockData = block.data
		
		setColor(colors.lightGray)
  		write(" -in which slots is ")
		setColor(colors.lime)
		write(getBlockName(block.blockID, blockData))
		setColor(colors.lightGray)
		print("("..block.blockID..","..blockData .. ") ?")
		setColor(colors.white)
  		if not slots[block.blockID] then
    		slots[block.blockID] = {}
  		end
  		slots[block.blockID][blockData] = {}
		show_selected_slot(turtle.getSelectedSlot())
		--input none
		--output(n)		

		--(oldWay)
		if tArgs[2] == "sim" or tArgs[2] == "simulate" then
  			write("   ")
  			str = read()
			n = tonumber(str)
		else
			n = numberSelector()
		end

		local itemData = show_selected_slot(n)
		if(n and itemData) then
			print()
			slots[block.blockID][blockData] = {itemData.name,itemData.damage}
		else
			local w,h = term.getCursorPos()
			term.clearLine()
			term.setCursorPos(1,h)
			print("    SKIPPING")
			slots[block.blockID][blockData] = {}
		end
	end
	
	h.close()
	save(slots,"slots")
end

function numberSelector()

    local function selectNext(newSelect)
        if newSelect >= 1 and newSelect <= 16 then
            turtle.select(newSelect)
			show_selected_slot(newSelect)
        end
    end
 
    local function ifKey(events,nKey,fn,...)
        if events[1] == "key" and events[2] == tonumber(nKey) then
            fn(...)
        end
    end
 
    local bRunning = true
	local bNothing = false
    while bRunning do
        local events = { os.pullEvent("key") }
        local newSelect
        local selected = turtle.getSelectedSlot()
   
        ifKey(events,203,function() newSelect = selected - 1 ; selectNext(newSelect) ; end)
        ifKey(events,205,function() newSelect = selected + 1 ; selectNext(newSelect) ; end)
        ifKey(events,200,function() newSelect = selected - 4 ; selectNext(newSelect) ; end)
        ifKey(events,208,function() newSelect = selected + 4 ; selectNext(newSelect) ; end)
		ifKey(events,28,function() bRunning = false ; end)
        ifKey(events,45,function() bNothing = true ; bRunning = false ; end)
 		ifKey(events,15,function() bNothing = true ; bRunning = false; end)

        for i = 2,13 do
            ifKey(events,i,function() selectNext(i-1) end)
        end
        for i = 26,27 do
            ifKey(events,i,function() selectNext(i-13) end)
        end
        for i = 39,40 do
            ifKey(events,i,function() selectNext(i-24) end)
        end
    end
    if bNothing then
    	return nil
    else
    	return turtle.getSelectedSlot()
    end
end

-- [[ Iterators ]] --

function checkIfAir()
	--finds the location to place the next block
    while true do
	x,y,z = iterate(x,y,z,startx,starty,startz,height-1,width-1,length-1)
		--makes the turtle build faster by having to travel less
        blockID2 = getBlockId(x,y,z)	-- temporary variable 
        blockData2 = getData(x,y,z) 	-- temporary variable
        if slots[blockID2] then
			-- makes sure the next block to place at location is not air
            slot_2nd = slots[blockID2][blockData2]
            if slot_2nd then
                if #slot_2nd > 0 then
                    recordObj(x,y,z)
                    break
                end
            end
        end
    end
end

function check(x,y,z,startx,starty,startz)
    if x%2==startx%2 then
        oddx = true
        if y%2==starty%2 then
            oddy = true
        else
            oddy = false
        end
    else
        oddx = false
        if y%2==starty%2 then
            oddy = false
        else
            oddy = true
        end
    end
	return oddx,oddy
end


function Yiterate(x,y,z,startx,starty,startz,finalx,finaly,finalz)
	
	local height = finalx
	local width = finaly
	local length = finalz
	
    if oddx then
        if y < width then
            y = y + 1
        elseif y == width then
            if x < height then
                x = x + 1
            --elseif x == height then
                --x,y,z = "max","max","max"
            end
        end
    else
        if y <= starty then
            if x < height then
                x = x + 1
			elseif x == height then
				x = "max"
				y = "max"
				z = "max"
            end
        else
            y=y-1
        end
    end
	return x,y,z
end

function iterate(x,y,z,startx,starty,startz,finalx,finaly,finalz) 
	
	local height = finalx
	local width = finaly
	local length = finalz
	
	
    local oddx,oddy = check(x,y,z,startx,starty,startz)
    if z == length and oddy then
        x,y,z = Yiterate(x,y,z,startx,starty,startz,finalx,finaly,finalz)    
    elseif z == startz and oddy then
        z = z + 1
    elseif z == startz and (not oddy) then
        x,y,z = Yiterate(x,y,z,startx,starty,startz,finalx,finaly,finalz)
    elseif z==length and (not oddy) then
        z = z - 1

    elseif z < length then
        if oddy then
            z = z + 1
        else
            z = z - 1
        end
    end
	return x,y,z
 end

-- [[ TSP_algorithm API ]] --

local w,h = term.getSize()
 
local function calculateDistance(tNode1,tNode2)
	local turnCost = 0
	local deltaY,deltaZ
	local y1 = tNode1[2]
	local z1 = tNode1[3]
	local y2 = tNode2[2]
	local z2 = tNode2[3] 
	
	deltaZ = z2-z1
	deltaY = y2-y1
	
	if deltaZ == 0 or deltaY == 0 then
		turnCost = 0
	else
		turnCost = 1
	end
	
	return math.abs(deltaZ) + math.abs(deltaY) + turnCost
	--return math.sqrt( (z2-z1)^2 + (y2-y1)^2 )
end
 
local function twoOptSwap(route, i, k)
    local new_route = {}
    for c = 1,i-1 do
        table.insert(new_route,route[c])
    end
    for c = k,i,-1 do
        table.insert(new_route,route[c])
    end
    for c = k+1,#route do
        table.insert(new_route,route[c])   
    end
    return new_route
end
 
local function calculateTotalDistance(route)
	local total = 0
	for i = 1,#route-1 do
		total = total + calculateDistance(route[i],route[i+1])
	end
	return total
end
 
local function display(route,distance)
    local l,h = term.getSize()
    shell.run("clear")
 
    for i = 1,#route-1 do
        paintutils.drawLine(route[i][2],route[i][3],route[i+1][2],route[i+1][3],colors.lime)
    end
    for i,coord in pairs(route) do
        term.setBackgroundColor(colors.yellow)
        term.setTextColor(colors.magenta)
		if coord[2] < l and coord[2] >= 1 and coord[3] >= 1 and coord[3] < h then
        	term.setCursorPos(coord[2],coord[3])
			local char = i + 64
			if char > 190 then
				char = char - 190
			end
			if char > 380 then 
				char = char - 380
			end
        	term.write(string.char(char))
		end
    end
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1,h)
    term.write(distance)
end
 
local route = {}
route[1] = {1,28,3}
route[2] = {1,36,13}
route[3] = {1,20,8}
route[4] = {1,8,8}
route[5] = {1,44,5}
route[6] = {1,32,13}
route[7] = {1,20,17}
--route[8] = {1,28,3}

function tsp_algorithm(existing_route)
	local improve = 0 
	while improve < 3 do
		local best_distance = calculateTotalDistance(existing_route)
		for i = 2,#existing_route-1 do
			for k = i + 1, #existing_route do
				new_route = twoOptSwap(existing_route, i, k)
				new_distance = calculateTotalDistance(new_route)
				if new_distance < best_distance then
					improve = 0
					existing_route = new_route
					best_distance = calculateTotalDistance(existing_route)
					display(existing_route,best_distance)
					sleep(0)
				end
			end
		end
		improve = improve + 1
	end
	return existing_route, best_distance
end

-- [[ schematic --> blueprint ]] --

--turtles[i].instructions[n] = {x,y,z,id,data}
--i = multiturtle ie 1,2,3,4 ; n = step ie 1 - 256 (no air) 

--fn splits 16x16 grid between 4 turtles returning startx,y,z and endx,y,z of 4 4x4 grids
--fn takes each 4x4 grid and turns them into instructions[n] = {x,y,z,id,data}
--fn for master turtle to setup all slave turtles with the instructions[n] table and goto/find/place functions

function blueprint(startx,starty,startz,finalx,finaly,finalz)
	--uses iterator to make instructions[n] table
	local x,y,z = startx,starty,startz
	local instructions = {}
	local nTimes = (finalx+1-startx)*(finaly+1-starty)*(finalz+1-startz)
	for i=1,nTimes do
		if x == "max" then
			break
		end
		local id = getBlockId(x,y,z)
		local data = getData(x,y,z)
		if id > 0 then
			table.insert(instructions,{x,y,z,id,data})
		end
		x,y,z = iterate(x,y,z,startx,starty,startz,finalx,finaly,finalz)
	end
	return instructions
end

function improveBlueprint(instructions,startx,starty,startz,finalx,finaly,finalz)
	local function instructions2layers(instructions)
    	local layers = {}
   		for x = startx,finalx do
        	layers[x] = {}
        	for n=1,#instructions do
            	if instructions[n][1] == x then
                	table.insert(layers[x],{unpack(instructions[n],1,3)})
            	end
        	end
    	end
    	return layers
	end
	local function organize(layers)
    	local startingPosition = {startx,starty,startz}
    	for x = startx,finalx do
       		table.insert(layers[x],1,startingPosition)
        	layers[x] = tsp_algorithm(layers[x])
        	startingPosition = layers[x][#layers[x]]
    	end
    	return layers
	end
 
	local function layers2instructions(layers)
   		local instructions = {}
    	--organizedlayers only
    	for x = startx,finalx do
        	for i = 2,#layers[x] do
            	table.insert(instructions,layers[x][i])
        	end
    	end
    	return instructions
	end
 
	local function add_id_and_data(instructions)
    	for n = 1,#instructions do
        	instructions[n][4] = getBlockId(unpack(instructions[n],1,3))
        	instructions[n][5] = getData(unpack(instructions[n],1,3))
    	end
    	return instructions
	end

	local layers = instructions2layers(instructions)
	layers = organize(layers)
	local new_instructions = layers2instructions(layers)
	new_instructions = add_id_and_data(new_instructions)
	return new_instructions
end

function simulateIns(instructions)
	local w,h = term.getSize()
    local lastx = 0
    shell.run("clr")
    for n = 1,#instructions do
        if lastx~=instructions[n][1] then
            term.setBackgroundColor(colors.black)
            shell.run("clr")
        end
		if instructions[n][2]+1 >= 1 and instructions[n][3]+1 >= 1 and instructions[n][2]+1 < w and instructions[n][3]+1 <  h then
        	term.setCursorPos(instructions[n][2]+1,instructions[n][3]+1)
        	term.setBackgroundColor(2^instructions[n][5])
        	term.write(" ")
		end
        lastx = instructions[n][1]
        sleep(0)
    end
end

function orientation_check(reference,slots)
	for id,table in pairs(slots) do
		for data,table2 in pairs(table) do
			if table2 and table2[1] then
				if (table2[1]:find("stairs") or table2[1]:find("chest") or table2[1]:find("furnace")) then
					for n = 1,5 do
						term.scroll(1)
						sleep(0)
					end
					print("orientation required")
					print("what direction is the turtle facing?")
					local r
					while true do
						write("    ")
						if term.isColor() then
							term.setTextColor(colors.yellow)
						end
						r = read()
						r = tostring(r):lower()
						term.setTextColor(colors.white)
						if r ~= "south" and r~= "north" and r~= "west" and r~= "east" then
							print(r.. " not recognized, north/south/east/west?")
						else
							break
						end
					end
				
					reference.relativeDirection = r
					print("don't forget to include wrench in turtle!")
					reference.wrench = true
					return reference
				end
			end
		end
	end
	return reference
end

function multiturtle_check(reference)
	write("How many Turtles?: ")
	local n = read()
	n = tonumber(n)
	if n then
		if n == 1 then
			reference.multiturtle = false
		else
			reference.multiturtle = n
		end
	end
	print()
	return reference
end

local function Main()
	setup(filename)

	--save(blocks,"blocks")
	--save(data,"data")
	--save(uniqueblocks,"uniqueblocks")

	reference = {
		startx = 0,
		starty = 0,
		startz = 0,
		finalx = height-1,
		finaly = width-1,
		finalz = length-1,
		height = height,
		width = width,
		length = length,
		wrench = false,
		multiturtle = false, -- otherwise its a number (1,2,4,8,12,etc),
		relativeDirection = "south",
		numChests = false,
		filename = false,
		returnx = 0,
		returny = 0,
		returnz = -1,
	}
	
	if not slots then
		slots = textutils.unserialize( fs.open("slots","r").readAll() )
	end

	reference = orientation_check(reference,slots)
	reference = multiturtle_check(reference)
	
	local instructions = blueprint(reference.startx,reference.starty,reference.startz,reference.finalx,reference.finaly,reference.finalz)
	if reference.multiturtle then
		local A1 = Class_Grid(instructions,reference.starty,reference.startz,reference.finaly,reference.finalz)
	    startLocations = {nTurtleSplit(reference.multiturtle,A1)}
		--save(startLocations,"startLocations")
		--[[for i,v in pairs(startLocations) do
			local nTurtle = i
			local ref = reference
			ref.starty = v.starty
			ref.startz = v.startz
			ref.finaly = v.finaly
			ref.finalz = v.finalz
			local ins = blueprint(ref.startx,v.starty,v.startz,ref.finalx,v.finaly,v.finalz)
			if tArgs[2] == "tsp" then
				ins = improveBlueprint(ins,ref.startx,ref.starty,ref.startz,ref.finalx,ref.finaly,ref.finalz)
			end
			local fname = saveBlueprint(ref,slots,ins,uniqueblocks,nTurtle)
			print(ref.starty," ",ref.startz," ",ref.finaly," ",ref.finalz)
			print(fname," saved")
		end]]
		local nTurtle = 1
		local v = startLocations[1]
		local ref = reference
		ref.starty = v.starty
		ref.startz = v.startz
		ref.finaly = v.finaly
		ref.finalz = v.finalz
		local ins = blueprint(ref.startx,v.starty,v.startz,ref.finalx,v.finaly,v.finalz)
		if tArgs[2] == "tsp" then
			ins = improveBlueprint(ins,ref.startx,ref.starty,ref.startz,ref.finalx,ref.finaly,ref.finalz)
		end
		local fname = saveBlueprint(ref,slots,ins,uniqueblocks,nTurtle)
		print(ref.starty," ",ref.startz," ",ref.finaly," ",ref.finalz)
		print(fname," saved")
	else
		
		if tArgs[2] == "tsp" then
			instructions = improveBlueprint(instructions,reference.startx,reference.starty,reference.startz,reference.finalx,reference.finaly,reference.finalz)
		end
	--textutils.pagedPrint(textutils.serialize(ins))
	--saveIns("instructions",ins)
		local fname = saveBlueprint(reference,slots,instructions,uniqueblocks)
		print(fname," saved")
	--delete slots,reference,ins,uniqueblocks files
	end
end

Main()
