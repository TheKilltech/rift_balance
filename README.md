# Rift Exploration Defense Industry (REDI)

REDI is a campaign-focused (story and open) total rebalance mod that overhauls Riftbreaker's resource economy, ammo, defenses, buildings, waves, and mission structure to support long-term, challenging playthroughs.

Riftbreaker is a great game, but the original campaign (pre-2.0 especially) was incredibly unchallenging, and that diminishes the fun. Because I can do something about it, I'll lose sleep if I don't. My short list of observations when I started:

1. In the normal game, resources play barely any role except very early on — only the research that unlocks a resource has real impact. We have infinite resource sources but no adequate sinks for them. That had to change.
2. Tier upgrades improve everything by at least 100%. That's excessive, and a big part of why hordes end up trivial to fight. Expect the nerf hammer.
3. Except for the outpost maps, many the many missions allow you to build substantial bases producing infinite resources with disabled attack waves. Something had to be done about that.
4. Ammo exists in the game but is irrelevant. Had to fix that too.

## Design philosophy

Most of REDI's changes are downstream of one idea: turn "have I unlocked X" into "can I keep affording X." Vanilla Riftbreaker's tension is front-loaded into the tech tree — once a tier is unlocked, running it costs nothing meaningful, so a maxed-out base stops asking you to make decisions. REDI tries to keep that tension alive for the whole playthrough:

- **Economy**: free or infinite sources become processing chains — cultivators no longer yield rare resources directly, and higher-tier buildings and ammo need scarcer, refined inputs the further you go.
- **Combat**: high-tier towers cost more to run continuously (energy/fluid per shot, ongoing upkeep), and placement matters because towers can block each other's line of fire — turtling stops being free, and the Fire Control Station rewards actively managing your defenses instead of leaving everything running.
- **Pacing**: waves and events are rebuilt so a fully upgraded base still gets tested 100 hours in, not just the first 10 — more randomization, longer and more varied attack phases, and wave "bleed" from completed biomes to other locations.
- **Redundancy**: almost every resource has more than one independent way to get it — natural deposits, cultivators and bio-presses, and synthetic production chains through dedicated economy buildings — so no single node or biome is a hard bottleneck.

This is a fix for a specific failure mode of long, open-ended play: infinite resources plus flat power tiers quietly stop mattering the longer a campaign runs. That's also why survival mode gets a much lighter touch — see below.

**Status**: REDI is actively developed and still evolving. Structural integration of Riftbreaker's 2.0 / World Expansion IV content — including orbital scanner missions — is done; what's left is balancing and fine-tuning, which is a permanent, ongoing task. If something still seems unclear or off, please say so on Discord.

An old mod spotlight article on Steam, from back when REDI was still in the early days:
https://store.steampowered.com/news/app/780310/view/4441205936032317627

## Resources
- Mines, Regular, Rare and Special Resources:
   - In vanilla, different extractor buildings (mines) are needed per resource. This mod changes that — there are now strip mines for surface deposits and drill mines for underground veins. Even palladium can now be mined with a simple strip mine if it's on the surface.
   - Some underground resource deposits are infinite. They're rare but precious!
   - In vanilla, cultivators are an automated infinite source and very powerful compared to mines. Added bio-resources replacing the direct rare-resource yield from cultivators — those bio-resources require additional processing steps to refine into palladium, titanium, uranium ore, or cobalt.
   - Refining bio-rare resources involves a new pipe-resource, reagent, which is refined mostly from plant biomass.
   - New crystalizer buildings offer an alternative way to obtain special resources, as an alternative to cultivators.
   - New resources: ammonium (mostly for ammo), nitric acid fluid (advanced ammo production), fluorine gas (basic resource-processing catalyst), reagent (higher-tier fluid for resource processing), petroleum (carbon and energy source), alloys (top-end resource produced from rare metals).
   - DLC1's morphium resource opens an extremely energy-intensive alternative way to obtain rare resources by converting metals.
   - DLC3's resin resource has an additional use: slow but infinite extraction of surface deposits.
   - The "more than one way to get it" principle applies to almost every resource in the game. DLC1 and DLC3 each added a biome-exclusive piped resource — REDI added alternative deposit types to acquire them, plus events that can spawn them later in other biomes too. Cultivators work the same way: biome-specific flora now yields new bio-resources that can be refined, but there's also a synthetic alternative from dedicated economy buildings. The same pattern applies to all resources in the game.

- Ammo: this mod changes massively how ammo works. All better mech and tower weapons now need higher-tier ammunition.
   - There are now 3 ammo tiers and 5 ammo categories: low caliber, high caliber, explosive, energy, and liquid. Each has dedicated production facilities.
   - Tier 2 ammo needs special resources for production — fedronite, hazenite, rhodenite, or tanzanite depending on the category — so stockpiling these now matters.
   - Tier 3 ammo is similar and requires rare resources.
   - Tier 2 ammo is crafted from tier 1 ammo, tier 3 from tier 2 — meaning you have to set up real production chains.
   - Higher-tier (mech) ammo production is map-local: you have to build a production chain on every map you need it, or bring enough ammo to get through your mission.
   - Ammo storages are split into one per category (not yet sure if they should share the same building limit).
   - Moved all ammo-related buildings (production and storage) into their own new category.

- AI: originally only used by towers, this mod makes complex industrial production also require the AI resource. Higher-level AI hubs offer significantly more AI, but require cooling.

- Buildings:
   - Work in progress: building upgrades should be more interesting. For example, the tier 2 carbonium power plant now additionally requires a catalyst resource that tier 1 doesn't need. Tier 3 carbonium power no longer consumes deposits but requires high-tier reagent as an additional input.
   - Reworked building tiers: carbonium power plant, bio composter, gas power plant, fusion reactor, nuclear plant, morphium power, AI hub, supercoolant refinery, ionizer, strip mine, drill mine, water filtration, gas filtering plant, gas extractors, liquid pumps, uranium centrifuge, and more.
   - New mechanic: some buildings now buff specific other buildings in their vicinity. For example, small energy-storage does not just store energy but also stabilizes the grid by which it gives nearby power plants a small production boost (at a cooling-upkeep cost). The same mechanic now boosts mines and other extractors, and the morphium-based rare-metal morphing plants, among others.
   - Due to the sheer number of new buildings, i had to split economy buildings into those for solid resources and liquid/piped ones into different categories.

## Weapons
- Higher-tier weapons in particular are nerfed compared to their original stats.
- Higher-tier weapons and turrets need higher-tier ammo.
- Most top-tier towers are now 2x2, with a corresponding firepower boost.
- Towers can now block each other, so placement becomes actually relevant.
- Higher-tier towers consume a lot more energy; energy-based towers consume large amounts of energy per shot on top of that.
- Most higher-tier towers require some fluid input.
- A new building, the Fire Control Station, lets you shut down all defenses when there's no enemy around, saving energy and resource consumption from towers and shield generators.

## Difficulty, Waves, Events and Missions
- Complete overhaul of the original attack wave code, originally because it was underwhelming in the end game.
- Attack waves are split into smaller, repeating attacks that can change composition and direction.
- Unusually, the attack phase lasts longer, but so does the idle time in between.
- There's a lot more randomization. A certain level of unpredictability creates unique experiences even 100h into the game and keeps the player on their toes — one attack phase may be easy while the next ends up hard, and vice versa, sometimes coinciding with events on top.
- Overhauled large parts of the events system as well.
- Events are more likely during attack phases.
- Expanded some existing events that tie to campaign progress — e.g., morphium veins may spawn in many biomes late in the game once the player completes Metal Valley.
- Changed all non-outpost missions so that staying on a map longer won't be entirely boring.
- After completing a biome, attack waves from that biome may now visit you at other locations (not just your HQ).
- Orbital scanner missions are now fully incorporated, including a change to how threat works. Now it affects mainly the wave difficulty, pulling tougher or easier wave sets from the campaign difficulty setting.

## Survival mode

Survival is intentionally not where REDI focuses. The problem REDI solves — infinite resources and flat tier scaling losing all meaning over a long, open campaign — mostly doesn't exist in survival, since survival is already time-boxed. Porting the full rework over wouldn't be a bug fix, it would need its own simplified design pass tuned to a short time budget, and that hasn't happened yet.

Current state: minimally playable, but not recommended as the primary way to experience REDI.

## Multiplayer / Co-op

I haven't tested REDI in co-op myself. No one has reported issues with it on Discord so far, but that's not the same as it being verified — treat co-op as unconfirmed for now. If you try it, a report of how it went (working or not) is genuinely useful.

## ToDo

- Balancing and fine-tuning: a never-ending, ongoing task — weapons, towers, attack waves, and the resource economy are all still being tuned, especially after the vanilla game's post-2.0 stat changes.

## Remarks
You're free to modify the mod to your own liking for personal use, but please don't republish it under your name. If you want to reuse some of the assets from this mod in your own, feel free — just make sure to credit me and this mod as the source.

You can contact me about issues/feedback on Discord. If you encounter crashes, attaching your log really helps me fix them. I'm usually watching https://discord.com/channels/423424585954754565/736688063362891860. If you want to get more deeply involved, check out the GitHub repo.

Please note that, due to the extensive changes this mod makes to the base game, it will collide with any other mods that change the same files.

## Help
If you like this mod, you can always contribute by reporting issues — crashes, balancing, weird behavior, or just things that are unclear. I try to fix these.

Translations: REDI is available in German and Chinese (Simplified) — Chinese was contributed by a community member, thank you! I'd gladly add more languages if someone wants to help out.

## Links
github:   https://github.com/TheKilltech/rift_balance
mod.io:   https://mod.io/g/riftbreaker/m/rift-exploration-defense-industry
steam:    https://steamcommunity.com/workshop/filedetails/?id=3598485480
discord:  https://discord.com/channels/423424585954754565/1134827658530803753
