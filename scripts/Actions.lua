Actions = {
  Items = {
    start_fade_in = {},
    start_fade_out = {}
  }
}

Actions.Items.start_fade_in = {
  timer = 0,
  active = false,
  start = function()
    Actions.Items.start_fade_in.timer = 0
  end,
  execute = function()
    if not Actions.Items.start_fade_in.active then return end
    Actions.Items.start_fade_in.timer = Actions.Items.start_fade_in.timer + 1
  end,
  draw = function()
    if not Actions.Items.start_fade_in.active then return end
    local color = "#000000" .. bit.tohex(math.min(255, Actions.Items.start_fade_in.timer * 4), 2)
    gui.box(0, -Config.Settings.SCREEN_SIZE.height, Config.Settings.SCREEN_SIZE.width, 0, color, color)
  end
}

Actions.Items.start_fade_out = {
  timer = 0,
  active = false,
  start = function()
    Actions.Items.start_fade_out.timer = 0
  end,
  execute = function()
    if not Actions.Items.start_fade_out.active then return end
    Actions.Items.start_fade_out.timer = Actions.Items.start_fade_out.timer + 1
  end,
  draw = function()
    if not Actions.Items.start_fade_out.active then return end
    local color = "#000000" .. bit.tohex(math.max(0, 255 - Actions.Items.start_fade_out.timer * 4), 2)
    gui.box(0, -Config.Settings.SCREEN_SIZE.height, Config.Settings.SCREEN_SIZE.width, 0, color, color)
  end
}
