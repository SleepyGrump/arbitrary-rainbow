/*
Dependencies:
	titlestr(word) - output: Word
	set() - side effects

The Layout Functions object which contains:

	wheader(text, player)
	wfooter(text, player)
	boxtext(list of stuff, separator, number of columns)
	fitcolumns(list, delimiter, player)

There's some integration with the Fate Dice Roller, which includes a concept called the Fate Ladder which consists of "word describing how good your stat is (+numeric value of stat)". I wanted to integrate this by default. It's easily uncoupled just by changing &layout.number to be however you want your numbers to be displayed. If you leave it in, however, you need the following function from that code:

	getladderword(#) - gets the formatted output of the Fate Ladder from a number. For example, "2" might return "%ch%cyCompetent%cn (+2)" depending on how you have your ladder set up.

Scope:
	- Two root commands, +profile and +pro (because ow my typing fingers).
		- Code +profile first, then +pro as an alias.
	- Allow the player to create, edit, share, switch, and delete profiles with ease.

		View profiles:
			+pros or +profiles - list your profiles
			+pro or +profile - view your current profile

		Switch profiles:
			+profile/set <name> - set your current profile to the <name> profile
			+profile/switch - switch to your last profile

		Create profiles:
			+profile/create <name> - make a new profile and switch to it. You don't have to do this - because you have a profile by default, you can just start setting yourself up. This command only matters when you want more than one.

		Edit profiles:
			+profile/set default - your first profile is always your default, but if you want to change it to a new one, this will do it.
			+profile/set <group>/<field>=<value> - set parts of a profile
				- To clear a field, +profile/set <group>/<field>=<nothing>
				- You can also +profile/set <field>=<value> but it will try to guess the group, and it might guess wrong. All "wrong" guesses go into the last group on the list.
			Special settings:
				Name - sets your icname()
				Gender - sets your @sex as well as your pronouns
				Pronouns - sets your pronouns()
				Default - Sets your current profile as the default profile.
			Global profile-switching settings:
				Mode - whether your profile changes your PC object or just your IC attributes.
					Active: Change your @name and @sex when you change profiles (you must have an @alias for this to work).
					Passive: Don't do that. (Default)
				Noise - how loud you are when switching profiles.
					Loud: Notify the room when you switch to a new profile.
					Quiet: Don't do that. (Default)

		Share profiles:
			+profile/show - show your current profile to the room.
			+profile/show <name> - show your current profile to someone.
			+profile/prove <stat> - show a stat to the room.
			+profile/prove <stat>=<name> - show a stat to someone.

		Delete profiles:
			+profile/nuke <name> - delete a profile. You'll get an "Are you sure?" Once you confirm, it goes byebye. If you delete your default, it just clears the default.

		Functions for coders:

			Pronouns and IC name occupy a special place because we want coders to be able to reference those parts of the PC's current profile easily. As such, they have global functions:

			  icname(%#) - get the player's current profile name, defaults to name() if not set

			  gender(%#) - get the player's current gender, defaults to @sex if not set.

			  pronouns(%#) - get the player's current profile pronouns, defaults to the pronouns and titles derived from the player's gender if not set

			  pronouns(%#, [s, o, p, a, t]) - get the subjective, objective, possessive, absolute possessive, or title pronoun for a person. You can spell out "subjective" if that helps you with code readability.

			Any other current profile note can be referenced like so:

				getprofilevalue(%#, group, field) - get any value on the player's current profile. If they haven't set that field up, you get nothing. This is to let you reference "stats" from dice rollers and door locks. (Must have Mechanics of at least 2 to open this chest, for example.)

			This also enables a little custom coding:

				@desc me=getprofilevalue(me, Bio, Description)

			Or, if you want to use some layout functions:

				@desc me=strcat(header(icname(me), %#), %R, boxtext(getprofilevalue(me, Bio, Description),,, %#), %R, footer(strcat(Pronouns:, %b, pronouns(me)), %#))

			Note: coders can't get the player's non-current profile. It would've been too much work for too little gain. Anyone can execute the above functions - there is no staff/wizbit lock - so with the +profile/set command, the player chooses what to show the world, and the world doesn't get to dig into the player's other personas until the player chooses to play them.

			Another note: because of that, I am not writing +profile <player>, +profiles <player>, +profile <player>/<profile>, etc. I just don't see the point, when +profile is intended for a cooperative game of tabletop rather than a staff-lead top-down game.

	- Profile data will be directly editable by the player without commands. This is because this is a low-code solution (despite appearances!), the data belongs to the player, and it will be possible for players to break things via commands. It should also be possible to fix those things or get a coder to figure them out.

	- Profile data will be exposed so the player can @decompile it.

	- Profile data should be stored like so:
	    &p-###-name %#=name
	    &p-###-pronouns %#=pronouns
	    &p-###-gender %#=gender
	    &p-###-<group>-###-label %#=label
	    &p-###-<group>-###-value %#=value

	- Profile settings should be stored like so:
			&profile-mode %#=Active|Passive|empty (passive)
			&profile-noise %#=Loud|Quiet|empty (quiet)
			&profile-default %#=###
			&profile-last %#=###
			&profile-count %#=###

	- Current profile will be stored like so:
			&icname %#=name
			&pronouns %#=subjective objective possessive apossessive title
			&gender %#=gender
			&current-profile %#=###



*/

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Don't change this bit. Skip down to the word 'customize'.
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@create Profile Functions <PF>=10
@set PF=SAFE INHERIT

@create Profile Layouts and Data <PLaD>=10
@set PLaD=SAFE
@parent PLaD=PF

@create Profile Switcher <PS>=10
@set PS=SAFE INHERIT
@parent PS=PLaD

@force me=&vD PF=[num(PLaD)]

@Startup PS=@dolist v(d.function_objects)=@trigger me/tr.makefunctions=##;

&tr.makefunctions PS=@dolist lattr(%0/f.global.*)=@function rest(rest(##, .), .)=%0/##; @dolist lattr(%0/f.globalp.*)=@function/preserve rest(rest(##, .), .)=%0/##; @dolist lattr(%0/f.globalpp.*)=@function/preserve/privilege rest(rest(##, .), .)=%0/##;

@force me=&D.FUNCTION_OBJECTS PS=[num(PF)]


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Here are the bits you're most likely to want to customize.
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Data - you must have at least one group. You can skip the rest.
@@        The data below is for some variety of Fate, maybe Accellerated.
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&d.predefined-groups PLaD=Bio|Skills|Approaches|Other

&d.predefined-labels.bio PLaD=Full name|High concept|Trouble
&d.predefined-value.bio PLaD=Not set

&d.predefined-labels.approaches PLaD=Careful|Clever|Flashy|Forceful|Quick|Sneaky
&d.predefined-value.approaches PLaD=0
&d.group-value-format.Approaches PLaD=number

&d.predefined-labels.skills PLaD=Stealth|Athletics|Lore|Mechanics|Survival
&d.predefined-value.skills PLaD=0
&d.group-value-format.skills PLaD=number

&d.predefined-labels.other PLaD=Stress|Conditions|Refresh|Fate Points
&d.predefined-value.other PLaD=None

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Layouts
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %# - %#
&layout.profile-list PLaD=strcat(setq(0, ulocal(f.get-current-profile, %0)), setq(2, default(%0/profile-default, 1)), wheader(name(%0) - Profiles, %0), %R, fitcolumns(trim(strcat(iter(sort(lattr(%0/p-*-name)), setr(1, edit(ulocal(layout.profile-name, %0, itext(0), %q0, %q2), |, _)),, |), if(not(t(%q1)), strcat(|, icname(%0), if(match(%q2, %q0), %b%(current%, default%))))), b, |), |, %0), %R, wfooter(strcat(Current profile:, %b, icname(%0)), %0))

@@ %0 - %#
@@ %1 - P-###-NAME
@@ %2 - current profile number
@@ %3 - profile default
&layout.profile-name PLaD=strcat(setq(0, edit(%1, -NAME,, P-,)), xget(%0, %1), case(strcat(match(%3, %q0), match(%2, %q0)), 11, strcat(%b, %(, current%, default, %)), 10, strcat(%b, %(, default, %)), 01, strcat(%b, %(, current, %))))

@@ %0 - %#
@@ %1 - viewer (optional)
&layout.profile PLaD=strcat(wheader(icname(%0) - Profile, setr(0, u(f.get-player, %0, %1))), %R, ulocal(layout.vitals, %0, %1), %R, iter(v(d.predefined-groups), ulocal(layout.group, %0, ulocal(f.get-current-profile, %0), itext(0), %1), |, %R), %R, wfooter(icname(%0), %q0))

@@ %0 - %#
@@ %1 - viewer (optional)
&layout.vitals PLaD=strcat(setq(0, 16), setq(1, or(match(%0, %1), not(t(%1)))), setq(2, strcat(ljust(Name:, %q0), %b, icname(%0), if(%q1, strcat(|, ljust(Default profile:, %q0), %b, if(match(default(%0/profile-default, 1), ulocal(f.f.get-current-profile, %0)), Yes, No))), |, ljust(Gender:, %q0), %b, gender(%0), if(%q1, strcat(|, ljust(Switch mode:, %q0), %b, default(%0/profile-mode, Passive))), if(%q1, strcat(||, ljust(Switch volume:, %q0), %b, default(%0/profile-noise, Quiet))))), boxtext(%q2, |, 2, u(f.get-player, %0, %1)), %b, ljust(Pronouns:, %q0), %b, pronouns(%0))

@@ %0 - %#
@@ %1 - profile number
@@ %2 - group
@@ %3 - viewer (optional)
&layout.group PLaD=strcat(setq(0, ulocal(f.get-fields-by-group, %0, %1, %2)), setq(1, getlongest(setr(4, iter(%q0, edit(ulocal(layout.label, ulocal(f.get-label, %0, itext(0), %2, inum(0))), |, _),, |)), |)), setq(2, getlongest(setr(5, iter(%q0, edit(ulocal(layout.value, ulocal(f.get-value, %0, itext(0), %2), v(d.group-value-format.%2)), |, _),, |)), |)), if(gt(add(%q1, %q2), div(ulocal(f.get-width, %0, %3), 2)), setq(2, 0)), wheader(%2, setr(6, ulocal(f.get-player, %0, %3))), %R, fitcolumns(iter(%q0, ulocal(layout.field, extract(%q4, inum(0), 1, |), extract(%q5, inum(0), 1, |),, %q1, %q2),, |), |, %q6))

@@ %0 - label
@@ %1 - Value
@@ %2 - value format
@@ %3 - label width
@@ %4 - value width
&layout.field PLaD=strcat(ulocal(layout.label, %0, %3), ulocal(layout.value, %1, %2, %4))

@@ %0 - label
@@ %1 - label width
&layout.label PLaD=case(1, and(strmatch(%0, *:*), t(%1)), ljust(%0, %1), strmatch(%0, *:*), %0, and(t(%0), t(%1)), ljust(strcat(%0, :, %b), %1), t(%0), strcat(%0, :, %b))

@@ %0 - Value
@@ %1 - value format
@@ %2 - value width
&layout.value PLaD=case(1, and(t(%2), t(strlen(%0))), ljust(ulocal(layout.format, %0, %1), %2), t(strlen(%0)), ulocal(layout.format, %0, %1))


@@ TODO: Add other formats?
@@ %0 - Value
@@ %1 - value format
&layout.format PLaD=switch(%1, number, ulocal(layout.number, %0), %0)

@@ TODO: Change this to a game-specific format?
@@ %0: A number
@@ Output: A formatted number
&layout.number PLaD=case(1, not(isnum(%0)), %0, gt(%0, 0), +%0, %0)

@@ %0 - %#
@@ %1 - profile
@@ %2 - group
@@ %3 - label
@@ %4 - value
&layout.value-set PLaD=strcat(alert(Profile: [icname(%0)]), %b, titlestr(%2), %b>%b, titlestr(%3), %b, now set to:, %b, switch(%3, Name, icname(%0), Gender, gender(%0), Pronouns, pronouns(%0), getprofilevalue(%0, %2, %3)))

@@ %0 - %#
@@ %1 - profile
@@ %2 - group
@@ %3 - label
@@ %4 - value
&layout.value-cleared PLaD=strcat(alert(Profile: [icname(%0)]), %b, titlestr(%2), %b>%b, titlestr(%3), %b, has been cleared.)


@@ %0 - %#
@@ %1 - setting
@@ %2 - value
&layout.setting-set PLaD=strcat(alert(Profile: [icname(%0)]), %b, switch(%1, Default, Your default profile is now: [icname(%0)], Mode, Your profile-switching mode is now: [default(%0/profile-mode, Passive)], Noise, Your profile-switching volume is now: [default(%0/profile-noise, Quiet)], Volume, Your profile-switching volume is now: [default(%0/profile-noise, Quiet)], Your %1 is now: %2))

@@ %0 - %#
@@ %1 - new profile number
@@ %2 - last profile number
&layout.profile-set PLaD=strcat(alert(Profile: [icname(%0)]), %b, if(t(strlen(%2)), Switched from [xget(%0, p-%2-name)] to [icname(%0)]., Profile now set to [icname(%0)].))

@@ %0 - %#
@@ %1 - new profile number
@@ %2 - last profile number
&layout.profile-set-loud PLaD=strcat(alert(Profile), %b, if(t(strlen(%2)), strcat(xget(%0, p-%2-name), %b, is now), name(%0) is now), %b, icname(%0)., if(strmatch(default(%0/profile-mode, Passive), Passive), strcat(%b, %(Player name, %b, name(%0).%))))

@@ %0 - %#
@@ %1 - name
&layout.switch-name PLaD=strcat(alert(Profile), %b, if(match(icname(%0), name(%0)), strcat(@name successfully switched to, %b, icname(%0).), strcat(Could not switch your @name to, %b, icname(%0). It might have been taken or it might not be a valid @name.)))

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ After this point you probably don't want to change things.
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@




@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Global functions
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@


@@ %0 - %#
@@ %1 - group or label
@@ %2 - label if group is given
&f.globalpp.getprofilevalue PF=strcat(setq(0, ulocal(f.get-current-profile, setr(1, u(f.get-player, %0)))), case(1, or(not(t(%0)), not(t(%1)), not(t(%q1))), #-1 ERROR You must give at least a person and a field to look up., and(t(%2), t(%1)), xget(%q1, ulocal(f.get-field-by-exact-group-and-label, %q1, %q0, %1, %2)-value), xget(%q1, ulocal(f.get-field-by-label, %q1, %q0, %2)-value)))

&f.globalpp.icname PF=default(setr(0, u(f.get-player, %0))/icname, name(%q0))

&f.globalpp.gender PF=default(setr(0, u(f.get-player, %0))/gender, default(%q0/sex, None))

&f.globalpp.pronouns PF=strcat(setq(1, default(setr(0, u(f.get-player, %0))/pronouns, strcat(subj(%q0), %b, obj(%q0), %b, poss(%q0), %b, aposs(%q0), %b, switch(xget(%q0, sex), m*, Mr., f*, Ms., Mx.)))), setq(1, edit(%q1, it it its its, they them their theirs, |)), if(t(%1), case(1, strmatch(%1, s*), first(%q1), strmatch(%1, o*), extract(%q1, 2, 1), strmatch(%1, p*), extract(%q1, 3, 1), strmatch(%1, a*), extract(%q1, 4, 1), last(%q1)), %q1))

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Local functions
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %0 - me, nothing, or %#
&f.get-player PF=pmatch(switch(%0, me, %#,, %#, %0))

@@ %0 - %#
@@ %1 - viewer DBref
&f.get-width PF=max(min(width(case(1, t(%1), %1, t(%0), %0, %#)), 80), 50)

@@ %0 - %#
@@ %1 - field
@@ %2 - group
@@ %3 - item
&f.get-label PF=default(%0/%1-label, extract(xget(%vD, d.predefined-labels.%2), %3, 1, |))

@@ %0 - %#
@@ %1 - field
@@ %2 - group
&f.get-value PF=default(%0/%1-value, default(%vD/d.predefined-value.%2, ?))

@@ %0 - %#
@@ %1 - profile number
@@ %2 - group
&f.get-fields-by-group PF=strcat(setq(0,), setq(1,), iter(xget(%vD, d.predefined-labels.%2), if(t(setr(2, ulocal(f.get-field-by-exact-group-and-label, %0, %1, %2, itext(0)))), strcat(setq(0, %q0 %q2), setq(1, %q1 %q2)), setq(0, %q0 %2_DEFAULT)), |, null(0)), %q0, %b, iter(setdiff(edit(lattr(%0/p-%1-%2-*-label), -LABEL,), %q1), itext(0)))

@@ Trying to get what's on the player to merge with a list of fields on the data object.

@@ %0 - %#
@@ %1 - profile number
@@ %2 - group
@@ %3 - label text
&f.get-value-by-group-and-label PF=xget(%0, first(trim(squish(iter(lattr(%0/p-%1-%2-*-label), if(strmatch(xget(%0, itext(0), %3*)), edit(itext(0), -LABEL, -VALUE)))))))

@@ %0 - %#
@@ %1 - profile number
@@ %2 - label text
&f.get-value-by-label PF=xget(%0, ulocal(f.get-field-by-label, %0, %1, %2)-VALUE)

@@ %0 - label text
&f.find-predefined-group-by-exact-label PF=trim(squish(iter(lattr(%vD/d.predefined-labels.*), iter(xget(%vD, itext(0)), if(strmatch(itext(0), %0), last(itext(1), .)), |, |),, |), |), b, |)

@@ %0 - label text
&f.find-predefined-group-by-label PF=if(t(setr(0, ulocal(f.find-predefined-group-by-exact-label, %0))), %q0, trim(squish(iter(lattr(%vD/d.predefined-labels.*), iter(xget(%vD, itext(0)), if(strmatch(itext(0), %0*), last(itext(1), .)), |, |),, |), |), b, |))

@@ %0 - %#
@@ %1 - label text
@@ Output: Group name
&f.get-group-by-label PF=if(t(setr(0, ulocal(f.get-field-by-label, %0, ulocal(f.get-current-profile, %0), %1))), first(rest(rest(%q0, -), -), -), if(t(setr(0, ulocal(f.find-predefined-group-by-label, %1))), %q0, Other))

@@ %0 - group
@@ %1 - label text
&f.find-best-label PF=if(t(setr(0, trim(squish(iter(strcat(Name|Gender|Pronouns|Default|Mode|Noise|Volume|, xget(%vD, d.predefined-labels.%0)), if(strmatch(itext(0), %1*), itext(0)), |, |), |), b, |))), %q0, titlestr(%1))

@@ %0 - %#
@@ %1 - profile number
@@ %2 - label text
&f.get-field-by-exact-label PF=first(trim(squish(iter(lattr(%0/p-%1-*-label), if(strmatch(xget(%0, itext(0)), %2), edit(itext(0), -LABEL,))))))

@@ %0 - %#
@@ %1 - profile number
@@ %2 - label text
&f.get-field-by-label PF=if(t(setr(0, ulocal(f.get-field-by-exact-label, %0, %1, %2))), %q0, first(trim(squish(iter(lattr(%0/p-%1-*-label), if(strmatch(xget(%0, itext(0)), %2*), edit(itext(0), -LABEL,)))))))

@@ %0 - %#
@@ %1 - profile number
@@ %2 - group
@@ %3 - label text
&f.get-field-by-exact-group-and-label PF=first(trim(squish(iter(lattr(%0/p-%1-%2-*-label), if(strmatch(xget(%0, itext(0)), %3), edit(itext(0), -LABEL,))))))

@@ %0 - %#
&f.get-current-profile PF=default(%0/current-profile, 1)

@@ %0 - %#
@@ %1 - profile number
@@ %2 - group
@@ %3 - label text
@@ Output: full field name prefix
&f.get-field-to-set PF=if(t(setr(0, ulocal(f.get-field-by-exact-group-and-label, %0, %1, %2, %3))), %q0, strcat(setq(0, add(default(%0/p-%1-%2-count, 0), 1)), null(set(%0, p-%1-%2-count:%q0)), p-%1-%2-%q0))


@@ %0 - group
@@ Output: correct group
&f.validate-group PF=if(t(member(v(d.predefined-groups), titlestr(%0), |)), titlestr(%0), last(v(d.predefined-groups), |))

@@ %0 - the command input
&f.find-command-switch PF=strcat(setq(0,), setq(1,), setq(2, switch(%0, /*/*, first(rest(first(%0), /), /), /*, rest(first(%0), /), first(%0))), null(iter(sort(lattr(%!/switch.*.%q2*)), case(1, match(last(itext(0), .), %q2), setq(0, %q0 [itext(0)]), strmatch(last(itext(0), .), %q2*), setq(1, %q1 [itext(0)])))), trim(if(t(%q0), first(%q0), %q1), b))

@@ %0 - %#
@@ %1 - profile name
@@ Output: profile ID
&f.find-profile-by-name PF=strcat(setq(0,), setq(1,), null(iter(sort(lattr(%0/p-*-name)), case(1, match(setr(2, xget(%0, itext(0))), %1), setq(0, %q0 [itext(0)]), strmatch(%q2, %1*), setq(1, %q1 [itext(0)])))), setq(0, if(t(%q0), first(%q0), if(t(%q1), first(%q1)))), if(t(%q0), edit(%q0, P-,, -NAME,), #-1 NOT FOUND))

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Commands
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@


@@ Momma command manager
&cmd-+profile PS=$+profile*:@switch setr(E, strcat(setq(C, ulocal(f.find-command-switch, %0)), if(not(t(%qC)), Could not find command: +profile%0)))=, { @trigger me/%qC=%#, %0; @pemit %#=alert(Debug) %qC |%0|; }, { @pemit %#=alert(Profiles error) %qE; }


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Command switches
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&switch.0. PS=@pemit %0=ulocal(layout.profile, %0);

&switch.1.s PS=@pemit %0=ulocal(layout.profile-list, %0);

&switch.2.set PS=@switch/first %1=/s* */*=*, { @trigger me/tr.profile.set=%0, setr(G, ulocal(f.validate-group, first(setr(L, rest(first(%1, =))), /))), ulocal(f.find-best-label, %qG, rest(%qL, /)), rest(%1, =); }, /s* *=*, { @trigger me/tr.profile.set=%0, setr(G, ulocal(f.get-group-by-label, %0, setr(L, first(rest(%1), =)))), ulocal(f.find-best-label, %qG, %qL), rest(%1, =); }, /se* default, { @trigger me/tr.profile.set=%0,, Default; }, /se* *, { @trigger me/tr.profile.switch=%0, rest(%1); }, /se*, { @pemit %0=alert(Profile +set) Please enter something to set!; }, { @pemit %0=alert(Profile set error) Could not find +profile/set command: +profile%1; }

&switch.3.show PS=@trigger me/tr.profile.show=%0, rest(%1);

&switch.4.switch PS=@trigger me/tr.profile.switch=%0, if(t(rest(%1)), rest(%1), xget(%0, strcat(p-, default(%0/profile-last, default(%0/profile-default, 1)), -name)));

&switch.5.create PS=@trigger me/tr.profile-create=%0, rest(%1);

&switch.6.prove PS=@trigger me/tr.prove-field=%0, before(rest(%1), =), rest(%1, =);

&switch.99.nuke PS=@switch/first %1=*=*, { @trigger me/tr.nuke-profile=%0, first(rest(%1), =), rest(%1, =); }, { @trigger me/tr.confirm-nuke=%0, rest(%1); }

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Triggers
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&tr.profile.show PS=@switch setr(E, strcat(setq(P, if(t(%1), ulocal(f.get-player, %1), strcat(lcon(loc(%0), CONNECT), setq(T, the room)))), if(not(t(%qP)), Couldn't figure out who '%1' is.)))=, { @dolist/notify %qP={ @pemit ##=strcat(alert(Profile), %b, name(%0), %b, shows, %b, if(t(%qT), %qT, you), %b, pronouns(%0, poss), %b, current profile:, %R, ulocal(layout.profile, %0, ##)); }; @wait me={ @switch/first %qT=, { @pemit %0=alert(Profile) You showed [itemize(iter(%qP, name(itext(0)),, |), |)] your profile for [icname(%0)].; }; }; }, { @pemit %0=alert(Profile) %qE; }

@@ Input:
@@ %0 - %#
@@ %1 - Group
@@ %2 - Label
@@ %3 - Value
&tr.profile.set PS=@switch/first %2=name, { @trigger me/tr.set-name=%0, %3; }, pronoun*, { @trigger me/tr.set-pronouns=%0, %3; }, gender, { @trigger me/tr.set-gender=%0, %3; }, default, { @trigger me/tr.set-default=%0; }, mode, { @trigger me/tr.set-mode=%0, %3; }, noise, { @trigger me/tr.set-noise=%0, %3; }, volume, { @trigger me/tr.set-noise=%0, %3; }, { @trigger me/tr.set-field=%0, %1, %2, %3; };

@@ Input:
@@ %0 - %#
@@ %1 - Group
@@ %2 - Label
@@ %3 - Value
&tr.set-field PS=@switch %3=, { @trigger me/tr.clear-field=%0, %1, %2, %3; }, { @set %0=[setr(I, ulocal(f.get-field-to-set, %0, ulocal(f.get-current-profile, %0), %1, %2))]-label:%2; @set %0=%qI-value:%3; @pemit %0=ulocal(layout.value-set, %0, %qP, %1, %2, %3); };

@@ Input:
@@ %0 - %#
@@ %1 - Group
@@ %2 - Label
@@ %3 - Value
&tr.clear-field PS=@set %0=[setr(I, ulocal(f.get-field-to-set, %0, ulocal(f.get-current-profile, %0), %1, %2))]-label:; @set %0=%qI-value:; @pemit %0=ulocal(layout.value-cleared, %0, %qP, %1, %2, %3);

@@ Input:
@@ %0 - %#
@@ %1 - Value
&tr.set-name PS=@set %0=p-[setr(P, ulocal(f.get-current-profile, %0))]-name:[if(t(%1), %1, name(%0))]; @set %0=icname:%1; @switch default(%0/profile-mode, Passive)=Active, { @name %0=%1; @pemit %0=ulocal(layout.switch-name, %0, %1); }; @pemit %0=ulocal(layout.value-set, %0, %qP, Basic Info, Name, %1);

@@ Input:
@@ %0 - %#
@@ %1 - Value
&tr.set-gender PS=@set %0=p-[setr(P, ulocal(f.get-current-profile, %0))]-gender:%1; @set %0=gender:%1; @switch default(%0/profile-mode, Passive)=Active, { @sex %0=%1; }; @pemit %0=ulocal(layout.value-set, %0, %qP, Basic Info, Gender, %1); @trigger me/tr.set-pronouns=%0, %1;

@@ Input:
@@ %0 - %#
@@ %1 - Value
&tr.set-pronouns PS=@switch/first/notify %1=m*, { @set %0=pronouns:he him his his Mr.; }, f*, { @set %0=pronouns:she her her hers Ms.; }, * * * * *, {@set %0=pronouns:%1; }, { @set %0=pronouns:they them their theirs Mx.; }; @wait me={ @set %0=p-[setr(P, ulocal(f.get-current-profile, %0))]-pronouns:[xget(%0, pronouns)]; @pemit %0=ulocal(layout.value-set, %0, %qP, Basic Info, Pronouns, %1); }

@@ Input:
@@ %0 - %#
&tr.set-default PS=@set %0=profile-default:[setr(P, ulocal(f.get-current-profile, %0))]; @pemit %0=ulocal(layout.setting-set, %0, Default, %qP);

@@ Input:
@@ %0 - %#
@@ %1 - Value
&tr.set-mode PS=@switch setr(E, strcat(setq(M, case(1, eq(strlen(%1), 0), Passive, strmatch(Active, %1*), Active, strmatch(Passive, %1*), Passive)), if(not(t(%qM)), Couldn't figure out what you meant by '%1'. Valid values are 'Active' and 'Passive'., if(and(match(%qM, Active), not(t(xget(%0, alias)))), You must have an alias before you can use Active mode. This is so people can still page you. Set your alias with @alias me=<alias> and then try again.))))=, { @set %0=profile-mode:%qM; @pemit %0=ulocal(layout.setting-set, %0, Mode, %qM); }, { @pemit %0=alert(Profile mode error) %qE; }

@@ Input:
@@ %0 - %#
@@ %1 - Value
&tr.set-noise PS=@switch setr(E, strcat(setq(M, case(1, eq(strlen(%1), 0), Quiet, strmatch(Loud, %1*), Loud, strmatch(Quiet, %1*), Quiet)), if(not(t(%qM)), Couldn't figure out what you meant by '%1'. Valid values are 'Loud' and 'Quiet'.)))=, { @set %0=profile-noise:%qM; @pemit %0=ulocal(layout.setting-set, %0, Noise, %qM); }, { @pemit %0=alert(Profile mode error) %qE; }

@@ Input:
@@ %0 - %#
@@ %1 - profile name
&tr.profile.switch PS=@switch setr(E, strcat(setq(L, ulocal(f.get-current-profile, %0)), setq(N, ulocal(f.find-profile-by-name, %0, %1)), if(not(t(%qN)), Couldn't find a profile name starting with '%1'. Check +profiles for your list of profiles.), if(eq(%qL, %qN), You are already on the profile '[icname(%0)]'.)))=, { @set %0=profile-last:%qL; @set %0=current-profile:%qN; @set %0=icname:[xget(%0, p-%qN-name)]; @set %0=gender:[xget(%0, p-%qN-gender)]; @set %0=pronouns:[xget(%0, p-%qN-pronouns)]; @switch setr(M, default(%0/profile-mode, Passive))=Active, { @name %0=[icname(%0)]; @set %0=sex:[gender(%0)]; @pemit %0=ulocal(layout.switch-name, %0, icname(%0)); }; @pemit %0=ulocal(layout.profile-set, %0, %qN, %qL); @switch default(%0/profile-noise, Quiet)=Loud, { @remit loc(%0)=ulocal(layout.profile-set-loud, %0, %qN, %qL); }; }, { @pemit %0=alert(Profile switcher) %qE; }

@@ Input:
@@ %0 - %#
@@ %1 - profile name
&tr.profile-create PS=@switch setr(E, strcat(if(not(t(%1)), You need to include a name for your new profile.)))=, { @set %0=profile-count:[setr(N, add(default(%0/profile-count, 1), 1))]; @set %0=p-%qN-name:%1; @pemit %0=alert(Profile) Profile created: %1; @trigger me/tr.profile.switch=%0, %1; }, { @pemit %0=alert(Profile) %qE; }

@@ Input:
@@ %0 - %#
@@ %1 - label
@@ %2 - target player (optional)
&tr.prove-field PS=@switch setr(E, strcat(setq(F, ulocal(f.get-field-by-label, %0, setr(C, ulocal(f.get-current-profile, %0)), %1)), setq(L, ulocal(f.find-best-label, %0, %1)), setq(V, ulocal(layout.value, xget(%0, %qF-value), v(d.group-value-format.[extract(%qF, 3, 1, -)]))), setq(P, if(t(%2), ulocal(f.get-player, %2), strcat(lcon(loc(%0), CONNECT), setq(T, the room)))), if(not(t(%qP)), Couldn't figure out who '%2' is.), if(not(t(%qF)), Couldn't find a field named '%1'.)))=, { @dolist/notify %qP={ @pemit ##=strcat(alert(Profile), %b, name(%0), %b, shows, %b, if(t(%qT), %qT, you), %b, pronouns(%0, poss), %b, %qL:, %b, %qV); }; @wait me=@switch/first %qT=, { @pemit %0=alert(Profile) You showed [itemize(iter(%qP, name(itext(0)),, |), |)] your %qL: %qV; } }, { @pemit %0=alert(Profile) %qE; }

@@ Input:
@@ %0 - %#
@@ %1 - profile name
&tr.confirm-nuke PS=@switch setr(E, strcat(setq(N, ulocal(f.find-profile-by-name, %0, %1)), if(not(t(%qN)), Couldn't figure out which profile you meant by '%1'.)))=, { @set %0=profile-nuke:%qN|[secs()]; @pemit %0=alert(Profile) Before you continue, make absolutely certain that [xget(%0, p-%qN-name)] is the profile you want to nuke. If you're absolutely certain you want to delete this profile, type +profile/nuke %1=YES; }, { @pemit %0=alert(Profile) %qE; }

&tr.nuke-profile PS=@switch strcat(setq(N, ulocal(f.find-profile-by-name, %0, %1)), setq(P, xget(%0, p-%qN-name)), or(not(strmatch(%qN, first(setr(W, xget(%0, profile-nuke)), |))), gt(sub(secs(), rest(%qW, |)), 300), not(match(%2, YES))))=1, { @trigger me/tr.confirm-nuke=%0, %1; }, { @switch setr(E, if(not(t(%qN)), Couldn't figure out which profile you meant by '%1'.))=, { @pemit %0=alert(Profile) Decompiling profile data so you can recreate it if this was a mistake...%R[iter(lattr(%0/p-%qN-*), &[itext(0)] %0=[xget(%0, itext(0))],, %R)]; @pemit %0=alert(Profile) Deleting data for %qP profile...; @wipe %0/p-%qN-*; @pemit %0=alert(Profile) Your profile for %qP has been nuked.; @switch ulocal(f.get-current-profile, %0)=%qN, { @trigger me/tr.profile.switch=%0; }; }, { @pemit %0=alert(Profile) %qE; }; }


@tel PF=PLaD

@tel PLaD=PS

