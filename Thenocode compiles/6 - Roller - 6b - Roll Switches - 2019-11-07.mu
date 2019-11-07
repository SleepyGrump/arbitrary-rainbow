/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/6%20-%20Roller/6b%20-%20Roll%20Switches.txt

Compiled 2019-11-07

NOTE: Missing end-paren on line 23 has been added.

*/

think Entering 10 lines.

&d.switch.passives [v(d.nr)]=nowound trained weakness rote blind

&d.switch.aliases [v(d.nr)]=10-again|again=10 9-again|again=9 8-again|again=8 no-again|again=no 11-again|again=no wp|willpower

&f.switch.name-complete [v(d.nr)]=localize(iter(lcstr(trim(%0, l, /)), strcat(setq(0, lcstr(sort(edit(lattr(%!/f.roll/*), F.ROLL/,)))), setq(x, before(%i0, =)), setq(y, rest(%i0, =)), case(1, t(setr(1, grab(%q0, %qx*))), /%q1[if(strlen(%qy), =%qy)], t(setr(1, grab(v(d.switch.passives), %qx*))), /%q1[if(strlen(%qy), =%qy)], t(setr(1, rest(grab(v(d.switch.aliases), %qx*|*), |))), /%q1[if(words(%qy), =%qy)])), /, @@))

&f.getswitch [v(d.nr)]=regrabi(%qz, ^%0, /)

&f.hasswitch? [v(d.nr)]=t(u(f.getswitch, %0))

&f.roll/weakness [v(d.nr)]=strcat(setq(a, 11), if(not(strmatch(%qs, chance), setq(s, Weakness))))

&f.roll/again [v(d.nr)]=strcat(setq(0, rest(%0, =)), case(1, not(t(%q0)), u(f.registers.error-add, Again type not passed.), strmatch(%q0, n*), setq(a, 11), not(and(isint(%q0), gte(%q0, 8))), u(f.registers.error-add, Again type must be integer of 8 or higher.), setq(a, %q0)))

&f.roll/extended [v(d.nr)]=strcat(setq(0, if(strmatch(%0, *=*), rest(%0, =), %qn)), setq(1, 200), case(0, cor(t(%qn), t(rest(%0, =))), u(f.registers.error-add, If there no traits in the roll%, you must use /extended=<num>), cand(isint(%q0), gt(%q0, 0)), u(f.registers.error-add, Extended roll must be an integer greater than zero), lte(%0, %q1), u(f.registers.error-add, Extended roll cannot be higher than %q1), setq(n, %q0)))

&f.roll/target [v(d.nr)]=strcat(setq(0, rest(%0, =)), setq(1, 200), case(0, cand(t(%q0), isint(%q0), gt(%q0, 0)), u(f.registers.error-add, Targeted roll must be an integer greater than zero), lte(%q0, %q1), u(f.registers.error-add, Target number cannot be higher than %q1), setq(t, %q0)))

&f.roll/willpower [v(d.nr)]=strcat(setq(0, if(strlen(rest(%0, =)), rest(%0, =), 3)), setq(1, 4), case(0, not(cor(u(f.hasswitch?, extended), u(f.hasswitch?, target))), u(f.registers.error-add, Cannot add willpower to an extended or targeted roll%; roll one at a time.), cand(isint(%q0), gt(%q0, 0)), u(f.registers.error-add, Dice for willpower must be between 2 and %q1.), lte(%q0, %q1), u(f.registers.error-add, Dice for willpower cannot be higher than %q1.), t(getstat(%1/template)), u(f.registers.error-add, Must have a template to spend willpower.), t(u(v(d.spend-regain)/f.pool.canchange, %1, willpower, -1)), u(f.registers.error-add, You don't have enough Willpower to spend.), strcat(u(f.registers.output-add, %q0 %(willpower%)), u(f.registers.dice-add, %q0), u(v(d.spend-regain)/f.pool.changestat, %1, willpower, -1))))

think Entry complete.
