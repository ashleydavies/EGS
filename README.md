# Registering Interest

I am considering coming back to this project and re-writing and expanding upon it, if there is a desire for this. In this event, I would likely migrate it to a proper class system like https://github.com/kikito/middleclass, instead of the one I rolled, which is awful.

If you decide to use this code, I'd ask you let me know at ashley@davies.me.uk so that I can gauge whether or not there is any interest.

Should you email me, please title it "Registering EGS Interest". You can write whatever you like as a message, or even leave it blank.

# EGS

EGS, Easy GUI System, is a library I wrote sometime between 2010 and 2012 for LÖVE.

It provides a straightforward way to create, edit and get data from GUI on-screen.

Some of the code is hacky and patched together, as it is quite an old project.

It has recently been, thanks to a contribution by buckle2000, updated to support LÖVE 0.10.x.

# Old README

This is a GUI library for Love2D, aimed at being simple to set up and use.

It has an event system similar to the one found at http://roblox.com, e.g. `Object.Event:connect(function)` to register an event handler

Here's a basic example:

```lua
require("Class.lua")
require("GUIElements/GUIMain.lua")
	
function love.load()
	ClickButton = TextButton:new()
	ClickButton.text = "Move mouse on me and I will move to the left!"

	--This changes its size to the text size, and also gives 2.5 pixels padding on all sides.
	ClickButton:adjustSizeToText()
	
	ClickButton.position = {100, 100}
	
	ClickButton.hasCaption = true
	ClickButton.caption = "Don't be shy! Move your mouse until I disapear!"

	-- The function we pass is run every time the mouse is moved on the element
	ClickButton.mouseMoved:connect(function(x,y)
		--x and y are passed as arguments in most mouse events. We won't use them this time.
		ClickButton.position[1] = ClickButton.position[1] - 1
	end)
end

function love.draw()
	GUIDraw()
end

function love.update()
	GUIUpdate()
end
```

And that's a functional button that when you move your mouse on it, it moves away to the left! Simple, and easy!
