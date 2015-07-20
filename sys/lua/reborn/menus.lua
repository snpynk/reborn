--{{{ HEROES REBORN / MENUS
--{{{ READ info.lua

-- %men
-- Table containing menu functions
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
		msg2(id, reb.color.pos.."Super Heroes Reborn Mod v"..reb.VERSION.." written by "..reb.AUTHOR)
		msg2(id, "Last updated on "..reb.DATE)
	end
end

function men.commands(id, trigg)
	if trigg == 2 then
		cl.popHeroes(id)
	elseif trigg == 3 then
		cl.popMyHeroes(id)
	elseif trigg == 4 then
		cl.delHeroes(id)
	elseif trigg == 5 then
		cl.reset(id)
	elseif trigg == 6 then
		cl.popShop(id)
	elseif trigg == 7 then
		cl.popInv(id)
	elseif trigg == 8 then
		cl.popMark(id)
	elseif trigg == 9 then
		men.main(id, 5)
	else msg2(id, reb.color.neg.."Command not available yet, work in progress!") end
end

function men.items(id, trigg)
	if trigg == 1 then cl.popInv(id) elseif trigg == 2 then cl.popShop(id) elseif trigg == 3 then cl.popMark(id) end
end

--------------------------------------------------------------------------------------------------------------------

men.mem = {}
men.memP = 0

-- #men.frame(player_id, menu_title, menu_buttons, menu_function)
-- Pops up a menu to a player
function men.frame(id, title, buttons, callback)
	men.memP = men.memP + 1
	local frame = "x"..men.memP
	men.mem[frame] = {title, player = id, buttons = buttons, callback = callback}
	if #buttons < 10 then menu(id, title..","..table.concat(buttons,",")) else men._gen(id, frame) end
end

-- #men._gen(player_id, frame_id, frame_page)
-- Generates an advanced menu
function men._gen(id, frame, page)
	local data = men.mem[frame]
	local page = page or 1
	local pages = math.ceil(#data.buttons / 6)
	if page < 1 then page = pages end
	if page > pages then page = 1 end
	local menuString = data[1].." ("..page.."/"..pages..")"
	for i = 6 * page - 5, 6 * page do
		if data.buttons[i] then menuString = menuString..", "..data.buttons[i] else menuString = menuString.."," end
	end
	if page == pages then menuString = menuString..",,First page" else menuString = menuString..",,Next page" end
	if page == 1 then menuString = menuString..",Last page" else menuString = menuString..",Previous page" end
	menu(id, menuString)
end

-- #men._core(...)
-- Serves the frame menu callback and page system
function men._core(id, title, button)
	for frame, data in pairs(men.mem) do 
		if data.player == id and data[1] == title:sub(1, #data[1]) then
			if #data.buttons > 9 then
				local page = title:match("(%d*)/")
				local pages = math.ceil(#data.buttons / 6)
				if button == 8 then men._gen(id, frame, page + 1) return
				elseif button == 9 then men._gen(id, frame, page - 1) return
				elseif button <= 6 and button > 0 then button = ((page - 1) * 6) + button end
			end
			if button ~= 0 then
				local buttonName = data.buttons[button]
				if buttonName:find("|") then buttonName = buttonName:sub(1, buttonName:find("|") - 1) end
				loadstring(data.callback.."(...)")(id, button, buttonName); men.mem[frame] = nil
			end
			break
		end
	end
end

addhook("menu", "men._core")