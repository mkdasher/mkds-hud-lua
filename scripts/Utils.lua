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
  if color == "black" then color = "#000000ff"
  elseif color == "white" then color = "#ffffffff"
  end

  if color:sub(1,1) ~= "#" then return color end

  local rgb = {tonumber(color:sub(2,3),16), tonumber(color:sub(4,5),16), tonumber(color:sub(6,7),16)}
  local real_fade = (16 + fade) * 16

  local r = math.floor(rgb[1] * real_fade / 256)
  local g = math.floor(rgb[2] * real_fade / 256)
  local b = math.floor(rgb[3] * real_fade / 256)

  return "#" .. bit.tohex(r,2) .. bit.tohex(g,2) .. bit.tohex(b,2) .. color:sub(-2,-1)
end
