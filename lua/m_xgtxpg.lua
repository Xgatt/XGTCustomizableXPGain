-- ============================================================
-- XGT Customizable XP Gain — Lua handler
--
-- Engine XP distribution (kill XP, quest XP, tomes, every path)
-- routes through opcode 104 with durationType=1. We attach an
-- op403 (ScreenEffects) listener to any party member whose
-- modifier is non-default; the handler mutates incoming op104
-- events in place by scaling m_effectAmount by the member's
-- XGT_XPMOD LOCAL.
--
-- LOCAL semantic (unchanged from v2.1): XGT_XPMOD is an absolute
-- percentage, 100 = no change. XGT_XPMOD_SET distinguishes
-- "default 100" from "never set".
-- ============================================================

if not EEex_Active then return end

local DEFAULT_MOD = 100

-- ------------------------------------------------------------
-- Utility
-- ------------------------------------------------------------

local function getName(sprite)
    if not sprite then return "<unknown>" end
    local n = sprite:getName()
    if n and n ~= "" then return n end
    return "<unnamed>"
end

local function getModifier(sprite)
    if not sprite then return DEFAULT_MOD end
    if sprite:getLocalInt("XGT_XPMOD_SET") == 0 then
        return DEFAULT_MOD
    end
    return sprite:getLocalInt("XGT_XPMOD")
end

local function formatModifier(mod)
    if mod == DEFAULT_MOD then
        return "default (100%)"
    elseif mod > DEFAULT_MOD then
        return string.format("+%d%%", mod - DEFAULT_MOD)
    else
        return string.format("-%d%%", DEFAULT_MOD - mod)
    end
end

local function castOnSelf(sprite, res)
    sprite:applyEffect({
        ["effectID"]     = 146,   -- Cast Spell
        ["dwFlags"]      = 1,     -- param2=1: cast instantly, ignore restrictions
        ["res"]          = res,
        ["sourceID"]     = sprite.m_id,
        ["sourceTarget"] = sprite.m_id,
    })
end

-- ============================================================
-- XGTXPOP — op403 (ScreenEffects) handler.
-- Fires for every effect added to the listening sprite. We only
-- act on op104/timing=1/param2=0 (the engine's add-to-basestat
-- XP path); everything else passes through untouched.
-- ============================================================
function XGTXPOP(op403eff, incoming, sprite)
    if incoming.m_effectId ~= 104 then return end
    if incoming.m_durationType ~= 1 then return end
    if incoming.m_dWFlags ~= 0 then return end  -- skip SET (1) and PCT (2) modes

    local mod = getModifier(sprite)
    if mod == DEFAULT_MOD then return end

    local original = incoming.m_effectAmount
    local modified = math.floor(original * mod / 100)
    incoming.m_effectAmount = modified

    Infinity_DisplayString(string.format(
        "%s: XP gain %d -> %d (%s)",
        getName(sprite), original, modified, formatModifier(mod)))
    -- no explicit return → don't block; engine applies the mutated effect
end

-- ============================================================
-- XGT_SetMod — called from the book dialog. Sets LOCALs, swaps
-- cosmetic icon SPL, and installs/removes the op403 listener
-- based on whether the new value is the default.
-- ============================================================
function XGT_SetMod(value)
    local sprite = EEex_LuaAction_Object
    if not sprite then return end

    sprite:setLocalInt("XGT_XPMOD_SET", 1)
    sprite:setLocalInt("XGT_XPMOD", value)

    -- Cosmetic icon swap.
    castOnSelf(sprite, "XGTXPIR")
    if value > DEFAULT_MOD then
        castOnSelf(sprite, "XGTXPIU")
    elseif value < DEFAULT_MOD then
        castOnSelf(sprite, "XGTXPID")
    end

    -- Always strip any existing listener first (idempotent).
    sprite:applyEffect({
        ["effectID"]     = 321,            -- Remove effects by resource
        ["res"]          = "XGTXPOP",
        ["sourceID"]     = sprite.m_id,
        ["sourceTarget"] = sprite.m_id,
    })
    -- Install only for non-default modifiers.
    if value ~= DEFAULT_MOD then
        sprite:applyEffect({
            ["effectID"]     = 403,        -- Screen Effects
            ["durationType"] = 9,          -- permanent
            ["res"]          = "XGTXPOP",  -- lua function name
            ["m_sourceRes"]  = "XGTXPOP",  -- for op321 removal
            ["sourceID"]     = sprite.m_id,
            ["sourceTarget"] = sprite.m_id,
        })
    end

    Infinity_DisplayString(string.format(
        "%s's XP gain is now %s.", getName(sprite), formatModifier(value)))
end

-- ============================================================
-- XGT_ShowParty — prints each party member's current modifier.
-- ============================================================
function XGT_ShowParty()
    Infinity_DisplayString("Tome of the Masterful Learner — party settings:")
    local any = false
    for i = 0, 5 do
        local m = EEex_Sprite_GetInPortrait(i)
        if m then
            any = true
            Infinity_DisplayString(string.format(
                "  %s: %s", getName(m), formatModifier(getModifier(m))))
        end
    end
    if not any then
        Infinity_DisplayString("  (no party members found)")
    end
end
