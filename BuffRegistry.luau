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

    -- For future me
    -- Use overflow for min max calculations
    -- Then add variables value min and value max
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

    HealthIncrease = {
        name = "Vitality Boost",
        description = "Gives you more warmth.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    HealthRegen = {
        name = "Vitality Regeneration",
        description = "Gives you more regen speed.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    StaminaIncrease = {
        name = "Stamina Boost",
        description = "Gives you more stamina.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    StaminaRegen = {
        name = "Stamina Regeneration",
        description = "Gives you stamina faster.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    StaminaCost = {
        name = "Stamina Concentration",
        description = "You control your stamina use alot better making the costs of stamina less.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    StaminaRegenDelay = {
        name = "Stamina Regeneration Recovery",
        description = "It takes less time to start recovering.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    CombatCooldownReduction = {
        name = "Combat Utility",
        description = "You can use combat attacks a little bit faster.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },

    -- Nen Qualities

    NenDamageIncrease = {
        name = "Nen Damage Boost",
        description = "Your Nen attacks do slightly more damage.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    NenIncomingDamageReduction = {
        name = "Nen Damage Reduction",
        description = "Incoming NEN attacks do slightly less damage.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    NenCost = {
        name = "Nen Concentration",
        description = "You control your stamina use alot better making the costs of stamina less..",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },

    NenRegeneration = {
        name = "Nen Regenaration Boost.",
        description = "Your Nen regenerates a little bit faster.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    NenXPBoost = {
        name = "Nen XP Boost.",
        description = "You receive Nen Experience a little quicker than others.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },

    -- Defense Qualities 
    DamageDecreasebyDefense = {
        name = "Damage Reduction By Defense.",
        description = "Your damage to block conversion gets lowered a little.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    }, --> Basically if player is blocking and damage is 100 then it will do 100 defense damage and damage decrease may lower it
    DefenseCost = {
        name = "Defense Concentration.",
        description = "Your idle defense current draw draws a little less.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    }, --> How much defense is consumed when being used and not getting hit.
    DefenseRegen = {
        name = "Defense Regenaration Boost.",
        description = "Your defense regenerates a little bit faster.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    DefenseRegenDelay = {
        name = "Defense Recovery.",
        description = "Your Defense Recovers a little bit faster.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },

    -- Mining Qualities
    MiningDamage = {
        name = "Mining Strength.",
        description = "Your pickaxe suddenly becomes a little bit more useful.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    MiningSpeed = {
        name = "Mining Speed.",
        description = "Your can mine a little bit faster.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    ResourceDropIncreaseChance = {
        name = "Mining Luck.",
        description = "Your chances of a higher quality material dropping is slightly higher.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },

    StatXPBoost = {
        name = "Generic XP Boost",
        description = "You receive Generic Experience a little quicker than others.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },

    -- Resistance Qualities
    StunResistance = {
        name = "Stun Resistance",
        description = "Your stun duration is a little bit less.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    KnockBackResistance = {
        name = "Knockback Resistance",
        description = "You're suddenly better at dealing with knockback.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    BleedResistance = {
        name = "Bleed Resistance",
        description = "You're suddenly better at dealing with bleeding.",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    BurnResistance = {
        name = "Burn Resistance",
        description = "You're suddenly better at dealing with burning!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    PoisonResistance = {
        name = "Poison Resistance",
        description = "You're suddenly better at dealing with poison!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    FreezeResistance = {
        name = "Freeze Resistance",
        description = "You're suddenly better at dealing with freezing!",
        effect = {
            type = BuffRegistry.types.MultiplierByOffset,
            value = 1,
        },
    },
    -- Positive Performance Qualities
    DamageImmunity = {},
    StunImmunity = {},

    -- Negative Performance Qualities
    Stun = {},
    StunDurationIncrease = {},
    Bleed = {},
    Burn = {},
    Poison = {},
    Freeze = {},
    Blind = {},
    Root = {},
    Ragdoll = {},
    KnockBack = {},
}

local Buffs = {}

BuffRegistry.Buffs = Buffs
BuffRegistry.Qualities = Qualities

return BuffRegistry