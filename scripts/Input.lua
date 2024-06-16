Input = {
  tab = {},
  tab_prev = {}
}

function Input.getKeyboardInput()
  for i = 65, 90 do
      local key = string.char(i)
      if Input.tab[key] and not Input.tab_prev[key] then
          return key
      end
  end
  for i = 48, 57 do  -- ASCII codes for '0' to '9'
      local key = string.char(i)
      if Input.tab[key] and not Input.tab_prev[key] then
          return key
      end
      if Input.tab["numpad" .. key] and not Input.tab_prev["numpad" .. key] then
          return key
      end
  end
  if Input.tab["space"] and not Input.tab_prev["space"] then return " "
  elseif Input.tab["minus"] and Input.tab["shift"] and not Input.tab_prev["minus"] then return "_"
  elseif Input.tab["minus"] and not Input.tab_prev["minus"] then return "-"
  elseif Input.tab["period"] and not Input.tab_prev["period"] then return "."
  elseif Input.tab["backspace"] and not Input.tab_prev["backspace"] then return "delete"
  elseif Input.tab["delete"] and not Input.tab_prev["delete"] then return "delete"
  elseif Input.tab["enter"] and not Input.tab_prev["enter"] then return "enter"
  end
  return nil
end

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

  local keyboardInput = Input.getKeyboardInput()
  if keyboardInput ~= nil then
    Input.onKeyboardInput(keyboardInput)
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

function Input.onKeyboardInput(keyboardPress)
  if Config.EDIT_MENU.enabled then
    if Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_SOCIALS" then
      if Config.Edit_Panel.HUD_SOCIALS.edit_mode == 'text' then
        if keyboardPress == "enter" then
          Config.Edit_Panel.HUD_SOCIALS.edit_mode = 'none'
        elseif keyboardPress == "delete" then
          Config.Settings.SOCIAL_MEDIA.items[Config.Edit_Panel.HUD_SOCIALS.selected_item].text = string.sub(Config.Settings.SOCIAL_MEDIA.items[Config.Edit_Panel.HUD_SOCIALS.selected_item].text, 1, -2)
        else
          Config.Settings.SOCIAL_MEDIA.items[Config.Edit_Panel.HUD_SOCIALS.selected_item].text = Config.Settings.SOCIAL_MEDIA.items[Config.Edit_Panel.HUD_SOCIALS.selected_item].text .. keyboardPress
        end
      end
    end
  end
end

function Input.onClick(xmouse, ymouse)

  if Config.EDIT_MENU.enabled then

    -- TAB BUTTONS

    local tab_size = #Config.Edit_Panel.TAB_MENU.TABS
    if Input.isInRange(xmouse, ymouse, Config.Edit_Panel.TAB_MENU.x, Config.Edit_Panel.TAB_MENU.y, Config.Edit_Panel.TAB_MENU.width, Config.Edit_Panel.TAB_MENU.item_height * tab_size) then
      Config.Edit_Panel.TAB_MENU.selected_tab = math.floor((ymouse - Config.Edit_Panel.TAB_MENU.y) / Config.Edit_Panel.TAB_MENU.item_height) + 1
    end

    -- TAB CONTENT

    if Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_ELEMENTS" then

      local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.CUSTOM_HUD)
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

      local total_hack_size, total_hack_keys = Utils.getTableSizeAndKeys(Config.Edit_Panel.HACKS.ITEMS)
      local hack_keys =  Utils.getPageItems(total_hack_keys, Config.Edit_Panel.HACKS.items_per_page, Config.Edit_Panel.HACKS.selected_page)
      local hack_size = #hack_keys

      for i = 1, hack_size, 1 do
        local item_width = Config.Edit_Panel.HACKS.default_item_width
        local options = Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].options or {true,false}
        if Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].item_width then
          item_width = Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].item_width
        end
        if Input.isInRange(
          xmouse,
          ymouse,
          Config.Edit_Panel.HACKS.x + Config.Edit_Panel.HACKS.header_width,
          Config.Edit_Panel.HACKS.y + (i-1) * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap),
          item_width * #options,
          Config.Edit_Panel.HACKS.item_height
        ) then
          local selectedItem = math.floor((xmouse - Config.Edit_Panel.HACKS.x - Config.Edit_Panel.HACKS.header_width) / item_width) + 1
          Config.Settings.HACKS[hack_keys[i]] = options[selectedItem]
        elseif Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons ~= nil then
          local hack_extra_size, hack_extra_keys = Utils.getTableSizeAndKeys(Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons)
          for j = 1, hack_extra_size, 1 do
            local key = hack_extra_keys[j]
            if Input.isInRange(
              xmouse,
              ymouse,
              Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons[key].x,
              Config.Edit_Panel.HACKS.y + (i-1) * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap),
              Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons[key].width,
              Config.Edit_Panel.HACKS.item_height
            ) then
              Config.Settings.HACKS_EXTRA_BUTTONS[key] = not Config.Settings.HACKS_EXTRA_BUTTONS[key]
            end
          end
        end
      end

      local page_selector = {
        x = Config.Edit_Panel.TAB_MENU.x + Config.Edit_Panel.TAB_MENU.width + Config.Edit_Panel.TAB_MENU.box_width / 2 - 3 * 15 / 2,
        y = Config.Edit_Panel.TAB_MENU.y + Config.Edit_Panel.TAB_MENU.height - 20,
        button_size = 15
      }
      if Input.isInRange(xmouse, ymouse, page_selector.x, page_selector.y, page_selector.button_size, page_selector.button_size) then
        if Config.Edit_Panel.HACKS.selected_page > 1 then
          Config.Edit_Panel.HACKS.selected_page = Config.Edit_Panel.HACKS.selected_page - 1
        end
      elseif Input.isInRange(xmouse, ymouse, page_selector.x + page_selector.button_size * 2 + 10, page_selector.y, page_selector.button_size, page_selector.button_size) then
        if Config.Edit_Panel.HACKS.selected_page * Config.Edit_Panel.HACKS.items_per_page < total_hack_size then
          Config.Edit_Panel.HACKS.selected_page = Config.Edit_Panel.HACKS.selected_page + 1
        end
      end

    elseif Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_SOCIALS" then

      if Input.isInRange(xmouse, ymouse,
        Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.enabled_button.x,
        Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.enabled_button.y,
        Config.Edit_Panel.HUD_SOCIALS.enabled_button.width,
        Config.Edit_Panel.HUD_SOCIALS.enabled_button.height) then
          Config.Settings.CUSTOM_HUD_EXTRA.social_media.visible = not Config.Settings.CUSTOM_HUD_EXTRA.social_media.visible
      end

      if Config.Edit_Panel.HUD_SOCIALS.edit_mode == 'icon' then

        if Input.isInRange(xmouse, ymouse,
          Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.cancel_button.x,
          Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.cancel_button.y,
          Config.Edit_Panel.HUD_SOCIALS.cancel_button.width,
          Config.Edit_Panel.HUD_SOCIALS.cancel_button.height) then
            Config.Edit_Panel.HUD_SOCIALS.edit_mode = 'none'
        end

        for i = 1, #Config.SOCIAL_ICONS + 1, 1 do
          local icons_x = Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.edit_icon.x
          local icons_y = Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.edit_icon.y
          local icons_size = Config.Edit_Panel.HUD_SOCIALS.edit_icon.size
          local icons_dist = Config.Edit_Panel.HUD_SOCIALS.edit_icon.size + Config.Edit_Panel.HUD_SOCIALS.edit_icon.gap
          local icons_per_row = Config.Edit_Panel.HUD_SOCIALS.edit_icon.items_per_row

          if Input.isInRange(xmouse, ymouse,
            icons_x - 4 + icons_dist * ((i-1) % icons_per_row),
            icons_y - 4 + icons_dist * math.floor((i-1) / icons_per_row),
            icons_size,
            icons_size) then
              if i <= #Config.SOCIAL_ICONS then
                Config.Settings.SOCIAL_MEDIA.items[Config.Edit_Panel.HUD_SOCIALS.selected_item].icon = Config.SOCIAL_ICONS[i]
              else
                Config.Settings.SOCIAL_MEDIA.items[Config.Edit_Panel.HUD_SOCIALS.selected_item].icon = ''
              end
              Config.Edit_Panel.HUD_SOCIALS.edit_mode = 'none'
          end
        end

      else

        Config.Edit_Panel.HUD_SOCIALS.edit_mode = 'none' -- If click, reset to none mode

        if #Config.Settings.SOCIAL_MEDIA.items < Config.Edit_Panel.HUD_SOCIALS.max_items then
          if Input.isInRange(xmouse, ymouse,
            Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.add_element_button.x,
            Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.add_element_button.y,
            Config.Edit_Panel.HUD_SOCIALS.add_element_button.width,
            Config.Edit_Panel.HUD_SOCIALS.add_element_button.height) then
              table.insert(Config.Settings.SOCIAL_MEDIA.items, {icon = '',text = '',scale = 1})
          end
        end

        for i = 1, #Config.Settings.SOCIAL_MEDIA.items, 1 do
          local preview_x = Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.preview.x
          local preview_y = Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.preview.y
          local preview_size = Config.Edit_Panel.HUD_SOCIALS.preview.size
          local preview_dist = Config.Edit_Panel.HUD_SOCIALS.preview.size + Config.Edit_Panel.HUD_SOCIALS.preview.gap

          if Input.isInRange(xmouse, ymouse, preview_x - 16, preview_y - 4 + preview_dist*(i-1), 10, 10) then
            table.remove(Config.Settings.SOCIAL_MEDIA.items, i)
          end
          if Input.isInRange(xmouse, ymouse, preview_x - 4, preview_y - 4 + preview_dist*(i-1), preview_size, preview_size) then
            Config.Edit_Panel.HUD_SOCIALS.edit_mode = 'icon'
            Config.Edit_Panel.HUD_SOCIALS.selected_item = i
          end
          if Input.isInRange(xmouse, ymouse, preview_x + preview_size, preview_y - 4 + preview_dist*(i-1), Config.Edit_Panel.HUD_SOCIALS.width + Config.Edit_Panel.HUD_SOCIALS.x - preview_dist - preview_x, preview_size) then
            Config.Edit_Panel.HUD_SOCIALS.edit_mode = 'text'
            Config.Edit_Panel.HUD_SOCIALS.selected_item = i
          end
        end

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
      local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.CUSTOM_HUD)
      for i = 1, custom_hud_size, 1 do
        local item_position = Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].position
        if Input.isInRange(xmouse, ymouse, item_position.x, item_position.y, 15, 15) then
          Config.EDIT_CUSTOM_HUD.item = custom_hud_keys[i]
          Config.EDIT_CUSTOM_HUD.block = 'CUSTOM_HUD'
          Config.EDIT_CUSTOM_HUD.click_offset.x = xmouse - item_position.x
          Config.EDIT_CUSTOM_HUD.click_offset.y = ymouse - item_position.y
        end
      end

      local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.CUSTOM_HUD_EXTRA)
      for i = 1, custom_hud_size, 1 do
        local item_position = Config.Settings.CUSTOM_HUD_EXTRA[custom_hud_keys[i]].position
        if Input.isInRange(xmouse, ymouse, item_position.x, item_position.y, 15, 15) then
          Config.EDIT_CUSTOM_HUD.item = custom_hud_keys[i]
          Config.EDIT_CUSTOM_HUD.block = 'CUSTOM_HUD_EXTRA'
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
      Config.Settings[Config.EDIT_CUSTOM_HUD.block][Config.EDIT_CUSTOM_HUD.item].position.x = math.floor(xmouse - Config.EDIT_CUSTOM_HUD.click_offset.x)
      Config.Settings[Config.EDIT_CUSTOM_HUD.block][Config.EDIT_CUSTOM_HUD.item].position.y = math.floor(ymouse - Config.EDIT_CUSTOM_HUD.click_offset.y)
    end
  end
end

function Input.onRelease(xmouse, ymouse)
  if Config.EDIT_MENU.enabled then
    Config.EDIT_CUSTOM_HUD.item = nil
    Config.EDIT_CUSTOM_HUD.block = nil
    Config.SAVE_CONFIG.pressed = false
  end
end
