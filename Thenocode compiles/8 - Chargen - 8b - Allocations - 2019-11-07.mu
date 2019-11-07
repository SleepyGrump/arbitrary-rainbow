/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/8%20-%20Chargen/8b%20-%20Allocations.txt

Compiled 2019-11-07

*/

think Entering 10 lines.

&f.allocated.attributes [v(d.cg)]=iter(mental physical social, add(sub(u(f.points.category, %0, attribute, %i0), 3), ladd(iter(filter(fil.stats-to-include, %1,,, attribute, %i0), last(%i0, :)))),, /)

&f.allocated.skills [v(d.cg)]=iter(mental physical social, add(u(f.points.category, %0, skill, %i0), ladd(iter(filter(fil.stats-to-include, %1,,, skill, %i0), last(%i0, :)))),, /)

&f.allocated.specialties [v(d.cg)]=strcat(setq(l, ulocal(f.list-stats-tags, %0, skill, mental.physical.social, or)), setq(s, iter(%ql, lattr(%0/_%i0.*))), setq(t, u(%0/_bio.template)), setq(f, u(f.allocated.specialties.%qt, %0, %qs)), iter(%qf, iter(%i0, setq(s, remove(%qs, %i0))), `, @@), %qs[if(strlen(%qf), `%qf)])

&f.allocated.specialties.human [v(d.cg)]=@@

&f.allocated.aspirations [v(d.cg)]=localize(strcat(setq(a, cat(u(v(d.asp)/f.get.aspirations.status, %0, pitched), u(v(d.asp)/f.get.aspirations.status, %0, approved))), setq(s, filter(v(d.asp)/filter.term, %qa,,, %0, short-term)), setq(l, filter(v(d.asp)/filter.term, %qa,,, %0, long-term)), words(%qs), /, words(%ql)))

&f.pts-valid?.aspirations [v(d.cg)]=strcat(setq(a, u(f.allocated.aspirations, %0)), cand(eq(first(%qa, /), 2), eq(rest(%qa, /), 1)))

&f.allocated.merits [v(d.cg)]=strcat(setq(t, u(%0/_bio.template)), ladd(cat(ulocal(f.points.category, %0, merit, *), iter(lattr(%0/_merit.*.*), mul(-1, first(u(%0/%i0), .))), -[ulocal(f.allocated.merits.%qt, %0)],)), /, udefault(f.allocated.power-trait.%qt, 0, %0))

&f.allocated.power-trait.human [v(d.cg)]=0

&f.allocated.integrity [v(d.cg)]=strcat(setq(t, u(%0/_bio.template)), udefault(f.allocated.integrity.%qt, u(f.allocated.integrity.human, %0), %0))

&f.allocated.integrity.human [v(d.cg)]=u(u(d.dd)/.value, %0, advantage.integrity)

think Entry complete.
