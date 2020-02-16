Class("Slider")(
	{
		["load"] = function(s)
			table.insert(GUIs, s)
		end,
		["clickedOn"] = false,
		["hoverShadingPercent"] = 20, --Better to have a darker shading because it's harder to see on a slider
		["mouseDownShadingPercent"] = 30,
		["slots"] = 6, --How many slots for the slideRectangle to fit into.
		["slotsVisible"] = true, --Do the slots display?
		["slotsColor"] = {0.4, 0.5, 0.4, 1},
		["slotsSize"] = {2, 5}, --How big are the slots drawn?
		["slotsOnBar"] = true, --If true the slots appear centered on the bar rather than below.
		["slideRectangleSize"] = {4, 10},
		["slideRectanglePosition"] = 1, --Measured in slots not pixels.
		["slideRectangleBorderColor"] = {0.3, 0.8, 0.9, 1},
		["slideRectangleBackgroundColor"] = {0.4, 0.5, 0.4, 1},
		["slideRectangleBorderWidth"] = 2,
		["sliderBarHeight"] = 1, --How tall the bar the slider sits on is.
		--Overwride gDraw and gUpdate.
		["gDraw"] = function(se, Args)
			love.graphics.setColor(unpack(se.backgroundColor))
			love.graphics.draw(
				GUIGraphics["spotImg"],
				se.position[1],
				se.position[2] + se.size[2] / 2 - se.sliderBarHeight / 2,
				0,
				se.size[1],
				se.sliderBarHeight
			)
			if se.borderVisible then
				love.graphics.setColor(unpack(se.borderColor))
				drawBorder(
					se.position[1],
					se.position[2] + se.size[2] / 2 - se.sliderBarHeight / 2,
					se.size[1],
					se.sliderBarHeight,
					se.borderWidth
				)
			end
			local slotDistance = se.size[1] / se.slots

			if se.slotsVisible then
				love.graphics.setColor(unpack(se.slotsColor))
				if se.slotsOnBar then
					for i = 1, se.slots do
						love.graphics.draw(
							GUIGraphics["spotImg"],
							se.position[1] + slotDistance * i - se.slotsSize[1] / 2 - slotDistance / 2,
							se.position[2] + se.size[2] / 2 - se.slotsSize[2] / 2,
							0,
							se.slotsSize[1],
							se.slotsSize[2]
						)
					end
				else
					for i = 1, se.slots do
						love.graphics.draw(
							GUIGraphics["spotImg"],
							se.position[1] + slotDistance * i - se.slotsSize[1] / 2 - slotDistance / 2,
							se.position[2] + se.size[2] / 2,
							0,
							se.slotsSize[1],
							se.slotsSize[2]
						)
					end
				end
			end
			local sliderPosition = {
				se.position[1] + slotDistance * se.slideRectanglePosition - slotDistance / 2 - se.slideRectangleSize[1] / 2,
				se.position[2] + se.size[2] / 2 - se.slideRectangleSize[2] / 2
			}
			love.graphics.setColor(unpack(se.slideRectangleBackgroundColor))
			love.graphics.draw(
				GUIGraphics["spotImg"],
				sliderPosition[1],
				sliderPosition[2],
				0,
				se.slideRectangleSize[1],
				se.slideRectangleSize[2]
			)
			love.graphics.setColor(unpack(se.slideRectangleBorderColor))
			drawBorder(sliderPosition[1], sliderPosition[2], se.slideRectangleSize[1], se.slideRectangleSize[2], 2)
			if se.shadingVisible then
				if se.mouseLDown then
					drawShading(
						sliderPosition[1],
						sliderPosition[2],
						se.slideRectangleSize[1],
						se.slideRectangleSize[2],
						se.mouseDownShadingPercent
					)
				elseif se.mouseHovering then
					drawShading(
						sliderPosition[1],
						sliderPosition[2],
						se.slideRectangleSize[1],
						se.slideRectangleSize[2],
						se.hoverShadingPercent
					)
				end
			end
		end,
		["update"] = function(se, Time)
			local slotDistance = se.size[1] / se.slots
			local sliderPosition = {
				se.position[1] + slotDistance * se.slideRectanglePosition - slotDistance / 2 - se.slideRectangleSize[1] / 2,
				se.position[2] + se.size[2] / 2 - se.slideRectangleSize[2] / 2
			}

			if se.mouseLDown then
				if mousePosition[1] < se.position[1] then
					se.slideRectanglePosition = 1
				elseif mousePosition[1] > se.position[1] + se.size[1] then
					se.slideRectanglePosition = se.slots
				else
					for i = 1, se.slots do --Any more efficient way of finding closest? :L
						if mousePosition[1] < se.position[1] + i * slotDistance then
							se.slideRectanglePosition = i
							break
						end
					end
				end
			end
		end,
		["gUpdate"] = function(self, dt)
			--Cache values for events
			local previously = {
				["bld"] = self.mouseLDown,
				["brd"] = self.mouseRDown,
				["mh"] = self.mouseHovering,
				["tts"] = self.toolTipSeconds
			}

			local slotDistance = self.size[1] / self.slots
			local sliderPosition = {
				self.position[1] + slotDistance * self.slideRectanglePosition - slotDistance / 2 - self.slideRectangleSize[1] / 2,
				self.position[2] + self.size[2] / 2 - self.slideRectangleSize[2] / 2
			}

			local mouseWithinComponent =
				love.mouse.getX() > sliderPosition[1] and love.mouse.getY() > sliderPosition[2] and
				love.mouse.getX() < sliderPosition[1] + self.slideRectangleSize[1] and
				love.mouse.getY() < sliderPosition[2] + self.slideRectangleSize[2]

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
				if not mouseLeft then
					self.mouseLDown = false
				end
				self.mouseRDown = false
				self.toolTipSeconds = self.toolTipSeconds2
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
		["sliderMoved"] = newEvent()
	},
	{GUIElement}
)
