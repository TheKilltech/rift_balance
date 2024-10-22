# Rift Exploration Defense Industry

This mod changes the resource economy of the Riftbreaker campaign, reworking many existing energy and resource buildings but most prominently entierly reworks ammo production. Now powerful weapons (both mech and towers) need a specialized industry to supply them. Also refining rare resources from bio-collectors requires now a multi step process. Overall, maintaining a powerful defense for your outposts won't be such a trivial task anymore and normal difficulty waves might actually prove to be a challenge, when power, ammo and resources aren't easily available in infinite numbers.

Playing Riftbreaker is a greata game but i find the campaign increadibly unchallenging and that diminishes my fun when playing though. And because i can do something about it, i will suffer from sleepless nights if i don't. My short list of observations:
1. in the normal game resources play barely any role except very early on - only the reasearch which unlock a resource has a big impact. we have infinite resource sources, but no adequately sinks for those. That must change
3. Tier upgrades improve everything by at least 100%. That's insane and massively contributing to making all hords trivial to defeat. Expect the nerf hammer.
4. Except for the outpost maps, all other missions are boring but allow us still to build substantial bases producing infinite resources. Have to do something about that.
5. Ammo exists in the game but is irrelevant. Have to fix that.

**Disclaimer**: this is a mod i am making for myself and it is still in a very early development stage. don't complain if stuff is not yet working. currently not all tech is in the tech tree and **survival tech tree is broken** (haven't moved the changed there yet). localization is missing, so this is only english for now. 

## Resources
- Ammo: this mod changes massively how ammo works. All better mech and tower weapons now need hier tier ammunutions.
   - There are not 3 levels. There are 5 ammo categories: low caliber, high caliber, explosive, energy and liquid. Each of those has dedicated production facilities to produce that ammo.
   - Furthermore tier 2 ammo needs special resources for production: fedronite, hazenitem, rhodenite or tanzanite depending on the category. now stockpling these is important.
   - tier 3 ammo is similar and requires rare resources.
   - tier 2 ammo is crafted from tier 1 ammo. same for tier 3 ammo. This means you have to setup production chains
   - higher tier ammo production is map local. you have to build up a production chain on every map you need it - or bring enough ammo to get through your mission. (i couldn't make this feature, but then i discovered that because of a bug, it is already kind of that way)
   - split ammo storages into one for each category. not sure yet, if they should share the same building limit.
   - moved all ammo related buildings (production and storage into an own new category. currently it reuses the ^ upgrade symbol).
    
 - AI: originally only used by towers, this mod makes coplex industrial production also require ai resource. on the other hand, higher level ai hubs offer significatly more ai, but require cooling. 
	
 - Resources: cultivators are an infinite entierly automated infinite source and they are very powerful compared to mines.
   - added bio-resources replacing the direct rare resource yield from cultivators. those bio resources require additional processing steps to refine them into palladium, titanium, uranium ore or cobalt.
   - the refining involves a new pipe-resource reagent. it is refined from plant biomass mostly.
   - different types of biomass have become quite important to some production chains
   - added new nitic acid fluid involved in production chains of most ammo types. uses animal biomass and hazenite.
  
 - Building Updates  
   - work in progress: building upgrades should be more interesting. for example tier 2 carbonium power plant will now additionally require cooling, which tier 1 doesn't have. The additional trouble will come at significant power output increase. Tier 3 only accepts supercoolant for cooling. reworked buildings: carbonium power plant, bio composter, gas power plant, fusion reactor, ai hub, supercoolant refinery, ionizer

## Weapons
 - higher tier weapons, especially are nerfed to the ground compared to their original stats. top tier towers nerfed also a little.
 - higher tier weapons and turrents need higher tier ammo
 - towers can now block each other, so placement becomes actually relevant
 - higher tier towers now consume a lot more energy.
 - energy based towers consume large armounts of energy per shot on top of that.
  
## Missions
 - i have changed all the non-outpost missions, so that if you chose on a map longer, it won't be entierly boring
 - started to adjust the events manager to produce more randoness in events, partiularly create 1 in a 100 rare random events where every everything bad happens all at once. a certain level of unpredictibility can create very unique experiences even 100h into the game and keep the player on their toes.
  
## ToDo
 - so far i have been just warming up and testing things. so expect major changes. don't wont to start certain things before the devs haven't realeased their difficulty improvements and multiplayer.
 - test friendly fire. hope the devs implement it is as a custom game setting though
 - rework building upgrages:
   - change level 3 nuclear reactor to use molten salt reactor (reagent + bio-uranium => liquid uranium)
   - rework of morphium buildings
   - rework plasma towers
 - add nitrate as resource & surface deposit (alternate option to produce nitric acid)
 - add underground deposits (ironium, uranium, palladium, titanium, nitrate) which need a dedicated mine. swap to one mine for all surface deposits
 - change campaign maps resource deposits
 - bio-ironium
 - pimp building visuals
 - improve icons and visuals of entities added by the mod
 - nerf higher tier mech equipment 

## Remarks
you are free to modify the mod to your own liking for personal use, but please don't republish it under your name. If you want to reuse some of the assets from this mod in your own, feel free but make sure to mention me and this mod as the source.

You can contact me about issues/feedback the mod on Discord. i am usually watching https://discord.com/channels/423424585954754565/736688063362891860

Please note, that due to the extensive changes this mod does to the base game, it will collide with any other mods that change the same files. 

## Links
github repository for the mod: https://github.com/TheKilltech/rift_balance
mod.io page: https://mod.io/g/riftbreaker/m/rift-exploration-defense-industry
discord feedback thread: https://discord.com/channels/423424585954754565/1020353928476508210/threads/1134827658530803753

Recommended mods:
Rebalenced Energy Walls https://mod.io/g/riftbreaker/m/distributed-force-energy-walls