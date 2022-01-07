-- Options:
_G.Velocity = Vector3.new(35,0,0)
-- Align:
local function Align(P0,P1,Position,Rotate)
local AlignPosition = Instance.new("AlignPosition", P0)
local AlignOrientation = Instance.new("AlignOrientation", P0)
local Attachment1 = Instance.new("Attachment", P0)
local Attachment2 = Instance.new("Attachment", P1)
-- Main Attach Thingy:
AlignPosition.Attachment0,AlignPosition.Attachment1 = Attachment1,Attachment2 -- Shortcut
AlignOrientation.Attachment0,AlignOrientation.Attachment1 = Attachment1,Attachment2 -- Shortcut
-- Properties:
AlignPosition.RigidityEnabled = true
AlignOrientation.MaxTorque,AlignOrientation.Responsiveness = 9e9,200 -- 9e9 Torque, 200 (max) Response
-- Rotate/Position
Attachment1.Position = Position or Vector3.new(0,0,0)
Attachment1.Rotation = Rotate or Vector3.new(0,0,0)
end

-- Main (R6)
local Character = workspace[game.Players.LocalPlayer.Name]
local Humanoid = Character:FindFirstChild("Humanoid")
Character.Archivable = true

local Reanim = Character:Clone()
Reanim.Parent = Character
Reanim.Name = "TalentlessDumbass" -- fox*
for i,v in pairs(Reanim:GetChildren()) do 
	if v:IsA("BasePart") then v.Transparency = 1
		elseif v:IsA("Accessory") then v:Destroy()
	end
end
Reanim.Head.face.Transparency = 1
-- Noclip
game:GetService("RunService").Stepped:Connect(function()
    Humanoid.Died:Connect(function()
        return -- Breaks the script, function 'break' will not work on runservices idk why.
    end)
    for i,v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)

-- Align
Character.Torso['Right Shoulder']:Destroy()
Character.Torso['Left Shoulder']:Destroy()
Character.Torso['Right Hip']:Destroy()
Character.Torso['Left Hip']:Destroy()
Character.HumanoidRootPart:Destroy()
function InstantAttach(P0)
    Align(Character[P0],Reanim[P0])
end
InstantAttach("Right Arm")
InstantAttach("Left Arm")
InstantAttach("Right Leg")
InstantAttach("Left Leg")
InstantAttach("Torso")

-- Netless:
game:GetService("RunService").Heartbeat:Connect(function()
    for i,v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "Torso" then v.Velocity = _G.Velocity elseif v:IsA("Accessory") then v.Handle.Velocity = _G.Velocity end
    end
    pcall(function() Character.Torso.Velocity = Vector3.new(1000,1000,1000) end)
end)
-- Finishes Touches:
game.Players.LocalPlayer.Character = Reanim
game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
Character.Humanoid:ChangeState(15)
game.Players.LocalPlayer.Character = workspace[game.Players.LocalPlayer.Name]
Reanim:Destroy()
end)
-- Camera
workspace:FindFirstChildOfClass("Camera").CameraSubject = Reanim.Humanoid
-- Done.
