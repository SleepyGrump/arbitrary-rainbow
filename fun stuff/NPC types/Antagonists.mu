/*
This absolutely requires you to already have installed NPCs - AKA Critters 2.0.mu. If you haven't, stop now and go back!

*/

@create Antagonists=10
@force me=&d.antagonists me=[search(name=Antagonists)]
@wait 1=@set [v(d.antagonists)]=SAFE INHERIT
@wait 1=@force me=@parent [v(d.antagonists)]=[v(d.npcs)]
@wait 1=@tel [v(d.antagonists)]=[v(d.npcs)]

@@ ========================================================================= @@

&stat_categories [v(d.antagonists)]=General Pools|Combat Pools

&stats [v(d.antagonists)]=Concept|Size|Species Factor|Willpower|Defense|Initiative|Intelligence|Wits|Resolve|Strength|Dexterity|Stamina|Presence|Manipulation|Composure

&required-stats [v(d.antagonists)]=Concept

&non-numeric_stats [v(d.antagonists)]=Concept

&non-numeric_stat_categories [v(d.antagonists)]=

&willpower [v(d.antagonists)]=0

@set [v(d.antagonists)]/willpower=VISUAL

&f.get-speed [v(d.antagonists)]=default(speed, ulocal(f.get-trait, strength, dexterity, ulocal(f.get-species-factor)))

&f.get-defense [v(d.antagonists)]=default(defense, add(min(default(wits, 1), default(dexterity, 1)), first(default(athletics, 0), |)))

&f.get-health [v(d.antagonists)]=default(health, add(ulocal(f.get-size), default(stamina, 1)))

&f.get-willpower [v(d.antagonists)]=default(willpower, 0)

&f.get-initiative [v(d.antagonists)]=default(initiative, ulocal(f.get-trait, dexterity, composure))

&layout.one-pool [v(d.antagonists)]=if(t(%0), strcat(setq(0, sub(width(%#), 5)), %r, iter(%0, strcat(space(3), ljust(ulocal(f.attribute_list_to_name, itext(0), 1, 1)%b, sub(sub(%q0, 2), strlen(setr(1, default(itext(0), 0)))), .), %b, %q1),, %r)))

&layout.pools [v(d.antagonists)]=strcat(%r, wdivider(General Dice Pools), ulocal(layout.one-pool, lattrp(me/general_pools-*)), %r, wdivider(Combat Dice Pools), ulocal(layout.one-pool, lattrp(me/combat_pools-*)))

&layout.advantages [v(d.antagonists)]=strcat(%r, wdivider(Advantages), %r, ulocal(layout.row, Willpower, ulocal(f.get-willpower), Health, ulocal(f.get-health), Initiative, ulocal(f.get-initiative)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-speed), Size, ulocal(f.get-size)))

@desc [v(d.antagonists)]=if(t(lcon(me)), ulocal(layout.container), strcat(ulocal(layout.header, Concept), ulocal(layout.attributes), ulocal(layout.pools), ulocal(layout.advantages), ulocal(layout.sheet-bottom-notes, Notes)))

@@ Checks go below...

&check-general_pools [v(d.antagonists)]=if(not(t(lattrp(me/general_pools-*))), You should put some general pools in there.)

&check-combat_pools [v(d.antagonists)]=if(not(t(lattrp(me/combat_pools-*))), You should put some combat pools in there.)

&check-willpower [v(d.antagonists)]=if(cor(gt(setr(0, default(willpower, 0)), 3), eq(%q0, 0)), Antagonist willpower should generally be between 0 and 3 - 0 for no-name one-shot NPCs%, and 1-3 for named NPCs. Yours is %q0. [if(eq(%q0, 0), This message is just to let you know that it can be set if you like!)])
