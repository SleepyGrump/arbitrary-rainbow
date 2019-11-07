/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/A%20-%20Bonus%20Sub-Systems/A2%20-%20WoD%20Init.txt

Compiled 2019-11-07

Had to remove a lot of duplicate code. Manually merged c.init/set since there were two different versions of it.

*/

think Entering 23 lines.

@create Initiative Tracker=10

@set Initiative Tracker=inherit

@set Initiative Tracker=safe

&d.flags init=new:n|surprised:s|delayed:d|turn delayed:D

&c.init init=$+init*:@pemit %#=[setq(0, secure(%0))][switch(%q0,, u(c.init-default), /*, u(c.init-switch, after(first(%q0), /), rest(%q0)), %b*, u(c.init-specific, trim(%q0)), Error: +init's format is +init%[/<switch>%]%[ <input>%])]

&c.init-switch init=ifelse(setr(0, grab(lattr(me/c.init/*), c.init/%0*)), u(%q0, %1), No such switch for +init. Valid switches are: [itemize(lcstr(iter(lattr(me/c.init/*), after(##, /))))])

&c.init-default init=[setq(l, loc(%#))][setq(i, lattr(%ql/_init.*))][setq(f, revwords(sort(iter(%qi, [first(get(%ql/%i0), |)]|%i0))))][setq(c, revwords(sort(setunion(iter(%qf, strtrunc(%i0, 2)),))))][header(Initiative Roster)]%r[if(t(%qi), [iter(%qc, [wrap([ansi(hg, [rjust(trim(%i0, l, 0), 2)]%))] [iter(setr(z, filter(fil.display.init-total, %qf,,, %i0)), ljust(ulocal(f.display.one-init-entry, rest(%i0, |), %ql, if(gt(words(%qz), 1), [inum()].%b)), 36))], 74, left, null(lefttxt), null(righttxt), 4, null(osep), 78)],, %r)], %b No initiatives at this location.)]%r[footer(if(t(%qi), [words(%qi)] initiatives))]

&fil.display.init-total init=strmatch(%0, %1*)

&f.display.one-init-entry init=localize([setq(d, extract(get(%1/%0), 2, 1, |))][setq(f, setdiff(extract(get(%1/%0), 3, 1, |), n))][setq(e, iter(%qf, first(grab(u(d.flags), *:%i0, |), :),, |))]%2[if(isdbref(setr(s, rest(%0, .))), [name(%qs)], [titlestr(edit(%qs, _, %b))][setq(e, npc|%qe)])][if(t(%qe), ansi(xh, %b%([iter(trim(%qe, b, |), %i0, |, %,%b)]%)))])

&c.init-specific init=u(c.init-default)

&c.init/clear init=switch(1, not(or(isapproved(%#), isstaff(%#))), [alert(Error, alert)] Must be approved to clear an initiative roster., not(or(isstaff(%#), not(comp(%0, YES)))), If you're sure you want to clear the roster%, type +init/clear YES[oemit(%#, [alert(+init, alert)] %N may be clearing initiatives at this location.)], [setq(l, loc(%#))][monitor(+init/clear: %N at [name(loc(%#))] %([loc(%#)]%))][iter(lattr(%ql/_init.*), set(%ql, %i0:),, @@)][remit(%ql, [alert(+init)] %N clears the initiative roster in this location.)])

&c.init/set init=[setq(s, trim(before(%0, =)))][setq(i, rpad(trim(rest(%qs, /)), 2, 0))][setq(s, ulocal(f.validate.init-subject, before(%qs, /), %#))][setq(t, rest(%0, =))][setq(n, iter(rest(%qt), rest(grab(u(d.flags), %i0*:*, |), :)))][setq(t, rpad(trim(first(%qt)), 2, 0))][setq(f, setunion(%qn [extract(rest(get(loc(%#)/_init.%qs), |), 3, 1, .)],))][case(1, not(%qs), [alert(Error, alert)] [rest(%qs)]., or(gt(%qt, 99), lt(%qt, 1)), [alert(Error, alert)] New initiative must be between 1 and 99., and(isdbref(%qs), isapproved(%qs)), [setq(i, rpad(getstat(%qs/initiative), 2, 0))][ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.0, %qf)][u(f.clean-dbref, %#)][remit(loc(%#), [alert(+init)] %N directly set %oself on the initiative roster at [mul(1, %qt)].)], not(isint(%qt)), [alert(Error, alert)] Initiative trait if entered must be numeric, not(isdbref(%qs)), [ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.0, %qf)][remit(loc(%#), [alert(+init)] %N directly set "[titlestr(%qs)]" on the initiative roster at [mul(1, %qt)].)], [alert(Error, alert)] Must be approved to set your own +init.)]

&f.validate.init-subject init=localize([setq(t, pmatch+(if(%0, %0, %1)))][case(1, strmatch(%qt, %1), %qt, not(valid(attrname, edit(%0, %b, _))), #-1 That's Not a Good Name, not(%qt), %0, #-1 Subject Must Be Self or Not a Player)])

&f.clean-dbref init=iter(setdiff(search(eroom=hasattr(##, _init.%0)), loc(%0)), set(%i0, _init.%0:))

&f.init.add.new init=[set(%1, _init.[edit(%0, %b, _)]:%2.[u(f.init.tiebreaker-roll)]|%3|[setunion(n %4,)])][null(ulocal(f.init.resolve-init-conflicts, %2, %1, u(f.init.conflict-list, %2, %1)))]

&f.init.tiebreaker-roll init=rjust(rand(1, 10), 2, 0)

&f.init.resolve-init-conflicts init=localize(if(t(%2), [iter(%2, set(%1, %i0:%0.[u(f.init.tiebreaker-roll)]|[rest(get(%1/%i0), |)]))][ulocal(f.init.resolve-init-conflicts, %0, %1, u(f.init.conflict-list, %0, %1))]))

&f.init.conflict-list init=localize([setq(l, filter(fil.matching-inits, lattr(%1/_init.*),,, %0, %1))][setq(f, setunion(iter(%ql, first(get(%1/%i0), |)),))][setq(c, iter(%qf, [setq(e, filter(fil.exact-inits, lattr(%1/_init.*),,, %i0, %1))][if(gt(words(%qe), 1), %qe)]))][squish(filter(fil.init-flag, %qc,,, %1, n))])

&fil.matching-inits init=strmatch(%1, first(get(%2/%0), .))

&fil.exact-inits init=strmatch(%1, first(get(%2/%0), |))

&fil.init-flag init=t(setinter(extract(get(%1/%0), 3, 1, |), %2))

&c.init/roll init=[setq(0, edit(%0, -, +-))][setq(s, before(%q0, +))][setq(i, rpad(trim(rest(%qs, /)), 2, 0))][setq(s, ulocal(f.validate.init-subject, before(%qs, /), %#))][setq(m, ladd(edit(edit(rest(%q0, +), +, %b), -%b, %b-)))][setq(r, rand(1, 10))][setq(f, extract(rest(get(loc(%#)/_init.%qs), |), 3, 1, .))][case(1, not(%qs), [alert(Error, alert)] [rest(%qs)], or(gt(%qm, 90), lt(%qm, -90)), [alert(Error, alert)] Modifier total must be between -90 and 90, and(isdbref(%qs), isapproved(%qs)), [setq(i, rpad(getstat(%qs/initiative), 2, 0))][if(lt(setr(h, u(%qs/_health.penalty)), 0), [setq(m, add(%qm, %qh))][setq(n, health penalty applied)])][setq(t, rjust(add(%qi, %qr, %qm), 2, 0))][ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.%qm, %qf)][u(f.clean-dbref, %#)][remit(loc(%#), [alert(+init)] %N rolled %qr[if(t(%qm), %b[operand(%qm)] [abs(%qm)])]%, putting %oself on the initiative roster at [mul(1, %qt)].[if(t(%qn), %b%(%qn%))])], not(isdbref(%qs)), [setq(t, rjust(add(%qi, %qr, %qm), 2, 0))][ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.%qm, %qf)][remit(loc(%#), [alert(+init)] %N rolled %qr[if(t(%qm), %b[operand(%qm)] [abs(%qm)])]%, putting "[titlestr(%qs)]" on the initiative roster at [mul(1, %qt)].)], [alert(Error, alert)] Must be approved to roll your own +init.)]

&c.init/remove init=[setq(s, ulocal(f.validate.init-subject, %0, %#))][setq(l, loc(%#))][case(0, comp(%0,), [alert(Error, alert)] Must enter name to remove., t(%qs), [alert(Error, alert)] [rest(%qs)]., hasattr(%ql, setr(a, _init.[edit(%qs, %b, _)])), [alert(Error, alert)] Subject has has no initiative to remove., not(and(isdbref(%qs), isapproved(%qs))), [set(%ql, %qa:)][remit(%ql, [alert(+init)] %N removes %oself from the initiative roster.)], isdbref(%qs), [set(%ql, %qa:)][remit(%ql, [alert(+init)] %N removes "%qs" from the initiative roster.)], [alert(Error, alert)] Must be approved to clear your own +init.)]

think Entry complete.
