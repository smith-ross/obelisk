package.path = package.path..";../../../../../src/?.lua"

local obelisk = require("Obelisk")
local service = obelisk.m("service")

service.registerService("TestService", {
    onStart = function()
        print("Started Test Service")
    end,
    onUpdate = function()
        print("Updated Test Service")
    end
})