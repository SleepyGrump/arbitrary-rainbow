/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/4%20-%20XP%20and%20Costs/4c%20-%20XP%20and%20Advancement.txt

Compiled 2019-11-07

Escaped SQL Insert "reason" field because it allows apostrophes.

Escaped some other stuff, and removed an escape from the "freebie" command because it was already being escaped in the SQL command.

SQL CODE:


DROP TABLE IF EXISTS xp_log;

--

CREATE TABLE IF NOT EXISTS xp_log (
	target_objid VARCHAR(255) NOT NULL,
	target_name VARCHAR(255) NOT NULL,

	enactor_objid VARCHAR(255) NOT NULL,
	enactor_name VARCHAR(255) NOT NULL,

	log_time TIMESTAMP NOT NULL DEFAULT NOW(),

	xp_type VARCHAR(255) NOT NULL,
	xp_amt DECIMAL(21,17) NOT NULL,

	trait_category VARCHAR(255),
	trait_name VARCHAR(255),
	trait_value VARCHAR(255),

	action VARCHAR(255) NOT NULL,
	reason VARCHAR(255),

	entry_num BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	trait_value_old VARCHAR(255),

	PRIMARY KEY (target_objid, log_time),
	INDEX (entry_num)
) ENGINE=INNODB;

*/

think Entering 81 lines.

@create XP Advancement System <xpas>

@fo me=&d.xpas me=search(name=XP Advancement System <xpas>)

@set XP Advancement System <xpas>=INHERIT SAFE

@fo me=&d.sfp [v(d.xpas)]=[search(name=Stat Functions Prototype <sfp>)]

@fo me=&d.dd [v(d.xpas)]=[search(name=Data Dictionary <dd>)]

@fo me=&d.xpcd [v(d.xpas)]=[search(name=XP Cost Database <xpcd>)]

@fo me=&d.cg [v(d.xpas)]=[search(name=GMC Chargen <cg>)]

@fo me=@parent [v(d.xpas)]=[v(d.codp)]

&prefix.sql [v(d.xpas)]=sql.

&prefix.validations [v(d.xpas)]=validate.

&pref.player_spend [v(d.xpas)]=on

&c.xp/cost [v(d.xpas)]=$xp/cost *:@pemit %#=[u(f.xp/cost, %0)]

&c.xp/spend [v(d.xpas)]=$xp/spend *:@pemit %#=[u(f.xp/spend, %0)]

&c.xp/freebie [v(d.xpas)]=$xp/freebie *:@pemit %#=[u(f.xp/freebie, %0)]

&.isapproved [v(d.xpas)]=isapproved(%0, %1)

&.value [v(d.xpas)]=u(v(d.dd)/.value, %0, %1)

&.msg [v(d.xpas)]=ansi(h, <%0>, n, %b%1)

&.plural [v(d.xpas)]=if(eq(%0, 1), %0 %1, %0 %2)

&.lmax [v(d.xpas)]=lmax(%0)

&.trunc [v(d.xpas)]=fdiv(trunc(mul(%0, power(10, %1))), power(10, %1))

&.objid [v(d.xpas)]=localize(if(t(setr(l, locate(%#, %0, *))), [num(%ql)]:[convtime(get(%ql/created))], #-1 NOT FOUND))

&f.sql.escape [v(d.xpas)]=edit(%0, \%, \\\\\%, ', \\\\', ", \\\\", \%, \\\\\\\%)(not needed at this time)

&f.html.unescape [v(d.xpas)]=edit(edit(edit(edit(%0, &#37;, %%), &lt;, <), &gt;, >), &amp;, &)

&f.time.unix2sql [v(d.xpas)]=if(%0, timefmt($Y-$m-$d $H:$M:$S $z, %0), none)

&f.time.sql2unix [v(d.xpas)]=sql(SELECT UNIX_TIMESTAMP('%0'))

&f.transaction.begin [v(d.xpas)]=strcat(sql(START TRANSACTION), sql(SET autocommit =0))

&f.transaction.end [v(d.xpas)]=strcat(sql(COMMIT), sql(SET autocommit =1))

&sql.xp_log.add [v(d.xpas)]=INSERT INTO xp_log (target_objid, target_name, enactor_objid, enactor_name, xp_type, xp_amt, action, reason) VALUES ('[u(.objid, %0)]', '[u(f.sql.escape, name(%0))]', '[u(.objid, %1)]', '[u(f.sql.escape, name(%1))]', '[u(f.sql.escape, %2)]', %3, '[u(f.sql.escape, %5)]', '[u(f.sql.escape, %4)]')

&sql.xp_log.auto-add [v(d.xpas)]=INSERT INTO xp_log (target_objid, target_name, enactor_objid, enactor_name, xp_type, xp_amt, reason) VALUES ('[u(.objid, %0)]', '[u(f.sql.escape, name(%0))]', '[u(.objid, %1)]', 'Auto-Experience System', '%2', %3, 'Daily Auto')

&sql.xp_log.type-character [v(d.xpas)]=SELECT entry_num, enactor_objid, enactor_name, log_time, xp_amt, reason FROM xp_log WHERE target_objid='[u(.objid, %0)]' AND xp_type='[u(f.sql.escape, lcstr(%1))]' [if(strlen(%2), AND trait_name LIKE '[u(f.sql.escape, edit(%2, %b, _))]%%%%')]

&c.xp.general [v(d.xpas)]=$^\+?xp$:@assert not(isapproved(%#, guest))={@pemit %#=u(.msg, xp, Players only)}; @pemit %#=strcat(wheader(XP & Beats), %r, iter(v(d.xp_types), u(display.xp-and-beats.one-line, %#, %i0),, %r), %r, wdivider(), %r, if(isapproved(%#), u(display.approval-deets, %#)), %r, wfooter())

@set v(d.xpas)/c.xp.general=regexp

&c.xp.specific [v(d.xpas)]=$^\+?xp (.+)$:think setr(p, pmatch(trim(%1))); @assert cor(isstaff(%#), strmatch(%#, %qp))={@pemit %qp=u(.msg, xp, Staff or self only)}; @assert t(%qp)={@pemit %qp=u(.msg, xp, '[trim(%1)]' not found)}; @assert not(isapproved(%qp, guest))={@pemit %#=u(.msg, xp, Players only)}; @pemit %#=strcat(wheader(XP & Beats for [name(%qp)]), %r, iter(v(d.xp_types), u(display.xp-and-beats.one-line, %qp, %i0),, %r), %r, wdivider(), %r, if(isapproved(%qp), u(display.approval-deets, %qp)), wfooter())

@set v(d.xpas)/c.xp.specific=regexp

&display.xp-and-beats.one-line [v(d.xpas)]=strcat(setq(a, get(%0/_special.beats.%1)), setq(c, ladd(%qa)), setq(e, first(%qa)), setq(s, rest(%qa)), ansi(h, titlestr(%1)), :, %b, Experience:, %b, floor(fdiv(%qc, v(d.beat-to-exp))), %,%b, Beats:, %b, mod(%qc, v(d.beat-to-exp)), %r, %b- Earned:, %b, u(.trunc, fdiv(%qe, v(d.beat-to-exp)), 1), %r, %b- Spent:, %b%b, u(.trunc, fdiv(abs(%qs), v(d.beat-to-exp)), 1))

&display.approval-deets [v(d.xpas)]=localize(strcat(setq(y, strmatch(%#, %0)), setq(n, name(%0)), setq(a, u([v(d.cg)]/f.total_secs_approved, %0)), if(%qy, You have, %qn has), %b, been approved for, %b, exptime(%qa), %r, if(%qy, You are, %qn is), %b, auto-gaining, %b, u(f.auto.beats.weekly, %0), %b, Normal Beats per week, %r, if(%qy, You have, %qn has), %b, earned, %b, default(%0/_special.beats_earned.normal, 0), %b, out of, %b, u(f.weekly_beats.max_earnable, %0), %b, Normal Beats this week, %r, It will be reset in, %b, u(.plural, sub(7, u(f.day_in_approval_week, %0)), day, days), %r,))

&c.xp/log [v(d.xpas)]=$^\+?xp/log(.*)$:@assert not(isapproved(%#, guest))={@pemit %#=u(.msg, xp/log, Players only)}; @assert sql(select 1)={@pemit %#=u(.msg, xp/log, SQL connection is down%; log cannot be retrieved)}; think strcat(* Switches & Cetera *, %r, if(strmatch(strtrunc(%1, 1), /), strcat(raw switches:, %b, setr(s, trim(first(%1))), %r, raw everything else:, %b, setr(o, trim(rest(%1))), %r,), strcat(raw everything else:, %b, setr(o, trim(%1)), %r,))); @if isint(%qo)={@trigger %!/trig.xp/log.detail=%#, %qo, %qs}, {@trigger %!/trig.xp/log.summary=%#, %qo, %qs};

@set v(d.xpas)/c.xp/log=regexp

&trig.xp/log.summary [v(d.xpas)]=think strcat(** DEBUG SPAM **, %r, if(isstaff(%0), strcat(* STAFF *, %r, raw target:, %b, setr(p, first(%1, /)), %r, raw type:, %b, setr(x, rest(%1, /)), %r,), strcat(* PLAYER *, %r, raw target:, %b, setr(p, %0), %r, raw type:, %b, setr(x, %1), %r,)), * PROCESSING *, %r, processed target:, %b, setr(t, pmatch(trim(%qp))), %r, processed xp type:, %b, setr(e, grab(normal|[edit(v(d.xp_types), %b, |)], trim(%qx*), |)), %r, processed log type:, %b, setr(g, grab(|[edit(v(d.log_types), %b, |)], rest(trim(%2*), /), |)), %r,); @assert cor(strmatch(%0, %qp), isstaff(%0))={@pemit %0=u(.msg, xp/log, Self or staff only)}; @assert t(%qt)={@pemit %0=u(.msg, xp/log, Target '[trim(%qp)]' not found)}; @assert strlen(%qe)={@pemit %0=u(.msg, xp/log, Experience type '[trim(%qx)]' not found)}; @assert cor(strlen(%qg), strmatch(%2,))={@pemit %0=u(.msg, xp/log, Log type '[rest(trim(%2), /)]' not found)}; think strcat(Log:, setr(l, iter(sql(u(sql.select.type-character, %qt, %qe, %qg), `, |), u(format.xp/log.one-line, %i0), `, `))); @pemit %0=strcat(wheader(XP/Log[if(strlen(%qg), /[capstr(%qg)])] for [name(%qt)] %([capstr(%qe)]%)), %r, u(display.xp/log.header), %r, iter(%ql, u(display.xp/log.one-line, %i0), `, %r), %r, wfooter())

&trig.xp/log.detail [v(d.xpas)]=think strcat(* extra switches (%2) ignored for now *, %r, * xp log for entry '%1' *, %r, log:, %b, setr(l, sql(u(sql.select.entry_num, %1), `, |)), %r, target's dbref:, %b, setr(t, first(elements(%ql, 3, |), :)), %r,); @break eq(words(%ql, `), 0)={@pemit %0=u(.msg, xp/log, No entries found)}; @assert eq(words(%ql, `), 1)={@pemit %0=u(.msg, xp/log, Somehow I found more than one entry for entry num '%1'. This is very alarming. Help.)}; @assert cor(strmatch(%0, %qt), isstaff(%0))={@pemit %0=u(.msg, xp/log, Self or staff only)}; think strcat(enactor's display width:, %b, setr(w, width(%0)), %r * format data for display *, %r, enactor (dbref):, %b, setr(e, strcat(elements(%ql, 2, |), %b, %(, first(elements(%ql, 1, |), :), %))), %r, target (dbref):, %b, setr(t, strcat(elements(%ql, 4, |), %b, %(, %qt, %))), %r, timestamp:, %b, setr(x, elements(%ql, 5, |)), %r, action:, %b, setr(a, elements(%ql, 7, |)), reason:, %b, setr(r, elements(%ql, 8, |)), trait type:, %b, setr(y, titlestr(elements(%ql, 9, |))), %r, trait name -> 'value':, %b, setr(n, strcat(statname(elements(%ql, 10, |)), %b, %[, %qy, %], %b', elements(%ql, 13, |) , ' -> ', elements(%ql, 11, |), ')), %r, xp amt & type:, %b, setr(z, if(t(elements(%ql, 6, |)), strcat(setq(z, elements(%ql, 12, |)), setq(z, if(not(strmatch(%qz, normal)), [capstr(%qz)]%b)), u(.plural, fdiv(elements(%ql, 6, |), v(d.beat-to-exp)), %qzExperience, %qzExperiences)))), %r,); @pemit %0=strcat(header(xp/log %1, %qw), %r, ansi(h, Enactor), :, %b, %qe, %r, ansi(h, Target), :, %b, %qt, %r, ansi(h, Action), :, %b, %qa, %r, ansi(h, Timestamp), :, %b, %qx, %r, ansi(h, Trait), :, %b, if(strlen(%qy), %qn, ansi(xh, <none>)), %r, ansi(h, Amount), :, %b, if(strlen(%qz), %qz, ansi(xh, <n/a>)), %r, ansi(h, Reason), :%b, if(strlen(%qr), %qr, ansi(xh, <none>)), %r, footer(, %qw));&format.xp/log.one-line [v(d.xpas)]=strcat(elements(%0, 1, |), |, elements(%0, 3, |), %b, %(, first(elements(%0, 2, |), :), %), |, timefmt($m/$d/$g, u(f.time.sql2unix, elements(%0, 4, |))), |, case(elements(%0, 6, |), spend, -, freebie, -, unaward, -), trim(fdiv(floor(elements(%0, 5, |)), v(d.beat-to-exp)), l, 0), |, if(strlen(elements(%0, 8, |)), strcat(statname(elements(%0, 8, |)), %b, ->, %b, ', elements(%0, 9, |), '), strcat(elements(%0, 7, |))),)

&display.xp/log.header [v(d.xpas)]=localize(strcat(setq(w, sub(width(%#), 80)), rjust(Exp, 5), %b%b, ljust(Reason, add(27, ceil(fdiv(%qw, 2)))), %b%b, ljust(Entered By, add(20, floor(fdiv(%qw, 2)))), %b, ljust(Date, 10), %b, Entry Num, %r, wdivider()))

&display.xp/log.one-line [v(d.xpas)]=localize(strcat(setq(w, sub(width(%#), 80)), rjust(elements(%0, 4, |), 5), %b%b, ljust(elements(%0, 5, |), add(27, ceil(fdiv(%qw, 2)))), %b%b, ljust(elements(%0, 2, |), add(20, floor(fdiv(%qw, 2)))), %b, ljust(elements(%0, 3, |), 10), %b, rjust(elements(%0, 1, |), 9)))

&c.xp/award [v(d.xpas)]=$^\+?xp/award(.+)$:@assert isstaff(%#)={@pemit %#=u(.msg, xp/award, Staff only)}; @assert sql(select 1)={@pemit %#=u(.msg, xp/award, SQL connection is down%; award not processed)}; think strcat(name (w/type):, %b, setr(n, first(%1, =)), %r, type:, %b, setr(t, if(t(setr(t, trim(rest(%qn, /)))), %qt, normal)), %r, name:, %b, setr(n, trim(first(%qn, /))), %r, amt (w/reason):, %b, setr(a, rest(%1, =)), %r, reason:, %b, setr(r, trim(rest(%qa, %bfor%b))), %r, value:, %b, setr(a, trim(first(%qa, %bfor%b))), %r, value in beats:, %b, setr(a, switch(rest(%qa), b*, first(%qa), x*, mul(first(%qa), v(d.beat-to-exp)), ex*, mul(first(%qa), v(d.beat-to-exp)),, trim(%qa), I don't know what you mean by '%qa')), %r,); @assert hastype(setr(p, pmatch(%qn)), PLAYER)={@pemit %#=u(.msg, xp/award, Could not find '%qn')}; @assert cor(isapproved(%qp), isapproved(%qp, chargen))={@pemit %#=u(.msg, xp/award, '[name(%qp)]' is not approved nor in chargen)}; @assert hastype(setr(p, pmatch(%qn)), PLAYER)={@pemit %#=u(.msg, xp/award, Could not find '%qn')}; @assert isint(%qa)={@pemit %#=u(.msg, xp/award, %qa)}; @assert strlen(%qr)={@pemit %#=u(.msg, xp/award, Must include reason)}; @break cor(strmatch(%qr, *|*), strmatch(%qr, *`*))={@pemit %#=u(.msg, xp/award, May not use | or ` in reason)}; @assert t(match(v(d.xp_types), %qt))={@pemit %#=u(.msg, xp/award, I can't find the '%qt' type)}; think strcat(experience:, setr(x, get(%qp/_special.beats.%qt)), %r, beats earned:, setr(b, udefault(f.beats_earned.%qt, get(%qp/_special.beats_earned.%qt), %qp)), %r, final award attribute:, setr(f, add(%qa, %qb)), %r, total weekly earnable:, setr(e, u(f.weekly_beats.max_earnable, %qp))); @assert cor(lte(%qf, %qe), isapproved(%qp, chargen))={@pemit %#=u(.msg, xp/award, '[name(%qp)]' cannot take that many %qt beats. They can only take '[floor(sub(%qe, %qb))]' more beats for the rest of their week.)}; @set/quiet %qp=_special.beats.%qt:[add(first(%qx), %qa)] [rest(%qx)];@set/quiet %qp=_special.beats_earned.%qt:[if(isapproved(%qp), %qf)]; think strcat(tranaction begin, u(f.transaction.begin), %r, sanitized reason:, setr(s, u(f.sql.escape, %qr)), %r, add to xp_log (null is good):, sql(u(sql.insert.award, %qp, %#, %qt, %qa, %qs)), %r, tranaction end, u(f.transaction.end)); @pemit %#=u(.msg, xp/award, You have awarded '[name(%qp)]' [u(.plural, %qa, Beat, Beats)] [if(not(strmatch(%qt, normal)), %(%qt%)%b)]for '%qr'); @pemit %qp=u(.msg, xp/award, [moniker(%#)] has just awarded you [u(.plural, %qa, Beat, Beats)] [if(not(strmatch(%qt, normal)), %(%qt%)%b)]for '%qr');

@set v(d.xpas)/c.xp/award=regexp

@set v(d.xpas)/c.xp/award=no_parse

&d.beat-to-exp [v(d.xpas)]=5

&d.xp_types [v(d.xpas)]=normal player

&d.log_types [v(d.xpas)]=gain spend freebie auto unspend unaward

&default.special.beats.normal [v(d.dd)]=0 0

&d.restricted.types [v(d.xpas)]=iter(lattr(%!/d.restricted.types.*), u(%i0))

&d.restricted.types.default [v(d.xpas)]=bio

&d.restricted.stats [v(d.xpas)]=iter(lattr(%!/d.restricted.stats.*), u(%i0))

&d.restricted.stats.default [v(d.xpas)]=advantage.integrity merit.status_(*)&f.cost.calculator [v(d.xpas)]=localize(strcat(setq(i, crumple(before(rest(trim(%3, l, _), %(), %)))), setq(s, u(v(d.sfp)/f.statpath-without-instance, trim(%3, l, _))), setq(f, u(f.formula_finder, %qs, %0)), setq(v, first(get(v(d.dd)/%qs), |)), if(t(%qf), u(v(d.xpcd)/%qf, %0, %1, %2, %qs, %qv, %qi), %qf)))

&f.formula_finder [v(d.xpas)]=localize(strcat(setq(t, get(%1/_bio.template)), setq(s, %0), setq(s, filter(fil.formula_finder, iter(lnum(words(%0, .), 2), setr(s, replace(%qs, %i0, ?, .))),,, xp)), setq(s, cat(iter(%qs, %i0~%qt), %qs)), setq(s, filter(fil.formula_finder, %qs,,, xp)), setq(x, %0), setq(x, filter(fil.formula_finder, iter(lnum(words(%0, .), 1), setr(x, ldelete(%qx, %i0, .))),,, xp)), setq(x, cat(iter(%qx, %i0~%qt), %qx)), setq(x, filter(fil.formula_finder, %qx,,, xp)), case(1, t(filter(fil.formula_finder, %0~%qt,,, xp)), xp.%0~%qt, t(filter(fil.formula_finder, %0,,, xp)), xp.%0, t(%qs), xp.[first(%qs)], t(%qx), xp.[first(%qx)], #-1 No Experience costs found)))

&fil.formula_finder [v(d.xpas)]=hasattr(v(d.xpcd), %1.%0)

&f.xp/cost [v(d.xpas)]=strcat(setq(p, first(%0, =)), setq(v, rest(%0, =)), setq(n, rest(%qp, /)), setq(p, first(%qp, /)), if(not(t(%qn)), strcat(setq(n, %qp), setq(p, %#)), setq(p, pmatch(%qp))), setq(w, ulocal(v(d.sfp)/f.find-sheet, %qp)), setq(s, ulocal(v(d.sfp)/f.statpath.workhorse, %qn, %qp)), setq(t, ulocal(.value, %qw, %qs)), if(not(t(%qv)), setq(v, ulocal(f.stat.next_rank, %qw, _%qs))), setq(c, ulocal(f.cost.calculator, %qw, %qt, %qv, %qs)), setq(x, get(%qw/_special.beats.normal)), case(1, t(setr(e, ulocal(validate.player, %qp, %qw, 1))), ulocal(.msg, xp/cost, %qe), t(setr(e, ulocal(validate.stat, %qw, %qs, %qt, %qv))), ulocal(.msg, xp/cost, %qe), t(setr(e, ulocal(validate.value, %qs, %qt, %qv))), ulocal(.msg, xp/cost, %qe), t(setr(e, ulocal(validate.cost, %qc))), ulocal(.msg, xp/cost, %qe), ulocal(.msg, xp/cost, ulocal(display.xp/cost, %qp, %qn, %qs, %qv, %qt))))

&display.xp/cost [v(d.xpas)]=strcat(The cost, %b, if(not(strmatch(%#, %0)), cat(for, name(%0),)), case(u(v(d.sfp)/f.get-class, %2), list, strcat(to add %3, %b, %(, u(u(d.dd)/.class_translate_list, %2, %3), %), %b, to, %b, statname(%0/%1)), flag, strcat(to add, %b', statname(%0/%1), '%b, %(, %3, %)), cat(to raise, statname(%0/%1), from, if(strlen(%4), %4, 0), to %3)), %b, is %qc Experience., if(cor(strmatch(u(pref.player_spend), off)), %b%(Player spending is off.%)), setq(e, u(validate.spend, %qc, %qx)), setq(f, u(validate.restricted, %qs, %qv)), case(1, cand(%qe, %qf), %b%(%qe%, %qf.%), t(%qe), %b%(%qe.%), t(%qf), %b%(%qf.%)))

&f.stat.next_rank [v(d.xpas)]=localize(strcat(setq(d, ulocal(v(d.sfp)/f.statpath-without-instance, trim(%1, l, _))), setq(s, first(udefault(%0/%1, 0), .)), setq(v, first(u(v(d.dd)/%qd), |)), setq(n, extract(%qv, inc(match(%qv, %qs, .)), 1, .)), case(1, strmatch(%qv, #), inc(%qs), strmatch(%1, _skill.*.*), inc(%qs), not(t(%qn)), #-1 That stat can't go any higher, gt(%qs, last(%qv, .)), #-1 Stat Already Above Max Level, %qn)))

&f.xp/spend [v(d.xpas)]=strcat(setq(p, first(%0, =)), setq(v, rest(%0, =)), setq(n, rest(%qp, /)), setq(p, first(%qp, /)), if(not(t(%qn)), strcat(setq(n, %qp), setq(p, %#)), setq(p, pmatch(%qp))), setq(w, ulocal(v(d.sfp)/f.find-sheet, %qp)), setq(s, ulocal(v(d.sfp)/f.statpath.workhorse, %qn, %qp)), setq(t, ulocal(.value, %qw, %qs)), if(not(t(%qv)), setq(v, ulocal(f.stat.next_rank, %qw, _%qs))), setq(c, ulocal(f.cost.calculator, %qw, %qt, %qv, %qs)), setq(x, get(%qw/_special.beats.normal)), case(1, cand(strmatch(u(pref.player_spend), off), not(isstaff(%#))), u(.msg, xp/spend, Player spending is off. Ask staff to spend your stats.), t(setr(e, ulocal(validate.player, %qp, %qw, 1))), u(.msg, xp/spend, %qe), t(setr(e, ulocal(validate.stat, %qw, %qs, %qt, %qv))), u(.msg, xp/spend, %qe), t(setr(e, ulocal(validate.value, %qs, %qt, %qv))), u(.msg, xp/spend, %qe), t(setr(e, ulocal(validate.cost, %qc))), u(.msg, xp/spend, %qe), t(setr(e, ulocal(validate.spend, %qc, %qx))), u(.msg, xp/spend, %qe), t(setr(e, ulocal(validate.restricted, %qs, %qv))), u(.msg, xp/spend, %qe), strmatch(setr(e, sql(u(sql.insert.spend, %qp, %#, normal, mul(%qc, v(d.beat-to-exp)), u(f.sql.escape, %qs), null(null), %qv, %qt))), #-*), u(.msg, xp/spend, SQL connection is down%; spend not processed), strmatch(setr(e, ulocal(v(d.sfp)/f.setstat.workhorse, %qw, %qs, %qv)), #-*), u(.msg, xp/spend, Error from Setstat: %qe), strcat(setq(e, set(%qw, _special.beats.normal:[first(%qx)] [sub(rest(%qx), mul(%qc, v(d.beat-to-exp)))])), if(strmatch(%qe, #-*), u(.msg, xp/spend, Error while setting new xp: %qe %r%(Original XP attribute: %qx%))), setq(n, statname(%qp/%qn)), u(.msg, xp/spend, strcat(if(strmatch(%qp, %#), Your, [name(%qp)]'s), %b, %qn, %b, has been set, case(u(v(d.sfp)/f.get-class, %qs), list,, %bto '%qv'), %b, for %qc Experience.)),)))

&d.regex.freebie [v(d.xpas)]=(.+)/(.+?)(=(.+))? for (.+)

&f.xp/freebie [v(d.xpas)]=strcat(setq(0, regmatchi(%0, v(d.regex.freebie), -1 p n -1 v r)), setq(p, pmatch(%qp)), setq(w, ulocal(v(d.sfp)/f.find-sheet, %qp)), setq(s, ulocal(v(d.sfp)/f.statpath.workhorse, %qn, %qp)), setq(t, ulocal(.value, %qw, %qs)), if(not(%qv), setq(v, ulocal(f.stat.next_rank, %qw, _%qs))), case(1, not(isstaff(%#)), u(.msg, xp/freebie, Staff only), not(strlen(%qr)), u(.msg, xp/freebie, Must provide a reason this is free), t(setr(e, ulocal(validate.player, %qp, %qw, 1))), u(.msg, xp/freebie, %qe), t(setr(e, ulocal(validate.stat, %qw, %qs, %qt, %qv))), u(.msg, xp/freebie, %qe), t(setr(e, ulocal(validate.value, %qs, %qt, %qv))), u(.msg, xp/freebie, %qe), t(setr(e, ulocal(validate.restricted, %qs, %qv))), u(.msg, xp/freebie, %qe), strmatch(v(d.transaction.begin), *#-*), u(.msg, xp/freebie, Transaction begin failed%; freebie not processed), strmatch(setr(e, sql(u(sql.insert.spend, %qp, %#, normal, 0, %qs, %qr, %qv, %qt))), #-*), u(.msg, xp/freebie, Unable to connect to database%; freebie not processed[null(v(f.transaction.end))]), strmatch(setr(e, ulocal(v(d.sfp)/f.setstat.workhorse, %qw, %qs, %qv)), #-*), u(.msg, xp/freebie, Error from Setstat: %qe [null(v(f.transaction.end))]), strcat(setq(n, statname(%qp/%qn)), u(.msg, xp/freebie, strcat(if(strmatch(%qp, %#), Your, [name(%qp)]'s), %b, %qn, %b, has been set to '%qv' for Free because '%qr')), null(v(f.transaction.end)))))

@fo me=&d.ars [v(d.xpas)]=[search(name=Alt Registration <ars>)]

&c.xp/convert [v(d.xpas)]=$^\+?xp/convert (.+) from (.+)$:@assert sql(select 1)={@pemit %#=u(.msg, xp/convert, SQL connection is down%; conversion not processed)}; think strcat(** initial registers **, %r, -- target --, %r, name:, %b, setr(n, trim(%2)), %r, dbref:, %b, setr(d, if(strmatch(%qn, me), %#, pmatch(%qn))), %r, objid:, %b, setr(o, u(.objid, %qd)), %r, player xp:, %b, setr(x, get(%qd/_special.beats.player)), %r, -- enactor --, %r, normal xp:, %b, setr(l, get(%#/_special.beats.normal)), %r, -- amt/type --, %r, type:, %b, setr(t, grab(beats|experience|xp, [rest(%1)]*, |)), %r, amt if 'all':, %b, setr(a, case(setr(a, first(%1)), all, ladd(%qx), %qa))amt in beats:, %b, setr(a, case(%qt, beats, %qa, experience, mul(%qa, v(d.beat-to-exp)), xp, mul(%qa, v(d.beat-to-exp)), 0)), %r,); @assert t(%qo)={@pemit %#=u(.msg, xp/convert, Character '%qn' not found.)}; @assert strlen(%qt)={@pemit %#=u(.msg, xp/convert, If you're going to enter a type%, it must be 'beats'%, 'experience'%, or 'xp'. Leave blank for 'beats'.)}; @assert cand(isint(%qa), gt(%qa, 0))={@pemit %#=u(.msg, xp/convert, Amount to transfer must be a non-zero integer)}; @assert u(v(d.ars)/f.has-alt, %#, %qo)={@pemit %#=u(.msg, xp/convert, '[name(%qd)]' is not an alt of yours. If [subj(%qd)] should be%, see: +help alts)}; @assert gte(ladd(%qx), %qa)={@pemit %#=u(.msg, xp/convert, [name(%qd)] doesn't have that much Player Experience)}; @trigger %!/trig.xp/convert.spend=%#, %qd, %qa; @wait 1=@trigger %!/trig.xp/convert.gain=%#, %qd, %qa; @pemit %#=u(.msg, xp/convert, cat(Converted, u(.plural, %qa, beat, beats), from, if(strmatch(%qd, %#), your, [name(%qd)]'s), Player Experience to your Normal Experience));

@set v(d.xpas)/c.xp/convert=regexp

&trig.xp/convert.spend [v(d.xpas)]=think strcat(## xp/convert: spend ##, %r, u(f.transaction.begin), ** set registers **, %r, target xp:, %b, setr(p, get(%1/_special.beats.player)), %r, reason:, %b, setr(r, Converted Player Experience to [name(%0)] (%0)), %r, sanitized reason:, %b, setr(r, u(f.sql.escape, %qr)), %r, ** manipulate beats attributes **, %r, spend target's player beats:, %b, setr(d, set(%1, _special.beats.player:[first(%qp)] [sub(rest(%qp), %2)])), %r, ** enter SQL log: spend (target, player) **, %r, add spend (player) to xp_log:, %b, setr(s, sql(u(sql.xp_log.add, %1, %0, player, %2, %qr, spend))), %r, u(f.transaction.end),); @if strlen(%qd%qs)={@pemit %0=u(.msg, xp/convert, strcat(Spending from [name(%1)] ran into some problems:, if(strlen(%qd), %r* [name(%1)]'s Player Beats was not set correctly! It should be: [first(%qp)] [sub(rest(%qp), %2)]), if(strlen(%qs), %r* The xp/log for [name(%1)]'s Player Beats was not set)))};&trig.xp/convert.gain [v(d.xpas)]=think strcat(## xp/convert: gain ##, %r, ** set registers **, %r, enactor xp:, %b, setr(n, get(%0/_special.beats.normal)), %r, reason:, %b, setr(r, Converted Player Experience from [name(%1)] (%1)), %r, sanitized reason:, %b, setr(r, u(f.sql.escape, %qr)), %r, ** manipulate beats attributes **, %r, gain enactor's normal beats:, %b, setr(d, set(%0, _special.beats.normal:[add(first(%qn), %2)] [rest(%qn)])), %r, ** enter SQL log: award (enactor, normal) **, %r, add gain (normal) to xp_log:, %b, setr(s, sql(u(sql.xp_log.add, %0, %0, normal, %2, %qr, gain))), %r,); @if strlen(%qd%qs)={@pemit %0=u(.msg, xp/convert, strcat(Gaining to [name(%0)] ran into some problems:, if(strlen(%qd), %r* [name(%0)]'s Normal Beats was not set correctly! It should be: [add(first(%qn), %2)] [rest(%qn)]), if(strlen(%qs), %r* The xp/log for [name(%0)]'s Normal Beats was not set)))};&validate.player [v(d.xpas)]=case(0, cor(isstaff(%#), match(%0, %#)), Yourself only, t(%1), Could not find a sheet, cor(%2, isapproved(%0, approved), isstaff(%#)), Must be approved for play to spend Experience)

&validate.stat [v(d.xpas)]=localize(strcat(setq(v, u(v(d.cg)/f.statcheck, %0, _%1, case(u(v(d.sfp)/f.get-class, %1), numeric, sub(%3, %2), %3))), case(0, t(%1), Stat not found, not(strmatch(%3, #-*)), capstr(lcstr(rest(%3))), cor(t(first(%qv, .)), strmatch(%3,)), capstr(lcstr(rest(first(%qv, .)))), t(elements(%qv, 2, .)), Can't set the stat outside character generation, t(elements(%qv, 3, .)), Stat cannot be taken by your template, t(elements(%qv, 4, .)), rest(elements(%qv, 4, .)))))

&validate.cost [v(d.xpas)]=case(1, cand(isstaff(%#), not(t(%0))), This stat has no Experience cost and must be set using 'stat/set', not(%0), This stat has no Experience cost and must be set by a staffer)

&validate.value [v(d.xpas)]=localize(strcat(setq(c, ulocal(v(d.sfp)/f.get-class, %0)), setq(v, lcstr(first(get(v(d.dd)/%0), |))), case(%qc, list, case(0, t(%2), capstr(lcstr(rest(%2))), eq(words(setinter(%qv, lcstr(%2), .), .), words(%2, .)), Value not in the list of values I can set, not(match(%1, %2, .)), You already have the stat at that level), numeric, case(0, t(%2), capstr(lcstr(rest(%2))), isint(%2), Raise must be numeric, gt(%2, %1), Stat must be raised), string, Cannot raise string stats, flag, null(all flags should be okay), Uncaptured stat class type in 'validate.value')))

&validate.spend [v(d.xpas)]=if(gt(%0, fdiv(ladd(%1), v(d.beat-to-exp))), Not enough[if(not(cor(strmatch(%2,), strmatch(%2, normal))), %bcapstr(%2))] Experience)

&validate.restricted [v(d.xpas)]=localize(case(1, isstaff(%#), null(ignore entirely), lor(iter(u(d.restricted.types), match(first(%0, .), %i0))), Stats of this type must be purchased for you by a staffer, lor(iter(u(d.restricted.stats), match(%0, %i0))), This stat must be purchased for you by a staffer,))

&f.at_weeks_end? [v(d.xpas)]=eq(u(f.day_in_approval_week, %0), 0)

&f.day_in_approval_week [v(d.xpas)]=localize(strcat(setq(a, grab(revwords(get(%0/_approval.log), |), approved:*, |)), setq(a, elements(%qa, 2, :)), mod(idiv(sub(secs(), %qa), v(d.one-day)), 7)))

&f.current_period [v(d.xpas)]=ceil(fdiv(u([v(d.cg)]/f.total_secs_approved, %0), mul(v(d.one-week), inc(v(d.period.weeks)))))

&f.auto.beats.weekly [v(d.xpas)]=case(u(f.current_period, %0), 0, 0, 1, 10, 2, 5, 3, 3, 1)

&f.auto.beats.daily [v(d.xpas)]=fdiv(u(f.auto.beats.weekly, %0), 7)

&f.weekly_beats.max_earnable [v(d.xpas)]=sub(v(d.beats.max_weekly), u(f.auto.beats.weekly, %0))

&f.approved_characters [v(d.xpas)]=search(eplayer=cand(isapproved(##), not(isstaff(##))))

@daily [v(d.xpas)]=@trigger %!/trig.daily.xp; @trigger %!/trig.weekly.reset;&trig.daily.xp [v(d.xpas)]=@eval strcat(list(1, sql(u(f.transaction.begin))), list(search(eplayer=cand(isapproved(##), not(isstaff(##)))), strcat(setq(x, u(f.auto.beats.daily, %i0)), setq(c, get(%i0/_special.beats.normal)), set(%i0, _special.beats.normal:[add(first(%qc), %qx)] [rest(%qc)]), sql(u(sql.insert.daily-auto, %i0, %!, normal, %qx)))), list(1, sql(u(f.transaction.end))))

&trig.weekly.reset [v(d.xpas)]=think setr(m, header(xpas: clear weekly beat limits)); think setr(n, divider(normal beats));think setr(o, iter(search(eplayer=cand(isapproved(##), hasattr(##, _special.beats_earned.normal), u(f.at_weeks_end?, ##))), cat(name(%i0), %i0, ::, set(%i0, _special.beats_earned.normal:), ::, if(strmatch(get(%i0/_special.beats_earned.normal),), ansi(hg, OK!), ansi(n, error))),, %r)); think setr(p, divider(player beats)); think setr(q, iter(search(eplayer=cand(isapproved(##), hasattr(##, _special.beats_earned.player), u(f.at_weeks_end?, ##))), cat(name(%i0), %i0, ::, set(%i0, _special.beats_earned.player:), ::, if(strmatch(get(%i0/_special.beats_earned.player),), ansi(hg, OK!), ansi(n, error))),, %r)); think setr(r, footer());&f.beats_earned.player [v(d.xpas)]=ladd(iter(alts(%0), get(%i0/_special.beats_earned.player)))

&f.beats_earned.normal [v(d.xpas)]=get(%0/_special.beats_earned.normal)

&sql.select.spends-stat [v(d.xpas)]=SELECT log_time, reason, xp_type, xp_amt FROM xp_log WHERE target_objid='[u(.objid, %0)]' AND trait_category='[first(%1, .)]' AND trait_name='[rest(%1, .)]' [if(strmatch(ulocal([u(d.sfp)]/f.get-class, %1), list), AND trait_value='%2')] AND (action='spend' OR action='freebie') ORDER BY log_time ASC

think Entry complete.
