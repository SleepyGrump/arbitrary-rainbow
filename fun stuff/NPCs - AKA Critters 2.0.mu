/*
Dependencies:
	wheader()
	wfooter()
	wdivider()
	alert()
	isstaff()
	You must also install at least one NPC Type from the NPC types subdirectory.

Update: This is the second version of the original +critters, expanded to all kinds of NPCs - Horrors, Spirits, NPC humans, animals, fantasy animals, etc. Because of this, we have renamed it to "NPCs" and all the commands to "+npc".

TODO:
 - Write a first-time drop-in for the existing critters.
 - Write some kind of stat-listing utility - +npc/stats <npc>?
 - Hobgoblins
 - Hedge Ghosts
 - Werewolf weird spirit stuff - Hosts, etc?
 - Maybe make the below-minimums of Influences and Manifestations error
 - Maybe make skills only show up on Horrors if they exist?

DONE:
 - Do we change the stats to use wiz-only attributes? Don't need to since the object is owned by the coder and is only editable via code that can check for permissions first.

 - Write a one-time routine to convert old Critters into NPCs. +npc/transfer <critter>=<category>

================================================================================

Wiki help pages:

=== NPCs ===

NPC code exists to help you find (and create!) the stats of NPCs more easily. These stats will sometimes differ just a bit from the official Onyx Path published stats because there are calculations to some of the derived stats which don't always match up with what OP wrote. If you find an error with any of the +npcs, please let us know! If there's ever a difference between the book version of an NPC and the version in +npcs, use the version in +npcs.

* +npcs - list all the NPC types.
* +npcs <type> - list all the NPCs of that type.
* +npc <name or DBref> - show yourself a single NPC.

You can also create your own NPCs! Type +help NPC2 to see how. If you need help, staff can create a NPC for you.

[[Category:RP Systems]]  [[Category:Help]]

=== NPC2 ===

Here's how to make your own NPCs! It won't be in +npcs, but you can look at it any time you need to see its stats.

* +npc/clone <existing NPC>=<new name> - clone a NPC into your inventory so you can modify it. You will be notified if the new name is not appropriate compared to the other names in the library - try to choose something unique.

* +npc/blank <NPC category>=<name> - create a new, blank NPC in your inventory so you can modify it. Be careful not to name it something already in the libray.

Once you have a NPC, you can use these commands to modify it:

* +npc/set <stat>=<value>
Examples:
:: +npc/set Strength=4
:: +npc/set Brawl=5
:: +npc/set Bane=Hickory stick dipped in cow's blood
:: +npc/set Numina=Blast
:: +npc/set asdf=This will error and show you a list of stats you can set.

* +npc/set <stat type>/<stat>=<value>
Examples:
:: +npc/set Merit/Language (French)=1
:: +npc/set Attack/Bite=2L
:: +npc/set Note/Candy=This monster loves candy.
:: +npc/set Specialty/Brawl=Grappling
:: +npc/set Influence/Wishes=3
:: +npc/set Numina/Blast=1
:: +npc/set asdf/jkl;=This will error and show you a list of stats you can set.

* +npc/rename <NPC>=<new name>

* +npc/category <NPC>=<new category> - be careful, this will change the NPC's sheet completely!

* +npc/check <NPC> - check the NPC for obvious issues with character generation

* +npc/edit <NPC> - start working on a NPC you stopped earlier.

* +npc/destroy <NPC> - nuke an NPC you're done with and don't want to save.

You can submit new NPCs to the official NPC library with: +req/pitch New NPC: <NPC>=I made a NPC! It's object #<dbref>, please check it out! I think it belongs in the library because <reason>.

Staff commands are available in +help NPC3.

[[Category:RP Systems]]  [[Category:Help]]

=== NPC3 ===

* +npc/approve <dbref>=<note> - sticks an "approved" stamp on it if it doesn't already have one. (Useful for approving a NPC pre-plot, for example.) Locks the NPC so that it cannot be edited by the player.

* +npc/unapprove <dbref> - unapproves the NPC. If they're in the database, it will drop them in your inventory.

* +npc/import <dbref> - put the NPC into the public NPCs database.

* +npc/remove <dbref> - remove the NPC from the public database. Will put it in your inventory.

* +npc/transfer <dbref>=<category> - transfer an NPC out of the old Critters system (which only covered animals) and into the new system. May require some manual editing.

To create a new category, code staff is needed since the category object controls how the sheet looks and what stats and categories are available, as well as any chargen checks.

[[Category:RP Systems]]  [[Category:Help]]


*/

@@ ========================================================================= @@
think Object creation time.
@@ ========================================================================= @@

@create NPC Commands <NPCC>=10
@create NPC Sheets <NPCS>=10

@force me=&d.npcc me=[search(name=NPC Commands <NPCC>)]
@force me=&d.npcs me=[search(name=NPC Sheets <NPCS>)]
@force me=&vS [v(d.npcs)]=[search(name=NPC Sheets <NPCS>)]
@force me=&vC [v(d.npcs)]=[search(name=Critter Sheet Parent <CSP>)]

@set [v(d.npcc)]=SAFE COMMANDS INHERIT
@set [v(d.npcs)]=SAFE INHERIT
@force me=@parent [v(d.npcc)]=[v(d.npcs)]
@tel [v(d.npcs)]=[v(d.npcc)]

&d.commands [v(d.npcc)]=+npcs - list all the NPC types.|+npcs <type> - list all the NPCs of that type.|+npc <name or DBref> - show yourself a single NPC.|+npc/clone <existing NPC>=<new name> - clone 'em.|+npc/blank <NPC category>=<name> - make a blank one.|+npc/set <stat>=<value> - set some Strength, etc.|+npc/set <stat type>/<stat>=<value> - set Merits, etc.|+npc/rename <NPC>=<new name> - rename it.|+npc/category <NPC>=<new category> - change its sheet.|+npc/check <NPC> - does it obey the rules?|+npc/edit <NPC> - work on an NPC.|+npc/destroy <NPC> - nuke it!|+view NPC/Stat Examples - see some examples of how to set stats.

&d.staff_commands [v(d.npcc)]=+npc/approve <dbref>=<note> - approve it.|+npc/unapprove <dbref> - unapprove it.|+npc/import <dbref> - stick it in the +npcs DB!|+npc/remove <dbref> - take it out of the NPC DB.

&d.stat_setting_examples [v(d.npcc)]=+npc/set Strength=4|+npc/set Brawl=5|+npc/set Bane=Hickory stick dipped in cow's blood|+npc/set asdf=This will error and show you a list of valid stats.||+npc/set Merit/Language (French)=1|+npc/set Brawl Attack/Bite=2L|+npc/set Note/Candy=This monster loves candy.|+npc/set Specialty/Brawl=Grappling|+npc/set Influence/Wishes=3|+npc/set Numina/Blast=1|+npc/set asdf/jkla=This will error and show you a list of valid stats.

@desc [v(d.npcc)]=strcat(wheader(NPC Commands short list), %r, iter(v(d.commands), strcat(space(3), itext(0)), |, %r), %r, wdivider(NPC Staff commands short list), %r, iter(v(d.staff_commands), strcat(space(3), itext(0)), |, %r), %r, wfooter(Created by %cmM%cgelpomene%cn at NOLA))

&view-stat_examples [v(d.npcc)]=strcat(wheader(Examples of stat setting), %r, iter(v(d.stat_setting_examples), strcat(space(3), itext(0)), |, %r), %r, wfooter(Created by %cmM%cgelpomene%cn at NOLA))

@@ ========================================================================= @@
think Layout and decoration functions.
@@ ========================================================================= @@

&desc [v(d.npcs)]=ulocal(layout.container)

&layout.container [v(d.npcs)]=strcat(wheader(switch(setr(N, name(me)), *<*>, NPC Types, %qN)), %r, ulocal(case(%0, 2, layout.dbref-list-two-column, layout.dbref-list), sortby(f.sort-by-name, lcon(me))), %r, wfooter(+npc <NPC> for more info.))

&layout.name-and-value [v(d.npcs)]=strcat(setq(0, ulocal(f.get-three-column-widths, %#)), %0, if(t(%0), :), space(sub(last(%q0, |), add(1, strlen(%0), strlen(%1)))), %1)

&layout.skill [v(d.npcs)]=strcat(%0, if(t(%0), :%b), if(t(%1), %1, default(edit(%0, %b, _), 0)), if(t(setr(0, default(specialty-[edit(%0, %b, _)], 0))), strcat(%b, %(, %q0, %))))

&layout.row [v(d.npcs)]=strcat(setq(0, ulocal(f.get-three-column-widths, %#)), space(3), ulocal(layout.name-and-value, %0, %1, last(%q0, |)), space(first(%q0, |)), ulocal(layout.name-and-value, %2, %3, last(%q0, |)), space(extract(%q0, 2, 1, |)), ulocal(layout.name-and-value, %4, %5, last(%q0, |)))

&layout.row-no-values [v(d.npcs)]=strcat(setq(0, ulocal(f.get-three-column-widths, %#)), space(3), ljust(strtrunc(%0, last(%q0, |)), last(%q0, |)), space(first(%q0, |)), ljust(strtrunc(%1, last(%q0, |)), last(%q0, |)), space(extract(%q0, 2, 1, |)), ljust(strtrunc(%2, last(%q0, |)), last(%q0, |)))

&layout.list-with-values [v(d.npcs)]=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), ulocal(layout.row, ulocal(f.attribute_list_to_name, %0, 1, inum(0)), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 1, 3), ulocal(f.attribute_list_to_name, %0, 2, inum(0)), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 2, 3), ulocal(f.attribute_list_to_name, %0, 3, inum(0)), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 3, 3)),, %r)

&layout.list [v(d.npcs)]=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), ulocal(layout.row-no-values, ulocal(f.attribute_list_to_name, %0, 1, inum(0)), ulocal(f.attribute_list_to_name, %0, 2, inum(0)), ulocal(f.attribute_list_to_name, %0, 3, inum(0))),, %r)

&layout.dbref-list [v(d.npcs)]=iter(lnum(add(div(words(%0), 3), t(mod(words(%0), 3)))), ulocal(layout.row-no-values, ulocal(f.lookup-from-list-of-names, %0, itext(0), 1, 3), ulocal(f.lookup-from-list-of-names, %0, itext(0), 2, 3), ulocal(f.lookup-from-list-of-names, %0, itext(0), 3, 3)),, %r)

&layout.dbref-list-two-column [v(d.npcs)]=iter(lnum(add(div(words(%0), 2), t(mod(words(%0), 2)))), ulocal(layout.two-column, ulocal(f.lookup-from-list-of-names, %0, itext(0), 1, 2), ulocal(f.lookup-from-list-of-names, %0, itext(0), 2, 2)),, %r)

&layout.two-column [v(d.npcs)]=strcat(setq(0, ulocal(f.get-two-column-widths)), space(3), ljust(strtrunc(%0, rest(%q0, |)), rest(%q0, |)), space(first(%q0, |)), ljust(strtrunc(%1, rest(%q0, |)), rest(%q0, |)))

@@ TODO: Remove if not in use
&layout.two-column-name-and-value [v(d.npcs)]=strcat(ljust(%0:%b, sub(%2, strlen(%1))), %1)

@@ TODO: Remove if not in use
&layout.list-two-column [v(d.npcs)]=strcat(setq(0, rest(ulocal(f.get-two-column-widths), |)), iter(lnum(add(div(words(%0), 2), t(mod(words(%0), 2)))), ulocal(layout.two-column, ulocal(layout.two-column-name-and-value, ulocal(f.attribute_list_to_name, %0, itext(0), 1, 2), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 1, 2), %q0), ulocal(layout.two-column-name-and-value, ulocal(f.attribute_list_to_name, %0, itext(0), 2, 2), ulocal(f.lookup-from-list-of-attributes, %0, itext(0), 2, 2), %q0)),, %r))

&layout.list-one-column [v(d.npcs)]=strcat(setq(0, sub(width(%#), 5)), iter(%0, strcat(space(3), ljust(ulocal(f.attribute_list_to_name, itext(0), 1, 1)%b, sub(sub(%q0, 2), strlen(setr(1, ulocal(f.lookup-from-list-of-attributes, itext(0), 1, 1)))), .), %b, %q1),, %r))

@@ %0 - title
@@ %1 - value
@@ %2 - title width
@@ Sample uses:
@@ - u(layout.note, Appearance,, 14) - Appearance: default(appearance, Unset.)
@@ - u(layout.note, note-1) - default(note-1, Unset.)
@@ - u(layout.note, Blargity, The blargity foo.) - The blargity foo.
@@ - u(layout.note, Blargity, Blargity foo., 14) - Blargity: Blargity foo.
&layout.note [v(d.npcs)]=strcat(setq(0, sub(width(%#), 3)), trim(wrap(strcat(space(3), if(t(%2), ljust(%0:%b, %2)), if(t(%1), default(edit(%1, %b, _), %1), default(edit(%0, %b, _), [titlestr(%0)] unset.))), %q0, Left,,, add(%2, 3)), r))

@@ %0 - list to display
@@ %1 - name if it's anything special.
&layout.header [v(d.npcs)]=strcat(setq(0, add(last(sort(iter(edit(%0, `,), strlen(itext(0)), |))), 2)), wheader(if(t(%1), %1, strcat(name(me), %b-%b, num(me)))), iter(%0, if(switch(itext(0), *`*, hasattrp(me, edit(itext(0), `,, %b, _)), 1), strcat(%r, ulocal(layout.note, edit(itext(0), `,),, %q0))), |, @@))

&layout.attributes [v(d.npcs)]=strcat(%r, wdivider(Attributes), %r, ulocal(layout.row, Intelligence, default(intelligence, 1), Strength, default(strength, 1), Presence, default(presence, 1)), %r, ulocal(layout.row, Wits, default(wits, 1), Dexterity, default(dexterity, 1), Manipulation, default(manipulation, 1)), %r, ulocal(layout.row, Resolve, default(resolve, 1), Stamina, default(stamina, 1), Composure, default(composure, 1)))

&layout.ephemeral_attributes [v(d.npcs)]=strcat(%r, wdivider(Attributes), %r, ulocal(layout.row, Power, default(power, 0), Finesse, default(finesse, 0), Resistance, default(resistance, 0)))

@@ %0 - header
@@ %1 - stat title, if different from header
@@ %2 - optional, means "always show".
@@ %3 - optional, means show just the names of the items, with no values
&layout.sheet-section [v(d.npcs)]=if(cor(t(setr(0, lattrp(%@/[edit(if(t(%1), %1, %0), %b, _)]-*))), t(%2)), strcat(%r, wdivider(%0), %r, ulocal(layout.list[if(not(t(%3)), -with-values)], %q0)))

@@ lattrp(me/stuff) fires with the looker's permissions rather than the object it's on's permissions.

&layout.sheet-bottom-notes [v(d.npcs)]=strcat(%r, wdivider(%0), %r, ulocal(layout.note, Appearance,), if(t(setr(1, v(totem_benefits))), strcat(%r%r, ulocal(layout.note, Totem Benefits,, 16))), if(t(setr(0, lattrp(me/note-*))), %r%r), iter(%q0, ulocal(layout.note, itext(0),),, %r%r), ulocal(layout.approved), %r, wfooter(Created by [default(creator, System)] on [v(created)]))

&layout.attack [v(d.npcs)]=strcat(setq(0, sub(width(%#), 6)), wrap(strcat(space(3), %1, :%b, %0, %b, damage%,, %b, add(default(strength, 1), default(%2, 1), strmatch(default(specialty-%2, 0), %1)), %b, dice pool.), %q0, Left,, space(3), 3, %r, %q0))

&layout.attacks [v(d.npcs)]=strcat(%r, wdivider(Attacks), %r, iter(sort(lattrp(me/brawl_attack-*)), ulocal(layout.attack, v(itext(0)), titlestr(rest(itext(0), -)), brawl),, %r), iter(sort(lattrp(me/melee_attack-*)), ulocal(layout.attack, v(itext(0)), titlestr(rest(itext(0), -)), melee),, %r), iter(sort(lattrp(me/firearms_attack-*)), ulocal(layout.attack, v(itext(0)), titlestr(rest(itext(0), -)), firearms),, %r), iter(sort(lattrp(me/athletics_attack-*)), ulocal(layout.attack, v(itext(0)), titlestr(rest(itext(0), -)), athletics),, %r))

&layout.approved [v(d.npcs)]=if(t(v(approved)), strcat(%r%r, ulocal(layout.note, Approved by, approved, 13)))

@@ ========================================================================= @@
think Data-getting functions.
@@ ========================================================================= @@

@@ %0 - list
@@ %1 - Which row we're on. 1-index.
@@ %2 - which column we're on, 1-index.
&f.attribute_list_to_name [v(d.npcs)]=titlestr(edit(rest(extract(%0, add(%1, mul(3, sub(%2, 1))), 1), -), _, %b))

@@ %0 - list to extract from
@@ %1 - Which row we're on. 1-index.
@@ %2 - which column we're on, 1-index.
@@ %3 - number of columns
&f.lookup-from-list-of-attributes [v(d.npcs)]=if(gte(words(%0), add(mul(%1, %3), %2)), v(extract(%0, add(mul(%1, %3), %2), 1)))

&f.lookup-from-list-of-names [v(d.npcs)]=if(gte(words(%0), add(mul(%1, %3), %2)), strcat(setr(0, extract(%0, add(mul(%1, %3), %2), 1)), %b>%b, name(%q0)))

&f.get-three-column-widths [v(d.npcs)]=strcat(setq(0, sub(width(%0), 6)), setq(0, sub(%q0, 4)), setq(1, mod(%q0, 3)), setq(0, sub(%q0, %q1)), add(mod(%q1, 2), div(%q1, 2), 2), |, add(div(%q1, 2), 2), |, div(%q0, 3))

&f.get-two-column-widths [v(d.npcs)]=strcat(setq(0, sub(width(%0), 6)), setq(0, sub(%q0, 2)), setq(1, mod(%q0, 2)), setq(0, sub(%q0, %q1)), add(%q1, 2), |, div(%q0, 2))

&f.sort-by-name [v(d.npcs)]=comp(name(%0), name(%1))

&f.get-trait [v(d.npcs)]=add(default(%0, 1), default(%1, 1), %2)

&f.get-defense [v(d.npcs)]=add(min(default(wits, 1), default(dexterity, 1)), default(athletics, 0))

&f.get-species-factor [v(d.npcs)]=default(species_factor, 5)

&f.get-size [v(d.npcs)]=default(size, 5)

@@ ========================================================================= @@
think Command-related functions
@@ ========================================================================= @@

&f.find-exact-NPC [v(d.npcs)]=strcat(setq(0, ), iter(lcon(%vS), iter(lcon(itext(0)), if(t(member(name(itext(0)), %0, |)), setq(0, strcat(%q0, %b, itext(0)))))), %q0)

&f.find-NPC  [v(d.npcs)]=strcat(setq(0, ), iter(lcon(%vS), iter(lcon(itext(0)), if(strmatch(name(itext(0)), %0*), setq(0, strcat(%q0, %b, itext(0)))))), %q0)

&f.locate-NPC [v(d.npcs)]=squish(trim(if(cand(isdbref(%0), member(%vS, parent(parent(%0)), |)), %0, if(t(setr(0, locate(%vS, %0, i))), %q0, if(t(setr(0, ulocal(f.find-exact-NPC, %0))), %q0, ulocal(f.find-NPC, %0))))))

&f.find-exact-local-NPC [v(d.npcs)]=strcat(setq(0, ), iter(lcon(%0), if(t(member(ucstr(name(itext(0))), ucstr(%1), |)), setq(0, strcat(%q0, %b, itext(0))))), %q0)

&f.find-local-NPC  [v(d.npcs)]=strcat(setq(0, ), iter(lcon(%0), if(strmatch(name(itext(0)), %1*), setq(0, strcat(%q0, %b, itext(0))))), %q0)

&f.locate-local-NPC [v(d.npcs)]=squish(trim(if(cand(isdbref(%1), member(%vS, parent(parent(%1)), |)), %1, if(t(setr(0, locate(%0, %1, i))), %q0, if(t(setr(0, ulocal(f.find-exact-local-NPC, %0, %1))), %q0, ulocal(f.find-local-NPC, %0, %1))))))

&f.locate-category [v(d.npcs)]=squish(trim(if(cand(isdbref(%0), member(%vS, parent(%0), |)), %0, if(t(setr(0, locate(%vS, %0, i))), %q0))))

@@ %0: player wanting to edit
@@ %1: NPC
&f.can-edit-NPC [v(d.npcs)]=cor(isstaff(%0), cand(not(hasattr(%1, locked)), strmatch(xget(%1, creator-dbref), %0)))

@@ %0: player
@@ %1: optional input text to select a new NPC
&f.get-current-NPC [v(d.npcs)]=if(isdbref(setr(2, strcat(setq(1, switch(%1, *=*, first(%1, =), */*, first(%1, /))), if(t(%q1), if(cand(t(setr(0, ulocal(f.locate-local-NPC, %0, %q1))), ulocal(f.can-edit-NPC, %0, %q0)), strcat(set(%0, _current-NPC:%q0), %q0), if(cand(t(setr(0, ulocal(f.locate-NPC, %q1))), ulocal(f.can-edit-NPC, %0, %q0)), strcat(set(%0, _current-NPC:%q0), %q0), #-1 NO NPC FOUND)), default(%0/_current-NPC, #-1 NO NPC SET))))), %q2, #-1 NO NPC SELECTED)

@@ ========================================================================= @@
think Triggers.
@@ ========================================================================= @@

@@ %0: target
@@ %1: message
&tr.error [v(d.npcc)]=@pemit %0=alert(NPC Error) %1;

&tr.success [v(d.npcc)]=@pemit %0=alert(NPC) %1;

&tr.show-npc [v(d.npcc)]=@assert t(setr(L, ulocal(f.locate-NPC, %1)))={ @trigger me/tr.error=%0, Could not find any NPCs or NPC types named '%1'. Try the DBref?; }; @assert eq(words(%qL), 1)={ @trigger me/tr.error=%0, Found multiple NPCs whose names start with '%1'. Did you mean one of these? [itemize(iter(%qL, name(itext(0)) %([itext(0)]%),, |), |)]; }; @pemit %0=udefault(%qL/desc, alert(NPC) This NPC has no sheet at this time.);

@@ ========================================================================= @@
think Commands.
@@ ========================================================================= @@

&cmd-+npcs [v(d.npcc)]=$+npcs:@pemit %#=udefault(%vS/desc, alert(NPC) No NPC categories are set up at this time.)

&cmd-+npc_no_text [v(d.npcc)]=$+npc:@pemit %#=udefault(%vS/desc, alert(NPC) No NPC categories are set up at this time.)

&cmd-+npc [v(d.npcc)]=$+npc *:@trigger me/tr.show-npc=%#, %0;

&cmd-+npcs_group [v(d.npcc)]=$+npcs *:@trigger me/tr.show-npc=%#, %0;

&cmd-+npc/clone [v(d.npcc)]=$+npc/clone *=*:@assert t(setr(L, ulocal(f.locate-NPC, %0)))={ @trigger me/tr.error=%#, Could not find any NPCs or NPC types named '%0'. Try the DBref?; }; @assert eq(words(%qL), 1)={ @trigger me/tr.error=%#, Found multiple NPCs whose names start with '%qL'. Did you mean one of these? [itemize(iter(%qL, name(itext(0)) %([itext(0)]%),, |), |)]; }; @assert not(t(locate(%#, %1, i)))={ @trigger me/tr.error=%#, You already have an NPC named '%1'. Choose another name.; }; @assert t(setr(C, create(%1, 10, t)))={ @trigger me/tr.error=%#, NPC cloning failed - maybe '%1' is a bad name?; }, {@trigger me/tr.success=%#, Created new %1 with dbref %qC.; }; @dolist lattr(%qL)={ @cpattr %qL/##=%qC/##; }; @set %qC=creator:[moniker(%#)] (%#); @set %qC=creator-dbref:%#; @wipe %qC/approved; @wipe %qC/locked; @parent %qC=parent(%qL); @tel %qC=%#; @set %#=_current-NPC:%qC; @trigger me/tr.success=%#, You are now the proud owner of a brand new NPC called '%1' with DBref %qC. Check your inventory (type '%chi%cn') or type '%chl %1%cn' to take a look%, and check out %ch+help NPC2%cn for details on what to do next.;

&cmd-+npc/blank [v(d.npcc)]=$+npc/blank *=*:@assert t(setr(L, ulocal(f.locate-category, %0)))={ @trigger me/tr.error=%#, Could not find any NPC categories named '%0'. Try the DBref?; }; @assert eq(words(%qL), 1)={ @trigger me/tr.error=%#, Found multiple NPC categories starting with '%qL'. Did you mean one of these? [itemize(iter(%qL, name(itext(0)) %([itext(0)]%),, |), |)]; }; @assert not(t(locate(%#, %1, i)))={ @trigger me/tr.error=%#, You already have an NPC named '%1'. Choose another name.; }; @assert t(setr(C, create(%1, 10, t)))={ @trigger me/tr.error=%#, NPC creation failed - maybe '%1' is a bad name?; }, {@trigger me/tr.success=%#, Created new %1 with dbref %qC.; }; @set %qC=creator:[moniker(%#)] (%#); @set %qC=creator-dbref:%#; @wipe %qC/approved; @wipe %qC/locked; @parent %qC=%qL; @tel %qC=%#; @set %#=_current-NPC:%qC; @trigger me/tr.success=%#, You are now the proud owner of a brand new NPC called '%1' with DBref %qC. Check your inventory (type '%chi%cn') or type '%chl %1%cn' to take a look%, and check out %ch+help NPC2%cn for details on what to do next.;

&cmd-+npc/category [v(d.npcc)]=$+npc/cat* *:@assert t(setr(N, ulocal(f.get-current-NPC, %#, switch(%1, *=*, %1, */*, %1,))))={ @trigger me/tr.error=%#, case(1, switch(%1, *=*, 1, */*, 1, 0), Can't find an NPC named '[first(%1, switch(%1, *=*, =, */*, /))]', or that NPC is approved and locked., You don't currently have an NPC selected to work on. Either specify your NPC with %ch+npc/edit <NPC>%cn or include the NPC in your command with %ch+npc/<command> <NPC>=<value>%cn.); }; @assert t(setr(C, ulocal(f.locate-category, setr(T, switch(%1, *=*, rest(%1, =), */*, rest(%1, /), %1)))))={ @trigger me/tr.error=%#, Can't find a category named '%qT'.; }; @assert not(strmatch(%qC, parent(%qN)))={ @trigger me/tr.error=%#, name(%qN) already has a sheet category of [name(%qC)].; }; @parent %qN=%qC; @trigger me/tr.success=%#, strcat(Changed, %b, name(%qN)'s sheet category to, %b, name(%qC). 'l, %b, name(%qN), ' to see the results.);

&cmd-+npc/name [v(d.npcc)]=$+npc/*name *:@assert t(setr(N, ulocal(f.get-current-NPC, %#, %1)))={ @trigger me/tr.error=%#, case(1, switch(%1, *=*, 1, */*, 1, 0), Can't find an NPC named '%1', or that NPC is approved and locked., You don't currently have an NPC selected to work on. Either specify your NPC with %ch+npc/edit <NPC>%cn or include the NPC in your command with %ch+npc/<command> <NPC>=<value>%cn.); }; @assert t(setr(T, switch(%1, *=*, rest(%1, =), */*, rest(%1, /), %1)))={ @trigger me/tr.error=%#, You need to choose something to name the NPC.; }; @name %qN=%qT; @assert strmatch(name(%qN), %qT)={ @trigger me/tr.error=%#, Could not name your NPC '%qT' - that's not a good name for an NPC.; }; @trigger me/tr.success=%#, Your NPC is now named [name(%qN)].;

&cmd-+npc/edit [v(d.npcc)]=$+npc/edit *:@assert cor(t(setr(L, locate(%#, %0, i))), cand(isstaff(%#), t(setr(L, ulocal(f.locate-NPC, %0)))))={ @trigger me/tr.error=%#, strcat(Could not find any NPCs in your inventory, %b, if(isstaff(%#), or in the NPC database%b), named '%0'. Try the DBref?); }; @assert eq(words(%qL), 1)={ @trigger me/tr.error=%#, Found multiple NPCs whose names start with '%qL'. Did you mean one of these? [itemize(iter(%qL, name(itext(0)) %([itext(0)]%),, |), |)]; }; @assert t(setr(N, ulocal(f.get-current-NPC, %#, %qL=)))={ @trigger me/tr.error=%#, Can't find an NPC named '%0', or that NPC is approved and locked.; }; @trigger me/tr.success=%#, You are now editing the NPC '[name(%qN)]'.;

&cmd-+npc/destroy [v(d.npcc)]=$+npc/destroy *:@break strmatch(%0, *=YES); @assert t(setr(N, ulocal(f.get-current-NPC, %#, %0=)))={ @trigger me/tr.error=%#, Can't find an NPC named '%0', or that NPC is approved and locked.; }; @set %#=_destroy-NPC:[secs()]; @trigger me/tr.success=%#, You are now editing the NPC '[name(%qN)]'. Are you sure you wish to destroy them? Type %ch+npc/destroy [name(%qN)]=YES%cn to continue. This command will expire in 5 minutes.;

&cmd-+npc/destroy_yes [v(d.npcc)]=$+npc/destroy *=YES:@assert t(setr(N, ulocal(f.get-current-NPC, %#, %0=)))={ @trigger me/tr.error=%#, Can't find an NPC named '%0', or that NPC is approved and locked.; }; @assert hasattr(%#, _destroy-NPC)={ @set %#=_destroy-NPC:[secs()]; @trigger me/tr.success=%#, You are now editing the NPC '[name(%qN)]'. Are you sure you wish to destroy them? Type %ch+npc/destroy [name(%qN)]=YES%cn to continue. This command will expire in 5 minutes.; }; @assert lte(sub(secs(), xget(%#, _destroy-NPC)), 300)={ @trigger me/tr.error=%#, The destroy command has expired. Please try again.; }; @wipe %#/_destroy-NPC; @destroy/instant %qN; @trigger me/tr.success=%#, You have destroyed the NPC.;

&cmd-+npc/approve [v(d.npcc)]=$+npc/approve *=*:@assert isstaff(%#)={ @trigger me/tr.error=%#, You must be staff to use this command.; }; @assert t(setr(N, ulocal(f.get-current-NPC, %#, %0=)))={ @trigger me/tr.error=%#, Can't find an NPC named '%0', or that NPC is approved and locked.; }; @set %qN=approved:[moniker(%#)] (%#) on [time()]: %1; @set %qN=locked:1; @trigger me/tr.success=%#, You approved [name(%qN)] with the comment: %1;

&cmd-+npc/unapprove [v(d.npcc)]=$+npc/unapprove *:@assert isstaff(%#)={ @trigger me/tr.error=%#, You must be staff to use this command.; }; @assert t(setr(N, ulocal(f.get-current-NPC, %#, %0=)))={ @trigger me/tr.error=%#, Can't find an NPC named '%0', or that NPC is approved and locked.; }; @wipe %qN/approved; @wipe %qN/locked; @trigger me/tr.success=%#, You unapproved [name(%qN)]. The NPC is now editable.;

&cmd-+npc/import [v(d.npcc)]=$+npc/import *:@assert isstaff(%#)={ @trigger me/tr.error=%#, You must be staff to use this command.; }; @assert t(setr(N, ulocal(f.get-current-NPC, %#, %0=)))={ @trigger me/tr.error=%#, Can't find an NPC named '%0', or that NPC is approved and locked.; }; @assert hasattr(%qN, approved)={ @trigger me/tr.error=%#, You must approve [name(%qN)] before you import them.; }; @assert not(strmatch(loc(%qN), parent(%qN)))={ @trigger me/tr.error=%#, name(%qN) is already imported.; }; @tel %qN=parent(%qN); @trigger me/tr.success=%#, You imported [name(%qN)] into the database under [name(parent(%qN))].;

&cmd-+npc/remove [v(d.npcc)]=$+npc/remove *:@assert isstaff(%#)={ @trigger me/tr.error=%#, You must be staff to use this command.; }; @assert t(setr(N, ulocal(f.locate-NPC, %0)))={ @trigger me/tr.error=%#, Can't find an NPC named '%0', or that NPC is approved and locked.; }; @assert strmatch(loc(%qN), parent(%qN))={ @trigger me/tr.error=%#, name(%qN) is not imported so can't be removed from the database.; }; @tel %qN=%#; @trigger me/tr.success=%#, You removed [name(%qN)] from the database and put them in your inventory.;

@@ 1. Figure out if it's actually a +critter.
@@ 2. Clone it? Or just transfer it?
@@ 3. Convert it into the new system.

&cmd-+npc/transfer [v(d.npcc)]=$+npc/transfer *=*:@assert isstaff(%#)={ @trigger me/tr.error=%#, You must be staff to use this command.; }; @assert isdbref(%vC)={ @trigger me/tr.error=%#, You don't have an old +critters installation so this command is irrelevant. If you do have an old +critters installation%, set it up with &vC [parent(me)]=<the old +critters sheet parent dbref> and run this command again.; }; @assert isdbref(setr(N, locate(%vC, %0, i)))={ @trigger me/tr.error=%#, Can't find a +critters NPC with the name or DBRef '%0'.; }; @assert t(setr(L, ulocal(f.locate-category, %1)))={ @trigger me/tr.error=%#, Can't find a category named '%1'.; }; @assert t(setr(C, create(name(%qN), 10, t)))={ @trigger me/tr.error=%#, Critter transfer failed - maybe '[name(%qN)]' is a bad name?; }, {@trigger me/tr.success=%#, Created new %1 with dbref %qC.; }; @dolist lattr(%qN)={ @switch/first 1=cand(strmatch(setr(V, xget(%qN, ##)), *|*), member(ATHLETICS BRAWL STEALTH SURVIVAL EMPATHY INTIMIDATION, ##)), { @set %qC=##:[first(%qV, |)]; @set %qC=specialty-##:[rest(%qV, |)]; }, strmatch(##, attack-*), { @set %qC=brawl_attack-[setr(V, xget(%qN, ##))]:[default(%qN/damage-%qV, default(%qN/damage, 0L))]; }, strmatch(##, damage-*), { think @@(Skipping damage attributes because we handled those in the attack section.); }, strmatch(##, note-*), { @switch/first setr(V, xget(%qN, ##))=Approved *, {}, { @cpattr %qN/##=%qC/##; }; }, { @cpattr %qN/##=%qC/##; } }; @set %qC=creator:[moniker(%#)] (%#); @set %qC=creator-dbref:%#; @wipe %qC/approved; @wipe %qC/locked; @parent %qC=%qL; @tel %qC=%#; @set %#=_current-NPC:%qC; @trigger me/tr.success=%#, strcat(Exported, %b, name(%qN) from +critters and dropped it in your inventory. 'l, %b, name(%qN)' to make sure the transfer worked OK.);

@@ ========================================================================= @@
think Stat-finding functions.
@@ ========================================================================= @@

@@ %0: parent stat type list
@@ %1: stat type we're looking for
@@ Output: where on the object to set the stat.
&f.find-exact-stat-type [v(d.npcs)]=if(t(setr(0, member(ucstr(%0), ucstr(%1), |))), extract(%0, %q0, 1, |))

&f.find-stat-type [v(d.npcs)]=if(t(setr(0, match(%0, %1*, |))), extract(%0, %q0, 1, |))

@@ %0: Parent object
@@ %1: Stat type
&f.get-stat-type [v(d.npcs)]=strcat(setq(1, ulocal(f.get-all-stat-types, %0)), if(t(setr(0, ulocal(f.find-exact-stat-type, %q1, %1))), %q0, ulocal(f.find-stat-type, %q1, %1)))

&f.get-all-stat-types [v(d.npcs)]=strcat(xget(%0, stat_categories), |, xget(%vS, stat_categories))

@@ %0: parent stat type list
@@ %1: stat type we're looking for
@@ Output: where on the object to set the stat.
&f.find-exact-stat [v(d.npcs)]=if(t(setr(0, member(ucstr(%0), ucstr(%1), |))), extract(%0, %q0, 1, |))

&f.find-stat [v(d.npcs)]=if(t(setr(0, match(%0, %1*, |))), extract(%0, %q0, 1, |))

@@ %0: Parent object
@@ %1: Stat type
&f.get-stat [v(d.npcs)]=strcat(setq(1, ulocal(f.get-all-stats, %0)), if(t(setr(0, ulocal(f.find-exact-stat, %q1, %1))), %q0, ulocal(f.find-stat, %q1, %1)))

&f.get-all-stats [v(d.npcs)]=strcat(xget(%0, stats), |, xget(%vS, stats))

@@ %0: parent values list
@@ %1: list value we're looking for
@@ Output: What exact list value to set.
&f.find-exact-value-from-list [v(d.npcs)]=if(t(setr(0, member(ucstr(%0), ucstr(%1), |))), extract(%0, %q0, 1, |))

&f.find-value-from-list [v(d.npcs)]=if(t(setr(0, match(%0, %1*, |))), extract(%0, %q0, 1, |))

@@ %0: Parent object
@@ %1: List to search
@@ %2: List value to find
&f.get-value-from-list [v(d.npcs)]=strcat(setq(1, ulocal(f.get-all-values-from-list, %0, %1)), if(t(%q1), if(t(setr(0, ulocal(f.find-exact-value-from-list, %q1, %2))), %q0, ulocal(f.find-value-from-list, %q1, %2)), %2))

&f.get-all-values-from-list [v(d.npcs)]=trim(strcat(xget(%0, list-[edit(%1, %b, _)]), |, xget(%vS, list-%1)), b, |)

@@ ========================================================================= @@
think Statting commands.
@@ ========================================================================= @@

&cmd-+npc/set_with_type [v(d.npcc)]=$+npc/set */*=*:@assert t(setr(N, ulocal(f.get-current-NPC, %#, %0)))={ @trigger me/tr.error=%#,case(1, switch(%1, *=*, 1, */*, 1, 0), Can't find an NPC named '%0', or that NPC is approved and locked., You don't currently have an NPC selected to work on. Either specify your NPC with %ch+npc/edit <NPC>%cn or include the NPC in your command with %ch+npc/<command> <NPC>=<rest of the command>%cn.); }; @assert t(setr(C, ulocal(f.get-stat-type, %qN, %0)))={ @trigger me/tr.error=%#, Could not find a stat type of '%0'. Valid stat types for this category are: [itemize(ulocal(f.get-all-stat-types, %qN), |)].; }; @assert cor(t(setr(V, ulocal(f.get-value-from-list, %qN, %qC, %1))), strmatch(%1,))={ @trigger me/tr.error=%#, Could not find a %qC named '%1'. Valid possibilities are: [itemize(ulocal(f.get-all-values-from-list, %qN, %qC), |)].; }; @assert cor(t(setr(F, ulocal(f.get-value-from-list, %qN, %qV, %2))), strmatch(%2,))={ @trigger me/tr.error=%#, Could not find a %qV named '%2'. Valid possibilities are: [itemize(ulocal(f.get-all-values-from-list, %qN, %qV), |)].; }; @set %qN=setr(A, edit(%qC-%qV, %b, _)):%qF; @assert strmatch(xget(%qN, %qA), %qF)={ @switch t(%qF)=1, { @trigger me/tr.error=%#, Could not set the stat name '%qA'. Maybe that's a bad name for a stat?; }, { @trigger me/tr.error=%#, Cannot unset the %qC stat '%qV'. That stat is required.; }; }; @switch hasattr(parent(%qN), tr.%qA)=1, { @trigger parent(%qN)/tr.%qA=%qN, %qF; }; @assert t(%2)={ @trigger me/tr.success=%#, Unset [name(%qN)]'s %qC [titlestr(%qV)].; }; @trigger me/tr.success=%#, Set [name(%qN)]'s %qC [titlestr(%qV)] to: %qF;

&cmd-+npc/set [v(d.npcc)]=$+npc/set *=*:@break strmatch(%0, */*); @assert t(setr(N, ulocal(f.get-current-NPC, %#, %0)))={ @trigger me/tr.error=%#,case(1, switch(%1, *=*, 1, */*, 1, 0), Can't find an NPC named '%0', or that NPC is approved and locked., You don't currently have an NPC selected to work on. Either specify your NPC with %ch+npc/edit <NPC>%cn or include the NPC in your command with %ch+npc/<command> <NPC>=<rest of the command>%cn.); }; @assert t(setr(C, ulocal(f.get-stat, %qN, %0)))={ @assert cand(t(%1), t(setr(C, ulocal(f.get-stat-type, %qN, %0))))={ @trigger me/tr.error=%#, Could not find a stat called '%0'. Valid stats for this category are: [itemize(ulocal(f.get-all-stats, %qN), |)].; }; @force %#=+npc/set %qC/%1=1; }; @assert cor(t(setr(V, ulocal(f.get-value-from-list, %qN, %qC, %1))), strmatch(%1,))={ @trigger me/tr.error=%#, Could not find a value for %qC like '%1'. Valid possibilities are: [itemize(ulocal(f.get-all-values-from-list, %qN, %qC), |)].; }; @set %qN=setr(A, edit(%qC, %b, _)):%qV; @assert strmatch(xget(%qN, %qA), %qV)={ @switch t(%1)=1, { @trigger me/tr.error=%#, Could not set the stat name '%qA'. Maybe that's a bad name for a stat?; }, { @trigger me/tr.error=%#, Cannot unset the stat '%qC'. That stat is required.; }; }; @switch hasattr(parent(%qN), tr.%qA)=1, { @trigger parent(%qN)/tr.%qA=%qN, %qV; }; @assert t(%1)={ @trigger me/tr.success=%#, Unset [name(%qN)]'s %qC.; }; @trigger me/tr.success=%#, Set [name(%qN)]'s %qC to: %qV;

@@ TODO: Some kind of stat lister.

@@ &cmd-+npc/set_list [v(d.npcc)]=$+npc/set*:

&cmd-+npc/check [v(d.npcc)]=$+npc/check*:@assert t(setr(N, ulocal(f.get-current-NPC, %#, trim(%0)=)))={ @trigger me/tr.error=%#,case(1, switch(%1, *=*, 1, */*, 1, 0), Can't find an NPC named '%0', or that NPC is approved and locked., You don't currently have an NPC selected to work on. Either specify your NPC with %ch+npc/edit <NPC>%cn or include the NPC in your command with %ch+npc/<command> <NPC>%cn.); }; @trigger me/tr.success=%#, strcat(setq(R,), null(iter(lattrp(%qN/check-*), setq(R, %qR|[ulocal(%qN/[itext(0)], %qN)]))), setq(R, squish(trim(%qR, b, |), |)), if(t(%qR), strcat(Results:%R%T, iter(%qR, itext(0), |, %r%t)), All [name(%qN)]'s NPC checks pass.));

@@ ========================================================================= @@
think Setting up Categories for character sheets.
@@ ========================================================================= @@

@@ Stat categories for everyone: Note
@@ Stats for everyone: Appearance

&stat_categories [v(d.npcs)]=Note

&stats [v(d.npcs)]=Appearance

&non-numeric_stats [v(d.npcs)]=Appearance

@@ Common stats

&f.get-species-factor [v(d.npcs)]=default(species_factor, 1)

&f.get-size [v(d.npcs)]=default(size, 1)

@@ Required stats

&check-required_stats [v(d.npcs)]=squish(trim(iter(v(required-stats), if(not(hasattr(%0, edit(itext(0), %b, _))), itext(0) is required.), |, |), b, |), |)

&check-numeric_stats [v(d.npcs)]=squish(trim(iter(setdiff(v(stats), setunion(v(non-numeric_stats), xget(parent(), non-numeric_stats), |), |), if(not(isnum(default(%0/[edit(itext(0), %b, _)], 0))), itext(0) should be a number.), |, |), b, |), |)

&check-list_stats [v(d.npcs)]=iter(v(stat_categories), if(t(setr(0, v(list-[itext(0)]))), iter(lattr(me/[itext(0)]-*), if(not(member(ucstr(edit(%q0, %b, _)), setr(1, rest(itext(0), -)), |)), strcat('%q1' is not a valid, %b, setr(2, titlestr(itext(1))). Valid %q2 values are, %b, itemize(%q0, |).)),, |)), |, |)

&check-numeric_stat_categories [v(d.npcs)]=squish(trim(iter(setdiff(v(stat_categories), setunion(v(non-numeric_stat_categories), xget(parent(), non-numeric_stat_categories), |), |), iter(lattrp(me/[itext(0)]-*), if(not(isnum(setr(0, default(%0/[edit(itext(0), %b, _)], 0)))), titlestr(edit(itext(0), -, %b, _, %b)) should be a number. Its value is: %q0),, |), |, |), b, |), |)

@@ ========================================================================= @@

think All done. Next make sure you download some NPC types, like Animals and Spirits. Once at least one of those is installed, you should @tel NPCC to your master code room and start making NPCs.
