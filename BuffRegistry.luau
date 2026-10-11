--!strict

-- Defines the BuffRegistry module which manages the registration and retrieval of buffs in the game. 
-- This script allows for the addition of new buffs, checking for existing buffs, and retrieving buff data based on unique identifiers.
local BuffRegistryCalc = require("././BuffRegistryCalc")

local BuffRegistry = {
    types = {
        MultiplierByOffset = {id = 1, calc = BuffRegistryCalc.multiplierbyoffset},
        MultiplierByTotal = {id = 2,  calc = BuffRegistryCalc.multipliertotal},
        flat = {id = 3, calc = BuffRegistryCalc.flat},
        override = {id = 4, calc = BuffRegistryCalc.override},
        minimum = {id = 5, calc = BuffRegistryCalc.minimum},
        maximum = {id = 6, calc = BuffRegistryCalc.maximum},
        flatpercent = {id = 7, calc = BuffRegistryCalc.flatpercent,},
        expontential = {id = 8, calc = BuffRegistryCalc.exponential},
        basedonntarget = {id = 9, calc = BuffRegistryCalc.basedontarget},
        basedonmissing = {id = 10, calc = BuffRegistryCalc.basedonmissing},
        additivestacking = {id = 11, calc = BuffRegistryCalc.additivestacking},
        multiplicativestacking = {id = 12, calc = BuffRegistryCalc.multiplicativestacking},
        diminishingreturns = {id = 13, calc = BuffRegistryCalc.diminishingreturns},
        conditional = {id = 14, calc = BuffRegistryCalc.conditional},
        conversion = {id = 15, calc = BuffRegistryCalc.conversion},
        chancebased = {id = 16, calc = BuffRegistryCalc.chancebased},
    }
}

-- GetBaseValue does storedValue + amount given by skills that have been applied to the player.
-- GetBuffMultiplier applies the multiplier given by temporary buffs

--[[
    +-------------------------+----------------------------------------------+--------------------------------------+
    | Type                    | Description / Formula                        | Example                              |
    +-------------------------+----------------------------------------------+--------------------------------------+
    | multiplierbyoffset      | base * (1 + value / 100)                     | 5 = +5%, -5 = -5%                    |
    | multipliertotal         | base * value                                 | 0.8 = 80%, 1.2 = 120%               |
    | flat                    | base + value                                 | 25 = +25, -10 = -10                  |
    | override                | result = value                               | 250 = exactly 250                    |
    | minimum                 | max(current, value)                          | Minimum value of 10                  |
    | maximum                 | min(current, value)                          | Maximum value of 100                 |
    | clamp                   | min(max(current, min), max)                  | Restrict value to 10-100             |
    | flatpercent             | current + (base * value / 100)               | Add 10% of base                      |
    | exponential             | base * pow(multiplier, exponent)             | 100 * 1.1^2 = 121                    |
    | basedontarget           | targetStat * value / 100                     | 10 = 10% of target HP                |
    | basedonmissing           | missingStat * value / 100                    | 20 = 20% of missing HP               |
    | additivestacking         | value1 + value2 + value3                     | 20% + 30% = 50%                      |
    | multiplicativestacking   | multiplier1 * multiplier2                    | 1.2 * 1.3 = 1.56x                    |
    | diminishingreturns       | maxBonus * input / (input + constant)        | 100 * 50 / 100 = 50                  |
    | conditional              | Apply buff only if condition is true         | +20% damage below 50% HP             |
    | periodic                 | amountPerTick * tickCount                    | 10 healing * 5 ticks = 50            |
    | conversion               | sourceStat * conversionRate                  | 200 attack * 0.1 = 20 armor          |
    | chancebased              | Trigger if random roll < chance              | 0.25 = 25% chance                    |
    +-------------------------+----------------------------------------------+--------------------------------------+


]]
local Qualities = {
    -- Combat Qualities

    DamageIncrease = {
        name = "Damage Boost",
        description = "Gives you a damage boost that are non physical",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        }
    },

    PhysicalDamageIncrease = {
        name = "Physical Damage Boost",
        description = "Gives you a damage boost that are physical",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        }
    },


    IncomingDamageReduction = {
        name = "Damage Dealt Protection",
        description = "Reduces the amount of damage you deal against others",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        }
    },

    AttackSpeed ={
        name = "Attack Speed Boost",
        description = "Increases your attack speed",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        }
    },

    CriticalChance = {
        name = "Critical Chance Boost",
        description = "Increases your chances of a critical hit!",
        effect = {
            type = BuffRegistry.types.chancebased,
            value = 1,
        },
    },
    CriticalDamage = {
        name = "Critical Damage Boost",
        description = "Increases your Critical Damage!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    Range = {
        name = "Reach Increase",
        description = "Increases your utensil tool ranges!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    -- Movement Qualities
    
    MovementSpeed =  {
        name = "Movement Speed Boost",
        description = "Increases your walkspeed!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    SprintSpeed = {
        name = "Movement Speed Boost",
        description = "Increases your Runningspeed!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },

    DashDistance = {
        name = "Dash Distance",
        description = "Increases your Dashing distances!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    DashSpeed = {
        name = "Dash Speed",
        description = "Increases your Dashing speeds!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    DashCooldown = {
        name = "Dash Cooldown",
        description = "Lowers your cooldown speeds!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },

    -- Health & Stamina Qualities

    HealthIncrease = {},
    HealthRegen = {},
    StaminaIncrease = {},
    StaminaRegen = {},
    StaminaCost = {},
    StaminaRegenDelay = {},
    CombatCooldownReduction = {},

    -- Nen Qualities

    NenDamageIncrease = {}, 
    NenIncomingDamageReduction = {},
    NenCost = {},
    NenRegeneration = {},
    NenXPBoost = {},

    -- Defense Qualities 
    DamageDecreasebyDefense = {}, --> Basically if player is blocking and damage is 100 then it will do 100 defense damage and damage decrease may lower it
    DefenseCost = {}, --> How much defense is consumed when being used and not getting hit.
    DefenseRegen = {},
    DefenseRegenDelay = {},

    -- Mining Qualities
    MiningDamage = {},
    MiningSpeed = {},
    ResourceDropIncreaseChance = {},
    StatXPBoost = {},

    -- Resistance Qualities
    StunResistance = {},
    KnockBackResistance = {},
    BleedResistance = {},
    BurnResistance = {},
    PoisonResistance = {},
    FreezeResistance = {},
    ShockResistance = {},
    SlowResistance = {},
    
    -- Positive Performance Qualities
    DamageImmunity = {},
    StunImmunity = {},

    -- Negative Performance Qualities
    Stun = {},
    StunDurationIncrease = {},
    Slow = {},
    Bleed = {},
    Burn = {},
    Poison = {},
    Freeze = {},
    Shock = {},
    Blind = {},
    Silence = {},
    Weaken = {},
    Vulnerability = {},
    Root = {},
    Ragdoll = {},
    KnockBack = {},
}

local Buffs = {}

BuffRegistry.Buffs = Buffs
BuffRegistry.Qualities = Qualities

return BuffRegistry