/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/3%20-%20Stat%20Setter/3c%20-%20Basic%20Set%20Switches.txt

Compiled 2019-11-07

*/

think Entering 4 lines.

&d.regmatch-stat [v(d.ss)]=strcat(if(gte(words(%0, /), 2), setq(0, trim(first(%0, /))), setq(0, %1)), if(gte(words(%0, /), 2), setq(1, rest(%0, /)), setq(1, %0)), setq(2, case(1, strmatch(%q1, *=*), =, strmatch(%q1, *+*), +, strmatch(%q1, *-*), -)), setq(3, trim(rest(%q1, %q2))), setq(1, trim(first(%q1, %q2))), cand(t(%q0), t(%q1), t(%q2)))

&f.stat/set [v(d.ss)]=strcat(setq(m, u(d.regmatch-stat, %0, %#)), setq(p, if(isstaff(%#), u(.pmatch, first(%q0, :)), %#)), setq(x, if(isstaff(%#), %qp:[rest(%q0, :)], %#:[rest(%q0, :)])), case(0, t(%qm), I couldn't tell what you typed. The format is: stat/set %[<target>/%]<stat> <operator> <value>, cor(isstaff(%#), isapproved(%#, chargen)), u(.msg, stat/set, Must be Staff or be In-Chargen), t(%qp), u(.msg, stat/set, Player '%qp' not found), t(getstat(%qp/template)), u(.msg, stat/set, No Template set; use 'stat/template <template>'), strcat(setq(n, ulocal(u(d.stat-funcs)/f.statpath-validate-name, %q1)), cor(lte(words(%qn), 1), not(%qn))), u(.msg, stat/set, cat(Can only set one stat at a time. I'm matching:, itemize(iter(%qn, ansi(n, u(v(d.stat-funcs)/f.statname.workhorse, rest(%i0, .)), n, %b, xh, %[, xh, u(v(d.stat-funcs)/f.statname.workhorse, first(%i0, .)), xh, %]),, |), |))), comp(%q2, =), if(t(setr(s, setstat(%qx/%q1, %q3, %1))), %qs, u(.msg, stat/set, Error from setstat(): %qs)), not(xor(comp(%q2, +), comp(%q2, -))), if(t(setr(s, shiftstat(%qx/%q1, %q2%q3, %1))), %qs, u(.msg, stat/set, Error from shiftstat(): %qs)), u(.msg, stat/set, I couldn't tell what you typed. The format is: 'stat/set <target>/<stat> <operator> <value>')))

&f.stat/offset [v(d.ss)]=u(f.stat/set, %0, offset)

&f.stat/override [v(d.ss)]=u(f.stat/set, %0, override)

think Entry complete.
