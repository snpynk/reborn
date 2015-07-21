--{{{ HEROES REBORN / CLIENT FUNCTIONS
--{{{ READ info.lua

cl = {}

-- #info(player_id)
-- Shows mod informations to specified player
function cl.info(id)
	msg2(id, reb.color.pos.."Super Heroes Reborn Mod v"..reb.ABOUT.version.." written by "..reb.ABOUT.author)
	msg2(id, "Codename: "..reb.ABOUT.codename)
	msg2(id, "Last updated on "..reb.ABOUT.date)
end

-- #get(player_id, hero_name)
-- Returns wether the specified player has the specified hero and also returns its level
function cl.get(id, hero)
	local pi = pi[id]
	return (pi.heroes[hero] ~= nil) and pi.heroes[hero]
end

-- #load(player_id)
-- Loads a the specified player data
function cl.load(id)
	pi[id] = pi.newUser()

	local USGN = player(id, "usgn")
	local pi = pi[id]
	local mainLine = false
	
	pi.load = true

	if USGN > 0 then
		local saveFile = io.open(reb.ABOUT.path.."/saves/"..USGN, "r")
		if saveFile then
			msg2(id, reb.color.pos.."Your savefile has been found...@C")

			local version
			local metaData = false
			local outDated = false

			for line in saveFile:lines() do
				if not metaData then
					metaData = true
					version, pack = line:match(":(.*),(.*)")
					if pack ~= reb.PACK.NAME or version ~= reb.PACK.VERSION then
						local content = saveFile:read("*all")
						mainLine = content:sub(content:find("e"), #content)
						mainLine = mainLine:sub(1, mainLine:find("\n"))
						outDated = true
						os.remove(reb.ABOUT.path.."/saves/"..USGN)
						msg2(id, reb.color.neg.."...and it is outdated, your heroes will be reseted (to avoid bugs) !@C")
						break
					end
				elseif not mainLine then mainLine = line else
					local param, value = line:match("(.*)=(.*)")
					pi.heroes[param] = tonumber(value)
				end
			end
			saveFile:close()
			if not outDated then msg2(id, reb.color.pos.."...and it has been successfully loaded!@C") end
		else
			msg2(id, reb.color.neg.."Your savefile haven't been found...@C")
			msg2(id, reb.color.pos.."...this is your first time!@C")
		end
	else
		msg2(id, reb.color.neg.."You are not logged to unrealsoftware.de...@C")
		msg2(id, reb.color.neu.."...we highly recommend you to make an account!@C")
	end

	local level, nexp, exp, ratio = 0, 0, tostring(mainLine):match("exp=(.*):") or nil, tostring(mainLine):match(":(%d*)") or nil
	
	if exp then
		if exp:find("X") then
			pi.brave = true
			exp = exp:sub(1, #exp - 1)
		elseif exp:find("Y") then
			pi.legend = true
			pi.brave = true
			exp = exp:sub(1, #exp - 1)
		end
		
		while tonumber(exp) >= nexp do
			level = level + 1
			nexp = nexp + ratio * level
		end
	end

	pi.level = 1
	if level ~= 0 then pi.level = level end

	pi.exp = tonumber(exp) or 0
	pi.nexp = nexp or reb.config.level_ratio
	pi.ratio = ratio or reb.config.level_ratio
	pi.points = reb.config.point_start + (reb.config.point_level * (pi.level - 1))
	if pi.level >= reb.config.level_max then
		pi.points = pi.points - (pi.level - reb.config.level_max)
		if pi.brave then msg(reb.color.pos.."A legend has just arrived!") end
	end
	
	cl.pontuate(id)
	cl.save(id)
end

-- #save(player_id)
-- Saves the specified player data
function cl.save(id)
	local USGN = player(id, "usgn")
	if USGN > 0 then
		local saveFile = io.open(reb.ABOUT.path.."/saves/"..USGN, "w")
		local pi = pi[id]
		
		saveFile:write(":"..reb.PACK.VERSION..","..reb.PACK.NAME)
		if pi.legend then saveFile:write("\nexp="..pi.exp.."Y:"..pi.ratio) 
		elseif pi.brave then saveFile:write("\nexp="..pi.exp.."X:"..pi.ratio) 
		else saveFile:write("\nexp="..pi.exp..":"..pi.ratio) end
		for name, value in pairs(pi.heroes) do saveFile:write("\n"..string.format(name.."=%d", value)) end
		saveFile:close()
	end
end

-- #setup(player_id)
-- Prepares the specified player upon spawn
function cl.setup(id)
	local pi = pi[id]
	local items = {50}

	local weapon = reb.config.spawn_items[math.random(#reb.config.spawn_items)]
	if player(id, "bot") and weapon == 10 then repeat weapon = reb.config.spawn_items[math.random(#reb.config.spawn_items)] until weapon ~= 10 end
	table.insert(items, tostring(weapon))
	
	local health = 100
	local armor = player(id, "armor")
	local speed = player(id, "speedmod")
	
	for _, hero in ipairs(reb.statuses) do
		local level = cl.get(id, hero.id)
		if level then
			local amount = hero.value
			if hero.multiply then amount = amount * level end
			if hero.type == 1 then health = health + amount
			elseif hero.type == 2 then armor = armor + amount
			elseif hero.type == 3 then speed = speed + amount end
		end
	end
	
	parse("setmaxhealth "..id.." "..health)
	parse("setarmor "..id.." "..armor)
	parse("speedmod "..id.." "..speed)
	
	for _, hero in ipairs(reb.equipments) do if cl.get(id, hero.id) then table.insert(items, tostring(hero.value)) end end

	for _, hero in ipairs(reb.dynData) do
		if hero.data.auto then
			if hero.data.priv then if cl.get(id, hero.id) then pi[hero.id] = reb.copy(hero.data[1]) else pi[hero.id] = nil end
			else pi[hero.id] = reb.copy(hero.data[1]) end
		elseif hero.data.priv and cl.get(id, hero.id) and pi[hero.id] == nil then pi[hero.id] = reb.copy(hero.data[1])
		elseif not hero.data.priv and pi[hero.id] == nil then pi[hero.id] = reb.copy(hero.data[1]) end
	end

	pi.speed = speed
	return items
end

-- #pontuate(player_id)
-- Calculates the heroes points on the specified player
function cl.pontuate(id)
	local pi = pi[id]
	if pi.level <= reb.config.level_max then pi.points = (pi.level * reb.config.point_level) - 1 + reb.config.point_start
	else pi.points = (reb.config.level_max * reb.config.point_level) - 1 + reb.config.point_start end
	
	for _, class in pairs(reb.heroes) do
		for heroK, hero in pairs(class) do
			local level = cl.get(id, heroK)
			if level then pi.points = pi.points - (class.points * level) end
		end
	end
	cl.draw(id)
	cl.save(id)
end

-- #draw(player_id)
-- Refreshes the specified player hud
function cl.draw(id)
	local pi = pi[id]
	--	sh_txt2(id,7,2,'Super Hero Mod Gold (v 1.2)',322,13,1)
	if player(id, "usgn") > 0 then parse("hudtxt2 "..id.." 1 \""..reb.color.pos.."Login as: "..player(id, "usgn").."\" 5 415")
	else parse("hudtxt2 "..id.." 0 \""..reb.color.neg.."Failed to loggin!\" 5 415") end
	parse("hudtxt2 "..id.." 2 \"Level: "..pi.level.."/"..reb.config.level_max.."\" 5 430")
	if pi.legend then parse("hudtxt2 "..id.." 2 \""..reb.color.neg.."Level: "..pi.level.."/"..reb.config.level_max.."\" 5 430") end
		
	parse("hudtxt2 "..id.." 3 \"Points: "..pi.points.."\" 115 430")

	parse("hudtxt2 "..id.." 4 \"Exp: ("..pi.exp.."/"..pi.nexp..")\" 215 430")
	parse("hudtxt2 "..id.." 5 \""..reb.color.lilac.."Credits: ("..pi.credits.."/"..reb.config.credits_max..")\" 215 415")
end

-- #giveExp(player_id, experience_points)
-- Gives experience points to the specified player
function cl.giveExp(id, exp)
	local exp = exp or 0
	local levelUp = false

	local pi = pi[id]
	pi.exp = pi.exp + exp
	while pi.exp >= pi.nexp do
		levelUp = true
		pi.level = pi.level + 1
		pi.nexp = pi.nexp + reb.config.level_ratio * pi.level
		cl.pontuate(id)
		for className, class in pairs(reb.heroes) do
			if pi.level == class.req then
				msg2(id, reb.color.pos..className.." class has been unlocked!@C")
				parse("sv_sound2 "..id.." "..reb.config.sound_unlock)
			end
		end
	end

	if levelUp then
		if pi.brave and not pi.legend and pi.level >= reb.config.level_max then
			msg2(id, reb.color.pos.."You just became a LEGEND!@C")
			msg2(id, reb.color.pos.."Thanks for playing this gamemode and for putting this much effort on it!@C")
			pi.legend = true
		end
		msg2(id, reb.color.pos.."Level UP!@C")
		msg(reb.color.purple..player(id,"name").." reached level "..pi.level.."!")
		parse("sv_sound2 "..id.." "..reb.config.sound_level)
		parse("sethealth "..id.." "..player(id, "maxhealth"))
	end

	cl.draw(id)
	cl.save(id)
end

-- #giveCred(player_id, credits)
-- Gives credits to the specified player
function cl.giveCred(id, credits)
	local pi = pi[id]
	if pi.credits + reb.config.credits_kill <= reb.config.credits_max then
		pi.credits = pi.credits + reb.config.credits_kill
	else pi.credits = reb.config.credits_max end
end

-- #killReward(player_id, victim_id, weapon_id)
-- killRewards the specified player for a kill
function cl.killReward(id, victim, weapon)
	if (player(id,"team") ~= player(victim,"team") or tonumber(game("sv_gamemode")) == 1) and id ~= victim and player(id, "exists") then
		local vi = pi[victim]
		local pi = pi[id]

		if player(victim,"bot") then cl.giveExp(id, reb.config.exp_ratio) else cl.giveExp(id, 2 * reb.config.exp_ratio) end
		cl.giveCred(id, reb.config.credits_kill)

		if weapon == 50 or weapon == 75 then
			msg(reb.color.purple..player(id,"name").." humiliated "..player(victim,"name").."!@C")
			msg2(id, reb.color.pos.."You got extra "..(2 * reb.config.exp_ratio).." exp for that!@C")
			parse("sv_sound "..reb.config.sound_humiliation)
			cl.giveExp(id, 2 * reb.config.exp_ratio)
		end

		if pi.level < vi.level then
			local dif = vi.level - pi.level
			if dif > 50 then dif = 50 end
			cl.giveExp(id, reb.config.exp_ratio * dif)
			msg2(id, reb.color.lilac.."You killed a stronger player!@C")
			msg2(id, reb.color.pos.."You got extra "..reb.config.exp_ratio * dif.." exp for that!@C")
		end
	end
end

-- #getHero(player_id, hero_name[|hero_button_number, hero_name])
-- Purchases an hero as the specified player
function cl.getHero(id, hero, hero2)
	if hero2 then hero = reb.copy(hero2) end

	local pi = pi[id]
	local cost, max, class

	hero = hero:sub(1, hero:find(" %(") - 1)
	for heroK, heroData in reb.order(reb.heroes) do if heroData[hero] then cost = heroData.points; max = heroData[hero].max or 1; class = heroK break end end

	if pi.points >= cost then
		if cl.get(id, hero) then if cl.get(id, hero) < max then pi.heroes[hero] = pi.heroes[hero] + 1 end
		else pi.heroes[hero] = 1 end
		
		for _, hero in ipairs(reb.dynData) do
			if cl.get(id, hero.id) and hero.data.priv and not pi[hero.id] then pi[hero.id] = reb.copy(hero.data[1]) end
		end
		
		cl.pontuate(id)
		cl.save(id)
		cl.popHeroes(id, class)
	else msg2(id, reb.color.neg.."You don't have enough points (Required: "..cost..")! @C") end
end

-- #delHero(player_id, hero_name[|hero_button_number, hero_name, page, show_message])
-- Removes an hero as the specified players
function cl.delHero(id, hero, hero2, page, interactive)
	if type(hero) == "number" then hero = reb.copy(hero2)
	else if type(hero2) ~= "number" then interactive = hero2; page = 1 else interactive = page; page = hero2 end end
	
	if hero:find("%(") then hero = hero:sub(1, hero:find(" %(") - 1) end
	
	local pi = pi[id]
	pi.heroes[hero] = pi.heroes[hero] - 1
	if pi.heroes[hero] <= 0 then pi.heroes[hero] = nil end
	cl.pontuate(id)
	
	cl.save(id)
	cl.draw(id)
	
	if not interactive then
		msg2(id, reb.color.pos.."You have successfully removed/downgraded "..hero.." hero from your stats! Your points have been returned!")
		cl.popMyHeroes(id, page)
	end
end

-- #delHeroes(player_id)
-- Removes all the specified player heroes
function cl.delHeroes(id)
	local pi = pi[id]
	for hero, level in pairs(pi.heroes) do for times = 1, level do cl.delHero(id, hero, true) end end
	msg2(id, reb.color.pos.."All your heroes have been successfully removed! Your points have been returned!")
end

-- #equip(player_id, item_name)
-- Gives an item to the specified player
function cl.equip(id, item)
	table.insert(pi[id].inventory, item)
end

-- #holds(player_id, item_name)
-- Returns whether the specified player holds the specified item on its inventory
function cl.holds(id, item)
	for _, itemK in ipairs(pi[id].inventory) do if itemK == item then return true end end
	return false
end

-- #buy(player_id, item_name[|item_button_number, item_name])
-- Buys an item as the specified player
function cl.buy(id, item, item2)
	if item2 then item = reb.copy(item2) end
	local pi = pi[id]
	local cost

	for catK, cat in reb.order(reb.shop) do if cat[item] then cost = cat[item].cost break end end

	if pi.credits >= cost then
		if not cl.holds(id, item) then
			msg2(id, reb.color.pos.."You purchased "..item.."!@C")
			msg2(id, reb.color.lilac.."Check your inventory to use it!@C")
			pi.credits = pi.credits - cost
			cl.equip(id, item)
		else msg2(id, reb.color.neg.."You already have this item!") end
	else msg2(id, reb.color.neg.."You don't have enough credits! @C") end
	cl.draw(id)
end

-- #use(player_id, item_button_number, item_name)
-- Uses an item as the specified player
function cl.use(id, itemP, item)
	local pi = pi[id]
	local func
	
	if player(id, "health") > 0 then
		for catK, cat in reb.order(reb.shop) do if cat[item] then cat[item].func(id) break end end
		table.remove(pi.inventory, itemP)
		cl.draw(id)
	else msg2(id, reb.color.neg.."You can only use items while you're dead!") end
end

-- #sell(player_id, item_button_number, item_name)
-- Sell an item as the specified player
function cl.sell(id, itemP, item)
	local pi = pi[id]
	local cost

	for catK, cat in reb.order(reb.shop) do
		if cat[item] then
			if catK == "Special" then msg2(id, reb.color.neg.."You can't sell this item!") return else
			cost = cat[item].cost break end
		end
	end

	pi.credits = pi.credits + cost
	table.remove(pi.inventory, itemP)
	cl.draw(id)
end

-- #reset(player_id)
-- Resets players stats completely
function cl.reset(id, _, button)
	if not button then
		men.frame(id, "Are you sure to reset your stats ?", {"Yes","No"}, "cl.reset")
		return
	end
	
	if button == "Yes" then
		if pi[id].level < reb.config.level_max then msg2(id, reb.color.neg.."You can't reset your stats unless you are level "..reb.config.level_max.." or higher!") return end
		local legend = pi[id].legend
		
		pi[id] = pi.newUser()
		local pi = pi[id]
		pi.brave = true
		pi.legend = legend
		
		cl.save(id)
		cl.load(id)
		
		for _, hero in ipairs(reb.dynData) do
			if hero.data.auto then
				if hero.data.priv then if cl.get(id, hero.id) then pi[hero.id] = reb.copy(hero.data[1]) else pi[hero.id] = nil end
				else pi[hero.id] = reb.copy(hero.data[1]) end
			elseif hero.data.priv and cl.get(id, hero.id) and pi[hero.id] == nil then pi[hero.id] = reb.copy(hero.data[1])
			elseif not hero.data.priv and pi[hero.id] == nil then pi[hero.id] = reb.copy(hero.data[1]) end
		end
		
		msg2(id, reb.color.pos.."Your level and stats have been successfully resetted!")
		msg2(id, reb.color.pos.."Thanks for being such brave player! From now on, you will be enjoying the brave player benefits!")
	end
end

-- #popMenu
-- Pops up the mod menu to the specified player
function cl.popMenu(id)
	men.frame(id, "Reborn Menu", {"Chat Commands", "Heroes Menu", "My Heroes Menu", "Items Menu", "Information"}, "men.main")
end

-- #popCmds(player_id)
-- Pops up the chat commands menu to the specified player
function cl.popCmds(id)
	local cmds = {}
	for _, cmd in ipairs(reb.ABOUT.commands) do table.insert(cmds, "!"..cmd[1].."|"..cmd.desc) end
	men.frame(id, "Chat Commands", cmds, "men.commands")
end

-- #popHeroes(player_id, class_name[|class_button_number, class_name])
-- Pops up heroes menu to the specified player
function cl.popHeroes(id, classK, classK2)
	local pi = pi[id]
	if classK2 then classK = reb.copy(classK2) end
	
	if not classK then
		local classes = {}
		for classK, classData in reb.order(reb.heroes) do
			if pi.level >= classData.req then table.insert(classes, classK.."|Level "..classData.req)
			else table.insert(classes, "(Locked Class|Level "..classData.req..")") end
		end
		
		men.frame(id, "Heroes > Classes (Level: "..pi.level..")", classes, "cl.popHeroes")
		return
	end
	
	if not reb.heroes[classK] then msg2(id, reb.color.neg.."That class doesn't exist!") return
	elseif pi.level < reb.heroes[classK].req then msg2(id, reb.color.neg.."You need to unlock this class to access it!") return end
	
	local class = reb.heroes[classK]
	local heroes = {}

	for heroK, hero in reb.order(class) do
		if type(hero) == "table" then
			local level = cl.get(id, heroK) or 0
			local max = hero.max or 1

			table.insert(heroes, heroK.." ("..level.."/"..max..")|"..hero.desc)
		end
	end

	men.frame(id, classK.." (Points: "..pi.points..")", heroes, "cl.getHero")
end

-- #popMyHeroes(player_id[, page])
-- Pops up heroes build menu to the specified player
function cl.popMyHeroes(id, page)
	local page = page or 1
	local pi = pi[id]
	local heroes = {}
	for hero, heroData in pairs(pi.heroes) do
		local level = cl.get(id, hero) or 0
		local max
		for _, heroData2 in pairs(reb.heroes) do if type(heroData2) == "table" and heroData2[hero] then
			max = heroData2[hero].max or 1
		end end
		
		table.insert(heroes, hero.." ("..level.."/"..max..")|Remove")
	end
	men.frame(id, "My Heroes", heroes, "cl.delHero", page)
end

-- #popItems(player_id)
-- Pops up items menu to the specified player
function cl.popItems(id)
	men.frame(id, "Items Menu", {"Inventory|Use Items", "Shop|Buy Items", "Market|Sell Items"}, "men.items")
end

-- #popShop(player_id, category[|category_button_number, category])
-- Pops up Shop menu to the specified player
function cl.popShop(id, category, category2)
	if category2 then category = reb.copy(category2) end
	
	local pi = pi[id]
	if not category then
		local categories = {}
		for cat, _ in reb.order(reb.shop) do if cat ~= "Special" then table.insert(categories, cat) end end
		
		men.frame(id, "Shop | Buy Items (Credits: "..pi.credits..")", categories, "cl.popShop")
		return
	end
	
	if not reb.shop[category] then msg2(id, reb.color.neg.."That shop doesn't exist!") return end
	
	local itemT = reb.shop[category]
	local items = {}

	for itemK, item in reb.order(itemT) do table.insert(items, itemK.."|"..item.cost.." C") end
	men.frame(id, "Shop > "..category, items, "cl.buy")
end

-- #popInv(player_id)
-- Pops up the inventory to the specified player
function cl.popInv(id)
	local pi = pi[id]
	men.frame(id, "Inventory | Use Items", pi.inventory, "cl.use")
end

-- #popMark(player_id)
-- Pops up the market to the specified player
function cl.popMark(id)
	local pi = pi[id]
	men.frame(id, "Market | Sell Items", pi.inventory, "cl.sell")
end

-- #getStats(player_id, target_id)
-- Pops up the stats information menu of the specified target to the specified player
function cl.getStats(id, target)
	if not target then msg2(id, reb.color.neg.."You must specify a target!") return
	elseif not player(target, "exists") then msg2(id, reb.color.neg.."This player doesn't exist!") return end
	
	local ti = pi[target]
	local pi = pi[id]
	
	local heroes = {}
	table.insert(heroes, "(Level: "..ti.level..")")
	table.insert(heroes, "(Exp: "..ti.exp.."/"..ti.nexp..")")
	table.insert(heroes, "(Credits: "..ti.credits..")")
	
	for hero, heroData in pairs(ti.heroes) do
		local level = cl.get(target, hero) or 0
		local max, desc
		for _, heroData2 in pairs(reb.heroes) do if type(heroData2) == "table" and heroData2[hero] then
			desc = heroData2[hero].desc
			max = heroData2[hero].max or 1
		end end
		
		table.insert(heroes, hero.." ("..level.."/"..max..")|"..desc)
	end
	men.frame(id, player(target, "name").." Stats", heroes, "men.null")	
end