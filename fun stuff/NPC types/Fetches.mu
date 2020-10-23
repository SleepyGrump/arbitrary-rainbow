/*
This absolutely requires you to already have installed NPCs - AKA Critters 2.0.mu. If you haven't, stop now and go back!

*/

@create Fetches=10
@force me=&d.fetches me=[search(name=Fetches)]
@wait 1=@set [v(d.fetches)]=SAFE INHERIT
@wait 1=@force me=@parent [v(d.fetches)]=[v(d.npcs)]
@wait 1=@tel [v(d.fetches)]=[v(d.npcs)]

@@ ========================================================================= @@

&stat_categories [v(d.fetches)]=Merit|Specialty|Echo

&stats [v(d.fetches)]=Wyrd|Virtue|Vice|Size|Species Factor|Willpower|Speed|Defense|Health|Initiative|Intelligence|Wits|Resolve|Strength|Dexterity|Stamina|Presence|Manipulation|Composure|Academics|Athletics|Animal Ken|Computer|Brawl|Empathy|Crafts|Drive|Expression|Investigation|Firearms|Intimidation|Medicine|Larceny|Persuasion|Occult|Stealth|Socialize|Politics|Survival|Streetwise|Science|Weaponry|Subterfuge

&required-stats [v(d.fetches)]=

&non-numeric_stats [v(d.fetches)]=Virtue|Vice

&non-numeric_stat_categories [v(d.fetches)]=Specialty

&list-echo [v(d.fetches)]=Attuned to the Wyrd|Call the Huntsman|Death of Glamour|Enter the Hedge|Heart of Wax|Mimic Contract|Normalcy|Shadow Boxing|Shadow Step|Summon Shard

&list-specialty [v(d.fetches)]=Academics|Athletics|Animal Ken|Computer|Brawl|Empathy|Crafts|Drive|Expression|Investigation|Firearms|Intimidation|Medicine|Larceny|Persuasion|Occult|Stealth|Socialize|Politics|Survival|Streetwise|Science|Weaponry|Subterfuge

&echo-attuned_to_the_wyrd [v(d.fetches)]=1

@set [v(d.fetches)]/echo-attuned_to_the_wyrd=VISUAL

&wyrd [v(d.fetches)]=1

@set [v(d.fetches)]/wyrd=VISUAL

&f.get-speed [v(d.fetches)]=default(speed, ulocal(f.get-trait, strength, dexterity, ulocal(f.get-species-factor)))

&f.get-defense [v(d.fetches)]=default(defense, add(min(default(wits, 1), default(dexterity, 1)), first(default(athletics, 0), |)))

&f.get-health [v(d.fetches)]=default(health, ulocal(f.get-trait, size, stamina))

&f.get-willpower [v(d.fetches)]=default(willpower, ulocal(f.get-trait, resolve, composure))

&f.get-initiative [v(d.fetches)]=default(initiative, ulocal(f.get-trait, dexterity, composure))

&layout.one-pool [v(d.fetches)]=if(t(%0), strcat(setq(0, sub(width(%#), 5)), %r, iter(%0, strcat(space(3), ljust(ulocal(f.attribute_list_to_name, itext(0), 1, 1)%b, sub(sub(%q0, 2), strlen(setr(1, default(itext(0), 0)))), .), %b, %q1),, %r)))

&layout.pools [v(d.fetches)]=strcat(%r, wdivider(General Dice Pools), ulocal(layout.one-pool, lattrp(me/general_pools-*)), %r, wdivider(Combat Dice Pools), ulocal(layout.one-pool, lattrp(me/combat_pools-*)))

&layout.skill_list [v(d.fetches)]= edit(itemize(trim(%0, b, |), |), %band%b, %,%b, :,, %,%,, %,)

&layout.skills [v(d.fetches)]=if(t(ladd(iter(Academics|Athletics|Animal Ken|Computer|Brawl|Empathy|Crafts|Drive|Expression|Investigation|Firearms|Intimidation|Medicine|Larceny|Persuasion|Occult|Stealth|Socialize|Politics|Survival|Streetwise|Science|Weaponry|Subterfuge, hasattrp(me, itext(0)), |))), strcat(%r, wdivider(Skills, %#), %r, null(iter(Academics|Computer|Crafts|Investigation|Medicine|Occult|Politics|Science, if(t(default(itext(0), 0)), setq(0, strcat(%q0, |, ulocal(layout.skill, itext(0))))), |, @@)), null(iter(Athletics|Brawl|Drive|Firearms|Larceny|Stealth|Survival|Weaponry, if(t(default(itext(0), 0)), setq(1, strcat(%q1, |, ulocal(layout.skill, itext(0))))), |, @@)), null(iter(Animal Ken|Empathy|Expression|Intimidation|Persuasion|Socialize|Streetwise|Subterfuge, if(t(default(itext(0), 0)), setq(2, strcat(%q2, |, ulocal(layout.skill, itext(0))))), |, @@)), setq(0, ulocal(layout.skill_list, %q0)), setq(1, ulocal(layout.skill_list, %q1)), setq(2, ulocal(layout.skill_list, %q2)), squish(trim(strcat(if(t(%q0), ulocal(layout.note, Mental Skills, %q0, 17)%r), if(t(%q1), ulocal(layout.note, Physical Skills, %q1, 17)%r), if(t(%q2), ulocal(layout.note, Social Skills, %q2, 17))), b, %r), %r)))

&layout.merits [v(d.fetches)]=if(t(lattrp(me/merit-*)), strcat(%r, wdivider(Merits), %r, ulocal(layout.list-one-column, lattrp(me/merit-*))))

&layout.advantages [v(d.fetches)]=strcat(%r, wdivider(Advantages), %r, ulocal(layout.row, Willpower, ulocal(f.get-willpower), Health, ulocal(f.get-health), Initiative, ulocal(f.get-initiative)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-speed), Size, ulocal(f.get-size)))

@desc [v(d.fetches)]=if(t(lcon(me)), ulocal(layout.container), strcat(ulocal(layout.header, Virtue|Vice|Wyrd), ulocal(layout.attributes), ulocal(layout.skills), ulocal(layout.merits), ulocal(layout.sheet-section, Echoes, echo, 1), ulocal(layout.advantages), ulocal(layout.sheet-bottom-notes, Notes)))

@@ Checks go below...

&check-echoes [v(d.fetches)]=if(neq(setr(1, words(lattrp(me/echo-*))), setr(0, add(default(wyrd, 1), 1))), You should have %q0 Echoes at this Fetch's Wyrd. Instead you have %q1.)

&check-echo_wyrd_5 [v(d.fetches)]=if(and(hasattrp(me, echo-call_the_huntsman), lt(default(wyrd, 1), 5)), The Fetch must be at least Wyrd 5 to have the Echo Call the Huntsman.)

&check-echo_wyrd_4 [v(d.fetches)]=if(and(hasattrp(me, echo-death_of_glamour), lt(default(wyrd, 1), 4)), The Fetch must be at least Wyrd 4 to have the Echo Death of Glamour.)

&check-echo_wyrd_3 [v(d.fetches)]=if(and(hasattrp(me, echo-death_of_glamour), lt(default(wyrd, 1), 3)), The Fetch must be at least Wyrd 3 to have the Echo Shadow Step.)

&check-echo_wyrd_2 [v(d.fetches)]=if(and(cor(hasattrp(me, echo-mimic_contract), hasattrp(me, echo-shadow_boxing)), lt(default(wyrd, 1), 2)), The Fetch must be at least Wyrd 2 to have the Echoes Mimic Contract or Shadow Boxing.)
