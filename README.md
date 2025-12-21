# Rift Exploration Defense Industry

REDI is a campaign-only total rebalance mod which added extensive features to each biome, resource economy, defense and events. Unfortunately as the mod aims at long term playthroughs, it is not compatible with the short surivial runs (survival is currently not playable without cheats).

Playing Riftbreaker is a greata game but the original campaign previous to 2.0 was increadibly unchallenging and that diminishes my fun when playing though. And because i can do something about it, i will suffer from sleepless nights if i don't. My short list of observations:
1. in the normal game resources play barely any role except very early on - only the reasearch which unlock a resource has a big impact. we have infinite resource sources, but no adequately sinks for those. That must change
3. Tier upgrades improve everything by at least 100%. That's insane and massively contributing to making all hords trivial to defeat. Expect the nerf hammer.
4. Except for the outpost maps, all other missions are boring but allow us still to build substantial bases producing infinite resources. Have to do something about that.
5. Ammo exists in the game but is irrelevant. Have to fix that.

**Disclaimer**: this is a mod i am making for myself and it is still in a early development stage. please understand if you find stuff is not yet working properly. currently not all tech is in the tech tree and **survival tech tree is broken**. localization is missing, so this is only english for now. 

an old mod spotlight article on steam:
https://store.steampowered.com/news/app/780310/view/4441205936032317627

## Resources
- Mines, Regular, Rare and Special Resources:
   - in vanilla different extractor buildings (mines) are needed per resource. this mod changes that. there are now strip mines for surface deposits and drill mines for underground veins. now even palladium can be mined with the simple strip mine if it is on the surface.
   - some underground resource deposit are infinite. they are rare but precious!
   - In vanilla cultivators are an infinite entierly automated infinite source and they are very powerful compared to mines. added bio-resources replacing the direct rare resource yield from cultivators. those bio resources require additional processing steps to refine them into palladium, titanium, uranium ore or cobalt.
   - the refining of bio-rare resourses involves a new pipe-resource reagent. it is refined from plant biomass mostly.
   - new crystalizer buildings offer an alternative to obtain special resources as an alternative to cultivators
   - new resources: ammonium (mostly for ammo), nitic acid fluid (advanced ammo production), fluorine gas (basic resource processing catalyst), reagent (higher tier fluid for resource processing), petroleum (carbon and energy source), alloys (top end resource produced from rare metals)
   - DLC1 morphium resource opens a new extremely energy intensive alternative of obtain rare resources by converting metals
   - DLC3 resin resource has an additional use for a slow ableit infinite extraction of surface deposits
    
- Ammo: this mod changes massively how ammo works. All better mech and tower weapons now need hier tier ammunutions.
   - There are now 3 ammo tiers and 5 ammo categories: low caliber, high caliber, explosive, energy and liquid. Each of those has dedicated production facilities to produce that ammo.
   - Furthermore tier 2 ammo needs special resources for production: fedronite, hazenitem, rhodenite or tanzanite depending on the category. now stockpling these is important.
   - tier 3 ammo is similar and requires rare resources.
   - tier 2 ammo is crafted from tier 1 ammo. tier 3 ammo from tier 2. This means you have to setup production chains
   - higher tier (mech) ammo production is map local. you have to build up a production chain on every map you need it - or bring enough ammo to get through your mission. (originally i failed with map local resources but discovered a bug where at least the mech ammo is map-local)
   - split ammo storages into one for each category. not sure yet, if they should share the same building limit.
   - moved all ammo related buildings (production and storage into an own new category. currently it reuses the ^ upgrade symbol).

 - AI: originally only used by towers, this mod makes coplex industrial production also require ai resource. on the other hand, higher level ai hubs offer significatly more ai, but require cooling. 
	  
 - Buildings  
   - work in progress: building upgrades should be more interesting. for example tier 2 carbonium power plant will now additionally require a catalyst resource, which tier 1 doesn't have. Tier 3 carbonium power does no longer consume deposits but require high tier reagent as additional input. 
   - reworked buildings tiers: carbonium power plant, bio composter, gas power plant, fusion reactor, nuclear plant, morphium power, ai hub, supercoolant refinery, ionizer, strip mine, drill mine, water filtration, gas filtering plant, gas extractors, liquid pumps, uranium centrifuge, ...
   - due to the sheer amount of new buildings, i had to split economy buildings producing solid and liquid resources into different categories

## Weapons
 - higher tier weapons, especially are nerfed compared to their original stats.
 - higher tier weapons and turrents need higher tier ammo
 - most top tier towers are now 2x2 but with with a corresponding firepower boost
 - towers can now block each other, so placement becomes actually relevant
 - higher tier towers now consume a lot more energy, energy based towers consume large armounts of energy per shot on top of that
 - most hier tier towers require some fluid input
 - a new building, the Fire Control Station, allows to shut down all defenses when there is no enemy around saving energy and resources consumption of towers and shield generators.
  
## Difficulty, Waves, Events and Missons
 - complete overhaul of the original attack wave code originally because they were underwhelming in the end game
 - attack waves are split into smaller repeating attacks that can change composition and direction
 - unsually the attack phase lasts longer but also the idle time in between
 - there is a lot more randomization. a certain level of unpredictibility can create very unique experiences even 100h into the game and keep the player on their toes. one attack phase may be quite easy while the next may end up quite hard and vice versa and coincide with events on top
 - oberhauled large parts of events system as well
 - during the attack phases, events are more likely
 - expanded on some existing events that tie to campaign progress e.g. morphium veins may spawn in many biomes late in the game once the player completes metal valley
 - i have changed all the non-outpost missions, so that if you chose to stay on a map longer, it won't be entierly boring
 - after completing a biome, now attack waves from that biome may visit you at other locations (not just your hq)
  
## ToDo
 - post 2.0 patch cleanup: the vanilla game update introduced a lot of new features that need to be incorporated into the mod
 - post 2.0 stability and difficulty fixes
 - fully incorporate the features of this mod into newly generated missions since 2.0 from the orbital scanner
 - balancing: a never ending, ongoing task. weapons, towers, attack waves, resource economy all that is on the agenda, especially after vanilla game changed many stats.

## Remarks
you are free to modify the mod to your own liking for personal use, but please don't republish it under your name. If you want to reuse some of the assets from this mod in your own, feel free but make sure to mention me and this mod as the source.
You can contact me about issues/feedback on Discord. if you encounter crashes, adding your log can really help me to fix them. i am usually watching https://discord.com/channels/423424585954754565/736688063362891860. if you want to get deeper involved, check out github for the mod.
Please note, that due to the extensive changes this mod does to the base game, it will collide with any other mods that change the same files.

## Help
if you like this mod, you can always contribute by reporting any issues: crashes, balancing, weird behavior or just if something is unclear. i try to fix these things.
furthermore as you can see the page for this mod lacks any media - i woudn't mind contributions in this departament showing off some interesting features of this mod i could add here :)

## Links
github:   https://github.com/TheKilltech/rift_balance
mod.io:	  https://mod.io/g/riftbreaker/m/rift-exploration-defense-industry
steam:    https://steamcommunity.com/workshop/filedetails/?id=3598485480
discord:  https://discord.com/channels/423424585954754565/1134827658530803753
