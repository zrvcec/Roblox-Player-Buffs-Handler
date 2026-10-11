--!strict
local Buffs = {}

type NumberList = {number}

local RandomGenerator = Random.new()

-- 1. Percentage increase or decrease.
function Buffs.multiplierbyoffset(base: number, percent: number): number
    return base * (1 + percent / 100)
end

-- 2. Direct multiplier.
function Buffs.multipliertotal(base: number, multiplier: number): number
    return base * multiplier
end

-- 3. Add or subtract a fixed amount.
function Buffs.flat(base: number, amount: number): number
    return base + amount
end

-- 4. Replace the current value.
function Buffs.override(current:number, newValue: number): number
    return newValue
end

-- 5. Enforce a minimum value.
function Buffs.minimum(current: number, minimum: number): number
    return math.max(current, minimum)
end

-- 6. Enforce a maximum value.
function Buffs.maximum(current: number, maximum: number): number
    return math.min(current, maximum)
end

-- 7. Restrict a value to a range.
function Buffs.clamp(current: number, minValue: number, maxValue: number): number
    if minValue > maxValue then
        return 0
    end
    return math.clamp(current, minValue, maxValue)
end

-- 8. Add a percentage of the original base.
function Buffs.flatpercent(base: number, current: number, percent: number): number
    return current + base * (percent / 100)
end

-- 9. Exponential scaling.
function Buffs.exponential(base: number, multiplier: number, exponent: number): number
    return base * (multiplier ^ exponent)
end

-- 10. Calculate a percentage of a target stat.
function Buffs.basedontarget(targetStat: number, percent: number): number
    return targetStat * (percent / 100)
end

-- 11. Calculate a percentage of a missing stat.
function Buffs.basedonmissing(maxStat: number, currentStat: number, percent: number): number
    local missing: number = math.max(0, maxStat - currentStat)
    return missing * (percent / 100)
end

-- 12. Add bonuses together.
function Buffs.additivestacking(bonuses: NumberList): number
    local total: number = 0

    for _, bonus: number in ipairs(bonuses) do
        total += bonus
    end

    return total
end

-- 13. Multiply multipliers together.
function Buffs.multiplicativestacking(multipliers: NumberList): number
    local total: number = 1

    for _, multiplier: number in ipairs(multipliers) do
        total *= multiplier
    end

    return total
end

-- 14. Diminishing returns.
function Buffs.diminishingreturns(input: number, maxBonus: number, scalingConstant: number): number
    if scalingConstant <= 0 then
        return 0
    end

    input = math.max(0, input)
    return maxBonus * input / (input + scalingConstant)
end

-- 15. Apply a buff only if the condition is true.
function Buffs.conditional(base: number, condition: boolean, applyBuff: (number) -> number): number
    if condition then
        return applyBuff(base)
    end

    return base
end

-- 16. Calculate the total of a periodic effect.
function Buffs.periodic(amountPerTick: number, tickCount: number): number
    return amountPerTick * tickCount
end

-- 17. Convert one stat into another.
function Buffs.conversion(sourceStat: number, conversionRate: number): number
    return sourceStat * conversionRate
end

-- 18. Chance-based effect.
function Buffs.chancebased(chance: number): (boolean)
    if chance <= 0 then return false end
    if chance >= 1 then return true end
    return RandomGenerator:NextNumber() < chance
end

return Buffs