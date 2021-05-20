MarioFont = {
  NUMBER_SIZE = 9
}

function MarioFont.getKmhPixels()
  return {
    "000000000000000000000000000",
    "000000000000000000000000000",
    "111100000000000000011110000",
    "122100000000000000012210000",
    "122100000000000000012210000",
    "122111111111111111012211110",
    "122112211222222221112222211",
    "122122111222222222112222221",
    "122221101221121122112211221",
    "122222111221121122112211221",
    "122122211221121122112211221",
    "122112211221121122112211221",
    "111111111111111111111111111"
  }
end

function MarioFont.getKmhSlashPixels()
  return {
    "000000000000000000000000000000000",
    "000000000000000000000000000000000",
    "111100000000000000000111111110000",
    "122100000000000000000122112210000",
    "122100000000000000000122112210000",
    "122111111111111111001121112211110",
    "122112211222222221101221012222211",
    "122122111222222222101221012222221",
    "122221101221121122101221012211221",
    "122222111221121122111211012211221",
    "122122211221121122112210012211221",
    "122112211221121122112210012211221",
    "111111111111111111111110011111111"
  }
end

function MarioFont.getTimePixels()
  return {
    "00000000000000000000000000000000000",
    "11111111110000001111011110000000000",
    "12222222211111111221012210111111111",
    "12222222211222211221012210122222221",
    "12222222211222211221112210122222221",
    "11112211111222211222122210122111111",
    "00012210001222111222122210122222210",
    "00012210001222111222222211122222210",
    "00112210001221112222222221122111111",
    "00122210001221112212221221122222221",
    "00122210001221012211211221122222221",
    "00122210001221012211111221122222221",
    "00111110001111011110001111111111111"
  }
end

function MarioFont.getLapPixels()
  return {
    "00000000000000000000000000000000000",
    "00000001111100000000000001111111100",
    "00000001222100000011111001222222110",
    "00000011222100000012221101222222211",
    "00000012221100000112222111222112221",
    "00000012221000000122222211222111221",
    "00000112211000001122112211222112221",
    "00000122210000001221112211222222211",
    "00000122211111111221112211222222110",
    "00001122222222112222222211222111100",
    "00001222222222112222222211222100000",
    "00001222222222112221122211222100000",
    "00001111111111111111111111111100000"
  }
end

function MarioFont.getColons()
  return {
    "00000000",
    "00000000",
    "00111100",
    "00122100",
    "00122100",
    "00111100",
    "00000000",
    "00111100",
    "00122100",
    "00122100",
    "00111100",
    "00000000",
    "00000000"
  }
end

function MarioFont.getDot()
  return {
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00111100",
    "00122100",
    "00122100",
    "00111100"
  }
end

function MarioFont.getNumberPixels(i)
  numbers = {
    {
      "00111100",
      "01122110",
      "11222211",
      "12222221",
      "12211221",
      "12211221",
      "12211221",
      "12211221",
      "12222221",
      "12222221",
      "11222211",
      "01122110",
      "00111100"
    },
    {
      "00011110",
      "00112210",
      "01122210",
      "01222210",
      "01222210",
      "01112210",
      "00012210",
      "00012210",
      "00012210",
      "00012210",
      "00012210",
      "00012210",
      "00011110"
    },
    {
      "11111110",
      "12222211",
      "12222221",
      "12222221",
      "11111221",
      "00112221",
      "01122211",
      "11222110",
      "12221111",
      "12222221",
      "12222221",
      "11222221",
      "01111111"
    },
    {
      "11111110",
      "12222211",
      "12222221",
      "12222221",
      "11111221",
      "00122221",
      "00122211",
      "00111221",
      "11111221",
      "12222221",
      "12222211",
      "12222110",
      "11111100"
    },
    {
      "11111000",
      "12221000",
      "12221000",
      "12221000",
      "12211110",
      "12212210",
      "12212210",
      "12212211",
      "12222221",
      "12222221",
      "11122111",
      "00122100",
      "00111100",
    },
    {
      "01111111",
      "01222221",
      "01222221",
      "11222221",
      "12211111",
      "12222211",
      "12222221",
      "11111221",
      "11111221",
      "12222221",
      "12222211",
      "12222110",
      "11111100",
    },
    {
      "00111110",
      "00122210",
      "01122110",
      "01222100",
      "01221110",
      "11222211",
      "12222221",
      "12211221",
      "12211221",
      "12222221",
      "11222211",
      "01122110",
      "00111100"
    },
    {
      "11111111",
      "12222221",
      "12222221",
      "12211221",
      "12211221",
      "11111221",
      "00012221",
      "00012211",
      "00012210",
      "00112210",
      "00122210",
      "00122210",
      "00111110",
    },
    {
      "00111110",
      "01122211",
      "11222221",
      "12211221",
      "12211221",
      "11222211",
      "01122110",
      "11222211",
      "12211221",
      "12211221",
      "11222211",
      "01122110",
      "00111100",
    },
    {
      "00111110",
      "01122211",
      "11222221",
      "12211221",
      "12211221",
      "12222221",
      "11222221",
      "01112211",
      "00112210",
      "00122210",
      "01122110",
      "01222100",
      "01111100",
    }
  }
  return numbers[i+1]
end

function MarioFont.drawPixel(x,y,color,fade,scale)

  local new_color = Utils.setColorFade(color, fade)

  if scale < 1 then
    gui.drawpixel(x, y, new_color)
  else
    for i = 1, math.ceil(scale), 1 do
      for j = 1, math.ceil(scale), 1 do
        gui.drawpixel(x + i, y + j, new_color)
      end
    end
  end
end

function MarioFont.drawChar(x,y, n, bordercolor, fillcolor, fade, scale)
  pixels = {}
  if n == " " then return end
  if n == ":" then
    pixels = MarioFont.getColons()
  elseif n == "." then
    pixels = MarioFont.getDot()
  elseif tonumber(n) ~= nil then
    n = tonumber(n)
    pixels = MarioFont.getNumberPixels(n)
  else
    return
  end
  for i=0,7,1 do
    for j=0,12,1 do
      pixelcolor = pixels[j+1]:sub(i+1,i+1)
      if pixelcolor == "1" then MarioFont.drawPixel(x+i*scale,y+j*scale, bordercolor, fade, scale) end
      if pixelcolor == "2" then MarioFont.drawPixel(x+i*scale,y+j*scale, fillcolor, fade, scale) end
    end
  end
end


function MarioFont.drawString(position, n, bordercolor, fillcolor, fade, scale)
  local x,y = position.x, position.y

  for i=1,n:len(),1 do
    MarioFont.drawChar(x + MarioFont.NUMBER_SIZE*(i-1)*scale, y, n:sub(i,i), bordercolor, fillcolor, fade, scale)
  end
end

function MarioFont.drawTimer(position, timer, bordercolor, fillcolor, fade, scale)
  local x,y = position.x, position.y

  for i=1,timer:len(),1 do
    MarioFont.drawChar(x + MarioFont.NUMBER_SIZE*(i-1)*scale, y, timer:sub(i,i), bordercolor, fillcolor, fade, scale)
  end
end

function MarioFont.drawTimeLabel(position, bordercolor, fillcolor, fade, scale)
  local x,y = position.x, position.y

  pixels = MarioFont.getTimePixels()
  for i=0,35,1 do
    for j=0,12,1 do
      pixelcolor = pixels[j+1]:sub(i+1,i+1)
      if pixelcolor == "1" then MarioFont.drawPixel(x+i*scale,y+j*scale, bordercolor, fade, scale) end
      if pixelcolor == "2" then MarioFont.drawPixel(x+i*scale,y+j*scale, fillcolor, fade, scale) end
    end
  end
end

function MarioFont.drawLapLabel(position, bordercolor, fillcolor, fade, scale)
  local x,y = position.x, position.y

  local pixels = MarioFont.getLapPixels()
  for i=0,35,1 do
    for j=0,12,1 do
      local pixelcolor = pixels[j+1]:sub(i+1,i+1)
      if pixelcolor == "1" then MarioFont.drawPixel(x+i*scale,y+j*scale, bordercolor, fade, scale) end
      if pixelcolor == "2" then MarioFont.drawPixel(x+i*scale,y+j*scale, fillcolor, fade, scale) end
    end
  end
end

function MarioFont.drawKmhLabel(position, bordercolor, fillcolor, fade, scale)
  local x,y = position.x, position.y

  local pixels = MarioFont.getKmhPixels()
  for i=0,26,1 do
    for j=0,12,1 do
      local pixelcolor = pixels[j+1]:sub(i+1,i+1)
      if pixelcolor == "1" then MarioFont.drawPixel(x+i*scale,y+j*scale, bordercolor, fade, scale) end
      if pixelcolor == "2" then MarioFont.drawPixel(x+i*scale,y+j*scale, fillcolor, fade, scale) end
    end
  end
end

function MarioFont.drawKmhSlashLabel(position, bordercolor, fillcolor, fade, scale)
  local x,y = position.x, position.y

  local pixels = MarioFont.getKmhSlashPixels()
  for i=0,32,1 do
    for j=0,12,1 do
      local pixelcolor = pixels[j+1]:sub(i+1,i+1)
      if pixelcolor == "1" then MarioFont.drawPixel(x+i*scale,y+j*scale, bordercolor, fade, scale) end
      if pixelcolor == "2" then MarioFont.drawPixel(x+i*scale,y+j*scale, fillcolor, fade, scale) end
    end
  end
end
