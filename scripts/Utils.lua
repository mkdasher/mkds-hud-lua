Utils = {

}

function Utils.getTableSize(t)
  local i = 0
  for k, v in pairs(t) do
    i = i + 1
  end
  return i
end

function Utils.getTableKeys(t)
  local keys={}
  local i = 0
  for k, v in pairs(t) do
    i = i + 1
    keys[i] = k
  end
  return keys
end

function Utils.getTableSizeAndKeys(t)
  local keys={}
  local i = 0
  for k, v in pairs(t) do
    i = i + 1
    keys[i] = k
  end
  table.sort(keys)
  return i,keys
end

function Utils.getCenteredText(t, size)
  if t:len() > size then return t end
  spaces = math.ceil((size - t:len()) / 2)
  return (string.rep(" ", spaces) .. t .. string.rep(" ", spaces))
end

function Utils.setColorFade(color, fade)
  if color == "black" then color = 0xff
  elseif color == "white" then color = 0xffffffff
  end

  if type(color) == "string" then return end

  local real_fade = (16 + fade) * 16
  local r = bit.rshift(color, 24)
  local g = bit.rshift(color, 16) % 256
  local b = bit.rshift(color, 8) % 256
  local a = color % 256
  r = math.floor(r * real_fade / 256)
  g = math.floor(g * real_fade / 256)
  b = math.floor(b * real_fade / 256)
  return r * 0x1000000 + g * 0x10000 + b * 0x100 + a
end
