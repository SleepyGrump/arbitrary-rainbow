/*
This absolutely requires you to already have installed NPCs - AKA Critters 2.0.mu. If you haven't, stop now and go back!

Concept:
Type: Minion / Horde / Lone Terror
Dice Pools Chart on pg 143
General dice pools:
Combat dice pools:
Best dice pool (calculated)
Worst dice pool (Calculated)
Willpower
Dread powers: list

*/

@create Brief Nightmares=10
@force me=&d.brief_nightmares me=[search(name=Brief Nightmares)]
@wait 1=@set [v(d.brief_nightmares)]=SAFE INHERIT
@wait 1=@force me=@parent [v(d.brief_nightmares)]=[v(d.npcs)]
@wait 1=@tel [v(d.brief_nightmares)]=[v(d.npcs)]

@@ ========================================================================= @@

&stat_categories [v(d.brief_nightmares)]=Dread Power|Influence|Numina|Good Pools|Bad Pools|Other Pools

&stats [v(d.brief_nightmares)]=Concept|Aspiration|Type|Size|Species Factor|Willpower|Speed|Health|Initiative|Defense|Best Dice Pools|Worst Dice Pools|All Other Pools

&required-stats [v(d.brief_nightmares)]=Concept|Aspiration|Type

&non-numeric_stats [v(d.brief_nightmares)]=Concept|Aspiration|Type

&non-numeric_stat_categories [v(d.brief_nightmares)]=

&list-type [v(d.brief_nightmares)]=Minion|Horde|Lone Terror

&list-dread_power [v(d.brief_nightmares)]=Beastmaster|Chameleon Horror|Discorporate|Eye Spy|Fire Elemental|Gremlin|Home Ground|Hunter's Senses|Hypnotic Gaze|Immortal|Jump Scare|Prodigious Leap|Madness and Terror|Maze|Miracle|Mist Form|Natural Weapons|Know Soul|Reality Stutter|Regenerate|Snare|Skin-taker|Soul Thief|Surprise Entrance|Toxic|Unbreakable|Wall Climb

&list-numina [v(d.brief_nightmares)]=Aggressive Meme|Awe|Blast|Dement|Drain|Emotional Aura|Essence Thief|Fate Sense|Firestarter|Host Jump|Implant Mission|Innocuous|Left-Handed Spanner|Mortal Mask|Omen Trance|Pathfinder|Rapture|Regenerate|Resurrection|Seek|Speed|Sign|Stalwart|Telekinesis

&list-regenerate [v(d.brief_nightmares)]=1|2|3|4|5

&list-natural_weapons [v(d.brief_nightmares)]=1|2|3

&list-toxic [v(d.brief_nightmares)]=1|2

&layout.skill_list [v(d.brief_nightmares)]= edit(itemize(trim(%0, b, |), |), %band%b, %,%b, :,, %,%,, %,)

@@ %0 - the target object.
@@ %1 - the value the stat is being set to.
&tr.type [v(d.brief_nightmares)]=@set %0=best_dice_pools:[switch(%1, Minion, 5, Horde, 7, Lone Terror, 10)]; @set %0=worst_dice_pools:[switch(%1, Minion, 0, Horde, 1, Lone Terror, 2)]; @set %0=all_other_pools:[switch(%1, Minion, 2, Horde, 3, Lone Terror, 5)]; @set %0=willpower:[switch(%1, Minion, 2, Horde, 3, Lone Terror, 6)];

&type [v(d.brief_nightmares)]=Minion

@set [v(d.brief_nightmares)]/type=VISUAL

&best_dice_pools [v(d.brief_nightmares)]=5

@set [v(d.brief_nightmares)]/best_dice_pools=VISUAL

&worst_dice_pools [v(d.brief_nightmares)]=0

@set [v(d.brief_nightmares)]/worst_dice_pools=VISUAL

&all_other_pools [v(d.brief_nightmares)]=2

@set [v(d.brief_nightmares)]/all_other_pools=VISUAL

&willpower [v(d.brief_nightmares)]=2

@set [v(d.brief_nightmares)]/willpower=VISUAL

&f.get-speed [v(d.brief_nightmares)]=default(speed, add(default(all_other_pools,0), 5))

&f.get-defense [v(d.brief_nightmares)]=default(defense, default(all_other_pools, 0))

&f.get-health [v(d.brief_nightmares)]=default(health, add(default(best_dice_pools, 0), 2))

&f.get-willpower [v(d.brief_nightmares)]=default(willpower, 0)

&f.get-initiative [v(d.brief_nightmares)]=default(initiative, default(all_other_pools, 0))

&layout.one-pool [v(d.brief_nightmares)]=if(t(%0), strcat(setq(0, sub(width(%#), 5)), %r, iter(%0, strcat(space(3), ljust(ulocal(f.attribute_list_to_name, itext(0), 1, 1)%b, sub(sub(%q0, 2), strlen(setr(1, switch(first(itext(0), -), good*, default(best_dice_pools, 0), bad*, default(worst_dice_pools, 0), default(all_other_pools, 0))))), .), %b, %q1),, %r)))

&layout.pools [v(d.brief_nightmares)]=strcat(%r, wdivider(Pools), %r, ulocal(layout.row, Best Dice Pools, default(best_dice_pools, 0), Worst Dice Pools, default(worst_dice_pools, 0), Other Dice Pools, default(all_other_pools, 0)), ulocal(layout.one-pool, lattrp(me/good_pools-*)), ulocal(layout.one-pool, lattrp(me/bad_pools-*)), ulocal(layout.one-pool, lattrp(me/other_pools-*)))

&layout.advantages [v(d.brief_nightmares)]=strcat(%r, wdivider(Advantages), %r, ulocal(layout.row, Willpower, ulocal(f.get-willpower), Health, ulocal(f.get-health), Initiative, ulocal(f.get-initiative)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-speed), Size, ulocal(f.get-size)))

@desc [v(d.brief_nightmares)]=if(t(lcon(me)), ulocal(layout.container), strcat(ulocal(layout.header, Concept|Aspiration|Type), ulocal(layout.pools), ulocal(layout.sheet-section, Influences, influence), ulocal(layout.sheet-section, Dread Powers, dread_power, 1), ulocal(layout.sheet-section, Numina), ulocal(layout.advantages), ulocal(layout.sheet-bottom-notes, Notes)))

@@ Checks go below...

&check-good_pools [v(d.brief_nightmares)]=if(not(t(lattrp(me/good_pools-*))), You should put some good pools in there.)

&check-bad_pools [v(d.brief_nightmares)]=if(not(t(lattrp(me/bad_pools-*))), You should put some bad pools in there.)

&check-dread_powers [v(d.brief_nightmares)]=strcat(setq(0, ladd(strcat(iter(lattrp(me/dread_power-*), default(itext(0), 0)), %b, iter(lattrp(me/numina-*), default(itext(0), 0)), %b, iter(lattrp(me/influence-*), default(itext(0), 0))))), setq(2, case(setr(1, default(type, Minion)), Minion, 3, Horde, 5, Lone Terror, 7)), if(neq(%q0, %q2), %q1 horrors should have a total sum of Dread Power%, %Influence%, and Numina dots of %q2. You have a total of %q0.))
