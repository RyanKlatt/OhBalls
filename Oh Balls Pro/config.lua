application = {
	content = {
	
		graphicsCompatibility = 1,  -- Turn on V1 Compatibility Mode
		
		width = 320,
		height = 480, 
		scale = "letterBox",
		fps = 30,
		
		--[[
        imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},
	    license =
    {
        google =
        {
            key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoT+qe9ux0fdWUfJcvwM4mxHZkFTfdP8eL+lUH9tZ+9yz4lGcUj/Xzb6fCQAw+OMAfpUdSjB685CYC03233L6i+Jfqz6tjGdP/bNrDZih6e/c5JNHPeM9rAuTu7jt2Kn1mLmWQaYXP5ZQVn1dtOTcgQ2lR7nX+K+/OI2N5CERma7cVxbsrVGFGoa02UlZClRifTHmpgVJpVoGHsgDjvWBbG0DdfyBIRVcXjIUmmjJpqLsRSxDzLWh1FboGOObaEPeLolXKM4hrRK6/tmVHE1qAul0fIXFvRWCsrxa8TCjinneUmrxf7RZ8zqTMTqWSPiOgLTKuyrr9xQKEImXwruiLQIDAQAB",
            policy = "serverManaged",
        },
    },

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
