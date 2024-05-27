Input = {
  tab = {},
  tab_prev = {}
}

function Input.update()
  Input.tab = input.get()

  local xmouse, ymouse = Input.resizeCoordinates(Input.tab['xmouse'], Input.tab['ymouse'])

  if Input.tab['rightclick'] and not Input.tab_prev['rightclick'] then
    Input.onClick(xmouse, ymouse)
  elseif Input.tab['rightclick'] and Input.tab_prev['rightclick'] then
    Input.onPress(xmouse, ymouse)
  elseif not Input.tab['rightclick'] and Input.tab_prev['rightclick'] then
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

    -- TAB BUTTONS

    local tab_size, tab_keys = Utils.getTableSizeAndKeys(Config.Edit_Panel.TAB_MENU.TABS)
    if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.TAB_MENU.x, Config.Edit_Panel.TAB_MENU.y, Config.Edit_Panel.TAB_MENU.width, Config.Edit_Panel.TAB_MENU.item_height * tab_size) then
      Config.Edit_Panel.TAB_MENU.selected_tab = math.floor((ymouse - Config.Edit_Panel.TAB_MENU.y) / Config.Edit_Panel.TAB_MENU.item_height) + 1
    end

    -- TAB CONTENT

    if Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_ELEMENTS" then

      local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(CustomHud.Items)
      if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.CUSTOM_HUD.x, Config.Edit_Panel.CUSTOM_HUD.y, Config.Edit_Panel.CUSTOM_HUD.width, Config.Edit_Panel.CUSTOM_HUD.item_height * custom_hud_size) then
        local selectedItem = math.floor((ymouse - Config.Edit_Panel.CUSTOM_HUD.y) / Config.Edit_Panel.CUSTOM_HUD.item_height) + 1
        Config.Settings.CUSTOM_HUD[custom_hud_keys[selectedItem]].visible = not Config.Settings.CUSTOM_HUD[custom_hud_keys[selectedItem]].visible
      end

      local original_hud_size, original_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.ORIGINAL_HUD)
      if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.ORIGINAL_HUD.x, Config.Edit_Panel.ORIGINAL_HUD.y, Config.Edit_Panel.ORIGINAL_HUD.width, Config.Edit_Panel.ORIGINAL_HUD.item_height * original_hud_size) then
        local selectedItem = math.floor((ymouse - Config.Edit_Panel.ORIGINAL_HUD.y) / Config.Edit_Panel.ORIGINAL_HUD.item_height) + 1
        Config.Settings.ORIGINAL_HUD[original_hud_keys[selectedItem]] = not Config.Settings.ORIGINAL_HUD[original_hud_keys[selectedItem]]
      end

    elseif Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_SETTINGS" then

      local misc_size, misc_keys = Utils.getTableSizeAndKeys(Config.Settings.MISC)
      if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.MISC.x, Config.Edit_Panel.MISC.y, Config.Edit_Panel.MISC.width, Config.Edit_Panel.MISC.item_height * misc_size) then
        local selectedItem = math.floor((ymouse - Config.Edit_Panel.MISC.y) / Config.Edit_Panel.MISC.item_height) + 1
        Config.Settings.MISC[misc_keys[selectedItem]] = not Config.Settings.MISC[misc_keys[selectedItem]]
      end

    elseif Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HACKS" then

      local hack_size, hack_keys = Utils.getTableSizeAndKeys(Config.Settings.HACKS)
      if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.HACKS.x, Config.Edit_Panel.HACKS.y, Config.Edit_Panel.HACKS.width, Config.Edit_Panel.HACKS.item_height * hack_size) then
        local selectedItem = math.floor((ymouse - Config.Edit_Panel.HACKS.y) / Config.Edit_Panel.HACKS.item_height) + 1
        Config.Settings.HACKS[hack_keys[selectedItem]] = not Config.Settings.HACKS[hack_keys[selectedItem]]
      end

    end

    -- EDIT MODE BUTTON

    if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.x, Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.y, Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.width, Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.height) then
      Config.EDIT_CUSTOM_HUD.enabled = not Config.EDIT_CUSTOM_HUD.enabled
    end

    -- ACTIONS

    local actions_size, actions_keys = Utils.getTableSizeAndKeys(Actions.Items)
    if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.ACTIONS.x, Config.Edit_Panel.ACTIONS.y, Config.Edit_Panel.ACTIONS.width, Config.Edit_Panel.ACTIONS.item_height * actions_size) then
      local selectedItem = math.floor((ymouse - Config.Edit_Panel.ACTIONS.y) / Config.Edit_Panel.ACTIONS.item_height) + 1
      Actions.Items[actions_keys[selectedItem]].active = not Actions.Items[actions_keys[selectedItem]].active
      if Actions.Items[actions_keys[selectedItem]].active then
        Actions.Items[actions_keys[selectedItem]].start()
      end
    end

    -- EDIT BUTTONS

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

    -- SAVE BUTTON

    if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.SAVE_CONFIG_BUTTON.x, Config.Edit_Panel.SAVE_CONFIG_BUTTON.y, Config.Edit_Panel.SAVE_CONFIG_BUTTON.width, Config.Edit_Panel.SAVE_CONFIG_BUTTON.height) then
      Config.save()
      Config.SAVE_CONFIG.pressed = true
    end

    -- HIDE MENU BUTTON

    if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.HIDE_MENU_BUTTON.x, Config.Edit_Panel.HIDE_MENU_BUTTON.y, Config.Edit_Panel.HIDE_MENU_BUTTON.width, Config.Edit_Panel.HIDE_MENU_BUTTON.height) then
      Config.EDIT_CUSTOM_HUD.enabled = false
      Config.EDIT_MENU.enabled = false
      print('Edit Menu is disabled! To enable it again, right-click on the touch screen!')
    end

  else
    Config.EDIT_MENU.enabled = true
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
