--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: Dr. Haeyong Chung
--Due Date: December 1, 2019
--File Name: FileUtility.lua
--Description:	Represents the player's account. Used as an interface
--				with the server and stores account information.

--Libraries
local json = require( "json" )

--Create FileUtility object
local FileUtility = {}

--Default directory for the files
local directory = system.DocumentsDirectory

--Saves a table into the specified file
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
        file:write( json.encode( t , { indent = true }) )
        -- Close the file handle
        io.close( file )
        return true
    end
end

--Creates a table using the data from the given file
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
