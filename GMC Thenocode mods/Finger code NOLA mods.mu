/*
================================================================================

Dependencies: Thenomain's isapproved() function; Layout functions (wheader, wfooter, wdivider)

================================================================================

On NOLA, we've already got custom and good-enough +who/+where/etc, but our +finger sucked. Because of the way Theno grouped the commands, replacing our +finger with straight-up drop-in copy of his code would've been a pain. Besides, we needed to make lots of modifications to ensure that players' existing +finger info showed up, and add our custom fields (of which there are a ton), so... I ported Theno's +finger code from here:

https://github.com/thenomain/Mu--Support-Systems/blob/master/Brand%20New%20Who%20Where/bnww%20-%2004%20-%20Finger.txt

And heavily modified it to fit with our setting and game. It is drop-in ready, but perhaps not as clean as most would like, especially the +finger/set command, which is from our old +finger object and has not been updated. Also, I can't imagine other games have the "Accorded" +finger status, so you might want to remove that.

Here's the help file:

+finger <name> - Pulls up information on the name inputted.

+finger/set field=text - Sets text in the selected field.

If you don't choose a pre-created field, the info will be set into your +finger with &finger-<field>. You can have 3 of these user-set fields on yourself at a time.

Available fields are as follows:

===IC information===

* Full name: whatever it is right now - if you don't set this, it'll take what's on your sheet.
* Apparent age: Roughly how old/young your character looks. Note this isn't AGE, but how they LOOK.
* Short-desc: The one that shows in the room description.
* Wiki: A link to your wiki page. This is a great thing to do, as names will eventually get reused.
* Accorded: Whether or not you are a signatory of the Accords.
* IC pronouns: The pronouns your character prefers to be addressed by. Will guess based on your @gender if not set.
* Shadowname: For mages.
* Occupation: Your IC job.
* Quote: A quote from your character.

===OOC information===

* Played by: The real life inspiration for your character's look.
* OOC pronouns: The pronouns you prefer to be addressed by. Will guess based on your @gender if not set.
* Timezone: Your timezone. Do keep in mind the game is set in New Orleans, Louisiana and as such, Central time is "home."
* Note: A brief note you want people to read about you/your character.
* RP prefs: Your preferences for RP.
* Position: Your position OOC. (Use Occupation for IC.)
* Song: A song/link to a song that describes your character.
* Alts: A list of characters you want to publicly announce are yours.

===Staff-only information===

* Email: An email address. Only viewable by staff.

================================================================================

Changelog:

2020-01-14: added coloration to staff view of people's alts cuz we have players with over a dozen and sorting the dead from the living was getting hard! This added the dependency of the "isapproved(##, status)" function.

2020-05-29: found a bunch of cool functions that give info about what kind of terminal a player has. Only works when they're connected, though - so I added an aconnect and started logging them.

2020-07-26: I got sick of alts code mis-detecting people. It was going by the first two IP sections. That... doesn't work. First /three/ sections is at least sane. Exact match would be better. So, switched that code call to check the first three sections.

While I was at it, I converted the code to be easily edited after it's already been made live. (All that [v(d.fto)] stuff.)

Then I decided to put the _player-info tag I'd been building up data on into practice, and wrote a piece of code called Exact Alts. That allows staff to see who's logged into which bits. It picks out people living in the same house as two different folks pretty well (unless they both use the same clients and screen size), but also includes historical info (so will catch folks logging in from the same web-client as the same person). There's merit to both so for now I'm leaving them both in. Will see how the data works out in practice before I decide to remove one or the other.

Then... why not keep the "far match" option... but down-grade it. So that's more IP info. What's interesting is, if a name appears on all three lists, it's a high degree of confidence.

2020-08-12: Moved extra alts info into +finger/alts and expanded it a bit. Still working out how to format it.

*/

think Entering data.

@create Finger Thing Object <FTO>=10

@force me=&d.fto me=[num(Finger Thing Object <FTO>)]

@set [v(d.fto)]=INHERIT SAFE

&c.finger [v(d.fto)]=$^\+?finger(.*)$:think strcat(p:, setr(p, if(t(%1), pmatch(switch(trim(%1), /al*, rest(%1), me, %#, trim(%1))), %#))); @assert not(strmatch(%1, /set*))={}; @assert t(%qP)={@pemit %#=u(.msg, finger, Target not found)}; @assert hastype(%qp, PLAYER)={@pemit %#=u(.msg, finger, Target not found)}; @pemit %#=strcat(wheader(u(display.finger.header, %qp)), %r, u(display.finger.ic, %qp), %r, wdivider(OOC info), %r, u(display.finger.ooc, %qp), %r, if(setr(x, u(display.finger.user, %qp)), strcat(wdivider(Extra info), %r, %qx, %r)), if(isstaff(%#), strcat(wdivider(Staff-only info), %r, u(display.finger.staff, %qp), %r, if(strmatch(%1, /alt*), strcat(wdivider(Staff-only alts info), %r, u(display.finger.staff_alts, %qp), %r)))), wfooter(u(display.finger.footer, %qp)));

@set FTO/c.finger=regex

&C.+FINGER/SET [v(d.fto)]=$+finger/set *=*:@pemit %#=[switch(%0, *position*, Set. [set(%#, position:%1)], *song*, Set. [set(%#, finger-song:%1)], *full*name*, Set. [set(%#, finger-fullname:%1)], *short*desc*, Set. [set(%#, short-desc:%1)], *note*, Set. [set(%#, finger-note:%1)], *quote*, Set. [set(%#, finger-quote:%1)], *email*, Set. [set(%#, _finger-email:%1)], *wiki*, Set. [set(%#, finger-wiki:%1)], *played*by*, Set. [set(%#, finger-playedby:%1)], *alts*, Set.[set(%#, finger-alts:%1)], *rp*pref*, Set. [set(%#, rp-prefs:%1)], *time*zone*, Set. [set(%#, finger-timezone:%1)], *shadowname*, Set. [set(%#, finger-shadowname:%1)], *apparent*age*, Set. [set(%#, finger-apparentage:%1)], *occupation*, Set.[set(%#, finger-occupation:%1)], *accord*, Set. [set(%#, finger-accorded:%1)], *ic*pron*, Set. [set(%#, finger-ic_pronouns:%1)], *ooc*pron*, Set. [set(%#, finger-ooc_pronouns:%1)], Setting a non-default +finger field - you can only have [v(d.finger-max-fields)] of these on your +finger at once. [setr(T, set(%#, finger-[edit(%0, %b, _)]:%1))])]

&.remove_elements [v(d.fto)]=ldelete(%0, iter(%1, matchall(%0, %i0, %2), %2), %2, %2)

&.msg [v(d.fto)]=alert(%0) %1

&d.finger.max-fields [v(d.fto)]=3

&d.finger.section.ic [v(d.fto)]=full_name apparent_age short-desc wiki accorded ic_pronouns shadowname occupation quote

&d.finger.section.ooc [v(d.fto)]=played_by location last_connected ooc_pronouns timezone note rp_preferences position song public_alts badges

&d.finger.section.staff [v(d.fto)]=template last_ip terminfo template_alts email mail connection_time

&d.finger.section.staff_alts [v(d.fto)]=exact_alts near_alts far_alts interface_alts 

&format.finger.one-section [v(d.fto)]=edit(trim(squish(iter(%1, strcat(setq(0, udefault(finger.%i0, get(%0/finger-%i0), %0)), if(t(%q0), strcat(u(format.finger.title, %i0), %b, wrap(%q0, 51, left,,, 20)))),, |), |), b, |), |, %r)

&format.finger.title [v(d.fto)]=strcat(space(2), ljust(ansi(h, [titlestr(edit(%0, _, %b))]:), 17))

&display.finger.header [v(d.fto)]=strcat(u(finger.name, %0), if(isstaff(%#), %b%(%0%)), if(strlen(setr(a, u(finger.alias, %0))), %b%[%qa%]))

&display.finger.footer [v(d.fto)]=strcat(%[, u(finger.approval, %0), %])

&display.finger.ic [v(d.fto)]=u(format.finger.one-section, %0, u(d.finger.section.ic))

&display.finger.ooc [v(d.fto)]=u(format.finger.one-section, %0, u(d.finger.section.ooc))

&display.finger.user [v(d.fto)]=u(format.finger.one-section, %0, u(f.finger.get-user-fields, %0))

&display.finger.staff [v(d.fto)]=u(format.finger.one-section, %0, u(d.finger.section.staff))

&display.finger.staff_alts [v(d.fto)]=u(format.finger.one-section, %0, u(d.finger.section.staff_alts))

&f.finger.get-user-fields [v(d.fto)]=extract(u(.remove_elements, lcstr(edit(lattr(%0/finger-*), FINGER-,)), iter(lattr(%!/d.finger.section.*), lcstr(v(%i0))) apparentage playedby rp-prefs fullname), 1, v(d.finger.max-fields))

&finger.name [v(d.fto)]=moniker(%0)

&finger.alias [v(d.fto)]=get(%0/alias)

&finger.approval [v(d.fto)]=isapproved(%0, status)

&finger.location [v(d.fto)]=strcat(if(t(setr(l, objeval(%#, loc(%0)))), strcat(name(%ql), if(hasattr(%ql, coord), strcat(%b, %[, get(%ql/coord), %]))), ansi(xh, <unknown>)))

&finger.wiki [v(d.fto)]=default(%0/finger-wiki, ansi(xh, %(use '+finger/set wiki=<url>' to set this.%)))

&finger.accorded [v(d.fto)]=get(%0/finger-accorded)

&finger.apparent_age [v(d.fto)]=get(%0/finger-apparentage)

&finger.played_by [v(d.fto)]=get(%0/finger-playedby)

&finger.short-desc [v(d.fto)]=get(%0/short-desc)

&finger.timezone [v(d.fto)]=get(%0/finger-timezone)

&finger.email [v(d.fto)]=default(%0/_finger-email, Not set.)

&finger.mail [v(d.fto)]=strcat(setq(M, mail(%0)), extract(%qM, 2, 1) unread out of, %b, ladd(%qM), %b, messages.)

&finger.note [v(d.fto)]=u(%0/finger-note)

&finger.rp_preferences [v(d.fto)]=get(%0/rp-prefs)

&finger.shadowname [v(d.fto)]=get(%0/finger-shadowname)

&finger.occupation [v(d.fto)]=get(%0/finger-occupation)

&finger.position [v(d.fto)]=default(%0/position, get(%0/finger-position))

&finger.song [v(d.fto)]=get(%0/finger-song)

&finger.public_alts [v(d.fto)]=get(%0/finger-alts)

&finger.connection_time [v(d.fto)]=This player was connected for [first(exptime(connlast(%0)))] the last time they logged in.

&finger.ic_pronouns [v(d.fto)]=default(%0/finger-ic_pronouns, switch(xget(%0, sex), M*, he/him, F*, she/her, they/them))

&finger.ooc_pronouns [v(d.fto)]=xget(%0, finger-ooc_pronouns)

&finger.template [v(d.fto)]=getstat(%0/template)

&finger.terminfo [v(d.fto)]=if(t(setr(0, first(xget(%0, _player-info), |))), strcat(first(%q0, -)%,, %b, extract(%q0, 3, 1, -), x, extract(%q0, 2, 1, -) screen%,%b, extract(%q0, 4, 1, -) colors), No terminal info found.)

&finger.last_connected [v(d.fto)]=if(hasflag(%0, connected), strcat(Connected, %b%(, secs2hrs(idle(%0)), %b, idle%)), strcat(setr(c, get(%0/last)), %b, %(, first(exptime(sub(secs(), convtime(%qc)))), %)))

&finger.last_ip [v(d.fto)]=strcat(setr(0, get(%0/lastip)), if(and(not(strmatch(%q0, setr(1, extract(first(xget(%0, _player-info), |), 5, 100, -)))), t(%q1)), strcat(%,%b, %q1)))

&finger.near_alts [v(d.fto)]=iter(search(eplayer=strmatch(get(##/lastip), extract(get(%0/lastip), 1, 3, .).*), 2), switch(isapproved(%i0, status), chargen, ansi(g, name(%i0)), guest, ansi(gh, name(%i0)), unapproved, ansi(xh, name(%i0)), frozen, ansi(xh, name(%i0)), moniker(%i0)),, %,%b)

&finger.exact_alts [v(d.fto)]=iter(search(eplayer=cand(hasattr(%0, _player-info), hasattr(##, _player-info), t(setinter(xget(%0, _player-info), xget(##, _player-info), |))), 2), switch(isapproved(%i0, status), chargen, ansi(g, name(%i0)), guest, ansi(gh, name(%i0)), unapproved, ansi(xh, name(%i0)), frozen, ansi(xh, name(%i0)), moniker(%i0)),, %,%b)

&finger.far_alts [v(d.fto)]=iter(search(eplayer=strmatch(get(##/lastip), extract(get(%0/lastip), 1, 2, .).*), 2), switch(isapproved(%i0, status), chargen, ansi(g, name(%i0)), guest, ansi(gh, name(%i0)), unapproved, ansi(xh, name(%i0)), frozen, ansi(xh, name(%i0)), moniker(%i0)),, %,%b)

&finger.interface_alts [v(d.fto)]=iter(search(eplayer=cand(strmatch(get(##/lastip), extract(get(%0/lastip), 1, 2, .).*), hasattr(%0, _player-info), hasattr(##, _player-info), t(setinter(iter(xget(%0, _player-info), extract(itext(0), 1, 3, -), |, |), iter(xget(##, _player-info), extract(itext(0), 1, 3, -), |, |), |))), 2), switch(isapproved(%i0, status), chargen, ansi(g, name(%i0)), guest, ansi(gh, name(%i0)), unapproved, ansi(xh, name(%i0)), frozen, ansi(xh, name(%i0)), moniker(%i0)),, %,%b)

&finger.template_alts [v(d.fto)]=iter(search(eplayer=cand(hasattr(%0, _player-info), hasattr(##, _player-info), t(setinter(xget(%0, _player-info), xget(##, _player-info), |))), 2), u(display.player-name, itext(0)),, %,%b)

&display.player-name [v(d.fto)]=strcat(switch(setr(0, isapproved(%0, status)), approved, moniker(%0), chargen, ansi(g, name(%0)), ansi(xh, name(%0))), %b, %(, ansi(if(switch(%q0, chargen, 1, approved, 1, 0), switch(default(%0/_bio.template, Unset), Vampire, r, Ghoul, hr, Werewolf, y, Wolf-blooded, hy, Changeling, b, Fae-touched, hb, Atariya, c, Infected, hg, Plain, g, Lost Boy, hc, Psychic Vampire, m)), default(%0/_bio.template, Unset)), %))

&finger.badges [v(d.fto)]=itemize(iter(lattr(%0/_badge-*), titlestr(edit(delete(itext(%i0), 0, 7), _, %b)),, %,), %,)

&finger.full_name [v(d.fto)]=default(%0/finger-fullname, if(setr(t, getstat(%0/full_name)), %qt, ansi(xh, <not set on sheet>)))

&layout.player-info [v(d.fto)]=strcat(terminfo(%0), -, height(%0), -, width(%0), -, colordepth(%0), -, host(%0))

&tr.player-info [v(d.fto)]=@set %0=_player-info:[setr(0, ulocal(layout.player-info, %0))]|[remove(xget(%0, _player-info), %q0, |, |)];

@aconnect [v(d.fto)]=@trigger me/tr.player-info=%#;

think Entry complete.
