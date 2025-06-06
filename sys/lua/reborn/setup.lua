--[[ 
	ZEN SUPER HERO PACK
	THIS PACK IS BASED ON BLAZINGNOTE'S SUPER HERO SETUP WITH SOME CHANGES AND ADDITIONS
	HUDS 7 UP TO 40 ARE OCCUPIED
	WRITTEN BY _YANK
--]]

reb.PACK = {
	NAME = "Zen Pack";
	AUTHOR = "_Yank";
	VERSION = "4.1beta";
}

reb.config = {
	point_start = 8;
	point_level = 1;
	
	level_ratio = 800;
	level_max = 105;

	credits_kill = 15;
	credits_kill_turret = 10;
	credits_kill_bot_diff = -5;
	credits_max = 500;
	credits_start = 0;

	exp_ratio = 500;
	exp_max_bonusFactor = 15;

	spawn_items = {30, 32, 33, 20, 34, 39, 10};

	sound_level = "superhero/sh_levelup.wav";
	sound_unlock = "superhero/sh_unlock.ogg";
	sound_humiliation = "fun/humiliation.wav";

	sound_win = "superhero/sh_rnd_win.ogg";
	sound_loose = "superhero/sh_rnd_lose.ogg";

	hud_ids = {2, 3, 4, 5, 6};

	ip_saves = true;
}

reb.heroes = {
	["Usual Heroes"] = {
		1;
		req = 0;
		points = 1;
		["Sportsman"] = {
			1;
			max = 4;
			type = 1;
			value = 5;
			multiply = true;
			desc = "Health";
			long_desc = "Increases your maximum HP by 5 (times level)";
		};
		["Policeman"] = {
			2;
			max = 4;
			type = 2;
			value = 5;
			multiply = true;
			desc = "Armor";
			long_desc = "Increases your maximum AP by 5 (times level)";
		};
		["Thief"] = {
			3;
			max = 3;
			type = 3;
			value = 1;
			multiply = true;
			desc = "Speed";
			long_desc = "Increases your speed by 1 (times level)";
		};
		["Snowman"] = {
			4;
			type = 4;
			value = 75;
			desc = "Snowballs";
			long_desc = "Gives you snowballs";
		};
		["Nightcrawler"] = {
			5;
			type = 4;
			value = 88;
			avoid_bots = true;
			desc = "Telekinesis";
			long_desc = "Gives you a portal gun";
		};
		["Secret Agent"] = {
			6;
			type = 4;
			value = 3;
			desc = "Deagle";
			long_desc = "Gives you a desert eagle";
		};
		["Bomberman"] = {
			7;
			type = 4;
			value = 51;
			max = 5;
			data = {0, priv = true, auto = true};
			desc = "Supply Grenades";
			long_desc = "Gives you a HE grenade. Respawns after some time depending on the level";
		};
	};
	["Classical Heroes"] = {
		2;
		req = 5;
		points = 2;
		["Superman"] = {
			1;
			max = 4;
			type = {1, 2};
			value = {5, 5};
			multiply = true;
			desc = "Health/Armor";
			long_desc = "Increases your maximum HP and AP by 5 (times level)";
		};
		["Punisher"] = {
			2;
			desc = "Insta Reload";
			long_desc = "Weapons reload instantly";
		};
		["The Torch"] = {
			3;
			type = 4;
			value = 73;
			desc = "Molotov";
			long_desc = "Gives you a molotov cocktail";
		};
		["The Flash"] = {
			4;
			max = 2;
			type = 3;
			value = 1;
			multiply = true;
			desc = "Speed";
			long_desc = "Increases your speed by 1 (times level)";
		};
		["Saiyan"] = {
			5;
			avoid_bots = true;
			desc = "Opponent health";
			long_desc = "Whenever you hit an enemy it shows his left HP";
		};
		["Werewolf"] = {
			6;
			type = 4;
			value = 59;
			desc = "Nightvision";
			long_desc = "Gives you nightvisions";
		};
		["Ninja"] = {
			7;
			type = 4;
			value = 53;
			avoid_bots = true;
			desc = "Smoke";
			long_desc = "Gives you a smoke grenade";
		};
	};
	["Reliable Heroes"] = {
		3;
		req = 10;
		points = 3;
		["Cyclops"] = {
			1;
			type = 4;
			value = 87;
			desc = "Laser Mines";
			long_desc = "Gives you laser mines";
		};
		["Engineer"] = {
			2;
			type = 4;
			value = 74;
			max = 3;
			data = {{0, false, 0}, priv = true, secure = true};
			desc = "Turrets";
			long_desc = "Gives you a wrench (You can only build turrets (3 max.))";
		};
		["Juggernaut"] = {
			3;
			max = 2;
			type = 1;
			value = 20;
			multiply =  true;
			desc = "Health";
			long_desc = "Increases your maximum HP by 20 (times level)";
		};
		["Jason"] = {
			4;
			type = {4,4};
			value = {85, 60};
			desc = "Chainsaw/Mask";
			long_desc = "Gives you a chainsaw and a gas mask";
		};
		["Rambo"] = {
			5;
			type = 4;
			value = 90;
			desc = "M134";
			long_desc = "Gives you an M134";
		};
	};
	["Super Heroes"] = {
		4;
		req = 15;
		points = 4;
		["Dracula"] = {
			1;
			max = 3;
			desc = "HP per kill";
			long_desc = "Each kill you will receive 15 HP (times level)";
		};
		["Minesweeper"] = {
			2;
			type = 4;
			value = 77;
			avoid_bots = true;
			desc = "Mines";
			long_desc = "Gives you a mine set";
		};
		["Cobra"] = {
			3;
			data = {{0,0}, auto = true};
			max = 3;
			desc = "Poison";
			long_desc = "Opponent looses 12HP after 4 seconds. The effect may repeat depending on the level";
		};
		["Wolverine"] = {
			4;
			max = 5;
			type = 4;
			value = 78;
			desc = "Heal/Claws";
			long_desc = "Gives you claws and every 4 seconds, gives you 10 HP (times level)";
		};
		["Hulk"] = {
			5;
			desc = "Smash";
			long_desc = "Every time you destroy an enemy building you will receive 10 credits";
		};
	};
	["Glorious Heroes"] = {
		5;
		req = 20;
		points = 5;
		["Kamikadze"] = {
			1;
			max = 3;
			desc = "Explosion";
			long_desc = "When you die, you leave an explosion (power depending on level)";
		};
		["Batman"] = {
			2;
			max = 2;
			type = {2,3};
			value = {30, 1};
			multiply = true;
			desc = "Armor/Speed";
			long_desc = "Increases your maximum AP by 30 and gives you speed (times level)";
		};
		["Shenlong"] = {
			3;
			data = {false, auto = true, priv = true, secure = true};
			desc = "Critical Reborn";
			long_desc = "When you're about to die, you get a second chance with 50HP (only happens 1 time each spawn)";
		};
		["Demoman"] = {
			4;
			type = 4;
			value = 49;
			desc = "Gren. Launcher";
			long_desc = "Gives you a grenade launcher";
		};
		["Krillin"] = {
			6;
			type = 4;
			value = 52;
			avoid_bots = true;
			desc = "Flashbang";
			long_desc = "Gives you a flash grenade";
		};
	};
	["Ultra Heroes"] = {
		6;
		req = 25;
		points = 6;
		["The Hammer"] = {
			1;
			max = 3;
			type = 0;	
			desc = "Damage";
			long_desc = "Inflicts up to 30% extra damage to enemies";
		};
		["Iron Man"] = {
			2;
			type = 4;
			value = 48;
			desc = "Rockets";
			long_desc = "Gives you a rocket launcher";
		};
		["Robin"] = {
			3;
			max = 2;
			type = 3;
			multiply = true;
			value = 2;
			desc = "Speed";
			long_desc = "Increases your speed by 2 (times level)";
		};
		["Cpt. Kenpachi"] = {
			4;
			type = 4;
			value = 69;
			desc = "Machete";
			long_desc = "Gives you a machete";
		};
		["Rocket Racoon"] = {
			5;
			type = 4;
			value = 91;
			desc = "FN 2000";
			long_desc = "Gives you an FN 2000";
		};
		["Piccolo"] = {
			6;
			type = 4;
			value = 89;
			desc = "Satchel Charge";
			long_desc = "Gives you Satchel Charges";
		};
	};
	["Modern Heroes"] = {
		7;
		req = 30;
		points = 7;
		["Spiderman"] = {
			1;
			data = {false, auto = true};
			desc = "Stun";
			long_desc = "Slows down the opponent for some time";
		};
		["Pyro"] = {
			2;
			type = 4;
			value = 46;
			desc = "Flamethrower";
			long_desc = "Gives you a flamethrower";
		};
		["King Kong"] = {
			3;
			type = 1;
			value = 35;
			multiply = true;
			desc = "Health";
			long_desc = "Increases your maximum health by 35 (times level)";
		};
		["Major"] = {
			4;
			type = 4;
			value = 76;
			desc = "Airstrike";
			long_desc = "Gives you an airstrike flare";
		};
		["Nami"] = {
			5;
			max = 3;
			avoid_bots = true;
			desc = "Item Steal";
			long_desc = "When you kill someone and he has items, you got a chance of stealing them";
		};
	};
	["Legends"] = {
		8;
		req = 35;
		points = 15;
		["Bin Laden"] = {
			1;
			type = 4;
			value = 47;
			desc = "RPG Launcher";
			long_desc = "Gives you a RPG Launcher";
		};
		["Shadow Cat"] = {
			2;
			desc = "Invisibility";
			long_desc = "Gives you a Stealth Suit";
		};
		["Cpt. America"] = {
			3;
			type = 4;
			value = 41;
			avoid_bots = true;
			desc = "Shield";
			long_desc = "Gives you a Tactical Shield";
		};
		["Thor"] = {
			4;
			desc = "Shock";
			long_desc = "Shakes the opponent vision";
		};
	};
	["Special"] = {
		9;
		req = 40;
		points = 20;
		["Venom"] = {
			1;
			desc = "Anti-Stun";
			long_desc = "Nullifies Spiderman's stun effect";
		};
		["Diablo"] = {
			2;
			avoid_bots = true;
			desc = "Evil Wrath";
			long_desc = "Gives the player a special explosion item";
		};
		["Saitama"] = {
			3;
			desc = "Super Melee";
			long_desc = "Increases your melee damage by 200%";
		};
	};
};

reb.functions = {
	spawn = function(id)
		-- Engineer
		if cl.get(id, "Engineer") then msg2(id, reb.color.pos.."You have Engineer powers, you can build "..(3 - pi[id]["Engineer"][1]).." Turret(s)!") end

		-- Diablo
		if cl.get(id, "Diablo") then
			msg2(id, reb.color.pos.."You have Diablo power, check your inventory to use it!")
			for _, item in ipairs(pi[id].inventory) do if item == "Evil Wrath" then return end end
			table.insert(pi[id].inventory, "Evil Wrath")
		end

		-- Shadow Cat
		if cl.get(id, "Shadow Cat") then
			parse("setarmor "..id.." 206")
		end
	end;

	update = function()
		for _, id in ipairs(player(0, "tableliving")) do
			-- Bomberman
			if cl.get(id, "Bomberman") then
				local data = pi[id]["Bomberman"]
				local Bomberman = cl.get(id, "Bomberman")

				data = data + 4
				if data >= 24 - (Bomberman * 4) then parse("equip "..id.." 51"); data = 0 end

				pi[id]["Bomberman"] = data
			end

			-- Wolverine
			if cl.get(id, "Wolverine") then
				local level = cl.get(id, "Wolverine")
				parse("sethealth "..id.." "..player(id, "health") + (10 * level)) 
			end

			-- Spiderman
			local data = pi[id]["Spiderman"]
			if data then
				parse("speedmod "..id.." "..data)
				pi[id]["Spiderman"] = false
			end

			-- Cobra
			local data2 = pi[id]["Cobra"]
			local health = player(id,"health") - 10
			if data2[1] > 0 and data2[2] > 0 and player(data2[1],"exists") then
				data2[2] = data2[2] - 1
				if health > 0 then parse("sethealth "..id.." "..health) else parse("customkill "..data2[1].." Poison "..id) end
				if data2[2] <= 0 then data2[1] = 0 end
				pi[id]["Cobra"] = data2
			end
		end
	end;

	reload = function(id, mode)
		-- Punisher
		if mode == 1 and cl.get(id, "Punisher") then parse("equip "..id.." "..player(id, "weapontype")) end
	end;

	attack = function(id)
		-- Punisher
		if cl.get(id, "Punisher") then
			local wep = player(id, "weapontype")
			if wep == 47 then parse("equip "..id.." 47") end
		end
	end;

	hit = function(id, source, weapon, hpDmg, apDmg)
		local toReturn = false
		local newHpDmg = false
		local newApDmg = false
		local isAttack = weapon <= 100
		local isFireArm = (weapon <= 51 or weapon == 90 or weapon == 91)
		
		-- Saitama
		if isAttack and cl.get(source, "Saitama") and itemtype(weapon, "slot") == 3 then
			toReturn = true
			newHpDmg = hpDmg + math.floor(hpDmg * 2)
			newApDmg = apDmg + math.floor(apDmg * 2)
		end

		if isFireArm then
			-- The Hammer
			if cl.get(source, "The Hammer") and isFireArm then
				local level = cl.get(source, "The Hammer")
				toReturn = true
				newHpDmg = hpDmg + math.floor((hpDmg / 9) * level)
				newApDmg = apDmg + math.floor((apDmg / 6) * level)
			end
		
			-- Thor
			if cl.get(source, "Thor") then
				if weapon ~= 47 then
					local power = math.floor((0.5 * (newHpDmg or hpDmg)) + 0.5)
					parse("shake "..id.." "..power)
				end
			end

			-- Spiderman
			if cl.get(source, "Spiderman") and not cl.get(id, "Venom") then
				local data = pi[id]["Spiderman"]
				if not data and (game("sv_gamemode") == 1 or player(source,"team") ~= player(id,"team")) then
					msg2(id, reb.color.neg.."You got stunned by "..player(source, "name").."!@C")
					pi[id]["Spiderman"] = player(id,"speedmod")
					parse("speedmod "..id.." -9")
				end
			end

			-- Cobra
			if cl.get(source, "Cobra") then
				local level = cl.get(source, "Cobra")
				local data = pi[id]["Cobra"]
				if player(id,"health") - (newHpDmg or hpDmg) > 0 and data[1] == 0 and data[2] < 1 and (game("sv_gamemode") == 1 or player(source,"team") ~= player(id,"team")) then
					msg2(id, reb.color.neg.."You got poisoned by "..player(source, "name").."!@C")
					pi[id]["Cobra"] = {source, level}
				end
			end
		end

		-- Saiyan
		if cl.get(source, "Saiyan") and (game("sv_gamemode") == 1 or player(source,"team") ~= player(id,"team")) then
			local hud = 6 + id
			local x = 320 + (player(id, "x") - player(source, "x"))
			local y = 240 + (player(id, "y") - player(source, "y"))
			
			parse("hudtxtalphafade "..source.." "..hud.." 1 1")
			parse("hudtxt2 "..source.." "..hud.." \""..reb.color.purple.."(HP:"..player(id,"health") - (newHpDmg or hpDmg)..")\" "..x.." "..y)
			parse("hudtxtmove "..source.." "..hud.." 400 "..x.." "..(y - 40))
			timer(300, "parse", "hudtxtalphafade "..source.." "..hud.." 400 0")
		end

		-- Shenlong
		if cl.get(id, "Shenlong") then
			if not pi[id]["Shenlong"] and player(id,"health") - (newHpDmg or hpDmg) <= 0 then
				msg2(id,reb.color.lilac.."Reborn!@C")
				parse("sethealth "..id.." 50")
				pi[id]["Shenlong"] = true
				return 1
			end
		end
		
		if toReturn then
			if newHpDmg then
				local newHp = player(id, "health") - newHpDmg
				local newAp = (player(id, "armor") - newApDmg < 0 and 0) or player(id, "armor") - newApDmg
				if newHp > 0 then
					parse("sethealth "..id.." "..newHp)
					
					if player(id, "armor") <= 200 then parse("setarmor "..id.." "..newAp) 	end
					
					return 1
				else
					parse("customkill "..source.." \""..itemtype(player(source,"weapontype"), "name").."\" "..id)
					return
				end
			end
			
			return 1
		end
	end;

	buildattempt = function(id, type)
		-- Engineer
		if cl.get(id, "Engineer") and type == 8 then
			local data = pi[id]["Engineer"]
			if data[1] >= 3 then
				msg2(id, "You can't build more turrets!")
				return 1
			else data[2] = true; pi[id]["Engineer"] = data end
		end
	end;

	build = function(id, type, x, y, mode, oid)
		-- Engineer
		if cl.get(id, "Engineer") then
			local data = pi[id]["Engineer"]
			if data[2] then
				data[1] = data[1] + 1
				data[2] = false
				data[3] = oid
				pi[id]["Engineer"] = data
			end
		end
	end;

	objectkill = function(oid, id)
		if player(id, "exists") then
			-- Engineer
			if cl.get(id, "Engineer") then
				local data = pi[id]["Engineer"]
				if oid == data[3] then
					data[1] = data[1] - 1
					pi[id]["Engineer"] = data
				end
			end

			-- Hulk
			if cl.get(id, "Hulk") then
				if object(oid, "team") ~= player(id, "team") or (tonumber(game("sv_gamemode")) == 1 and object(oid, "player") ~= id) then
					msg2(id, reb.color.pos.."Hulk Smash! + 10 Credits")
					cl.giveCred(id, 10)
					cl.draw(id)
				end
			end
		end
	end;

	die = function(id, killer, weapon, x, y)
		if not player(killer, "exists") or not pi[killer] then return end 
	
		-- Dracula
		if cl.get(killer, "Dracula") then
			local level = cl.get(killer, "Dracula")
			msg2(killer, reb.color.pos.."Vampiric Drain! + "..(15 * level).." HP")
			parse("sethealth "..killer.." "..player(killer, "health") + (15 * level))
		end

		-- Kamikadze
		if cl.get(id, "Kamikadze") then
			local level = cl.get(id, "Kamikadze")
			local power = (level * 75)
			parse("explosion "..x.." "..y.." "..power.." "..power.." "..id)
		end

		-- Nami
		if cl.get(killer, "Nami") then
			local level = cl.get(killer, "Nami")
			local vi = pi[id]
			local pi = pi[killer]
			for pos, item in ipairs(vi.inventory) do
				if item ~= "Evil Wrath" then
					local rate = math.random(1, 5 - level) == 2
					if rate then
						table.insert(pi.inventory, item)
						table.remove(pi.inventory, pos)
						msg2(killer, reb.color.pos.."You stole "..item.." from "..player(id, "name").."!@C")
						msg2(id, reb.color.neg..player(killer,"name").." has stolen your "..item.."!@C")
					end
				end
			end
		end
	end;

}

reb.shop = {
	["Buildings"] = {
		1;
		["Mines I"] = {4, cost = 55, func = function(id) utils.quad(id, 3, 0, 20) end};
		["Mines II"] = {5, cost = 65, func = function(id) utils.quad(id, 3, 20) end};
		["Mines III"] = {6, cost = 75, func = function(id) utils.quad(id, 5, 20) end};

		["Base I"] = {1, cost = 150, func = function(id) utils.quad(id, 3, 8, 6) end};
		["Base II"] = {2, cost = 285, func = function(id) utils.quad(id, 5, 8, 6) end};
		["Base III"] = {3, cost = 400, func = function(id) utils.quad(id, 7, 8, 6) end};
		
		["Medical Tent I"] = {7, cost = 100, func = function(id) utils.quad(id, 3, 7, 6) end};
		["Medical Tent II"] = {8, cost = 200, func = function(id) utils.quad(id, 5, 7, 6) end};
		["Medical Tent III"] = {9, cost = 300, func = function(id) utils.quad(id, 7, 7, 6) end};
		
		["Walls I"] = {10, cost = 75, func = function(id) utils.quad(id, 3, 6, 3, 2, 1) end};
		["Walls II"] = {11, cost = 100, func = function(id) utils.quad(id, 5, 6, 3, 3, 2) end};
		["Walls III"] = {12, cost = 125, func = function(id) utils.quad(id, 7, 6, 3, 4, 3) end};
	};

	["Potions"] = {
		2;
		["25HP Potion"] = {1, cost = 10, func = function(id) parse("sethealth "..id.." "..player(id, "health") + 10) end};
		["50HP Potion"] = {2, cost = 15, func = function(id) parse("sethealth "..id.." "..player(id, "health") + 50) end};
		["75HP Potion"] = {3, cost = 20, func = function(id) parse("sethealth "..id.." "..player(id, "health") + 75) end};
		["100HP Potion"] = {4, cost = 25, func = function(id) parse("sethealth "..id.." "..player(id, "health") + 100) end};
	};

	["Nukes"] = {
		3;
		["Super-Bomb I"] = {1, cost = 50, func = function(id) parse("explosion "..player(id, "x").." "..player(id, "y").." 200 200 "..id) end};
		["Super-Bomb II"] = {2, cost = 100, func = function(id) parse("explosion "..player(id, "x").." "..player(id, "y").." 300 300 "..id) end};
		["Super-Bomb III"] = {3, cost = 150, func = function(id) parse("explosion "..player(id, "x").." "..player(id, "y").." 500 500 "..id) end};
		["Atomic-Bomb X"] = {3, cost = 500, func = function(id) parse("explosion "..player(id, "x").." "..player(id, "y").." 7000 1500 "..id) end};
	};

	["Special"] = {
		4;
		["Evil Wrath"] = {1, func = function(id)
				local x, y = player(id, "x"), player(id, "y")
				msg(reb.color.neg..player(id,"name").." used Evil Wrath!")
				parse("explosion "..x.." "..y.." 220 220 "..id)
				parse("explosion "..(x + 90).." "..(y + 90).." 180 220 "..id)
				parse("explosion "..(x + 90).." "..(y - 90).." 180 220 "..id)
				parse("explosion "..(x - 90).." "..(y - 90).." 180 220 "..id)
				parse("explosion "..(x - 90).." "..(y + 90).." 180 220 "..id)
				parse("explosion "..x.." "..(y + 90).." 150 175 "..id)
				parse("explosion "..x.." "..(y - 90).." 150 175 "..id)
				parse("explosion "..(x + 90).." "..y.." 150 175 "..id)
				parse("explosion "..(x - 90).." "..y.." 150 175 "..id)
			end
		};
	};
};
