package.path = package.path..";../../../../../src/?.lua"

local obelisk = require("Obelisk")
local TestComponent = require("module/ui/example/TestComponent")
local service = obelisk.m("service")
local ui = obelisk.m("ui")
local monitor = peripheral.find("monitor")

service.registerService("UIService", {
    onStart = function()
        print("Started Test Service")
    end,
    onUpdate = function()
        term.clear()
        if monitor then 
            monitor.setTextScale(0.5)
        end
        term.setBackgroundColor(colors.black)
        term.setCursorPos(0,0)
        ui.App("testApp")
        term.setBackgroundColor(colors.black)
    end
})