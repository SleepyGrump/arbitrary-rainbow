/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/9%20-%20Critical%20Sub-Systems/9c%20-%20Spend%20and%20Regain.txt

Compiled 2019-11-07

*/

think Entering 32 lines.

@create Pool Spend Regain System <psrs>

@fo me=&d.psrs me=[search(name=Pool Spend Regain System <psrs>)]

@set Pool Spend Regain System <psrs>=safe inherit

@fo me=@parent Pool Spend Regain System <psrs>=[v(d.codp)]

&prefix.pool_spend_rules [v(d.psrs)]=spend.

&prefix.pool_regain_rules [v(d.psrs)]=regain.

&prefix.amount_calc [v(d.psrs)]=amt.

&.msg [v(d.psrs)]=ansi(xh, <%0>, n, %b%1)

&.possessive [v(d.psrs)]=strcat(%0, if(strmatch(%0, *s), ', 's))

&.plural [v(d.psrs)]=strcat(%0, %b, plural(%0, %1, %2))

&.be_quiet [v(d.psrs)]=cand(andflags(loc(%0), bB), not(elock(loc(%0)/speechlock, %0)))

&c.spend [v(d.psrs)]=$(?s)^\+?spend(/[^\s]+)*(.*)$:@assert isapproved(%#)={@pemit %#=u(.msg, spend, You must be approved);}; think u(f.registers.extract, %1, trim(%2)); @assert t(%qp)={@pemit %#=u(.msg, spend, I don't know '%qt');}; @assert cor(isstaff(%#), strmatch(%#, %qp))={@pemit %#=u(.msg, spend, Only staff may spend for someone else);}; @assert hasattr(%!, spend.trigger.%qw)={@pemit %#=u(.msg, spend, I don't know how to spend '[edit(%qw, _, %b)]'. I know: [itemize(edit(lcstr(lattr(%!/spend.trigger.*)), spend.trigger.,))]);}; @trigger %!/spend.trigger.%qw=%#, %qp, %qi, %qs, %qr;

@set v(d.psrs)/c.spend=regexp

&c.regain [v(d.psrs)]=$(?s)^\+?regain(/[^\s]+)*(.*)$:@assert isapproved(%#)={@pemit %#=u(.msg, regain, You must be approved);}; think u(f.registers.extract, %1, trim(%2)); @assert t(%qp)={@pemit %#=u(.msg, regain, I don't know '%qt');}; @assert cor(isstaff(%#), strmatch(%#, %qp))={@pemit %#=u(.msg, regain, Only staff may regain for someone else);}; @assert hasattr(%!, regain.trigger.%qw)={@pemit %#=u(.msg, regain, I don't know how to regain '[edit(%qw, _, %b)]'. I know: [itemize(edit(lcstr(lattr(%!/regain.trigger.*)), regain.trigger.,))]);}; @trigger %!/regain.trigger.%qw=%#, %qp, %qi, %qs, %qr;

@set v(d.psrs)/c.regain=regexp

&spend.trigger.willpower [v(d.psrs)]=@assert t(setr(e, u(f.pool.canchange, %1, willpower, -1)))={@pemit %0=u(.msg, willpower/spend, rest(%qe))}; @assert t(setr(e, u(f.pool.changestat, %1, willpower, -1)))={u(.msg, willpower/spend, rest(%qe))}; think e: [setr(e, u(display.number, %0, %1, willpower, spend, 1,, %4))]; @eval u(f.announcement, %0, %1, spend, %qe);

&f.announcement [v(d.psrs)]=case(1, cand(u(.be_quiet, %0), strmatch(%0, %1)), pemit(%0, u(.msg, %2, %3 %(not announced%)))strmatch(%0, %1), remit(loc(%0), u(.msg, %2, %3)), pemit(%0 %1, u(.msg, %2, %3 %(sent to [name(%1)]%))));

&regain.methods.willpower [v(d.psrs)]=|all|rest

&f.match_method [v(d.psrs)]=localize(strcat(setq(x, grab(sort(u(%1.methods.%2, %3), a, |), %3*, |)), if(strlen(%qx), %qx, %3)))

&amt.regain.rest.default [v(d.psrs)]=1

&regain.trigger.willpower [v(d.psrs)]=think strcat(m:, %b, setr(m, u(f.match_method, %1, regain, willpower, %2)), %r, a:, %b, setr(a, u(amt.regain, %1, willpower, %qm)), %r,); @assert strlen(%qm)={@pemit %0=u(.msg, willpower/regain, I could not find the method '%2')}; @assert t(%qa)={@pemit %0=u(.msg, willpower/regain, rest(%qa))}; @assert t(setr(e, u(f.pool.canchange, %1, Willpower, %qa)))={@pemit %0=u(.msg, willpower/regain, rest(%qe))}; @assert t(setr(e, u(f.pool.changestat, %1, willpower, %qa)))={@pemit %0=u(.msg, willpower/regain, rest(%qe))}; think e: [setr(e, u(display.number, %0, %1, willpower, regain, %qa, %qm, %4))]; @eval u(f.announcement, %0, %1, regain, %qe);

&display.number [v(d.psrs)]=strcat(name(%0), %b, %3s, %b, if(cand(strlen(%5), not(strmatch(%4, %5))), [titlestr(%5)] %([u(.plural, %4, point, points)]%), u(.plural, %4, point, points)), %b, of, %b, if(strmatch(%0, %1), poss(%1), u(.possessive, name(%1))), %b, titlestr(%2), %b, pool, if(strlen(%6), %, for %6), .)

&display.roll [v(d.psrs)]=strcat(name(%0), %b, if(gte(%4, 0), %2s %4, critically fails %2ing), %b, capstr(%1), %b, by, %b, titlestr(%3), if(strlen(%5), %, using switches [itemize(%5, /, &)]), if(strlen(%6), %, for %6), .)

&f.pool.changestat [v(d.psrs)]=shiftstat(%0/%1, %2, offset)

&f.registers.extract [v(d.psrs)]=strcat(s:, %b, setr(s, trim(%0)), %r, i:, %b, setr(i, trim(before(after(%1, =), %bfor%b))), %r, r:, %b, setr(r, trim(after(%1, %bfor%b))), %r, setq(w, edit(trim(before(before(%1, %bfor%b), =)), %b, _)), t:, %b, setr(t, if(strlen(rest(%qw, /)), first(%qw, /), %#)), %r, p:, %b, setr(p, pmatch(%qt)), %r, w:, %b, setr(w, if(strlen(rest(%qw, /)), rest(%qw, /), %qw)), %r,)

&f.pool.canchange [v(d.psrs)]=localize(strcat(setq(s, getstat(%0/%1)), setq(m, getstat(%0/%1_maximum)), setq(t, add(%qs, %2)), case(0, isint(%2), #-1 May only change by an integer, neq(%2, 0), #-1 Cannot change by zero, isnum(%qm), #-1 Do not appear to be changing a pool, gte(%qt, 0), #-1 Pool cannot be negative, lte(%qt, %qm), #-1 Pool cannot be greater than its maximum, 1)))

&amt.regain [v(d.psrs)]=case(1, isint(%2), udefault(amt.regain.numeric.%1, u(amt.regain.numeric.default, %0, %1, %2), %0, %1, %2), t(lattr(%!/amt.regain.*)), udefault(amt.regain.%2.%1, u(amt.regain.%2.default, %0, %1, %2), %0, %1, %2), #-1 Regain amount rules for '%2' not found)

&amt.regain.numeric.default [v(d.psrs)]=if(cand(isint(%2), gt(%2, 0)), %2, #-1 Value must be a positive integer)

&amt.regain.all.default [v(d.psrs)]=mul(getstat(%0/%1, offset), -1)

&amt.spend [v(d.psrs)]=case(1, isint(%2), udefault(amt.spend.numeric.%1, u(amt.spend.numeric.default, %0, %1, %2), %0, %1, %2), t(lattr(%!/amt.spend.*)), udefault(amt.spend.%2.%1, u(amt.spend.%2.default, %0, %1, %2), %0, %1, %2), #-1 Spend amount rules for '%2' not found)

&amt.spend.numeric.default [v(d.psrs)]=if(cand(isint(%2), gt(%2, 0)), mul(%2, -1), #-1 Value must be a positive integer)

&amt.spend.all.default [v(d.psrs)]=mul(getstat(%0/%1), -1)

think Entry complete.
