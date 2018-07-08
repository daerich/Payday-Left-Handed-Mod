function PlayerStandard:_stance_entered(unequipped)
	local stance_standard = tweak_data.player.stances.default[managers.player:current_state()] or tweak_data.player.stances.default.standard
	local head_stance = self._state_data.ducking and tweak_data.player.stances.default.crouched.head or stance_standard.head
	local stance_id
	local stance_mod = {
		translation = Vector3(0, 0, 0)
	}
	
	if flipped_view.settings.toggle_view == true then
		stance_mod = {
			translation = Vector3(flipped_view.settings.variable, 0, 0)
		}
	else
		stance_mod = {
			translation = Vector3(0, 0, 0)
		}
	end
	
	log(tostring(stance_mod.translation))
	
	if not unequipped then
		stance_id = self._equipped_unit:base():get_stance_id()
		stance_mod = self._state_data.in_steelsight and self._equipped_unit:base().stance_mod and self._equipped_unit:base():stance_mod() or stance_mod
	end
	local stances
	if self:_is_meleeing() or self:_is_throwing_projectile() then
		stances = tweak_data.player.stances.default
	else
		stances = tweak_data.player.stances[stance_id] or tweak_data.player.stances.default
	end
	local misc_attribs = stances.standard
	if self:_is_using_bipod() and not self:_is_throwing_projectile() then
		misc_attribs = stances.bipod
	else
		misc_attribs = self._state_data.in_steelsight and stances.steelsight or self._state_data.ducking and stances.crouched or stances.standard
	end
	local duration = tweak_data.player.TRANSITION_DURATION + (self._equipped_unit:base():transition_duration() or 0)
	local duration_multiplier = self._state_data.in_steelsight and 1 / self._equipped_unit:base():enter_steelsight_speed_multiplier() or 1
	local new_fov = self:get_zoom_fov(misc_attribs) + 0
	self._camera_unit:base():clbk_stance_entered(misc_attribs.shoulders, head_stance, misc_attribs.vel_overshot, new_fov, misc_attribs.shakers, stance_mod, duration_multiplier, duration)
	managers.menu:set_mouse_sensitivity(self:in_steelsight())
end