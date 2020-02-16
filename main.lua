require("Class")
require("GUIElements/GUIMain")

function giveTheme(element)
	element.backgroundColor = {math.random(), math.random(), math.random(), 1}
	element.borderColor = {math.random(), math.random(), math.random(), 1}
	element.toolTipVisible = true
	element.toolTipText = element.className
	--Check out 'GUIClassDeclaration.lua' for more GUI properties. They've got many more properties!
end

function constructButton(text, position)
	button = TextButton:new()
	button.text = text
	button.position = position
	button.textFittingMinimumPadding = 10
	button:resizeToText()
	return button
end

function love.load()
	love.graphics.setFont(love.graphics.setNewFont(10))
	love.graphics.setBackgroundColor(1, 1, 1)
	
	GE1 = GUIElement:new()
	GE1.size = {64, 32}
	GE1.position = {12, 12}
	giveTheme(GE1)
	--GUIElement is an empty frame. It reacts with shading and has most events. It also has a toolTip. It's not a very usefull object.
	--It's main reason for existance is because other elements all inherit it's properties.

	CB1 = CheckBox:new()
	CB1.position = {12 + 64 + 10, 12}
	giveTheme(CB1)
	
	TB1 = TextButton:new()
	TB1.position = {12 + 64 + 32 + 10 + 10, 12}
	TB1.text = "This is a TextButton! It'll resize until textFitting is true!"
	giveTheme(TB1)
	
	SL1 = Slider:new()
	SL1.position = {12, 12 + 32 + 10}
	SL1.size = {128, 32}
	giveTheme(SL1)

	button1 = constructButton("Hello World", {300, 300})
	giveTheme(button1)
end

function love.update(time)
	GUIUpdate(time)
	if not TB1.textFitting then
		TB1.size[1] = TB1.size[1] + 1
	end
end

function love.draw()
	GUIDraw()
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print(GE1.toolTipSeconds,100,100)
end
