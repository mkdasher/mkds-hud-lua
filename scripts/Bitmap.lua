Bitmap = {
  buffer = {}
}

function Bitmap.bytes_to_int(b1, b2, b3, b4)
  if not b4 then error("need four bytes to convert to int",2) end
  local n = b1 + b2*256 + b3*65536 + b4*16777216
  n = (n > 2147483647) and (n - 4294967296) or n
  return n
end

function Bitmap.bytes_to_color(b1, b2, b3)
  return "#" .. bit.tohex(b3,2) .. bit.tohex(b2,2) .. bit.tohex(b1,2) .. "ff"
end

function Bitmap.readPixel(buffer)
  bytes = buffer:read(3)
  return Bitmap.bytes_to_color(bytes:byte(1,3))
end

function Bitmap.readInt(buffer)
  bytes = buffer:read(4)
  return Bitmap.bytes_to_int(bytes:byte(1,4))
end

function Bitmap.drawPixel(x,y, color, fade, scale)

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

function Bitmap.readImage(filename)
  image = {}

  if Bitmap.buffer[filename] ~= nil then return end

  local buffer, err = io.open(filename, "rb")

  if buffer then

      buffer:read(10)
      initData = Bitmap.readInt(buffer)
      headerSize = Bitmap.readInt(buffer)
      image.width = Bitmap.readInt(buffer)
      image.height = Bitmap.readInt(buffer)
      buffer:seek('set', initData)
      for i=1,image.height,1 do
        for j=1,image.width,1 do
          if i == 1 then image[j] = {} end
          image[j][image.height-i+1] = Bitmap.readPixel(buffer)
        end
        if image.width * 3  % 4 > 0 then
          buffer:read(4 - (image.width * 3) % 4)
        end
      end

      buffer:close()
      Bitmap.buffer[filename] = image

  else
	print(filename .. " failed to load!")
  end
  
  
end

function Bitmap.switchColor(color, palette, finalPalette)
  for i = 1, #palette, 1 do
    if palette[i] == color then
      return finalPalette[i]
    end
  end
  return color
end

function Bitmap.printImageIndexed(x,y,filename,palette,finalPalette,fade,scale)

  Bitmap.readImage(filename)
  local image = Bitmap.buffer[filename]

  for i=0,image.height-1,1 do
    for j=0,image.width-1,1 do
      color = image[j+1][i+1]
      color = Bitmap.switchColor(color, palette, finalPalette)
      if color ~= "#00ff00ff" then
        Bitmap.drawPixel(x + j*scale, y + i*scale, color, fade, scale)
      end
    end
  end
end

function Bitmap.printImage(x,y,filename,fade,scale)
  Bitmap.readImage(filename)

  local image = Bitmap.buffer[filename]

  if image == nil then return end

  for i=0,image.height-1,1 do
    for j=0,image.width-1,1 do
      color = image[j+1][i+1]
      if color ~= "#001863ff" and color ~= "#001063ff" then
        Bitmap.drawPixel(x + j*scale, y + i*scale, color, fade, scale)
      end
    end
  end
end

function Bitmap.loadAllBitmaps()
	Bitmap.readImage('resources/boost.bmp')
	Bitmap.readImage('resources/input_display.bmp')
	Bitmap.readImage('resources/item_shroom0.bmp')
	Bitmap.readImage('resources/item_shroom1.bmp')
	Bitmap.readImage('resources/item_shroom2.bmp')
	Bitmap.readImage('resources/item_shroom3.bmp')
	Bitmap.readImage('resources/lap_1.bmp')
	Bitmap.readImage('resources/lap_2.bmp')
	Bitmap.readImage('resources/lap_3.bmp')
	Bitmap.readImage('resources/lap_4.bmp')
	Bitmap.readImage('resources/lap_5.bmp')
	Bitmap.readImage('resources/lap_empty.bmp')
	Bitmap.readImage('resources/lap_total3.bmp')
	Bitmap.readImage('resources/lap_total5.bmp')
	print('Finished reading all resources!')
end
