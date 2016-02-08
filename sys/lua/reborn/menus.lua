--{{{ HEROES REBORN / MENUS
--{{{ READ info.lua

-- %men
-- Table containing stactic menu functions
men = {}

function men.main(id, trigg)
	if trigg == 1 then
		-- Chat Commands
		cl.popCmds(id)
	elseif trigg == 2 then
		-- Heroes Menu
		cl.popHeroes(id)
	elseif trigg == 3 then
		-- Heroes Build
		cl.popMyHeroes(id)
	elseif trigg == 4 then
		-- Items Menu
		cl.popItems(id)
	elseif trigg == 5 then
		-- Information
		cl.info(id)
	end
end

function men.commands(id, trigg, cmd)
	local func
	cmd = cmd:sub(2, #cmd)
	for _, cmd2 in ipairs(reb.ABOUT.commands) do if cmd2[1] == cmd then func = cmd2.func end end
	loadstring(func.."(...)")(id)
end

function men.items(id, trigg)
	if trigg == 1 then cl.popInv(id) elseif trigg == 2 then cl.popShop(id) elseif trigg == 3 then cl.popMark(id) end
end

--------------------------------------------------------------------------------------------------------------------

men.mem = {}
for id = 1, tonumber(game("sv_maxplayers")) do men.mem[id] = false end

-- #men.frame(player_id, menu_title, menu_buttons, menu_function)
-- Pops up a menu to a player
function men.frame(id, title, buttons, callback, page)
	local page = page or 1
	men.mem[id] = {title, player = id, buttons = buttons, callback = callback}
	if #buttons < 10 then menu(id, title..","..table.concat(buttons,",")) else men._gen(id, page) end
end

-- #men.null()
-- Serves as helpers to menus with no action buttons
function men.null()
end

-- #men._gen(player_id, frame_page)
-- Generates a possible advanced menu
function men._gen(id, page)
	local data = men.mem[id]

	local pages = math.ceil(#data.buttons / 6)
	page = (page < 1 and pages) or (page > pages and 1) or page

	local menuString = data[1].." ("..page.."/"..pages..")"
	for i = 6 * page - 5, 6 * page do
		if data.buttons[i] then menuString = menuString..","..data.buttons[i] else menuString = menuString.."," end
	end

	if page == pages then menuString = menuString..",,First page" else menuString = menuString..",,Next page" end
	if page == 1 then menuString = menuString..",Last page" else menuString = menuString..",Previous page" end
	menu(id, menuString)
end

-- #men._core(...)
-- Serves the frame menu callback and page system
function men._core(id, title, button)
	local menu = men.mem[id]
	if menu and (menu[1] == title or (#menu.buttons > 9 and menu[1] == title:match("(.*) %(%d*/%d*%)"))) then
		if button == 0 or button == "X" then
			men.mem[id] = false
			return
		end

		if #menu.buttons > 9 then
			local page = tonumber(title:match(".* %((%d*)/%d*%)"))
			local pages = math.ceil(#menu.buttons / 6)

			if button == 8 then men._gen(id, page + 1) return
			elseif button == 9 then men._gen(id, page - 1) return
			elseif button <= 6 then button = ((page - 1) * 6) + button end
		end
		
		local buttonName = menu.buttons[button]
		if buttonName:find("|") then buttonName = buttonName:match("(.*)|") end

		local callback = menu.callback
		men.mem[id] = false

		local success, err = pcall(loadstring(callback.."(...)"), id, button, buttonName, page or nil)
		if not success then
			print("Error: Reborn Menus: Menu named \""..title.."\" failed on button \""..buttonName.."\"#"..button.." for ID#"..id..":")
			print(err)
		end

		return
	end
end

addhook("menu", "men._core")