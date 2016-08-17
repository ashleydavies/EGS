#Registering Interest

I am considering coming back to this project and re-writing and expanding upon it, if there is a desire for this. In this event, I would likely migrate it to a proper class system like https://github.com/kikito/middleclass, instead of the one I rolled, which is awful.

If you decide to use this code, I implore you to let me know at ashley@daviesl.uk so I can gauge whether or not there is any interest.

Should you email me, please title it "Registering EGS Interest". You can write whatever you like as a message, or even leave it blank.

#EGS

EGS, Easy GUI System, is a library I wrote sometime between 2010 and 2012 for LÖVE.

It provides a straightforward way to create, edit and get data from GUI on-screen.

Some of the code is hacky and patched together, as it is quite an old project.

It has recently been, thanks to a contribution by buckle2000, updated to support LÖVE 0.10.x.

#Old README

This is a GUI library for Love2D. It's very customizable and has literally tens of features.

It has a full-fledged event system (Similar to the one found at http://roblox.com) (Object.Event:connect(function))

It's realy easy to use! Here's a basic example:


	require("Class.lua")
	require("GUIElements\/GUIMain.lua")
	
	function love.load()
		Button:new("ClickButton")
		ClickButton.text = "Move mouse on me and I will move to the left!"
		ClickButton:adjustSizeToText()
		--This changes it's size to the text's size, but also gives 2.5 pixels padding on all sides.
		ClickButton.position = {100, 100}
		--Position at x: 100, y: 100
		ClickButton.hasCaption = true
		--This makes the caption display a few seconds into hovering mouse on GUI (Second count adjustable!)
		ClickButton.caption = "Don't be shy! Move your mouse until I disapear!"
		--Sets the hover caption.
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


And that's a functional button that when you move your mouse on it, it moves away to the left! Simple, and easy!
It looks longer than it is because of all the comments, though.
