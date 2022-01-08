
--[[
# How does reanimation work?
Reanimate uses a clone to track movements, and with aligning your
main bodyparts to the clone will gain you script's animation to be fe.
(i don't know why it just does not work without reanimate.)


Anyways, lets return to main things.

]]

-- Options, Will explain why velocity is needed later on.
_G.Velocity = Vector3.new(35,0,0)

--[[
Align Method.. The main core of reanimate (I would not consider using CFLoop method as it delays.)

Align is made with:
    - Align Position
    - Align Orientation
    - 2 Attachments.
First of all you would like to start with adding arguments into the function.
    `local function Align(P0,P1,Position,Rotate)`
        - P0 = Part0
        - P1 = Part1
        - Position/Rotate = self-explanatory     
            - Names of the args can be always changed to whatever you want to.
    
Then make sure you create instances into right parents/path.
    AlignPosition and AlignOrientation should go to Part0, your main body you will attach from
    first Attachment Should go with Part0, second one should be with Part1
    
Now It is time to connect the Aligns.

You need to set:
AlignPosition.Attachment0 to the first Attachment
AlignPosition.Attachment1 to the second Attachment
You need to do the same with AlignOrientation.

Example:
--------------------------------------------
local AlignPosition = Instance.new("AlignPosition", P0)
local AlignOrientation = Instance.new("AlignOrientation", P0)
local Attachment1 = Instance.new("Attachment", P0)
local Attachment2 = Instance.new("Attachment", P1)

AlignPosition.Attachment0 = Attachment1
AlignPosition.Attachment1 = Attachment2
AlignOrientation.Attachment0 = Attachment1
AlignOrientation.Attachment1 = Attachment2
--------------------------------------------

Boom, your align is almost done, now the thing left is properties to fix delays and bugs.
I do recommend to enable RigidityEnabled[1] on both AlignPosition and AlignOrientation
but if you dont want to well.


Definition of RigidityEnabled:

Position:
When set to true, the solver will react as quickly as possible to move the attachments together.
When false, the torque is dependent on AlignPosition.MaxForce, AlignPosition.MaxVelocity, and AlignPosition.Responsiveness.

Orientation:
When set to true, the solver will react as quickly as possible to align the attachments. 
When false, the torque is dependent on AlignOrientation.MaxTorque, AlignOrientation.MaxAngularVelocity, and AlignOrientation.Responsiveness.


AlignPosition Properties:
https://developer.roblox.com/en-us/api-reference/class/AlignPosition
The properties you only need for align position in align is:
MaxForce, Responsiveness (200 Max), MaxVelocity (optional).

AlignOrientation Properties:
https://developer.roblox.com/en-us/api-reference/class/AlignOrientation

The properties you only need for align position in align is:
MaxTorque, Responsiveness (200 Max), MaxAngularVelocity (optional).

Also if you wanna customize position make sure to add those lines:

ATTACHMENT-THAT-GOES-TO-P0-HERE.Position = Position or Vector3.new(0,0,0)
ATTACHMENT-THAT-GOES-TO-P0-HERE.Rotation = Rotate or Vector3.new(0,0,0)

And full example of using the function should be:
Align(Character["Thing"],Reanimate['Right Arm'],Vector3.new(0,-0.5,0),Vector3.new(0,0,0))

]]
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
AlignOrientation.RigidityEnabled = true
-- Rotate/Position
Attachment1.Position = Position or Vector3.new(0,0,0)
Attachment1.Rotation = Rotate or Vector3.new(0,0,0)
end

--[[ 
Here goes the main reanimation process, setting up dummy.
First of all if you wanna have cleaner code, make variables.
Then you need to enable archivable property on character.
(It allows you to destroy, clone and modify your character).
Then clone your Character, make sure to make it as a variable.
Make sure to parent it into your Character, and give it a reasonable name.
And make sure to hide the clone body.

]]
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

-- Nocliping
--[[ 
This is very Important thing in reanimations.
Due to both clones having collidable torso might lead to getting flinged on attach.
This is why you should do noclip.

Also make sure you are using RunService.Stepped because other run services don't work.

]]
game:GetService("RunService").Stepped:Connect(function()
    Humanoid.Died:Connect(function()
        return -- Breaks the script, function 'break' will not work on runservices idk why.
    end)
    for i,v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
    -- fuck it
end)

--[[ Aliging
So before you attach your bodyparts, make sure to destroy Shoulders/Hips to align arms.
And destroy HumanoidRootPart as it takes most of net causing the body sometimes to fall
You can use shorter version align which is something like this:
function InstantAttach(P0)
    Attach(Character[P0],Reanim[P0])
end
InstantAttach("Right Arm")

You can do it without any shortcuts too!

Attach(Character.AE,Reanim.AE) -- Position/Rotation is not needed if you added "or Vector3.new(0,0,0)" to the Rotation/Position Align Variable.

Notes:
1. DO NOT ATTACH HEAD UNLESS YOU ARE ON PERMA DEATH OR YOU ARE USING HEAD MOVEMENT METHOD
2. DO NOT BREAK ROOTPART ON PDEATH, INSTEAD DESTROY ROOTJOINT AND ATTACH IT
3. DO NOT ALIGN ACCESSORIES UNLESS ON PDEATH
]]
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



--[[ Netless Section.
Remember the top thing i told you about velocity? well it's actually mine source of netless.
It makes your body jitters allowing the parts to move making it not lose it parent.
Make sure you dont give too low Vector3 or to high one.
Best ones IN MY OPINION is: [0,-30.5,0]
Also only RunService.Heartbeat works.

]]
game:GetService("RunService").Heartbeat:Connect(function()
    for i,v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then v.Velocity = _G.Velocity elseif v:IsA("Accessory") then v.Handle.Velocity = _G.Velocity end
    end
end)
--[[ Movement, and stuff.
There are 2 methods that you can use to make your character move.

1: Humanoid:Move Method.
This one is really simple.

You have to put this line of code:
 - Reanim.Humanoid:Move(Character.Humanoid.MoveDirection)
Inside the noclip, make sure you place it after "for i,v" thing.
You also gonna need jump trigger which uses UserInputService and here how it looks like:

game:GetService("UserInputService").JumpRequest:Connect(function()
	Reanim.Humanoid.Jump = true
	Reanim.Humanoid.Sit = false
end)

and that's all.


2: Simple Variable changing.
Basically changes your Character path into reanim causing everything to focus on a clone instead your main body.
This allows you to instant convert scripts without having to change character variable
Allows you to use tools and many more.
Example:
game.Players.LocalPlayer.Character = CLONEVARIABLE

And you are gonna need Reset method to make sure everything is back to normal after reset.

game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
Character.Humanoid:ChangeState(15)
game.Players.LocalPlayer.Character = workspace[game.Players.LocalPlayer.Name]
Reanim:Destroy()
end)
]]

game.Players.LocalPlayer.Character = Reanim
game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
Character.Humanoid:ChangeState(15)
game.Players.LocalPlayer.Character = workspace[game.Players.LocalPlayer.Name]
Reanim:Destroy()
end)
-- Camera, Basically making sure your camera redirects to clone humanoid to avoid weird camera movements.
workspace:FindFirstChildOfClass("Camera").CameraSubject = Reanim.Humanoid
