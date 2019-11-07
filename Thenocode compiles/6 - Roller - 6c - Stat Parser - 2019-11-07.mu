/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/6%20-%20Roller/6c%20-%20Stat%20Parser.txt

Compiled 2019-11-07

*/

think Entering 15 lines.

&f.registers.output-add [v(d.nr)]=setq(o, strcat(%qo, `, if(comp(%1,), %1, +), if(strmatch(%2, nostat), ansi(xh, %[%0%]), %0)))

&f.registers.dice-add [v(d.nr)]=setq(d, add(%qd, %0))

&f.registers.error-add [v(d.nr)]=setq(e, %qe`%0)

&f.registers.extendednum-add [v(d.nr)]=setq(n, add(%qn, %0))

&f.stat-check.health [v(d.nr)]=if(cand(not(u(f.hasswitch?, nowounds)), lt(setr(0, ladd(u(.value_full, %0, health.penalty), .)), 0)), strcat(u(f.registers.output-add, [abs(%q0)] %(wounds%), -), u(f.registers.dice-add, %q0)))

&f.stat-check.stats [v(d.nr)]=iter(edit(%1, -%b, -, -, +-), case(1, u(f.stat-check.number, %i0), null(number), strcat(setq(1, u(.sign, %i0)), setq(0, trim(case(%q1, -, rest(%i0, -), %i0))), setq(2, if(comp(%q0,), u(.statpath, %q0, %0), setq(0, %b))), u(f.stat-check.invalid-trait, %q0, %q1, %q2)), null(invalid), u(f.stat-check.trait, %0, %q0, %q1, %q2), null(check the stat)), +, @@)

&f.stat-check.number [v(d.nr)]=if(isint(%0), strcat(u(f.registers.dice-add, %0), u(f.registers.output-add, abs(%0), u(.sign, %0)), 1))

&f.stat-check.invalid-trait [v(d.nr)]=if(not(%2), strcat(u(f.registers.output-add, %0, %1, nostat), 1))

&f.stat-check.trait [v(d.nr)]=if(u(f.stat-check.skill, %0, %1, %2, %3), 1, udefault(f.stat-check.trait.[u(.class, %3)], u(f.registers.error-add, Trait class not recognized), %0, %1, %2, u(.statname, rest(%3, .)), u(.value_full, %0, %3)))

&f.stat-check.trait.numeric [v(d.nr)]=strcat(u(f.registers.dice-add, mul(ladd(%4, .), case(%2, -, -1, 1))), u(f.registers.output-add, %3, %2), u(f.registers.extendednum-add, mul(ladd(%4, .), case(%2, -, -1, 1))), 1)

&f.stat-check.trait.string [v(d.nr)]=strcat(u(f.registers.output-add, %3, %2, nostat), 1)

&f.stat-check.trait.list [v(d.nr)]=strcat(u(f.registers.output-add, %2, %3, nostat), 1)

&f.stat-check.skill [v(d.nr)]=if(strmatch(%3, skill.*), strcat(setq(4, elements(%3, 1 2, .)), setq(5, u(.value_full, %0, %q4)), setq(6, rest(rest(%3, .), .)), setq(7, ladd(iter(edit(%q6, %b, _), u(.value_full, %0, %q4.%i0), .))), case(1, u(f.stat-check.skill.untrained, %0, %q4, %q5, %q6, %q7, %2), 1, u(f.stat-check.skill.trained, %0, %q4, %q5, %q6, %q7, %2), 1, u(f.registers.error-add, Failed at Stat-Check Skill))))

&f.stat-check.skill.untrained [v(d.nr)]=if(cand(not(%2), not(u(f.hasswitch?, trained))), strcat(setq(6, case(1, u(.hastag?, %1, physical.social, or), -1, u(.hastag?, %1, mental), -3, -99)), setq(7, %q6), setq(8, u(.statname, rest(%1, .))), setq(9, u(.statname, %3)), case(1, not(%3), strcat(u(f.registers.dice-add, %q7), setq(0, [abs(%q7)] [lcstr(%(untrained %q8%))]), setq(1, u(.sign, mul(%q7, case(%5, -, -1, 1)))), setq(2,)), t(%4), strcat(setq(7, ladd(%q7.%4, .)), setq(0, [abs(%q7)] [lcstr(%(untrained %q8.%q9%))]), setq(1, u(.sign, mul(%q7, case(%5, -, -1, 1)))), setq(2,), u(f.registers.extendednum-add, ladd(%4, .))), strcat(setq(7,), setq(0, %q8.%q9), setq(1, %5), setq(2, nostat))), u(f.registers.output-add, %q0, %q1, %q2), 1))

&f.stat-check.skill.trained [v(d.nr)]=strcat(case(1, not(%3), strcat(setq(6, %2), setq(7, u(.statname, rest(%1, .))), setq(8,)), t(%4), strcat(setq(6, ladd(%2.%4, .)), setq(7, [u(.statname, rest(%1, .))].[u(.statname, %3)]), setq(8,)), strcat(setq(6, 0), setq(7, [u(.statname, rest(%1, .))].[u(.statname, %3)]), setq(8, nostat))), u(f.registers.output-add, %q7, %5, %q8), if(t(%q6), strcat(u(f.registers.dice-add, %q6), u(f.registers.extendednum-add, %q6))), 1)

think Entry complete.
