/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/3%20-%20Stat%20Setter/3d%20-%20Template%20and%20Wipe.txt

Compiled 2019-11-07

*/

think Entering 8 lines.

&f.stat/template [v(d.ss)]=strcat(if(strmatch(%0, *=*), setq(0, before(%0, =)), setq(0, %#)), if(strmatch(%0, *=*), setq(1, after(%0, =)), setq(1, %0)), if(strmatch(%q0, me), setq(0, %#)), setq(p, u(.pmatch, %q0)), setq(w, u(f.find-sheet, %qp)), setq(s, strmatch(%#, %qp)), setq(v, statvalidate(template, %q1)), case(0, cor(isstaff(%#), cand(%qs, isapproved(%#, chargen))), u(.msg, stat/template, Staff only), not(hasattr(%qw, _bio.template)), if(t(%qs), u(.msg, stat/template, You already have a template. 'stat/wipe' to erase your stats., Player already has a template. 'stat/wipe %q0' to erase their stats.)), t(%qv), u(.msg, stat/template, Template '%q1' could not be found; check 'stat template'), strcat(setq(l, u(f.statpaths-for-template, %qv)), u(display.statpath_defaults, %qp, %qv, %ql), null(set(%qw, _BIO.TEMPLATE:%qv)), null(u(f.defaults.set, %qw, %ql)),)))

&f.statpaths-for-template [v(d.ss)]=setunion(filter(filter.stat-allowed-for-template, edit(lattr([u(d.data-dictionary)]/default.*), DEFAULT.,),,, %0),)

&f.defaults.set [v(d.ss)]=iter(%1, set(%0, _%i0:[u([u(d.data-dictionary)]/default.%i0, %0)]))

&display.statpath_defaults [v(d.ss)]=strcat(header(Set up [name(%0)] with template '%1'), %r %b, ansi(h, Sheet Location), : [u(f.find-sheet, %0)] %r %b, ansi(h, Template), : %1 %r, setq(m, setunion(iter(%2, first(%i0, .)),)), iter(%qm, [divider(titlestr(edit(%i0, _, %b)))]%r[iter(graball(%2, %i0.*), strcat(%b%b, ansi(h, ulocal([u(d.stat-funcs)]/f.statname.workhorse, rest(%i0, .))), :%b, get([u(d.data-dictionary)]/default.%i0)),, %r)],, %r), %r, footer(sheet [name(%0)]))

&filter.stat-allowed-for-template [v(d.ss)]=cor(u([u(d.stat-funcs)]/f.hastag?.workhorse, %0, %1), not(u([u(d.stat-funcs)]/f.hastag?.workhorse, %0, get([u(d.data-dictionary)]/bio.template))))

&f.stat/wipe [v(d.ss)]=strcat(if(strmatch(%0, *=*), setq(0, trim(first(%0, =))), setq(0, %#)), setq(1, trim(rest(%0, =))), setq(p, u(.pmatch, %q0)), setq(s, strmatch(%qp, %#)), setq(w, u(f.find-sheet, %qp)), case(0, cor(isstaff(%#), cand(%qs, isapproved(%#, chargen))), u(.msg, stat/wipe, Staff only), t(%qp), u(.msg, stat/wipe, Player not found), hasattr(%qw , _bio.template), u(.msg, stat/wipe, Template not set; cannot wipe stats), comp(%q1, YES), strcat(setq(l, u(f.statpaths-from-sheet, %qw)), wheader(Wiping [name(%qp)]'s Sheet), %r, %b%b, iter(%ql, strcat(ansi(h, u([u(d.stat-funcs)]/f.statname.workhorse, rest(%i0, .))), :%b, get(%qw/_%i0), null(set(%qw, _%i0:))),, %r %b), %r, wfooter(Sheet Wiped)), u(.msg, stat/wipe, if(t(%qs), ansi(r, >> Are you%b, rhu, absolutely sure, r, %byou want to wipe your sheet? <<, n, %rIf so%, type:%b, h, stat/wipe me=YES), ansi(r, >> Are you%b, rhu, absolutely sure, r, %byou want to wipe [name(%qp)]'s sheet? <<, n, %rIf so%, type:%b, h, stat/wipe [name(%qp)]=YES)))))

&f.statpaths-from-sheet [v(d.ss)]=cat(BIO.TEMPLATE, edit(iter(u([u(d.stat-funcs)]/d.search-order), iter(lattr(%0/_%i0.*), rest(%i0, _))), BIO.TEMPLATE, null(null)))

&f.list-stats-all [v(d.ss)]=u([u(d.stat-funcs)]/f.stat-list-selected, *)

think Entry complete.
