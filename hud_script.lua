-- Script Made by MKDasher --

dofile "scripts/json.lua"
dofile "scripts/Utils.lua"
dofile "scripts/Memory.lua"
dofile "scripts/Input.lua"
dofile "scripts/Config.lua"
dofile "scripts/Bitmap.lua"
dofile "scripts/Program.lua"
dofile "scripts/Display.lua"
dofile "scripts/CustomHud.lua"
dofile "scripts/MarioFont.lua"

local dataBuffer = {nil,nil,nil}
local pointer = {0,0,0}

Config.load()
Bitmap.loadAllBitmaps()

function fn()
  Memory.setVersion()
  pointer = Memory.getPointers()
  dataBuffer = Program.main(pointer, dataBuffer)
end

function fm()
  Input.update()
  if Config.EDIT_CUSTOM_HUD.enabled then gui.box(0,-Config.Settings.SCREEN_SIZE.height,Config.Settings.SCREEN_SIZE.width,0,"#00000044", "#00000044") end
  local showHUD = pointer[2] ~= 0 and dataBuffer[1] ~= nil
  Display.displayHUD(dataBuffer, showHUD)
  Display.displayEditMenu(Config.Settings.SCREEN_SIZE)
  
end

emu.registerafter(fn)
gui.register(fm)
