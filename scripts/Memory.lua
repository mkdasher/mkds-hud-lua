Memory = {
  E = 0x50434d41, --AMCP
  U = 0x45434d41, --AMCE
  J = 0x4A434d41, --AMCJ
  version = 0
}

Memory.variable = {
  lap = {address = {0x217B87C, 0x217B85C, 0x217B8FC}, size = 1},
  totallaps = {address = {0x217B884, 0x217B864, 0x217B904}, size = 1},
  finished_run = {address = {0x217ACAC, 0x217AC8C, 0x217AD2C}, size = 1},

  fade = {address = {0x21755B0, 0x2175590, 0x2175630}, size = 2},

  aspect_ratio = {address = {0x20775D0, 0x20775D0, 0x2077710}, size = 4},
  hud_aspect_ratio = {address = {0x208A068, 0x208A068, 0x208A1A8}, size = 2},
  live_ghost = {address = {0x23CDD54, 0x23CDD54, 0x23CD394}, size = 4},
  ghost_input = {address = {0x2175686, 0x2175666, 0x2175706}, size = 2},

  music1 = {address = {0x217D9DC, 0x217D9BC, 0x217DA74}, size = 4},
  music2 = {address = {0x217DA00, 0x217D9E0, 0x217DA98}, size = 4},

  hud_lapcount = {address = {0x20BC244, 0x20BC244, 0x20BC384}, size = 1},
  hud_item = {address = {0x20BA6B8, 0x20BA6B8, 0x20BA7F8}, size = 1},
  hud_player = {address = {0x20B9E24, 0x20B9E24, 0x20B9F64}, size = 1},
  hud_timer = {address = {0x20BB654, 0x20BB654, 0x20BB794}, size = 1},
  hud_final_time = {address = {0x20D06E0, 0x20D06E0, 0x20D0820}, size = 1}

}

function Memory.setVersion()
    Memory.version = memory.readdword(0x023FFA8C)
end

function Memory.getPointers()
  if Memory.version == Memory.E then
      return {memory.readdword(0x021661B0), memory.readdword(0x0217AD18), memory.readdword(0x0217BC4C)}
  elseif Memory.version == Memory.U then
    return {memory.readdword(0x021661B0), memory.readdword(0x0217ACF8), memory.readdword(0x0217BC2C)}
  else --J
    return {memory.readdword(0x021662D0), memory.readdword(0x0217AD98), memory.readdword(0x0217BCCC)}
  end
end

function Memory.readVariable(variable)
  local addr = 0
  if Memory.version == Memory.E then addr = variable.address[1]
  elseif Memory.version == Memory.U then addr = variable.address[2]
  else addr = variable.address[3] -- J
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
  local addr = 0
  if Memory.version == Memory.E then addr = variable.address[1]
  elseif Memory.version == Memory.U then addr = variable.address[2]
  else addr = variable.address[3] -- J
  end

  if variable.size == 1 then
    return memory.writebyte(addr, value)
  elseif variable.size == 2 then
    return memory.writeword(addr, value)
  else -- 4
    return memory.writedword(addr, value)
  end
end
