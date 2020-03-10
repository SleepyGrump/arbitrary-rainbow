/*
Dependencies:
	wheader()
	wfooter()
	wdivider()

Wiki help page:

Spirit character sheets are available. It's basically an on-game way for STs to keep track of their spirits.

* +spirits - list the spirits available
* +spirit <name> - view pre-generated stats for the spirits

To create one of your own:

@create Spirit
@parent Spirit=#960
@set Spirit=NO_COMMAND

&power Spirit=1
&finesse Spirit=2
&resistance Spirit=3
&rank Spirit=2
&essence Spirit=4

&numina-1 Spirit=Numina 1
&numina-2 Spirit=Numina 2

&influence-1 Spirit=Thing influenced|1

&concept Spirit=The Spirit of Trying Out New Things

&aspiration Spirit=Do something new!

&ban Spirit=Can't do the same thing twice.

&bane Spirit=Anything older than 100 years.

&benefits Spirit=Merit 1 (1 XP), Merit 2 (2 XP)

&appearance Spirit=Sparkling shining brand spanking new!

&note-1 Spirit=Fantastic power, itty bitty living space.

l Spirit

*/

@create Spirit Sheet Parent <SSP>=10
@set SSP=SAFE PARENT_OK COMMANDS

&layout.name-and-value SSP=strcat(setq(0, ulocal(f.get-three-column-widths, %#)), %0, if(t(%0), :), space(sub(last(%q0, |), add(1, strlen(%0), strlen(%1)))), %1)

&layout.row SSP=strcat(setq(0, ulocal(f.get-three-column-widths, %#)), space(3), ulocal(layout.name-and-value, %0, %1, last(%q0, |)), space(first(%q0, |)), ulocal(layout.name-and-value, %2, %3, last(%q0, |)), space(extract(%q0, 2, 1, |)), ulocal(layout.name-and-value, %4, %5, last(%q0, |)))

&layout.row-no-values SSP=strcat(setq(0, ulocal(f.get-three-column-widths, %#)), space(3), ljust(strtrunc(%0, last(%q0, |)), last(%q0, |)), space(first(%q0, |)), ljust(strtrunc(%1, last(%q0, |)), last(%q0, |)), space(extract(%q0, 2, 1, |)), ljust(strtrunc(%2, last(%q0, |)), last(%q0, |)))

&layout.list-with-values SSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), strcat(setq(0, ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 0)), setq(1, ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 1)), setq(2, ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 2)), ulocal(layout.row, first(%q0, |), rest(%q0, |), first(%q1, |), rest(%q1, |), first(%q2, |), rest(%q2, |))),, %r)

&layout.list SSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), ulocal(layout.row-no-values, ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 0), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 1), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 2)),, %r)

&layout.name SSP=strcat(name(me), %b-%b, switch(default(rank, 0), 4, Ensah %(Rank 4%), 3, Ensih %(Rank 3%), 2, Hursih %(Rank 2%), 1, Hursih %(Rank %), 0, Muthra %(Rank 0%), Dihir %(Rank 5+%)))

&layout.dbref-list SSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), ulocal(layout.row-no-values, ulocal(f.lookup-from-list-of-names, %0, itext(0), 0, 3), ulocal(f.lookup-from-list-of-names, %0, itext(0), 1, 3), ulocal(f.lookup-from-list-of-names, %0, itext(0), 2, 3)),, %r)

@@ %0 - title
@@ %1 - value
@@ %2 - title width
&layout.note SSP=strcat(setq(0, sub(width(%#), 6)), wrap(strcat(space(3), if(t(%1), strcat(ljust(strcat(%0, :%b), %2), default(%1, Unset.)), default(%0, Unset.))), if(t(%1), sub(%q0, %2), %q0), Left,, space(3), if(t(%1), add(%2, 3), 3), %r, %q0))

@@ %0 - list to extract from
@@ %1 - Which row we're on. 0-index.
@@ %2 - which column we're on, 0-index.
@@ Assuming 3-column always.

&f.lookup-from-list-of-attributes SSP=if(gte(words(%0), add(mul(%1, 3), %2, 1)), v(extract(%0, add(mul(%1, 3), %2, 1), 1)))

@@ %0 - list to extract from
@@ %1 - Which row we're on. 0-index.
@@ %2 - which column we're on, 0-index.
@@ %3 - number of columns

&f.lookup-from-list-of-names SSP=if(gte(words(%0), add(mul(%1, %3), %2, 1)), name(extract(%0, add(mul(%1, %3), %2, 1), 1)))

&f.get-trait SSP=min(add(default(%0, 0), default(%1, 0), %2), switch(default(rank, 0), 0, 0, 1, 5, 2, 7, 3, 9, 4, 12, 15))

&f.get-defense SSP=if(lte(default(rank, 0), 1), max(default(power, 0), default(finesse, 0)), min(default(power, 0), default(finesse, 0)))

&f.get-species-factor SSP=default(species_factor, default(rank, 1))

&f.get-size SSP=default(size, default(rank, 1))

&f.get-three-column-widths SSP=strcat(setq(0, sub(width(%0), 6)), setq(0, sub(%q0, 4)), setq(1, mod(%q0, 3)), setq(0, sub(%q0, %q1)), add(mod(%q1, 2), div(%q1, 2), 2), |, add(div(%q1, 2), 2), |, div(%q0, 3))


@desc SSP=strcat(wheader(ulocal(layout.name)), %r, ulocal(layout.note, Concept, concept, 13), %r, ulocal(layout.note, Aspiration, aspiration, 13), %r, wdivider(Attributes), %r, ulocal(layout.row, Power, default(power, 0), Finesse, default(finesse, 0), Resistance, default(resistance, 0)), %r, wdivider(Advantages), %r, ulocal(layout.row, Essence, default(essence, 0), Size, ulocal(f.get-size), Species factor, ulocal(f.get-species-factor)), %r, wdivider(Traits), %r, ulocal(layout.row, Willpower, ulocal(f.get-trait, resistance, finesse), Corpus, ulocal(f.get-trait,, resistance, ulocal(f.get-size)), Initiative, ulocal(f.get-trait, finesse, resistance)), %r, ulocal(layout.row, Defense, ulocal(f.get-defense), Speed, ulocal(f.get-trait, power, finesse, ulocal(f.get-species-factor))), %r, wdivider(Influences), %r, ulocal(layout.list-with-values, lattr(me/influence-*)), %r, wdivider(Numina), %r, ulocal(layout.list, lattr(me/numina-*)), %r, wdivider(Notes), %r, space(3), +view%b, name(me), /notes for notes., %r, wfooter())

&view-notes SSP=strcat(wheader(ulocal(layout.name) - Notes), %r%r, ulocal(layout.note, Ban, ban, 13), %r%r, ulocal(layout.note, Bane, bane, 13), %r%r, ulocal(layout.note, Benefits, benefits, 13), %r%r, ulocal(layout.note, Appearance, appearance, 13), %r%r, setr(0, iter(sort(lattr(me/note-*)), ulocal(layout.note, itext(0)),, %r%r)), if(t(%q0), %r%r), wfooter())


&cmd-+spirits SSP=$+spirits:@pemit %#=strcat(wheader(Spirit list), %r, ulocal(layout.dbref-list, sortby(f.sort-by-name, lcon(me))), %r, wfooter(+spirit <name> for more info.))

&cmd-+spirit SSP=$+spirit *:@pemit %#=if(t(setr(L, locate(me, %0, i))), udefault(%qL/desc, This spirit doesn't have stats yet.), strcat(alert(Spirits), %b, if(strmatch(%qL, #-1*), Can't find a spirit named '%0'., Found multiple spirits whose names start with '%0'. Did you mean one of these? [itemize(trim(squish(iter(lcon(me), if(strmatch(name(itext(0)), %0*), name(itext(0))),, |), |), b, |), |)])))

/*

@@ ========================================================================== @@

@create Beshilu
@parent Beshilu=SSP
@set Beshilu=NO_COMMAND

&power Beshilu=3
&finesse Beshilu=3
&resistance Beshilu=3
&rank Beshilu=2
&essence Beshilu=9

&numina-1 Beshilu=Left-Handed Spanner
&numina-2 Beshilu=Sign
&numina-3 Beshilu=Telekinesis

&influence-1 Beshilu=Technology|2

&concept Beshilu=

&aspiration Beshilu=

&ban Beshilu=

&bane Beshilu=

&benefits Beshilu=

&appearance Beshilu=

@force me=&note-1 Beshilu=Approved [time()] by [moniker(%#)] (%#).

@wait 1=@tel Beshilu=SSP

@@ ========================================================================== @@

@@ Sample personal spirit sheet:

@create Upgrade
@parent Upgrade=SSP
@set Upgrade=NO_COMMAND

&power upgrade=3
&finesse upgrade=3
&resistance upgrade=3
&rank upgrade=2
&essence upgrade=9

&numina-1 upgrade=Left-Handed Spanner
&numina-2 upgrade=Sign
&numina-3 upgrade=Telekinesis

&influence-1 Upgrade=Technology|2

&concept upgrade=The Spirit of Taking It To The Next Level

&aspiration upgrade=Improve Something.

&ban Upgrade=Can't use the most basic version of a thing - it must be either customized or intentionally acquired as not the cheapest or simplest form available. Game effect: All members of the pack must pay +1 Availability for any equipment in order to have it made custom, or must build it themselves.

&bane upgrade=Unworked lead. It's a conductor, but in its raw state it foils him, and it is geologically colocated with silver, creating a sympathetic bane with the wolves.


&benefits Upgrade=Hobbyist Clique (Crafts) (2 XP), Good Time Management (1 XP)

&appearance upgrade=Generally appears either as a slightly fuzzy image that seems like if Dwayne Wayne from A Different World had gotten Max Headroomed, or as the mascot of the 1984 World's Fair in New Orleans, Seymore D. Fair, a second-lining anthropomorphic pelican in a blue tuxedo coat, spats and top hat.

@force me=&note-1 Upgrade=Approved [time()] by [moniker(%#)] (%#).

*/