Display = {
  Button = {
    pressed = {0x0000ffff, 0xffffffff, 0xffffffff, 0x000000ff},
    unpressed = {0x00000000, 0xffffffff, 0xaaaaaaff, 0x000000ff},
    disabled = {0x00000000, 0xffffffff, 0xaaaaaaff, 0x000000ff}
  },
  Edit_Mode = {
    unpressed = {0xffffff88, 0xffffffff},
    pressed = {0xffff0080, 0xffff00ff}
  }
}

function Display.isHUDfinished(data)
  return data.finished_run == 1 and data.time_lap > 127
end

function Display.displayHUD(dataBuffer, showHUD)
  local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(CustomHud.Items)
  for i = 1, custom_hud_size, 1 do
    if custom_hud_keys[i] == "input_display" and not Config.Settings.MISC.disable_idisplay_after_finish and Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].visible then
      CustomHud.Items[custom_hud_keys[i]].draw(dataBuffer[1])
    elseif showHUD and Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].visible then
      CustomHud.Items[custom_hud_keys[i]].draw(dataBuffer[1])
    end
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
      string.upper(keys[i]:gsub("_"," ")),
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
      string.upper(keys[i]:gsub("_"," ")),
      {x = box.x, y = box.y, width = box.width, height = box.item_height},
      buttontypes[i]
    )
  end
end

function Display.displayRamDataItem(x,y,text)
  gui.text(Config.Edit_Panel.RAM_DATA.x + x, Config.Edit_Panel.RAM_DATA.y + y, text, 0xffffffff, 0x000000ff)
end

function Display.displayRamData(dataBuffer, pointer)

  if not Config.EDIT_MENU.enabled then return end

  Display.displayRamDataItem(0 ,0, "RAM DATA")

  Display.displayRamDataItem(0,  20, "Pointer 1: " .. bit.tohex(pointer[1]))
  Display.displayRamDataItem(0,  30, "Pointer 2: " .. bit.tohex(pointer[2]))
  Display.displayRamDataItem(0,  40, "Pointer 3: " .. bit.tohex(pointer[3]))

  if dataBuffer[1] == nil then return end
  local data = dataBuffer[1]

  Display.displayRamDataItem(0,  60, "X: " .. data.position.x)
  Display.displayRamDataItem(0,  70, "Y: " .. data.position.y)
  Display.displayRamDataItem(0,  80, "Z: " .. data.position.z)
  Display.displayRamDataItem(0,  90, "Speed: " .. data.real_speed)
  Display.displayRamDataItem(0, 100, "Internal Speed: " .. data.speed)

  Display.displayRamDataItem(0, 120, "Boost: " .. data.boost)
  Display.displayRamDataItem(0, 130, "Boost (mt only): " .. data.boost_mt)

  Display.displayRamDataItem(0, 150, "Checkpoint: " .. data.checkpoint)
  Display.displayRamDataItem(0, 160, "Key Checkpoint: " .. data.keycheckpoint)

  Display.displayRamDataItem(0, 180, "Timer: " .. data.current_timer)
  Display.displayRamDataItem(0, 190, "Lap (frames): " .. data.time_lap)

  for i = 1, data.totallaps, 1 do
    Display.displayRamDataItem(0, 200 + i*10, "Lap " .. i .. ": " .. data.lap_timer[i])
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

  local tab_size, tab_keys = Utils.getTableSizeAndKeys(Config.Edit_Panel.TAB_MENU.TABS)
  local tab_buttontypes = {}
  for i = 1, tab_size, 1 do
    tab_buttontypes[i] = Config.Edit_Panel.TAB_MENU.selected_tab == i and "pressed" or "unpressed"
  end
  Display.buttonList(tab_size, Config.Edit_Panel.TAB_MENU.TABS, tab_buttontypes, Config.Edit_Panel.TAB_MENU)


  -- Custom HUD

  if Config.Edit_Panel.TAB_MENU.TABS[Config.Edit_Panel.TAB_MENU.selected_tab] == "HUD_ELEMENTS" then

    local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(CustomHud.Items)
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

    local hack_size, hack_keys = Utils.getTableSizeAndKeys(Config.Settings.HACKS)
    local hack_buttontypes = {}
    for i = 1, hack_size, 1 do
      hack_buttontypes[i] = Config.Settings.HACKS[hack_keys[i]] and "pressed" or "unpressed"
    end
    Display.buttonList(hack_size, hack_keys, hack_buttontypes, Config.Edit_Panel.HACKS)

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
    for i = 1, custom_hud_size, 1 do
      local item_position = Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].position
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

  -- Actions

  for i = 1, actions_size, 1 do
    Actions.Items[actions_keys[i]].draw()
  end


end
