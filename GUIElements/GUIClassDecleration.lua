function newEvent()
	return {
		["num"] = 0,
		["connected"] = {},
		["connect"] = function(ev,func)
			ev.num = ev.num + 1
			ev.connected[ev.num] = func
			return {
				["disconnect"] = function(se)
					se.connected = false
					ev.connected[ev.num] = nil
				end,
				["connected"] = true
			}
		end,
		["run"] = function(ev,...)
			for _,v in pairs(ev.connected) do
				v(...)
			end
		end
	}
end

Class("GUIElement") {					
						["load"] = function(se)
							table.insert(GUIs,se)
						end,
						
						
						["visible"] = true,
						["backgroundColor"] = {200,100,100},
						["shadingVisible"] = true,
						["hoverShadingPercent"] = 10, --How dark (in percent - 0 is invisible, 100 is pitch black) the hover shading should be
						["mouseDownShadingPercent"] = 30, --How dark in percent the mouse down shading should be. Applies to left button only.
						["borderVisible"] = true,
						["borderColor"] = {80,200,240},
						["borderWidth"] = 2,
						["toolTipVisible"] = false,
						["toolTipText"] = "toolTip",
						["toolTipSeconds"] = 0.5,	--Works same as mouseClickedSeconds.
						["toolTipSeconds2"] = 0.5,
						["toolTipBorderColor"] = {80,200,240},
						["toolTipBackgroundColor"] = {100,150,100},
						
						["size"] = {50,20},
						["position"] = {20,20},
						
						["mouseLDown"] = false,
						["mouseRDown"] = false,
						["mouseHovering"] = false,
						["mouseLClickedSeconds"] = 0.5, --If they press the mouse button then release it within this amount of time, it will count as a Click.
						["mouseLClickedSeconds2"] = 0.5, --Same as above, but this is so the script remembers what to reset it to once it reaches 0.
						["mouseRClickedSeconds"] = 0.5,
						["mouseRClickedSeconds2"] = 0.5,
						
						["gDraw"] = function(se)	--Default GUI draw function. Some elements override this function but it should be used in most.
							love.graphics.setColor(unpack(se.backgroundColor))
							love.graphics.draw(GUIGraphics["spotImg"], se.position[1], se.position[2], 0, se.size[1], se.size[2])
							if se.borderVisible then
								love.graphics.setColor(unpack(se.borderColor))
								drawBorder(se.position[1], se.position[2], se.size[1], se.size[2], se.borderWidth)
							end
							if se.shadingVisible then
								if se.mouseHovering and se.mouseLDown then
									drawShading(se.position[1], se.position[2], se.size[1], se.size[2], se.mouseDownShadingPercent)
								elseif se.mouseHovering then
									drawShading(se.position[1], se.position[2], se.size[1], se.size[2], se.hoverShadingPercent)
								end
							end
						end,
						
						["gDrawFinal"] = function(se)
							--toolTip
							if se.toolTipVisible and se.toolTipSeconds <= 0 then
								--dun dun dunnnn
								local position = {mousePosition[1] + 20, mousePosition[2] + 20}
								local size = {love.graphics.getFont():getWidth(se.toolTipText) + 6, love.graphics.getFont():getHeight() + 6}
								love.graphics.setColor(se.toolTipBackgroundColor[1], se.toolTipBackgroundColor[2], se.toolTipBackgroundColor[3], 255)
								love.graphics.draw(GUIGraphics["spotImg"], position[1], position[2], 0, size[1], size[2])
								love.graphics.setColor(se.toolTipBorderColor[1], se.toolTipBorderColor[2], se.toolTipBorderColor[3], 255)
								drawBorder(position[1], position[2], size[1], size[2], 2)
								love.graphics.setColor(0,0,0,255)
								love.graphics.print(se.toolTipText, position[1] + 3, position[2] + 3)
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
							local elseWasExecuted = false
							if love.mouse.getX() > se.position[1] and love.mouse.getY() > se.position[2] and love.mouse.getX() < se.position[1] + se.size[1] and love.mouse.getY() < se.position[2] + se.size[2] then
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
								se.mouseLDown = false
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
						
						
						--Events
						["mouseButtonLDown"] = newEvent("mouseButtonLDown"),
						["mouseButtonRDown"] = newEvent("mouseButtonRDown"),
						["mouseButtonLUp"] = newEvent("mouseButtonLUp"),
						["mouseButtonRUp"] = newEvent("mouseButtonRUp"),
						["mouseButtonLClick"] = newEvent("mouseButtonLClick"),
						["mouseButtonRClick"] = newEvent("mouseButtonRClick"),
						["mouseEnter"] = newEvent("mouseEntered"),
						["mouseExit"] = newEvent("mouseExited"),
						["mouseMove"] = newEvent("mouseMove"),
						["toolTipStartShowing"] = newEvent("toolTipStartShowing"),
						["toolTipStopShowing"] = newEvent("toolTipStopShowing"),
					}
