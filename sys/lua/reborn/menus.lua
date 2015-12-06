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
men.memP = 0

-- #men.frame(player_id, menu_title, menu_buttons, menu_function)
-- Pops up a menu to a player
function men.frame(id, title, buttons, callback, page)
	local page = page or 1
	men.memP = men.memP + 1
	local frame = "x"..men.memP
	men.mem[frame] = {title, player = id, buttons = buttons, callback = callback}
	if #buttons < 10 then menu(id, title..","..table.concat(buttons,",")) else men._gen(id, frame, page) end
end

-- #men.null()
-- Serves as helpers to menus with no action buttons
function men.null()
end

-- #men._gen(player_id, frame_id, frame_page)
-- Generates an advanced menu
function men._gen(id, frame, page)
	local data = men.mem[frame]

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
	for frame, data in pairs(men.mem) do 
		if data.player == id and ((#data.buttons <= 9 and data[1] == title) or (#data.buttons > 9 and data[1] == title:match("(.*) %(%d*/%d*%)"))) then
			if button == 0 or button == "X" then men.mem[frame] = nil return end

			if #data.buttons > 9 then

				local page = tonumber(title:match(".* %((%d*)/%d*%)"))
				local pages = math.ceil(#data.buttons / 6)

				if button == 8 then men._gen(id, frame, page + 1) return
				elseif button == 9 then men._gen(id, frame, page - 1) return
				elseif button <= 6 then button = ((page - 1) * 6) + button end
			end
			
			local buttonName = data.buttons[button]
			if buttonName:find("|") then buttonName = buttonName:sub(1, buttonName:find("|") - 1) end
			if #data.buttons > 9 then loadstring(data.callback.."(...)")(id, button, buttonName, page); 
			else loadstring(data.callback.."(...)")(id, button, buttonName) end
			men.mem[frame] = nil
			return
		end
	end
end

addhook("menu", "men._core")