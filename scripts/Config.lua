-- Default config variables

Config = {
  FILENAME = "config.json",
  EDIT_CUSTOM_HUD = {
    enabled = false,
    block = nil,
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
    input_display = {visible = true, position = {x = 8, y = -110}, scale = 1},
    boost = {visible = true, position = {x = 418, y = -27}, scale = 1},
    timer = {visible = true, position = {x = 388, y = -346}, scale = 2},
    final_time = {visible = true, position = {x = 380, y = -338}, scale = 2}
  },
  CUSTOM_HUD_EXTRA = {
    social_media = {visible = true, position = {x = 422, y = -163}, scale = 1}
  },
  MISC = {
    disable_input_display_after_finish_race = true,
    show_kmh_decimals = false,
    show_slash_on_kmh = true,
    show_time_label_on_timer = true,
    show_time_label_on_final_time = true,
    green_screen_touchscreen = false
  },
  HACKS = {
    aspect_ratio = 'widescreen',
    live_ghost = false,
    camera_view = 'off',
    music = true,
    cc = 'off',
    force_finish_race = false,
    ghost_flickering = "off",
    unlock_everything = false,
    replay_camera_hack = false
  },
  HACKS_EXTRA_BUTTONS = {
    display_inputs = true
  },
  INPUT_DISPLAY_COLORS = {
    button_pressed = 0xffffffff,
    button_unpressed = 0x00000030,
    layout_fill = 0xd8d8d8ff,
    layout_border = 0x000000ff,
    background = 0x00ff00ff
  },
  BOOST_COLORS = {
    empty_border = 0x222222ff,
    normal_border = 0xc8a000ff,
    normal_fill = 0xffff00ff,
    prb_border = 0xff8000ff,
    prb_fill = 0xff0000ff,
    background = 0x00ff00ff,
    background_fill = 0x00000020
  },
  SOCIAL_MEDIA = {
    items = {
    }
  },
  SCREEN_SIZE = {
    width = 640, height = 360
  }
}

Config.SOCIAL_ICONS = {
  "discord",
  "instagram",
  "patreon",
  "tiktok",
  "twitch",
  "twitter",
  "x",
  "youtube"
}

Config.Edit_Panel = {
  TAB_MENU = {
    x = 10, y = 30, width = 90, box_width = 370, height = 240, item_height = 25,
    selected_tab = 1,
    TABS = {
      'HUD_ELEMENTS',
      'HUD_SETTINGS',
      'HUD_SOCIALS',
      'HACKS'
    }
  },
  CUSTOM_HUD = {x = 110, y = 60, width = 175, item_height = 25},
  ORIGINAL_HUD = {x = 285, y = 60, width = 175, item_height = 25},
  MISC = {x = 110, y = 40, width = 350, item_height = 25},
  CUSTOM_HUD_EDIT_BUTTON = {x = 125, y = 325, width = 100, height = 25},
  SAVE_CONFIG_BUTTON = {x = 10, y = 290, width = 100, height = 25},
  HIDE_MENU_BUTTON = {x = 10, y = 325, width = 100, height = 25},
  ACTIONS = {x = 245, y = 300, width = 100, item_height = 25},
  RAM_DATA = {x = 480, y = 15},
  HUD_SOCIALS = {
    x = 100, y = 30, width = 370,
    max_items = 4,
    edit_mode = 'none', --text, icon, none
    selected_item = 1,
    edit_icon = {x = 65, y = 45, gap = 15, size = 40, items_per_row = 5},
    preview = {x = 30, y = 45, gap = 5, size = 40},
    enabled_button = {x = 5, y = 5, width = 50, height = 20},
    add_element_button = {x = 140, y = 212, width = 90, height = 20},
    cancel_button = {x = 140, y = 212, width = 90, height = 20}
  },
  HACKS = {
    x = 100, y = 40, width = 370, item_height = 20, item_gap = 5, header_width = 125,
    default_item_width = 100,
    items_per_page = 8,
    selected_page = 1,
    ITEMS = {
      music = {
      },
      live_ghost = {
        item_width = 60,
        extra_buttons = {
          display_inputs = {x = 360, width = 95}
        }
      },
      aspect_ratio = {
        options = {"native", "widescreen", "21:9"},
        item_width = 72
      },
      cc = {
        options = {"50cc", "100cc", "150cc", "300cc", "off"},
        item_width = 45
      },
      force_finish_race = {
      },
      ghost_flickering = {
        options = {"no_flickering", "off"}
      },
      unlock_everything = {
      },
      replay_camera_hack = {
      },
      camera_view = {
        item_width = 60,
        options = {"1st_person", "aerial", "zoom_out", "off"}
      }
    }
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
