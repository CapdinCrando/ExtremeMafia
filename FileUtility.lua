local json = require( "json" )

local FileUtility = {}

local directory = system.DocumentsDirectory

function FileUtility.saveTable(t, filename)
    -- Path for the file to write
    local path = system.pathForFile( filename, directory )
 
    -- Open the file handle
    local file, errorString = io.open( path, "w" )
 
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Write encoded JSON data to file
        file:write( json.encode( t ) )
        -- Close the file handle
        io.close( file )
        return true
    end
end

function FileUtility.loadTable(filename)
    -- Path for the file to read
    local path = system.pathForFile( filename, directory )
 
    -- Open the file handle
    local file, errorString = io.open( path, "r" )
 
    if not file then
        -- Error occurred; output the cause
		print( "File error: " .. errorString )
		return {}
    else
        -- Read data from file
        local contents = file:read( "*a" )
        -- Decode JSON data into Lua table
        local t = json.decode( contents )
        -- Close the file handle
        io.close( file )
        -- Return table
        return t
    end
end

return FileUtility