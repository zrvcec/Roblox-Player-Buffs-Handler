--!strict

-- Defines the BuffRegistry module which manages the registration and retrieval of buffs in the game. 
-- This script allows for the addition of new buffs, checking for existing buffs, and retrieving buff data based on unique identifiers.

local BuffRegistry = {}

-- GetBaseValue does storedValue + amount given by skills that have been applied to the player.
-- GetBuffMultiplier applies the multiplier given by temporary buffs

local Qualities = {
    -- Combat Qualities

    DamageIncrease = {},
    PhysicalDamageIncrease = {},
    IncomingDamageReduction = {},
    AttackSpeed = {},
    CriticalChance = {},
    CriticalDamage = {},
    Range = {},

    -- Movement Qualities
    
    MovementSpeed = {},
    SprintSpeed = {},
    DashDistance = {},
    DashSpeed = {},
    DashCooldown = {},

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