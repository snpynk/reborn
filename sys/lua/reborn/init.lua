--{{{ HEROES REBORN / MAIN
--{{{ READ info.lua

reb = {}
reb.ABOUT = {
	name = "Super Hero Reborn";
	author = "_Yank";
	version = "1.12beta";
	codename = "Aye Captain!";
	date = "10/02/2016";
	path = "sys/lua/reborn";
	debug = false;
}

if reb.ABOUT.debug then
	reb.DEB_COL = "\169000255000"
	reb.DEB_SCOL = "\169255000000"
	print(reb.DEB_COL.."Initializing "..reb.ABOUT.author.."'s Heroes Reborn Mod v"..reb.ABOUT.version.."...")
	print(reb.DEB_COL.."Working directory: "..reb.ABOUT.path)
	print("Last updated: "..reb.ABOUT.date)
end

function reb.LOAD(file)
	if reb.ABOUT.debug then
		print(reb.DEB_COL.."Loading "..file.."...")
		local _, err = pcall(dofile, reb.ABOUT.path.."/"..file)
		if err then print(err); print(reb.DEB_SCOL.."     Error, couldn't load "..file.." correctly!") return end
		print("     "..file.." has been loaded correctly!")
	else dofile(reb.ABOUT.path.."/"..file) end
end

reb.LOAD("values.lua")
reb.LOAD("setup.lua")
reb.LOAD("client.lua")
reb.LOAD("commands.lua")

pi.maxPlayers = tonumber(game("sv_maxplayers"))
pi.newUser = function() 
	return { 
		heroes = {},
		inventory = {},

		level = 1,
		exp = 0,

		nexp = reb.config.level_ratio,
		ratio = reb.config.level_ratio,
		brave = false,

		points = reb.config.point_start,
		credits = reb.config.credits_start,

		ioSleep = false,
		ioLoaded = false,
	}
end

for id = 1, pi.maxPlayers do pi[id] = pi.newUser() end

reb.hooks = {
	serveraction = function(id, button)
		reb.dohook("serveraction", id, button)

		if button == 1 then cl.popMenu(id)
		elseif button == 2 then cl.popCmds(id)
		elseif button == 3 then cl.popItems(id) end
	end;

	spawn = function(id)
	--	for _, itemId in pairs(playerweapons(id)) do parse("strip "..id.." "..itemId) end

		if pi[id].points > 0 then cl.popHeroes(id) end

		local items = cl.setup(id)
		
		reb.dohook("spawn", id)
		return "50,"..table.concat(items, ",")
	end;

	team = function(id, team)
		local pi = pi[id]
		if not pi.ioLoaded and not player(id,"bot") then cl.load(id) end

		return reb.dohook("team", id, team) or nil
	end;

	second = function()
		reb.TICK = reb.TICK + 1
		if reb.TICK >= reb.UPRATE then
			reb.hooks.update()
			reb.TICK = 0
		end

		return reb.dohook("second") or nil
	end;

	update = function()
		return reb.dohook("update") or nil
	end;

	hit = function(id, source, weapon, hpDmg, apDmg)
		if id == source then return 1 end

		return reb.dohook("hit", id, source, weapon, hpDmg, apDmg) or nil
	end;

	die = function(id, source, weapon, x, y)
		cl.killReward(source, id, weapon)
		return reb.dohook("die", id, source, weapon, x, y) or nil
	end;

	startround = function()
		local winner = (game("winrow_t") > 0 and 1) or 2
		local exp = math.floor(reb.config.exp_ratio * 0.5)
		for _, id in ipairs(player(0, "tableliving")) do
			if player(id, "team") == winner then
				msg2(id, reb.color.lilac.."Your team won the round!@C")
				msg2(id, reb.color.pos.."You got extra "..exp.." exp for that!@C")
				cl.giveExp(id, exp)
				parse("sv_sound2 "..id.." \""..reb.config.sound_win.."\"")
			else parse("sv_sound2 "..id.." \""..reb.config.sound_loose.."\"") end
		end
	end;

	dominate = function(id, team, x, y)
		local exp = math.floor(reb.config.exp_ratio * 0.05)
		cl.giveExp(id, exp)
		msg2(id, reb.color.neu.."You dominated a point!@C")
		msg2(id, reb.color.pos.."You got extra "..exp.." exp for that!@C")
	end;
	
	drop = function(...)
		return reb.dohook("drop", ...) or 1
	end;
	
	join = function(id)
		pi[id] = pi.newUser()
		reb.dohook("join", id)
	end;
}

-- @hook(hook_name, function_name, priority)
-- Hooks a function to an event directly
reb.freehook = freehook
reb.hooks.items = {}

-- @hook(hook_name, function_name, priority)
-- Hooks a function to an event
function reb.hook(event, func, prio)
	if not reb.hooks.items[event] then reb.hooks.items[event] = {} end
	if not prio then prio = #reb.hooks.items[event] + 1 
	elseif prio > #reb.hooks.items[event] then prio = #reb.hooks.items[event] + 1
	elseif prio < 0 then prio = 1 end
	reb.hooks.items[prio] = func
	table.insert(reb.hooks.items[event], prio, func)
	if not reb.hooks[event] then 
		loadstring("reb.hooks."..event.." = function(...) return "..table.concat(reb.hooks.items[event], "(...) or ").."(...) end")()
		addhook(event, "reb.hooks."..event)
		reb.hooks.items[event].auto = true
	elseif reb.hooks.items[event].auto then
		loadstring("reb.hooks."..event.." = function(...) return "..table.concat(reb.hooks.items[event], "(...) or ").."(...) end")()
	end

	print(reb.color.lilac.."Function "..func.." has been hooked to "..event.." hook")
end

-- @freehook(hook_name, function_name)
-- Frees a function from an event
function reb.freehook(event, func)
	if not reb.hooks.items[event] then error("No function has been hooked to the event: "..event) return end
	for evenK, func2 in ipairs(reb.hooks.items[event]) do if func == func2 then table.remove(reb.hooks.items[event], evenK) end end
	
	if reb.hooks.items[event].auto then
		if #reb.hooks.items[event] <= 0  then
			reb.freehook(event, func)
		else loadstring("reb.hooks."..event.." = function(...) return "..table.concat(reb.hooks.items[event], "(...) or ").."(...) end")() end
	end

	print(reb.color.lilac.."Function "..func.." has been freed from "..event.." hook")
end

-- @dohook(event_name)
-- Runs the functions hooked on the specified event
function reb.dohook(event, ...)
	local params = {...} or false
	if not reb.hooks.items[event] then return end
	if params then
		params = table.concat(params, ",")
		for _, func in ipairs(reb.hooks.items[event]) do
			local ret = {loadstring("return "..func.."("..params..")")()}
			if ret then return unpack(ret) end
		end
	end
end

-- @copy(object)
-- Returns a copy of the specified object (variable, array, table, etc)
function reb.copy(object)
	local tempTab = {}
	local function _copy(object)
		if type(object) ~= "table" then return object
		elseif tempTab[object] then return tempTab[object] end
		local newTab = {}
		tempTab[object] = newTab
		for key, value in pairs(object) do newTab[_copy(key)] = _copy(value) end
		return setmetatable(newTab, getmetatable(object))
	end
	return _copy(object)
end

-- @order(table)
-- Iterates over a table that follows the REBY syntax (first numeric index (1), is the position on the list)
function reb.order(tab)
	local tempTab = {}
	for key, value in pairs(tab) do
		tempTab[#tempTab + 1] = value
		if type(value) == "table" then tempTab[#tempTab]._key_ = key end
	end

	table.sort(tempTab, function(data1, data2)
		if type(data1) ~= "table" then data1 = {#tempTab + 1} end
		if type(data2) ~= "table" then data2 = {#tempTab + 1} end
		return (data1[1] < data2[1])
	end)

	local i = 0
	local iterator = function()
		i = i + 1
		if i > #tempTab or type(tempTab[i]) ~= "table" then return nil else
			local key = tempTab[i]._key_
			tempTab[i]._key_ = nil
			return key, tempTab[i]
		end
	end

	return iterator
end

-- @organize(hero_data, hero_name)
-- Serves as helper for the quickier heroes system
function reb.organize(hero, heroK)
	if type(hero.type) == "table" then
		for key, hero2type in ipairs(hero.type) do
			local hero2 = reb.copy(hero)
			hero2.type = hero2type				
			hero2.value = hero.value[key]
			reb.organize(hero2, heroK)
		end
	else
		if hero.type > 0 and hero.type < 4 then table.insert(reb.statuses, hero); reb.statuses[#reb.statuses].id = heroK
		elseif hero.type == 4 then table.insert(reb.equipments, hero); reb.equipments[#reb.equipments].id = heroK end
	end
end

for hook, _ in pairs(reb.hooks) do if hook ~= "update" and hook ~= "items" then addhook(hook,"reb.hooks."..hook) end end

reb.LOAD("utils.lua")
reb.LOAD("menus.lua")

for hook, _ in pairs(reb.functions) do reb.hook(hook, "reb.functions."..hook) end

reb.settings()

reb.statuses = {}
reb.equipments = {}
reb.dynData = {}

for classK, class in pairs(reb.heroes) do 
	if type(class) == "table" then
		for heroK, hero in pairs(class) do
			if type(hero) == "table" and heroK ~= "req" and heroK ~= "points" then
				if hero.type then reb.organize(hero, heroK) end
				if hero.data then
					table.insert(reb.dynData, hero)
					reb.dynData[#reb.dynData].id = heroK 
				end
			end
		end
	end
end