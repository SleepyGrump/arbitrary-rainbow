/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/4%20-%20XP%20and%20Costs/4c4%20-%20XP%20Unaward.txt

Compiled 2019-11-07

*/

think Entering 6 lines.

&c.xp/unaward [v(d.xpas)]=$^\+?xp/unaward(.+)?$:@assert isstaff(%#, wizard)={@pemit %#=u(.msg, xp/unward, Wizard only)}; @assert sql(select 1)={@pemit %#=u(.msg, xp/unaward, SQL connection is down%; unaward not processed)}; think strcat(entry num:, setr(e, first(%1)), %r, reason:, setr(r, trim(rest(%1, for))), %r,); @break strmatch(%qr, *[lit(%r)]*)={@pemit %#=u(.msg, xp/unaward, We are not allowing multi-line reasons)}; @assert cand(isint(%qe), gt(%qe, 0))={@pemit %#=u(.msg, xp/unaward, Entry num must be postitive integer)}; @assert strlen(%qr)={@pemit %#=u(.msg, xp/unaward, Must include a reason)}; think strcat(sql log:, setr(l, sql(u(sql.select.entry_num, %qe), `, |)), %r, target objid:, setr(o, elements(%ql, 3, |)), %r, target dbref:, setr(d, first(%qo, :)), %r, amt to unaward:, setr(s, elements(%ql, 6, |)), %r, unawarded?:, setr(0, sql(u(sql.select.unaward.check, %qe))), %r,); @assert strlen(%ql)={@pemit %#=u(.msg, xp/unaward, No such entry number found)}; @assert not(strmatch(%ql, #-*))={@pemit %#=u(.msg, xp/unaward, Initial SQL query failed - please contact a coder)}; @assert cand(isdbref(%qd), strmatch(%qo, u(.objid, %qd)))={@pemit %#=u(.msg, xp/unaward, Target no longer exists)}; @assert not(%q0)={@pemit %#=u(.msg, xp/unaward, This has already been unawarded in 'xp/log %q0');}; think strcat(action:, %b, setr(a, elements(%ql, 7, |)), %r, xp type:, %b, setr(t, elements(%ql, 12, |)), %r,); @assert strmatch(%qa, gain)={@pemit %#=u(.msg, xp/unaward, Action is '%qa'%; must be 'gain')}; @assert strmatch(%qt, normal)={@pemit %#=u(.msg, xp/unaward, XP type is '%qt'%; must be 'normal')}; think strcat(current beats:, setr(b, get(%qd/_special.beats.%qt)), %r,); @pemit %#=strcat(header(strcat(Unaward: Entry %qe, if(strlen(setr(z, elements(%ql, 8, |))), %b%(%qz%))), width()), %r, Removing, %b, case(%qa, gain, strcat(u(.plural, floor(%qs), Beat, Beats), if(gt(div(%qs, v(d.beat-to-exp)), 0), strcat(%b, %(, div(%qs, v(d.beat-to-exp)), %b, Exp, %))),)), %b, if(strmatch(%qd, %#), from you, from [name(%qd)]), %b, for reason ', %qr, ', %r, footer(%qe, width())); think strcat(start:, u(f.transaction.begin), %r, log the entry:, setr(3, sql(u(sql.insert.unaward.log, %qd, %#, %qt, %qs, u(f.sql.escape, %qr)))), %r, reference:, setr(4, if(not(strmatch(%q3, #-*)), sql(u(sql.insert.unaward.reference, %qe)), #-1 log entry failed)), %r, commit:, u(f.transaction.end), %r,); @break strmatch(%q3, #-*)={@pemit %#=u(.msg, xp/unaward, Error logging unaward%; unaward canceled)}; think strcat(set beats:, setr(5, set(%qd, _special.beats.%qt:[cat(sub(first(%qb), %qs), rest(%qb))])), %r,); @break strmatch(%q5, #-*)={@pemit %#=u(.msg, xp/unaward, I tried to '&_special.beats.%qt %qd=[cat(sub(first(%qb), %qs), rest(%qb))]' %([name(%qd)]%) but an error ocurred. Please set this properly or this character will not have the unaward recorded.)}; think strcat(set beats_earned:, setr(6, set(%qd, _special.beats_earned.%qt:[sub(get(%qd/_special.beats_earned.%qt), %qs)])),)@break strmatch(%q5, #-*)={@pemit %#=u(.msg, xp/unaward, I tried to '&_special.beats_earned.%qt %qd=[sub(get(%qd/_special.beats_earned.%qt), %qs)]' %([name(%qd)]%) but an error ocurred. Please set this properly or this character will not have their spent beats counter correct.)};

@set [v(d.xpas)]/c.xp/unaward=regexp

@set [v(d.xpas)]/c.xp/unaward=no_parse

&sql.insert.unaward.log [v(d.xpas)]=INSERT INTO xp_log (target_objid, target_name, enactor_objid, enactor_name, xp_type, xp_amt, action, reason) VALUES ('[u(.objid, %0)]', '[name(%0)]', '[u(.objid, %1)]', '[name(%1)]', '%2', %3, 'unaward', '%4')

&sql.insert.unaward.reference [v(d.xpas)]=INSERT INTO xp_log_unspend (entry_num_spend, entry_num_unspend) VALUES (%0, LAST_INSERT_ID())

&sql.select.unaward.check [v(d.xpas)]=SELECT entry_num_unspend FROM xp_log_unspend WHERE entry_num_spend=%0

think Entry complete.
