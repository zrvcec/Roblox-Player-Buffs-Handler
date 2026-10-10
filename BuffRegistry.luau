--!strict

-- Defines the BuffRegistry module which manages the registration and retrieval of buffs in the game. 
-- This script allows for the addition of new buffs, checking for existing buffs, and retrieving buff data based on unique identifiers.

local BuffRegistry = {}

-- GetBaseValue does storedValue + amount given by skills that have been applied to the player.
-- GetBuffMultiplier applies the multiplier given by temporary buffs

local Qualities = {
    Walkspeed = {
        GetBaseValue = function()
            
        end,

        GetBuffMultiplier = function()
            
        end,
    },
    RunSpeed = {
        GetBaseValue = function()
            
        end,

        GetBuffMultiplier = function()
            
        end,
    },
    Strength = {
        GetBaseValue = function()
            
        end,

        GetBuffMultiplier = function()
            
        end,
    },
    JumpPower = {
        GetBaseValue = function()
            
        end,

        GetBuffMultiplier = function()
            
        end,
    },
}

local Buffs = {}

BuffRegistry.Buffs = Buffs
BuffRegistry.Qualities = Qualities

return BuffRegistry