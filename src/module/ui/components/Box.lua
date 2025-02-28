local Component = require("Component")

local Box = Component:extend(function(self)
    local position, size, color = self.props.position, self.props.size, self.props.color
    paintutils.drawFilledBox(position.x, position.y, size.x, size.y, color)
end)

return Box