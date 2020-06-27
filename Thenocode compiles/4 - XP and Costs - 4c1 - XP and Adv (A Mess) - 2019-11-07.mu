/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/4%20-%20XP%20and%20Costs/4c1%20-%20XP%20and%20Adv%20(A%20Mess).txt

Compiled 2019-11-07

Added escaping to the spend and award insert. It allows stat names like Helios' Judgement and reasons like 'That's crazy'.

Changed all "reason" SELECT calls that output to a list to SELECT "SUBSTRING(reason, 1, 26)" because my players are spammy bastiges.

*/

think Entering 7 lines.

&prefix.timers [v(d.xpcd)]=timer.

&sql.insert.daily-auto [v(d.xpas)]=INSERT INTO xp_log (target_objid, target_name, enactor_objid, enactor_name, xp_type, xp_amt, action, reason) VALUES ('[u(.objid, %0)]', '[u(f.sql.escape, name(%0))]', '[u(.objid, %1)]', 'Auto-Experience System <xpas>', '%2', %3, 'auto', 'Daily Auto')

&sql.insert.award [v(d.xpas)]=INSERT INTO xp_log (target_objid, target_name, enactor_objid, enactor_name, xp_type, xp_amt, action, reason) VALUES ('[u(.objid, %0)]', '[u(f.sql.escape, name(%0))]', '[u(.objid, %1)]', '[u(f.sql.escape, name(%1))]', '[u(f.sql.escape, %2)]', [u(f.sql.escape, %3)], 'gain', '[u(f.sql.escape, %4)]')

&sql.select.type-character [v(d.xpas)]=SELECT * FROM (SELECT entry_num, enactor_objid, enactor_name, log_time, xp_amt, action, SUBSTRING(reason, 1, 26), trait_name, trait_value FROM xp_log WHERE target_objid='[u(.objid, %0)]' AND xp_type='[lcstr(%1)]' [case(%2, all, null(show all), null(null), AND action!='auto', AND action='%2')] [if(strlen(%3), AND trait_name LIKE '[u(f.sql.escape, edit(%3, %b, _))]%%%%')] ORDER BY entry_num DESC LIMIT 25) t ORDER BY entry_num

&sql.select.entry_num [v(d.xpas)]=SELECT enactor_objid, enactor_name, target_objid, target_name, log_time, xp_amt, action, reason, trait_category, trait_name, trait_value, xp_type, trait_value_old FROM xp_log WHERE entry_num=%0

&sql.insert.spend [v(d.xpas)]=INSERT INTO xp_log (target_objid, target_name, enactor_objid, enactor_name, xp_type, xp_amt, trait_category, trait_name, trait_value, trait_value_old, action, reason) VALUES ('[u(.objid, %0)]', '[u(f.sql.escape, name(%0))]', '[u(.objid, %1)]', '[u(f.sql.escape, name(%1))]', '[u(f.sql.escape, %2)]', %3, '[u(f.sql.escape, lcstr(first(%4, .)))]', '[u(f.sql.escape, lcstr(rest(%4, .)))]', '[u(f.sql.escape, %6)]', '[u(f.sql.escape, %7)]', [if(eq(%3, 0), 'freebie', 'spend')], '[u(f.sql.escape, %5)]')

&sql.select.last-touched [v(d.xpas)]=SELECT MAX(log_time) FROM xp_log WHERE target_objid ='[u(.objid, %0)]' AND trait_category ='[u(f.sql.escape, lcstr(first(%1, .)))]' AND trait_name LIKE '[u(f.sql.escape, if(strlen(rest(%1, .)), lcstr(rest(%1, .)), %%))]';

think Entry complete.
