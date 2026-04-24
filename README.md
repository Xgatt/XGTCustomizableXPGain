# XGTCustomizableXPGain

## Description
This is a WeiDU mod for the Infinity Engine Enhanced Edition games (BGEE, BG2EE, EET) that lets your party members gain XP at different rates. 

This is done through a book item — "Tome of the Masterful Learner" — added to the protagonist's inventory at game start. Right-click the book and choose "Study" to open a dialog that lets the reader set their own XP gain modifier from **-100%** (no XP at all) up to **+500%** (six times the normal rate), in predefined steps. **Requires EEex**.

Each party member's modifier is tracked independently on their own creature record, so you can have Charname gaining +50% XP while Imoen gains -25% and everyone else stays at the default 100%. The book travels with whoever picks it up — any party member holding it can study it to reconfigure their own rate. A "How fast is my team learning?" option dumps every member's current modifier to chat.

Any change made through the book will only apply to FUTURE XP, so think of this as an on-the-fly XP adjustment system.

This should ease the pain of playing with a double- or triple-class character in a party setting, since you can set those character to level a bit faster to make up for their lack of progress. Ideally, with this mod installed, you won't need to install any other global XP reduction mods (e.g. EET Tweaks components to reduce quest and kill XP). You can set your own curve with this so that early levels go fast, and you can slow yourself down on the fly if you find your growth outpacing the challenge. 

This also solves a major problem with XP cap removal combined with lots of new content mods, where you have to predict at install time how much XP you will gain throughout the saga and pre-reduce everything. Instead, with this mod you can just reduce or completely turn off XP gains for whoever is overleveled until you feel comfortable again.

## Compatibility and Installation Order
This mod is extremely lightweight. It does **not** touch any CRE, BCS, DLG, or ITM files except installing its own book and a single `EXTEND_TOP` on `baldur.bcs` to hand the book to Player1 at game start. All XP interception happens at runtime through EEex's op403 (ScreenEffects) hook — there is no install-time patching of creatures, scripts, or existing XP-granting actions.

Install order does not matter. It can safely go anywhere in your load order, early or late, and will coexist with XP-modifying tweak mods (subrace XP multipliers, XP book tweaks, quest XP scalers, etc.) without conflict. Though, as I've mentioned earlier, you won't need any other XP scalers with this added. Just needs to be installed sometime after EEEx.

## Technical Details (Under the Hood)
The IE engine grants XP to creatures exclusively via **opcode 104** (Experience Points) with **durationType=1**. This is true for every XP source — creature kill XP, scripted quest XP (`AddexperienceParty`, `AddXPObject`, `ChangeStat(…,XP,…,ADD)`), XP tome items, and anything else. All paths converge on op104 at the engine level.

When a party member configures a non-default rate via the book:

1. Two LOCAL variables are stamped on their CRE: `XGT_XPMOD_SET` (sentinel) and `XGT_XPMOD` (the absolute percentage — 100 means no change, 150 means +50%, etc.).
2. An **op403** (ScreenEffects) effect is applied to them, pointing at the mod's Lua handler `XGTXPOP`.
3. From that moment on, every op104/timing=1/add event that would be applied to that member is intercepted by the handler before the engine processes it. The handler reads the member's `XGT_XPMOD` and rewrites the incoming `m_effectAmount` in place: `floor(original × mod / 100)`. The engine then applies the rewritten effect normally. You'll get helpful messages in the chat window every time you gain XP explaining exactly how much each party member is getting.

Resetting a member to 100% removes the op403 listener via op321 (Remove effects by resource). The CRE's stored XP stat is never directly read or written — only the flow of incoming gains is scaled. This means the mod can be uninstalled cleanly at any time with no lingering effect on accumulated XP.

## Credits
Bubb, for outlining the op403 + op104 interception pattern and for flagging the cleaner op146-param2=1 route over the action-queue hack for cosmetic SPL application. And Luke for helping me clean up the code.
