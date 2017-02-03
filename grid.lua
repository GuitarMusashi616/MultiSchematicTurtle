--[[if not fs.exists("villageHouse.blueprint") then
    shell.run("pastebin get ggYJsi1l villageHouse.blueprint")
end
shell.run("villageHouse.blueprint")]]
 
if not fs.exists("textutilsFIX") then
    shell.run("pastebin get 3wguFBXn textutilsFIX")
end
 
os.loadAPI("textutilsFIX")
 
 
function save(table,fileself)
    local h = fs.open(fileself,"w")
    h.write(textutilsFIX.serialize(table))
    h.close()
end
 
function printGrid(grid)
    for y = 0,#grid do
        for z = 0,#grid[y] do
            textutils.slowWrite(grid[y][z],1000)
        end
        print()
    end
end
 
function createWeight(instructions,starty,startz,finaly,finalz)
    local weightGrid,ygrid,zgrid = {},{},{}
   
    for y = starty,finaly do
        ygrid[y] = 0
        weightGrid[y] = {}
        for z = startz,finalz do
            zgrid[z] = 0
            weightGrid[y][z] = 0
        end
    end
   
   
    for n = 1,#instructions do
        assert(instructions[n],instructions[n])
        local y,z = instructions[n][2],instructions[n][3]
        if weightGrid[y] and weightGrid[y][z] then
            weightGrid[y][z] = weightGrid[y][z] + 1
            ygrid[y] = ygrid[y] + 1
            zgrid[z] = zgrid[z] + 1
        end
    end
 
 
    return weightGrid,ygrid,zgrid
end
 
 
function Class_Grid(instructions,starty,startz,finaly,finalz)
    local self = {}
    self.starty = starty
    self.startz = startz
    self.finaly = finaly
    self.finalz = finalz
    self.grid,self.ygrid,self.zgrid = createWeight(instructions,starty,startz,finaly,finalz)
    self.splity = function(self)
        local n = split(self.ygrid,self.starty,self.finaly)
        local A2 = Class_Grid(instructions,self.starty,self.startz,n,self.finalz)
        local B2 = Class_Grid(instructions,n+1,self.startz,self.finaly,self.finalz)
        return A2,B2
    end
    self.splitz = function(self)
        local n = split(self.zgrid,self.startz,self.finalz)
        local A2 = Class_Grid(instructions,self.starty,self.startz,self.finaly,n)
        local B2 = Class_Grid(instructions,self.starty,n+1,self.finaly,self.finalz)
        return A2,B2
    end
    self.splitLongestSide = function(self)
        local rel_z_size = self.finalz - self.startz
        local rel_y_size = self.finaly - self.starty
        if rel_y_size >= rel_z_size then
            return self:splity()
        else
            return self:splitz()
        end
    end
    return self
end
 
function split(zgrid,startz,finalz)
    local prevleft,prevright
    for n = startz,finalz do
        local left,right = 0,0
        for z = startz,n do
            left = left + zgrid[z]
        end
        for z = finalz,n+1,-1 do
            assert(zgrid[z],zgrid[z])
            right = right + zgrid[z]
        end
        if left>=right then
            --[[print("left: ",left)
            print("right: ",right)
            print("n: ",n)
            print("prevleft: ",prevleft)
            print("prevright: ",prevright)]]
            local split
            assert(left)
            assert(right)
            if not prevleft and not prevright then
                print("SHORTCUT")
                return n
            end
            local opta = math.abs(left - right)
            local optb = math.abs(prevleft - prevright)
            if opta <= optb then
                split = n
            elseif opta > optb then
                split = n - 1
            end
            return split
        end
        prevleft,prevright = left,right
    end
end
 
function nTurtleSplitOLD(n,A1)
    --n can == 1,2,4,8,16
    if n == 1 then
        return A1
    elseif n == 2 then
        return A1:splitLongestSide()
    elseif n == 4 then
        local A2,B2 = A1:splitLongestSide()
        local A3,B3 = A2:splitLongestSide()
        local C3,D3 = B2:splitLongestSide()
        return A3,B3,C3,D3
    elseif n == 8 then
        local A2,B2 = A1:splitLongestSide()
        local A3,B3 = A2:splitLongestSide()
        local C3,D3 = B2:splitLongestSide()
        local A4,B4 = A3:splitLongestSide()
        local C4,D4 = B3:splitLongestSide()
        local E4,F4 = C3:splitLongestSide()
        local G4,H4 = D3:splitLongestSide()
        return A4,B4,C4,D4,E4,F4,G4,H4
    elseif n == 16 then
        local A2,B2 = A1:splitLongestSide()
        local A3,B3 = A2:splitLongestSide()
        local C3,D3 = B2:splitLongestSide()
        local A4,B4 = A3:splitLongestSide()
        local C4,D4 = B3:splitLongestSide()
        local E4,F4 = C3:splitLongestSide()
        local G4,H4 = D3:splitLongestSide()
        local A5,B5 = A4:splitLongestSide()
        local C5,D5 = B4:splitLongestSide()
        local E5,F5 = C4:splitLongestSide()
        local G5,H5 = D4:splitLongestSide()
        local I5,J5 = E4:splitLongestSide()
        local K5,L5 = F4:splitLongestSide()
        local M5,N5 = G4:splitLongestSide()
        local O5,P5 = H4:splitLongestSide()
        return A5,B5,C5,D5,E5,F5,G5,H5,I5,J5,K5,L5,M5,N5,O5,P5
    end
end
 
--local A1 = Class_Grid(instructions,reference.starty,reference.startz,reference.finaly,reference.finalz)
 --local startLocations = {nTurtleSplit(8,A1)}
--save(A1,"A1")

function splice(A1,tab)
	local a,b = A1:splitLongestSide()
	table.insert(tab,a)
	table.insert(tab,b)
end

--[[local tab = {}
splice(A1,tab)
local tab2 = {}
for i,obj in pairs(tab) do
	splice(obj,tab2)
end
for i,v in pairs(tab) do
	--print()
end]]

function nTurtleSplit(n,A1)
	n = tonumber(n)
	n = math.log(n)/math.log(2)
	if n == 0 then
		return A1
	end
	assert(n)
	local tab = {}
	for i = 1,n do
		tab[i] = {}
		if i == 1 then
			splice(A1,tab[i])
		else
			for _,obj in pairs(tab[i-1]) do
				splice(obj,tab[i])
			end
		end
	end
	return unpack(tab[n])
end


--save(tab,"tab")


--save(startLocations,"startLocations")
--[[for i,v in pairs(startLocations) do
    assert(v.starty,i)
    print(v.starty," ",v.startz," ",v.finaly," ",v.finalz)
end
print(A1.starty," ",A1.startz," ",A1.finaly," ",A1.finalz)
print(A2.starty," ",A2.startz," ",A2.finaly," ",A2.finalz)
print(B2.starty," ",B2.startz," ",B2.finaly," ",B2.finalz)]]
