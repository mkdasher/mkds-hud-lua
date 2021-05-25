CustomHud = {
  Items = {
    boost = {},
    final_time = {},
    input_display = {},
    item_roulette = {},
    lap_counter = {},
    speedometer = {},
    timer = {}
  }
}

CustomHud.Items.input_display.draw = function(data)

  local fade = 0

  if Config.Settings.MISC.disable_idisplay_after_finish then
    if (Display.isHUDfinished(data)) then return end
    fade = data.fade
  end

  local x,y = Config.Settings.CUSTOM_HUD.input_display.position.x, Config.Settings.CUSTOM_HUD.input_display.position.y
  local colors = Config.Settings.INPUT_DISPLAY_COLORS
  local scale = Config.Settings.CUSTOM_HUD.input_display.scale

  local j = Input.getJoypad()

  if data ~= nil and Config.Settings.MISC.live_ghost and Config.Settings.MISC.live_ghost_display_inputs and data.finished_run == 0 then
    j = Input.getGhostInput(data.ghost_input)
  end


  local palette = {
       "#000000ff",
       "#ff0000ff",
       "#008000ff",
       "#ff8000ff",
       "#00ff00ff",
       "#ffff00ff",
       "#800080ff",
       "#808080ff",
       "#0000ffff",
       "#00ffffff",
       "#ff00ffff",
       "#ff80ffff",
       "#ffffffff"
  }

  local finalPalette = {
    colors['layout_border'],
    j['left'] and colors['button_pressed'] or colors['button_unpressed'],
    j['L'] and colors['button_pressed'] or colors['button_unpressed'],
    j['B'] and colors['button_pressed'] or colors['button_unpressed'],
    colors['background'],
    j['down'] and colors['button_pressed'] or colors['button_unpressed'],
    j['up'] and colors['button_pressed'] or colors['button_unpressed'],
    j['R'] and colors['button_pressed'] or colors['button_unpressed'],
    j['right'] and colors['button_pressed'] or colors['button_unpressed'],
    j['A'] and colors['button_pressed'] or colors['button_unpressed'],
    j['X'] and colors['button_pressed'] or colors['button_unpressed'],
    j['Y'] and colors['button_pressed'] or colors['button_unpressed'],
    colors['layout_fill']
  }

  Bitmap.printImageIndexed(x,y,"resources/input_display.bmp", palette, finalPalette, fade, scale)

end

CustomHud.Items.boost.draw = function(data)

    if (Display.isHUDfinished(data)) then return end

    local colors = Config.Settings.BOOST_COLORS
    local boost = data.boost
    local prb = data.prb
    local scale = Config.Settings.CUSTOM_HUD.boost.scale
    local x,y = Config.Settings.CUSTOM_HUD.boost.position.x, Config.Settings.CUSTOM_HUD.boost.position.y

    palette = {
         "#000000ff",
         "#00ff00ff"
    }

    local border = colors.empty_border
    if boost > 0 then
      border = (prb > 0) and colors.prb_border or colors.normal_border
    end
    local fill = (prb > 0) and colors.prb_fill or colors.normal_fill

    finalPalette = {
        border,
        colors.background
    }

    gui.box(x + 6*scale, y + 5*scale, x + 206*scale, y + 15*scale, Utils.setColorFade(colors.background_fill, data.fade), Utils.setColorFade(colors.background_fill, data.fade))

    if boost > 0 then
      gui.box(x + 6*scale, y + 5*scale, x + (boost * 2 + 6)*scale, y + 15*scale, Utils.setColorFade(fill, data.fade), Utils.setColorFade(fill, data.fade))
    end

    Bitmap.printImageIndexed(x,y,"resources/boost.bmp", palette, finalPalette, data.fade, scale)

end

CustomHud.Items.final_time.draw = function(data)

  if data.finished_run < 1 or data.time_lap < 140 then return end

  local position = Config.Settings.CUSTOM_HUD.final_time.position
  local scale = Config.Settings.CUSTOM_HUD.final_time.scale



  local x,y = position.x, position.y
  local bordercolor = "black"
  local fillcolor = "white"
  local fillcolor_best = "white"

  if data.time_lap % 16 < 4 then fillcolor_best = "white"
  elseif data.time_lap % 16 < 8 then fillcolor_best = "#ffc600ff"
  elseif data.time_lap % 16 < 12 then fillcolor_best = "#ff5a5aff"
  else fillcolor_best = "#ffc600ff"
  end

  local x_offset = 0
  local t_lap = 160 - data.time_lap
  if t_lap > 0 then x_offset = 135 * t_lap / 20 end

  if Config.Settings.MISC.show_time_label_on_final_time then MarioFont.drawTimeLabel({x = x+x_offset*scale, y = y}, bordercolor, fillcolor_best, data.fade, scale) end
  MarioFont.drawTimer({x = x+1+38*scale+x_offset*scale, y = y}, data.final_timer, bordercolor, fillcolor_best, data.fade, scale)

  for i=1,data.totallaps,1 do
    local x_offset = 0
    local t_lap = 160 + i*4 - data.time_lap
    if t_lap > 0 then x_offset = 135 * t_lap / 20 end

    if i == 1 then
      if Config.Settings.MISC.show_time_label_on_final_time then MarioFont.drawLapLabel({x = x-9*scale+x_offset*scale, y = y+24*scale}, bordercolor, fillcolor, data.fade, scale) end
    end
    if Config.Settings.MISC.show_time_label_on_final_time then MarioFont.drawChar(x+27*scale+ x_offset*scale, y+24*scale+16*(i-1)*scale, tostring(i), bordercolor, fillcolor, data.fade, scale) end
    MarioFont.drawTimer({x = x+1+38*scale+x_offset*scale, y = y+24*scale+16*(i-1)*scale}, data.lap_timer[i], bordercolor, fillcolor, data.fade, scale)
  end

end

CustomHud.Items.item_roulette.draw = function(data)

  if (Display.isHUDfinished(data)) then return end

  local x, y = Config.Settings.CUSTOM_HUD.item_roulette.position.x, Config.Settings.CUSTOM_HUD.item_roulette.position.y
  local scale = Config.Settings.CUSTOM_HUD.item_roulette.scale

  if data.shroom == 3 then Bitmap.printImage(x,y,"resources/item_shroom3.bmp", data.fade, scale)
  elseif data.shroom == 2 then Bitmap.printImage(x,y,"resources/item_shroom2.bmp", data.fade, scale)
  elseif data.shroom == 1 then Bitmap.printImage(x,y,"resources/item_shroom1.bmp", data.fade, scale)
  elseif data.shroom == 0 then Bitmap.printImage(x,y,"resources/item_shroom0.bmp", data.fade, scale)
  end

end

CustomHud.Items.lap_counter.draw = function(data)

  if (Display.isHUDfinished(data)) then return end

  local x, y = Config.Settings.CUSTOM_HUD.lap_counter.position.x, Config.Settings.CUSTOM_HUD.lap_counter.position.y
  local scale = Config.Settings.CUSTOM_HUD.lap_counter.scale

  if data.totallaps == 3 or data.totallaps == 5 then
    if data.lap > 1 and data.time_lap < 120 and data.time_lap % 12 > 7 and data.finished_run == 0 then
      Bitmap.printImage(x,y,"resources/lap_empty.bmp", data.fade, scale)
    else
      Bitmap.printImage(x,y,"resources/lap_" .. data.lap .. ".bmp", data.fade, scale)
    end
    Bitmap.printImage(x+(59 * scale),y+(3 * scale),"resources/lap_total" .. data.totallaps .. ".bmp", data.fade, scale)
  end

end

CustomHud.Items.speedometer.draw = function(data)

  if (Display.isHUDfinished(data)) then return end

  local NUMBERLENGTH = 6

  local x, y = Config.Settings.CUSTOM_HUD.speedometer.position.x, Config.Settings.CUSTOM_HUD.speedometer.position.y
  local scale = Config.Settings.CUSTOM_HUD.speedometer.scale

  local speed = string.format("%.2f" ,math.abs(data.real_speed / 360))

  if not Config.Settings.MISC.show_kmh_decimals then
    speed = math.floor(speed)
  end

  speed_str = (string.rep(" ", NUMBERLENGTH) .. tostring(speed)):sub(-NUMBERLENGTH,-1)

  MarioFont.drawString(Config.Settings.CUSTOM_HUD.speedometer.position, speed_str, "black", "white", data.fade, scale)

  if Config.Settings.MISC.show_slash_on_kmh then
    MarioFont.drawKmhSlashLabel({x = x + (MarioFont.NUMBER_SIZE * NUMBERLENGTH + 2) * scale, y = y}, "black", "white", data.fade, scale)
  else
    MarioFont.drawKmhLabel({x = x + (MarioFont.NUMBER_SIZE * NUMBERLENGTH + 2) * scale, y = y}, "black", "white", data.fade, scale)
  end

end

CustomHud.Items.timer.draw = function(data)

  if (Display.isHUDfinished(data)) then return end

  local position = Config.Settings.CUSTOM_HUD.timer.position
  local scale = Config.Settings.CUSTOM_HUD.timer.scale

  local bordercolor = "black"
  local fillcolor = "white"

  local timer_position = {x = position.x + 1 + 38 * scale, y = position.y}

  if data.lap > 1 and data.time_lap < 128 then
    if data.time_lap % 16 < 4 then fillcolor = "white"
    elseif data.time_lap % 16 < 8 then fillcolor = "#ffc600ff"
    elseif data.time_lap % 16 < 12 then fillcolor = "#ff5a5aff"
    else fillcolor = "#ffc600ff"
    end

    if Config.Settings.MISC.show_time_label_on_timer then MarioFont.drawLapLabel(position, bordercolor, fillcolor, data.fade, scale) end
    if data.finished_run == 1 then
      MarioFont.drawTimer(timer_position, data.lap_timer[data.lap], bordercolor, fillcolor, data.fade, scale)
    else
      MarioFont.drawTimer(timer_position, data.lap_timer[data.lap-1], bordercolor, fillcolor, data.fade, scale)
    end
  else
    if Config.Settings.MISC.show_time_label_on_timer then MarioFont.drawTimeLabel(position, bordercolor, fillcolor, data.fade, scale) end
    MarioFont.drawTimer(timer_position, data.current_timer, bordercolor, fillcolor, data.fade, scale)
  end

end
