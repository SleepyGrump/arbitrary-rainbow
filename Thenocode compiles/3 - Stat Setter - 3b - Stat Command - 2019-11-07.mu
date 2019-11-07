/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/3%20-%20Stat%20Setter/3b%20-%20Stat%20Command.txt

Compiled 2019-11-07

*/

think Entering 5 lines.

&c.stat [v(d.ss)]=$^\+?stat(.*)$:@pemit %#=[setq(0, %1)][switch(strtrunc(%q0, 1), null(null), u(f.stat-default), /, u(f.stat-switch, after(first(%q0), /), rest(%q0)), %b, u(f.stat-specific, trim(%q0)), u(.msg, stat, Command is 'stat%[/<switch>%] %[<other stuff>%]'))]

@set [v(d.ss)]/c.stat=regex

&f.stat-switch [v(d.ss)]=ifelse(setr(0, grab(lattr(%!/f.stat/*), f.stat/%0*)), u(%q0, %1), No such switch for 'stat'. Valid switches are: [itemize(lcstr(iter(lattr(%!/f.stat/*), after(%i0, /))))])

&f.stat-default [v(d.ss)]=u(.msg, stat, The command needs more input; try 'stat <stat name>')

&f.stat-specific [v(d.ss)]=u(f.stat/values, %0)

think Entry complete.
