Input = {
  tab = {},
  tab_prev = {}
}

function Input.update()
  Input.tab = input.get()

  local xmouse, ymouse = Input.resizeCoordinates(Input.tab['xmouse'], Input.tab['ymouse'])

  if Input.tab['leftclick'] and not Input.tab_prev['leftclick'] then
    Input.onClick(xmouse, ymouse)
  elseif Input.tab['leftclick'] and Input.tab_prev['leftclick'] then
    Input.onPress(xmouse, ymouse)
  elseif not Input.tab['leftclick'] and Input.tab_prev['leftclick'] then
    Input.onRelease(xmouse, ymouse)
  end

  Input.tab_prev = Input.tab
end

function Input.getJoypad()
  local j = joypad.get(1)
  return j
end

function Input.getGhostInput(input)
  local j = {}
  if bit.band(input, 0x01) > 0 then j.A = 1 end
  if bit.band(input, 0x02) > 0 then j.B = 1 end
  if bit.band(input, 0x10) > 0 then j.right = 1 end
  if bit.band(input, 0x20) > 0 then j.left = 1 end
  if bit.band(input, 0x40) > 0 then j.up = 1 end
  if bit.band(input, 0x80) > 0 then j.down = 1 end
  if bit.band(input, 0x100) > 0 then j.R = 1 end
  if bit.band(input, 0x200) > 0 then j.L = 1 end
  return j
end

function Input.isInRange(xmouse,ymouse,x,y,xregion,yregion)
	if xmouse >= x and xmouse <= x + xregion then
		if ymouse >= y and ymouse <= y + yregion then
			return true
		end
	end
	return false
end

function Input.resizeCoordinates(xmouse, ymouse)
  return xmouse * Config.Settings.SCREEN_SIZE.width / 256, ymouse * Config.Settings.SCREEN_SIZE.height / 192
end

function Input.onClick(xmouse, ymouse)

  if Config.EDIT_MENU.enabled then

    local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(CustomHud.Items)
    if Input.isInRange(xmouse, ymouse, Config.Settings.EDIT_PANEL.CUSTOM_HUD.x, Config.Settings.EDIT_PANEL.CUSTOM_HUD.y, Config.Settings.EDIT_PANEL.CUSTOM_HUD.width, Config.Settings.EDIT_PANEL.CUSTOM_HUD.item_height * custom_hud_size) then
      local selectedItem = math.floor((ymouse - Config.Settings.EDIT_PANEL.CUSTOM_HUD.y) / Config.Settings.EDIT_PANEL.CUSTOM_HUD.item_height) + 1
      Config.Settings.CUSTOM_HUD[custom_hud_keys[selectedItem]].visible = not Config.Settings.CUSTOM_HUD[custom_hud_keys[selectedItem]].visible
    end

    if Input.isInRange(xmouse, ymouse, Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.x, Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.y, Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.width, Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.height) then
      Config.EDIT_CUSTOM_HUD.enabled = not Config.EDIT_CUSTOM_HUD.enabled
    end

    local original_hud_size, original_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.ORIGINAL_HUD)
    if Input.isInRange(xmouse, ymouse, Config.Settings.EDIT_PANEL.ORIGINAL_HUD.x, Config.Settings.EDIT_PANEL.ORIGINAL_HUD.y, Config.Settings.EDIT_PANEL.ORIGINAL_HUD.width, Config.Settings.EDIT_PANEL.ORIGINAL_HUD.item_height * original_hud_size) then
      local selectedItem = math.floor((ymouse - Config.Settings.EDIT_PANEL.ORIGINAL_HUD.y) / Config.Settings.EDIT_PANEL.ORIGINAL_HUD.item_height) + 1
      Config.Settings.ORIGINAL_HUD[original_hud_keys[selectedItem]] = not Config.Settings.ORIGINAL_HUD[original_hud_keys[selectedItem]]
    end

    local misc_size, misc_keys = Utils.getTableSizeAndKeys(Config.Settings.MISC)
    if Input.isInRange(xmouse, ymouse, Config.Settings.EDIT_PANEL.MISC.x, Config.Settings.EDIT_PANEL.MISC.y, Config.Settings.EDIT_PANEL.MISC.width, Config.Settings.EDIT_PANEL.MISC.item_height * misc_size) then
      local selectedItem = math.floor((ymouse - Config.Settings.EDIT_PANEL.MISC.y) / Config.Settings.EDIT_PANEL.MISC.item_height) + 1
      Config.Settings.MISC[misc_keys[selectedItem]] = not Config.Settings.MISC[misc_keys[selectedItem]]
    end

    local actions_size, actions_keys = Utils.getTableSizeAndKeys(Actions.Items)
    if Input.isInRange(xmouse, ymouse, Config.Settings.EDIT_PANEL.ACTIONS.x, Config.Settings.EDIT_PANEL.ACTIONS.y, Config.Settings.EDIT_PANEL.ACTIONS.width, Config.Settings.EDIT_PANEL.ACTIONS.item_height * actions_size) then
      local selectedItem = math.floor((ymouse - Config.Settings.EDIT_PANEL.ACTIONS.y) / Config.Settings.EDIT_PANEL.ACTIONS.item_height) + 1
      Actions.Items[actions_keys[selectedItem]].active = not Actions.Items[actions_keys[selectedItem]].active
      if Actions.Items[actions_keys[selectedItem]].active then
        Actions.Items[actions_keys[selectedItem]].start()
      end
    end

    if Config.EDIT_CUSTOM_HUD.enabled then
      for i = 1, custom_hud_size, 1 do
        local item_position = Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].position
        if Input.isInRange(xmouse, ymouse, item_position.x, item_position.y, 15, 15) then
          Config.EDIT_CUSTOM_HUD.item = custom_hud_keys[i]
          Config.EDIT_CUSTOM_HUD.click_offset.x = xmouse - item_position.x
          Config.EDIT_CUSTOM_HUD.click_offset.y = ymouse - item_position.y
        end
      end
    end

    if Input.isInRange(xmouse, ymouse, Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.x, Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.y, Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.width, Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.height) then
      Config.save()
      Config.SAVE_CONFIG.pressed = true
    end

    if Input.isInRange(xmouse, ymouse, Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.x, Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.y, Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.width, Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.height) then
      Config.EDIT_CUSTOM_HUD.enabled = false
      Config.EDIT_MENU.enabled = false
      print('Edit Menu is disabled! To enable it again, please reload the lua script.')
    end

  end

end

function Input.onPress(xmouse, ymouse)
  if Config.EDIT_MENU.enabled then
    if Config.EDIT_CUSTOM_HUD.enabled and Config.EDIT_CUSTOM_HUD.item ~= nil then
      Config.Settings.CUSTOM_HUD[Config.EDIT_CUSTOM_HUD.item].position.x = math.floor(xmouse - Config.EDIT_CUSTOM_HUD.click_offset.x)
      Config.Settings.CUSTOM_HUD[Config.EDIT_CUSTOM_HUD.item].position.y = math.floor(ymouse - Config.EDIT_CUSTOM_HUD.click_offset.y)
    end
  end
end

function Input.onRelease(xmouse, ymouse)
  if Config.EDIT_MENU.enabled then
    Config.EDIT_CUSTOM_HUD.item = nil
    Config.SAVE_CONFIG.pressed = false
  end
end
