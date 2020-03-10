/*
Dependencies:
	wheader()
	wfooter()
	wdivider()
	alert()

Wiki help page:

* +critters - list all the critters.
* +critter <name> - show yourself a single critter.

If you want to create your own:

@create Critter=10
@parent Critter=#977
@set Critter=NO_COMMAND

&intelligence Critter=0
&wits Critter=1
&resolve Critter=1
&strength Critter=1
&dexterity Critter=1
&stamina Critter=1
&presence Critter=1
&manipulation Critter=1
&composure Critter=1

&athletics Critter=1
&brawl Critter=1|Bite
&stealth Critter=0
&survival Critter=1
&empathy Critter=0
&intimidation Critter=0

&species_factor Critter=2
&size Critter=1

&damage-bite Critter=0L

&attack-1 Critter=Bite

&appearance Critter=A magical critter!

&note-0 Critter=Critter McCritterface!

l Critter

*/

@create Critter Sheet Parent <CSP>=10
@set CSP=SAFE PARENT_OK COMMANDS

&layout.name-and-value CSP=strcat(setq(0, ulocal(f.get-three-column-widths, %#)), %0, if(t(%0), :), space(sub(last(%q0, |), add(1, strlen(%0), strlen(%1)))), %1)

&layout.skill CSP=strcat(%0, if(t(%0), :%b), first(%1, |), if(t(rest(%1, |)), strcat(%b, %(, rest(%1, |), %))))

&layout.row CSP=strcat(setq(0, ulocal(f.get-three-column-widths, %#)), space(3), ulocal(layout.name-and-value, %0, %1, last(%q0, |)), space(first(%q0, |)), ulocal(layout.name-and-value, %2, %3, last(%q0, |)), space(extract(%q0, 2, 1, |)), ulocal(layout.name-and-value, %4, %5, last(%q0, |)))

&layout.row-no-values CSP=strcat(setq(0, ulocal(f.get-three-column-widths, %#)), space(3), ljust(strtrunc(%0, last(%q0, |)), last(%q0, |)), space(first(%q0, |)), ljust(strtrunc(%1, last(%q0, |)), last(%q0, |)), space(extract(%q0, 2, 1, |)), ljust(strtrunc(%2, last(%q0, |)), last(%q0, |)))

&layout.list-with-values CSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), strcat(setq(0, ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 0, 3)), setq(1, ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 1, 3)), setq(2, ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 2, 3)), ulocal(layout.row, first(%q0, |), rest(%q0, |), first(%q1, |), rest(%q1, |), first(%q2, |), rest(%q2, |))),, %r)

&layout.list CSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), ulocal(layout.row-no-values, ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 0, 3), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 1, 3), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 2, 3)),, %r)

&layout.dbref-list CSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), ulocal(layout.row-no-values, ulocal(f.lookup-from-list-of-names, %0, itext(0), 0, 3), ulocal(f.lookup-from-list-of-names, %0, itext(0), 1, 3), ulocal(f.lookup-from-list-of-names, %0, itext(0), 2, 3)),, %r)

&layout.two-column CSP=strcat(setq(0, ulocal(f.get-two-column-widths)), space(3), ljust(strtrunc(%0, rest(%q0, |)), rest(%q0, |)), space(first(%q0, |)), ljust(strtrunc(%1, rest(%q0, |)), rest(%q0, |)))

&layout.list-two-column CSP=iter(lnum(add(div(words(%0), 2), t(mod(words(%0), 2)))), ulocal(layout.two-column, ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 0, 2), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 1, 2)),, %r)

@@ %0 - title
@@ %1 - value
@@ %2 - title width
&layout.note CSP=strcat(setq(0, sub(width(%#), 6)), wrap(strcat(space(3), if(t(%1), strcat(ljust(strcat(%0, :%b), %2), default(%1, Unset.)), default(%0, Unset.))), if(t(%1), sub(%q0, %2), %q0), Left,, space(3), if(t(%1), add(%2, 3), 3), %r, %q0))

&layout.attributes CSP=strcat(wdivider(Attributes), %r, ulocal(layout.row, Intelligence, default(intelligence, 1), Strength, default(strength, 1), Presence, default(presence, 1)), %r, ulocal(layout.row, Wits, default(wits, 1), Dexterity, default(dexterity, 1), Manipulation, default(manipulation, 1)), %r, ulocal(layout.row, Resolve, default(resolve, 1), Stamina, default(stamina, 1), Composure, default(composure, 1)))

&layout.skills CSP=strcat(wdivider(Skills), %r, ulocal(layout.two-column, ulocal(layout.skill, Athletics, default(athletics, 0)), ulocal(layout.skill, Empathy, default(empathy, 0))), %r, ulocal(layout.two-column, ulocal(layout.skill, Brawl, default(brawl, 0)), ulocal(layout.skill, Intimidation, default(intimidation, 0))), %r, ulocal(layout.two-column, ulocal(layout.skill, Stealth, default(stealth, 0)), ulocal(layout.skill, Survival, default(survival, 0))))

&layout.list-of-notes CSP=strcat(wdivider(%0), %r, iter(sort(lattr(me/%1*)), ulocal(layout.note, itext(0)),, %r%r))

&layout.attack CSP=strcat(setq(0, sub(width(%#), 6)), wrap(strcat(space(3), setr(1, first(%0, |)), :%b, default(damage-%q1, default(damage, 0L)), %b, damage%,, %b, add(default(strength, 1), first(setr(2, default(brawl, 1)), |), if(strmatch(%q2, *|*%q1*), 1, 0)), %b, dice pool., if(t(rest(%0, |)), strcat(%b, rest(%0, |)))), %q0, Left,, space(3), 3, %r, %q0))

&layout.attacks CSP=strcat(wdivider(Attacks), %r, iter(sort(lattr(me/attack-*)), ulocal(layout.attack, v(itext(0))),, %r%r))

@@ %0 - list to extract from
@@ %1 - Which row we're on. 0-index.
@@ %2 - which column we're on, 0-index.
@@ %3 - number of columns

&f.lookup-from-list-of-attributes CSP=if(gte(words(%0), add(mul(%1, %3), %2, 1)), v(extract(%0, add(mul(%1, %3), %2, 1), 1)))

&f.lookup-from-list-of-names CSP=if(gte(words(%0), add(mul(%1, %3), %2, 1)), name(extract(%0, add(mul(%1, %3), %2, 1), 1)))

&f.get-three-column-widths CSP=strcat(setq(0, sub(width(%0), 6)), setq(0, sub(%q0, 4)), setq(1, mod(%q0, 3)), setq(0, sub(%q0, %q1)), add(mod(%q1, 2), div(%q1, 2), 2), |, add(div(%q1, 2), 2), |, div(%q0, 3))

&f.get-two-column-widths CSP=strcat(setq(0, sub(width(%0), 6)), setq(0, sub(%q0, 2)), setq(1, mod(%q0, 2)), setq(0, sub(%q0, %q1)), add(%q1, 2), |, div(%q0, 2))

&f.sort-by-name CSP=comp(name(%0), name(%1))

&f.get-trait CSP=add(default(%0, 1), default(%1, 1), %2)

@@ Animals take the MAX of wits or dex, plus athletics.
@@ Need a book reference for that...

&f.get-defense CSP=add(max(default(wits, 1), default(dexterity, 1)), first(default(athletics, 0), |))

&f.get-species-factor CSP=default(species_factor, 1)

&f.get-size CSP=default(size, 1)

@desc CSP=strcat(wheader(strcat(name(me), if(isstaff(%#), strcat(%b-%b, num(me))))), %r, ulocal(layout.note, Appearance, appearance), %r, ulocal(layout.attributes), %r, ulocal(layout.skills), %r, wdivider(Traits), %r, ulocal(layout.row, Willpower, ulocal(f.get-trait, resolve, composure), Health, ulocal(f.get-trait, size, stamina), Initiative, ulocal(f.get-trait, dexterity, composure)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-trait, strength, dexterity, ulocal(f.get-species-factor)), Size, ulocal(f.get-size)), %r, ulocal(layout.attacks), %r, ulocal(layout.list-of-notes, Notes, note-), %r, wfooter())

&cmd-+critters CSP=$+critters:@pemit %#=strcat(wheader(Critter list), %r, ulocal(layout.dbref-list, sortby(f.sort-by-name, lcon(me))), %r, wfooter(+critter <name> for more info.))

&cmd-+critter CSP=$+critter *:@pemit %#=if(t(setr(L, locate(me, %0, i))), udefault(%qL/desc, This critter doesn't have stats yet.), strcat(alert(Critters), %b, if(strmatch(%qL, #-1*), Can't find a critter named '%0'., Found multiple critters whose names start with '%0'. Did you mean one of these? [itemize(trim(squish(iter(lcon(me), if(strmatch(name(itext(0)), %0*), name(itext(0))),, |), |), b, |), |)])))

/*

@@ Not including this feature because it could lead to object proliferation:

@@ &cmd-+critter/clone CSP=$+critter/clone *:@pemit %#=if(t(setr(L, locate(me, %0, i))), if(not(t(locate(me, [moniker(%#)]'s [name(%qL)]))), alert(Critters) Cloning you a [name(%qL)]...), alert(Critters) Can't find a critter named '%0'.); @switch t(%qL)=1, {@clone %qL=moniker(%#)'s [name(%qL)]/10; @tel };

*/

/*

@@ Sample critter sheet:

@@ ========================================================================== @@

@create Bat
@parent Bat=CSP

&intelligence Bat=0
&wits Bat=1
&resolve Bat=0
&strength Bat=1
&dexterity Bat=4
&stamina Bat=1
&presence Bat=1
&manipulation Bat=0
&composure Bat=1

&athletics Bat=4|Flight
&brawl Bat=1
&stealth Bat=0
&survival Bat=3
&empathy Bat=0
&intimidation Bat=0

&species_factor Bat=10
&size Bat=1

&damage Bat=0L

&attack-1 Bat=Bite

&appearance Bat=Sky squirrel - oddly cute, not so bad. 6/10 do not handle without gloves.

&note-0 Bat=Speed is flight only. Bats can see in maneuver and total darkness without penalty.

@force me=&note-1 Bat=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Bat=CSP

@@ ========================================================================== @@

@create Badger
@parent Badger=CSP

&intelligence Badger=1
&wits Badger=3
&resolve Badger=3
&strength Badger=2
&dexterity Badger=3
&stamina Badger=5
&presence Badger=2
&manipulation Badger=1
&composure Badger=2

&athletics Badger=4|Burrowing
&brawl Badger=3
&stealth Badger=2
&survival Badger=4
&empathy Badger=0
&intimidation Badger=1

&species_factor Badger=4
&size Badger=3

&damage Badger=0L

&attack-1 Badger=Bite

&appearance Badger=Small and hostile, full of thwarted rage.

&note-0 Badger=Badgers add two extra dice to all rolls to resist toxins and disease.

@force me=&note-1 Badger=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Badger=CSP

@@ ========================================================================== @@

@create Bear
@parent Bear=CSP

&intelligence Bear=1
&wits Bear=2
&resolve Bear=4
&strength Bear=6
&dexterity Bear=2
&stamina Bear=4
&presence Bear=3
&manipulation Bear=1
&composure Bear=4

&athletics Bear=3|Climbing
&brawl Bear=4
&stealth Bear=0
&survival Bear=3
&empathy Bear=0
&intimidation Bear=3

&species_factor Bear=6
&size Bear=7

&damage-bite Bear=2L
&damage-claw Bear=1L

&attack-1 Bear=Bite
&attack-2 Bear=Claw

&appearance Bear=Murder floof is made of rage and spite - and heaven help you if she has cubs.

@force me=&note-1 Bear=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Bear=CSP


@@ ========================================================================== @@

@create Cat (Domestic)
@parent Cat (Domestic)=CSP

&intelligence Cat (Domestic)=1
&wits Cat (Domestic)=4
&resolve Cat (Domestic)=3
&strength Cat (Domestic)=1
&dexterity Cat (Domestic)=5
&stamina Cat (Domestic)=3
&presence Cat (Domestic)=3
&manipulation Cat (Domestic)=1
&composure Cat (Domestic)=3

&athletics Cat (Domestic)=4
&brawl Cat (Domestic)=2
&stealth Cat (Domestic)=3
&survival Cat (Domestic)=0
&empathy Cat (Domestic)=0
&intimidation Cat (Domestic)=0

&species_factor Cat (Domestic)=7
&size Cat (Domestic)=2

&damage Cat (Domestic)=0L

&attack-1 Cat (Domestic)=Bite
&attack-2 Cat (Domestic)=Claw

&appearance Cat (Domestic)=The reason the internet was created. Small, fluffy, and cute. Beware.

@force me=&note-1 Cat (Domestic)=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Cat (Domestic)=CSP


@@ ========================================================================== @@

@create Cat (Great)
@parent Cat (Great)=CSP

&intelligence Cat (Great)=1
&wits Cat (Great)=4
&resolve Cat (Great)=4
&strength Cat (Great)=5
&dexterity Cat (Great)=4
&stamina Cat (Great)=3
&presence Cat (Great)=3
&manipulation Cat (Great)=1
&composure Cat (Great)=3

&athletics Cat (Great)=4|Climbing
&brawl Cat (Great)=4|Claws
&stealth Cat (Great)=3
&survival Cat (Great)=3|Tracking
&empathy Cat (Great)=0
&intimidation Cat (Great)=3

&species_factor Cat (Great)=8
&size Cat (Great)=5

&damage-bite Cat (Great)=2L
&damage-claw Cat (Great)=1L

&attack-1 Cat (Great)=Bite
&attack-2 Cat (Great)=Claw

&appearance Cat (Great)=Danger floof. Still sits if fits.

@force me=&note-1 Cat (Great)=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Cat (Great)=CSP

@@ ========================================================================== @@

@create Chimpanzee
@parent Chimpanzee=CSP

&intelligence Chimpanzee=2
&wits Chimpanzee=3
&resolve Chimpanzee=2
&strength Chimpanzee=5
&dexterity Chimpanzee=4
&stamina Chimpanzee=3
&presence Chimpanzee=2
&manipulation Chimpanzee=2
&composure Chimpanzee=4

&athletics Chimpanzee=3|Climbing
&brawl Chimpanzee=3|Bite
&stealth Chimpanzee=0
&survival Chimpanzee=3
&empathy Chimpanzee=0
&intimidation Chimpanzee=3

&species_factor Chimpanzee=6
&size Chimpanzee=4

&damage Chimpanzee=0L

&attack-1 Chimpanzee=Bite

&appearance Chimpanzee=Our future replacements - if the squid don't get there first.

@force me=&note-1 Chimpanzee=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Chimpanzee=CSP

@@ ========================================================================== @@

@create Coyote
@parent Coyote=CSP

&intelligence Coyote=1
&wits Coyote=4
&resolve Coyote=4
&strength Coyote=3
&dexterity Coyote=3
&stamina Coyote=3
&presence Coyote=4
&manipulation Coyote=1
&composure Coyote=3

&athletics Coyote=4|Running
&brawl Coyote=3
&stealth Coyote=2
&survival Coyote=4|Tracking
&empathy Coyote=0
&intimidation Coyote=3

&species_factor Coyote=7
&size Coyote=3

&damage Coyote=0L

&attack-1 Coyote=Bite

&appearance Coyote=Wild pupper. Might be a little chompy.

@force me=&note-1 Coyote=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Coyote=CSP

@@ ========================================================================== @@

@create Crocodile (Juvenile)
@parent Crocodile (Juvenile)=CSP

&intelligence Crocodile (Juvenile)=1
&wits Crocodile (Juvenile)=2
&resolve Crocodile (Juvenile)=3
&strength Crocodile (Juvenile)=4
&dexterity Crocodile (Juvenile)=1
&stamina Crocodile (Juvenile)=4
&presence Crocodile (Juvenile)=2
&manipulation Crocodile (Juvenile)=1
&composure Crocodile (Juvenile)=4

&athletics Crocodile (Juvenile)=3|Swimming
&brawl Crocodile (Juvenile)=3|Grappling
&stealth Crocodile (Juvenile)=2|Swamp
&survival Crocodile (Juvenile)=3
&empathy Crocodile (Juvenile)=0
&intimidation Crocodile (Juvenile)=3

&species_factor Crocodile (Juvenile)=5
&size Crocodile (Juvenile)=4

&damage Crocodile (Juvenile)=2L

&attack-1 Crocodile (Juvenile)=Bite|When a crocodile succeeds a bite attack, it immediately grapples its victim. Grappled victims take a two die penalty to counter grapple a crocodile once bitten.

&appearance Crocodile (Juvenile)=Bit small for a crocodile, this little murder log probably isn't done growing yet.

@force me=&note-1 Crocodile (Juvenile)=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Crocodile (Juvenile)=CSP

@@ ========================================================================== @@

@create Deer (Buck)
@parent Deer (Buck)=CSP

&intelligence Deer (Buck)=1
&wits Deer (Buck)=3
&resolve Deer (Buck)=3
&strength Deer (Buck)=3
&dexterity Deer (Buck)=3
&stamina Deer (Buck)=3
&presence Deer (Buck)=3
&manipulation Deer (Buck)=1
&composure Deer (Buck)=3

&athletics Deer (Buck)=3|Running
&brawl Deer (Buck)=3|Horns
&stealth Deer (Buck)=2
&survival Deer (Buck)=2
&empathy Deer (Buck)=0
&intimidation Deer (Buck)=2

&species_factor Deer (Buck)=8
&size Deer (Buck)=3

&damage Deer (Buck)=1L

&attack-1 Deer (Buck)=Horn

&appearance Deer (Buck)=Horny bastard with a bad attitude.

@force me=&note-1 Deer (Buck)=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Deer (Buck)=CSP

@@ ========================================================================== @@

@create Dog (Large)
@parent Dog (Large)=CSP

&intelligence Dog (Large)=1
&wits Dog (Large)=4
&resolve Dog (Large)=4
&strength Dog (Large)=4
&dexterity Dog (Large)=3
&stamina Dog (Large)=3
&presence Dog (Large)=4
&manipulation Dog (Large)=1
&composure Dog (Large)=3

&athletics Dog (Large)=4|Running
&brawl Dog (Large)=3
&stealth Dog (Large)=1
&survival Dog (Large)=3|Tracking
&empathy Dog (Large)=0
&intimidation Dog (Large)=3

&species_factor Dog (Large)=7
&size Dog (Large)=4

&damage Dog (Large)=0L

&attack-1 Dog (Large)=Bite

&appearance Dog (Large)=Big durn woofer.

@force me=&note-1 Dog (Large)=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Dog (Large)=CSP

@@ ========================================================================== @@

@create Dog (Small)
@parent Dog (Small)=CSP

&intelligence Dog (Small)=1
&wits Dog (Small)=4
&resolve Dog (Small)=4
&strength Dog (Small)=2
&dexterity Dog (Small)=3
&stamina Dog (Small)=3
&presence Dog (Small)=4
&manipulation Dog (Small)=1
&composure Dog (Small)=3

&athletics Dog (Small)=3|Running
&brawl Dog (Small)=2
&stealth Dog (Small)=1
&survival Dog (Small)=3|Tracking
&empathy Dog (Small)=0
&intimidation Dog (Small)=3

&species_factor Dog (Small)=6
&size Dog (Small)=2

&damage Dog (Small)=0L

&attack-1 Dog (Small)=Bite

&appearance Dog (Small)=Sub-woofer.

@force me=&note-1 Dog (Small)=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Dog (Small)=CSP

@@ ========================================================================== @@

@create Elephant
@parent Elephant=CSP

&intelligence Elephant=1
&wits Elephant=2
&resolve Elephant=3
&strength Elephant=9
&dexterity Elephant=2
&stamina Elephant=7
&presence Elephant=2
&manipulation Elephant=1
&composure Elephant=3

&athletics Elephant=2|Running
&brawl Elephant=3|Tusks
&stealth Elephant=0
&survival Elephant=3
&empathy Elephant=0
&intimidation Elephant=3

&species_factor Elephant=6
&size Elephant=15

&damage-tusk Elephant=1L
&damage-trample Elephant=3L

&attack-1 Elephant=Tusk
&attack-2 Elephant=Trample

&appearance Elephant=Big gray wall with ears.

@force me=&note-1 Elephant=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Elephant=CSP

@@ ========================================================================== @@

@create Fox
@parent Fox=CSP

&intelligence Fox=1
&wits Fox=4
&resolve Fox=3
&strength Fox=1
&dexterity Fox=4
&stamina Fox=3
&presence Fox=2
&manipulation Fox=1
&composure Fox=3

&athletics Fox=4|Running
&brawl Fox=3
&stealth Fox=3
&survival Fox=3|Tracking
&empathy Fox=0
&intimidation Fox=1

&species_factor Fox=7
&size Fox=2

&damage Fox=0L

&attack-1 Fox=Bite
&attack-2 Fox=Trample

&appearance Fox=Dog hardware running cat software.

@force me=&note-1 Fox=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Fox=CSP

@@ ========================================================================== @@

@create Horse
@parent Horse=CSP

&intelligence Horse=1
&wits Horse=3
&resolve Horse=3
&strength Horse=5
&dexterity Horse=3
&stamina Horse=5
&presence Horse=3
&manipulation Horse=1
&composure Horse=2

&athletics Horse=4
&brawl Horse=1|Kicking
&stealth Horse=0
&survival Horse=2
&empathy Horse=0
&intimidation Horse=0

&species_factor Horse=12
&size Horse=7

&damage-bite Horse=0L
&damage-kick Horse=2L

&attack-1 Horse=Bite
&attack-2 Horse=Kick|A successful strike from a horse's hoof inflicts the Knocked Down Tilt (GMC pg. 211)

&appearance Horse=Long leggy pupper.

&note-0 Horse=Horses can lift four times as much as a human with comparable Strength and Athletics.

@force me=&note-1 Horse=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Horse=CSP

@@ ========================================================================== @@

@create Owl
@parent Owl=CSP

&intelligence Owl=1
&wits Owl=2
&resolve Owl=3
&strength Owl=1
&dexterity Owl=3
&stamina Owl=2
&presence Owl=3
&manipulation Owl=1
&composure Owl=3

&athletics Owl=3
&brawl Owl=2|Ambush
&stealth Owl=2
&survival Owl=3
&empathy Owl=0
&intimidation Owl=2

&species_factor Owl=10
&size Owl=2

&damage-beak Owl=0L
&damage-talons Owl=1L
&damage-ambush Owl=1L

&attack-1 Owl=Beak
&attack-2 Owl=Talons
&attack-3 Owl=Ambush|Fly-by talon attack.

&appearance Owl=The floofy night parrot. Loves pettings.

&note-0 Owl=+2 on sight and sound perception rolls. Speed is flight only.

@force me=&note-1 Owl=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Owl=CSP

@@ ========================================================================== @@

@create Rat
@parent Rat=CSP

&intelligence Rat=1
&wits Rat=3
&resolve Rat=2
&strength Rat=1
&dexterity Rat=4
&stamina Rat=2
&presence Rat=1
&manipulation Rat=2
&composure Rat=2

&athletics Rat=3
&brawl Rat=0
&stealth Rat=4
&survival Rat=1
&empathy Rat=0
&intimidation Rat=0

&species_factor Rat=2
&size Rat=1

&damage Rat=---

&attack-1 Rat=Bite

&appearance Rat=Surprisingly cute in small groups. Terrifying in swarms.

@force me=&note-1 Rat=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Rat=CSP

@@ ========================================================================== @@

@create Raven or Crow
@parent Raven or Crow=CSP

&intelligence Raven or Crow=2
&wits Raven or Crow=4
&resolve Raven or Crow=4
&strength Raven or Crow=1
&dexterity Raven or Crow=3
&stamina Raven or Crow=2
&presence Raven or Crow=3
&manipulation Raven or Crow=1
&composure Raven or Crow=3

&athletics Raven or Crow=3
&brawl Raven or Crow=1
&stealth Raven or Crow=0
&survival Raven or Crow=3
&empathy Raven or Crow=0
&intimidation Raven or Crow=2

&species_factor Raven or Crow=10
&size Raven or Crow=2

&damage Raven or Crow=0L

&attack-1 Raven or Crow=Beak

&appearance Raven or Crow=Big black birb. Fond of omens.

&note-0 Raven or Crow=Speed is flight only.

@force me=&note-1 Raven or Crow=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Raven or Crow=CSP

@@ ========================================================================== @@

@create Snake
@parent Snake=CSP

&intelligence Snake=1
&wits Snake=2
&resolve Snake=3
&strength Snake=1
&dexterity Snake=3
&stamina Snake=1
&presence Snake=3
&manipulation Snake=1
&composure Snake=4

&athletics Snake=1
&brawl Snake=1
&stealth Snake=4
&survival Snake=3
&empathy Snake=0
&intimidation Snake=1

&species_factor Snake=2
&size Snake=2

&damage Snake=0L

&attack-1 Snake=Bite|Many snakes possess a venomous bite, with Toxicity varying from 3, for weaker poisons, all the way to 10 for the most lethal vipers. This inflicts the Poisoned tilt with Moderate or Grave severity as deemed appropriate.

&appearance Snake=Danger noodle! No step!

@force me=&note-1 Snake=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Snake=CSP

@@ ========================================================================== @@

@create Toad
@parent Toad=CSP

&intelligence Toad=0
&wits Toad=2
&resolve Toad=1
&strength Toad=1
&dexterity Toad=3
&stamina Toad=1
&presence Toad=1
&manipulation Toad=1
&composure Toad=3

&athletics Toad=2|Hopping
&brawl Toad=0
&stealth Toad=0
&survival Toad=3|Finding Food
&empathy Toad=0
&intimidation Toad=0

&species_factor Toad=2
&size Toad=1

&appearance Toad=Slippy boi. Sometimes tasty.

@force me=&note-1 Toad=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Toad=CSP

@@ ========================================================================== @@

@create Weasel or Ferret
@parent Weasel or Ferret=CSP

&intelligence Weasel or Ferret=1
&wits Weasel or Ferret=2
&resolve Weasel or Ferret=2
&strength Weasel or Ferret=1
&dexterity Weasel or Ferret=3
&stamina Weasel or Ferret=2
&presence Weasel or Ferret=2
&manipulation Weasel or Ferret=1
&composure Weasel or Ferret=2

&athletics Weasel or Ferret=2
&brawl Weasel or Ferret=1
&stealth Weasel or Ferret=4
&survival Weasel or Ferret=3
&empathy Weasel or Ferret=0
&intimidation Weasel or Ferret=1

&species_factor Weasel or Ferret=7
&size Weasel or Ferret=2

&damage Weasel or Ferret=0L

&attack-1 Weasel or Ferret=Bite

&appearance Weasel or Ferret=Cat noodle sometimes eats danger noodles.

@force me=&note-1 Weasel or Ferret=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Weasel or Ferret=CSP

@@ ========================================================================== @@

@create Wolf
@parent Wolf=CSP

&intelligence Wolf=1
&wits Wolf=4
&resolve Wolf=4
&strength Wolf=4
&dexterity Wolf=3
&stamina Wolf=3
&presence Wolf=4
&manipulation Wolf=1
&composure Wolf=3

&athletics Wolf=4|Running
&brawl Wolf=3
&stealth Wolf=2
&survival Wolf=4|Tracking
&empathy Wolf=0
&intimidation Wolf=3

&species_factor Wolf=7
&size Wolf=4

&damage Wolf=1L

&attack-1 Wolf=Bite

&appearance Wolf=Danger woofer.

@force me=&note-1 Wolf=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Wolf=CSP

@@ ========================================================================== @@

@create Crocodile (Adult)
@parent Crocodile (Adult)=CSP

&intelligence Crocodile (Adult)=1
&wits Crocodile (Adult)=2
&resolve Crocodile (Adult)=3
&strength Crocodile (Adult)=6
&dexterity Crocodile (Adult)=2
&stamina Crocodile (Adult)=4
&presence Crocodile (Adult)=2
&manipulation Crocodile (Adult)=1
&composure Crocodile (Adult)=4

&athletics Crocodile (Adult)=3|Swimming
&brawl Crocodile (Adult)=3|Grappling
&stealth Crocodile (Adult)=2|Swamp
&survival Crocodile (Adult)=3
&empathy Crocodile (Adult)=0
&intimidation Crocodile (Adult)=3

&species_factor Crocodile (Adult)=5
&size Crocodile (Adult)=7

&damage-bite Crocodile (Adult)=2L
&damage-tail Crocodile (Adult)=1L

&attack-1 Crocodile (Adult)=Bite|When the creature succeeds on a bite attack, it immediately grapples its victim. Grappled victims take a two die penalty to counter grapple the creature once bitten.

&attack-2 Crocodile (Adult)=Tail|Can only target creatures standing behind the creature.

&appearance Crocodile (Adult)=Full-grown American murder log. Do not disturb.

&note-0 Crocodile (Adult)=Custom content created for NOLA by Buster.

@force me=&note-1 Crocodile (Adult)=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Crocodile (Adult)=CSP

@@ ========================================================================== @@

@create Dragon
@parent Dragon=CSP

&intelligence Dragon=3
&wits Dragon=4
&resolve Dragon=4
&strength Dragon=6
&dexterity Dragon=2
&stamina Dragon=4
&presence Dragon=3
&manipulation Dragon=3
&composure Dragon=4

&athletics Dragon=3|Flight
&brawl Dragon=4
&stealth Dragon=0
&survival Dragon=3
&empathy Dragon=0
&intimidation Dragon=3

&species_factor Dragon=6
&size Dragon=7

&damage-bite Dragon=2L
&damage-claw Dragon=1L

&attack-1 Dragon=Bite
&attack-2 Dragon=Claw

&appearance Dragon=Scaly bastard with big teeth straight outta the Hedge.

&note-0 Dragon=Flight is x2 speed. Custom content.

@force me=&note-1 Dragon=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Dragon=CSP


*/