local Component = require("module/ui/components/Component")

local Box = Component:extend(nil, function(self)
    local position, size, color = self.props.position, self.props.size, self.props.color
    paintutils.drawFilledBox(position.x, position.y, position.x + size.x, position.y + size.y, color)
end)

return Box