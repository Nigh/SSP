
local controller=class("controller",device)

controller.name = "controller"
controller.tag = "ctrl"
controller.host = nil
controller.pipe = function(self,com,...)
	arg={...}
	if self[com] then self[com](self,...) end
end

return controller
-- TODO: 实现更加通用的控制器类型
