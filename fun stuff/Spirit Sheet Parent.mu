/*
Dependencies:
	wheader()
	wfooter()
	wdivider()

*/

@create Spirit Sheet Parent <SSP>=10
@set SSP=SAFE

&layout.name-and-value SSP=strcat(%0, if(t(%0), :), space(sub(21, add(strlen(%0), strlen(%1)))), %1)

&layout.row SSP=strcat(space(3), u(layout.name-and-value, %0, %1), space(4), u(layout.name-and-value, %2, %3), space(4), u(layout.name-and-value, %4, %5))

&layout.row-no-values SSP=strcat(space(3), ljust(strtrunc(%0, 22), 22), space(4), ljust(strtrunc(%1, 22), 22), space(4), ljust(strtrunc(%2, 22), 22))

&layout.list-with-values SSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), strcat(setq(0, u(f.lookup-from-list-of-attributes, %0, itext(0), 0)), setq(1, u(f.lookup-from-list-of-attributes, %0, itext(0), 1)), setq(2, u(f.lookup-from-list-of-attributes, %0, itext(0), 2)), u(layout.row, first(%q0, |), rest(%q0, |), first(%q1, |), rest(%q1, |), first(%q2, |), rest(%q2, |))),, %r)

&layout.list SSP=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), u(layout.row-no-values, u(f.lookup-from-list-of-attributes, %0, itext(0), 0), u(f.lookup-from-list-of-attributes, %0, itext(0), 1), u(f.lookup-from-list-of-attributes, %0, itext(0), 2)),, %r)

&layout.note SSP=wrap(strcat(space(3), if(t(%1), strcat(ljust(strcat(%0, :%b), 13), v(%1)), v(%0))), if(t(%1), 61, 74), Left,, space(3), if(t(%1), 16, 3), %r, 74)

@@ %0 - list to extract from
@@ %1 - Which row we're on. 0-index.
@@ %2 - which column we're on, 0-index.
@@ Assuming 3-column always.

&f.lookup-from-list-of-attributes SSP=if(gte(words(%0), add(mul(%1, 3), %2, 1)), v(extract(%0, add(mul(%1, 3), %2, 1), 1)))

&f.get-trait SSP=min(add(default(%0, 0), default(%1, 0), %2), switch(default(rank, 0), 0, 0, 1, 5, 2, 7, 3, 9, 4, 12, 15))

&f.get-defense SSP=if(lte(default(rank, 0), 1), max(default(power, 0), default(finesse, 0)), min(default(power, 0), default(finesse, 0)))

&f.get-species-factor SSP=default(species_factor, default(rank, 1))

&f.get-size SSP=default(species_factor, default(rank, 1))

@desc SSP=strcat(wheader(strcat(name(me), %b-%b, switch(default(rank, 0), 4, Ensah %(Rank 4%), 3, Ensih %(Rank 3%), 2, Hursih %(Rank 2%), 1, Hursih %(Rank %), 0, Muthra %(Rank 0%), Dihir %(Rank 5+%)))), %r, u(layout.note, Concept, concept), %r, u(layout.note, Aspiration, aspiration), %r, u(layout.note, Ban, ban), %r, u(layout.note, Bane, bane), %r, wdivider(Attributes), %r, u(layout.row, Power, default(power, 0), Finesse, default(finesse, 0), Resistance, default(resistance, 0)), %r, wdivider(Advantages), %r, u(layout.row, Essence, default(essence, 0), Size, u(f.get-size), Species factor, u(f.get-species-factor)), %r, wdivider(Traits), %r, u(layout.row, Willpower, u(f.get-trait, resistance, finesse), Corpus, u(f.get-trait,, resistance, u(f.get-size)), Initiative, u(f.get-trait, finesse, resistance)), %r, u(layout.row, Defense, u(f.get-defense), Speed, u(f.get-trait, power, finesse, u(f.get-species-factor))), %r, wdivider(Influences), %r, u(layout.list-with-values, lattr(me/influence-*)), %r, wdivider(Numina), %r, u(layout.list, lattr(me/numina-*)), %r, wdivider(Notes), %r, iter(sort(lattr(me/note-*)), u(layout.note, itext(0)),, %r%r), %r, wfooter())

/*

Sample spirit sheet:

@create Upgrade
@parent Upgrade=SSP

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

&bane upgrade=<TBD>

&note-benefits Upgrade=Totem Advantages: Hobbyist Clique - Crafts (2 dots), Good Time Management (1 dot)

&note-appearance upgrade=Appearance: Generally appears either as a slightly fuzzy image that seems like if Dwayne Wayne from A Different World had gotten Max Headroomed, or as the mascot of the 1984 World's Fair in New Orleans, Seymore D. Fair, a second-lining anthropomorphic pelican in a blue tuxedo coat, spats and top hat.


*/