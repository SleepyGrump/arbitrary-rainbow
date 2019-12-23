/*

On NOLA, we've already got custom and good-enough +who/+where/etc, but our +finger sucked. Because of the way Theno grouped the commands, replacing +finger with straight-up drop-in code would've been a pain. Besides, we needed to make lots of modifications to ensure that players' existing +finger info showed up, and add our custom fields (of which there are a ton), so... I ported Theno's +finger code from here:

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


*/

think Entering 48 lines.

@create Finger Thing Object <FTO>=10

@set FTO=INHERIT SAFE

&c.finger FTO=$^\+?finger(.*)$:think strcat(p:, setr(p, if(t(%1), pmatch(switch(trim(%1), me, %#, trim(%1))), %#))); @assert not(strmatch(%1, /set*))={}; @assert t(%qP)={@pemit %#=}; @assert hastype(%qp, PLAYER)={@pemit %#=u(.msg, finger, Target not found)}; @pemit %#=strcat(wheader(u(display.finger.header, %qp)), %r, u(display.finger.ic, %qp), %r, wdivider(OOC info), %r, u(display.finger.ooc, %qp), %r, if(setr(x, u(display.finger.user, %qp)), strcat(wdivider(Extra info), %r, %qx, %r)), if(isstaff(%#), strcat(wdivider(Staff-only info), %r, u(display.finger.staff, %qp), %r)), wfooter(u(display.finger.footer, %qp)));

@set FTO/c.finger=regex

&C.+FINGER/SET FTO=$+finger/set *=*:@pemit %#=[switch(%0, *position*, Set. [set(%#, position:%1)], *song*, Set. [set(%#, finger-song:%1)], *full*name*, Set. [set(%#, finger-fullname:%1)], *short*desc*, Set. [set(%#, short-desc:%1)], *note*, Set. [set(%#, finger-note:%1)], *quote*, Set. [set(%#, finger-quote:%1)], *email*, Set. [set(%#, _finger-email:%1)], *wiki*, Set. [set(%#, finger-wiki:%1)], *played*by*, Set. [set(%#, finger-playedby:%1)], *alts*, Set.[set(%#, finger-alts:%1)], *rp*pref*, Set. [set(%#, rp-prefs:%1)], *time*zone*, Set. [set(%#, finger-timezone:%1)], *shadowname*, Set. [set(%#, finger-shadowname:%1)], *apparent*age*, Set. [set(%#, finger-apparentage:%1)], *occupation*, Set.[set(%#, finger-occupation:%1)], *accord*, Set. [set(%#, finger-accorded:%1)], *ic*pron*, Set. [set(%#, finger-ic_pronouns:%1)], *ooc*pron*, Set. [set(%#, finger-ooc_pronouns:%1)], Setting a non-default +finger field - you can only have [v(d.finger-max-fields)] of these on your +finger at once. [setr(T, set(%#, finger-[edit(%0, %b, _)]:%1))])]

&.remove_elements FTO=ldelete(%0, iter(%1, matchall(%0, %i0, %2), %2), %2, %2)

&.msg FTO=alert(%0) %1

&d.finger.max-fields FTO=3

&d.finger.section.ic FTO=full_name apparent_age short-desc wiki accorded ic_pronouns shadowname occupation quote

&d.finger.section.ooc FTO=played_by location last_connected ooc_pronouns timezone note rp_preferences position song public_alts badges

&d.finger.section.staff FTO=template last_ip alts email mail connection_time

&format.finger.one-section FTO=edit(trim(squish(iter(%1, strcat(setq(0, udefault(finger.%i0, get(%0/finger-%i0), %0)), if(t(%q0), strcat(u(format.finger.title, %i0), %b, wrap(%q0, 51, left,,, 20)))),, |), |), b, |), |, %r)

&format.finger.title FTO=strcat(space(2), ljust(ansi(h, [titlestr(edit(%0, _, %b))]:), 17))

&display.finger.header FTO=strcat(u(finger.name, %0), if(isstaff(%#), %b%(%0%)), if(strlen(setr(a, u(finger.alias, %0))), %b%[%qa%]))

&display.finger.footer FTO=strcat(%[, u(finger.approval, %0), %])

&display.finger.ic FTO=u(format.finger.one-section, %0, u(d.finger.section.ic))

&display.finger.ooc FTO=u(format.finger.one-section, %0, u(d.finger.section.ooc))

&display.finger.user FTO=u(format.finger.one-section, %0, u(f.finger.get-user-fields, %0))

&display.finger.staff FTO=u(format.finger.one-section, %0, u(d.finger.section.staff))

&f.finger.get-user-fields FTO=extract(u(.remove_elements, lcstr(edit(lattr(%0/finger-*), FINGER-,)), iter(lattr(%!/d.finger.section.*), lcstr(v(%i0))) apparentage playedby rp-prefs fullname), 1, v(d.finger.max-fields))

&finger.name FTO=moniker(%0)

&finger.alias FTO=get(%0/alias)

&finger.approval FTO=isapproved(%0, status)

&finger.location FTO=strcat(if(t(setr(l, objeval(%#, loc(%0)))), strcat(name(%ql), if(hasattr(%ql, coord), strcat(%b, %[, get(%ql/coord), %]))), ansi(xh, <unknown>)))

&finger.wiki FTO=default(%0/finger-wiki, ansi(xh, %(use '+finger/set wiki=<url>' to set this.%)))

&finger.accorded FTO=get(%0/finger-accorded)

&finger.apparent_age FTO=get(%0/finger-apparentage)

&finger.played_by FTO=get(%0/finger-playedby)

&finger.short-desc FTO=get(%0/short-desc)

&finger.timezone FTO=get(%0/finger-timezone)

&finger.email FTO=default(%0/_finger-email, Not set.)

&finger.mail FTO=strcat(setq(M, mail(%0)), extract(%qM, 2, 1) unread out of, %b, first(%qM), %b, messages.)

&finger.note FTO=u(%0/finger-note)

&finger.rp_preferences FTO=get(%0/rp-prefs)

&finger.shadowname FTO=get(%0/finger-shadowname)

&finger.occupation FTO=get(%0/finger-occupation)

&finger.position FTO=default(%0/position, get(%0/finger-position))

&finger.song FTO=get(%0/finger-song)

&finger.public_alts FTO=get(%0/finger-alts)

&finger.connection_time FTO=This player was connected for [first(exptime(connlast(%0)))] the last time they logged in.

&finger.ic_pronouns FTO=default(%0/finger-ic_pronouns, switch(xget(%0, sex), M*, he/him, F*, she/her, they/them))

&finger.ooc_pronouns FTO=default(%0/finger-ooc_pronouns, switch(xget(%0, sex), M*, he/him, F*, she/her, they/them))

&finger.template FTO=getstat(%0/template)

&finger.last_connected FTO=if(hasflag(%0, connected), strcat(Connected, %b%(, secs2hrs(idle(%0)), %b, idle%)), strcat(setr(c, get(%0/last)), %b, %(, first(exptime(sub(secs(), convtime(%qc)))), %)))

&finger.last_ip FTO=get(%0/lastip)

&finger.alts FTO=iter(search(eplayer=strmatch(get(##/lastip), extract(get(%0/lastip), 1, 2, .).*), 2), moniker(%i0),, %,%b)

&finger.badges FTO=itemize(iter(lattr(%0/_badge-*), titlestr(edit(delete(itext(%i0), 0, 7), _, %b)),, %,), %,)

&finger.full_name FTO=default(%0/finger-fullname, if(setr(t, getstat(%0/full_name)), %qt, ansi(xh, <not set on sheet>)))

think Entry complete.
