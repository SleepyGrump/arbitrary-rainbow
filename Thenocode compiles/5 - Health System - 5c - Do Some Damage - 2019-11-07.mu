/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/5%20-%20Health%20System/5c%20-%20Do%20Some%20Damage.txt

Compiled 2019-11-07

*/

think Entering 3 lines.

&f.do-some-dmg [v(d.whs)]=[setq(t, u(f.conv-type, %3))][setq(h, if(lt(%0, ladd(%1)), u(f.reverse-max-health, %0, %1), %1))][iter(u(d.health-types), setq(inum(0), elements(%qh, inum(0))),, @@)][setq(s, min(%2, setr(u, sub(%0, ladd(%qh)))))][setq(%qt, add(r(%qt), %qs))][setq(c, max(0, sub(%2, %qu)))][iter(lnum(%qc), [setq(m, u(f.min-dmg, %q1, %q2, %q3))][if(gt(%qt, %qm), u(f.do-some-dmg.push), u(f.do-some-dmg.wrap))],, @@)]%q1 %q2 %q3

&f.do-some-dmg.push [v(d.whs)]=[setq(%qm, dec(r(%qm)))][setq(%qt, inc(r(%qt)))]

&f.do-some-dmg.wrap [v(d.whs)]=if(lte(inc(%qm), words(u(d.health-types))), [setq(%qm, dec(r(%qm)))][setq(inc(%qm), inc(r(inc(%qm))))])

think Entry complete.
