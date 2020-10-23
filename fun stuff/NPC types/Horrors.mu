/*
This absolutely requires you to already have installed NPCs - AKA Critters 2.0.mu. If you haven't, stop now and go back!

*/

@create Horrors=10
@force me=&d.Horrors me=[search(name=Horrors)]
@wait 1=@set [v(d.horrors)]=SAFE INHERIT
@wait 1=@force me=@parent [v(d.horrors)]=[v(d.npcs)]
@wait 1=@tel [v(d.horrors)]=[v(d.npcs)]

@@ ========================================================================= @@

&stat_categories [v(d.horrors)]=Dread Power|Merit|Specialty|Influence|Numina

&stats [v(d.horrors)]=Concept|Aspiration|Potency|Virtue|Vice|Ban|Bans|Banes|Intelligence|Wits|Resolve|Strength|Dexterity|Stamina|Presence|Manipulation|Composure|Academics|Athletics|Animal Ken|Computer|Brawl|Empathy|Crafts|Drive|Expression|Investigation|Firearms|Intimidation|Medicine|Larceny|Persuasion|Occult|Stealth|Socialize|Politics|Survival|Streetwise|Science|Weaponry|Subterfuge|Size|Species Factor|Willpower|Speed|Health|Initiative|Defense|Integrity|Harmony|Humanity|Clarity

&required-stats [v(d.horrors)]=Concept|Aspiration|Virtue|Vice|Potency|Intelligence|Wits|Resolve|Strength|Dexterity|Stamina|Presence|Manipulation|Composure

&non-numeric_stats [v(d.horrors)]=Concept|Aspiration|Virtue|Vice|Ban|Bans|Banes

&non-numeric_stat_categories [v(d.horrors)]=Specialty

&list-specialty [v(d.horrors)]=Academics|Athletics|Animal Ken|Computer|Brawl|Empathy|Crafts|Drive|Expression|Investigation|Firearms|Intimidation|Medicine|Larceny|Persuasion|Occult|Stealth|Socialize|Politics|Survival|Streetwise|Science|Weaponry|Subterfuge

&list-dread_power [v(d.horrors)]=Beastmaster|Chameleon Horror|Discorporate|Eye Spy|Fire Elemental|Gremlin|Home Ground|Hunter's Senses|Hypnotic Gaze|Immortal|Jump Scare|Prodigious Leap|Madness and Terror|Maze|Miracle|Mist Form|Natural Weapons|Know Soul|Reality Stutter|Regenerate|Snare|Skin-taker|Soul Thief|Surprise Entrance|Toxic|Unbreakable|Wall Climb

&list-numina [v(d.horrors)]=Aggressive Meme|Awe|Blast|Dement|Drain|Emotional Aura|Essence Thief|Fate Sense|Firestarter|Host Jump|Implant Mission|Innocuous|Left-Handed Spanner|Mortal Mask|Omen Trance|Pathfinder|Rapture|Regenerate|Resurrection|Seek|Speed|Sign|Stalwart|Telekinesis

&list-regenerate [v(d.horrors)]=1|2|3|4|5

&list-natural_weapons [v(d.horrors)]=1|2|3

&list-toxic [v(d.horrors)]=1|2

&potency [v(d.horrors)]=1

@set [v(d.horrors)]/potency=VISUAL

&f.get-speed [v(d.horrors)]=default(speed, ulocal(f.get-trait, strength, dexterity, ulocal(f.get-species-factor)))

&f.get-defense [v(d.horrors)]=default(defense, add(min(default(wits, 1), default(dexterity, 1)), default(athletics, 0)))

&f.get-health [v(d.horrors)]=default(health, ulocal(f.get-trait, size, stamina))

&f.get-willpower [v(d.horrors)]=default(willpower, ulocal(f.get-trait, resolve, composure, default(potency, 1)))

&f.get-initiative [v(d.horrors)]=default(initiative, ulocal(f.get-trait, dexterity, composure))

&layout.skill_list [v(d.horrors)]= edit(itemize(trim(%0, b, |), |), %band%b, %,%b, :,, %,%,, %,)

&layout.skills [v(d.horrors)]=if(t(ladd(iter(Academics|Athletics|Animal Ken|Computer|Brawl|Empathy|Crafts|Drive|Expression|Investigation|Firearms|Intimidation|Medicine|Larceny|Persuasion|Occult|Stealth|Socialize|Politics|Survival|Streetwise|Science|Weaponry|Subterfuge, hasattrp(me, itext(0)), |))), strcat(%r, wdivider(Skills, %#), %r, null(iter(Academics|Computer|Crafts|Investigation|Medicine|Occult|Politics|Science, if(t(default(itext(0), 0)), setq(0, strcat(%q0, |, ulocal(layout.skill, itext(0))))), |, @@)), null(iter(Athletics|Brawl|Drive|Firearms|Larceny|Stealth|Survival|Weaponry, if(t(default(itext(0), 0)), setq(1, strcat(%q1, |, ulocal(layout.skill, itext(0))))), |, @@)), null(iter(Animal Ken|Empathy|Expression|Intimidation|Persuasion|Socialize|Streetwise|Subterfuge, if(t(default(itext(0), 0)), setq(2, strcat(%q2, |, ulocal(layout.skill, itext(0))))), |, @@)), setq(0, ulocal(layout.skill_list, %q0)), setq(1, ulocal(layout.skill_list, %q1)), setq(2, ulocal(layout.skill_list, %q2)), squish(trim(strcat(if(t(%q0), ulocal(layout.note, Mental Skills, %q0, 17)%r), if(t(%q1), ulocal(layout.note, Physical Skills, %q1, 17)%r), if(t(%q2), ulocal(layout.note, Social Skills, %q2, 17))), b, %r), %r)))

&layout.morality [v(d.horrors)]=iter(Integrity Humanity Harmony Clarity, if(hasattrp(me, itext(0)), strcat(%r, ulocal(layout.row, itext(0), default(itext(0), 0)))),, @@)

&layout.merits [v(d.horrors)]=if(t(lattrp(me/merit-*)), strcat(%r, wdivider(Merits), %r, ulocal(layout.list-one-column, lattrp(me/merit-*))))

&layout.advantages [v(d.horrors)]=strcat(%r, wdivider(Advantages), %r, ulocal(layout.row, Willpower, ulocal(f.get-willpower), Health, ulocal(f.get-health), Initiative, ulocal(f.get-initiative)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-speed), Size, ulocal(f.get-size)), ulocal(layout.morality))

@desc [v(d.horrors)]=if(t(lcon(me)), ulocal(layout.container), strcat(ulocal(layout.header, Concept|Aspiration|Virtue|Vice|Ban`|Bans`|Banes`|Potency), ulocal(layout.attributes), ulocal(layout.skills), ulocal(layout.sheet-section, Influences, influence), ulocal(layout.sheet-section, Dread Powers, dread_power, 1), ulocal(layout.sheet-section, Numina), ulocal(layout.merits), ulocal(layout.advantages), ulocal(layout.sheet-bottom-notes, Notes)))

@@ Checks go below...

&check-traits [v(d.horrors)]=iter(Intelligence|Wits|Resolve|Strength|Dexterity|Stamina|Presence|Manipulation|Composure|Academics|Athletics|Animal Ken|Computer|Brawl|Empathy|Crafts|Drive|Expression|Investigation|Firearms|Intimidation|Medicine|Larceny|Persuasion|Occult|Stealth|Socialize|Politics|Survival|Streetwise|Science|Weaponry|Subterfuge, if(t(setr(0, ulocal(trait-test, itext(0)))), %q0), |, |)

&trait-test [v(d.horrors)]=if(gt(default(%0, 0), setr(1, case(setr(0, default(potency, 1)), 1, 5, 2, 6, 3, 7, 4, 8, 5, 9, 10))), Max [titlestr(%0)] for Potency %q0 is %q1.)

&check-traits-max [v(d.horrors)]=strcat(setq(0, ladd(iter(Intelligence Wits Resolve Strength Dexterity Stamina Presence Manipulation Composure, default(itext(0), 1)) -9)), setq(2, case(setr(1, default(potency, 1)), 1, 18, 2, 22, 3, 26, 4, 30, 5, 34, 6, 38, 7, 42, 8, 46, 9, 50, 10, 1000)), if(gt(%q0, %q2), Potency %q1 horrors may not have a total sum of Attribute dots above %q2. You have a total of %q0.))

&check-traits-min [v(d.horrors)]=strcat(setq(0, ladd(iter(Intelligence Wits Resolve Strength Dexterity Stamina Presence Manipulation Composure, default(itext(0), 1)) -9)), setq(2, case(setr(1, default(potency, 1)), 1, 15, 2, 19, 3, 23, 4, 27, 5, 31, 6, 35, 7, 39, 8, 43, 9, 47, 51)), if(lt(%q0, %q2), Potency %q1 horrors may not have a total sum of Attribute dots fewer than %q2. You have a total of %q0.))

&check-skill-max [v(d.horrors)]=strcat(setq(0, ladd(iter(Academics|Athletics|Animal Ken|Computer|Brawl|Empathy|Crafts|Drive|Expression|Investigation|Firearms|Intimidation|Medicine|Larceny|Persuasion|Occult|Stealth|Socialize|Politics|Survival|Streetwise|Science|Weaponry|Subterfuge, default(itext(0), 0), |))), setq(2, add(mul(setr(1, default(potency, 1)), 5), 5)), if(gt(%q0, %q2), Potency %q1 horrors may not have a total sum of Skill dots above %q2. You have a total of %q0.))

&check-merit-max [v(d.horrors)]=strcat(setq(0, ladd(iter(lattrp(me/merit-*), default(itext(0), 0)))), setq(2, add(mul(setr(1, default(potency, 1)), 2), 1)), if(gt(%q0, %q2), Potency %q1 horrors may not have a total sum of Merit dots above %q2. You have a total of %q0.))

&check-dread_powers [v(d.horrors)]=strcat(setq(0, ladd(strcat(iter(lattrp(me/dread_power-*), default(itext(0), 0)), %b, iter(lattrp(me/numina-*), default(itext(0), 0)), %b, iter(lattrp(me/influence-*), default(itext(0), 0))))), setq(2, case(setr(1, default(potency, 1)), 1, 3, 2, 3, 3, 3, 4, 4, 5, 4, 6, 4, 7, 5, 8, 6, 9, 7, 8)), if(neq(%q0, %q2), Potency %q1 horrors should have a total sum of Dread Power%, %Influence%, and Numina dots of %q2. You have a total of %q0.))

&check-skills-min [v(d.horrors)]=if(lt(setr(1, ladd(iter(Academics|Athletics|Animal Ken|Computer|Brawl|Empathy|Crafts|Drive|Expression|Investigation|Firearms|Intimidation|Medicine|Larceny|Persuasion|Occult|Stealth|Socialize|Politics|Survival|Streetwise|Science|Weaponry|Subterfuge, default(itext(0), 0), |))), setr(0, add(mul(default(potency, 1), 5), 5))), By the book you can have up to %q0 points of Skills. You have %q1. You can do fewer if you want to%, this is just a notification!)

&check-merits-min [v(d.horrors)]=if(lt(setr(1, ladd(iter(lattrp(me/merit-*), v(itext(0))))), setr(0, add(mul(default(potency, 1), 2), 1))), By the book you can have up to %q0 points of Merits. You have %q1. You can do fewer if you want to%, this is just a notification!)
