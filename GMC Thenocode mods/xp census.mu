
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
