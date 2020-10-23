/*
This absolutely requires you to already have installed NPCs - AKA Critters 2.0.mu. If you haven't, stop now and go back!
*/

@create Spirits=10
@force me=&d.Spirits me=[search(name=Spirits)]
@wait 1=@set [v(d.spirits)]=SAFE INHERIT
@wait 1=@force me=@parent [v(d.spirits)]=[v(d.npcs)]
@wait 1=@tel [v(d.spirits)]=[v(d.npcs)]

@@ ========================================================================= @@

&stat_categories [v(d.spirits)]=Influence|Manifestation|Numina

&list-numina [v(d.spirits)]=Aggressive Meme|Awe|Blast|Dement|Drain|Emotional Aura|Essence Thief|Fate Sense|Firestarter|Hallucination|Host Jump|Implant Mission|Innocuous|Left-Handed Spanner|Mortal Mask|Omen Trance|Pathfinder|Rapture|Regenerate|Resurrection|Seek|Speed|Sign|Stalwart|Telekinesis

&list-manifestation [v(d.spirits)]=Twilight Form|Discorporate|Reaching|Gauntlet Breach|Avernian Gateway|Shadow Gateway|Image|Materialize|Fetter|Unfetter|Possess|Claim

&stats [v(d.spirits)]=Rank|Concept|Aspiration|Power|Finesse|Resistance|Essence|Size|Species Factor|Ban|Bane|Totem Benefits|Totem Points

&required-stats [v(d.spirits)]=Rank|Concept|Aspiration|Power|Finesse|Resistance|Ban|Bane

&non-numeric_stats [v(d.spirits)]=Concept|Aspiration|Ban|Bane|Totem Benefits

&manifestation-twilight_form [v(d.spirits)]=1

@set [v(d.spirits)]/manifestation-twilight_form=VISUAL

&f.get-defense [v(d.spirits)]=default(defense, if(hasattr(me, numina-stalwart), default(resistance, 0), if(lte(default(rank, 0), 1), max(default(power, 0), default(finesse, 0)), min(default(power, 0), default(finesse, 0)))))

&f.get-size [v(d.spirits)]=default(size, default(rank, 1))

&f.get-species-factor [v(d.spirits)]=default(species_factor, default(rank, 1))

@@ %0 - the target object.
@@ %1 - the value the stat is being set to.
&tr.totem_points [v(d.spirits)]=@set %0=rank:[case(1, gte(%1, 36), 5, gte(%1, 26), 4, gte(%1, 15), 3, gte(%1, 9), 2, gte(%1, 5), 1, 0)]; @set %0=essence:%1;

&layout.name [v(d.spirits)]=strcat(name(me), %b-%b, switch(default(rank, 0), 4, Ensah %(Rank 4%), 3, Ensih %(Rank 3%), 2, Hursih %(Rank 2%), 1, Hursih %(Rank 1%), 0, Muthra %(Rank 0%), Dihir %(Rank 5+%)), %b-%b, num(me))

&layout.advantages [v(d.spirits)]=strcat(%r, wdivider(Advantages), %r, ulocal(layout.row, Essence, default(essence, 0), Size, ulocal(f.get-size), Species factor, ulocal(f.get-species-factor)), %r, ulocal(layout.row, Willpower, ulocal(f.get-trait, resistance, finesse), Corpus, add(default(resistance, 1), ulocal(f.get-size)), Initiative, ulocal(f.get-trait, finesse, resistance)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-trait, power, finesse, ulocal(f.get-species-factor))))

@desc [v(d.spirits)]=if(t(lcon(me)), ulocal(layout.container, 2), strcat(ulocal(layout.header, Concept|Aspiration|Ban|Bane|Totem Points`, ulocal(layout.name)), ulocal(layout.ephemeral_attributes), ulocal(layout.advantages), ulocal(layout.sheet-section, Influences, influence, 1), ulocal(layout.sheet-section, Manifestations, manifestation, 1, 1), ulocal(layout.sheet-section, Numina,, 1), ulocal(layout.sheet-bottom-notes, Notes)))

@@ Spirit checks

&check-essence [v(d.spirits)]=if(t(setr(3, default(totem_points, 0))),if(neq(default(essence, 0), %q3), Don't forget to set this entity's Essence to the number of Totem Points you spent on it%, %q3.), if(gt(setr(2, default(essence, 0)), setr(1, case(setr(0, default(rank, 0)), 0, 5, 1, 10, 2, 15, 3, 20, 4, 25, 5, 50))), Max essence for Rank %q0 is %q1. You have %q2 essence., if(eq(%q2, 0), Don't forget to set an Essence score. The max for this entity's rank is %q0.)))

&check-traits [v(d.spirits)]=iter(Power Finesse Resistance, if(t(setr(0, ulocal(trait-test, itext(0)))), %q0),, |)

&trait-test [v(d.spirits)]=if(t(default(totem_points, 0)),, if(gt(default(%0, 0), setr(1, case(setr(0, default(rank, 0)), 0, 0, 1, 5, 2, 7, 3, 9, 4, 12, 5, 15))), Max [titlestr(%0)] for Rank %q0 is %q1.))

&check-traits-max [v(d.spirits)]=if(t(default(totem_points, 0)),, strcat(setq(0, add(default(Power, 0), default(Finesse, 0), default(Resistance, 0))), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 8, 2, 14, 3, 25, 4, 35, 5, 45)), if(gt(%q0, %q2), Rank %q1 spirits may not have a total sum of Power%, Finesse%, and Resistance dots above %q2. You have a total of %q0.)))

&check-traits-min [v(d.spirits)]=if(t(default(totem_points, 0)),, strcat(setq(0, add(default(Power, 0), default(Finesse, 0), default(Resistance, 0))), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 5, 2, 9, 3, 15, 4, 26, 5, 36)), if(lt(%q0, %q2), Rank %q1 spirits may not have a total sum of Power%, Finesse%, and Resistance dots fewer than %q2. You have a total of %q0.)))

&check-totem_traits [v(d.spirits)]=if(t(default(totem_points, 0)), strcat(setq(0, add(default(Power, 0), default(Finesse, 0), default(Resistance, 0))), setq(1, default(totem_points, 0)), if(neq(%q0, %q1), You have %q1 Totem Points to spend on Power%, Finesse%, and Resistance. Right now you have spent %q0 points in these traits.)))

&f.get-max-numina [v(d.spirits)]=if(t(setr(0, div(default(totem_points, 0), 4))), %q0, case(default(rank, 0), 0, 0, 1, 3, 2, 5, 3, 7, 4, 9, 5, 11))

&f.get-extra-influences [v(d.spirits)]=max(sub(words(lattrp(me/influence-*)), default(rank, 0)), 0)

&f.get-extra-manifestations [v(d.spirits)]=max(sub(words(lattrp(me/manifestations-*)), add(default(rank, 0), 1)), 0)

&f.get-total-numina [v(d.spirits)]=add(words(lattrp(me/numina-*)), ulocal(f.get-extra-influences), ulocal(f.get-extra-manifestations))

&f.get-unspent-numina [v(d.spirits)]=max(sub(ulocal(f.get-max-numina), words(lattrp(me/numina-*))), 0)

&check-numina-max [v(d.spirits)]=strcat(setq(0, ulocal(f.get-total-numina)), setq(1, default(totem_points, 0)), setq(2, ulocal(f.get-max-numina)), if(t(%q1), if(neq(%q0, %q2), Your %q1 Totem Points grants you %q2 Numina dots%, which can also be spent on Influences and Manifestations. You have spent %q0 dots total.), if(gt(%q0, %q2), Rank [default(rank, 0)] spirits may not have a total number of numina above %q2. You have %q0 numina.)))

&check-numina-min [v(d.spirits)]=if(t(default(totem_points, 0)),, strcat(setq(0, ulocal(f.get-total-numina)), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 1, 2, 3, 3, 5, 4, 7, 5, 9)), if(lt(%q0, %q2), Rank %q1 spirits may not have a total number of numina fewer than %q2. You have %q0 numina.)))

&check-influences-max [v(d.spirits)]=strcat(setq(0, add(sub(ulocal(f.get-unspent-numina), ulocal(f.get-extra-manifestations)), setr(2, default(rank, 0)))), setq(1, ladd(iter(lattrp(me/influence-*), v(itext(0))))), if(gt(%q1, %q0), By our calculations%, you should have a max of %q0 Influences%, counting unspent Numina and the Influences granted by the entity's rank of %q2. You have %q1.))

&check-manifestations-max [v(d.spirits)]=strcat(setq(0, add(sub(ulocal(f.get-unspent-numina), ulocal(f.get-extra-influences)), setr(2, default(rank, 0)), 1)), setq(1, ladd(iter(lattrp(me/manifestation-*), v(itext(0))))), if(gt(%q1, %q0), By our calculations%, you should have a max of %q0 Manifestations%, counting unspent Numina and the Manifestations granted by the entity's rank of %q2%, plus the default Twilight Form. You have %q1.))

&check-totem_benefits [v(d.spirits)]=if(t(setr(0, default(totem_points, 0))), if(not(hasattr(me, totem_benefits)), Totem Benefits are required. With %q0 totem points%, you have [case(1, gte(%q0, 20), 10, gte(%q0, 15), 5, gte(%q0, 9), 3, 1)] XP to spend on Totem Benefits.))

&check-totem_appearance [v(d.spirits)]=if(t(default(totem_points, 0)), if(not(hasattr(me, appearance)), Appearance is required for Totems.))

&check-shadow_gateway [v(d.spirits)]=if(and(hasattrp(me, manifestation-shadow_gateway), lt(default(rank, 0), 3)), The spirit needs to be at least Rank 3 to have the Shadow Gateway Manifestation.)

&check-resurrection [v(d.spirits)]=if(and(hasattrp(me, numina-resurrection), lt(default(rank, 0), 4)), The spirit needs to be at least Rank 4 to have the Numina Resurrection.)

&check-influences-min [v(d.spirits)]=if(lt(setr(1, ladd(iter(lattrp(me/influence-*), v(itext(0))))), setr(0, default(rank, 0))), By the book you can have up to %q0 points of Influences. You have %q1. You can do fewer if you want to%, this is just a notification!)

&check-manifestations-min [v(d.spirits)]=if(lt(setr(1, ladd(iter(lattrp(me/manifestation-*), v(itext(0))))), setr(0, default(rank, 0))), By the book you can have up to %q0 points of Manifestations. You have %q1. You can do fewer if you want to%, this is just a notification!)
