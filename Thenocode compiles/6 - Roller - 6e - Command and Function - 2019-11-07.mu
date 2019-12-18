/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/6%20-%20Roller/6e%20-%20Command%20and%20Function.txt

Compiled 2019-11-07

*/

think Entering 9 lines.

&c.roll [v(d.nr)]=$^\+?roll(/.+?)? (.+?)(%=.*)?$:@assert cor(isstaff(%#), not(isapproved(%#, chargen)))={@pemit %#=[u(.alert, roll)] You are 'in chargen', and so cannot use this command. If you need something on your sheet rolled, please contact a staffer.}; @pemit %#=strcat(setq(7, squish(edit(strip(%2, %%%,;<>%[%]), %(, %b%())), null(u(f.roll.workhorse, %q7, %#, remove(%1, blind, /, /))), setq(9, u(f.build.to-list, %#, trim(rest(%3, =)), %1)), if(t(words(%qe, `)), cat(u(.alert, roll), u(display.roll-items, %qe)), u(display.roll-to-[first(%q9, |)], %#, rest(%q9, |))))

@set v(d.nr)/c.roll=regex

&f.build.to-list [v(d.nr)]=localize(strcat(setq(0, iter(%0 %1, if(setr(1, pmatch(%i0)), %q1))), case(1, strmatch(%1, job *), job|%1, cand(t(%1), match(%2, blind, /)), strcat(blind|, setdiff(%q0, %0)), t(%1), strcat(private|, setunion(%q0,)), strcat(public|, lcon(loc(%0), connect)))))

&f.roll [v(d.nr)]=strcat(setq(d,), setq(a,), setq(e,), setq(o,), setq(s,), setq(z,), setq(r,), setq(p,), setq(t,), setq(n,), setq(0, squish(edit(strip(%0, %%%,;<>%[%]), %(, %b%())), setq(1, u([u(d.stat-setter)]/f.find-sheet, pmatch(%1))), setq(2, if(words(trim(%2, l, /), /), /[trim(%2, l, /)])), case(0, t(words(%q0)), #-1 Nothing to Roll, t(%q1), %q1, cor(isstaff(%#), strmatch(%#, u([u(d.stat-setter)]/f.find-sheet, %#))), #-1 Staff Only, u(f.roll.workhorse, %q0, %q1, %q2)))

&f.roll.workhorse [v(d.nr)]=strcat(setq(z, u(f.switch.name-complete, %2)), setq(d, 0), setq(a, 10), setq(n, 0), setq(t,), setq(c,), setq(s, Standard), u(f.stat-check.stats, %1, %0), iter(edit(lcstr(lattr(%!/f.roll/*)), f.roll/,), if(u(f.hasswitch?, %i0), u(f.roll/%i0, u(f.getswitch, %i0), %#)),, @@), u(f.stat-check.health, %1), if(lte(%qd, 0), setq(s, Chance)), if(t(words(%qe, `)), strcat(#-1, |, u(display.roll-items, %qe), |, null(null)), strcat(setq(a, case(1, u(f.hasswitch?, weakness), 11, strmatch(%qs, chance), 10, %qa)), setq(n, case(1, u(f.hasswitch?, extended), %qn , u(f.hasswitch?, target), null(null), 1)), setq(r, trim(u(f.roll.workhorse.recurisve, 0, 0), b, |)), u(f.roll-success-interpreter), setq(c, trim(%qc)), strcat(%qc, |, %q2, |, trim(%qr, b, |)))))

@fo me=&ufunc/privileged.roll [v(d.nr)]=u\%( [num(nr)]/f.roll, \\\%0, \\\%1, \\\%2 \%)

@startup [v(d.nr)]=@dolist lattr(%!/ufunc.*)=@function/preserve [rest(##, .)]=%!/##; @dolist lattr(%!/ufunc/privileged.*)=@function/preserve/privileged [rest(##, .)]=%!/##

@trig v(d.nr)/startup

&f.roll.workhorse.recurisve [v(d.nr)]=if(cand(cor(not(%qn), lt(%0, %qn)), cor(not(%qt), lt(%1, %qt)), cor(t(%qt), t(%qn), lt(%0, 1))), strcat(setr(0, ulocal(f.roller, if(lte(%qd, 0), 1, %qd), %qa, if(u(f.hasswitch?, rote), 8))), |, setq(1, u(f.successes.%qs, %q0, 8)), setq(c, %qc %q1), u(f.roll.workhorse.recurisve, inc(%0), add(%q1, %1))),)

think Entry complete.
