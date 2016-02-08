--{{{ HEROES REBORN / CLIENT COMMANDS
--{{{ READ info.lua

reb.ABOUT.commands = {
	{"heroes", level = 0, desc = "Heroes menu", func = "cl.popHeroes"};
	{"myheroes", level = 0, desc = "My heroes menu", func = "cl.popMyHeroes"};
	{"clearheroes", level = 0, desc = "Reset heroes", func = "cl.delHeroes"};
	{"getstats", "whatstats", level = 0, desc = "Show player stats", func = "cl.getStats"};
	{"inform", level = 0, desc = "Ge hero description", func = "cl.heroInfo"};
	{"reset", level = 0, desc = "Reset stats", concat = 1, func = "cl.reset"};
	{"shop", level = 0, desc = "Shop", func = "cl.popShop"};
	{"inventory", level = 0, desc = "Inventory", func = "cl.popInv"};
	{"market", level = 0, desc = "Market", func = "cl.popMark"};
	{"reborn", level = 0, desc = "Mod info", func = "cl.info"};
}