local Component = require("module/ui/components/Component")

local Box = Component:extend(function(self)
    print("RENDER!")
    local position, size, color = self.props.position, self.props.size, self.props.color
    paintutils.drawFilledBox(position.x, position.y, size.x, size.y, color)
end)

return Box