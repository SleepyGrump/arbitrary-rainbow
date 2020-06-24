/*
================================================================================

Dependencies:
	* boxtext() - see Layout Functions
	* fitcolumns() - see Layout Functions
	* moniker()
	* wheader()
	* wfooter()
	* alert()

================================================================================

TO DO: No known development remaining. Report bugs to the github!

* If someone really really wants it, I'll make +eq/give work for players who have a piece of equipment and want to give it away to someone else. Not useful for NOLA though.

* Make equipment display a little more readable. Instead of listing them all out, hide the details until players go to +eq/details.

* Allow players to +eq/prove their entire equipment list.

================================================================================

Staff commands:

* +eq/create <title>=<details>
* +eq/destroy <title> - does not remove it from the players who have it!
* +eq/tag <title>=<tag> - tag equipment mental, physical, whatever
* +eq/untag <title>=<tag to remove> - untag equipment
* +eq/clone <title>=<new piece of equipment> - copy an old equipment piece
* +eq/update <title>=<new details>

* +eq/give <player>=<title> - give 'em stuff
* +eq/take <player>=<title> - take their stuff
* +eq/takeall <title> - take it away from everybody
* +eq/wipe <player> - wipe a player's equipment

* +eq/note <player>/<title>=<note> - Anything special about this item? number, etc?

* +eq/view <player> - see their stuff
* +eq/date <player> - see their stuff by date of purchase
* +eq/details <player>/<title> - view details on their stuff
* +eq/players <name> - find all players with <name> equipment

Player commands:

* +eq - list your equipment
* +eq <player name or equipment title> - alias for /view and /details
* +eq/view - same as +eq
* +eq/date - view equipment by date of purchase
* +eq/details <title> - view details on a piece of equipment
* +eq/list - list equipment tags
* +eq/list <tag> - list all equipment in a particular tag
* +eq/list untagged - list untagged equipment
* +eq/find <title> - list all equipment that starts with that text
* +eq/prove <title> - prove you have a piece of equipment to the room
* +eq/prove <title>=<player> - prove you have a piece of equipment to a player

================================================================================

Changelog:

2019-11-05: Added "+eq/note" and made "+eq/details" accept a player/title syntax.
2019-12-13: Consolidated +eq/view and +eq layouts. Made equipment notes show up in the default layout.
2019-12-17: Added dupe-checking to +eq/create. Created a default parsing for +eq <thing> where it'll execute either /view or /details depending what you typed.
2019-12-18:
	* Fixed the +eq/find bug.
	* Added +eq/players. That naturally led to +eq/takeall and +eq/wipe.
	* Added +eq/clone.
	* Did +eq/update just to wrap up new functionality.
	* Added sorting of equipment lists because why the heck not.
2020-01-07: Made +eq/view work without a name for players. Made it show the untruncated version of the equipment.
2020-04-30:
	* Make lists of equipment more readable and less spammy.
2020-05-01:
	* +eq/date <player> - list equipment by date, showing only name, tags and notes, useful for seeing when a player last got equipment.
2020-05-09:
	* +eq/month <player> - list equipment bought in the current month, by Availability. I tried to avoid sticking any system knowledge in this code - Availability is how CofD tracks equipment cost (Av1 is cheap, Av5 is expensive) - but I couldn't think of a good way to display what I needed and still make it easy for staff to remember what to type. I could've made it +eq/month <player>=<tag to search for> but then staff would just have more to remember, and I don't honestly see what use there is for that. Since AFAIK no one else is using this, I figured it's OK to cheat a little on the system agnostic criteria.
2020-05-16: Discovered a bug where you can't have "Chain" and "Chainmail" in the same system and that just can't be allowed. Exact match should beat a partial match. Not fixed yet...
2020-06-23: Fixed a bug with +eq/update to show the right text in the success output.

TODO:
	* Fix the Chainmail bug.
	* Create an item dispenser for CGEN players.
	* Add a "Count" field on the player.
	* Add a "Detail" field (or fix Notes to be less detailed).
	* Make the item honor the parenthetical sytnax - +eq/give Name=Item (Note) - see how that plays with items that already have parentheticals in their names first. (Honestly those are supposed to be replaced by a thing...)

================================================================================

Process to move equipment that previously existed and was a duplicate from before we had dupe-checking:

e #662/eq-99-*
e #662/eq-4-*

@dolist search(type=player)={@switch/first hasattr(##, _EQ-99-NAME)=1, { @mvattr ##=_EQ-99-NAME,_EQ-4-NAME; @mvattr ##=_EQ-99-NOTE,_EQ-4-NOTE;};}

@wipe #662/eq-99-*

================================================================================

*/

@create Equipment Database <EQD>=10
@set EQD=SAFE

@create Equipment Functions <EQF>=10
@set EQF=SAFE INHERIT
@parent EQF=EQD

@create Equipment Commands <EQC>=10
@set EQC=SAFE INHERIT
@parent EQC=EQF

@force me=&vD EQF=[num(EQD)]

@force me=&d.eqf me=[search(name=Equipment Functions <EQF>)]
@force me=&d.eqc me=[search(name=Equipment Commands <EQC>)]

@desc [v(d.eqc)]=%RStaff commands:%R%R* +eq/create <title>=<details>%R* +eq/destroy <title> - does not remove it from the players who have it!%R* +eq/tag <title>=<tag> - tag equipment mental, physical, whatever%R* +eq/untag <title>=<tag to remove> - untag equipment%R* +eq/clone <title>=<new piece of equipment> - copy an old equipment piece%R* +eq/update <title>=<new details>%R%R* +eq/give <player>=<title> - give 'em stuff%R* +eq/take <player>=<title> - take their stuff%R* +eq/takeall <title> - take it away from everybody%R* +eq/wipe <player> - wipe a player's equipment%R%R* +eq/note <player>/<title>=<note> - Anything special about this item? number, etc?%R%R* +eq/view <player> - see their stuff%R* +eq/details <player>/<title> - view details on their stuff%R* +eq/players <name> - find all players with <name> equipment%R%RPlayer commands:%R%R* +eq - list your equipment%R* +eq <player name or equipment title> - alias for /view and /details%R* +eq/details <title> - view details on a piece of equipment%R* +eq/list - list equipment tags%R* +eq/list <tag> - list all equipment in a particular tag%R* +eq/list untagged - list untagged equipment%R* +eq/find <title> - list all equipment that starts with that text%R* +eq/prove <title> - prove you have a piece of equipment to the room%R* +eq/prove <title>=<player> - prove you have a piece of equipment to a player%R

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Layouts
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %0 - error message
&layout.error [v(d.eqf)]=alert(Equipment malfuction) %0

@@ %0 - player
@@ %1 - target
&layout.equipment [v(d.eqf)]=strcat(wheader(if(match(%0, %1), Your, name(%1)'s) equipment, %0), %R, ulocal(layout.short-equipment, %0, %1, ulocal(f.sort-equipment-attrs, lattr(%1/_eq-*-name), %b)), %R, wfooter(, %0))

@@ %0 - player
@@ %1 - target (might not exist)
@@ %2 - equipment list
&layout.short-equipment [v(d.eqf)]=fitcolumns(iter(%2, strcat(xget(%vD, trim(itext(0), l, _)), setq(0, ulocal(f.get-equipment-note, %1, itext(0))), if(t(%q0), strcat(%b, %(, %q0, %)))), if(strmatch(%2, *|*), |), |), |)

@@ %0 - player
@@ %1 - tag if there is one
&layout.list-equipment [v(d.eqf)]=strcat(wheader(if(t(%1), Equipment tagged '%1', Equipment tags), %0), %R, if(t(%1), ulocal(layout.short-equipment, %0,, ulocal(f.sort-equipment-attrs, ulocal(f.list-equipment-by-tag, %1), %b)), fitcolumns(ulocal(f.list-equipment-tags, %1), |, %0)), %R, wfooter(, %0))

@@ %0 - player
@@ %1 - title if there is one
&layout.find-equipment [v(d.eqf)]=strcat(wheader(Equipment matching '%1', %0), %R, setq(0, ulocal(f.sort-equipment-attrs, ulocal(f.find-equipment-by-title, %0, %1), |)), if(t(%q0), ulocal(layout.short-equipment, %0,, %q0), No equipment by the title '%1' found.), %R, wfooter(, %0))

@@ %0 - player viewing
@@ %1 - title of the presumed equipment
@@ %2 - player the equipment is on
&layout.equipment-details [v(d.eqf)]=if(t(setr(0, first(ulocal(f.find-all-equipment-by-title, %1), |))), strcat(wheader(ulocal(f.get-equipment-title, %q0), %0), %R%R, boxtext(ulocal(f.get-equipment-details, %q0),,, %0), %R%R, boxtext(strcat(Tags:, %b, setq(1, ulocal(f.get-equipment-tags, %q0)), if(t(%q1), itemize(%q1, |), None.)),,, %0), %R%R, if(t(%2), strcat(if(hasattr(%2, _%q0), boxtext(rest(xget(%2, _%q0), |),,, %0)), if(hasattr(%2, edit(_%q0, NAME, note)), strcat(%r%r%b, Note:, %b, xget(%2, edit(_%q0, NAME, note)))))), %r, wfooter(, %0)), ulocal(layout.error, Could not find equipment '%1'.))

@@ %0 - player
@@ %1 - equipment found
@@ %2 - target player
@@ %3 - "to" string - to "you", "the room".
&layout.prove-equipment [v(d.eqf)]=strcat(alert(Equipment), name(%0) proves, %b, poss(%0), %b, equipment ', setr(0, ulocal(f.get-equipment-title, trim(%1, l, _))), ', %b, to %3:, %R%R, u(layout.equipment-details, %2, %q0, %0))

@@ %0 - list of equipment attributes separated by pipes
&layout.list-equipment-names [v(d.eqf)]=itemize(iter(ulocal(f.sort-equipment-attrs, %0, |), xget(%vD, itext(0)), |, |), |)

@@ %0 - equipment attr
&layout.list-players-with-equipment [v(d.eqf)]=strcat(setq(0, ulocal(f.find-equipment-on-players, %0)), alert(Equipment), %b, if(t(%q0), strcat(The following players have the equipment ', xget(%vD, %0), ':, %b, itemize(iter(%q0, moniker(itext(0)),, |), |)), strcat(No players have the equipment, %b, ', xget(%vD, %0), '.)))

@@ %0 - player
@@ %1 - equipment attribute
&layout.equipment-all-lines [v(d.eqf)]=strcat(ulocal(f.format-date, edit(revwords(extract(revwords(xget(%0, _%1)), 1, 5)), .,)), setq(0, strcat(xget(%vD, %1), :, %b, itemize(xget(%vD, edit(%1, NAME, TAGS)), |))), if(lte(strlen(%q0), sub(%q1, 2)), strcat(%b, %q0), strcat(%b, %q0)))

@@ %0 - player
@@ %1 - target
&layout.equipment-by-date [v(d.eqf)]=strcat(wheader(if(match(%0, %1), Your, name(%1)'s) equipment by date, %0), %R, iter(ulocal(f.sort-equipment-by-date, lattr(%1/_eq-*-name), %b), strcat(ulocal(layout.equipment-all-lines, %1, trim(itext(0), l, _)), setq(0, ulocal(f.get-equipment-note, %1, itext(0))), if(t(%q0), strcat(%R, space(3), Note:, %b, %q0))),, %R), %R, wfooter(, %0))

@@ %0 - viewer
@@ %1 - target character
@@ %2 - equipment attribute
@@ %3 - partial tag
&layout.equipment-line-date-and-tag [v(d.eqf)]=strcat(%b, name(%1), %b, bought, %b, first(setr(0, xget(%1, %2)), |), %b, on, %b, ulocal(f.format-date, edit(revwords(extract(revwords(%q0), 1, 5)), .,)), %b, with, %b, if(t(setr(0, ulocal(f.has-tag, %2, %3))), %q0, No %3), .)

@@ %0 - viewer
@@ %1 - target character
@@ %2 - month
@@ %3 - year
@@ %4 - tag
&layout.equipment-by-month-year [v(d.eqf)]=strcat(setq(0, trim(squish(edit(strcat(setq(1, filter(f.filter-by-month-year, ulocal(f.sort-equipment-by-date, lattr(%1/_eq-*-name), %b),,, %1, %2, %3)), if(t(%q1), iter(%q1, itext(1)/[itext(0)]))), |, %b)))), if(t(%q0), iter(%q0, ulocal(layout.equipment-line-date-and-tag, %0, %1, rest(itext(0), /), %4),, %r)))

@@ %0 - viewer
@@ %1 - target character
@@ %2 - month
@@ %3 - year
@@ %4 - tag
&layout.pretty-equipment-month-year [v(d.eqf)]=strcat(wheader(Equipment purchased in %2 %3, %0), %r%r, ulocal(layout.equipment-by-month-year, %0, %1, %2, %3, %4), %r%r, wfooter(, %0))

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Local functions
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %0 - equipment attribute
@@ %1 - tag to partial-match
&f.has-tag [v(d.eqf)]=trim(squish(iter(ulocal(f.get-equipment-tags, edit(%0, _,)), if(strmatch(itext(0), %1*), itext(0)), |, |), |), b, |)

@@ %0 - date in standard format, eg. Sat May 02 15:41:01 2020
&f.format-date [v(d.eqf)]=strcat(ulocal(f.get-month-from-string, extract(%0, 2, 1)), -, extract(%0, 3, 1), -, extract(%0, 5, 1))

@@ %0 - May, Dec, etc
&f.get-month-from-string [v(d.eqf)]=switch(%0, Jan, 01, Feb, 02, Mar, 03, Apr, 04, May, 05, Jun, 06, Jul, 07, Aug, 08, Sep, 09, Oct, 10, Nov, 11, Dec, 12, 00)

@@ %0 - list of equipment attributes
@@ %1 - delimiter
&f.sort-equipment-attrs [v(d.eqf)]=strcat(setq(0, edit(%0, %1, |)), setq(1, iter(%q0, xget(%vD, edit(itext(0), _,)), |, |)), setq(2, munge(me/sort_alphabetic, %q1, %q0, |)), edit(%q2, |, %1))

&sort_alphabetic [v(d.eqf)]=sort(%0, i, |, |)

@@ %0 - list of equipment attributes
@@ %1 - delimiter
@@ %2 - player the attrs are on
&f.sort-equipment-by-date [v(d.eqf)]=strcat(setq(0, edit(%0, %1, |)), setq(1, iter(%q0, edit(revwords(extract(revwords(xget(%2, itext(0))), 1, 5)), .,), |, |)), setq(2, munge(me/sort_by_date, %q1, %q0, |)), edit(%q2, |, %1))

&sort_by_date [v(d.eqf)]=sortby(f.sort-date, %0, |, |)

&f.sort-date [v(d.eqf)]=comp(convtime(%0), convtime(%1))

@@ %0 - equipment attribute
@@ %1 - player
@@ %2 - month
@@ %3 - year
&f.filter-by-month-year [v(d.eqf)]=and(match(extract(revwords(edit(extract(revwords(xget(%1, %0)), 1, 5), .,)), 2, 1), %2), match(extract(revwords(edit(extract(revwords(xget(%1, %0)), 1, 5), .,)), 5, 1), %3))

@@ %0 - title
&f.find-equipment-on-players [v(d.eqf)]=search(eval=hasattr(##, _%0))

@@ %0 - player
@@ %1 - title
@@ %2 - 1 if exact search
&f.find-equipment-on-player-by-title [v(d.eqf)]=first(trim(squish(iter(lattr(%0/_eq-*-name), if(strmatch(first(xget(%0, itext(0)), |), %1[case(t(%2), 0, *)]), itext(0)),, |), |), b, |), |)

@@ %0 - title
@@ %1 - 1 if exact search
&f.find-all-equipment-by-title [v(d.eqf)]=trim(squish(iter(lattr(%vD/eq-*-name), if(strmatch(xget(%vD, itext(0)), %0[case(t(%1), 0, *)]), itext(0)),, |), |), b, |)

@@ and(or(not(t(%1)), eq(strlen(%0),)),

@@ %0 - player
@@ %1 - title
@@ %2 - 1 if exact search
&f.find-equipment-by-title [v(d.eqf)]=case(1, t(setr(0, ulocal(f.find-equipment-on-player-by-title, %0, %1, %2))), %q0, t(setr(1, ulocal(f.find-all-equipment-by-title, %1, %2))), %q1, #-1 NOT FOUND)

@@ %0 - tag
&f.list-equipment-by-tag [v(d.eqf)]=switch(%0, untag*, u(f.list-untagged-equipment), trim(squish(iter(lattr(%vD/eq-*-tags), iter(xget(%vD, itext(0)), if(strmatch(itext(0), %0*), edit(itext(1), TAGS, NAME)), |)))))

&f.list-untagged-equipment [v(d.eqf)]=trim(squish(setdiff(lattr(%vD/eq-*-name), iter(lattr(%vD/eq-*-tags), edit(itext(0), TAGS, NAME), |))))

@@ %0 - tag
&f.list-equipment-tags [v(d.eqf)]=setinter(setr(0, trim(squish(iter(lattr(%vD/eq-*-tags), iter(xget(%vD, itext(0)), if(strmatch(itext(0), %0*), itext(0)), |, |),, |), |), b, |)), %q0, |)

@@ %0 - equipment attribute
&f.get-equipment-tags [v(d.eqf)]=xget(%vD, edit(%0, NAME, TAGS))

@@ %0 - equipment attribute
&f.get-equipment-title [v(d.eqf)]=xget(%vD, %0)

@@ %0 - equipment attribute
&f.get-equipment-details [v(d.eqf)]=xget(%vD, edit(%0, NAME, DETAILS))

@@ %0 - player
@@ %1 - equipment attribute
&f.get-equipment-note [v(d.eqf)]=xget(%0, edit(%1, NAME, NOTE))

@@ %0 - the player
&f.get-width [v(d.eqf)]=max(min(width(%0), 80), 50)

@@ %0 - me, nothing, or %#
&f.get-player [v(d.eqf)]=pmatch(switch(%0, me, %#,, %#, %0))

@@ %0 - the command input
&f.find-command-switch [v(d.eqf)]=strcat(setq(0,), setq(1,), setq(2, switch(%0, /*/*, first(rest(first(%0), /), /), /*, rest(first(%0), /), %b*, _, first(%0))), null(iter(sort(lattr(%!/switch.*.%q2*)), case(1, match(last(itext(0), .), %q2), setq(0, %q0 [itext(0)]), strmatch(last(itext(0), .), %q2*), setq(1, %q1 [itext(0)])))), trim(if(t(%q0), first(%q0), %q1), b))

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Command manager
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&cmd-+eq [v(d.eqc)]=$+eq*:@switch setr(E, strcat(setq(C, ulocal(f.find-command-switch, %0)), if(not(t(%qC)), Could not find command: +eq%0)))=, { @trigger me/%qC=%#, %0; }, { @pemit %#=ulocal(layout.error, %qE); }


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Command switches
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&switch.0. [v(d.eqc)]=@pemit %0=ulocal(layout.equipment, %0, %0);

&switch.0._ [v(d.eqc)]=@switch/first and(t(ulocal(f.get-player, trim(%1))), or(isstaff(%0), match(%0, ulocal(f.get-player, trim(%1)))))=1, { @trigger me/tr.equipment-view=%0, trim(%1); }, { @trigger me/switch.1.details=%0, /details %1; };

&switch.1.details [v(d.eqc)]=@pemit %0=ulocal(layout.equipment-details, %0, switch(rest(%1), */*, rest(rest(%1), /), rest(%1)), switch(rest(%1), */*, if(isstaff(%0), if(t(setr(P, ulocal(f.get-player, first(rest(%1), /)))), %qP, ulocal(layout.error, Could not find player '[first(rest(%1), /)]'.)), ulocal(layout.error, You are not staff and cannot view players' equipment.)), %0));

&switch.2.list [v(d.eqc)]=@pemit %0=ulocal(layout.list-equipment, %0, rest(%1));

&switch.2.date [v(d.eqc)]=@trigger me/tr.equipment-date=%0, if(t(rest(%1)), rest(%1), %0);

&switch.2.month [v(d.eqc)]=@trigger me/tr.equipment-month=%0, if(t(rest(%1)), rest(%1), %0), Availability;

&switch.3.find [v(d.eqc)]=@pemit %0=ulocal(layout.find-equipment, %0, rest(%1));

&switch.4.prove [v(d.eqc)]=@trigger me/tr.prove-equipment=%0, before(rest(%1), =), rest(%1, =);

&switch.5.create [v(d.eqc)]=@trigger me/tr.equipment-create=%0, before(rest(%1), =), rest(%1, =);

&switch.5.tag [v(d.eqc)]=@trigger me/tr.equipment-tag=%0, before(rest(%1), =), rest(%1, =);

&switch.5.untag [v(d.eqc)]=@trigger me/tr.equipment-untag=%0, before(rest(%1), =), rest(%1, =);

&switch.5.update [v(d.eqc)]=@trigger me/tr.equipment-update=%0, before(rest(%1), =), rest(%1, =);

&switch.5.clone [v(d.eqc)]=@trigger me/tr.equipment-clone=%0, before(rest(%1), =), rest(%1, =);

&switch.6.give [v(d.eqc)]=@trigger me/tr.equipment-give=%0, before(rest(%1), =), rest(%1, =);

&switch.6.take [v(d.eqc)]=@trigger me/tr.equipment-take=%0, before(rest(%1), =), rest(%1, =);

&switch.6.view [v(d.eqc)]=@trigger me/tr.equipment-view=%0, if(t(rest(%1)), rest(%1), %0);

&switch.6.note [v(d.eqc)]=@trigger me/tr.equipment-note=%0, first(rest(%1), /), last(first(%1, =), /), rest(%1, =);

&switch.7.players [v(d.eqc)]=@trigger me/tr.find-players-with-equipment=%0, rest(%1);

&switch.8.takeall [v(d.eqc)]=@trigger me/tr.take-equipment-from-all-players=%0, rest(%1);

&switch.98.wipe [v(d.eqc)]=@switch/first %1=*=*, { @trigger me/tr.wipe-equipment=%0, first(rest(%1), =), rest(%1, =); }, { @trigger me/tr.wipe-single-player-equipment=%0, rest(%1); }

&switch.99.destroy [v(d.eqc)]=@switch/first %1=*=*, { @trigger me/tr.destroy-equipment=%0, first(rest(%1), =), rest(%1, =); }, { @trigger me/tr.confirm-destroy=%0, rest(%1); }


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Triggers
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ Input:
@@ %0 - %#
@@ %1 - equipment title
@@ %2 - details
&tr.equipment-create [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot create equipment.), %b, if(not(t(%1)), You need to include a title for the new equipment.), %b, if(not(t(%2)), You need to include details for the new equipment.)))))=, { @assert not(t(ulocal(f.find-equipment-by-title, %0, %1, 1)))={@pemit %0=u(layout.error, There's already equipment named '%1'.); }; @set %vD=eq-count:[setr(N, add(default(%vD/eq-count, 0), 1))]; @set %vD=eq-%qN-name:%1; @set %vD=eq-%qN-details:%2; @pemit %0=u(layout.equipment-details, %0, %1); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - equipment title
@@ %2 - new equipment
&tr.equipment-clone [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot clone equipment.), %b, if(not(t(setr(O, ulocal(f.find-all-equipment-by-title, %1)))), Can't figure out what equipment to copy from.), %b, if(not(t(%2)), You need to include a name for the new equipment.), %b, if(t(ulocal(f.find-equipment-by-title, %0, %2, 1)), There is already a piece of equipment named '%2'.), %b, if(gt(words(%qO, |), 1), Found multiple pieces of equipment named '%1' so I can't tell which one you're cloning: [ulocal(layout.list-equipment-names, %qO)])))))=, { @set %vD=eq-count:[setr(N, add(default(%vD/eq-count, 0), 1))]; @set %vD=eq-%qN-name:%2; @set %vD=eq-%qN-details:[xget(%vD, edit(%qO, NAME, DETAILS))]; @set %vD=eq-%qN-tags:[xget(%vD, edit(%qO, NAME, TAGS))]; @pemit %0=u(layout.equipment-details, %0, %2); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - equipment title
@@ %2 - tag
&tr.equipment-tag [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot tag equipment.), %b, if(not(t(setr(A, ulocal(f.find-all-equipment-by-title, %1)))), Could not find equipment named '%1'.), %b, if(gt(words(%qA, |), 1), More than one piece of equipment was returned: [u(layout.list-equipment-names, %qA)]), %b, if(not(t(%2)), You need to include a tag for the equipment.)))))=, { @set %vD=setr(A, edit(%qA, NAME, TAGS)):[setunion(ulocal(f.get-equipment-tags, %qA), %2, |)]; @pemit %0=u(layout.equipment-details, %0, %1); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - equipment title
@@ %2 - tag
&tr.equipment-untag [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot tag equipment.), %b, if(not(t(setr(A, ulocal(f.find-all-equipment-by-title, %1)))), Could not find equipment named '%1'.), %b, if(gt(words(%qA, |), 1), More than one piece of equipment was returned: [u(layout.list-equipment-names, %qA)]), %b, if(or(not(t(%2)), not(member(setr(T, ulocal(f.get-equipment-tags, %qA)), %2, |))), You need to include the exact tag you wish to remove.)))))=, { @set %vD=setr(A, edit(%qA, NAME, TAGS)):[setdiff(%qT, %2, |)]; @pemit %0=u(layout.equipment-details, %0, %1); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - equipment title
@@ %2 - new details
&tr.equipment-update [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot change equipment details.), %b, if(not(t(setr(A, ulocal(f.find-all-equipment-by-title, %1)))), Could not find equipment named '%1'.), %b, if(gt(words(%qA, |), 1), More than one piece of equipment was returned: [u(layout.list-equipment-names, %qA)]), setq(D, xget(%vD, edit(%qA, NAME, DETAILS)))))))=, { @set %vD=edit(%qA, NAME, DETAILS):%2; @pemit %0=alert(Equipment) You changed the details for '[xget(%vD, %qA)]' from:%R[alert(Equipment Details)] %qD%R[alert(Equipment)] To:%R[alert(Equipment Details)] %2; }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - player
@@ %2 - equipment title
&tr.equipment-give [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot give equipment.), %b, if(not(t(setr(A, ulocal(f.find-all-equipment-by-title, %2)))), Could not find equipment named '%2'.), %b, if(gt(words(%qA, |), 1), More than one piece of equipment was returned: [u(layout.list-equipment-names, %qA)]), %b, if(or(not(t(%2)), not(t(setr(P, ulocal(f.get-player, %1))))), Could not find player '%1'.)))))=, { @set %qP=_%qA:[ulocal(f.get-equipment-title, %qA)]|[strcat(Given to, %b, name(%qP), %(, %qP, %), %b, by, %b, moniker(%0), %b, %(, %0, %), %b, on, %b, time(), .)]; @pemit %0=alert(Equipment) You gave [name(%qP)] the equipment [ulocal(f.get-equipment-title, %qA)].; }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - player
@@ %2 - equipment title
&tr.equipment-take [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot take away equipment.), %b, if(or(not(t(%2)), not(t(setr(P, ulocal(f.get-player, %1))))), Could not find player '%1'., if(not(t(setr(A, ulocal(f.find-equipment-on-player-by-title, %qP, %2)))), Could not find equipment named '%2' on player [name(%qP)].))))))=, { @wipe %qP/%qA; @pemit %0=alert(Equipment) You took [name(%qP)]'s equipment [ulocal(f.get-equipment-title, trim(%qA, l, _))] away.; }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - player
&tr.equipment-view [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(or(not(t(%1)), not(t(setr(P, ulocal(f.get-player, %1))))), Could not find player '%1'.), %b, if(and(not(isstaff(%0)), not(match(%0, %qP))), You are not staff and cannot view players' equipment.)))))=, { @pemit %0=ulocal(layout.equipment, %0, %qP, 1); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - player
&tr.equipment-date [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(or(not(t(%1)), not(t(setr(P, ulocal(f.get-player, %1))))), Could not find player '%1'.), %b, if(and(not(isstaff(%0)), not(match(%0, %qP))), You are not staff and cannot view players' equipment by date.)))))=, { @pemit %0=ulocal(layout.equipment-by-date, %0, %qP, 1); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - player
@@ %2 - tag
&tr.equipment-month [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(or(not(t(%1)), not(t(setr(P, ulocal(f.get-player, %1))))), Could not find player '%1'.), %b, if(and(not(isstaff(%0)), not(match(%0, %qP))), You are not staff and cannot view players' equipment for the current month.)))))=, { @pemit %0=ulocal(layout.pretty-equipment-month-year, %0, %qP, extract(time(), 2, 1), extract(time(), 5, 1), %2); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - player
@@ %2 - equipment title
@@ %3 - note
&tr.equipment-note [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot add notes to players' equipment.), %b, if(or(not(t(%1)), not(t(setr(P, ulocal(f.get-player, %1))))), Could not find player '%1'.), %b, if(not(t(setr(A, ulocal(f.find-equipment-on-player-by-title, %qP, %2)))), Could not find equipment named '%2' on player [name(%qP)].)))))=, { @set %qP=[edit(%qA, NAME, note)]:%3; @pemit %0=ulocal(layout.equipment-details, %0, first(xget(%qP, %qA), |), %qP); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - title
@@ %2 - target player (optional)
&tr.prove-equipment [v(d.eqc)]=@switch setr(E, strcat(setq(F, ulocal(f.find-equipment-on-player-by-title, %0, %1)), setq(P, if(t(%2), ulocal(f.get-player, %2), strcat(lcon(loc(%0), CONNECT), setq(T, the room)))), if(not(t(%qP)), Couldn't figure out who '%2' is.), if(not(t(%qF)), Couldn't find a piece of equipment on you named '%1'.)))=, { @dolist/notify %qP={ @pemit ##=ulocal(layout.prove-equipment, %0, %qF, ##, if(t(%qT), %qT, you)); }; @wait me=@switch/first %qT=, { @pemit %0=alert(Equipment) You showed [if(t(%qT), %qT, itemize(iter(%qP, name(itext(0)),, |), |))] your [first(xget(%0, %qF), |)] equipment.; } }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - title
&tr.find-players-with-equipment [v(d.eqc)]=@assert isstaff(%0)={ @pemit %0=u(layout.error, You must be staff to find players with a piece of equipment.); }; @assert t(setr(N, ulocal(f.find-all-equipment-by-title, %1)))={ @pemit %0=u(layout.error, Could not find equipment named '%1'.); }; @assert eq(words(%qN, |), 1)={ @pemit %0=u(layout.error, More than one piece of equipment was returned: [u(layout.list-equipment-names, %qN)]); }; @pemit %0=ulocal(layout.list-players-with-equipment, %qN);

@@ Input:
@@ %0 - %#
@@ %1 - title
&tr.take-equipment-from-all-players [v(d.eqc)]=@assert isstaff(%0)={ @pemit %0=u(layout.error, You must be staff to take a piece of equipment away from everybody.); }; @assert t(setr(N, ulocal(f.find-all-equipment-by-title, %1)))={ @pemit %0=u(layout.error, Could not find equipment named '%1'.); }; @assert eq(words(%qN, |), 1)={ @pemit %0=u(layout.error, More than one piece of equipment was returned: [u(layout.list-equipment-names, %qN)]); }; @assert t(setr(P, ulocal(f.find-equipment-on-players, %qN)))={ @pemit %0=u(layout.error, No players have the equipment '%1'.); }; @dolist/notify %qP={ @set ##=_%qN:; }; @wait me=@pemit %0=alert(Equipment) Removed '[xget(%vD, %qN)]' from the following players: [itemize(iter(%qP, moniker(itext(0)),, |), |)];

@@ Input:
@@ %0 - %#
@@ %1 - title
&tr.wipe-single-player-equipment [v(d.eqc)]=@asert isstaff(%0)={ @pemit %0=u(layout.error, You are not staff and cannot wipe players' equipment.); }; @assert t(setr(P, ulocal(f.get-player, %1)))={ @pemit %0=u(layout.error, Could not find player '%1'.); }; @assert t(lattr(%qP/_eq-*-name))={ @pemit %0=u(layout.error, moniker(%qP) does not have equipment to wipe.); }; @set %0=eq-player-wipe:%qP|[secs()]; @pemit %0=alert(Equipment) Are you sure you want to wipe all of [moniker(%qP)]'s equipment? If you're sure, type +eq/wipe %1=YES; }, { @pemit %0=ulocal(layout.error, %qE); }

&tr.wipe-equipment [v(d.eqc)]=@asert isstaff(%0)={ @pemit %0=u(layout.error, You are not staff and cannot wipe players' equipment.); }; @assert t(setr(P, ulocal(f.get-player, %1)))={ @pemit %0=u(layout.error, Could not find player '%1'.); }; @assert t(lattr(%qP/_eq-*-name))={ @pemit %0=u(layout.error, moniker(%qP) does not have equipment to wipe.); }; @assert not(or(not(strmatch(%qP, first(setr(W, xget(%0, eq-player-wipe)), |))), gt(sub(secs(), rest(%qW, |)), 300), not(match(%2, YES))))={ @trigger me/tr.wipe-single-player-equipment=%0, %1; }; @pemit %0=alert(Equipment) Decompiling [moniker(%qP)]'s' equipment data so you can recreate it if this was a mistake...%R%R[iter(lattr(%qP/_eq-*-name), &[itext(0)] %qP=[xget(%qP, itext(0))],, %R)]%R; @pemit %0=alert(Equipment) Wiping [moniker(%qP)]'s equipment...; @wipe %qP/_eq-*-name; @pemit %0=alert(Equipment) [moniker(%qP)]'s equipment has been wiped.;

@@ Input:
@@ %0 - %#
@@ %1 - title
&tr.confirm-destroy [v(d.eqc)]=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot destroy equipment.), setq(N, ulocal(f.find-all-equipment-by-title, %1)), if(not(t(%qN)), Couldn't find equipment named '%1'.), %b, if(gt(words(%qN, |), 1), More than one piece of equipment was returned: [u(layout.list-equipment-names, %qN)])))))=, { @set %0=eq-nuke:%qN|[secs()]; @pemit %0=alert(Equipment) Before you continue, make absolutely certain that [xget(%vD, %qN)] is the equipment you want to destroy. If you're absolutely certain you want to destroy this equipment, type +eq/destroy %1=YES; }, { @pemit %0=ulocal(layout.error, %qE); }

&tr.destroy-equipment [v(d.eqc)]=@asert isstaff(%0)={ @pemit %0=u(layout.error, You are not staff and cannot wipe players' equipment.); }; @switch strcat(setq(N, ulocal(f.find-all-equipment-by-title, %1)), setq(P, xget(%vD, %qN)), or(not(strmatch(%qN, first(setr(W, xget(%0, eq-nuke)), |))), gt(sub(secs(), rest(%qW, |)), 300), not(match(%2, YES))))=1, { @trigger me/tr.confirm-destroy=%0, %1; }, { @switch setr(E, if(not(t(%qN)), Couldn't figure out which equipment you meant by '%1'.))=, { @pemit %0=alert(Equipment) Decompiling equipment data so you can recreate it if this was a mistake...%R%R[iter(lattr(%vD/eq-[first(rest(%qN, -), -)]-*), &[itext(0)] %vD=[xget(%vD, itext(0))],, %R)]%R; @pemit %0=alert(Equipment) Deleting data for %qP equipment...; @wipe %vD/eq-[first(rest(%qN, -), -)]-*; @pemit %0=alert(Equipment) The equipment '%qP' has been destroyed. This does not remove it from players that have it set, but they will no longer be able to view equipment details for that equipment; }, { @pemit %0=ulocal(layout.error, %qE); }; }

