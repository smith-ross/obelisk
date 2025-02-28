local Component = require("module/ui/components/Component")
local Box = require("module/ui/components/Box")

local TestComponent = Component:extend(nil, function(self)
    local position = self.props.position or {x = 10, y = 10}
    local updatedPositionX = self:defineState("pos", position.x)

    updatedPositionX.set((updatedPositionX.get() + 1) % 15)
    return Box:withProps("renderBox" .. self.props.id, {
        position = {x = updatedPositionX.get(), y = position.y},
        size = {x = 2, y = 2},
        color = self.props.color or colors.lime,
    })()
end)

return TestComponent