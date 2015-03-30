--Use
--Class "Name" {Properties}
--Class "Name" ( {Properties}, {Inherited classes})

local function CloneTable(tab)
	local rT = {} --returnTable
	for key,val in pairs(tab) do
		if type(val) == "table" then
			rT[key] = CloneTable(val)
		else
			rT[key] = val
		end
	end
	return rT
end

function Class(className)
	return function(ClassProperties,InheritsFrom)	--Ugly hax for aesthetic calling purpouses

		local className, ClassProperties, InheritsFrom = className, ClassProperties, InheritsFrom
		local returnTable = {}
		--returnTable.Properties = ClassProperties
		returnTable.Properties = {}
		if InheritsFrom ~= nil then
			for _,v in pairs(InheritsFrom) do
				for _2,subv in pairs(v.Properties) do
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
		for _2,subv in pairs(ClassProperties) do
			if type(_2) == "number" then
				returnTable.Properties[subv] = ""
			elseif type(_2) == "function" then
				local fn = string.dump(subv)
				returnTable.Properties[_2] = loadstring(fn)
			else
				returnTable.Properties[_2] = subv
			end
		end

		returnTable.new = function(s,nameArgs)
			local rT = {}	--returnTable
			for _,v in pairs(returnTable.Properties) do
				if type(_) == "number" then	--Allows for default values.
					rT[v] = ""
				elseif type(v) == "table" then
					rT[_] = CloneTable(v)
				else
					rT[_] = v
				end
			end
			rT["className"] = className
			rT["name"] = nameArgs
		
			if rT["load"] ~= nil then
				rT:load()
			end
			getfenv(2)[nameArgs] = rT
		end

		getfenv(2)[className] = returnTable
	end
end
