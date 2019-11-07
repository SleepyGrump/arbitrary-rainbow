/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/5%20-%20Health%20System/5b%20-%20Functions%20and%20Display.txt

Compiled 2019-11-07

*/

think Entering 7 lines.

&f.conv-type [v(d.whs)]=if(isnum(%0), extract(u(d.health-types), %0, 1), match(u(d.health-types), %0*))

&f.min-dmg [v(d.whs)]=localize([setq(z,)][iter(u(d.health-types), if(cand(t(v(dec(inum(0)))), not(t(%qz))), setq(z, inum(0))),, @@)]%qz)

&display.health-bar [v(d.whs)]=[setq(w, inc(words(%0)))][iter(* X /, iter(lnum(elements(%0, sub(%qw, inum(0)))), ansi(xh, %[, nh, %i1, xh, %]),, @@),, @@)][iter(lnum(sub(%1, ladd(%0))), ansi(xh, %[%b%]),, @@)]

&display.health-descr [v(d.whs)]=strcat(setq(h, strmatch(%2, -*)), setq(m, if(%qh, receives, takes)), setq(d, switch(abs(%2), >6, ungodly, >4, extreme, >2, significant, >0, some, no)), setq(n, if(comp(%qd, no), now, still)), setq(t, lightly.noticeably.badly.severely), setq(t, case(1, cand(gte(ladd(%3), %4), comp(u(f.min-dmg, first(%3), elements(%3, 2), last(%3)), 1)), critically, eq(ladd(%3), 0), fine, elements(%qt, round(mul(fdiv(ladd(%3), %4), words(%qt, .)), 0), ., .))), setq(i, bruised.bleeding.mangled), setq(i, itemize(trim(iter(%3, if(gt(%i0, 0), [elements(%qi, inum(0), ., .)].),, @@), b, .), .)), name(%0), %b, %qm %qd, %b, if(%qh, healing for %1, %1), %b, and is %qn, %b, trim(%qt %qi), .)

&display.health-detail [v(d.whs)]=strcat(if(strmatch(%2, -*), header([name(%0)] receives healing for [abs(%2)] [capstr(%1)]), header([name(%0)] takes %2 [capstr(%1)])), %r, %b, ansi(h, Initial Health), :, %b, u(display.health-bar, %4, %3), %b-%b, ladd(%4), %b, of %3, %r, %b, ansi(h, Final Health), :, %b%b%b, u(display.health-bar, %5, %3), %b-%b, ladd(%5), %b, of %3, %b, if(neq(u(%0/_health.penalty), 0), %([u(%0/_health.penalty)] dice%)), %r%b %r, trim(wrap(ulocal(display.health-descr, %0, %1, %2, %5, %3), 78, left, %b), r), %r, footer(if(t(comp(%0, %6)), [if(strmatch(%2, -*), healed, dealt)] by [name(%6)])))

&display.current-health-descr [v(d.whs)]=strcat(setq(t, lightly.noticeably.badly.severely), setq(t, case(1, cand(gte(ladd(%1), %2), comp(u(f.min-dmg, first(%1), extract(%1, 2, 1), last(%1)), 1)), critically, eq(ladd(%1), 0), fine, elements(%qt, round(mul(fdiv(ladd(%1), %2), words(%qt, .)), 0), ., .))), setq(i, bruised.bleeding.mangled), setq(i, itemize(trim(iter(%1, if(gt(%i0, 0), [elements(%qi, inum(0), ., .)].),, @@), b, .), .)), name(%0), %b, is, %b, trim(%qt %qi), .)

&f.reverse-max-health [v(d.whs)]=localize(strcat(setq(d, setr(i, sub(ladd(%1), %0))), setq(h, iter(%1, [sub(%i0, min(%qi, %i0))][setq(i, sub(%qi, min(%qi, %i0)))])), u(f.do-some-dmg, %0, %qh, %qd, bashing)))

think Entry complete.
