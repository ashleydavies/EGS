function newEvent()
	return {
		["num"] = 0,
		["connected"] = {},
		["connect"] = function(ev, func)
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
		["run"] = function(ev, ...)
			for _, v in pairs(ev.connected) do
				v(...)
			end
		end
	}
end

Class("GUIElement") {
	["load"] = function(se)
		table.insert(GUIs, se)
	end,
	["visible"] = true,
	["backgroundColor"] = {0.8, 0.5, 0.5, 1},
	["shadingVisible"] = true,
	["hoverShadingPercent"] = 10, --How dark (in percent - 0 is invisible, 100 is pitch black) the hover shading should be
	["mouseDownShadingPercent"] = 30, --How dark in percent the mouse down shading should be. Applies to left button only.
	["borderVisible"] = true,
	["borderColor"] = {0.2, 0.7, 0.9, 1},
	["borderWidth"] = 2,
	["toolTipVisible"] = false,
	["toolTipText"] = "toolTip",
	["toolTipSeconds"] = 0.5, --Works same as mouseClickedSeconds.
	["toolTipSeconds2"] = 0.5,
	["toolTipBorderColor"] = {0.2, 0.9, 0.95, 1},
	["toolTipBackgroundColor"] = {0.3, 0.6, 0.7, 1},
	["size"] = {50, 20},
	["position"] = {20, 20},
	["mouseLDown"] = false,
	["mouseRDown"] = false,
	["mouseHovering"] = false,
	["mouseLClickedSeconds"] = 0.5, --If they press the mouse button then release it within this amount of time, it will count as a Click.
	["mouseLClickedSeconds2"] = 0.5, --Same as above, but this is so the script remembers what to reset it to once it reaches 0.
	["mouseRClickedSeconds"] = 0.5,
	["mouseRClickedSeconds2"] = 0.5,
	["gDraw"] = function(se) --Default GUI draw function. Some elements override this function but it should be used in most.
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
			local position = {mousePosition[1] + 20, mousePosition[2] + 20}
			local size = {love.graphics.getFont():getWidth(se.toolTipText) + 6, love.graphics.getFont():getHeight() + 6}
			love.graphics.setColor(unpack(se.toolTipBackgroundColor))
			love.graphics.draw(GUIGraphics["spotImg"], position[1], position[2], 0, size[1], size[2])
			love.graphics.setColor(unpack(se.toolTipBorderColor))
			drawBorder(position[1], position[2], size[1], size[2], 2)
			love.graphics.setColor(0, 0, 0, 255)
			love.graphics.print(se.toolTipText, position[1] + 3, position[2] + 3)
		end
	end,
	["gUpdate"] = function(self, Time)
		--Cache values for events
		local cacheEventStuff = {
			["bld"] = self.mouseLDown,
			["brd"] = self.mouseRDown,
			["mlcs"] = self.mouseLClickedSeconds,
			["mrcs"] = self.mouseRClickedSeconds,
			["mh"] = self.mouseHovering,
			["tts"] = self.toolTipSeconds
		}
		local elseWasExecuted = false
		if
			love.mouse.getX() > self.position[1] and love.mouse.getY() > self.position[2] and
				love.mouse.getX() < self.position[1] + self.size[1] and
				love.mouse.getY() < self.position[2] + self.size[2]
		 then
			self.mouseHovering = true
			if self.toolTipSeconds > 0 then
				self.toolTipSeconds = self.toolTipSeconds - Time
			end
			if mouseLeft then
				self.mouseLDown = true
				if self.mouseLClickedSeconds > 0 then
					self.mouseLClickedSeconds = self.mouseLClickedSeconds - Time
				end
			else
				self.mouseLDown = false
				self.mouseLClickedSeconds = self.mouseLClickedSeconds2
			end
			if mouseRight then
				self.mouseRDown = true
				if self.mouseRClickedSeconds > 0 then
					self.mouseRClickedSeconds = self.mouseRClickedSeconds - Time
				end
			else
				self.mouseRDown = false
				self.mouseRClickedSeconds = self.mouseRClickedSeconds2
			end
		else
			self.mouseHovering = false
			self.mouseLDown = false
			self.mouseRDown = false
			elseWasExecuted = true --This is to stop mlDown and mrDown firing event callbacks.
			self.toolTipSeconds = self.toolTipSeconds2
			self.mouseLClickedSeconds = self.mouseLClickedSeconds2
			self.mouseRClickedSeconds = self.mouseRClickedSeconds2
		end

		--Fire necessary events.
		if not cacheEventStuff["bld"] and self.mouseLDown and not elseWasExecuted then
			self.mouseButtonLDown:run(unpack(mousePosition))
		end
		if not cacheEventStuff["brd"] and self.mouseRDown and not elseWasExecuted then
			self.mouseButtonRDown:run(unpack(mousePosition))
		end
		if cacheEventStuff["bld"] and not self.mouseLDown and not elseWasExecuted then
			self.mouseButtonLUp:run(unpack(mousePosition))
		end
		if cacheEventStuff["brd"] and not self.mouseRDown and not elseWasExecuted then
			self.mouseButtonRUp:run(unpack(mousePosition))
		end
		 --Old broken click code. Need to fix this. Shouldn't be too hard.
		--[[
							if se.mouseLClickedSeconds > 0 and cacheEventStuff["bld"] and not se.mouseLDown and not elseWasExecuted then
								se.mouseButtonLClick:run(unpack(mousePosition))
							end
							if se.mouseRClickedSeconds > 0 and cacheEventStuff["bld"] and not se.mouseLDown and not elseWasExecuted then
								se.mouseButtonRClick:run(unpack(mousePosition))
							end
							]] if
			self.mouseHovering and not cacheEventStuff["mh"]
		 then
			self.mouseEnter:run(unpack(mousePosition))
		end
		if not self.mouseHovering and cacheEventStuff["mh"] then
			self.mouseExit:run(unpack(mousePosition))
		end
		if self.mouseHovering and cacheEventStuff["mh"] and unpack(mousePosition) ~= unpack(mousePositionCache) then
			self.mouseMove:run(unpack(mousePosition))
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
	["toolTipStopShowing"] = newEvent("toolTipStopShowing")
}
