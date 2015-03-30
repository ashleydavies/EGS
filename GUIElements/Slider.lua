Class("Slider") ({

	["load"] = function(s)
		table.insert(GUIs,s)
	end,
	
	["clickedOn"] = false,
	
	["hoverShadingPercent"] = 20,	--Better to have a darker shading because it's harder to see on a slider
	["mouseDownShadingPercent"] = 30,
	
	["slots"] = 10,	--How many slots for the slideRectangle to fit into.
	["slotsVisible"] = true,	--Do the slots display?
	["slotsColor"] = {100,150,100},
	["slotsSize"] = {2,5},	--How big are the slots drawn?
	["slotsOnBar"] = false,	--If true the slots appear centered on the bar rather than below.
	["slideRectangleSize"] = {4,10},
	["slideRectanglePosition"] = 1,	--Measured in slots not pixels.
	["slideRectangleBorderColor"] = {80,200,240},
	["slideRectangleBackgroundColor"] = {100,150,100},
	["slideRectangleBorderWidth"] = 2,
	["sliderBarHeight"] = 1,	--How tall the bar the slider sits on is.
	
	--Overwride gDraw and gUpdate.
	["gDraw"] = function(se,Args)	
		love.graphics.setColor(unpack(se.backgroundColor))
		love.graphics.draw(GUIGraphics["spotImg"], se.position[1], se.position[2] + se.size[2]/2 - se.sliderBarHeight/2, 0, se.size[1], se.sliderBarHeight)
		if se.borderVisible then
			love.graphics.setColor(unpack(se.borderColor))
			drawBorder(se.position[1], se.position[2] + se.size[2]/2 - se.sliderBarHeight/2, se.size[1], se.sliderBarHeight, se.borderWidth)
		end
		local slotDistance = se.size[1] / se.slots
		
		if se.slotsVisible then
			love.graphics.setColor(unpack(se.slotsColor))
			if se.slotsOnBar then
				for i = 1, se.slots do
					love.graphics.draw(GUIGraphics["spotImg"], se.position[1] + slotDistance * i - se.slotsSize[1]/2 - slotDistance/2, se.position[2] + se.size[2]/2 - se.slotsSize[2]/2, 0, se.slotsSize[1], se.slotsSize[2])
				end
			else
				for i = 1, se.slots do
					love.graphics.draw(GUIGraphics["spotImg"], se.position[1] + slotDistance * i - se.slotsSize[1]/2 - slotDistance/2, se.position[2] + se.size[2]/2, 0, se.slotsSize[1], se.slotsSize[2])
				end
			end
		end
		local sliderPosition = {se.position[1] + slotDistance * se.slideRectanglePosition - slotDistance/2 - se.slideRectangleSize[1]/2, se.position[2] + se.size[2]/2 - se.slideRectangleSize[2]/2}
		love.graphics.setColor(unpack(se.slideRectangleBackgroundColor))
		love.graphics.draw(GUIGraphics["spotImg"], sliderPosition[1], sliderPosition[2], 0, se.slideRectangleSize[1], se.slideRectangleSize[2])
		love.graphics.setColor(unpack(se.slideRectangleBorderColor))
		drawBorder(sliderPosition[1], sliderPosition[2], se.slideRectangleSize[1], se.slideRectangleSize[2], 2)
		if se.shadingVisible then
			if se.mouseLDown then
				drawShading(sliderPosition[1], sliderPosition[2], se.slideRectangleSize[1], se.slideRectangleSize[2], se.mouseDownShadingPercent)
			elseif se.mouseHovering then
				drawShading(sliderPosition[1], sliderPosition[2], se.slideRectangleSize[1], se.slideRectangleSize[2], se.hoverShadingPercent)
			end
		end
	end,
	
	["update"] = function(se, Time)
		local slotDistance = se.size[1] / se.slots
		local sliderPosition = {se.position[1] + slotDistance * se.slideRectanglePosition - slotDistance/2 - se.slideRectangleSize[1]/2, se.position[2] + se.size[2]/2 - se.slideRectangleSize[2]/2}

		if se.mouseLDown then
			if mousePosition[1] < se.position[1]  then
				se.slideRectanglePosition = 1
			elseif mousePosition[1] > se.position[1] + se.size[1] then
				se.slideRectanglePosition = se.slots
			else
				for i = 1, se.slots do	--Any more efficient way of finding closest? :L
					if mousePosition[1] < se.position[1] + i * slotDistance then
						se.slideRectanglePosition = i
						break
					end
				end
			end
		end
	end,
	
	["gUpdate"] = function(se, Time)
		--Cache values for events
		local cacheEventStuff = {
			["bld"] = se.mouseLDown,
			["brd"] = se.mouseRDown,
			["mlcs"] = se.mouseLClickedSeconds,
			["mrcs"] = se.mouseRClickedSeconds,
			["mh"] = se.mouseHovering,
			["tts"] = se.toolTipSeconds,
		}
		
		local slotDistance = se.size[1] / se.slots
		local sliderPosition = {se.position[1] + slotDistance * se.slideRectanglePosition - slotDistance/2 - se.slideRectangleSize[1]/2, se.position[2] + se.size[2]/2 - se.slideRectangleSize[2]/2}

		local elseWasExecuted = false
		if love.mouse.getX() > sliderPosition[1] and love.mouse.getY() > sliderPosition[2] and love.mouse.getX() < sliderPosition[1] + se.slideRectangleSize[1] and love.mouse.getY() < sliderPosition[2] + se.slideRectangleSize[2] then
			se.mouseHovering = true
			if se.toolTipSeconds > 0 then
				se.toolTipSeconds = se.toolTipSeconds - Time
			end
			if mouseLeft then
				se.mouseLDown = true
				if se.mouseLClickedSeconds > 0 then
					se.mouseLClickedSeconds = se.mouseLClickedSeconds - Time
				end
			else
				se.mouseLDown = false
				se.mouseLClickedSeconds = se.mouseLClickedSeconds2
			end
			if mouseRight then
				se.mouseRDown = true
				if se.mouseRClickedSeconds > 0 then
					se.mouseRClickedSeconds = se.mouseRClickedSeconds - Time
				end
			else
				se.mouseRDown = false
				se.mouseRClickedSeconds = se.mouseRClickedSeconds2
			end
		else
			se.mouseHovering = false
			if not mouseLeft then
				se.mouseLDown = false
			end
			se.mouseRDown = false
			elseWasExecuted = true	--This is to stop mlDown and mrDown firing event callbacks.
			se.toolTipSeconds = se.toolTipSeconds2
			se.mouseLClickedSeconds = se.mouseLClickedSeconds2
			se.mouseRClickedSeconds = se.mouseRClickedSeconds2
		end
		
		--Fire necessary events.
		if not cacheEventStuff["bld"] and se.mouseLDown and not elseWasExecuted then
			se.mouseButtonLDown:run(unpack(mousePosition))
		end
		if not cacheEventStuff["brd"] and se.mouseRDown and not elseWasExecuted then
			se.mouseButtonRDown:run(unpack(mousePosition))
		end
		if cacheEventStuff["bld"] and not se.mouseLDown and not elseWasExecuted then
			se.mouseButtonLUp:run(unpack(mousePosition))
		end
		if cacheEventStuff["brd"] and not se.mouseRDown and not elseWasExecuted then
			se.mouseButtonRUp:run(unpack(mousePosition))
		end
		--[[
		if se.mouseLClickedSeconds > 0 and cacheEventStuff["bld"] and not se.mouseLDown and not elseWasExecuted then
			se.mouseButtonLClick:run(unpack(mousePosition))
		end
		if se.mouseRClickedSeconds > 0 and cacheEventStuff["bld"] and not se.mouseLDown and not elseWasExecuted then
			se.mouseButtonRClick:run(unpack(mousePosition))
		end
		]]--Old broken click code. Need to fix this. Shouldn't be too hard.
		if se.mouseHovering and not cacheEventStuff["mh"] then
			se.mouseEnter:run(unpack(mousePosition))
		end
		if not se.mouseHovering and cacheEventStuff["mh"] then
			se.mouseExit:run(unpack(mousePosition))
		end
		if se.mouseHovering and cacheEventStuff["mh"] and unpack(mousePosition) ~= unpack(mousePositionCache) then
			se.mouseMove:run(unpack(mousePosition))
		end
	end,
	
	["sliderMoved"] = newEvent()
	
	}, {GUIElement})