/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/A%20-%20Bonus%20Sub-Systems/A1%20-%20Census.txt

Compiled 2019-11-07

*/

think Entering 40 lines.

@create Census System <cs>

@set Census System <cs>=inherit safe

@parent Census System <cs>=codp

@fo me=&d.cs me=[search(name=Census System <cs>)]

&.msg [v(d.cs)]=ansi(h, <%0>, n, %b%1)

@fo me=&d.dd [v(d.cs)]=[search(name=Data Dictionary <dd>)]

@fo me=&d.sfp [v(d.cs)]=[search(name=Stat Functions Prototype <sfp>)]

&c.census [v(d.cs)]=$^\+?census([\s\S]+)?$:@pemit %#=[setq(0, secure(%1))][switch(%q0,, u(c.census.default), /*, u(c.census.switch, after(first(%q0), /), rest(%q0)), %b*, u(c.census.specific, trim(%q0)), u(.msg, census, Census' format is census%[/<switch>%]%[ <input>%]))]

@set v(d.cs)/c.census=regexp

&c.census.switch [v(d.cs)]=if(setr(0, grab(lattr(me/c.census/*), c.census/%0*)), u(%q0, %1), u(.msg, census, cat(No such switch for census., Valid switches are:, itemize(lcstr(iter(lattr(me/c.census/*), after(##, /)))))))

&c.census.default [v(d.cs)]=strcat(setq(a, u(f.search.approved)), setq(u, filter(fil.attr.exists, u(f.search.chargen),,, _bio.template)), wheader(Census: [words(%qa)] Approved), %r, wdivider(templates), %r, setq(l, iter(get(v(d.dd)/bio.template), strcat(%i0:, words(filter(fil.attr.string.is, %qa,,, _bio.template, %i0)), if(t(setr(x, filter(fil.attr.list.contains, %qu,,, _bio.template, %i0))), ansi(xh, %b%(+[words(%qx)]%)))), ., |)), columns(%ql, 25, |, 2), iter(get(v(d.dd)/bio.template), ulocal(display.census.template.%i0), . , @@), wfooter(%([words(%qu)] unapproved%)))

&c.census.specific [v(d.cs)]=strcat(setq(s, statpath(%0)), case(1, t(%qs), strcat(wheader(Census: [statname(%0)]), %r, u(display.census.breakdown, %qs, isstaff(%#)), wfooter()), u(.msg, census, I couldn't process the stat you wanted)))

&f.search.approved [v(d.cs)]=search(eplayer=cand(isapproved(##, approved), not(isstaff(##))))

&f.search.chargen [v(d.cs)]=search(eplayer=isapproved(##, chargen))

&f.search.attr [v(d.cs)]=search(eplayer=hasattr(##, %0))

&f.search.attr.template [v(d.cs)]=search(eplayer=cand(hasattr(##, %0), hasattr(##, _bio.template)))

&fil.approved [v(d.cs)]=cand(isapproved(%0, approved), not(isstaff(%0)))

&fil.chargen [v(d.cs)]=isapproved(%0, chargen)

&fil.unapproved [v(d.cs)]=isapproved(%0, unapproved)

&fil.frozen [v(d.cs)]=isapproved(%0, frozen)

&fil.dead [v(d.cs)]=isapproved(%0, dead)

&fil.attr.exists [v(d.cs)]=hasattr(%0, %1)

&fil.attr.string.is [v(d.cs)]=strmatch(u(%0/%1), %2)

&fil.attr.list.contains [v(d.cs)]=t(match(u(%0/%1), %2, .))

&fil.attr.value.is [v(d.cs)]=strmatch(first(u(%0/%1), .), %2)

&fil.attr.value.gte [v(d.cs)]=gte(first(u(%0/%1), .), %2)

&fil.attr.value.lte [v(d.cs)]=lte(first(u(%0/%1), .), %2)

&f.roster.string [v(d.cs)]=localize(strcat(setq(s, u(f.search.attr.template, %0)), iter(%1, strcat(%i0:, filter(fil.attr.[switch(%2, l*, list.contains, s*, string.is, string.is)], %qs,,, %0, %i0)), ., |)))

&f.roster.numeric [v(d.cs)]=localize(strcat(setq(o, case(strtrunc(%2, 1), i, is, =, is, g, gte, >, gte, l, lte, <, lte, is)), setq(s, u(f.search.attr.template, %0)), %1:, filter(fil.attr.value.%qo, %qs,,, %0, %1)))

&f.roster.totals [v(d.cs)]=localize(strcat(setq(t, u(f.search.attr, _bio.template)), iter(Approved Chargen Unapproved Frozen Dead, strcat(%i0:, filter(fil.%i0, %qt)),, |)))

&display.census.totals [v(d.cs)]=columns(iter(u(f.roster.totals), [first(%i0, :)]: [words(rest(%i0, :))], |, |), 25, |, 2)

&display.census.attribute [v(d.cs)]=localize(strcat(setq(v, iter(%1, first(%i0, :), ., .)), setq(r, ulocal(f.roster.string, %0, %qv, if(t(%2), l))), columns(iter(%qr, strcat(setq(l, rest(%i0, :)), setq(u, filter(fil.chargen, %ql)), setq(d, rest(extract(%1, inum(), 1, .), :)), if(t(%qd), %qd, first(%i0, :)), :, %b, words(filter(fil.approved, %ql)), if(%qu, ansi(xh, %b%(+[words(%qu)]%)))), |, |), 25, |, 2)))

&f.roster.types [v(d.cs)]=case(comp(%1, *), -1, null(return nothing), 1, %1, 0, localize(strcat(setq(0, edit(%0, %(%), %(*%))), setq(l, setunion(iter(search(eplayer=t(lattr(##/_%q0))), lattr(%i0/_%q0)),)), iter(%ql, first(rest(%i0, %(), %)),, .))))

&f.roster.order-approved [v(d.cs)]=iter(if(%2, iter(%1, ulocal(f.roster.numeric, %0, %i0), ., |), ulocal(f.roster.string, %0, %1, l)), strcat(first(%i0, :):, filter(fil.approved, rest(%i0, :)), :, filter(fil.chargen, rest(%i0, :))), |, |)

&display.census.breakdown [v(d.cs)]=localize(strcat(setq(d, u(v(d.dd)/%0)), setq(t, if(strmatch(%0, *()), extract(%qd, 2, 1, |))), setq(d, first(%qd, |)), setq(t, ulocal(f.roster.types, %0, %qt)), setq(n, u(v(d.sfp)/f.isclass?, %0, numeric)), setq(z, 0), iter(%qd, setq(z, max(strlen(%i0), %qz)), ., @@), if(t(%qt), iter(%qt, strcat(setq(0, edit(%0, %(%), %(%i0%))), setq(l, u(f.roster.order-approved, _%q0, %qd, %qn)), if(%1, u(display.census.breakdown.names, type.%i0, %ql, %qn), strcat(wdivider(titlestr(edit(%i0, _, %b))), %r, u(display.census.breakdown.totals, %ql, %qn, %qz)))), ., @@), strcat(setq(l, u(f.roster.order-approved, _%0, %qd, %qn)), if(%1, u(display.census.breakdown.names, %0, %ql, %qn), u(display.census.breakdown.totals, %ql, %qn, %qz))))))

&display.census.breakdown.names [v(d.cs)]=iter(filter(fil.values-with-members, %1, |, |), strcat(setq(a, extract(%i0, 2, 1, :)), setq(u, last(%i0, :)), wdivider(if(%2, [titlestr(edit(rest(%0, .), _, %b))]: [first(%i0, :)], titlestr(first(%i0, :)))), %r, ansi(c, >>%b, n, Approved: [words(%qa)], c, %b<<), %r, wrap(if(t(%qa), iter(%qa, name(%i0),, %, %b), ansi(xh, -)), sub(width(%#), 2), left, %b%b), %r, if(t(%qu), strcat(ansi(c, >>%b, n, Waiting: [words(%qu)], c, %b<<), %r, wrap(if(t(%qu), iter(%qu, name(%i0),, %, %b), ansi(xh, -)), sub(width(%#), 2), left, %b%b), %r))), |, @@)

&fil.values-with-members [v(d.cs)]=cor(t(extract(%0, 2, 1, :)), t(extract(%0, 3, 1, :)))

&display.census.breakdown.totals [v(d.cs)]=[columns(trim(iter(%0, [setq(a, elements(%i0, 2, :))][setq(u, elements(%i0, 3, :))][if(or(t(%qa), t(%qu), %1), [first(%i0, :)]: [case(setr(w, words(%qa)), 0, ansi(xh, -), %qw)][if(t(%qu), ansi(xh, %b%(+[words(%qu)]%)))]|)], |, @@), b, |), max(25, add(%2, 9)), |, 2)]

&display.census.template.changeling [v(d.cs)]=localize(strcat(setq(z, 0), setq(l, iter(get(u(d.dd)/bio.seeming), %i0: [setr(g, words(filter(fil.attr.list.contains, %qa,,, _bio.seeming, %i0)))][setq(z, add(%qz, %qg))][if(t(setr(x, filter(fil.attr.list.contains, %qu,,, _bio.seeming, %i0))), ansi(xh, %b%(+[words(%qx)]%)))][setq(z, add(%qz, words(%qx)))], ., |)), if(t(%qz), [footer(changeling: seeming)]%r[columns(%ql, 25, |, 2)]), setq(z, 0), setq(l, iter(get(u(d.dd)/bio.court), %i0: [setr(g, words(filter(fil.attr.list.contains, %qa,,, _bio.court, %i0)))][setq(z, add(%qz, %qg))][if(t(setr(x, filter(fil.attr.list.contains, %qu,,, _bio.court, %i0))), ansi(xh, %b%(+[words(%qx)]%)))] [setq(z, add(%qz, words(%qx)))], ., |)), if(t(%qz), [footer(changeling: court)]%r[columns(%ql, 25, |, 2)])))

&display.census.template.vampire [v(d.cs)]=localize(strcat(if(t(setr(l, u(display.census.breakdown, bio.clan))), [footer(vampire: clan)]%r%ql), if(t(setr(l, u(display.census.breakdown, bio.covenant))), [footer(vampire: covenant)]%r%ql), if(t(setr(l, filter(fil.values-with-members, u(f.roster.order-approved, _bio.bloodline, get(v(d.dd)/bio.bloodline), 0), |, |))), strcat(setq(l, iter(%ql, strcat(first(%i0, :), :%b, words(elements(%i0, 2, :)), if(t(setr(x, elements(%i0, 3, :))), ansi(xh, %b%(+[words(%qx)]%))), setq(w, max(%qw, add(strlen(first(%i0, :)), words(elements(%i0, 2 3, :, %b)), 4))),), |, |)), footer(vampire: bloodline), %r, columns(%ql, %qw, |, 2)))))

think Entry complete.
