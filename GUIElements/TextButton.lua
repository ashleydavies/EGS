Class("TextButton") ({

	["load"] = function(s)
		table.insert(GUIs,s)
		
		--Set minimumPadding to same distance as from top/top of text and bottom/bottom of text by default.
		s.textFittingMinimumPadding = s.size[2]/2 - love.graphics.getFont():getHeight()/2
	end,

	["text"] = "TextButton",
	["textFittingMinimumPadding"] = 0,	--How much padding on either side for textFitting to be true. It must have this much gap between it and the border.
	["textFitting"] = false,	--False if the text doesn't fit inside the box. If it's true the text is fitting in the box.
	
	["draw"] = function(s,Args)	
		love.graphics.setColor(0,0,0,255)
		local centrePosition = {s.position[1]+s.size[1]/2, s.position[2]+s.size[2]/2}
		love.graphics.print(s.text, centrePosition[1] - love.graphics.getFont():getWidth(s.text)/2, centrePosition[2] - love.graphics.getFont():getHeight()/2)	
	end,
	
	["update"] = function(s)
		--Ok is all we need to do is check if textFitting is true.
		if love.graphics.getFont():getWidth(s.text) < s.size[1] - s.textFittingMinimumPadding*2 then
			if not s.textFitting then
				s.textFitting = true
				s.textStartedFitting:run()
			end
		else
			if s.textFitting then
				s.textFitting = false
				s.textStoppedFitting:run()
			end
		end
	end,
	
	["textStartedFitting"] = newEvent(),
	["textStoppedFitting"] = newEvent(),
	
	}, {GUIElement})