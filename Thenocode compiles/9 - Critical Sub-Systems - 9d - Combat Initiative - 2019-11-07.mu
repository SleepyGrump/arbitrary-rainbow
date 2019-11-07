/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/9%20-%20Critical%20Sub-Systems/9d%20-%20Combat%20Initiative.txt

Compiled 2019-11-07

*/

think Entering 29 lines.

@create Initiative Tracker <it>=10

@fo me=&d.init me=[search(name=Initiative Tracker <it>)]

@set Initiative Tracker <it>=inherit safe

@fo me=@parent Initiative Tracker <it>=[v(d.codp)]

&d.flags [v(d.init)]=new:n|surprised:s|delayed:d|turn delayed:D

&.msg [v(d.init)]=ansi(h, <%0>, n, %b%1)

&.plural [v(d.init)]=plural(%0, %1, %2)

&.pmatch [v(d.init)]=if(strmatch(%0, me), %#, pmatch(%0))

&.operand [v(d.init)]=case(1, strmatch(%0, #-*), %0, strmatch(%0, -*), -, +)

&c.init [v(d.init)]=$^\+?init(.*)$:@pemit %#=switch(setr(0, secure(%1)),, u(c.init.default), /*, u(c.init.switch, after(first(%q0), /), rest(%q0)), %b*, u(c.init.specific, trim(%q0)), u(.msg, init, Format is: init%[/<switch>%]%[ <input>%]))

@set v(d.init)/c.init=regexp

&c.init.switch [v(d.init)]=ifelse(setr(0, grab(lattr(%!/c.init/*), c.init/%0*)), u(%q0, %1), u(.msg, init, No such switch. Valid switches are: [itemize(lcstr(iter(lattr(%!/c.init/*), after(%i0, /))))]))

&c.init.default [v(d.init)]=strcat(setq(l, loc(%#)), setq(i, lattr(%ql/_init.*)), setq(f, revwords(sort(iter(%qi, strcat(first(get(%ql/%i0), |), |, %i0))))), setq(c, revwords(sort(setunion(iter(%qf, strtrunc(%i0, 2)),)))), header(Initiative Roster), %r, if(t(%qi), iter(%qc, wrap(strcat(ansi(h, [rjust(trim(%i0, l, 0), 2)]%)), %b, iter(setr(z, filter(fil.display.init-total, %qf,,, %i0)), ljust(ulocal(f.display.one-init-entry, rest(%i0, |), %ql, if(gt(words(%qz), 1), [inum()].%b)), 36),, %r),), 74, left, null(lefttxt), null(righttxt), 4, null(osep), 78),, %r), %b No initiatives at this location.), %r, footer(if(t(%qi), u(.plural, words(%qi), initiative, initiatives))))

&fil.display.init-total [v(d.init)]=strmatch(%0, %1*)

&f.display.one-init-entry [v(d.init)]=localize(strcat(setq(d, extract(get(%1/%0), 2, 1, |)), setq(f, setdiff(extract(get(%1/%0), 3, 1, |), n)), setq(e, iter(%qf, first(grab(u(d.flags), *:%i0, |), :),, |)), %2, if(isdbref(setr(s, rest(%0, .))), name(%qs), strcat(setq(e, npc|%qe), titlestr(edit(%qs, _, %b)))), if(t(%qe), ansi(xh, %b%([iter(trim(%qe, b, |), %i0, |, %,%b)]%)))))

&c.init.specific [v(d.init)]=u(c.init.default)

&c.init/clear [v(d.init)]=switch(1, not(cor(isapproved(%#), isstaff(%#))), u(.msg, init/clear, Must be approved to clear an initiative roster), not(cor(isstaff(%#), not(comp(%0, YES)))), strcat(u(.msg, If you're sure you want to clear the roster%, type: init/clear YES), oemit(%#, u(.msg, init, %N may be clearing initiatives at this location))), strcat(setq(l, loc(%#)), iter(lattr(%ql/_init.*), set(%ql, %i0:),, @@), remit(%ql, u(.msg, init, %N clears the initiative roster in this location)),))

&c.init/set [v(d.init)]=strcat(setq(s, trim(before(%0, =))), setq(i, rpad(trim(rest(%qs, /)), 2, 0)), setq(s, ulocal(f.validate.init-subject, before(%qs, /), %#)), setq(t, rest(%0, =)), setq(n, iter(rest(%qt), rest(grab(u(d.flags), %i0*:*, |), :))), setq(t, rpad(trim(first(%qt)), 2, 0)), setq(f, setunion(cat(%qn, extract(rest(get(loc(%#)/_init.%qs), |), 3, 1, .)),)), case(1, not(%qs), u(.msg, init/set, rest(%qs)), cor(gt(%qt, 99), lt(%qt, 1)), u(.msg, init/set, New initiative must be between 1 and 99), cand(isdbref(%qs), isapproved(%qs)), strcat(setq(i, rpad(getstat(%qs/initiative), 2, 0)), ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.0, %qf), u(f.clean-dbref, %#), remit(loc(%#), u(.msg, init, %N directly set %oself on the initiative roster at [trim(%qt, l, 0)]))), not(isdbref(%qs)), strcat(ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.0, %qf), remit(loc(%#), u(.msg, init, %N directly set '[titlestr(%qs)]' on the initiative roster at [trim(%qt, l, 0)]))), u(.msg, init/set, Must be approved to set your own init)))

&f.validate.init-subject [v(d.init)]=localize(strcat(setq(t, u(.pmatch, if(%0, %0, %1))), case(1, strmatch(%qt, %1), %qt, not(valid(attrname, edit(%0, %b, _))), #-1 That's Not a Good Name, not(%qt), %0, #-1 Subject Must Be Self or Not a Player)))

&f.clean-dbref [v(d.init)]=iter(setdiff(search(eroom=hasattr(##, _init.%0)), loc(%0)), set(%i0, _init.%0:))

&f.init.add.new [v(d.init)]=strcat(set(%1, _init.[edit(%0, %b, _)]:%2.[u(f.init.tiebreaker-roll)]|%3|[setunion(n %4,)]), null(ulocal(f.init.resolve-init-conflicts, %2, %1, u(f.init.conflict-list, %2, %1))))

&f.init.tiebreaker-roll [v(d.init)]=rjust(rand(1, 10), 2, 0)

&f.init.resolve-init-conflicts [v(d.init)]=localize(if(t(%2), strcat(iter(%2, set(%1, %i0:%0.[u(f.init.tiebreaker-roll)]|[rest(get(%1/%i0), |)])), ulocal(f.init.resolve-init-conflicts, %0, %1, u(f.init.conflict-list, %0, %1)))))

&f.init.conflict-list [v(d.init)]=localize(strcat(setq(l, filter(fil.matching-inits, lattr(%1/_init.*),,, %0, %1)), setq(f, setunion(iter(%ql, first(get(%1/%i0), |)),)), setq(c, iter(%qf, [setq(e, filter(fil.exact-inits, lattr(%1/_init.*),,, %i0, %1))][if(gt(words(%qe), 1), %qe)])), squish(filter(fil.init-flag, %qc,,, %1, n)),))

&fil.matching-inits [v(d.init)]=strmatch(%1, first(get(%2/%0), .))

&fil.exact-inits [v(d.init)]=strmatch(%1, first(get(%2/%0), |))

&fil.init-flag [v(d.init)]=t(setinter(extract(get(%1/%0), 3, 1, |), %2))

&c.init/roll [v(d.init)]=strcat(setq(0, edit(%0, -, +-)), setq(s, before(%q0, +)), setq(i, rpad(trim(rest(%qs, /)), 2, 0)), setq(s, ulocal(f.validate.init-subject, before(%qs, /), %#)), setq(m, ladd(edit(edit(rest(%q0, +), +, %b), -%b, %b-))), setq(r, rand(1, 10)), setq(f, extract(rest(get(loc(%#)/_init.%qs), |), 3, 1, .)), case(1, not(%qs), u(.msg, init/roll, rest(%qs)), or(gt(%qm, 90), lt(%qm, -90)), u(.msg, init/roll, Modifier total must be between -90 and 90), cand(isdbref(%qs), isapproved(%qs)), strcat(setq(i, rpad(getstat(%qs/initiative), 2, 0)), if(lt(setr(h, u(%qs/_health.penalty)), 0), [setq(m, add(%qm, %qh))][setq(n, health penalty applied)]), setq(t, rjust(add(%qi, %qr, %qm), 2, 0)), ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.%qm, %qf), u(f.clean-dbref, %#), remit(loc(%#), u(.msg, init, %N rolled %qr[if(t(%qm), %b[u(.operand, %qm)] [abs(%qm)])]%, putting %oself on the initiative roster at [trim(%qt, l, 0)][if(t(%qn), %b%(%qn%))]))), not(isdbref(%qs)), strcat(setq(t, rjust(add(%qi, %qr, %qm), 2, 0)), ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.%qm, %qf), remit(loc(%#), u(.msg, init, %N rolled %qr[if(t(%qm), %b[u(.operand, %qm)] [abs(%qm)])]%, putting '[titlestr(%qs)]' on the initiative roster at [trim(%qt, l, 0)]))), u(.msg, init/roll, Must be approved to roll your own init)),)

&c.init/remove [v(d.init)]=strcat(setq(s, ulocal(f.validate.init-subject, %0, %#)), setq(l, loc(%#)), case(0, comp(%0,), u(.msg, init/remove, Must enter name to remove), t(%qs), u(.msg, init/remove, rest(%qs)), hasattr(%ql, setr(a, _init.[edit(%qs, %b, _)])), u(.msg, init/remove, Subject has has no initiative to remove), not(and(isdbref(%qs), isapproved(%qs))), strcat(set(%ql, %qa:), remit(%ql, u(.msg, init/remove, %N removes %oself from the initiative roster))), isdbref(%qs), strcat(set(%ql, %qa:), remit(%ql, u(.msg, init, %N removes '%qs' from the initiative roster))), u(.msg, init/remove, Must be approved to clear your own init),))

think Entry complete.
