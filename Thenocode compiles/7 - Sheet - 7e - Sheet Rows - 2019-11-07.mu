/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/7%20-%20Sheet/7e%20-%20Sheet%20Rows.txt

Compiled 2019-11-07

*/

think Entering 28 lines.

@create Sheet: Rows

@fo me=&d.sheet me=[search(name=Sheet: Rows)]

@set Sheet: Rows=inherit safe

@fo me=@parent Sheet: Rows=[v(d.nsc)]

&format.block.two-columns [v(d.sheet)]=localize(strcat(setq(w, 39), setq(t, case(%2, name-only, 38, 34)), setq(y, iter(%0, case(%2, name-only, u(display.trait-name-only, %i0, %qt, %qw, flag), ulocal(display.trait-and-value, %i0, %qt, %qw, numeric, .)), |, |)), setq(a, words(%0, |)), setq(b, ceil(fdiv(%qa, 2))), setq(c, lnum(1, %qb)), setq(d, lnum(inc(%qb), inc(%qa))), if(strlen(%1), divider(%1)%r,), vcolumns(%qw:[elements(%qy, %qc, |, |)], %qw:[elements(%qy, %qd, |, |)], |, %b)))

&format.block.two-even-columns [v(d.sheet)]=localize(strcat(setq(w, iter(%0, words(%i0, %r), |)), setq(t, ceil(fdiv(ladd(%qw), 2))), setq(o, ulocal(f.recursion.grouped-columns, first(%qw), rest(%qw), %qt)), setq(1, edit(extract(%0, 1, words(%qo), |), |, %r)), setq(2, edit(extract(%0, inc(words(%qo)), words(%0, |), |), |, %r)), if(strlen(%1), vcolumns([ceil(setr(f, sub(39, fdiv(strlen(%1), 2))))]:%q1, [floor(%qf)]:%q2, %r, %1), vcolumns(39:%q1, 39:%q2, %r))))

&f.recursion.grouped-columns [v(d.sheet)]=case(1, eq(ladd(%0), %2), %0, gt(ladd(%0), %2), extract(%0, 1, dec(words(%0))), ulocal(f.recursion.grouped-columns, cat(%0, first(%1)), rest(%1), %2))

&block.bio [v(d.sheet)]=strcat(setq(o, ulocal(bio.default, %0, %1)), setq(w, 39), setq(t, 12), divider(Bio), %r, setq(b, iter(%qo, ulocal(display.trait-and-value, %i0, %qt, %qw, string), |, |)), setq(r, floor(fdiv(setr(c, words(%qb, |)), 2))), vcolumns(%qw:[elements(%qb, lnum(1, %qr), |, |)], %qw:[elements(%qb, lnum(inc(%qr), %qc), |, |)], |, %b))

&display.trait-and-value [v(d.nsc)]=strcat(setq(v, rest(%0, :)), setq(s, ansi(xh, if(strmatch(%4,), %b, %4))), case(strtrunc(%0, 1), *, %b [trim(rest(%0, *))], #, u(display.subheader, %2, trim(rest(%0, #))), if(strlen(trim(%0)), strcat(ljust([first(%0, :)]%b, case(%3, flag, 0, list, sub(add(%1, 0), strlen(first(%qv, :))), %1), %qs), if(not(strmatch(%qs, ansi(xh, %b))), %qs, :), %b, udefault(display.value.%3, %qv, %qv, %5, %1, %b)), null(do nothing, show nothing))))

&display.value.numeric [v(d.nsc)]=if(eq(words(%0, .), 1), u(display.check-zero, %0), [u(display.check-zero, ladd(%0, .))] ([u(display.check-zero, first(%0, .))]))

&display.value.list [v(d.nsc)]=strcat(rest(first(%0, :), .), %b, ansi(hx, %(, hx, first(first(%0, :), .), hx, %)), iter(rest(%0, :), strcat(%r, repeat(%3, sub(add(%2, 1), strlen(%i0))), %b, rest(%i0, .), %b, ansi(hx, %(, hx, first(%i0, .), hx, %)),), :, @@))

&display.value.pool [v(d.nsc)]=localize(strcat(setq(c, u(display.check-zero, ladd(%0, .))), setq(o, ladd(%1, .)), setq(m, first(%1, .)), ladd(%0, .), if(cor(neq(%qc, %qo), neq(%qo, %qm)), edit(strcat(%b%(, if(neq(%qc, %qo), out of %qo%b), if(neq(%qo, %qm), %, max %qm), %)), %b%,, %,, %(%, %b,, %b%), %)))))

&display.check-zero [v(d.nsc)]=if(eq(%0, 0), -, %0)

&display.trait-name-only [v(d.nsc)]=strcat(setq(v, rest(%0, :)), setq(s, ansi(xh, if(strmatch(%4,), %b, %4))), case(strtrunc(%0, 1), *, %b [trim(rest(%0, *))], #, u(display.subheader, %2, trim(rest(%0, #))), strcat(ljust(cat(first(%0, :),), %1, %qs), if(not(strmatch(%qs, ansi(xh, %b))), %qs,))))

&block.attributes [v(d.sheet)]=strcat(setq(w, 26), setq(t, 17), setq(m, iter(#Mental|[ulocal(attributes.mental.default, %0)], u(display.trait-and-value, %i0, %qt, %qw, numeric), |, |)), setq(p, iter(#Physical|[ulocal(attributes.physical.default, %0)], u(display.trait-and-value, %i0, %qt, dec(%qw), numeric), |, |)), setq(s, iter(#Social|[ulocal(attributes.social.default, %0)], u(display.trait-and-value, %i0, %qt, %qw, numeric), |, |)), divider(Attributes), %r, vcolumns(%qw:%qm, [dec(%qw)]:%qp, %qw:%qs, |, %b))

&display.subheader [v(d.nsc)]=center(%b%1%b, %0, %xh%xx.%xn)

&block.skills [v(d.sheet)]=strcat(setq(w, 26), setq(t, 17), setq(m, iter(#Mental|[ulocal(skills.mental.default, %0)], u(display.trait-and-value, %i0, %qt, %qw, numeric), |, |)), setq(p, iter(#Physical|[ulocal(skills.physical.default, %0)], u(display.trait-and-value, %i0, %qt, dec(%qw), numeric), |, |)), setq(s, iter(#Social|[ulocal(skills.social.default, %0)], u(display.trait-and-value, %i0, %qt, %qw, numeric), |, |)), divider(Skills), %r, vcolumns(%qw:%qm, [dec(%qw)]:%qp, %qw:%qs, |, %b))

&display.value.pool [v(d.nsc)]=strcat(repeat(o, ladd(%0, .)), ansi(xh, repeat(., mul(-1, ladd(rest(%0, .), .)))), ansi(xh, repeat(#, mul(-1, ladd(rest(%1, .), .)))))

&block.traits [v(d.sheet)]=strcat(setq(w, 38), setq(t, 10), setq(x, ulocal(traits.willpower.default, %0)), setq(c, rest(setr(y, first(%qx, |)), :)), setq(p, last(%qx, :)), setq(z, iter(udefault(traits.morality.[get(%0/_bio.template)], u(traits.morality.default, %0), %0), udefault(display.integrity.[get(%0/_bio.template)], u(display.trait-and-value, %i0, %qt, %qw, string), %i0, %qt, %qw), |, |)), divider(Traits), %r, vcolumns(%qw:[u(display.trait-and-value, %qy, %qt, %qw, pool, %b, %qp)], %qw:%qz, |, %b))

&_ADVANTAGE.WILLPOWER me=derived

&_ADVANTAGE.WILLPOWER_MAXIMUM me=derived

&_ADVANTAGE.WILLPOWER me=derived.-2

&_ADVANTAGE.WILLPOWER_MAXIMUM me=derived.-1

&block.merits [v(d.sheet)]=strcat(setq(w, 79), setq(t, 70), setq(d, u(merits.default, %0)), setq(b, iter(%qd, strcat(setq(c, ulocal(v(d.sfp)/f.get-class, merit.[edit(first(%i0, :), %b, _)])), u(display.trait-and-value, %i0, %qt, %qw, %qc, .)), |, |)), divider(Merits), %r, iter(%qb, %i0, |, %r))

&block.advantages [v(d.sheet)]=strcat(setq(w, 26), setq(t, 17), setq(d, filter(filter.out-zeros, u(advantages.default, %0), |, |)), setq(a, iter(%qd, u(display.trait-and-value, %i0, %qt, %qw, numeric), |, |)), divider(Advantages), %r, columns(%qa, %qw, |))

&filter.out-zeros [v(d.nsc)]=cand(not(strmatch(rest(%0, :), 0)), not(strmatch(rest(%0, :),)))

&block.health [v(d.sheet)]=strcat(setq(w, 80), setq(t, 7), setq(c, first(setr(h, u(health.default, %0)), |)), setq(p, rest(%qh, |)), if(neq(last(%qp, :), 0), setq(p, strcat(%b%(, u(display.trait-and-value, %qp, %qt, %qw, numeric), %))), setq(p,)), divider(Health), %r, vcolumns(%qw:%b %qc%qp, |))

&display.sheet [v(d.sheet)]=strcat(header(cat(name(%1), %(%0%))), %r, u(block.bio, %0, %2), %r, u(block.attributes, %0, %2), %r, u(block.skills, %0, %2), %r, u(block.merits, %0, %2), %r, udefault(block.powers.[edit(%2, %b, _)],, %0, %2), u(block.advantages, %0, %2), u(block.traits, %0, %2), %r, udefault(block.traits.[edit(%2, %b, _)],, %0, %2), u(block.health, %0, %2), %r, footer())

think Entry complete.
