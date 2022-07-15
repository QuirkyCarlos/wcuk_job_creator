config = config or {}

---Uses billing UI instead of normal prompt to billing
config.usebillingUi = false 

--Max distance where marker can be seen
config.markerDistance = 10

---Use 3D text instead of markerDistance
config.use3DText = true

config.textSize = 1

--[[
    Available fonts values:
    0 - ChaletLondon
    1 - HouseScript
    2 - Monospace
    4 -CharletComprimeColonge
    7 - Pricedown
]]
config.textfonts = 0

--Seconds to lockpick a car
config.carLockpickTime = 0


-- Should the Vehicle have alarm wile lockpicking?
config.enableAlarmWhenLockpicking = true


-- Use or not jsfour-idcar script (if you have it) to view target ID card in check idenetity actions
config.usejsfourIdCard = false

-- Can the player use the F6 actions menu when it's off duty?
config.canUseActionsMenuWhileOFFDuty = false

