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
	["zIndex"] = 0,
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
	["gUpdate"] = function(self, dt)
		--Cache values for events
		local previously = {
			["bld"] = self.mouseLDown,
			["brd"] = self.mouseRDown,
			["mlcs"] = self.mouseLClickedSeconds,
			["mrcs"] = self.mouseRClickedSeconds,
			["mh"] = self.mouseHovering,
			["tts"] = self.toolTipSeconds
		}

		local mouseWithinComponent =
			love.mouse.getX() > self.position[1] and love.mouse.getY() > self.position[2] and
			love.mouse.getX() < self.position[1] + self.size[1] and
			love.mouse.getY() < self.position[2] + self.size[2]

		if mouseWithinComponent then
			self.mouseHovering = true
			if self.toolTipSeconds > 0 then
				self.toolTipSeconds = self.toolTipSeconds - dt
			end
			if mouseLeft then
				self.mouseLDown = true
				if not mouseLeftCache then
					self.mouseLDownWithinThisComponent = true
				end
			else
				self.mouseLDown = false
			end
			if mouseRight then
				self.mouseRDown = true
				if not mouseRightCache then
					self.mouseRDownWithinThisComponent = true
				end
			else
				self.mouseRDown = false
			end
		else
			self.mouseHovering = false
			self.mouseLDown = false
			self.mouseRDown = false
			self.toolTipSeconds = self.toolTipSeconds2
			self.mouseLDownWithinThisComponent = false
			self.mouseRDownWithinThisComponent = false
		end

		--Fire necessary events.
		if not previously["bld"] and self.mouseLDown and not mouseLeftCache then
			self.mouseButtonLDown:run(unpack(mousePosition))
		end
		if not previously["brd"] and self.mouseRDown and not mouseRightCache then
			self.mouseButtonRDown:run(unpack(mousePosition))
		end
		if previously["bld"] and not self.mouseLDown then
			self.mouseButtonLUp:run(unpack(mousePosition))
		end
		if previously["brd"] and not self.mouseRDown then
			self.mouseButtonRUp:run(unpack(mousePosition))
		end
		if previously["bld"] and not self.mouseLDown and self.mouseLDownWithinThisComponent then
			self.mouseButtonLClick:run(unpack(mousePosition))
		end
		if previously["brd"] and not self.mouseRDown and self.mouseRDownWithinThisComponent then
			self.mouseButtonRClick:run(unpack(mousePosition))
		end
		if self.mouseHovering and not previously["mh"] then
			self.mouseEnter:run(unpack(mousePosition))
		end
		if not self.mouseHovering and previously["mh"] then
			self.mouseExit:run(unpack(mousePosition))
		end
		if self.mouseHovering and previously["mh"] and unpack(mousePosition) ~= unpack(mousePositionCache) then
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
