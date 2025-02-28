local Component = require("module/ui/components/Component")
local Box = require("module/ui/components/Box")

local TestComponent = Component:extend(function(self)
    local position = self.props.position or {x = 10, y = 10}
    return Box:withProps({
        position = {x = position.x, y = position.y},
        size = {x = 30, y = 30},
        color = colors.lime,
    })()
end)

return TestComponent