/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/8%20-%20Chargen/8d%20-%20Prerequisites%20Check.txt

Compiled 2019-11-07

*/

think Entering 3 lines.

&f.prerequisite.cg-only [v(d.cg)]=if(cor(not(hastag?(rest(%1, .), chargen-only)), isapproved(%0, chargen)), 1, #-1 Chargen-Only stats cannot be gained after approval)

&f.prerequisite.template [v(d.cg)]=localize(strcat(setq(s, ulocal([u(d.sfp)]/f.statpath-without-instance, %1)), setq(t, setinter(lcstr(u([u(d.dd)]/bio.template)), lcstr(u([u(d.dt)]/tags.[rest(%qs, _)])), .)), if(t(%qt), if(t(setinter(lcstr(u(%0/_bio.template)), %qt, .)), 1, #-1 Character Template Not Allowed For This Stat), 1)))

&f.prerequisite.other [v(d.cg)]=localize(strcat(setq(i, before(rest(%1, %(), %))), setq(s, rest(ulocal(v(d.sfp)/f.statpath-without-instance, %1), _)), u(v(d.sfp)/f.prereq-check-other, %0, %qs, %qi, %2)))

think Entry complete.
