Hacks = {
  functions = {

  },
  runAll = function(pointer)
    for name, func in pairs(Hacks.functions) do
      if type(func) == "function" then
        func(pointer)
      end
    end
  end
}

function Hacks.functions.aspectRatio(pointer)
  base_ratio = 5461
  local aspect_ratio = Config.Settings.HACKS.aspect_ratio

  if aspect_ratio == nil or aspect_ratio == "original" or aspect_ratio == "native" or aspect_ratio == "4:3" then
    Memory.writeVariable(Memory.variable.aspect_ratio, base_ratio)
    Memory.writeVariable(Memory.variable.hud_aspect_ratio, 1794)
    return
  elseif aspect_ratio == "wide" or aspect_ratio == "widescreen" or aspect_ratio == "16:9" then
    Memory.writeVariable(Memory.variable.aspect_ratio, 0x1C71)
    Memory.writeVariable(Memory.variable.hud_aspect_ratio, 2730)
    return
  end

  if aspect_ratio == string.match(aspect_ratio, '%d+:%d+') then
    ratio = {}
    for k in string.gmatch(aspect_ratio, '%d+') do
      table.insert(ratio, tonumber(k))
    end
    if ratio[2] == 0 then
      Memory.writeVariable(Memory.variable.aspect_ratio, base_ratio)
    else
      new_ratio = math.floor(base_ratio * 3 * ratio[1] / 4 / ratio[2])
      Memory.writeVariable(Memory.variable.aspect_ratio, new_ratio)
    end
  else
    Memory.writeVariable(Memory.variable.aspect_ratio, base_ratio)
  end

end

function Hacks.functions.cc(pointer)
  if Config.Settings.HACKS.cc == "50cc" then
    Memory.writeVariable(Memory.variable.cc, 0)
  elseif Config.Settings.HACKS.cc == "100cc" then
    Memory.writeVariable(Memory.variable.cc, 1)
  elseif Config.Settings.HACKS.cc == "150cc" then
    Memory.writeVariable(Memory.variable.cc, 2)
  elseif Config.Settings.HACKS.cc == "300cc" then
    if pointer[2] ~= 0 then
      memory.writedword(pointer[2] + 0xD4, 0x2000)
      memory.writedword(pointer[2] + 0xD8, 0x2000)
      memory.writedword(pointer[2] + 0xDC, 0x2000)
    end
  end

end

function Hacks.functions.force_finish_race(pointer)
  if Config.Settings.HACKS.force_finish_race and pointer[1] ~= 0 then
    memory.writeword(pointer[1] + 14, 8)
    memory.writebyte(pointer[1] + 20, 1)
  end
end

function Hacks.functions.ghost_flickering(pointer)
  if pointer[2] ~= 0 then
    if Config.Settings.HACKS.ghost_flickering == "no_flickering" then
      memory.writebyte(pointer[2] + 0x92C, 1)
    end
  end
end

function Hacks.functions.invisible_ghost(pointer)
  if pointer[2] ~= 0 then
    if Config.Settings.HACKS.invisible_ghost then
      memory.writeword(pointer[2] + 0x92C, 0xffff)
    end
  end
end

function Hacks.functions.liveGhost(pointer)
  Memory.writeVariable(Memory.variable.live_ghost, Config.Settings.HACKS.live_ghost and 1 or 0)
end

function Hacks.functions.music(pointer)
  music_value = 0x7f
  if not Config.Settings.HACKS.music then music_value = 0 end
  Memory.writeVariable(Memory.variable.music1, music_value)
  Memory.writeVariable(Memory.variable.music2, music_value)
end

function Hacks.functions.replay_camera_hack(pointer)
  Memory.writeVariable(Memory.variable.replay_camera, Config.Settings.HACKS.replay_camera_hack and 0 or 1)
end

function Hacks.functions.camera_view(pointer)
  local camera_pointer = Memory.readVariable(Memory.variable.camera_pointer)
  if pointer[2] ~= 0 then

    if Config.Settings.HACKS.camera_view == '1st_person' then
      if camera_pointer ~= 0 then memory.writedword(camera_pointer + 0xE8, 0x000005C0) end
      memory.writedword(pointer[2] + 0x408, 0x0000FFFF)
      memory.writedword(pointer[2] + 0xBC, 0x00000000)
      memory.writedword(pointer[2] + 0xC0, 0x00000000)
      memory.writedword(pointer[2] + 0xC4, 0x00000000)
    else
      if camera_pointer ~= 0 then memory.writedword(camera_pointer + 0xE8, 0x00000FFC) end
      memory.writedword(pointer[2] + 0x408, 0x00000000)
      memory.writedword(pointer[2] + 0xBC, 0x00001000)
      memory.writedword(pointer[2] + 0xC0, 0x00001000)
      memory.writedword(pointer[2] + 0xC4, 0x00001000)
    end

    if Config.Settings.HACKS.camera_view == 'aerial' then
      if camera_pointer ~= 0 then
        memory.writedword(camera_pointer + 0xAC, 0x00500000)
        memory.writedword(camera_pointer + 0xE8, 0x0000B000)
      end
    elseif Config.Settings.HACKS.camera_view == 'zoom_out' then
      if camera_pointer ~= 0 then
        memory.writedword(camera_pointer + 0xAC, 0x00020000)
        memory.writedword(camera_pointer + 0xE8, 0x00002000)
      end
    end
  end
end

function Hacks.functions.unlock_everything(pointer)
  if Config.Settings.HACKS.unlock_everything then
    Memory.writeVariable(Memory.variable.unlock_everything, 0x7FFFFFF)
  end
end
