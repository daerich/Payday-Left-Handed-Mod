_G.flipped_view = _G.flipped_view or {}
flipped_view._path = ModPath
flipped_view._save_file = SavePath .. "flipped_view.txt"
flipped_view.settings = {}

function flipped_view:ResetToDefaultValues()
	self.settings = {
		toggle = true,
		variable = -16.5
	}
end

function flipped_view:Load()
	self:ResetToDefaultValues()
	local file = io.open(self._save_file, "r")
	if file then
		for k, v in pairs(json.decode(file:read("*all")) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function flipped_view:Save()
	local file = io.open(self._save_file, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_flipped_view", function(loc)
	for _, filename in pairs(file.GetFiles(flipped_view._path .. "loc/")) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			loc:load_localization_file(flipped_view._path .. "loc/" .. filename)
			break
		end
	end
	loc:load_localization_file(flipped_view._path .. "loc/english.txt", false)
end)

local old_see_team, old_laser_on, old_contour_ammo_indicator, old_laser_ammo_indicator,  old_notification_ammo, old_waypoint_ammo, old_waypoint_low_ammo, old_announcement_ammo, old_notification_death, old_waypoint_death,  old_announcement_death, old_color_any
Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_flipped_view", function(menu_manager)
	
	--Toggle
	MenuCallbackHandler.toggle_view_clbk = function(this, item)
		flipped_view.settings.toggle_view = item:value() == "on" and true or false
	end
	
	--Variable
	MenuCallbackHandler.variable_clbk = function(this, item)
		flipped_view.settings.variable = item:value() or -16.5
	end
	
	--Save settings
	MenuCallbackHandler.flipped_view_save = function(this, item)
		flipped_view:Save()
	end
	
	--Load settings
	flipped_view:Load()
	
	--Load JSON
	MenuHelper:LoadFromJsonFile(flipped_view._path .. "menu/menu.txt", flipped_view, flipped_view.settings)
	
end)
