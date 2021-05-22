-- Default config variables

Config = {
  FILENAME = "config.json",
  EDIT_CUSTOM_HUD = {
    enabled = false,
    item = nil,
    click_offset = {x = 0, y = 0}
  },
  SAVE_CONFIG = {
    pressed = false
  },
  EDIT_MENU = {
    enabled = true
  }
}

Config.Settings = {
  ORIGINAL_HUD = {
    lap_counter = false,
    item_roulette = false,
    player_position = false,
    timer = false,
    final_time = false
  },
  CUSTOM_HUD = {
    item_roulette = {visible = true, position = {x = 13, y = -352}, scale = 2},
    lap_counter = {visible = true, position = {x = 486, y = -308}, scale = 2},
    speedometer = {visible = true, position = {x = 450, y = -60}, scale = 2},
    input_display = {visible = false, position = {x = 8, y = -110}, scale = 1},
    boost = {visible = true, position = {x = 418, y = -27}, scale = 1},
    timer = {visible = true, position = {x = 388, y = -346}, scale = 2},
    final_time = {visible = true, position = {x = 380, y = -338}, scale = 2}
  },
  MISC = {
    disable_music = false,
    live_ghost = false,
    live_ghost_display_inputs = false,
    widescreen = true,
    disable_idisplay_after_finish = false,
    show_kmh_decimals = true,
    show_slash_on_kmh = true,
    show_time_label_on_timer = true,
    show_time_label_on_final_time = true
  },
  INPUT_DISPLAY_COLORS = {
    button_pressed = "#ffffffff",
    button_unpressed = "#00000030",
    layout_fill = "#d8d8d8ff",
    layout_border = "#000000ff",
    background = "#00ff00ff"
  },
  BOOST_COLORS = {
    empty_border = "#222222ff",
    normal_border = "#c8a000ff",
    normal_fill = "#ffff00ff",
    prb_border = "#ff8000ff",
    prb_fill = "#ff0000ff",
    background = "#00ff00ff",
    background_fill = "#00000020"
  },
  EDIT_PANEL = {
    CUSTOM_HUD = {x = 10, y = 40, width = 100, item_height = 25},
    ORIGINAL_HUD = {x = 125, y = 40, width = 100, item_height = 25},
    MISC = {x = 240, y = 40, width = 180, item_height = 25},
    CUSTOM_HUD_EDIT_BUTTON = {x = 10, y = 230, width = 100, height = 25},
    SAVE_CONFIG_BUTTON = {x = 10, y = 290, width = 100, height = 25},
    HIDE_MENU_BUTTON = {x = 10, y = 325, width = 100, height = 25},
    ACTIONS = {x = 125, y = 215, width = 100, item_height = 25},
    RAM_DATA = {x = 440, y = 24}
  },
  SCREEN_SIZE = {
    width = 640, height = 360
  }
}

function Config.loadJSON(filename)
  local contents = ""
  local myTable = {}
  local file = io.open(filename, "r" )
  if file then
      --print("trying to read ", filename)
      -- read all contents of file into a string
      local contents = file:read( "*a" )
      myTable = json.parse(contents);
      io.close(file)
      --print("Loaded file")
      return myTable
  end
  print(filename, "file not found")
  return nil
end

function Config.load()
  jsonfile = Config.loadJSON(Config.FILENAME)

  -- Load into Config.Settings, and keeping default variables if they don't appear on config.json
  if jsonfile ~= nil then
    for k, v in pairs(jsonfile) do
      Config.Settings[k] = v
    end
  end
end

function Config.save()
  print('Saved configuration')

  local contents = json.stringify(Config.Settings, false)
  local file = io.open(Config.FILENAME, "w" )

  if file then
    print('writing')
    file:write(contents)
    io.close(file)
  end
end
