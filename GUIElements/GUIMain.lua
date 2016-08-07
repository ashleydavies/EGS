require("GUIElements/GUIClassDecleration")

mouseLeft = love.mouse.isDown(1)
mouseRight = love.mouse.isDown(2)
mouseLeftCache = love.mouse.isDown(1)
mouseRightCache = love.mouse.isDown(2)
mousePosition = {love.mouse.getX(), love.mouse.getY()}
mousePositionCache = {love.mouse.getX(), love.mouse.getY()}

GUIGraphics = 	{
			["spotImg"] = love.graphics.newImage("GUIUI/WhiteSpot.png"),
			["Check"] = love.graphics.newImage("GUIUI/Check.png"),
				}

GUIs = {}

function GUIUpdate(Time)
	mouseLeft = love.mouse.isDown(1)
	mouseRight = love.mouse.isDown(2)
	mousePosition = {love.mouse.getX(), love.mouse.getY()}
	for _,v in pairs(GUIs) do
		v:gUpdate(Time)	--Core updating function
		if v.update then
			v:update(Time)
		end
	end
	mouseLeftCache = love.mouse.isDown(1)
	mouseRightCache = love.mouse.isDown(2)
	mousePositionCache = {love.mouse.getX(), love.mouse.getY()}
end

function GUIDraw()
	local pr, pg, pb, al = love.graphics.getColor()
	for _,v in pairs(GUIs) do
		v:gDraw()
		if v.draw then
			v:draw()
		end
	end
	for _,v in pairs(GUIs) do
		v:gDrawFinal()	--This is for things like toolTips that need to appear above all elements. :)
	end
	love.graphics.setColor(pr,pg,pb,al)
end

--- drawBorder
---
---Draws a border around a theoretical box. Limitations: lineWidth should be even.
---
---bX: box X position
---bY: box Y position
---bW: box width
---bH: box height
---lineWidth: width of border
function drawBorder(bX,bY,bW,bH, lineWidth)
--	love.graphics.draw(GUIGraphics["spotImg"], bX-lineWidth/2, bY-lineWidth/2, 0, bW+lineWidth, lineWidth)	--Topleft-Topright
--	love.graphics.draw(GUIGraphics["spotImg"], bX-lineWidth/2, bY-lineWidth/2, 0, lineWidth, bH+lineWidth)	--Topleft-Bottomleft
--	love.graphics.draw(GUIGraphics["spotImg"], bX+bW-lineWidth/2, bY-lineWidth/2, 0, lineWidth, bH+lineWidth)	--Topright-Bottomright
--	love.graphics.draw(GUIGraphics["spotImg"],bX-lineWidth/2, bY+bH-lineWidth/2, 0, bW+lineWidth, lineWidth)	--Bottomleft-Bottomright
--Above is old code that draws the border half inside half outside. This isn't great since it looks great with thin borders but horrible with thicker borders- Shading ruins it.
	love.graphics.draw(GUIGraphics["spotImg"], bX-lineWidth, bY-lineWidth, 0, bW+lineWidth*2, lineWidth)	--Topleft-Topright
	love.graphics.draw(GUIGraphics["spotImg"], bX-lineWidth, bY-lineWidth, 0, lineWidth, bH+lineWidth*2)	--Topleft-Bottomleft
	love.graphics.draw(GUIGraphics["spotImg"], bX+bW, bY-lineWidth, 0, lineWidth, bH+lineWidth*2)	--Topright-Bottomright
	love.graphics.draw(GUIGraphics["spotImg"], bX-lineWidth, bY+bH, 0, bW+lineWidth*2, lineWidth)	--Bottomleft-Bottomright
end

--- drawShading
---
---Draws shading.
---
---bX: box X position
---bY: box Y position
---bW: box width
---bH: box height
---transparency: number between 0 and 100. 100 is fully invisible and 0 is fully visible.
function drawShading(bX, bY, bW, bH, transparency)	
	love.graphics.setColor(0,0,0,(255/100)*transparency)
	love.graphics.draw(GUIGraphics["spotImg"], bX, bY, 0, bW, bH)
end

require("GUIElements/CheckBox")
require("GUIElements/TextButton")
require("GUIElements/Slider")