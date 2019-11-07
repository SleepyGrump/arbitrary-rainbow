/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/8%20-%20Chargen/8c%20-%20Points%20Check.txt

Compiled 2019-11-07

*/

think Entering 6 lines.

&f.pts-valid?.attributes [v(d.cg)]=strcat(setq(a, sort(u(f.allocated.attributes, %0, %1), n, /)), cand(eq(first(%qa, /), 3), eq(elements(%qa, 2, /), 4), eq(last(%qa, /), 5)))

&f.pts-valid?.skills [v(d.cg)]=strcat(setq(s, sort(u(f.allocated.skills, %0, %1), n, /)), and(eq(first(%qs, /), 4), eq(elements(%qs, 2, /), 7), eq(last(%qs, /), 11)))

&f.pts-valid?.specialties [v(d.cg)]=strcat(setq(s, u(f.allocated.specialties, %0)), setq(t, u(%0/_bio.template)), land([eq(words(first(%qs, `)), 3)] [udefault(f.pts-valid?.specialties.%qt, 1, rest(%qs, `))]))

&f.pts-valid?.merits [v(d.cg)]=eq(ladd(u(f.allocated.merits, %0), /), 10)

&f.pts-valid?.integrity [v(d.cg)]=strcat(setq(t, u(%0/_bio.template)), udefault(f.pts-valid?.integrity.%qt, u(f.pts-valid?.integrity.human, %0), %0))

&f.pts-valid?.integrity.human [v(d.cg)]=eq(u(f.allocated.integrity.human, %0), udefault(u(d.dd)/default.advantage.integrity, 7))

think Entry complete.
