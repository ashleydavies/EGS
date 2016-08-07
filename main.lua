require("Class")
require("GUIElements/GUIMain")

--------------NOTE

-----This project (GUIUI/ and GUIElements/) uses lpglv2 open source license. Just give me credit, please. 
-----Trappingnoobs

function giveTheme(element)
	element.backgroundColor = {math.random(1,255),math.random(1,255),math.random(1,255)}
	element.borderColor = {math.random(1,255),math.random(1,255),math.random(1,255)}
	element.toolTipVisible = true
	element.toolTipText = element.className..": "..element.name
	--Check out 'GUIClassDecleration.lua' for more GUI properties. They've got tens of properties!
end

function love.load()
	love.graphics.setFont(love.graphics.setNewFont(10))
	love.graphics.setBackgroundColor(255,255,255)
	
	GUIElement:new("GE1")
	GE1.size = {64,32}
	GE1.position = {12,12}
	giveTheme(GE1)
	--GUIElement is an empty frame. It reacts with shading and has most events. It also has a toolTip. It's not a very usefull object.
	--It's main reason for existance is because other elements all inherit it's properties.

	CheckBox:new("CB1")
	CB1.position = {12+64+10,12}
	giveTheme(CB1)
	
	TextButton:new("TB1")
	TB1.position = {12+64+32+10+10,12}
	TB1.text = "This is a TextButton! It'll resize until textFitting is true!"
	giveTheme(TB1)
	
	Slider:new("SL1")
	SL1.position = {12, 12 + 32 + 10}
	SL1.size = {128, 32}
	giveTheme(SL1)
end

function love.update(Time)
	GUIUpdate(Time)
	if not TB1.textFitting then
		TB1.size[1] = TB1.size[1] + 1
	end
end

function love.draw()
	GUIDraw()
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(GE1.toolTipSeconds,100,100)
end