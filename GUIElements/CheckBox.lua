Class("CheckBox") ({

	["load"] = function(s)
		table.insert(GUIs,s)
		
		s.mouseButtonLUp:connect(function()
			s:changeState()
		end)
	end,

	["size"] = {32, 32},
	["checked"] = false,
	
	["changeState"] = function(s,Args) 
		s.checked = Args or not s.checked
		s.checkStateChanged:run(s.checked)
	end,
	
	["draw"] = function(s,Args)	
		if s.checked then	
			love.graphics.setColor(0,0,0,255)
			love.graphics.draw(GUIGraphics["Check"],s.position[1],s.position[2],0,s.size[1]/32,s.size[2]/32)	
		end
	end,
	
	["checkStateChanged"] = newEvent()

	}, {GUIElement})
	