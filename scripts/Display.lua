Display = {
  Button = {
    pressed = {0x0000ffff, 0xffffffff, 0xffffffff, 0x000000ff},
    unpressed = {0x00000000, 0xffffffff, 0xaaaaaaff, 0x000000ff},
    disabled = {0x00000000, 0xaaaaaaff, 0xaaaaaaff, 0x000000ff},
    cancel = {0xff000033, 0xff0000ff,  0xff4444ff, 0x000000ff},
  },
  Edit_Mode = {
    unpressed = {0xffffff88, 0xffffffff},
    pressed = {0xffff0080, 0xffff00ff}
  }
}

function Display.MKDSText(x, y, text, scale, color, fade)
  current_x = x
  for i = 1, #text do
    local caracter = text:sub(i, i)
    if string.match(caracter, "%w") then
      caracter = string.upper(caracter)
    elseif caracter == '.' then
      caracter = 'dot'
    elseif caracter == '_' or caracter == '-' then
      -- do nothing
    else
      caracter = ' '
    end

    if caracter == ' ' then
      current_x = current_x + 10 * scale
    else
      bmpfile = 'resources/font/' .. caracter .. '.bmp'
      Bitmap.printFont(current_x, y, bmpfile, fade, scale, color)
      current_x = current_x + (Bitmap.buffer[bmpfile].width - 2) * scale
    end
  end
end

function Display.isHUDfinished(data)
  return data.finished_run == 1 and data.time_lap > 127
end

function Display.displayHUD(dataBuffer, showHUD)
  local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.CUSTOM_HUD)
  for i = 1, custom_hud_size, 1 do
    if custom_hud_keys[i] == "input_display" and not Config.Settings.MISC.disable_input_display_after_finish_race and Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].visible then
      CustomHud.Items[custom_hud_keys[i]].draw(dataBuffer[1])
    elseif showHUD and Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].visible then
      CustomHud.Items[custom_hud_keys[i]].draw(dataBuffer[1])
    end
  end
  if showHUD and Config.Settings.CUSTOM_HUD_EXTRA.social_media.visible then
    CustomHud.Items.social_media.draw(dataBuffer[1])
  end
end

function Display.button(x1,y1,x2,y2,text,box,buttontype)
  gui.box(x1,y1,x2,y2,Display.Button[buttontype][1], Display.Button[buttontype][2])
  gui.text(x1, y1 + box.height/2 - 2, Utils.getCenteredText(text, math.ceil(box.width / 6)), Display.Button[buttontype][3], Display.Button[buttontype][4])
end

function Display.buttonListWithTitle(title, size, keys, buttontypes, box)
  gui.text(box.x, box.y - 16, Utils.getCenteredText(title, math.ceil(box.width / 6)), 0xffffffff, 0x000000ff)
  for i = 1, size, 1 do
    Display.button(
      box.x,
      box.y + (i-1) * box.item_height,
      box.x + box.width,
      box.y + i * box.item_height,
      Utils.capitalizeWithSpaces(keys[i]),
      {x = box.x, y = box.y, width = box.width, height = box.item_height},
      buttontypes[i]
    )
  end
end

function Display.buttonList(size, keys, buttontypes, box)
  for i = 1, size, 1 do
    Display.button(
      box.x,
      box.y + (i-1) * box.item_height,
      box.x + box.width,
      box.y + i * box.item_height,
      Utils.capitalizeWithSpaces(keys[i]),
      {x = box.x, y = box.y, width = box.width, height = box.item_height},
      buttontypes[i]
    )
  end
end

function Display.displayRamDataItem(x,y,text)
  gui.text(Config.Edit_Panel.RAM_DATA.x + x, Config.Edit_Panel.RAM_DATA.y + y, text, 0xffffffff, 0x000000ff)
end

function Display.displayRamData(dataBuffer, pointer, pointer_addresses)

  if not Config.EDIT_MENU.enabled then return end

  Display.MKDSText(Config.Edit_Panel.RAM_DATA.x, Config.Edit_Panel.RAM_DATA.y, "RAM DATA", 0.8, 0xffd684ff, 0)

  Display.displayRamDataItem(0 , 30, "Pointers")
  Display.displayRamDataItem(0,  40, "1: [" .. bit.tohex(pointer_addresses[1]) .. "] -> " .. bit.tohex(pointer[1]))
  Display.displayRamDataItem(0,  50, "2: [" .. bit.tohex(pointer_addresses[2]) .. "] -> " .. bit.tohex(pointer[2]))
  Display.displayRamDataItem(0,  60, "3: [" .. bit.tohex(pointer_addresses[3]) .. "] -> " .. bit.tohex(pointer[3]))

  if dataBuffer[1] == nil then return end
  local data = dataBuffer[1]

  Display.displayRamDataItem(0,  80, "X: " .. data.position.x)
  Display.displayRamDataItem(0,  90, "Y: " .. data.position.y)
  Display.displayRamDataItem(0, 100, "Z: " .. data.position.z)
  Display.displayRamDataItem(0, 110, "Speed: " .. data.real_speed)
  Display.displayRamDataItem(0, 120, "Internal Speed: " .. data.speed)
  Display.displayRamDataItem(0, 130, "Max Speed: " .. data.max_speed)

  Display.displayRamDataItem(0, 150, "Boost: " .. data.boost)
  Display.displayRamDataItem(0, 160, "Boost (mt only): " .. data.boost_mt)
  Display.displayRamDataItem(0, 170, "MT timer: " .. data.mt_timer)

  Display.displayRamDataItem(0, 190, "Turning loss: " .. data.turning_loss)
  Display.displayRamDataItem(0, 200, "Grip: " .. data.grip)
  Display.displayRamDataItem(0, 210, "State: " .. data.air_state)

  Display.displayRamDataItem(0, 230, "Checkpoint: " .. data.checkpoint .. " (Key: " .. data.keycheckpoint .. ")")

  Display.displayRamDataItem(0, 250, "Timer: " .. data.current_timer)
  Display.displayRamDataItem(0, 260, "Lap (frames): " .. data.time_lap)

  for i = 1, data.totallaps, 1 do
    Display.displayRamDataItem(0, 270 + i*10, "Lap " .. i .. ": " .. data.lap_timer[i])
  end

end

function Display.displayActions()

  local actions_size, actions_keys = Utils.getTableSizeAndKeys(Actions.Items)
  for i = 1, actions_size, 1 do
    Actions.Items[actions_keys[i]].draw()
  end

end

function Display.displayEditMenu(screensize)

  if Config.Settings.MISC.green_screen_touchscreen then
    gui.box(0, 0,  screensize.width, screensize.height, "#00ff00", "#00ff00")
  end

  if not Config.EDIT_MENU.enabled then return end

  -- Main Panel

  gui.box(1, 1, screensize.width - 1, screensize.height - 1, "#00000080", 0xffffffff)
  gui.text(400, 345, "Right-click to interact with this menu!")

  -- Tab MENU

  gui.box(
    Config.Edit_Panel.TAB_MENU.x + Config.Edit_Panel.TAB_MENU.width,
    Config.Edit_Panel.TAB_MENU.y,
    Config.Edit_Panel.TAB_MENU.x + Config.Edit_Panel.TAB_MENU.width + Config.Edit_Panel.TAB_MENU.box_width,
    Config.Edit_Panel.TAB_MENU.y + Config.Edit_Panel.TAB_MENU.height,
    "#00000000",
    0xffffffff
  )

  local tab_size = #Config.Edit_Panel.TAB_MENU.TABS
  local tab_buttontypes = {}
  for i = 1, tab_size, 1 do
    tab_buttontypes[i] = Config.Edit_Panel.TAB_MENU.selected_tab == i and "pressed" or "unpressed"
  end
  Display.buttonList(tab_size, Config.Edit_Panel.TAB_MENU.TABS, tab_buttontypes, Config.Edit_Panel.TAB_MENU)


  -- Custom HUD

  if Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_ELEMENTS" then

    local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.CUSTOM_HUD)
    local custom_hud_buttontypes = {}
    for i = 1, custom_hud_size, 1 do
      custom_hud_buttontypes[i] = Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].visible and "pressed" or "unpressed"
    end
    Display.buttonListWithTitle("CUSTOM HUD", custom_hud_size, custom_hud_keys, custom_hud_buttontypes, Config.Edit_Panel.CUSTOM_HUD)

  end

  -- Original HUD

  if Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_ELEMENTS" then

    local original_hud_size, original_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.ORIGINAL_HUD)
    local original_hud_buttontypes = {}
    for i = 1, original_hud_size, 1 do
      original_hud_buttontypes[i] = Config.Settings.ORIGINAL_HUD[original_hud_keys[i]] and "pressed" or "unpressed"
    end
    Display.buttonListWithTitle("ORIGINAL HUD", original_hud_size, original_hud_keys, original_hud_buttontypes, Config.Edit_Panel.ORIGINAL_HUD)

  end

  -- Misc HUD

  if Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_SETTINGS" then

    local misc_size, misc_keys = Utils.getTableSizeAndKeys(Config.Settings.MISC)
    local misc_buttontypes = {}
    for i = 1, misc_size, 1 do
      misc_buttontypes[i] = Config.Settings.MISC[misc_keys[i]] and "pressed" or "unpressed"
    end
    Display.buttonList(misc_size, misc_keys, misc_buttontypes, Config.Edit_Panel.MISC)

  end

  -- Hack HUD

  if Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HACKS" then

    local total_hack_size, total_hack_keys = Utils.getTableSizeAndKeys(Config.Edit_Panel.HACKS.ITEMS)
    local hack_keys =  Utils.getPageItems(total_hack_keys, Config.Edit_Panel.HACKS.items_per_page, Config.Edit_Panel.HACKS.selected_page)
    local hack_size = #hack_keys

    for i = 1, hack_size, 1 do
      gui.text(Config.Edit_Panel.HACKS.x + 10, Config.Edit_Panel.HACKS.y + (i - 0.5) * (Config.Edit_Panel.HACKS.item_height + 5) - 5, Utils.capitalizeWithSpaces(hack_keys[i]), 0xffffffff, 0x000000ff)

      local item_width = Config.Edit_Panel.HACKS.default_item_width
      if Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].item_width then
        item_width = Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].item_width
      end

      if Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].options == nil then
        local pressed = {true,false}
        if not Config.Settings.HACKS[hack_keys[i]] then pressed = {false,true} end
        for j = 1, 2, 1 do
          Display.button(
            Config.Edit_Panel.HACKS.x + Config.Edit_Panel.HACKS.header_width + item_width * (j-1),
            Config.Edit_Panel.HACKS.y + (i-1) * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap),
            Config.Edit_Panel.HACKS.x + Config.Edit_Panel.HACKS.header_width + item_width * (j),
            Config.Edit_Panel.HACKS.y + i * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap) - Config.Edit_Panel.HACKS.item_gap,
            j == 1 and "ENABLED" or "DISABLED",
            {x = Config.Edit_Panel.HACKS.x + item_width, y = Config.Edit_Panel.HACKS.y + i * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap), width = item_width, height = Config.Edit_Panel.HACKS.item_height},
            pressed[j] and "pressed" or "unpressed"
          )
        end
      else
        for j = 1, #Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].options, 1 do
            Display.button(
              Config.Edit_Panel.HACKS.x + Config.Edit_Panel.HACKS.header_width + item_width * (j-1),
              Config.Edit_Panel.HACKS.y + (i-1) * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap),
              Config.Edit_Panel.HACKS.x + Config.Edit_Panel.HACKS.header_width + item_width * (j),
              Config.Edit_Panel.HACKS.y + i * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap) - Config.Edit_Panel.HACKS.item_gap,
              Utils.capitalizeWithSpaces(Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].options[j]),
              {x = Config.Edit_Panel.HACKS.x + item_width, y = Config.Edit_Panel.HACKS.y + i * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap), width = item_width, height = Config.Edit_Panel.HACKS.item_height},
              Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].options[j] == Config.Settings.HACKS[hack_keys[i]] and "pressed" or "unpressed"
            )
        end
      end

      if Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons ~= nil then
        local hack_extra_size, hack_extra_keys = Utils.getTableSizeAndKeys(Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons)
        for j = 1, hack_extra_size, 1 do
          local key = hack_extra_keys[j]
          Display.button(
            Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons[key].x,
            Config.Edit_Panel.HACKS.y + (i-1) * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap),
            Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons[key].x + Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons[key].width,
            Config.Edit_Panel.HACKS.y + i * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap) - Config.Edit_Panel.HACKS.item_gap,
            Utils.capitalizeWithSpaces(key),
            {x = Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons[key].x, y = Config.Edit_Panel.HACKS.y + i * (Config.Edit_Panel.HACKS.item_height + Config.Edit_Panel.HACKS.item_gap), width = Config.Edit_Panel.HACKS.ITEMS[hack_keys[i]].extra_buttons[key].width, height = Config.Edit_Panel.HACKS.item_height},
            Config.Settings.HACKS_EXTRA_BUTTONS[key] and "pressed" or "unpressed"
          )
        end
      end
    end

    local page_selector = {
      x = Config.Edit_Panel.TAB_MENU.x + Config.Edit_Panel.TAB_MENU.width + Config.Edit_Panel.TAB_MENU.box_width / 2 - 3 * 15 / 2,
      y = Config.Edit_Panel.TAB_MENU.y + Config.Edit_Panel.TAB_MENU.height - 20,
      button_size = 15
    }
    Display.button(
      page_selector.x,
      page_selector.y,
      page_selector.x + page_selector.button_size,
      page_selector.y + page_selector.button_size,
      "<",
      {x = page_selector.x, y = page_selector.y, width = page_selector.button_size, height = page_selector.button_size},
      Config.Edit_Panel.HACKS.selected_page > 1 and "pressed" or "disabled"
    )
    gui.text(
      page_selector.x + page_selector.button_size + 5,
      page_selector.y + page_selector.button_size/2 - 2,
      Utils.getCenteredText(tostring(Config.Edit_Panel.HACKS.selected_page), math.ceil(15 / 6))
    )
    Display.button(
      page_selector.x + page_selector.button_size * 2 + 10,
      page_selector.y,
      page_selector.x + page_selector.button_size * 3 + 10,
      page_selector.y + page_selector.button_size,
      ">",
      {x = page_selector.x + page_selector.button_size * 2 + 10, y = page_selector.y, width = page_selector.button_size, height = page_selector.button_size},
      Config.Edit_Panel.HACKS.selected_page * Config.Edit_Panel.HACKS.items_per_page < total_hack_size and "pressed" or "disabled"
    )

  end

  -- HUD Socials

  if Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_SOCIALS" then

    Display.button(
      Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.enabled_button.x,
      Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.enabled_button.y,
      Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.enabled_button.x + Config.Edit_Panel.HUD_SOCIALS.enabled_button.width,
      Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.enabled_button.y + Config.Edit_Panel.HUD_SOCIALS.enabled_button.height,
      "ENABLED",
      Config.Edit_Panel.HUD_SOCIALS.enabled_button,
      Config.Settings.CUSTOM_HUD_EXTRA.social_media.visible and "pressed" or "unpressed"
    )

    if Config.Edit_Panel.HUD_SOCIALS.edit_mode == 'icon' then

      Display.MKDSText(Config.Edit_Panel.HUD_SOCIALS.x + 120, Config.Edit_Panel.HUD_SOCIALS.y + 12, "SELECT ICON", 0.8, 0xffffffff, 0)

      Display.button(
        Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.cancel_button.x,
        Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.cancel_button.y,
        Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.cancel_button.x + Config.Edit_Panel.HUD_SOCIALS.cancel_button.width,
        Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.cancel_button.y + Config.Edit_Panel.HUD_SOCIALS.cancel_button.height,
        "CANCEL",
        Config.Edit_Panel.HUD_SOCIALS.cancel_button,
        "cancel"
      )

      for i = 1, #Config.SOCIAL_ICONS + 1, 1 do
        local icons_x = Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.edit_icon.x
        local icons_y = Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.edit_icon.y
        local icons_size = Config.Edit_Panel.HUD_SOCIALS.edit_icon.size
        local icons_dist = Config.Edit_Panel.HUD_SOCIALS.edit_icon.size + Config.Edit_Panel.HUD_SOCIALS.edit_icon.gap
        local icons_per_row = Config.Edit_Panel.HUD_SOCIALS.edit_icon.items_per_row

        gui.box(
          icons_x - 4 + icons_dist * ((i-1) % icons_per_row),
          icons_y - 4 + icons_dist * math.floor((i-1) / icons_per_row),
          icons_x - 4 + icons_dist * ((i-1) % icons_per_row) + icons_size,
          icons_y - 4 + icons_dist * math.floor((i-1) / icons_per_row) + icons_size,
          0x00000000,
          'white'
        )
        if i <= #Config.SOCIAL_ICONS then
          icon = 'resources/social/' .. Config.SOCIAL_ICONS[i] .. '.bmp'
          Bitmap.printImage(
            icons_x + icons_dist * ((i-1) % icons_per_row),
            icons_y + icons_dist * math.floor((i-1) / icons_per_row),
            icon, 0, 1)
        end

      end

    else

      if #Config.Settings.SOCIAL_MEDIA.items < Config.Edit_Panel.HUD_SOCIALS.max_items then
        Display.button(
          Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.add_element_button.x,
          Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.add_element_button.y,
          Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.add_element_button.x + Config.Edit_Panel.HUD_SOCIALS.add_element_button.width,
          Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.add_element_button.y + Config.Edit_Panel.HUD_SOCIALS.add_element_button.height,
          "ADD ELEMENT",
          Config.Edit_Panel.HUD_SOCIALS.add_element_button,
          "pressed"
        )
      end

      for i = 1, #Config.Settings.SOCIAL_MEDIA.items, 1 do
        local preview_x = Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.preview.x
        local preview_y = Config.Edit_Panel.HUD_SOCIALS.y + Config.Edit_Panel.HUD_SOCIALS.preview.y
        local preview_size = Config.Edit_Panel.HUD_SOCIALS.preview.size
        local preview_dist = Config.Edit_Panel.HUD_SOCIALS.preview.size + Config.Edit_Panel.HUD_SOCIALS.preview.gap

        -- X cancel buttons: Not using Display.button here cause it doesn't center the X properly
        gui.box(
          preview_x - 16,
          preview_y - 4 + preview_dist*(i-1),
          preview_x - 6,
          preview_y - 4 + 10 + preview_dist*(i-1),
          0xff000066,
          'red'
        )
        gui.text(preview_x - 13, preview_y - 2 + preview_dist*(i-1), "X", "red")

        -- Social boxes
        gui.box(
          preview_x - 4,
          preview_y - 4 + preview_dist*(i-1),
          preview_x - 4 + preview_size,
          preview_y - 4 + preview_size + preview_dist*(i-1),
          0x00000000,
          'white'
        )
        gui.box(
          preview_x + preview_size,
          preview_y - 4 + preview_dist*(i-1),
          Config.Edit_Panel.HUD_SOCIALS.x + Config.Edit_Panel.HUD_SOCIALS.width - Config.Edit_Panel.HUD_SOCIALS.preview.gap,
          preview_y - 4 + preview_size + preview_dist*(i-1),
          (Config.Edit_Panel.HUD_SOCIALS.edit_mode == 'text' and Config.Edit_Panel.HUD_SOCIALS.selected_item == i) and 0xffff0033 or 0x00000000,
          'white'
        )

        if Config.Settings.SOCIAL_MEDIA.items[i].icon ~= nil and Config.Settings.SOCIAL_MEDIA.items[i].icon ~= '' then
          icon = 'resources/social/' .. Config.Settings.SOCIAL_MEDIA.items[i].icon .. '.bmp'
          Bitmap.printImage(preview_x, preview_y + preview_dist*(i-1), icon, 0, 1)
        end
        if Config.Settings.SOCIAL_MEDIA.items[i].text ~= nil and Config.Settings.SOCIAL_MEDIA.items[i].text ~= '' then
          local scale = Config.Settings.SOCIAL_MEDIA.items[i].scale or 1
          Display.MKDSText(preview_x + preview_dist, preview_y + preview_dist*(i-1) + 5, Config.Settings.SOCIAL_MEDIA.items[i].text, scale,
            (Config.Edit_Panel.HUD_SOCIALS.edit_mode == 'text' and Config.Edit_Panel.HUD_SOCIALS.selected_item == i) and 0xeeee00ff or 0xffffffff, 0
          )
        end
      end

    end

  end

  -- Edit Mode

  Display.button(
    Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.x,
    Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.y,
    Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.x + Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.width,
    Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.y + Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON.height,
    "EDIT MODE",
    Config.Edit_Panel.CUSTOM_HUD_EDIT_BUTTON,
    Config.EDIT_CUSTOM_HUD.enabled and "pressed" or "unpressed"
  )

  if Config.EDIT_CUSTOM_HUD.enabled then

    local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.CUSTOM_HUD)
    for i = 1, custom_hud_size, 1 do
      local item_position = Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].position
      if Config.EDIT_CUSTOM_HUD.item == custom_hud_keys[i] then
        gui.text(item_position.x - 5, item_position.y - 10, "(" .. item_position.x .. ", " .. item_position.y .. ")", Display.Edit_Mode.pressed[2], 0x000000ff)
        gui.box(item_position.x, item_position.y, item_position.x + 15, item_position.y + 15, Display.Edit_Mode.pressed[1], Display.Edit_Mode.pressed[2])
      else
        gui.box(item_position.x, item_position.y, item_position.x + 15, item_position.y + 15, Display.Edit_Mode.unpressed[1], Display.Edit_Mode.unpressed[2])
      end
    end

    local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.CUSTOM_HUD_EXTRA)
    for i = 1, custom_hud_size, 1 do
      local item_position = Config.Settings.CUSTOM_HUD_EXTRA[custom_hud_keys[i]].position
      if Config.EDIT_CUSTOM_HUD.item == custom_hud_keys[i] then
        gui.text(item_position.x - 5, item_position.y - 10, "(" .. item_position.x .. ", " .. item_position.y .. ")", Display.Edit_Mode.pressed[2], 0x000000ff)
        gui.box(item_position.x, item_position.y, item_position.x + 15, item_position.y + 15, Display.Edit_Mode.pressed[1], Display.Edit_Mode.pressed[2])
      else
        gui.box(item_position.x, item_position.y, item_position.x + 15, item_position.y + 15, Display.Edit_Mode.unpressed[1], Display.Edit_Mode.unpressed[2])
      end
    end

  end

  -- Actions Menu

  local actions_size, actions_keys = Utils.getTableSizeAndKeys(Actions.Items)
  local actions_buttontypes = {}

  for i = 1, actions_size, 1 do
    actions_buttontypes[i] = Actions.Items[actions_keys[i]].active and "pressed" or "unpressed"
  end
  Display.buttonListWithTitle("ACTIONS", actions_size, actions_keys, actions_buttontypes, Config.Edit_Panel.ACTIONS)

  -- Save Config

  Display.button(
    Config.Edit_Panel.SAVE_CONFIG_BUTTON.x,
    Config.Edit_Panel.SAVE_CONFIG_BUTTON.y,
    Config.Edit_Panel.SAVE_CONFIG_BUTTON.x + Config.Edit_Panel.SAVE_CONFIG_BUTTON.width,
    Config.Edit_Panel.SAVE_CONFIG_BUTTON.y + Config.Edit_Panel.SAVE_CONFIG_BUTTON.height,
    "SAVE CONFIG",
    Config.Edit_Panel.SAVE_CONFIG_BUTTON,
    Config.SAVE_CONFIG.pressed and "pressed" or "unpressed"
  )

  -- Hide Menu Button

  Display.button(
    Config.Edit_Panel.HIDE_MENU_BUTTON.x,
    Config.Edit_Panel.HIDE_MENU_BUTTON.y,
    Config.Edit_Panel.HIDE_MENU_BUTTON.x + Config.Edit_Panel.HIDE_MENU_BUTTON.width,
    Config.Edit_Panel.HIDE_MENU_BUTTON.y + Config.Edit_Panel.HIDE_MENU_BUTTON.height,
    "HIDE MENU",
    Config.Edit_Panel.HIDE_MENU_BUTTON,
    "unpressed"
  )

end
