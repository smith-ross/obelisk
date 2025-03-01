local Component = require("module/ui/components/Component")
local Box = require("module/ui/components/Box")

local TestComponent = Component:extend(nil, function(self)
    local position = self.props.position or {x = 10, y = 10}
    local updatedPositionX = self:defineState("pos", position.x)
    local counter = self:defineState("counter", 0)
    local color = self:defineState("clr", colors.white)
    local COLORS = {
        colors.blue,
        colors.brown,
        colors.red,
        colors.green,
        colors.blue,
        colors.lime,
        colors.gray,
        colors.magenta
    }

    self:effect("counter", function()
        counter.set(counter.get() + 1)
        if counter.get() % 30 == 0 then
            updatedPositionX.set((updatedPositionX.get() + 1) % 60)
        end
    end, {counter.get()})

    self:effect("clr", function()
        color.set(COLORS[math.random(1, #COLORS)])
    end, {updatedPositionX.get()})

    return Box:withProps("renderBox" .. self.props.id, {
        position = {x = updatedPositionX.get(), y = position.y},
        size = {x = 2, y = 2},
        color = color.get()
    })()
end)

return TestComponent