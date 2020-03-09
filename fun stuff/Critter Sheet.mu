/*
Work in progress. Probably not ready for use.

Dependencies:
	wheader()
	wfooter()
	wdivider()

*/

@create Critter Sheet Parent <CSP>=10
@set CSP=SAFE PARENT_OK

&layout.name-and-value CSP=strcat(%0, if(t(%0), :), space(sub(21, add(strlen(%0), strlen(%1)))), %1)

&layout.skill CSP=strcat(%0, if(t(%0), :%b), first(%1, |), if(t(rest(%1, |)), strcat(%b, %(, rest(%1, |), %))))

&layout.row CSP=strcat(space(3), u(layout.name-and-value, %0, %1), space(4), u(layout.name-and-value, %2, %3), space(4), u(layout.name-and-value, %4, %5))

&layout.row-no-values CSP=strcat(space(3), ljust(strtrunc(%0, 22), 22), space(4), ljust(strtrunc(%1, 22), 22), space(4), ljust(strtrunc(%2, 22), 22))

&layout.two-column CSP=strcat(space(3), ljust(strtrunc(%0, 37), 37), space(2), ljust(strtrunc(%1, 37), 37))

&layout.list-with-values CSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), strcat(setq(0, u(f.lookup-from-list-of-attributes, %0, itext(0), 0, 3)), setq(1, u(f.lookup-from-list-of-attributes, %0, itext(0), 1, 3)), setq(2, u(f.lookup-from-list-of-attributes, %0, itext(0), 2, 3)), u(layout.row, first(%q0, |), rest(%q0, |), first(%q1, |), rest(%q1, |), first(%q2, |), rest(%q2, |))),, %r)

&layout.list CSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), u(layout.row-no-values, u(f.lookup-from-list-of-attributes, %0, itext(0), 0, 3), u(f.lookup-from-list-of-attributes, %0, itext(0), 1, 3), u(f.lookup-from-list-of-attributes, %0, itext(0), 2, 3)),, %r)

&layout.list-two-column CSP=iter(lnum(add(div(words(%0), 2), t(mod(words(%0), 2)))), u(layout.two-column, u(f.lookup-from-list-of-attributes, %0, itext(0), 0, 2), u(f.lookup-from-list-of-attributes, %0, itext(0), 1, 2)),, %r)

@@ %0 - title
@@ %1 - value
@@ %2 - title width
&layout.note CSP=wrap(strcat(space(3), if(t(%1), strcat(ljust(strcat(%0, :%b), %2), default(%1, Unset.)), default(%0, Unset.))), if(t(%1), sub(74, %2), 74), Left,, space(3), if(t(%1), add(%2, 3), 3), %r, 74)

&layout.attributes CSP=strcat(wdivider(Attributes), %r, u(layout.row, Intelligence, default(intelligence, 1), Strength, default(strength, 1), Presence, default(presence, 1)), %r, u(layout.row, Wits, default(wits, 1), Dexterity, default(dexterity, 1), Manipulation, default(manipulation, 1)), %r, u(layout.row, Resolve, default(resolve, 1), Stamina, default(stamina, 1), Composure, default(composure, 1)))

&layout.skills CSP=strcat(wdivider(Skills), %r, u(layout.two-column, u(layout.skill, Athletics, default(athletics, 0)), u(layout.skill, Empathy, default(empathy, 0))), %r, u(layout.two-column, u(layout.skill, Brawl, default(brawl, 0)), u(layout.skill, Intimidation, default(intimidation, 0))), %r, u(layout.two-column, u(layout.skill, Stealth, default(stealth, 0)), u(layout.skill, Survival, default(survival, 0))))

&layout.list-of-notes CSP=strcat(wdivider(%0), %r, iter(sort(lattr(me/%1*)), u(layout.note, itext(0)),, %r%r))

@@ %0 - list to extract from
@@ %1 - Which row we're on. 0-index.
@@ %2 - which column we're on, 0-index.
@@ %3 - number of columns

&f.lookup-from-list-of-attributes CSP=if(gte(words(%0), add(mul(%1, %3), %2, 1)), v(extract(%0, add(mul(%1, %3), %2, 1), 1)))

&f.get-trait CSP=add(default(%0, 1), default(%1, 1), %2)

@@ Animals take the MAX of wits or dex, plus athletics.
@@ Need a book reference for that...

&f.get-defense CSP=add(max(default(wits, 1), default(dexterity, 1)), first(default(athletics, 0), |))

&f.get-species-factor CSP=default(species_factor, 1)

&f.get-size CSP=default(size, 1)

@desc CSP=strcat(wheader(name(me)), %r, u(layout.note, Appearance, appearance), %r, u(layout.attributes), %r, u(layout.skills), %r, wdivider(Traits), %r, u(layout.row, Willpower, u(f.get-trait, resolve, composure), Health, u(f.get-trait, size, stamina), Initiative, u(f.get-trait, dexterity, composure)), %r, u(layout.row, Defense, u(f.get-defense), Speed, u(f.get-trait, strength, dexterity, u(f.get-species-factor))), %r, u(layout.list-of-notes, Attacks, attack-), %r, u(layout.list-of-notes, Notes, note-), wfooter())

/*

Sample critter sheet:

@create Crocodile
@parent Crocodile=CSP

&intelligence Crocodile=1
&wits Crocodile=2
&resolve Crocodile=3
&strength Crocodile=4
&dexterity Crocodile=1
&stamina Crocodile=4
&presence Crocodile=2
&manipulation Crocodile=1
&composure Crocodile=4

&athletics Crocodile=3|Swimming
&brawl Crocodile=3|Grappling
&stealth Crocodile=2|Swamp
&survival Crocodile=3
&empathy Crocodile=0
&intimidation Crocodile=3

&species_factor Crocodile=5
&size Crocodile=4

&attack-1 Crocodile=Bite: +2 damage, 7 dice pool. When a crocodile succeeds a bite attack, it immediately grapples its victim. Grappled victims take a two die penalty to counter grapple a crocodile once bitten.

&appearance Crocodile=Bit small for a crocodile, this salt-water murder log probably isn't done growing yet.

@force me=&note-1 Crocodile=Approved [time()] by [moniker(%#)] (%#).

*/