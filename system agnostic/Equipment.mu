@@ Requires: Layout functions (Boxtext and fitcolumns)

/*
Staff commands:

	+eq/create <title>=<details>
	+eq/destroy <title> - does not remove it from the players who have it!
	+eq/tag <title>=<tag> - tag equipment mental, physical, whatever
	+eq/untag <title>=<tag to remove> - untag equipment

	+eq/give <player>=<title> - give 'em stuff
	+eq/take <player>=<title> - take their stuff

	+eq/view <player> - see their stuff

Player commands:

	+eq - list your equipment
	+eq/details <title> - view details on a piece of equipment
	+eq/list - list equipment tags
	+eq/list <tag> - list all equipment in a particular tag
	+eq/find <title> - list all equipment that starts with that text
	+eq/prove <title> - prove you have a piece of equipment to the room
	+eq/prove <title>=<player> - prove you have a piece of equipment to a player

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

@desc EQC=%RStaff commands:%R%R%T+eq/create <title>=<details>%R%T+eq/destroy <title> - does not remove it from the players who have it!%R%T+eq/tag <title>=<tag> - tag equipment mental, physical, whatever%R%T+eq/untag <title>=<tag to remove> - untag equipment%R%R%T+eq/give <player>=<title> - give 'em stuff%R%T+eq/take <player>=<title> - take their stuff%R%R%T+eq/view <player> - see their stuff%R%RPlayer commands:%R%R%T+eq - list your equipment%R%T+eq/details <title> - view details on a piece of equipment%R%T+eq/list - list equipment tags%R%T+eq/list <tag> - list all equipment in a particular tag%R%T+eq/find <title> - list all equipment that starts with that text%R%T+eq/prove <title> - prove you have a piece of equipment to the room%R%T+eq/prove <title>=<player> - prove you have a piece of equipment to a player%R


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Layouts
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %0 - error message
&layout.error EQF=alert(Equipment malfuction) %0

@@ %0 - player
&layout.equipment EQF=strcat(wheader(Your equipment, %0), %R, iter(lattr(%0/_eq-*), ulocal(layout.equipment-line, %0, trim(itext(0), l, _)),, %R), %R, wfooter(, %0))

@@ %0 - player
@@ %1 - target
&layout.players-equipment EQF=strcat(wheader(name(%1)'s equipment, %0), %R, iter(lattr(%1/_eq-*), strcat(ulocal(layout.equipment-line, %1, trim(itext(0), l, _)), %R, space(3), rest(xget(%1, itext(0)), |)),, %R), %R, wfooter(, %0))


@@ %0 - player
@@ %1 - equipment attribute
&layout.equipment-line EQF=strcat(setq(0, strcat(xget(%vD, %1), :, %b, xget(%vD, edit(%1, NAME, DETAILS)))), setq(1, ulocal(f.get-width, %0)), if(lte(strlen(%q0), sub(%q1, 2)), strcat(%b, %q0), strcat(%b, strtrunc(%q0, sub(%q1, 5)), ...)))

@@ %0 - player
@@ %1 - tag if there is one
&layout.list-equipment EQF=strcat(wheader(if(t(%1), Equipment in tags matching '%1', Equipment tags), %0), %R, if(t(%1), iter(ulocal(f.list-equipment-by-tag, %1), ulocal(layout.equipment-line, %vD, itext(0)),, %R), fitcolumns(ulocal(f.list-equipment-tags, %1), |, %0)), %R, wfooter(, %0))

@@ %0 - player
@@ %1 - title if there is one
&layout.find-equipment EQF=strcat(wheader(Equipment matching '%1', %0), %R, setq(0, ulocal(f.find-equipment-by-title, %0, %1)), if(t(%q0), iter(%q0, ulocal(layout.equipment-line, %vD, trim(itext(0), l, _)),, %R), No equipment by the title '%1' found.), %R, wfooter(, %0))
+eq/find l

@@ %0 - player viewing
@@ %1 - title of the presumed equipment
@@ %2 - player the equipment is on
&layout.equipment-details EQF=if(t(setr(0, ulocal(f.find-all-equipment-by-title, %1))), strcat(wheader(ulocal(f.get-equipment-title, %q0), %0), %R, boxtext(ulocal(f.get-equipment-details, %q0),,, %0), %R%R, boxtext(strcat(Tags:, %b, setq(1, ulocal(f.get-equipment-tags, %q0)), if(t(%q1), itemize(%q1, |), None.)),,, %0), %R%R, if(t(%2), if(hasattr(%2, _%q0), boxtext(rest(xget(%2, _%q0), |),,, %0))), %r, wfooter(, %0)), ulocal(layout.error, Could not find equipment '%1'.))

@@ %0 - player
@@ %1 - equipment found
@@ %2 - target player
@@ %3 - "to" string - to "you", "the room".
&layout.prove-equipment EQF=strcat(alert(Equipment), name(%0) proves, %b, poss(%0), %b, equipment ', setr(0, ulocal(f.get-equipment-title, trim(%1, l, _))), ', %b, to %3:, %R%R, u(layout.equipment-details, %2, %q0, %0))


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Local functions
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %0 - the player
&f.get-width EQF=max(min(width(%0), 80), 50)

@@ %0 - the command input
&f.find-command-switch EQF=strcat(setq(0,), setq(1,), setq(2, switch(%0, /*/*, first(rest(first(%0), /), /), /*, rest(first(%0), /), first(%0))), null(iter(sort(lattr(%!/switch.*.%q2*)), case(1, match(last(itext(0), .), %q2), setq(0, %q0 [itext(0)]), strmatch(last(itext(0), .), %q2*), setq(1, %q1 [itext(0)])))), trim(if(t(%q0), first(%q0), %q1), b))

@@ %0 - player
@@ %1 - title
&f.find-equipment-on-player-by-title EQF=first(trim(squish(iter(lattr(%0/_eq-*), if(strmatch(first(xget(%0, itext(0)), |), %1*), itext(0)),, |), |), b, |), |)

@@ %0 - title
&f.find-all-equipment-by-title EQF=first(trim(squish(iter(lattr(%vD/eq-*), if(strmatch(first(xget(%vD, itext(0)), |), %0*), itext(0)),, |), |), b, |), |)

@@ %0 - player
@@ %1 - title
&f.find-equipment-by-title EQF=case(1, t(setr(0, ulocal(f.find-equipment-on-player-by-title, %0, %1))), %q0, t(setr(1, ulocal(f.find-all-equipment-by-title, %1))), %q1, #-1 NOT FOUND)

@@ %0 - tag
&f.list-equipment-by-tag EQF=trim(squish(iter(lattr(%vD/eq-*-tags), iter(xget(%vD, itext(0)), if(strmatch(itext(0), %0*), edit(itext(1), TAGS, NAME)), |))))

@@ %0 - tag
&f.list-equipment-tags EQF=setinter(setr(0, trim(squish(iter(lattr(%vD/eq-*-tags), iter(xget(%vD, itext(0)), if(strmatch(itext(0), %0*), itext(0)), |, |),, |), |), b, |)), %q0, |)

@@ %0 - me, nothing, or %#
&f.get-player EQF=pmatch(switch(%0, me, %#,, %#, %0))

@@ %0 - equipment attribute
&f.get-equipment-tags EQF=xget(%vD, edit(%0, NAME, TAGS))

@@ %0 - equipment attribute
&f.get-equipment-title EQF=xget(%vD, %0)

@@ %0 - equipment attribute
&f.get-equipment-details EQF=xget(%vD, edit(%0, NAME, DETAILS))

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Command manager
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&cmd-+eq EQC=$+eq*:@switch setr(E, strcat(setq(C, ulocal(f.find-command-switch, %0)), if(not(t(%qC)), Could not find command: +eq%0)))=, { @trigger me/%qC=%#, %0; }, { @pemit %#=ulocal(layout.error, %qE); }
+eq


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Command switches
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&switch.0. EQC=@pemit %0=ulocal(layout.equipment, %0);

&switch.1.details EQC=@pemit %0=ulocal(layout.equipment-details, %0, rest(%1), %0);

&switch.2.list EQC=@pemit %0=ulocal(layout.list-equipment, %0, rest(%1));

&switch.3.find EQC=@pemit %0=ulocal(layout.find-equipment, %0, rest(%1));

&switch.4.prove EQC=@trigger me/tr.prove-equipment=%0, before(rest(%1), =), rest(%1, =);

&switch.5.create EQC=@trigger me/tr.equipment-create=%0, before(rest(%1), =), rest(%1, =);

&switch.5.tag EQC=@trigger me/tr.equipment-tag=%0, before(rest(%1), =), rest(%1, =);

&switch.5.untag EQC=@trigger me/tr.equipment-untag=%0, before(rest(%1), =), rest(%1, =);

&switch.6.give EQC=@trigger me/tr.equipment-give=%0, before(rest(%1), =), rest(%1, =);

&switch.6.take EQC=@trigger me/tr.equipment-take=%0, before(rest(%1), =), rest(%1, =);

&switch.6.view EQC=@trigger me/tr.equipment-view=%0, rest(%1);

&switch.99.destroy EQC=@switch/first %1=*=*, { @trigger me/tr.destroy-equipment=%0, first(rest(%1), =), rest(%1, =); }, { @trigger me/tr.confirm-destroy=%0, rest(%1); }


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Triggers
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ Input:
@@ %0 - %#
@@ %1 - equipment title
@@ %2 - details
&tr.equipment-create EQC=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot create equipment.), %b, if(not(t(%1)), You need to include a title for the new equipment.), %b, if(not(t(%2)), You need to include details for the new equipment.)))))=, { @set %vD=eq-count:[setr(N, add(default(%vD/eq-count, 0), 1))]; @set %vD=eq-%qN-name:%1; @set %vD=eq-%qN-details:%2; @pemit %0=u(layout.equipment-details, %0, %1); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - equipment title
@@ %2 - tag
&tr.equipment-tag EQC=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot tag equipment.), %b, if(not(t(setr(A, ulocal(f.find-all-equipment-by-title, %1)))), Could not find equipment named '%1'.), %b, if(not(t(%2)), You need to include a tag for the equipment.)))))=, { @set %vD=setr(A, edit(%qA, NAME, TAGS)):[setunion(ulocal(f.get-equipment-tags, %qA), %2, |)]; @pemit %0=u(layout.equipment-details, %0, %1); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - equipment title
@@ %2 - tag
&tr.equipment-untag EQC=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot tag equipment.), %b, if(not(t(setr(A, ulocal(f.find-all-equipment-by-title, %1)))), Could not find equipment named '%1'.), %b, if(or(not(t(%2)), not(member(setr(T, ulocal(f.get-equipment-tags, %qA)), %2, |))), You need to include the exact tag you wish to remove.)))))=, { @set %vD=setr(A, edit(%qA, NAME, TAGS)):[setdiff(%qT, %2, |)]; @pemit %0=u(layout.equipment-details, %0, %1); }, { @pemit %0=ulocal(layout.error, %qE); }


@@ Input:
@@ %0 - %#
@@ %1 - player
@@ %2 - equipment title
&tr.equipment-give EQC=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot give equipment.), %b, if(not(t(setr(A, ulocal(f.find-all-equipment-by-title, %2)))), Could not find equipment named '%2'.), %b, if(or(not(t(%2)), not(t(setr(P, ulocal(f.get-player, %1))))), Could not find player '%1'.)))))=, { @set %qP=_%qA:[ulocal(f.get-equipment-title, %qA)]|[strcat(Given to, %b, name(%qP), %(, %qP, %), %b, by, %b, moniker(%0), %b, %(, %0, %), %b, on, %b, time(), .)]; @pemit %0=alert(Equipment) You gave [name(%qP)] the equipment [ulocal(f.get-equipment-title, %qA)]. If there's anything special about it, use +note.; }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - player
@@ %2 - equipment title
&tr.equipment-take EQC=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot take away equipment.), %b, if(or(not(t(%2)), not(t(setr(P, ulocal(f.get-player, %1))))), Could not find player '%1'., if(not(t(setr(A, ulocal(f.find-equipment-on-player-by-title, %qP, %2)))), Could not find equipment named '%2' on player [name(%qP)].))))))=, { @wipe %qP/%qA; @pemit %0=alert(Equipment) You took [name(%qP)]'s equipment [ulocal(f.get-equipment-title, trim(%qA, l, _))] away. Remember to unapprove any applicable player notes.; }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - player
&tr.equipment-view EQC=@switch setr(E, trim(squish(strcat(if(not(isstaff(%0)), You are not staff and cannot view players' equipment.), %b, if(or(not(t(%1)), not(t(setr(P, ulocal(f.get-player, %1))))), Could not find player '%1'.)))))=, { @pemit %0=ulocal(layout.players-equipment, %0, %qP); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - title
&tr.confirm-destroy EQC=@switch setr(E, strcat(if(not(isstaff(%0)), You are not staff and cannot destroy equipment.), setq(N, ulocal(f.find-all-equipment-by-title, %1)), if(not(t(%qN)), Couldn't figure out which equipment you meant by '%1'.)))=, { @set %0=eq-nuke:%qN|[secs()]; @pemit %0=alert(Equipment) Before you continue, make absolutely certain that [xget(%vD, %qN)] is the equipment you want to destroy. If you're absolutely certain you want to destroy this equipment, type +eq/destroy %1=YES; }, { @pemit %0=ulocal(layout.error, %qE); }

&tr.destroy-equipment EQC=@switch strcat(if(not(isstaff(%0)), You are not staff and cannot destroy equipment.), setq(N, ulocal(f.find-all-equipment-by-title, %1)), setq(P, xget(%vD, %qN)), or(not(strmatch(%qN, first(setr(W, xget(%0, eq-nuke)), |))), gt(sub(secs(), rest(%qW, |)), 300), not(match(%2, YES))))=1, { @trigger me/tr.confirm-destroy=%0, %1; }, { @switch setr(E, if(not(t(%qN)), Couldn't figure out which equipment you meant by '%1'.))=, { @pemit %0=alert(Equipment) Decompiling equipment data so you can recreate it if this was a mistake...%R%R[iter(lattr(%vD/eq-[first(rest(%qN, -), -)]-*), &[itext(0)] %vD=[xget(%vD, itext(0))],, %R)]%R; @pemit %0=alert(Equipment) Deleting data for %qP equipment...; @wipe %vD/eq-[first(rest(%qN, -), -)]-*; @pemit %0=alert(Equipment) The equipment '%qP' has been destroyed. This does not remove it from players that have it set, but they will no longer be able to view equipment details for that equipment; }, { @pemit %0=ulocal(layout.error, %qE); }; }





@@ Input:
@@ %0 - %#
@@ %1 - title
@@ %2 - target player (optional)
&tr.prove-equipment EQC=@switch setr(E, strcat(setq(F, ulocal(f.find-equipment-on-player-by-title, %0, %1)), setq(P, if(t(%2), ulocal(f.get-player, %2), strcat(lcon(loc(%0), CONNECT), setq(T, the room)))), if(not(t(%qP)), Couldn't figure out who '%2' is.), if(not(t(%qF)), Couldn't find a piece of equipment on you named '%1'.)))=, { @dolist/notify %qP={ @pemit ##=ulocal(layout.prove-equipment, %0, %qF, ##, if(t(%qT), %qT, you)); }; @wait me=@switch/first %qT=, { @pemit %0=alert(Equipment) You showed [if(t(%qT), %qT, itemize(iter(%qP, name(itext(0)),, |), |))] your [first(xget(%0, %qF), |)] equipment.; } }, { @pemit %0=ulocal(layout.error, %qE); }


/*

Sample use:

+eq/create Light Pistol=Damage 1, Range 25/50/10, Capacity Medium, Init -0, Str 2, Size 1, Availability 2. HL Pg.152.
+eq/tag Light Pis=Weapon|Firearm
+eq/details Light

*/

