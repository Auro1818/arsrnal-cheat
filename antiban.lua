local mt = getrawmetatable(game)
setreadonly(mt, false)
local old_nc = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
  local method = getnamecallmethod()
  if method == "Kick" or tostring(self) == "Kick" then
    return warn("[ANTI-BAN] Kick blocked")
  end
  if method == "FireServer" or method == "InvokeServer" then
    -- block controled remote invoking?
    -- or fake extra params
  end
  return old_nc(self, ...)
end)

local Players = game:GetService("Players")
hookfunction(Players.LocalPlayer.Kick, function() return warn("[ANTI-BAN] Local Kick blocked!") end)

-- Giấu box ESP khỏi đám đông
local oldNew = Instance.new
getgenv().Instance_new = newcclosure(function(type_, ...)
  if type_ == "BoxHandleAdornment" then
    local box = oldNew(type_, ...)
    box.ZIndex = 1
    return box
  end
  return oldNew(type_, ...)
end)
