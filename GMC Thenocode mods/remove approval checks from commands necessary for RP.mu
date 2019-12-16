think Entering 6 lines.

&c.init/clear init=switch(1, not(or(isstaff(%#), not(comp(%0, YES)))), If you're sure you want to clear the roster%, type +init/clear YES[oemit(%#, [alert(+init, alert)] %N may be clearing initiatives at this location.)], [setq(l, loc(%#))][monitor(+init/clear: %N at [name(loc(%#))] %([loc(%#)]%))][iter(lattr(%ql/_init.*), set(%ql, %i0:),, @@)][remit(%ql, [alert(+init)] %N clears the initiative roster in this location.)])

&c.init/set init=[setq(s, trim(before(%0, =)))][setq(i, rpad(trim(rest(%qs, /)), 2, 0))][setq(s, ulocal(f.validate.init-subject, before(%qs, /), %#))][setq(t, rest(%0, =))][setq(n, iter(rest(%qt), rest(grab(u(d.flags), %i0*:*, |), :)))][setq(t, rpad(trim(first(%qt)), 2, 0))][setq(f, setunion(%qn [extract(rest(get(loc(%#)/_init.%qs), |), 3, 1, .)],))][case(1, not(%qs), [alert(Error, alert)] [rest(%qs)]., or(gt(%qt, 99), lt(%qt, 1)), [alert(Error, alert)] New initiative must be between 1 and 99., isdbref(%qs), [setq(i, rpad(getstat(%qs/initiative), 2, 0))][ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.0, %qf)][u(f.clean-dbref, %#)][remit(loc(%#), [alert(+init)] %N directly set %oself on the initiative roster at [mul(1, %qt)].)], not(isdbref(%qs)), [ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.0, %qf)][remit(loc(%#), [alert(+init)] %N directly set "[titlestr(%qs)]" on the initiative roster at [mul(1, %qt)].)], [alert(Error, alert)] Something went wrong here - +bug it!)]

&c.init/roll init=[setq(0, edit(%0, -, +-))][setq(s, before(%q0, +))][setq(i, rpad(trim(rest(%qs, /)), 2, 0))][setq(s, ulocal(f.validate.init-subject, before(%qs, /), %#))][setq(m, ladd(edit(edit(rest(%q0, +), +, %b), -%b, %b-)))][setq(r, rand(1, 10))][setq(f, extract(rest(get(loc(%#)/_init.%qs), |), 3, 1, .))][case(1, not(%qs), [alert(Error, alert)] [rest(%qs)], or(gt(%qm, 90), lt(%qm, -90)), [alert(Error, alert)] Modifier total must be between -90 and 90, isdbref(%qs), [setq(i, rpad(getstat(%qs/initiative), 2, 0))][if(lt(setr(h, u(%qs/_health.penalty)), 0), [setq(m, add(%qm, %qh))][setq(n, health penalty applied)])][setq(t, rjust(add(%qi, %qr, %qm), 2, 0))][ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.%qm, %qf)][u(f.clean-dbref, %#)][remit(loc(%#), [alert(+init)] %N rolled %qr[if(t(%qm), %b[operand(%qm)] [abs(%qm)])]%, putting %oself on the initiative roster at [mul(1, %qt)].[if(t(%qn), %b%(%qn%))])], not(isdbref(%qs)), [setq(t, rjust(add(%qi, %qr, %qm), 2, 0))][ulocal(f.init.add.new, %qs, loc(%#), %qt%qi, %qi.%qm, %qf)][remit(loc(%#), [alert(+init)] %N rolled %qr[if(t(%qm), %b[operand(%qm)] [abs(%qm)])]%, putting "[titlestr(%qs)]" on the initiative roster at [mul(1, %qt)].)], [alert(Error, alert)] Something went wrong here - please use +bug to report it.)]

&c.init/remove init=[setq(s, ulocal(f.validate.init-subject, %0, %#))][setq(l, loc(%#))][case(0, comp(%0,), [alert(Error, alert)] Must enter name to remove., t(%qs), [alert(Error, alert)] [rest(%qs)]., hasattr(%ql, setr(a, _init.[edit(%qs, %b, _)])), [alert(Error, alert)] Subject has has no initiative to remove., not(isdbref(%qs)), [set(%ql, %qa:)][remit(%ql, [alert(+init)] %N removes %oself from the initiative roster.)], isdbref(%qs), [set(%ql, %qa:)][remit(%ql, [alert(+init)] %N removes "%qs" from the initiative roster.)], [alert(Error, alert)] An error has occurred - please report it with +bug.)]

&c.spend [v(d.psrs)]=$(?s)^\+?spend(/[^\s]+)*(.*)$:think u(f.registers.extract, %1, trim(%2)); @assert t(%qp)={@pemit %#=u(.msg, spend, I don't know '%qt');}; @assert cor(isstaff(%#), strmatch(%#, %qp))={@pemit %#=u(.msg, spend, Only staff may spend for someone else);}; @assert hasattr(%!, spend.trigger.%qw)={@pemit %#=u(.msg, spend, I don't know how to spend '[edit(%qw, _, %b)]'. I know: [itemize(edit(lcstr(lattr(%!/spend.trigger.*)), spend.trigger.,))]);}; @trigger %!/spend.trigger.%qw=%#, %qp, %qi, %qs, %qr;@set v(d.psrs)/c.spend=regexp

&c.regain [v(d.psrs)]=$(?s)^\+?regain(/[^\s]+)*(.*)$:think u(f.registers.extract, %1, trim(%2)); @assert t(%qp)={@pemit %#=u(.msg, regain, I don't know '%qt');}; @assert cor(isstaff(%#), strmatch(%#, %qp))={@pemit %#=u(.msg, regain, Only staff may regain for someone else);}; @assert hasattr(%!, regain.trigger.%qw)={@pemit %#=u(.msg, regain, I don't know how to regain '[edit(%qw, _, %b)]'. I know: [itemize(edit(lcstr(lattr(%!/regain.trigger.*)), regain.trigger.,))]);}; @trigger %!/regain.trigger.%qw=%#, %qp, %qi, %qs, %qr;@set v(d.psrs)/c.regain=regexp

think Entry complete.
