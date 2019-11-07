/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/4%20-%20XP%20and%20Costs/4c3%20-%20XP%20Unspend.txt

Compiled 2019-11-07

*/

think Entering 12 lines.

&c.xp/unspend [v(d.xpas)]=$^\+?xp/unspend(.*)$:@assert isstaff(%#, wizard)={@pemit %#=u(.msg, xp/unspend, Wizard only)}; @assert sql(select 1)={@pemit %#=u(.msg, xp/unspend, SQL connection is down%; unspend not processed)}; think strcat(entry num:, setr(e, first(%1)), %r, reason:, setr(r, trim(rest(%1, for))), %r,); @assert cand(isint(%qe), gt(%qe, 0))={@pemit %#=u(.msg, xp/unspend, Entry num must be postitive integer)}; @assert strlen(%qr)={@pemit %#=u(.msg, xp/unspend, Must include a reason)}; think strcat(sql log:, setr(l, sql(u(sql.select.entry_num, %qe), `, |)), %r, target objid:, setr(o, elements(%ql, 3, |)), %r, target dbref:, setr(d, first(%qo, :)), %r, unspent?:, setr(0, sql(u(sql.select.unspend.check, %qe))), %r,); @assert strlen(%ql)={@pemit %#=u(.msg, xp/unspend, No such entry number found)}; @assert not(strmatch(%ql, #-*))={@pemit %#=u(.msg, xp/unspend, Initial SQL query failed - please contact a coder)}; @assert cand(isdbref(%qd), strmatch(%qo, u(.objid, %qd)))={@pemit %#=u(.msg, xp/unspend, Target no longer exists)}; @assert not(%q0)={@pemit %#=u(.msg, xp/unspend, This has already been unspent in 'xp/log %q0');}; think strcat(action:, %b, setr(a, elements(%ql, 7, |)), %r, xp type:, %b, setr(t, elements(%ql, 12, |)), %r,); @assert cor(strmatch(%qa, spend), strmatch(%qa, freebie))={@pemit %#=u(.msg, xp/unspend, Action is '%qa'%; must be 'spend' or 'freebie')}; @assert strlen(setinter(%qt, v(d.unspend.allowed_types)))={@pemit %#=u(.msg, xp/unspend, XP type is '%qt'%; must be [itemize(iter(v(d.unspend.allowed_types), '%i0'),, or)])}; think strcat(xp (beats) spent:, setr(s, elements(%ql, 6, |)), %r, current beats:, setr(b, get(%qd/_special.beats.%qt)), %r, changed traits?:, setr(z, t(elements(%ql, 10, |))), %r, stat category:, setr(1, elements(%ql, 9, |)), %r, stat name:, setr(2, elements(%ql, 10, |)), %r, statpath:, setr(p, %q1.%q2), %r, stat class:, setr(c, ulocal(v(d.sfp)/f.get-class, %qp)), %r, logged value:, setr(v, elements(%ql, 11, |)), %r, current value:, setr(x, ulocal(.value, %qd, %qp)), %r, modified value:, setr(m, udefault(f.xp/unspend.%qc, #-1 I don't know how to unspend that kind of stat, %qx, %qv, elements(%ql, 13, |))), %r,); @assert not(strmatch(%qm , #-*))={@pemit %#=u(.msg, xp/unspend, rest(%qm));}; @pemit %#=if(t(%qz), u(display.unspend.stat), u(display.unspend.nostat));think strcat(start:, u(f.transaction.begin), %r, log entry:, setr(3, sql(u(sql.insert.unspend.log, %qd, %#, %qt, %qs, %qp, u(f.sql.escape, %qr), %qm, %qv))), %r, reference:, setr(4, if(not(strmatch(%q3, #-*)), sql(u(sql.insert.unspend.reference, %qe)), #-1 log entry failed)), %r, commit:, u(f.transaction.end), %r,); @break strmatch(%q3, #-*)={@pemit %#=u(.msg, xp/unspend, Error logging unspend%; unspend canceled)}; think strcat(set beats:, setr(5, set(%qd, _special.beats.%qt:[cat(first(%qb), add(rest(%qb), %qs))])), %r,); @if strmatch(%q5, #-*)={@pemit %#=u(.msg, xp/unspend, I tried to '&_special.beats.%qt %qd=[cat(first(%qb), add(rest(%qb), %qs))]' %([name(%qd)]%) but an error ocurred. Please set this properly or this character will not have the refund as recorded.)}; think if(t(%qz), strcat(set trait:, setr(6, setstat(%qd/[rest(%qp, .)], %qm)), %r,));@if cand(t(%qz), strmatch(%q6, #-*))={@pemit %#=u(.msg, xp/unspend, I tried to 'setstat %qd/[rest(%qp, .)]=%qm', but I got the message: [rest(%q6)]. Please set this properly or this character will still have their refunded stat.)};

@set v(d.xpas)/c.xp/unspend=regex

@set v(d.xpas)/c.xp/unspend=no_parse

&display.unspend.stat [v(d.xpas)]=strcat(header(Unspend: [statname(%q2)] %[[capstr(%q1)]%], width()), %r, ansi(h, statname(%q2)), : '%qx' -> ', udefault(display.xp/unspend.%qc, %qm, %qx, %qm), ', %r%r, Refunding, %b, case(%qa, freebie, no Exp %(freebie%), strcat(div(%qs, v(d.beat-to-exp)), %b, if(not(strmatch(%qt, normal)), %qt%b), Exp, %b, %(, u(.plural, floor(%qs), Beat, Beats), %),)), %b, if(strmatch(%qd, %#), you, to [name(%qd)]), %b, for reason '%qr', %r, footer(%qe, width()))

&display.unspend.nostat [v(d.xpas)]=strcat(header(Unspend Without Stat, width()), %r, Refunding, %b, div(%qs, v(d.beat-to-exp)), %b, if(not(strmatch(%qt, normal)), %qt%b), Exp, %b, %(, u(.plural, floor(%qs), Beat, Beats), %), %b, if(strmatch(%qd, %#), you, to [name(%qd)]), %b, for reason '%qr', %r, footer(%qe, width()))

&d.unspend.allowed_types [v(d.xpas)]=normal story

&f.xp/unspend.numeric [v(d.xpas)]=if(strmatch(add(%0, 0), add(%1, 0)), trim(%2, 0, l), #-1 Current value different than added value)

&f.xp/unspend.list [v(d.xpas)]=if(t(match(%0, %1, .)), !%1, #-1 Added value does not exist in current list)

&display.xp/unspend.list [v(d.xpas)]=ldelete(%0, match(%0, rest(%1, !), .), .)

&sql.insert.unspend.log [v(d.xpas)]=INSERT INTO xp_log (target_objid, target_name, enactor_objid, enactor_name, xp_type, xp_amt, trait_category, trait_name, trait_value, trait_value_old, action, reason) VALUES ('[u(.objid, %0)]', '[u(f.sql.escape, name(%0))]', '[u(.objid, %1)]', '[u(f.sql.escape, name(%1))]', '%2', %3, '[lcstr(first(%4, .))]', '[lcstr(rest(%4, .))]', '%6', '%7', 'unspend', '%5')

&sql.insert.unspend.reference [v(d.xpas)]=INSERT INTO xp_log_unspend (entry_num_spend, entry_num_unspend) VALUES (%0, LAST_INSERT_ID())

&sql.select.unspend.check [v(d.xpas)]=SELECT entry_num_unspend FROM xp_log_unspend WHERE entry_num_spend=%0

think Entry complete.
