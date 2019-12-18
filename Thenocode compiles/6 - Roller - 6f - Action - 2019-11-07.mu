/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/6%20-%20Roller/6f%20-%20Action.txt

Compiled 2019-11-07

*/

think Entering 5 lines.

&c.action [v(d.nr)]=$^\+?actions?(.*)$:@pemit %#=strcat(setq(0, %1), setq(s, first(rest(%q0, /))), setq(r, if(t(%qs), rest(%q0), trim(%q0))), setq(n, first(%qr)), setq(r, rest(%qr)), setq(a, grab(sort(lattr(%#/action.*)), action.%qn*)), case(0, t(%q0), u(f.action.list, %#), t(%qn), u(.msg, Action, Action name not entered), t(%qa), u(.msg, Action, Action '%qn' not found), u(f.action.workhorse, %#, %qa, %qs, %qr)))

@set [v(d.nr)]/c.action=regex

&f.action.workhorse [v(d.nr)]=strcat(setq(e, objeval(%0, u(%0/%1))), setq(s, first(rest(%qe, /))), setq(r, trim(before(if(t(%qs), rest(%qe), %qe), =))), if(t(%qs), setq(s, /%qs)), setq(r, %qr %3), setq(s, [if(t(%2), /%2)]%qs), case(0, t(%qe), u(Action, Action has no content%, so use roll), [setq(e,)][trigger(tr.action, %0, %qr, %qs)]))

&tr.action [v(d.nr)]=@force %0={roll%2 %1}

&f.action.list [v(d.nr)]=strcat(setq(a, lattr(%0/action.*)), if(t(%qa), strcat(header(Actions on [name(%0)]), %r, iter(%qa, strcat(%b, %b, ansi(h, capstr(lcstr(rest(%i0, .)))), :, %b, get(%0/%i0)), %r), %r, footer(words(%qa)),), msg(Action, No actions on [name(%0)])))

think Entry complete.
