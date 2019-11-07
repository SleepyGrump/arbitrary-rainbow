/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/2%20-%20Support%20Functions/2c%20-%20Support%20Functions.txt

Compiled 2019-11-07

*/

think Entering 8 lines.

&f.list-stats-tags [v(d.sfp)]=filter(fil.list-stats-tags, rest(edit(lattr(%0/_%1.*), %b_, %b), _),,, %2, not(strmatch(%3, or)))

&fil.list-stats-tags [v(d.sfp)]=ulocal(f.hastag?.workhorse, ulocal(f.statpath-without-instance, %0), %1, %2)

&fil.list-stats-types [v(d.sfp)]=t(match(%1, first(%0, .)))

&fil.list-stats-values [v(d.sfp)]=setunion(get(u(d.data-dictionary)/[ulocal(f.statpath-without-instance, %0)]), %1, .)

&f.prereq-check-other [v(d.sfp)]=localize([setq(p, ulocal([u(d.data-dictionary)]/prerequisite.%1, %0, edit(%2, %b, _), %3))][case(0, comp(%qp,), 1, %qp, #-3 [u([u(d.data-dictionary)]/prereq-text.%1, %0, edit(%2, _, %b), %3)], 1)])

&f.prereq-check-cgen [v(d.sfp)]=if(cor(strmatch(loc(%0), u(d.chargen)), not(u(f.hastag?.workhorse, %1, chargen-only))), 1, #-3 Stat May Only Be Purchased At Character Generation)

&f.prereq-check-template [v(d.sfp)]=localize([setq(b, lcstr(u([u(d.data-dictionary)]/bio.template)))][setq(t, setinter(lcstr(u([u(d.data-tags)]/tags.%1)), %qb, .))][case(0, comp(%qt,), 1, comp(setinter(%qt, lcstr(u(%0/_bio.template)), .),), #-3 Stat Not Allowed For This Template, 1)])

&f.pretty-stat-num [v(d.sfp)]=localize(switch([setq(b, first(%0, .))][setq(o, rest(%0, .))]1, not(cand(isnum(%qb), cor(isnum(%qo), not(t(%qo))))), ansi(hw, %0), cand(t(%1), gte(%qo, 0)), ansi(w, repeat(o, %qb), g, repeat(*, %qo)), cand(t(%1), lt(%qo, 0)), ansi(w, repeat(o, add(%qb, %qo)), hx, repeat(., min(abs(%qo), %qb))), gt(%qo, 0), ansi(ng, add(%qb, %qo)), lt(%qo, 0), ansi(hy, add(%qb, %qo)), ansi(w, %0)))

think Entry complete.
