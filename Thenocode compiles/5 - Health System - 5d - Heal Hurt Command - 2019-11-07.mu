/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/5%20-%20Health%20System/5d%20-%20Heal%20Hurt%20Command.txt

Compiled 2019-11-07

*/

think Entering 6 lines.

&c.hurt [v(d.whs)]=$^\+?hurt(.*)$:@pemit %#=u(f.healhurt-workhorse, trim(%1), 0)

&c.heal [v(d.whs)]=$^\+?heal(.*)$:@pemit %#=u(f.healhurt-workhorse, trim(%1), 1)

@set v(d.whs)/c.hurt=regex

@set v(d.whs)/c.heal=regex

&f.healhurt-workhorse [v(d.whs)]=strcat(if(t(setr(t, rest(%0, /))), setq(p, pmatch(before(%0, /))), strcat(setq(p, %#), setq(t, %0))), setq(a, switch(trim(after(%qt, =)), a*, 99, >0, #$,, 1, 0)), setq(t, grab(u(d.health-types), [trim(before(%qt, =))]*)), setq(s, u(v(d.stat-funcs)/f.find-sheet, %qp)), setq(e, u(f.healhurt-errorcheck, %qp, %qs, %qt, %qa, %1)), if(t(%qe), %qe, strcat(setq(0, iter(u(d.health-types), u(%qs/_health.%i0))), if(t(%1), setq(a, mul(-1, min(%qa, elements(%q0, match(u(d.health-types), %qt)))))), setq(1, ulocal(f.do-some-dmg, setr(m, ladd(ulocal(v(d.stat-funcs)/f.getstat.workhorse.numeric, %qs, _health.maximum), .)), %q0, %qa, %qt)), null(iter(%q1, set(%qs, _health.[extract(u(d.health-types), inum(0), 1)]:%i0))), pemit(if(t(comp(%#, %qp)), %# %qp, %#), ulocal(display.health-detail, %qp, %qt, %qa, %qm, %q0, %q1, %#)), pemit(setdiff(lcon(loc(%qp), connect), %# %qp), ulocal(display.health-descr, %qp, %qt, %qa, %q1, %qm)))))

&f.healhurt-errorcheck [v(d.whs)]=case(0, t(%0), msg(if(%4, heal, hurt), Unknown player), isapproved(%0), msg(if(%4, heal, hurt), Target not approved), cor(isstaff(%#), not(t(comp(%#, %0)))), msg(if(%4, heal, hurt), Only staff may hurt or heal others), t(%1), msg(if(%4, heal, hurt), [name(%0)] doesn't have a sheet so can't be hurt), t(%2), msg(if(%4, heal, hurt), Unknown kind of damage), cand(gt(%3, 0), isint(%3)), msg(if(%4, heal, hurt), Amount must be a postive integer))

think Entry complete.
