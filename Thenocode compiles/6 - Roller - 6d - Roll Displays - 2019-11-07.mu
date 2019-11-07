/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/6%20-%20Roller/6d%20-%20Roll%20Displays.txt

Compiled 2019-11-07

*/

think Entering 14 lines.

&display.list [v(d.nr)]=iter(rest(%0, .), %i0, ., .)

&display.roll-items [v(d.nr)]=iter(trim(trim(%0, b, `), b, +), edit(trim(%i0, b), +, %b+%b, -, %b-%b), `, @@)

&display.colorize.dice [v(d.nr)]=localize(strcat(setq(c, strmatch(%qs, chance)), setq(w, u(f.hasswitch?, weakness)), setq(r, u(f.hasswitch?, rote)), iter(%0, iter(%i0, case(1, u(f.successes.standard, %i0, 8), %xu%xc%i0%xn, cand(eq(%i0, 1), %qc), %xr%i0%xn, cand(%qw, eq(%i0, 1), cor(not(%qr), gt(inum(1), 1))), %xr%i0%xn, %i0)), :, :)))

&display.roll-output [v(d.nr)]=localize(strcat(setq(w, width(%2)), u(f.roll-success-interpreter), if(lte(%qd, 0), setq(d, 0)), if(gte(%qa, 11), setq(a, No)), header(strcat(%N rolls %qd Dice, if(strmatch(%qs, Standard),, %b- %qs), if(strmatch(%qa, 10),, %b- %qa-Again)), %qw), %r, %b Roll:%b, trim(wrap(%q2, sub(%qw, 6), l,,, 8), r, %b), %r, case(1, strmatch(%q1, Extended), u(display.roll-output.extended), u(display.roll-output.single)), %r, footer(strcat(trim(lcstr(before(%q1, %())), if(t(%1), %b(%1))), %qw)))

&display.roll-output.extended [v(d.nr)]=localize(strcat(%b Results:%b, ladd(%qc), %b, total successes, %r%r, iter(%qr, strcat(%b Successes:, %b, setr(x, max(extract(%qc, inum(), 1), -1)), %b, --, %b, u(display.interpret-roll-output, %i0), switch(%qx, -1, %b%(dramatic failure%))), |, %r)))

&display.roll-output.single [v(d.nr)]=cat(%b, Result:, trim(wrap(%q1 -- [u(display.interpret-roll-output, %qr)], sub(width(%#), 10), l,,, 10), r, %b))

&display.interpret-roll-output [v(d.nr)]=localize(strcat(setq(9, u(display.colorize.dice, %0)), %(, trim(elements(%q9, 1 3, :,)), if(t(setr(8, trim(elements(%q9, 2, :,)))), %, Rote: %q8), %)))

&display.roll-to-public [v(d.nr)]=iter(%1, pemit(%i0, u(display.roll-output, %0, public, %i0)),, @@)

&display.roll-to-private [v(d.nr)]=iter(%1, pemit(%i0, u(display.roll-output, %0, to [iter(%1, name(%i0),, %,%b)], %i0)))

&display.roll-to-blind [v(d.nr)]=strcat(u(display.roll-to-private, %0, %1), u(display.blind-roller-output, %1))

&display.blind-roller-output [v(d.nr)]=squish(strcat(u(.alert, roll/blind), %b, You roll, %b, itemize(cat(if(not(strmatch(%qs, standard)), lcstr(%qs)), if(or(setr(0, u(f.hasswitch?, target)), setr(1, u(f.hasswitch?, extended))), extended)),, &), %b, if(cor(%q0, %q1), strcat(%(, if(%q0, target %qt), if(cand(%q0, %q1), %,%b), if(%q1, %qn rolls), %))), %b, ', trim(u(display.roll-items, %qo)), ', setq(0, trim(edit(rest(%qz, /), grab(%qz, extended*, /), null(null), grab(%qz, target*, /), null(null)), b, /)), if(strlen(%q0), strcat(%, using, %b, iter(%q0, '%i0', /, %,%b), %b)), %b, to, %b, iter(%0, name(%i0),, %,%b)))

&display.roll-to-job [v(d.nr)]=case(0, t(setr(9, ulocal(f.has_job_access, rest(%1), %0))), u(.msg, roll, You can't roll to that job because [rest(%q9)]), strcat(ulocal(display.roll-output, %0, to %1), trigger(%va/trig_add, %q9, %r[ulocal(display.roll-output, %0, to %1, %!)], %0, ADD), trigger(%va/trig_broadcast, %q9, Roll added to [lcstr(%1)] by [name(%0)].)))

&f.has_job_access [v(d.nr)]=localize(case(0, not(u(%va/FN_GUEST, %1)), #-1 This command is not available to guests, isdbref(setr(0, u(%va/FN_FIND-JOB, %0))), #-1 That is an invalid job number, cor(cand(u(%va/IS_PUBLIC, %q0), match(get(%q0/OPENED_BY), %1)), u(%va/FN_MYACCESSCHECK, parent(%q0), %1, %q0),), #-1 [name(%q0)] is not yours%; you can only modify your own jobs, not(u(%va/FN_HASATTR, %q0, LOCKED)), #-1 That job is locked and cannot be changed at this time, %q0))

&f.roll-success-interpreter [v(d.nr)]=strcat(setq(1, if(gt(words(%qr, |), 1), Extended, switch(ladd(%qc), <0, Dramatic Failure, <1, Failure, <5, Success %(%qc%), Exceptional Success! %(%qc%)))), setq(2, trim(u(display.roll-items, %qo))))

think Entry complete.
