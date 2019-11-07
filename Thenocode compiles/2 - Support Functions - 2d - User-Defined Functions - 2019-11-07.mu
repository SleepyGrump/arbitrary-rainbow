/*

https://github.com/thenomain/GMCCG/blob/master/2%20-%20Support%20Functions/2d%20-%20User-Defined%20Functions.txt

Compiled 2019-11-07

*/

think Entering 32 lines.

@startup [v(d.sfp)]=@dolist lattr(%!/ufunc.*)=@function/preserve [rest(##, .)]=%!/##; @dolist lattr(%!/ufunc/privileged.*)=@function/preserve/privileged [rest(##, .)]=%!/##

@fo me=&ufunc/privileged.statpath [v(d.sfp)]=u\%( [num(sfp)]/f.statpath, \\\%0 \%)

&f.statpath [v(d.sfp)]=[setq(s,)][setq(p,)][setq(s, if(t(setr(s, rest(%0, /))), %qs[setq(p, before(%0, /))], %0))][case(0, isstaff(%@), #-1 STAFF ONLY, comp(%qs,), #-1 NEED STAT TO LOOK UP, ulocal(f.statpath.workhorse, %qs, %qp))]

&f.statpath.workhorse [v(d.sfp)]=strcat(setq(p, if(strlen(%1), u(f.find-sheet, u(.pmatch, %1)))), if(setr(s, ulocal(f.statpath-lookup-sheet, %qp, %0)), %qs, ulocal(f.statpath-lookup-dd, %0)))

@fo me=&ufunc/privileged.statname [v(d.sfp)]=u\%( [num(sfp)]/f.statname, \\\%0 \%)

&f.statname [v(d.sfp)]=if(t(setr(r, u(f.statpath, %0))), u(f.statname.workhorse, rest(%qr, .)), %qr)

&f.statname.workhorse [v(d.sfp)]=iter(edit(%0, _, %b), titlestr(%i0), ., .)

@fo me=&ufunc/privileged.getstat [v(d.sfp)]=u\%( [search(name=Stat Functions Prototype <sfp>)]/f.getstat, \\\%0 , \\\%1 \%)

&f.getstat [v(d.sfp)]=strcat(setq(p, u(.pmatch, before(before(%0, /), :))), setq(x, edit(trim(after(before(%0, /), :)), %b, _)), setq(s, rest(%0, /)), case(0, isstaff(%@), #-1 PERMISSION DENIED, t(%qp), #-1 PLAYER NOT FOUND, t(setr(d, u(f.find-sheet, %qp))), #-1 SHEET NOT FOUND, t(%qs), #-1 STAT MUST BE PROVIDED, u(f.getstat.workhorse, %qp[if(t(%qx), :%qx)], %qs, %qd, %1)))

&f.getstat.workhorse [v(d.sfp)]=strcat(setq(p, first(%0, :)), setq(x, rest(%0, :)), setq(s, ulocal(f.statpath.workhorse, %1, %qp)), setq(c, ulocal(f.get-class, %qs)), setq(a, if(t(%qx), %qx!%qs, %qs)), setq(d, u(%2/_%qa)), if(t(%qs), case(%qc, flag, ulocal(f.getstat.workhorse.flag, %qp, _%qa), string, ulocal(f.getstat.workhorse.string, %qp, _%qa), list, %qd, numeric, strcat(setq(d, ulocal(f.getstat.workhorse.numeric, %qp, _%qa)), switch(%3, p*, first(%qd, .), o*, rest(%qd, .), b*, %qd, t*, ladd(%qd, .), ladd(%qd, .))), %qd), %qs))

&f.getstat.workhorse.numeric [v(d.sfp)]=localize(strcat(setq(s, first(%1, !)), setq(x, rest(%!, !)), setq(i, crumple(before(rest(%qs, %(), %)))), setq(s, u(f.statpath-without-instance, trim(%qs, b, _))), iter(get(%0/%1), if(strmatch(%i0, derived), ulocal(u(d.data-dictionary)/%qs, %0, %qi), %i0), ., .)))

&f.getstat.workhorse.string [v(d.sfp)]=localize(strcat(setq(s, first(%1, !)), setq(x, rest(%!, !)), setq(i, crumple(before(rest(%qs, %(), %)))), setq(s, u(f.statpath-without-instance, trim(%qs, b, _))), if(strmatch(get(%0/%1), derived), ulocal([u(d.data-dictionary)]/%qs, %0, %qi), get(%0/%1))))

&f.getstat.workhorse.flag [v(d.sfp)]=localize(strcat(setq(s, first(%1, !)), setq(x, rest(%!, !)), setq(i, crumple(before(rest(%qs, %(), %)))), setq(s, u(f.statpath-without-instance, trim(%qs, b, _))), if(strmatch(get(%0/%1), derived), ulocal([u(d.data-dictionary)]/%qs, %0, %qi), hasattr(%0, %1))))

@fo me=&ufunc/privileged.hastag? [v(d.sfp)]=u\%( [num(sfp)]/f.hastag?, \\\%0, \\\%1, \\\%2 \%)

&f.hastag? [v(d.sfp)]=[setq(s, u(f.statpath.workhorse, %0))][if(t(%qs), u(f.hastag?.workhorse, u(f.statpath-without-instance, %qs), %1, strmatch(%2, a*)), 0)]

&f.hastag?.workhorse [v(d.sfp)]=[setq(t, lcstr(u(v(d.data-tags)/tags.%0)))][setq(b, iter(%1, if(strmatch(%i0, !*), not(match(%qt, rest(%i0, !), .)), match(%qt, %i0, .)), .))][if(%2, land(%qb), lor(%qb))]

@fo me=&ufunc/privileged.statvalidate [v(d.sfp)]=u\%( [num(sfp)]/f.statvalidate, \\\%0, \\\%1 \%)

&f.statvalidate [v(d.sfp)]=[setq(s, u(f.statpath-without-instance, u(f.statpath.workhorse, %0)))][switch(0, 1[null(<is staff>)], #-1 STAFF ONLY, t(%qs), %qs, u(f.statvalidate.workhorse, %qs, %1))]

&f.statvalidate.workhorse [v(d.sfp)]=localize(switch(0, u(f.statvalue-good, %1), #-1 VALUE CONTAINS ILLEGAL FORMAT, comp(lcstr(%1), default), strcat(setq(v, get(u(d.data-dictionary)/default.%0)), if(t(%qv), %qv, null(default of <null> will clear stat))), strcat(setq(s, first(get(u(d.data-dictionary)/%0), |)), setq(c, ulocal(f.get-class, %0)), setq(v, case(%qc, flag, if(strmatch(%1,), null(<null>), %qs), list, strcat(setq(e, edit(%1, %b, .)), setq(x, iter(graball(%qe, !*, ., .), ![grab(.%qs, [rest(%i0, !)]*, .)], ., .)), setq(a, iter(setdiff(%qe, %qx, .), grab(.%qs, %i0*, .), ., .)), trim(squish(%qa.%qx, .), b, .)), grab(%qs, %1*, .))), case(%qs, *, %1, #, if(cand(gte(%1, 1), isint(%1)), %1, #-1 VALUE NOT A POSITIVE INTEGER), switch(0, comp(%1,), #-1 VALUE WAS NULL, lt(words(%0, .), 3), %1, strlen(%qv), #-1 VALUE NOT FOUND, %qv)))))

@fo me=&ufunc/privileged.statvalidate? [v(d.sfp)]=u\%( [num(sfp)]/f.statvalidate?, \\\%0, \\\%1 \%)

&f.statvalidate? [v(d.sfp)]=t(ulocal(f.statvalidate, %0, %1))

@fo me=&ufunc/privileged.setstat [v(d.sfp)]=u\%( [num(sfp)]/f.setstat, \\\%0, \\\%1, \\\%2 \%)

&f.setstat [v(d.sfp)]=if(isstaff(%@), strcat(setq(p, u(.pmatch, first(first(%0, /), :))), setq(w, u(f.find-sheet, %qp)), setq(s, if(setr(s, ulocal(f.statpath.workhorse, rest(%0, /), %qp)), %qs, ulocal(f.statpath.workhorse, rest(%0, /)))), setq(i, ulocal(f.statpath-without-instance, %qs)), setq(x, edit(trim(rest(first(%0, /), :)), %b, _)), setq(x, case(0, not(strmatch(%qx,)), null(self), not(strmatch(%qx, #MAIN#)), null(self), valid(attrname, %qx), #-1 Sub-Sheet Name Illegal, not(strmatch(%qx, *!*)), #-1 Sub-Sheet Name Cannot Have ! In It, %qx)), setq(v, switch(%2, ov*, %1, of*, if(or(isnum(%1), not(comp(%1,))), %1, #-1 Non-Numeric Offset), case(%1, default, ulocal(u(d.data-dictionary)/default.%qi, %qw), null(null),, ulocal(f.statvalidate.workhorse, %qi, %1)))), setq(r, case(0, not(strmatch(%2, ov*)), 1, cor(setr(r, u(f.prereq-check-template, %qw, %qi)), strmatch(%qv,)), %qr, not(strmatch(%2, of*)), 1, t(setr(r, u(f.prereq-check-other, %qw, %qi, before(rest(%qs, %(), %)), if(u(f.isclass?, %qs, numeric), sub(%qv, first(u(%qw/_%qs), .)), %qv)))), %qr, 1)), switch(0, t(%qp), #-1 Player Not Found, not(strmatch(%qx, #-*)), %qx, or(t(get(%qw/_bio.template)), strmatch(%2, ov*)), #-1 Sheet Template Not Found, comp(rest(%0, /),), #-1 Stat Name May Not Be Null, t(%qs), %qs, not(strmatch(%qv, #-*)), %qv, t(%qr), %qr, u(f.setstat.workhorse, %qw[if(t(%qx), :%qx)], edit(%qs, %b, _), %qv, %2))), #-1 Not Staff)

&f.setstat.workhorse [v(d.sfp)]=strcat(setq(v,), setq(p, first(%0, :)), setq(x, rest(%0, :)), setq(c, ulocal(f.get-class, %1)), if(cand(strmatch(%qc, list), strmatch(%1, *.*.*)), setq(s, extract(%1, 1, 2, .)), setq(s, %1)), if(t(%qx), setq(s, %qx!%qs)), setq(d, get(%qp/_%qs)), setq(f, first(%qd, .)), setq(r, rest(%qd, .)), setq(m, case(1, strmatch(%3, of*), case(0, strmatch(%qc, numeric), #-1 CANNOT OFFSET NON-NUMERIC STAT, cand(comp(%2,), neq(%2, 0)), set(%qp, _%qs:%qf), comp(%qf,), set(%qp, _%qs:0.%2), set(%qp, _%qs:%qf.%2)), strmatch(%3, ov*), set(%qp, _%qs:%2), not(comp(%2,)), set(%qp, _%qs:), strmatch(%qc, numeric), set(%qp, _%qs:%2[if(%qr, .%qr)]), strmatch(%qc, list), [setq(v, edit(%2, %b, .))][setq(u, graball(%qv, !*, ., .))][setq(a, setdiff(%qv, %qu, .))][setq(u, edit(%qu, !,))][setq(v, setunion(setdiff(%qd, %qu, .), %qa, .))][set(%qp, _%qs:%qv)], set(%qp, _%qs:%2))), case(1, comp(%qm,), %qm, t(strlen(setr(v, if(strlen(%qv), %qv, %2)))), strcat(Set, %b, ulocal(f.statname.workhorse, rest(%qs, .)), if(strmatch(%3, of*), %boffset), if(not(strmatch(%qc, flag)), %bto '%qv'), .), strcat(Unset, %b, ulocal(f.statname.workhorse, rest(%qs, .)), if(strmatch(%3, of*), %boffset), .)))

@fo me=&ufunc/privileged.shiftstat [v(d.sfp)]=u\%( [num(sfp)]/f.shiftstat, \\\%0, \\\%1, \\\%2 \%)

&f.shiftstat [v(d.sfp)]=strcat(setq(p, u(.pmatch, first(first(%0, /), :))), setq(w, u(f.find-sheet, %qp)), setq(x, edit(trim(rest(first(%0, /), :)), %b, _)), setq(x, if(cor(strmatch(%qx,), valid(attrname, %qx), not(strmatch(%qx, !))), %qx, #-1 Sub-Sheet Name Illegal)), setq(s, if(setr(s, u(f.statpath.workhorse, rest(%0, /), %qp)), %qs, u(f.statpath.workhorse, rest(%0, /)))), setq(c, ulocal(f.get-class, %qs)), setq(v, if(cand(isnum(%1), neq(%1, 0)), trim(%1, l, +), #-1 SHIFT MUST BE NON-ZERO NUMERIC)), setq(r, case(0, not(strmatch(%2, ov*)), 1, t(setr(r, u(f.prereq-check-template, %qw, %qi))), %qr, t(setr(r, u(f.prereq-check-other, %qw, %qi, before(rest(%qs, %(), %)), %qv))), %qr, 1)), switch(0, isstaff(%@), #-1 Staff Only, t(%qp), #-1 Player Not Found, not(strmatch(%qx, #-*)), %qx, t(get(%qw/_bio.template)), #-1 Sheet Template Not Found, comp(rest(%0, /),), #-1 Stat Name May Not Be Null, t(%qs), %qs, strmatch(%qc, numeric), #-1 Stat Class Must Be Numeric, t(%qv), %qv, t(%qr), %qr, u(f.shiftstat.workhorse, %qw[if(t(%qx), :%qx)], %qs, %qv, %2)))

&f.shiftstat.workhorse [v(d.sfp)]=strcat(setq(p, first(%0, :)), setq(x, rest(%0, :)), setq(s, if(t(%qx), %qx!%1, %1)), setq(d, u(%qp/_%qs)), setq(f, first(%qd, .)), setq(r, rest(%qd, .)), setq(a, if(setr(a, add(%qf, %2)), %qa,)), setq(i, ulocal(f.statpath-without-instance, %1)), setq(c, ulocal(f.get-class, %1)), case(1, not(strmatch(%qc, numeric)), #-1 STAT CLASS MUST BE NUMERIC, strmatch(%3, ov*), ulocal(f.setstat.workhorse, %0, %1, %qa, ov), strmatch(%3, of*), ulocal(f.setstat.workhorse, %0, %1, add(%qr, %2), of), strmatch(%qf, derived), #-1 CANNOT SHIFT DERIVED STAT WITHOUT OVERRIDE, not(t(ulocal(f.statvalidate.workhorse, %qi, %qa))), #-1 SHIFT MAKES STAT INVALID, ulocal(f.setstat.workhorse, %0, %1, %qa)))

@fo me=&ufunc/privileged.getsheet [v(d.sfp)]=u\%( [num(sfp)]/f.getsheet, \\\%0, \\\%1 \%)

&f.getsheet [v(d.sfp)]=strcat(setq(f, first(%0, /)), setq(r, trim(rest(%0, /))), setq(p, u(.pmatch, %qf)), setq(w, u(f.find-sheet, %qp)), setq(s, if(strlen(%qr), ulocal(f.statpath.workhorse, %qr, %qp))), case(0, isstaff(%@), #-1 Staff Only, t(%qp), #-1 Player Not Found, t(%qw), #-1 Sheet Not Found, cor(not(strlen(%qr)), t(%qs)), #-1 Error From Statpath: [rest(%qs)], u(f.getsheet.workhorse, %qp, %qw, %qs, %1)))

&f.getsheet.workhorse [v(d.sfp)]=case(1, cand(strlen(%2), strlen(%3)), u(f.getsheet.workhorse.values, %0, %1, %2, %3), t(strlen(%2)), trim(strcat(if(words(lattr(%1/_%2)), #MAIN#), |, iter(sort(lattr(%1/_*!%2)), titlestr(edit(trim(first(%i0, !), _), _, %b)),, |)), b, |), trim(strcat(#MAIN#, |, iter(setunion(iter(filter(fil.sub-sheet.stat-path, lattr(%1/*!*)), first(%i0, !)),), titlestr(edit(first(%i0, !), _, %b)),, |)), b, |))

&f.getsheet.workhorse.values [v(d.sfp)]=trim(strcat(setq(s, rest(%2, .)), setq(m, lattr(%1/_%2)), setq(o, sort(lattr(%1/_*!%2))), setq(v, iter(%qo, ulocal(f.getstat.workhorse, %0:[first(rest(%i0, _), !)], %qs, %1, %3),, |)), if(t(%qm), strcat(#MAIN#, :, u(f.getstat.workhorse, %0, %qs, %1, %3))), |, iter(%qo, strcat(titlestr(edit(rest(first(%i0, !), _), _, %b)), :, elements(%qv, inum(), |)),, |)), b, |)

&fil.sub-sheet.stat-path [v(d.sfp)]=regmatch(%0, [^\.]*!.*)

think Entry complete.
