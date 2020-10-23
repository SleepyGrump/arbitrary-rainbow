/*
This absolutely requires you to already have installed NPCs - AKA Critters 2.0.mu. If you haven't, stop now and go back!
*/

@create Angels=10
@force me=&d.angels me=[search(name=Angels)]
@wait 1=@set [v(d.angels)]=SAFE INHERIT
@wait 1=@force me=@parent [v(d.angels)]=[v(d.npcs)]
@wait 1=@tel [v(d.angels)]=[v(d.npcs)]

@@ ========================================================================= @@

&stat_categories [v(d.angels)]=Influence|Manifestation|Numina

&list-numina [v(d.angels)]=Aggressive Meme|Awe|Blast|Dement|Drain|Emotional Aura|Essence Thief|Fate Sense|Firestarter|Hallucination|Host Jump|Implant Mission|Innocuous|Left-Handed Spanner|Mortal Mask|Omen Trance|Pathfinder|Rapture|Regenerate|Resurrection|Seek|Speed|Sign|Stalwart|Telekinesis

&list-manifestation [v(d.angels)]=Twilight Form|Discorporate|Avernian Gateway|Shadow Gateway|Image|Materialize|Fetter|Unfetter|Possess|Claim

&stats [v(d.angels)]=Rank|Mission|Virtue|Vice|Power|Finesse|Resistance|Essence|Size|Species Factor|Ban|Bane

&required-stats [v(d.angels)]=Rank|Mission|Virtue|Vice|Power|Finesse|Resistance|Ban|Bane

&non-numeric_stats [v(d.angels)]=Mission|Ban|Bane|Virtue|Vice

&manifestation-twilight_form [v(d.angels)]=1

@set [v(d.angels)]/manifestation-twilight_form=VISUAL

&f.get-defense [v(d.angels)]=default(defense, if(hasattr(me, numina-stalwart), default(resistance, 0), if(lte(default(rank, 0), 1), max(default(power, 0), default(finesse, 0)), min(default(power, 0), default(finesse, 0)))))

&layout.name [v(d.angels)]=strcat(name(me), %b-%b, Rank, %b, default(rank, 0), %b-%b, num(me))

&layout.advantages [v(d.angels)]=strcat(%r, wdivider(Advantages), %r, ulocal(layout.row, Essence, default(essence, 0), Size, ulocal(f.get-size), Species factor, ulocal(f.get-species-factor)), %r, ulocal(layout.row, Willpower, ulocal(f.get-trait, resistance, finesse), Corpus, add(default(resistance, 1), ulocal(f.get-size)), Initiative, ulocal(f.get-trait, finesse, resistance)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-trait, power, finesse, ulocal(f.get-species-factor))))

@desc [v(d.angels)]=if(t(lcon(me)), ulocal(layout.container, 2), strcat(ulocal(layout.header, Mission|Virtue|Vice|Ban|Bane, ulocal(layout.name)), ulocal(layout.ephemeral_attributes), ulocal(layout.advantages), ulocal(layout.sheet-section, Influences, influence, 1), ulocal(layout.sheet-section, Manifestations, manifestation, 1, 1), ulocal(layout.sheet-section, Numina,, 1), ulocal(layout.sheet-bottom-notes, Notes)))

@@ Angel checks

&check-essence [v(d.angels)]=if(gt(setr(2, default(essence, 0)), setr(1, case(setr(0, default(rank, 0)), 0, 5, 1, 10, 2, 15, 3, 20, 4, 25, 5, 50))), Max essence for Rank %q0 is %q1. You have %q2 essence., if(eq(%q2, 0), Don't forget to set an Essence score. The max for this entity's rank is %q0.))

&check-traits [v(d.angels)]=iter(Power Finesse Resistance, if(t(setr(0, ulocal(trait-test, itext(0)))), %q0),, |)

&trait-test [v(d.angels)]=if(gt(default(%0, 0), setr(1, case(setr(0, default(rank, 0)), 0, 0, 1, 5, 2, 7, 3, 9, 4, 12, 5, 15))), Max [titlestr(%0)] for Rank %q0 is %q1.)

&check-traits-max [v(d.angels)]=strcat(setq(0, add(default(Power, 0), default(Finesse, 0), default(Resistance, 0))), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 8, 2, 14, 3, 25, 4, 35, 5, 45)), if(gt(%q0, %q2), Rank %q1 angels may not have a total sum of Power%, Finesse%, and Resistance dots above %q2. You have a total of %q0.))

&check-traits-min [v(d.angels)]=strcat(setq(0, add(default(Power, 0), default(Finesse, 0), default(Resistance, 0))), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 5, 2, 9, 3, 15, 4, 26, 5, 36)), if(lt(%q0, %q2), Rank %q1 angels may not have a total sum of Power%, Finesse%, and Resistance dots fewer than %q2. You have a total of %q0.))

&f.get-max-numina [v(d.angels)]=case(default(rank, 0), 0, 0, 1, 3, 2, 5, 3, 7, 4, 9, 5, 11)

&f.get-extra-influences [v(d.angels)]=max(sub(words(lattrp(me/influence-*)), default(rank, 0)), 0)

&f.get-extra-manifestations [v(d.angels)]=max(sub(words(lattrp(me/manifestations-*)), add(default(rank, 0), 1)), 0)

&f.get-total-numina [v(d.angels)]=add(words(lattrp(me/numina-*)), ulocal(f.get-extra-influences), ulocal(f.get-extra-manifestations))

&f.get-unspent-numina [v(d.angels)]=max(sub(ulocal(f.get-max-numina), words(lattrp(me/numina-*))), 0)

&check-numina-max [v(d.angels)]=strcat(setq(0, ulocal(f.get-total-numina)), setq(1, ulocal(f.get-max-numina)), if(gt(%q0, %q1), Rank [default(rank, 0)] angels may not have a total number of numina above %q1. You have %q0 numina.))

&check-numina-min [v(d.angels)]=strcat(setq(0, ulocal(f.get-total-numina)), setq(2, case(setr(1, default(rank, 0)), 0, 0, 1, 1, 2, 3, 3, 5, 4, 7, 5, 9)), if(lt(%q0, %q2), Rank %q1 angels may not have a total number of numina fewer than %q2. You have %q0 numina.))

&check-influences-max [v(d.angels)]=strcat(setq(0, add(sub(ulocal(f.get-unspent-numina), ulocal(f.get-extra-manifestations)), setr(2, default(rank, 0)))), setq(1, ladd(iter(lattrp(me/influence-*), v(itext(0))))), if(gt(%q1, %q0), By our calculations%, you should have a max of %q0 Influences%, counting unspent Numina and the Influences granted by the entity's rank of %q2. You have %q1.))

&check-manifestations-max [v(d.angels)]=strcat(setq(0, add(sub(ulocal(f.get-unspent-numina), ulocal(f.get-extra-influences)), setr(2, default(rank, 0)), 1)), setq(1, ladd(iter(lattrp(me/manifestation-*), v(itext(0))))), if(gt(%q1, %q0), By our calculations%, you should have a max of %q0 Manifestations%, counting unspent Numina and the Manifestations granted by the entity's rank of %q2%, plus the default Twilight Form. You have %q1.))

&check-shadow_gateway [v(d.angels)]=if(and(hasattrp(me, manifestation-shadow_gateway), lt(default(rank, 0), 3)), The angel needs to be at least Rank 3 to have the Shadow Gateway Manifestation.)

&check-resurrection [v(d.angels)]=if(and(hasattrp(me, numina-resurrection), lt(default(rank, 0), 4)), The angel needs to be at least Rank 4 to have the Numina Resurrection.)

&check-influences-min [v(d.angels)]=if(lt(setr(1, ladd(iter(lattrp(me/influence-*), v(itext(0))))), setr(0, default(rank, 0))), By the book you can have up to %q0 points of Influences. You have %q1. You can do fewer if you want to%, this is just a notification!)

&check-manifestations-min [v(d.angels)]=if(lt(setr(1, ladd(iter(lattrp(me/manifestation-*), v(itext(0))))), setr(0, default(rank, 0))), By the book you can have up to %q0 points of Manifestations. You have %q1. You can do fewer if you want to%, this is just a notification!)
