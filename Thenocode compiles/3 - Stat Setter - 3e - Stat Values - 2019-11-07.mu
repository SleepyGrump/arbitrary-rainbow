/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/3%20-%20Stat%20Setter/3e%20-%20Stat%20Values.txt

Compiled 2019-11-07

*/

think Entering 7 lines.

&f.stat/values [v(d.ss)]=strcat(setq(a,), setq(t,), setq(v,), setq(f,), setq(y, u(d.stat-funcs)), setq(q, u(%qy/f.find-sheet, %#)), setq(x, u(d.data-dictionary)), if(strmatch(%0, */*), strcat(setq(w, rest(%0, /)), iter(before(%0, /), case(1, strmatch(%i0, v*=*), setq(v, edit(last(%i0, =), _, %b)), t(setr(z, grab(u(%qy/d.search-order), %i0*))), setq(a, %qa %qz), t(setr(z, grab(u(%qx/bio.template), %i0*, .))), setq(t, %qt.[edit(%qz, _, %b)]), setq(t, %qt.[edit(%i0, _, %b)])),, @@)), setq(w, %0)), setq(t, trim(%qt, b, .)), setq(p, u(%qy/f.statpath-validate-name, %qw)), if(t(%qa), setq(p, filter(%qy/fil.list-stats-types, %qp,,, %qa))), if(t(%qt), setq(p, filter(%qy/fil.list-stats-tags, %qp,,, %qt, 1))), if(t(%qv), setq(p, filter(%qy/fil.list-stats-values, %qp,,, %qv))), setq(n, u(%qy/f.statname.workhorse, rest(%qp, .))), setq(s, get(%qx/%qp)), case(1, cand(t(%qp), eq(words(%qp), 1)), u(display.stat.values.display.one), gt(words(%qp), 200), u(.msg, stat, Over two hundred matches. Please refine your search.), cand(t(%qp), gt(words(%qp), 1)), u(display.stat.values.display.multiple), u(.msg, stat, Stat not found; try '<name>*' to find a list of possible matches)))

&display.stat-valuelist [v(d.ss)]=case(%0, *, Any, #, Numeric, if(strmatch(%0, derived), Derived Formula, itemize(%0, ., if(t(%1), %1, and))))

&display.stat-prereqlist [v(d.ss)]=strcat(filter(filter.stat-prereqlist.template, u([u(d.data-dictionary)]/bio.template), ., ., %0), |, if(u([u(d.stat-funcs)]/f.hastag?.workhorse, %0, chargen-only), Chargen-Only), |, if(hasattr(u(d.data-dictionary), prereq-text.%0), u([u(d.data-dictionary)]/prereq-text.%0, %#)))

&filter.stat-prereqlist.template [v(d.ss)]=u([u(d.stat-funcs)]/f.hastag?.workhorse, %1, %0)

&display.stat.values.display.one [v(d.ss)]=strcat(wheader([edit(%qn, %(%), %(<type>%))] %[[ulocal([u(d.stat-funcs)]/f.statname.workhorse, first(%qp, .))]%]), %r, setq(x, u([u(d.stat-funcs)]/f.hastag?.workhorse, %qp, derived)), %b, %b, ansi(h, Values), :, %b, if(t(%qx), Derived Function, u(display.stat-valuelist, first(%qs, |))), if(cand(hasattr(u(d.data-dictionary), default.%qp), not(%qx)), strcat(%r, %b, %b, ansi(h, Default), :, %b, get([u(d.data-dictionary)]/default.%qp),)), case(words(%qs, |), 3, strcat(%r, %b, %b, ansi(h, Type), :, %b, u(display.stat-valuelist, elements(%qs, 2, |), or), %r, %b, %b, ansi(h, Details), :, %b, u(display.stat-valuelist, last(%qs, |))), 2, if(strmatch(%qp, *%(%)), strcat(%r, %b, %b, ansi(h, Type), :, %b, u(display.stat-valuelist, rest(%qs, |), or)), strcat(%r, %b, %b, ansi(h, Details), :, %b, u(display.stat-valuelist, rest(%qs, |))))), setq(r, ulocal(display.stat-prereqlist, %qp)), setq(n, ulocal([u(d.data-tags)]/notes.%qp)), if(cor(t(trim(%qr, b, |)), t(%qn)), %r), if(t(setr(x, first(%qr, |))), wrap(strcat(%r, ansi(h, Templates), :, %b, itemize(%qx, ., or)), sub(width(%#), 2), left, %b%b)), if(t(setr(x, elements(%qr, 2, |))), wrap(strcat(%r, ansi(h, Chargen), :, %b, itemize(%qx, .)), sub(width(%#), 2), left, %b%b)), if(t(setr(x, last(%qr, |))), wrap(strcat(%r, ansi(h, Prerequisites), :, %b, %qx), sub(width(%#), 2), left, %b%b)), if(cand(t(trim(%qr, b, |)), t(%qn)), %r), if(t(%qn), ansi(n, %b%b, h, Notes, n, :%r, n, iter(%qn, wrap(* %i0, sub(width(%#), 4), left, %b%b%b%b,, 2), |, %r))), %r, wfooter(if(u([u(d.stat-funcs)]/f.hastag?.workhorse, %qp, Chargen-Only), Chargen Only)))

&display.stat.values.display.multiple [v(d.ss)]=strcat(setq(z, u(d.stat-funcs)), setq(y, iter(%qp, edit(u(%qz/f.statname.workhorse, rest(%i0, .)), %(%), %(<type>%)),, |)), setq(m, last(sort(iter(%qy, strlen(%i0), |)))), header(Matches for [if(t(rest(%0, /)), [first(%0, /)]/)]%qw), %r, iter(%qp, strcat(%b%b, ljust(edit(u(%qz/f.statname.workhorse, rest(%i0, .)), %(%), %(<type>%)), %qm), %b%b, ansi(xh, %[, xh, u(%qz/f.statname.workhorse, first(%i0, .)), xh, %])),, %r), %r, footer([words(%qp)] Matches))

&fil.prerequisites [v(d.ss)]=cand(u([u(d.stat-funcs)]/f.prereq-check-template, %1, %0), if(cand(strmatch(%0, *_()), not(member(extract(get([u(d.data-dictionary)]/%0), 2, 1, |), *))), lor(iter(extract(get([u(d.data-dictionary)]/%0), 2, 1, |), u([u(d.stat-funcs)]/f.prereq-check-other, %1, %0, %i0), .)), u([u(d.stat-funcs)]/f.prereq-check-other, %1, %0)))

think Entry complete.
