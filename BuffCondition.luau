--!strict

-- Handles the conditions for buffs in the game. This script defines various buff conditions and their effects on players or entities.
-- In simple terms it defines how buffs are applied, checked, and removed based on certain criteria.

local BuffCondition = {}

BuffCondition.data = {
    CelestialsEvaporator_III = {
        name = "Celestials Evaporator III",
        description = "Grants player outrageous buff stats. Use at your own risk",

        effects = {
            Stun = {value = 1}
        }
    }
}

return BuffCondition