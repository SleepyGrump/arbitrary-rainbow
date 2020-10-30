/*
This absolutely requires you to already have installed NPCs - AKA Critters 2.0.mu. If you haven't, stop now and go back!
*/

@create Animals=10
@force me=&d.Animals me=[search(name=Animals)]
@wait 1=@set [v(d.animals)]=SAFE INHERIT
@wait 1=@force me=@parent [v(d.animals)]=[v(d.npcs)]
@wait 1=@tel [v(d.animals)]=[v(d.npcs)]

@@ ========================================================================= @@

&stat_categories [v(d.animals)]=Brawl Attack|Specialty

&stats [v(d.animals)]=Intelligence|Wits|Resolve|Strength|Dexterity|Stamina|Presence|Manipulation|Composure|Athletics|Brawl|Empathy|Intimidation|Stealth|Survival|Size|Species Factor

&required-stats [v(d.animals)]=Intelligence|Wits|Resolve|Strength|Dexterity|Stamina|Presence|Manipulation|Composure

&non-numeric_stat_categories [v(d.animals)]=Specialty

&f.get-health [v(d.animals)]=default(health, add(ulocal(f.get-size), default(stamina, 1)))

@@ Animals take the MAX of wits or dex, plus athletics. Still need a book reference for that.
&f.get-defense [v(d.animals)]=add(max(default(wits, 1), default(dexterity, 1)), first(default(athletics, 0), |))

&layout.skills [v(d.animals)]=strcat(%r, wdivider(Skills), %r, ulocal(layout.two-column, ulocal(layout.skill, Athletics, default(athletics, 0)), ulocal(layout.skill, Empathy, default(empathy, 0))), %r, ulocal(layout.two-column, ulocal(layout.skill, Brawl, default(brawl, 0)), ulocal(layout.skill, Intimidation, default(intimidation, 0))), %r, ulocal(layout.two-column, ulocal(layout.skill, Stealth, default(stealth, 0)), ulocal(layout.skill, Survival, default(survival, 0))))

&layout.advantages [v(d.animals)]=strcat(%r, wdivider(Advantages), %r, ulocal(layout.row, Willpower, ulocal(f.get-trait, resolve, composure), Health, ulocal(f.get-health), Initiative, ulocal(f.get-trait, dexterity, composure)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-trait, strength, dexterity, ulocal(f.get-species-factor)), Size, ulocal(f.get-size)))

@desc [v(d.animals)]=if(t(lcon(me)), ulocal(layout.container), strcat(ulocal(layout.header), ulocal(layout.attributes), ulocal(layout.skills), ulocal(layout.advantages), ulocal(layout.attacks), ulocal(layout.sheet-bottom-notes, Notes)))

@@ Checks for Animal NPCgen go here if we ever write any.
