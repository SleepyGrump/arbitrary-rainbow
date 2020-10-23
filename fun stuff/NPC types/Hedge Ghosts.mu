/*
This absolutely requires you to already have installed NPCs - AKA Critters 2.0.mu. If you haven't, stop now and go back!
*/

@create Hedge Ghosts=10
@force me=&d.hedge_ghosts me=[search(name=Hedge Ghosts)]
@wait 1=@set [v(d.hedge_ghosts)]=SAFE INHERIT
@wait 1=@force me=@parent [v(d.hedge_ghosts)]=[v(d.npcs)]
@wait 1=@tel [v(d.hedge_ghosts)]=[v(d.npcs)]

@@ ========================================================================= @@

&stat_categories [v(d.hedge_ghosts)]=Influence|Numina|Major Taboo|Major Bane|Minor Taboo|Minor Bane

&list-numina [v(d.hedge_ghosts)]=Aggressive Meme|Blast|Clarity Drain|Dematerialize|Dement|Drain|Emotional Aura|Entrap|Failed Token|Hallucination|Implant Mission|Keeper's Calling|Rapture|Sign|Speed|Stalwart|Stolen Masks

&stats [v(d.hedge_ghosts)]=Wyrd|Concept|Thread|Vice|Needle|Power|Finesse|Resistance|Glamour|Size|Species Factor|Integrity

&list-needle [v(d.hedge_ghosts)]=Bon Vivant|Chess Master|Commander|Composer|Counselor|Daredevil|Dynamo|Protector|Provider|Scholar|Storyteller|Teacher|Traditionalist|Visionary|Instigator

&list-thread [v(d.hedge_ghosts)]=Acceptance|Anger|Family|Friendship|Hate|Honor|Joy|Love|Memory|Revenge|Spite|Justice

&required-stats [v(d.hedge_ghosts)]=Concept|Thread|Power|Finesse|Resistance

&non-numeric_stats [v(d.hedge_ghosts)]=Concept|Thread|Vice|Needle

&non-numeric_stat_categories [v(d.hedge_ghosts)]=Major Taboo|Major Bane|Minor Taboo|Minor Bane

&wyrd [v(d.hedge_ghosts)]=1

@set [v(d.hedge_ghosts)]/wyrd=VISUAL

&major_bane-cold_iron [v(d.hedge_ghosts)]=Cold Iron causes aggravated damage to all Hedge Ghosts.

@set [v(d.hedge_ghosts)]/major_bane-cold_iron=VISUAL

&f.get-defense [v(d.hedge_ghosts)]=default(defense, if(hasattr(me, numina-stalwart), default(resistance, 0), if(lte(default(wyrd, 1), 1), max(default(power, 0), default(finesse, 0)), min(default(power, 0), default(finesse, 0)))))

&layout.name [v(d.hedge_ghosts)]=strcat(name(me), %b-%b, Wyrd, %b, default(wyrd, 1), %b-%b, num(me))

&layout.frailty [v(d.hedge_ghosts)]=ulocal(layout.note, titlestr(edit(first(%0, -), _, %b)), %0, 13)

&layout.frailties [v(d.hedge_ghosts)]=strcat(%r, wdivider(Frailties), %r, iter(squish(trim(strcat(lattrp(me/major_bane-*), %b, lattrp(me/major_taboo-*), %b, lattrp(me/minor_bane-*), %b, lattrp(me/minor_taboo-*)))), ulocal(layout.frailty, itext(0)),, %r))

&layout.advantages [v(d.hedge_ghosts)]=strcat(%r, wdivider(Advantages), %r, ulocal(layout.row, Glamour, default(glamour, 0), Size, ulocal(f.get-size), Species factor, ulocal(f.get-species-factor)), %r, ulocal(layout.row, Willpower, ulocal(f.get-trait, resistance, finesse), Corpus, add(default(resistance, 1), ulocal(f.get-size)), Initiative, ulocal(f.get-trait, finesse, resistance)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-trait, power, finesse, ulocal(f.get-species-factor)), Integrity, default(integrity, 7)))

@desc [v(d.hedge_ghosts)]=if(t(lcon(me)), ulocal(layout.container, 2), strcat(ulocal(layout.header, Concept|Thread|Vice`|Needle`, ulocal(layout.name)), ulocal(layout.frailties), ulocal(layout.ephemeral_attributes), ulocal(layout.advantages), ulocal(layout.sheet-section, Influences, influence, 1), ulocal(layout.sheet-section, Numina,, 1), ulocal(layout.sheet-bottom-notes, Notes)))

@@ NPCgen checks

&f.get-wyrd-score [v(d.hedge_ghosts)]=ceil(fdiv(default(wyrd, 1), 2))

&f.get-unspent-numina [v(d.hedge_ghosts)]=max(sub(case(default(wyrd, 1), 1, 3, 2, 5, 3, 7, 4, 9, 5, 11), words(lattrp(me/numina-*))), 0)

&f.get-extra-influences [v(d.hedge_ghosts)]=max(sub(words(lattrp(me/influence-*)), ulocal(f.get-wyrd-score)), 0)

&f.get-total-numina [v(d.hedge_ghosts)]=add(words(lattrp(me/numina-*)), ulocal(f.get-extra-influences))

&check-glamour [v(d.hedge_ghosts)]=if(gt(setr(2, default(glamour, 0)), setr(1, mul(ulocal(f.get-wyrd-score), 5))), Max glamour for this entity's Wyrd is %q1. You have %q2 glamour., if(eq(%q2, 0), Don't forget to set a Glamour score. The max for this entity's wyrd is %q1.))

&check-traits [v(d.hedge_ghosts)]=iter(Power Finesse Resistance, if(t(setr(0, ulocal(trait-test, itext(0)))), %q0),, |)

&trait-test [v(d.hedge_ghosts)]=if(gt(default(%0, 0), setr(1, case(ulocal(f.get-wyrd-score), 1, 5, 2, 7, 3, 9, 4, 12, 5, 15))), Max [titlestr(%0)] for this entity's Wyrd is %q1.)

&check-traits-max [v(d.hedge_ghosts)]=strcat(setq(0, add(default(Power, 0), default(Finesse, 0), default(Resistance, 0))), setq(2, case(ulocal(f.get-wyrd-score), 1, 8, 2, 14, 3, 25, 4, 35, 5, 45)), if(gt(%q0, %q2), Hedge Ghosts of this Wyrd may not have a total sum of Power%, Finesse%, and Resistance dots above %q2. You have a total of %q0.))

&check-traits-min [v(d.hedge_ghosts)]=strcat(setq(0, add(default(Power, 0), default(Finesse, 0), default(Resistance, 0))), setq(2, case(ulocal(f.get-wyrd-score), 1, 5, 2, 9, 3, 15, 4, 26, 5, 36)), if(lt(%q0, %q2), Hedge Ghosts of this Wyrd may not have a total sum of Power%, Finesse%, and Resistance dots fewer than %q2. You have a total of %q0.))

&check-numina-max [v(d.hedge_ghosts)]=strcat(setq(0, ulocal(f.get-total-numina)), setq(2, case(setr(1, default(wyrd, 1)), 1, 3, 2, 5, 3, 7, 4, 9, 5, 11)), if(gt(%q0, %q2), Wyrd %q1 Hedge Ghosts may not have a total number of numina above %q2. You have %q0 numina.))

&check-numina-min [v(d.hedge_ghosts)]=strcat(setq(0, ulocal(f.get-total-numina)), setq(2, case(setr(1, default(wyrd, 1)), 1, 1, 2, 3, 3, 5, 4, 7, 5, 9)), if(lt(%q0, %q2), Wyrd %q1 Hedge Ghosts may not have a total number of numina fewer than %q2. You have %q0 numina.))

&check-influences-max [v(d.hedge_ghosts)]=strcat(setq(0, add(ulocal(f.get-unspent-numina), ulocal(f.get-wyrd-score))), setq(1, ladd(iter(lattrp(me/influence-*), v(itext(0))))), if(gt(%q1, %q0), By our calculations%, you should have a max of %q0 Influences%, counting unspent Numina and the Influences granted by the entity's Wyrd. You have %q1.))

&check-influences-min [v(d.hedge_ghosts)]=if(lt(setr(1, ladd(iter(lattrp(me/influence-*), v(itext(0))))), setr(0, ulocal(f.get-wyrd-score))), By the book you can have up to %q0 points of Influences. You have %q1. You can do fewer if you want to%, this is just a notification!)

&f.get-required-minor-frailties [v(d.hedge_ghosts)]=case(ulocal(f.get-wyrd-score), 1, 1, 2, 2, 3, 2, 4, 3, 5, 3)

&f.get-required-major-frailties [v(d.hedge_ghosts)]=case(ulocal(f.get-wyrd-score), 1, 1, 2, 1, 3, 2, 4, 2, 5, 3)

&check-minor-frailties [v(d.hedge_ghosts)]=if(neq(setr(0, ulocal(f.get-required-minor-frailties)), setr(1, words(lattrp(me/minor_*)))), By our calculations%, you should have %q0 Minor Frailties. You have %q1.)

&check-major-frailties [v(d.hedge_ghosts)]=if(neq(setr(0, ulocal(f.get-required-major-frailties)), setr(1, words(lattrp(me/major_*)))), By our calculations%, you should have %q0 Major Frailties%, counting the default Major Bane%, Cold Iron. You have %q1.)
