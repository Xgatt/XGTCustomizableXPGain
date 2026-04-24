/** @tra setup.tra */

BEGIN XGTXPBK

/////////////////////////////////////////////////////////////////
// Root: To what end do you Study?
/////////////////////////////////////////////////////////////////
IF ~True()~ main
    SAY @100
    ++ @101 GOTO increase
    ++ @102 GOTO decrease
    ++ @103 DO ~EEex_LuaAction("XGT_SetMod(100)")~ EXIT
    ++ @104 DO ~EEex_LuaAction("XGT_ShowParty()")~ EXIT
    ++ @105 EXIT
END

/////////////////////////////////////////////////////////////////
// Increase sub-menu: +5%, +10%, +15%, +20%, +25%, +50%, +75%,
// +100%, +150%, +200%, +300%, +400%, +500%
/////////////////////////////////////////////////////////////////
IF ~True()~ increase
    SAY @110
    ++ @201 DO ~EEex_LuaAction("XGT_SetMod(105)")~ EXIT
    ++ @202 DO ~EEex_LuaAction("XGT_SetMod(110)")~ EXIT
    ++ @203 DO ~EEex_LuaAction("XGT_SetMod(115)")~ EXIT
    ++ @204 DO ~EEex_LuaAction("XGT_SetMod(120)")~ EXIT
    ++ @205 DO ~EEex_LuaAction("XGT_SetMod(125)")~ EXIT
    ++ @206 DO ~EEex_LuaAction("XGT_SetMod(150)")~ EXIT
    ++ @207 DO ~EEex_LuaAction("XGT_SetMod(175)")~ EXIT
    ++ @208 DO ~EEex_LuaAction("XGT_SetMod(200)")~ EXIT
    ++ @209 DO ~EEex_LuaAction("XGT_SetMod(250)")~ EXIT
    ++ @210 DO ~EEex_LuaAction("XGT_SetMod(300)")~ EXIT
    ++ @211 DO ~EEex_LuaAction("XGT_SetMod(400)")~ EXIT
    ++ @212 DO ~EEex_LuaAction("XGT_SetMod(500)")~ EXIT
    ++ @213 DO ~EEex_LuaAction("XGT_SetMod(600)")~ EXIT
    ++ @111 GOTO main
END

/////////////////////////////////////////////////////////////////
// Decrease sub-menu: -5% … -100%
/////////////////////////////////////////////////////////////////
IF ~True()~ decrease
    SAY @110
    ++ @221 DO ~EEex_LuaAction("XGT_SetMod(95)")~ EXIT
    ++ @222 DO ~EEex_LuaAction("XGT_SetMod(90)")~ EXIT
    ++ @223 DO ~EEex_LuaAction("XGT_SetMod(85)")~ EXIT
    ++ @224 DO ~EEex_LuaAction("XGT_SetMod(80)")~ EXIT
    ++ @225 DO ~EEex_LuaAction("XGT_SetMod(75)")~ EXIT
    ++ @226 DO ~EEex_LuaAction("XGT_SetMod(70)")~ EXIT
    ++ @227 DO ~EEex_LuaAction("XGT_SetMod(65)")~ EXIT
    ++ @228 DO ~EEex_LuaAction("XGT_SetMod(60)")~ EXIT
    ++ @229 DO ~EEex_LuaAction("XGT_SetMod(55)")~ EXIT
    ++ @230 DO ~EEex_LuaAction("XGT_SetMod(50)")~ EXIT
    ++ @231 DO ~EEex_LuaAction("XGT_SetMod(45)")~ EXIT
    ++ @232 DO ~EEex_LuaAction("XGT_SetMod(40)")~ EXIT
    ++ @233 DO ~EEex_LuaAction("XGT_SetMod(35)")~ EXIT
    ++ @234 DO ~EEex_LuaAction("XGT_SetMod(30)")~ EXIT
    ++ @235 DO ~EEex_LuaAction("XGT_SetMod(25)")~ EXIT
    ++ @236 DO ~EEex_LuaAction("XGT_SetMod(20)")~ EXIT
    ++ @237 DO ~EEex_LuaAction("XGT_SetMod(15)")~ EXIT
    ++ @238 DO ~EEex_LuaAction("XGT_SetMod(10)")~ EXIT
    ++ @239 DO ~EEex_LuaAction("XGT_SetMod(5)")~ EXIT
    ++ @240 DO ~EEex_LuaAction("XGT_SetMod(0)")~ EXIT
    ++ @111 GOTO main
END
