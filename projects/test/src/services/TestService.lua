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
        ui.App("app", {
            TestComponent:withProps("Test1", {
                id = "Test1",
                position = {x = 2, y = 2},
                size = {x = 2, y = 2},
            })(),
            TestComponent:withProps("Test2", {
                id = "Test2",
                position = {x = 10, y = 10},
                size = {x = 2, y = 2},
                color = colors.red,
            })(),
            TestComponent:withProps("Test3", {
                id = "Test3",
                position = {x = 5, y = 5},
                size = {x = 2, y = 2},
            })(),
        })
        term.setBackgroundColor(colors.black)
    end
})