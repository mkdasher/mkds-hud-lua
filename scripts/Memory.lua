Memory = {
  E = 0x50434d41, --AMCP
  U = 0x45434d41, --AMCE
  J = 0x4A434d41, --AMCJ
  K = 0x4B434D41, -- AMCK
  version = 0
}

Memory.VPOINTERS = { -- Version POINTERS
  LIVE_GHOST = 0x23c5640,
  MUSIC = 0x23C4920,
  MAIN = 0x2000B54,
  SCREEN = 0x2031458
}

Memory.variable = {
  lap = {pointer = Memory.VPOINTERS.MAIN, offset = 0xC53C, size = 1},
  totallaps = {pointer = Memory.VPOINTERS.MAIN, offset = 0xC544, size = 1},
  finished_run = {pointer = Memory.VPOINTERS.MAIN, offset = 0xB96C, size = 1},
  fade = {pointer = Memory.VPOINTERS.MAIN, offset = 0x6270, size = 2},
  ghost_input = {pointer = Memory.VPOINTERS.MAIN, offset = 0x6346, size = 2},

  live_ghost = {pointer = Memory.VPOINTERS.LIVE_GHOST, offset = 0x23C9B74, size = 4},

  music1 = {pointer = Memory.VPOINTERS.MUSIC, offset = 0x5B0, size = 4},
  music2 = {pointer = Memory.VPOINTERS.MUSIC, offset = 0x5D4, size = 4},

  aspect_ratio = {pointer = Memory.VPOINTERS.SCREEN, offset = 0x20775D0 - 0x2c0, K = 0x20762C8, size = 4},
  hud_aspect_ratio = {pointer = Memory.VPOINTERS.SCREEN, offset = 0x208A068 - 0x2c0, K = 0x20884C8, size = 2},
  hud_lapcount = {pointer = Memory.VPOINTERS.SCREEN, offset = 0x20BC244 - 0x2c0, K = 0x20B9130, size = 1},
  hud_item = {pointer = Memory.VPOINTERS.SCREEN, offset = 0x20BA6B8 - 0x2c0, K = 0x20B7604, size = 1},
  hud_player = {pointer = Memory.VPOINTERS.SCREEN, offset = 0x20B9E24 - 0x2c0, K = 0x20B6DC4, size = 1},
  hud_timer = {pointer = Memory.VPOINTERS.SCREEN, offset = 0x20BB654 - 0x2c0, K = 0x20B8584, size = 1},
  hud_final_time = {pointer = Memory.VPOINTERS.SCREEN, offset = 0x20D06E0 - 0x2c0, K = 0x20CD07C, size = 1}
}

function Memory.setVersion()
    Memory.version = memory.readdword(0x023FFA8C)
end

function Memory.getPointers()
  if Memory.version == Memory.K then return {
    memory.readdword(0x216F9A0),
    memory.readdword(memory.readdword(Memory.VPOINTERS.MAIN) + 0xB9D8),
    memory.readdword(memory.readdword(Memory.VPOINTERS.MAIN) + 0xC90C)
  } else
  return {
    memory.readdword(memory.readdword(Memory.VPOINTERS.MAIN) + 0x62DC),
    memory.readdword(memory.readdword(Memory.VPOINTERS.MAIN) + 0xB9D8),
    memory.readdword(memory.readdword(Memory.VPOINTERS.MAIN) + 0xC90C)
  }
  end
end

function Memory.readVariable(variable)

  if Memory.version == 0 then return 0 end

  local addr = 0
  if Memory.version == Memory.K and variable.pointer == Memory.VPOINTERS.SCREEN then addr = variable.K
  else addr = memory.readdword(variable.pointer) + variable.offset
  end

  if variable.size == 1 then
    return memory.readbytesigned(addr)
  elseif variable.size == 2 then
    return memory.readwordsigned(addr)
  else -- 4
    return memory.readdword(addr)
  end
end

function Memory.writeVariable(variable, value)

  if Memory.version == 0 then return end

  local addr = 0
  if Memory.version == Memory.K and variable.pointer == Memory.VPOINTERS.SCREEN then addr = variable.K
  else addr = memory.readdword(variable.pointer) + variable.offset
  end

  if variable.size == 1 then
    return memory.writebyte(addr, value)
  elseif variable.size == 2 then
    return memory.writeword(addr, value)
  else -- 4
    return memory.writedword(addr, value)
  end
end
