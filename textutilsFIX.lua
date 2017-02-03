local g_tLuaKeywords = {
    [ "and" ] = true,
    [ "break" ] = true,
    [ "do" ] = true,
    [ "else" ] = true,
    [ "elseif" ] = true,
    [ "end" ] = true,
    [ "false" ] = true,
    [ "for" ] = true,
    [ "function" ] = true,
    [ "if" ] = true,
    [ "in" ] = true,
    [ "local" ] = true,
    [ "nil" ] = true,
    [ "not" ] = true,
    [ "or" ] = true,
    [ "repeat" ] = true,
    [ "return" ] = true,
    [ "then" ] = true,
    [ "true" ] = true,
    [ "until" ] = true,
    [ "while" ] = true,
}
 
local function serializeImpl( t, tTracking, sIndent )
    local sType = type(t)
    if sType == "table" then
        --if tTracking[t] ~= nil then
            --error( "Cannot serialize table with recursive entries", 0 )
        --end
        tTracking[t] = true
 
        if next(t) == nil then
            -- Empty tables are simple
            return "{}"
        else
            -- Other tables take more work
            local sResult = "{\n"
            local sSubIndent = sIndent .. "  "
            local tSeen = {}
            for k,v in ipairs(t) do
                tSeen[k] = true
                sResult = sResult .. sSubIndent .. serializeImpl( v, tTracking, sSubIndent ) .. ",\n"
            end
            for k,v in pairs(t) do
                if not tSeen[k] then
                    local sEntry
                    if type(k) == "string" and not g_tLuaKeywords[k] and string.match( k, "^[%a_][%a%d_]*$" ) then
                        sEntry = k .. " = " .. serializeImpl( v, tTracking, sSubIndent ) .. ",\n"
                    else
                        sEntry = "[ " .. serializeImpl( k, tTracking, sSubIndent ) .. " ] = " .. serializeImpl( v, tTracking, sSubIndent ) .. ",\n"
                    end
                    sResult = sResult .. sSubIndent .. sEntry
                end
            end
            sResult = sResult .. sIndent .. "}"
            return sResult
        end
       
    elseif sType == "string" then
        return string.format( "%q", t )
   
    else
        return tostring(t)
   
    end
end
 
local EMPTY_ARRAY = {}
 
local function serializeJSONImpl( t, tTracking )
    local sType = type(t)
    if t == EMPTY_ARRAY then
        return "[]"
 
    elseif sType == "table" then
 
        tTracking[t] = true
 
        if next(t) == nil then
            -- Empty tables are simple
            return "{}"
        else
            -- Other tables take more work
            local sObjectResult = "{"
            local sArrayResult = "["
            local nObjectSize = 0
            local nArraySize = 0
            for k,v in pairs(t) do
                if type(k) == "string" then
                    local sEntry = serializeJSONImpl( k, tTracking ) .. ":" .. serializeJSONImpl( v, tTracking )
                    if nObjectSize == 0 then
                        sObjectResult = sObjectResult .. sEntry
                    else
                        sObjectResult = sObjectResult .. "," .. sEntry
                    end
                    nObjectSize = nObjectSize + 1
                end
            end
            for n,v in ipairs(t) do
                local sEntry = serializeJSONImpl( v, tTracking )
                if nArraySize == 0 then
                    sArrayResult = sArrayResult .. sEntry
                else
                    sArrayResult = sArrayResult .. "," .. sEntry
                end
                nArraySize = nArraySize + 1
            end
            sObjectResult = sObjectResult .. "}"
            sArrayResult = sArrayResult .. "]"
            if nObjectSize > 0 or nArraySize == 0 then
                return sObjectResult
            else
                return sArrayResult
            end
        end
 
    elseif sType == "string" then
        return string.format( "%q", t )
 
    else
        return tostring(t)
 
    end
end
 
function serialize( t )
    local tTracking = {}
    return serializeImpl( t, tTracking, "" )
end
 
function unserialize( s )
    local func = loadstring( "return "..s, "unserialize" )
    if func then
        setfenv( func, {} )
        local ok, result = pcall( func )
        if ok then
            return result
        end
    end
    return nil
end
 
function serializeJSON( t )
    local tTracking = {}
    return serializeJSONImpl( t, tTracking )
end
