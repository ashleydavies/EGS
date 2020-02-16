--Use
--Class "Name" {Properties}
--Class "Name" ( {Properties}, {Inherited classes})

local function CloneTable(tab)
	local rT = {} --returnTable
	for key, val in pairs(tab) do
		if type(val) == "table" then
			rT[key] = CloneTable(val)
		else
			rT[key] = val
		end
	end
	return rT
end

function Class(className)
	return function(ClassProperties, InheritsFrom) --Ugly hax for aesthetic calling purpouses
		local className, ClassProperties, InheritsFrom = className, ClassProperties, InheritsFrom
		local returnTable = {}
		--returnTable.Properties = ClassProperties
		returnTable.Properties = {}
		if InheritsFrom ~= nil then
			for _, v in pairs(InheritsFrom) do
				for _2, subv in pairs(v.Properties) do
					if type(_2) == "number" then
						returnTable.Properties[subv] = ""
					elseif type(_2) == "function" then
						local fn = string.dump(subv)
						returnTable.Properties[_2] = loadstring(fn)
					else
						returnTable.Properties[_2] = subv
					end
				end
			end
		end
		for _2, subv in pairs(ClassProperties) do
			if type(_2) == "number" then
				returnTable.Properties[subv] = ""
			elseif type(_2) == "function" then
				local fn = string.dump(subv)
				returnTable.Properties[_2] = loadstring(fn)
			else
				returnTable.Properties[_2] = subv
			end
		end

		returnTable.new = function(s, nameArgs)
			local newObject = {}
			for _, v in pairs(returnTable.Properties) do
				if type(_) == "number" then --Allows for default values.
					newObject[v] = ""
				elseif type(v) == "table" then
					newObject[_] = CloneTable(v)
				else
					newObject[_] = v
				end
			end
			newObject["className"] = className

			if newObject["load"] ~= nil then
				newObject:load()
			end
			if nameArgs == "" or nameArgs == nil then
				return newObject
			end
			-- If they passed a name, create it in their local function scope
			getfenv(2)[nameArgs] = newObject
		end

		if className == "" or className == nil then
			return returnTable
		end
		-- If they passed a name, create it in their local function scope
		getfenv(2)[className] = returnTable
	end
end
