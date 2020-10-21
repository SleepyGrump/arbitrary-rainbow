/*
This absolutely requires you to already have installed NPCs - AKA Critters 2.0.mu. If you haven't, stop now and go back!
*/

@create Ghosts=10
@force me=&d.ghosts me=[search(name=Ghosts)]
@wait 1=@set [v(d.ghosts)]=SAFE INHERIT
@wait 1=@force me=@parent [v(d.ghosts)]=[v(d.npcs)]
@wait 1=@tel [v(d.ghosts)]=[v(d.npcs)]

@@ ========================================================================= @@

&stat_categories [v(d.ghosts)]=Influence|Manifestation|Numina

&list-numina [v(d.ghosts)]=Aggressive Meme|Awe|Blast|Dement|Drain|Emotional Aura|Essence Thief|Fate Sense|Firestarter|Hallucination|Host Jump|Implant Mission|Innocuous|Left-Handed Spanner|Mortal Mask|Omen Trance|Pathfinder|Rapture|Regenerate|Seek|Speed|Sign|Stalwart|Telekinesis

&list-manifestation [v(d.ghosts)]=Twilight Form|Discorporate|Avernian Gateway|Image|Materialize|Fetter|Unfetter|Possess|Claim

&stats [v(d.ghosts)]=Rank|Concept|Aspiration|Virtue|Vice|Anchors|Power|Finesse|Resistance|Essence|Size|Species Factor|Ban|Bane|Integrity

&required-stats [v(d.ghosts)]=Rank|Concept|Aspiration|Virtue|Vice|Anchors|Power|Finesse|Resistance|Ban|Bane|Integrity

&non-numeric_stats [v(d.ghosts)]=Concept|Aspiration|Anchors|Virtue|Vice|Ban|Bane

&manifestation-twilight_form [v(d.ghosts)]=1

@set [v(d.ghosts)]/manifestation-twilight_form=VISUAL

&influence-anchors [v(d.ghosts)]=1

@set [v(d.ghosts)]/influence-anchors=VISUAL

&f.get-defense [v(d.ghosts)]=default(defense, if(hasattr(me, numina-stalwart), default(resistance, 0), if(lte(default(rank, 0), 1), max(default(power, 0), default(finesse, 0)), min(default(power, 0), default(finesse, 0)))))

&layout.name [v(d.ghosts)]=strcat(name(me), %b-%b, Rank, %b, default(rank, 0), %b-%b, num(me))

&layout.advantages [v(d.ghosts)]=strcat(%r, wdivider(Advantages), %r, ulocal(layout.row, Essence, default(essence, 0), Size, ulocal(f.get-size), Species factor, ulocal(f.get-species-factor)), %r, ulocal(layout.row, Willpower, ulocal(f.get-trait, resistance, finesse), Corpus, add(default(resistance, 1), ulocal(f.get-size)), Initiative, ulocal(f.get-trait, finesse, resistance)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-trait, power, finesse, ulocal(f.get-species-factor)), Integrity, default(integrity, 7)))

@desc [v(d.ghosts)]=if(t(lcon(me)), ulocal(layout.container, 2), strcat(ulocal(layout.header, Concept|Aspiration|Anchors|Virtue|Vice|Ban|Bane, ulocal(layout.name)), ulocal(layout.ephemeral_attributes), ulocal(layout.advantages), ulocal(layout.sheet-section, Influences, influence, 1), ulocal(layout.sheet-section, Manifestations, manifestation, 1), ulocal(layout.sheet-section, Numina,, 1), ulocal(layout.sheet-bottom-notes, Notes)))

@@ NPCgen checks

&check-essence [v(d.ghosts)]=if(gt(setr(2, default(essence, 0)), setr(1, case(setr(0, default(rank, 0)), 0, 5, 1, 10, 2, 15, 3, 20, 4, 25, 5, 50))), Max essence for Rank %q0 is %q1. You have %q2 essence., if(eq(%q2, 0), Don't forget to set an Essence score. The max for this entity's rank is %q1.))

&check-traits [v(d.ghosts)]=iter(Power Finesse Resistance, if(t(setr(0, ulocal(trait-test, itext(0)))), %q0),, |)

&trait-test [v(d.ghosts)]=if(gt(default(%0, 0), setr(1, case(setr(0, default(rank, 0)), 0, 0, 1, 5, 2, 7, 3, 9, 4, 12, 5, 15))), Max [titlestr(%0)] for Rank %q0 is %q1.)

&check-traits-max [v(d.ghosts)]=strcat(setq(0, add(default(Power, 0), default(Finesse, 0), default(Resistance, 0))), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 8, 2, 14, 3, 25, 4, 35, 5, 45)), if(gt(%q0, %q2), Rank %q1 ghosts may not have a total sum of Power%, Finesse%, and Resistance dots above %q2. You have a total of %q0.))

&check-traits-min [v(d.ghosts)]=strcat(setq(0, add(default(Power, 0), default(Finesse, 0), default(Resistance, 0))), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 5, 2, 9, 3, 15, 4, 26, 5, 36)), if(lt(%q0, %q2), Rank %q1 ghosts may not have a total sum of Power%, Finesse%, and Resistance dots fewer than %q2. You have a total of %q0.))

&f.get-extra-influences [v(d.ghosts)]=max(sub(words(lattrp(me/influence-*)), default(rank, 0)), 0)

&f.get-extra-manifestations [v(d.ghosts)]=max(sub(words(lattrp(me/manifestations-*)), add(default(rank, 0), 1)), 0)

&f.get-total-numina [v(d.ghosts)]=add(words(lattrp(me/numina-*)), ulocal(f.get-extra-influences), ulocal(f.get-extra-manifestations))

&check-numina-max [v(d.ghosts)]=strcat(setq(0, ulocal(f.get-total-numina)), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 3, 2, 5, 3, 7, 4, 9, 5, 11)), if(gt(%q0, %q2), Rank %q1 ghosts may not have a total number of numina above %q2. You have %q0 numina.))

&check-numina-min [v(d.ghosts)]=strcat(setq(0, ulocal(f.get-total-numina)), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 1, 2, 3, 3, 5, 4, 7, 5, 9)), if(lt(%q0, %q2), Rank %q1 ghosts may not have a total number of numina fewer than %q2. You have %q0 numina.))

&f.get-unspent-numina [v(d.ghosts)]=max(sub(case(default(rank, 0), 0, 0, 1, 3, 2, 5, 3, 7, 4, 9, 5, 11), words(lattrp(me/numina-*))), 0)

&check-influences-max [v(d.ghosts)]=strcat(setq(0, add(sub(ulocal(f.get-unspent-numina), ulocal(f.get-extra-manifestations)), setr(2, default(rank, 0)))), setq(1, ladd(iter(lattrp(me/influence-*), v(itext(0))))), if(gt(%q1, %q0), By our calculations%, you should have a max of %q0 Influences%, counting unspent Numina and the Influences granted by the entity's rank of %q2. You have %q1.))

&check-manifestations-max [v(d.ghosts)]=strcat(setq(0, add(sub(ulocal(f.get-unspent-numina), ulocal(f.get-extra-influences)), setr(2, default(rank, 0)), 1)), setq(1, ladd(iter(lattrp(me/manifestation-*), v(itext(0))))), if(gt(%q1, %q0), By our calculations%, you should have a max of %q0 Manifestations%, counting unspent Numina and the Manifestations granted by the entity's rank of %q2%, plus the default Twilight Form. You have %q1.))
