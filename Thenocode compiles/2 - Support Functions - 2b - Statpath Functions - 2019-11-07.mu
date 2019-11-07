/*

https://github.com/thenomain/GMCCG/blob/master/2%20-%20Support%20Functions/2b%20-%20Statpath%20Functions.txt

Compiled 2019-11-07

*/

think Entering 12 lines.

&f.stat-list-selected [v(d.sfp)]=setunion(iter([u(d.search-order)] [v(d.type.specials)], lattr([u(d.data-dictionary)]/%i0.%0*)),)

&f.find-sheet [v(d.sfp)]=udefault(%0/_special.sheet_location, %0)

&f.stat-input-instance-is-null? [v(d.sfp)]=regmatch(%0, .*%%(%%))

&f.statvalue-good [v(d.sfp)]=not(strmatch(%0, *`*))

&f.stat-input-breakdown-registers [v(d.sfp)]=[setq(z, squish(edit(%0, %(, %b%(, %(%b, %(, %b%), %))))][setq(x, trim(before(before(%qz, .), %()))][setq(y, before(rest(before(%qz, .), %(), %)))][setq(z, rest(%qz, .))]

&f.statpath-validate-name [v(d.sfp)]=localize(strcat([setq(0, edit(first(%0, .), %b, _))][setq(0, if(regmatch(%q0, %(.*%)%%(%(.*%)%%), z a b), [trim(%qa, b, _)]_%(%), %q0))][setq(1, if(strmatch(%q0, *_%(%)), [before(%q0, _%()]*_%(%), %q0*))][setq(2, sortby(sortby.types, filter(filter.search-types, u(f.stat-list-selected, %q1))))][setq(4, if(t(setr(3, graball(%q2, *.%q0))), %q3, first(%q2)))][if(t(%q4), %q4, #-1 STAT NOT FOUND)]))

&f.statpath-lookup-dd [v(d.sfp)]=strcat(setq(0, edit(%0, _, %b)), u(f.stat-input-breakdown-registers, %q0), if(setr(n, u(f.statpath-validate-name, %q0)), strcat(setq(s, u(v(d.data-dictionary)/%qn)), setq(c, ulocal(f.get-class, %qn)), if(strmatch(%qn, *_%(%)), switch(1, match(%qy,), setq(n, #-2 INSTANCE NOT FOUND), strmatch(*, setr(1, elements(%qs, 2, |))), setq(n, strcat(before(%qn, _%(%)), _%(, edit(%qy, %b, _), %))), t(setr(0, grab(%q1, %qy*, .))), setq(n, strcat(before(%qn, _%(%)), _%(, edit(%q0, %b, _), %))), setq(n, #-2 INSTANCE NOT FOUND))), if(cand(t(%qz), t(%qn)), switch(1, setr(1, strmatch(*, setr(2, elements(%qs, add(2, t(regmatch(%qn, .*%%( .*%\)))), |)))), setq(n, %qn.[edit(%qz, %b, _)]), t(setr(0, grab(.%q2, %qz*, .))), setq(n, %qn.%q0), setq(n, #-2 SUBSTAT NOT FOUND))))), if(cand(t(%qn), strmatch(%qc, list)), extract(%qn, 1, 2, .), %qn))

&f.statpath-without-instance [v(d.sfp)]=localize(if(regmatchi(%0, %(.*%)%%(.*%%), z z), %qz%(%), %0))

&f.statpath-lookup-sheet [v(d.sfp)]=strcat(setq(0, edit(%1, _, %b)), u(f.stat-input-breakdown-registers, %q0), setq(y, edit(%qy, %b, _)), setq(t, u(f.find-sheet, first(%0, :))), setq(s, if(t(setr(s, rest(%0, :))), %qs!,)), if(setr(q, setr(n, u(f.statpath-validate-name, %q0))), strcat(setq(d, get(v(d.data-dictionary)/%qn)), setq(c, ulocal(f.get-class, %qn)), if(strmatch(%qn, *_%(%)), switch(1, match(%qy,), setq(n, #-2 INSTANCE NOT FOUND), t(setr(0, grab(extract(%qd, 2, 1, |), %qy*, .))), setq(n, [before(%qn, _%(%))]_%(%q0%)), t(setr(0, lattr(%qt/_%qs[before(%qn, _%(%))]_%(%qy*%)))), setq(n, rest(%q0, _)), setq(n, #-2 INSTANCE NOT FOUND))), if(cand(t(%qz), t(%qn)), switch(1, t(setr(0, grab(extract(%qd, add(2, t(%qy)), 1, |), %qz*, .))), setq(n, %qn.%q0), t(setr(0, u(f.statpath.lookup.substats.sheet, %qt, %qs%qn, %qz))), setq(n, %qn.%q0), setq(n, #-2 SUBSTAT(S) NOT FOUND))))), if(cand(t(%qn), strmatch(%qc, list)), extract(%qn, 1, 2, .), %qn))

&f.statpath.lookup.substats.sheet [v(d.sfp)]=localize(strcat(setq(0, lattr(%0/_%1.*)), setq(1, iter(u(.crumple, edit(%2, %b, _), .), u(.grabexact, %q0, _%1.%i0), ., .)), setq(2, u(.crumple, edit(%q1, _%1.,), .)), if(t(%q2), %q2, #-2 SUBSTAT(S) NOT FOUND)))

&f.get-class [v(d.sfp)]=udefault([u(d.data-dictionary)]/class.[setr(s, u(f.statpath-without-instance, extract(%0, 1, 2, .)))], udefault([u(d.data-dictionary)]/class.[setr(s, elements(%qs, 1, .))].?, numeric))

&f.isclass? [v(d.sfp)]=t(match(%1, ulocal(f.get-class, %0)))

think Entry complete.
