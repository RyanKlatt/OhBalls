local json = require("json")
 
function loadLevels()
		local base = system.pathForFile( "levels.json", system.DocumentsDirectory)
	 	local jsoncontents = ""
	 	local levelsArray = {}
	 	local file = io.open( base, "r" )
	 		if file then
	 			local jsoncontents = file:read( "*a" )
	 			levelsArray = json.decode(jsoncontents);
	 			io.close( file )
	 	        return levelsArray
     		end
 
     		return levels
	 end
 
function saveLevels()
	    local base = system.pathForFile( "levels.json", system.DocumentsDirectory)
	    local file = io.open(base, "w")
	    local jsoncontents = json.encode(levels)
	    file:write( jsoncontents )
		io.close( file )
	end
	
	function loadLevels2()
		local base = system.pathForFile( "levels2.json", system.DocumentsDirectory)
	 	local jsoncontents = ""
	 	local levelsArray = {}
	 	local file = io.open( base, "r" )
	 		if file then
	 			local jsoncontents = file:read( "*a" )
	 			levelsArray = json.decode(jsoncontents);
	 			io.close( file )
	 	        return levelsArray
     		end
 
     		return levels2
	 end
 
function saveLevels2()
	    local base = system.pathForFile( "levels2.json", system.DocumentsDirectory)
	    local file = io.open(base, "w")
	    local jsoncontents = json.encode(levels2)
	    file:write( jsoncontents )
		io.close( file )
	end
	
		function loadLevels3()
		local base = system.pathForFile( "levels3.json", system.DocumentsDirectory)
	 	local jsoncontents = ""
	 	local levelsArray = {}
	 	local file = io.open( base, "r" )
	 		if file then
	 			local jsoncontents = file:read( "*a" )
	 			levelsArray = json.decode(jsoncontents);
	 			io.close( file )
	 	        return levelsArray
     		end
 
     		return levels3
	 end
 
function saveLevels3()
	    local base = system.pathForFile( "levels3.json", system.DocumentsDirectory)
	    local file = io.open(base, "w")
	    local jsoncontents = json.encode(levels3)
	    file:write( jsoncontents )
		io.close( file )
	end
	
		function loadLevels4()
		local base = system.pathForFile( "levels4.json", system.DocumentsDirectory)
	 	local jsoncontents = ""
	 	local levelsArray = {}
	 	local file = io.open( base, "r" )
	 		if file then
	 			local jsoncontents = file:read( "*a" )
	 			levelsArray = json.decode(jsoncontents);
	 			io.close( file )
	 	        return levelsArray
     		end
 
     		return levels4
	 end
 
function saveLevels4()
	    local base = system.pathForFile( "levels4.json", system.DocumentsDirectory)
	    local file = io.open(base, "w")
	    local jsoncontents = json.encode(levels4)
	    file:write( jsoncontents )
		io.close( file )
	end