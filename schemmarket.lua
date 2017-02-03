--upload to Market
local tArgs = {...}

-- Usage: market upload [file]
-- market (list schematics)
-- market [file] (download schematic)

function convertToStringFile(inputFileName, outputFileName)
  if not fs.exists(inputFileName) then
    print("InputFile: " .. inputFileName .. " does not exist.")
    printUsage()
    return
  end
  if fs.exists(outputFileName) then
    print("OutputFile: " .. outputFileName .. " does exist, please delete it before or choose another filename.")
    printUsage()
    return
  end
 
  local inFile = fs.open(inputFileName, "rb")
 
  local byteArray = {}
  local byte = 0
  while byte ~= nil do
    byte = inFile.read()
    table.insert(byteArray, byte)
  end
 
  outFile = fs.open(outputFileName, "w")
  outFile.write(textutils.serialize(byteArray))
  outFile.close()
end
 
function convertToByteFile(inputFileName, outputFileName)
 
  if not fs.exists(inputFileName) then
    print("InputFile: " .. inputFileName .. " does not exist.")
    printUsage()
    return
  end
  if fs.exists(outputFileName) then
    print("OutputFile: " .. outputFileName .. " does exist, please delete it before or choose another filename.")
    printUsage()
    return
  end
 
  local inFile = fs.open(inputFileName, "r")
  local charArray = {}
  charArray = textutils.unserialize(inFile.readAll())
  inFile.close()
 
 
  local outFile = fs.open(outputFileName, "wb")
 
  for _, byte in ipairs(charArray) do
    outFile.write(byte)
  end
  outFile.close()
end

--[[if not fs.exists("convert") then 
	local h = fs.open("convert","w")
	h.write(http.post("http://pastebin.com/raw/NUspW9KB").readAll())
	h.close()
end]]

local schematics = {

	tent = "UskC5qpE",
	chicken = "VisRJwkw",
	villageHouse = "0r2YMjaf",
	mobSpawner = "Cg6jgTqn",
	introHouse = "cWpAN2vw",
	genericModern = "dPBCAp5W",
}

local bugged_schematics = {
	star = "7im48RBP",
	
}

if not tArgs[1] then
	if term.isColor() then
		term.setTextColor(colors.lime)
	end
	for i,v in pairs(schematics) do
		print(" "..tostring(i))
	end
	term.setTextColor(colors.white)
elseif tArgs[1] == "upload" then
	if fs.exists("sSchematic") then
		fs.delete("sSchematic")
	end
	if not fs.exists("packager") then
		write("initializing...")
		shell.run("pastebin get gqgTcNEV packager")
		print(" finished")
	end
	fs.makeDir("bash_temp")
	fs.copy(tArgs[2],"bash_temp/"..tostring(tArgs[2]))
	shell.run("packager bash_temp package"..tostring(tArgs[2]).." "..tostring(tArgs[2]) )
	shell.run("pastebin put package"..tostring(tArgs[2]))
	fs.delete("package"..tostring(tArgs[2]))
	fs.delete("bash_temp")
else
	for name,address in pairs(schematics) do
		if tArgs[1] == name then
			
			if name == "tent" or name == "chicken" or name == "star" or name == "villageHouse" or name == "mobSpawner" then
				local schem = http.get("http://pastebin.com/raw/"..tostring(address)).readAll()
				local h = fs.open("temp","w")
				h.write(schem)
				h.close()
				convertToByteFile("temp", name)
				if fs.exists("temp") then
					fs.delete("temp")
				end
			else

				shell.run("pastebin get "..schematics[tArgs[1]].." package")	
				os.queueEvent("char","p")
				os.queueEvent("char","_")
				os.queueEvent("char","2")
				os.queueEvent("key",keys.enter)
				shell.run("package")
				for i,v in pairs(fs.list("p_2")) do
					print("extracting "..tostring(v))
					fs.move("p_2/"..tostring(v),shell.dir().."/"..tostring(v))
				end
				fs.delete("p_2")
				fs.delete("package")
			end
		end
	end
end