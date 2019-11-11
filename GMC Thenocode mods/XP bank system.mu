@@ Chargen fixes I don't have a home for yet.


@@ Remove the not-in-the-book requirement of "two short one long" aspirations.

&f.allocated.aspirations #28=localize(strcat(setq(a, lattr(%0/_aspiration.*)), words(%qa), /, words(%qa)))

&F.PTS-VALID?.ASPIRATIONS #28=strcat(setq(a, u(f.allocated.aspirations, %0)), gte(first(%qa, /), 3))

@@ Make sure to pass a second argument to the chargen checking code. Also remove the aspirations requirements - must have 3. No specific types.

&CHECK.CHARGEN #28 =strcat(divider(Chargen Levels, width(%#)), %r, %b%b, ansi(h, Attributes), :%b, udefault(check.chargen.attributes.%1, u(check.chargen.attributes.default, %0), %0), ulocal(check.chargen.attributes, %0, %1), %r, %b%b, ansi(h, Skills), :%b, udefault(check.chargen.skills.%1, u(check.chargen.skills.default, %0), %0), %r, ulocal(check.chargen.specialties, %0, %1), %r, %b%b, ansi(h, Aspirations), :%b, setq(a, u(f.allocated.aspirations, %0)), Total:, %b, first(%qa, /), /3, u(display.check.stats, %0, aspirations), %r, %b%b, ansi(h, Merits), :%b, setq(a, u(f.allocated.merits, %0)), ladd(%qa, /), /10, %b%(, rest(%qa, /), %b, on Power Stat%), %b, u(display.check.stats, %0, merits), %r, u(check.chargen.%1, %0, %2))

@@ XP banking system code

@@ Cron job

&CRON_TIME_WEEKLYXPRESET #63=||Sun|23|59|

&CRON_JOB_WEEKLYXPRESET #63=@trigger [v(d.xpas)]/trig.weekly.reset; @trigger [v(d.xpas)]/trig.daily.xp;

@@ XP bank code (that I've found so far)

&d.xp_types [v(d.xpas)]=normal bank

&trig.daily.xp [v(d.xpas)]=@eval strcat(list(1, sql(u(f.transaction.begin))), list(search(eplayer=cand(isapproved(##), not(isstaff(##)))), strcat(setq(x, u(f.auto.beats.daily, %i0)), setq(t, %qx), setq(c, get(%i0/_special.beats.normal)), setq(e, u(f.weekly_beats.max_earnable, %i0)), setq(k, default(%i0/_special.bank.normal, 0)), setq(a, if(gt(%qk, %qe), %qe, %qk)), setq(k, sub(%qk, %qa)), setq(x, add(%qx, %qa)), set(%i0, _special.beats.normal:[add(first(%qc), %qx)] [rest(%qc)]), set(%i0, _special.beats_earned.normal:%qa), set(%i0, _special.bank.normal:%qk), sql(u(sql.insert.daily-auto, %i0, %!, normal, %qt)), if(gt(%qa, 0), sql(u(sql.insert.bank-auto, %i0, %!, normal, %qa))))), list(1, sql(u(f.transaction.end))))

&TRIG.WEEKLY.RESET [v(d.xpas)]=think setr(m, header(xpas: clear weekly beat limits));think setr(n, divider(normal beats));think setr(o, iter(search(eplayer=cand(isapproved(##), hasattr(##, _special.beats_earned.normal), u(f.at_weeks_end?, ##))), cat(name(%i0), %i0, ::, set(%i0, _special.beats_earned.normal:), ::, if(strmatch(get(%i0/_special.beats_earned.normal),), ansi(hg, OK!), ansi(n, error))),, %r)); think setr(p, divider(player beats)); think setr(q, iter(search(eplayer=cand(isapproved(##), hasattr(##, _special.beats_earned.player), u(f.at_weeks_end?, ##))), cat(name(%i0), %i0, ::, set(%i0, _special.beats_earned.player:), ::, if(strmatch(get(%i0/_special.beats_earned.player),), ansi(hg, OK!), ansi(n, error))),, %r)); think setr(r, footer());

@@ &trig.weekly.reset [v(d.xpas)]=think setr(m, header(xpas: clear weekly beat limits)); think setr(n, divider(normal beats));think setr(o, iter(search(eplayer=cand(isapproved(##), hasattr(##, _special.beats_earned.normal), u(f.at_weeks_end?, ##))), cat(name(%i0), %i0, ::, set(%i0, _special.beats_earned.normal:[if(gt(setr(0, default(%i0/_special.bank.normal, 0)), setq(1, v(d.beats.max_weekly))0), %q1[set(%i0, _special.bank.normal:[sub(%q0, %q1)])], %q0[set(%i0, _special.bank.normal:[%q0])])]), ::, ansi(hg, OK!)),, %r)); think setr(p, divider(player beats)); think setr(q, iter(search(eplayer=cand(isapproved(##), hasattr(##, _special.beats_earned.player), u(f.at_weeks_end?, ##))), cat(name(%i0), %i0, ::, set(%i0, _special.beats_earned.player:[if(gt(setr(0, default(%i0/_special.bank.player, 0)), setq(1, v(d.beats.max_weekly))0), %q1[set(%i0, _special.bank.player:[sub(%q0, %q1)])], %q0[set(%i0, _special.bank.player:[%q0])])]), ::, ansi(hg, OK!)),, %r)); think setr(r, footer());

&F.AUTO.BEATS.DAILY [v(d.xpas)]=if(u(f.at_weeks_end?, %0), u(f.auto.beats.weekly, %0), 0)

&f.auto.beats.weekly [v(d.xpas)]=case(u(f.current_period, %0), 0, 0, 5)

&F.WEEKLY_BEATS.MAX_EARNABLE [v(d.xpas)] = 15

&sql.insert.bank-auto [v(d.xpas)] = INSERT INTO xp_log (target_objid, target_name, enactor_objid, enactor_name, xp_type, xp_amt, action, reason) VALUES ('[u(.objid, %0)]', '[u(f.sql.escape, name(%0))]', '[u(.objid, %1)]', 'Auto-Experience System <xpas>', '%2', %3, 'auto', 'Bank rollover')

&default.special.bank.normal [v(d.dd)]=0

&display.xp-and-beats.one-line [v(d.xpas)]=strcat(space(3), setq(a, get(%0/_special.beats.%1)), setq(b, get(%0/_special.bank.%1)), setq(c, ladd(%qa)), setq(e, first(%qa)), setq(s, rest(%qa)), setq(t, get(%0/_special.transferrable.%1)), ansi(h, titlestr(%1)), :, %b, Experience:, %b, floor(fdiv(%qc, v(d.beat-to-exp))), %,%b, Beats:, %b, mod(%qc, v(d.beat-to-exp)), %r, space(3), %b- Earned:, %b, floor(fdiv(%qe, v(d.beat-to-exp))), %r, space(3), %b- Spent:, %b, abs(floor(fdiv(%qs, v(d.beat-to-exp)))), %r, space(3), %b- Banked:, %b, abs(floor(fdiv(%qb, v(d.beat-to-exp)))), %r, space(3), %b- Transferrable:, %b, abs(floor(fdiv(%qt, v(d.beat-to-exp)))))

&display.approval-deets [v(d.xpas)]=localize(strcat(setq(y, strmatch(%#, %0)), setq(n, name(%0)), setq(a, u([v(d.cg)]/f.total_secs_approved, %0)), space(3), if(%qy, You have, %qn has), %b, been approved for, %b, exptime(%qa), %r, space(3), if(%qy, You are, %qn is), %b, auto-gaining, %b, u(f.auto.beats.weekly, %0), %b, Normal Beats per week, %r, space(3), if(%qy, You have, %qn has), %b, earned, %b, default(%0/_special.beats_earned.normal, 0), %b, out of, %b, u(f.weekly_beats.max_earnable, %0), %b, Normal Beats this week, %r, space(3), It will be reset next Sunday at 11:59 PM CST., %r,))

&c.xp/award [v(d.xpas)]=$^\+?xp/award(.+)$:@assert isstaff(%#)={@pemit %#=u(.msg, xp/award, Staff only)}; @assert sql(select 1)={@pemit %#=u(.msg, xp/award, SQL connection is down%; award not processed)}; think strcat(name (w/type):, setr(n, first(%1, =)), %r, type:, setr(t, if(t(setr(t, trim(rest(%qn, /)))), %qt, normal)), %r, name:, setr(n, trim(first(%qn, /))), %r, amt (w/reason):, setr(a, rest(%1, =)), %r, reason:, setr(r, trim(rest(%qa, %bfor%b))), %r, amt:, setr(a, trim(first(%qa, %bfor%b)))); @assert hastype(setr(p, pmatch(%qn)), PLAYER)={@pemit %#=u(.msg, xp/award, Could not find '%qn')}; @assert cor(isapproved(%qp), isapproved(%qp, chargen))={@pemit %#=u(.msg, xp/award, '[name(%qp)]' is not approved nor in chargen)}; @assert hastype(setr(p, pmatch(%qn)), PLAYER)={@pemit %#=u(.msg, xp/award, Could not find '%qn')}; @assert isint(%qa)={@pemit %#=u(.msg, xp/award, Award must be an integer)}; @assert strlen(%qr)={@pemit %#=u(.msg, xp/award, Must include reason)}; @break cor(strmatch(%qr, *|*), strmatch(%qr, *`*))={@pemit %#=u(.msg, xp/award, May not use | or ` in reason)}; @assert t(match(v(d.xp_types), %qt))={@pemit %#=u(.msg, xp/award, I can't find the '%qt' type)}; think strcat(experience:, setr(x, get(%qp/_special.beats.%qt)), %r, beats earned:, setr(b, udefault(f.beats_earned.%qt, get(%qp/_special.beats_earned.%qt), %qp)), %r, expected award attribute:, setr(f, add(%qa, %qb)), %r, total weekly earnable:, setr(e, u(f.weekly_beats.max_earnable, %qp)), %r, amount to send to bank:, setr(k, if(gt(%qf, %qe), sub(%qf, %qe), 0)), %r, final award attribute:, setr(f, sub(%qf, %qk)), %r, final xp attribute:, setr(x, sub(%qx, %qk)), %r, bank experience:, setr(n, get(%qp/_special.bank.%qt))); @assert cor(lte(%qf, %qe), isapproved(%qp, chargen))={@pemit %#=u(.msg, xp/award, '[name(%qp)]' cannot take that many %qt beats. They can only take '[floor(sub(%qe, %qb))]' more beats for the rest of their week.)}; @set/quiet %qp=_special.beats.%qt:[add(first(%qx), %qa)] [rest(%qx)];@set/quiet %qp=_special.beats_earned.%qt:[if(isapproved(%qp), %qf)]; @set/quiet %qp=_special.bank.%qt:[add(%qn, %qk)];think strcat(tranaction begin, u(f.transaction.begin), %r, sanitized reason:, setr(s, u(f.sql.escape, %qr)), %r, add to xp_log:, sql(u(sql.insert.award, %qp, %#, %qt, %qa, %qs)), %r, tranaction end, u(f.transaction.end)); @pemit %#=u(.msg, xp/award, You have awarded '[name(%qp)]' [u(.plural, %qa, Beat, Beats)] [if(not(strmatch(%qt, normal)), %(%qt%)%b)]for '%qr'); @pemit %qp=u(.msg, xp/award, [moniker(%#)] has just awarded you [u(.plural, %qa, Beat, Beats)] [if(not(strmatch(%qt, normal)), %(%qt%)%b)]for '%qr');@cemit Monitor=u(.msg, xp/award, [moniker(%#)] just gave [name(%qP)] [u(.plural, %qa, Beat, Beats)] for '%qr');

&f.time-until-next-purchase [v(d.xpas)]=min(604800, ulocal(f.get_spend_time_multiplier, %1, %2))

&f.get_spend_time_multiplier [v(d.xpas)]=if(switch(%0, advantage.blood_potency, 1, advantage.primal_urge, 1, advantage.satiety, 1, 0), mul(604800, if(gt(%1, 4), %1, 4)), mul(604800, %1))

&validate.spend_time [v(d.xpas)]=if(lt(secs(), setr(0, add(ulocal(f.last-purchase, %0, %1), ulocal(f.get_spend_time_multiplier, %1, %2)))), You can't buy this stat yet - not enough time has elapsed. Try back on [convsecs(%q0)].)

&timer.? [v(d.xpcd)]=mul(604800, ulocal(.value, %0, %1))

&timer.advantage.blood_potency [v(d.xpcd)]=mul(604800, if(gt(setr(0, ulocal(.value, %0, %1)), 4), %q0, 4))

&timer.advantage.primal_urge [v(d.xpcd)]=mul(604800, if(gt(setr(0, ulocal(.value, %0, %1)), 4), %q0, 4))

&timer.advantage.satiety [v(d.xpcd)]=mul(604800, if(gt(setr(0, ulocal(.value, %0, %1)), 4), %q0, 4))

&timer.advantage.glamour [v(d.xpcd)]=mul(604800, if(gt(setr(0, ulocal(.value, %0, %1)), 4), %q0, 4))

think Entry complete.

think This is the census of how much XP is rolling around on the game.

&sql.where-is-active-player [v(d.xpas)]=strcat(and target_objid IN %(, iter(u(F.APPROVED_CHARACTERS), strcat(', u(.objid, itext(0)), '),, %,), %))

&sql.get-top-10-players [v(d.xpas)]=strcat(SELECT TRIM(SUM(xp_amt)/5)+0%, target_name FROM xp_log WHERE action IN ('gain'%, 'auto'), %b, u(sql.where-is-active-player), %b, GROUP BY target_objid%, target_name ORDER BY SUM(xp_amt) DESC LIMIT 0%,10)

&sql.get-top-10-players [v(d.xpas)]=strcat(SELECT SUM%(XP%) AS XP%, target_name FROM %(SELECT TRIM%(SUM%(xp_amt%)/5%)+0 AS XP%, target_name FROM xp_log WHERE action IN %('gain'%, 'auto'%), %b, u(sql.where-is-active-player), %b, GROUP BY target_name UNION SELECT TRIM%(0 - SUM%(xp_amt%)/5%)+0 AS XP%, target_name FROM xp_log WHERE action IN %('unaward'%), %b, u(sql.where-is-active-player), %b, GROUP BY target_name%) DERIVTBL GROUP BY target_name ORDER BY XP DESC LIMIT 0%, 10)

&sql.get-top-10-unspent-players [v(d.xpas)]=strcat(SELECT SUM%(XP%) AS XP%, target_name FROM %(SELECT TRIM%(SUM%(xp_amt%)/5%)+0 AS XP%, target_name FROM xp_log WHERE action IN %('gain'%, 'auto'%), %b, u(sql.where-is-active-player), %b, GROUP BY target_name UNION SELECT TRIM%(0 - SUM%(xp_amt%)/5%)+0 AS XP%, target_name FROM xp_log WHERE action IN %('unaward'%, 'spend'%, 'deduct'%), %b, u(sql.where-is-active-player), %b, GROUP BY target_name%) DERIVTBL GROUP BY target_name ORDER BY XP DESC LIMIT 0%, 10)

&sql.get-avg-xp [v(d.xpas)]=strcat(SELECT ROUND(AVG%(XP%)%, 2) FROM %(SELECT TRIM%(SUM%(xp_amt%)/5%)+0 AS XP%, target_name FROM xp_log WHERE action IN %('gain'%, 'auto'%), %b, u(sql.where-is-active-player), %b, GROUP BY target_name UNION SELECT TRIM%(0 - SUM%(xp_amt%)/5%)+0 AS XP%, target_name FROM xp_log WHERE action IN %('unaward'%), %b, u(sql.where-is-active-player), %b, GROUP BY target_name%) DERIVTBL)

&sql.get-total-xp [v(d.xpas)]=strcat(SELECT SUM%(XP%) FROM %(SELECT TRIM%(SUM%(xp_amt%)/5%)+0 AS XP FROM xp_log WHERE action IN %('gain'%, 'auto'%), %b, u(sql.where-is-active-player), %b, UNION SELECT TRIM%(0 - SUM%(xp_amt%)/5%)+0 AS XP FROM xp_log WHERE action IN %('unaward'%), %b, u(sql.where-is-active-player), %) DERIVTBL)

&sql.get-spent-xp [v(d.xpas)]=strcat(SELECT SUM%(XP%) FROM %(SELECT TRIM%(SUM%(xp_amt%)/5%)+0 AS XP FROM xp_log WHERE action IN %('spend'%, 'deduct'%), %b, u(sql.where-is-active-player), %b, UNION SELECT TRIM%(0 - SUM%(xp_amt%)/5%)+0 AS XP FROM xp_log WHERE action IN %('unspend'%), %b, u(sql.where-is-active-player), %) DERIVTBL)

&layout.census [v(d.xpas)]=strcat(wheader(XP Census), %r, %b, ljust(Number of approved players:, 42), %b, words(u(F.APPROVED_CHARACTERS)), %R%R, %b, ljust(Average player XP:, 42), %b, sql(ulocal(sql.get-avg-xp)), %r%r, %b, ljust(Total player XP across all approved PCs:, 42), %b, sql(ulocal(sql.get-total-xp)), %r%r, %b, ljust(Spent XP across all approved PCs:, 42), %b, sql(ulocal(sql.get-spent-xp)), %r%r, %b, Top 10 players by max XP:, %r, iter(sql(ulocal(sql.get-top-10-players), |, ~), strcat(space(3), ljust(inum(0)., 3), %b, ljust(first(itext(0), ~), 4), %b-%b, rest(itext(0), ~)), |, %r), %r%r, %b, Top 10 players with unspent XP:, %r, iter(sql(ulocal(sql.get-top-10-unspent-players), |, ~), strcat(space(3), ljust(inum(0)., 3), %b, ljust(first(itext(0), ~), 4), %b-%b, rest(itext(0), ~)), |, %r), %r, %r, wfooter())

&c.xp/census [v(d.xpas)]=$^\+?xp/census$:@assert isstaff(%#, wizard)={@pemit %#=u(.msg, xp/census, Wizard only)}; @pemit %#=u(layout.census);

@set v(d.xpas)/c.xp/census=regex

@set v(d.xpas)/c.xp/census=no_parse

think Done.
