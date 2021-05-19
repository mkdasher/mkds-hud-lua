Display = {
  Button = {
    pressed = {"#0000ffff", "white", "white", "black"},
    unpressed = {"#00000000", "white", "#aaaaaaff", "black"},
    disabled = {"#00000000", "white", "#aaaaaaff", "black"}
  },
  Edit_Mode = {
    unpressed = {"#ffffff88", "white"},
    pressed = {"#ffff0080", "yellow"}
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

function Display.buttonList(title, size, keys, buttontypes, box)
  gui.text(box.x, box.y - 16, Utils.getCenteredText(title, math.ceil(box.width / 6)), "white", "black")
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

function Display.displayEditMenu(screensize)

  if not Config.EDIT_MENU.enabled then return end

  -- Main Panel

  gui.box(2, 2, screensize.width - 2, screensize.height - 2, "#00000080", "white")

  -- Custom HUD

  local custom_hud_size, custom_hud_keys = Utils.getTableSizeAndKeys(CustomHud.Items)
  local custom_hud_buttontypes = {}
  for i = 1, custom_hud_size, 1 do
    custom_hud_buttontypes[i] = Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].visible and "pressed" or "unpressed"
  end
  Display.buttonList("CUSTOM HUD", custom_hud_size, custom_hud_keys, custom_hud_buttontypes, Config.Settings.EDIT_PANEL.CUSTOM_HUD)

  Display.button(
    Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.x,
    Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.y,
    Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.x + Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.width,
    Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.y + Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON.height,
    "EDIT MODE",
    Config.Settings.EDIT_PANEL.CUSTOM_HUD_EDIT_BUTTON,
    Config.EDIT_CUSTOM_HUD.enabled and "pressed" or "unpressed"
  )

  if Config.EDIT_CUSTOM_HUD.enabled then
    for i = 1, custom_hud_size, 1 do
      local item_position = Config.Settings.CUSTOM_HUD[custom_hud_keys[i]].position
      if Config.EDIT_CUSTOM_HUD.item == custom_hud_keys[i] then
        gui.text(item_position.x - 5, item_position.y - 10, "(" .. item_position.x .. ", " .. item_position.y .. ")", Display.Edit_Mode.pressed[2], "black")
        gui.box(item_position.x, item_position.y, item_position.x + 15, item_position.y + 15, Display.Edit_Mode.pressed[1], Display.Edit_Mode.pressed[2])
      else
        gui.box(item_position.x, item_position.y, item_position.x + 15, item_position.y + 15, Display.Edit_Mode.unpressed[1], Display.Edit_Mode.unpressed[2])
      end
    end
  end

  -- Original HUD

  local original_hud_size, original_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.ORIGINAL_HUD)
  local original_hud_buttontypes = {}
  for i = 1, original_hud_size, 1 do
    original_hud_buttontypes[i] = Config.Settings.ORIGINAL_HUD[original_hud_keys[i]] and "pressed" or "unpressed"
  end
  Display.buttonList("ORIGINAL HUD", original_hud_size, original_hud_keys, original_hud_buttontypes, Config.Settings.EDIT_PANEL.ORIGINAL_HUD)

  -- Misc HUD

  local misc_hud_size, misc_hud_keys = Utils.getTableSizeAndKeys(Config.Settings.MISC)
  local misc_hud_buttontypes = {}
  for i = 1, misc_hud_size, 1 do
    misc_hud_buttontypes[i] = Config.Settings.MISC[misc_hud_keys[i]] and "pressed" or "unpressed"
  end
  Display.buttonList("MISC", misc_hud_size, misc_hud_keys, misc_hud_buttontypes, Config.Settings.EDIT_PANEL.MISC)

  -- Save Config

  Display.button(
    Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.x,
    Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.y,
    Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.x + Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.width,
    Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.y + Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON.height,
    "SAVE CONFIG",
    Config.Settings.EDIT_PANEL.SAVE_CONFIG_BUTTON,
    Config.SAVE_CONFIG.pressed and "pressed" or "unpressed"
  )

  -- Hide Menu Button

  Display.button(
    Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.x,
    Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.y,
    Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.x + Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.width,
    Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.y + Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON.height,
    "HIDE MENU",
    Config.Settings.EDIT_PANEL.HIDE_MENU_BUTTON,
    "unpressed"
  )


end
