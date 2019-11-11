/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/4%20-%20XP%20and%20Costs/4c5%20-%20XP%20Deduct.txt

Compiled 2019-11-07

Changed 'unspend' to 'deduct'.
*/

think Entering 4 lines.

&d.deduct.allowed_types [v(d.xpas)]=normal story arcane

&c.xp/deduct [v(d.xpas)]=$^\+?xp/deduct(.*)$:@assert hasflag(%#, W)={@pemit %#=u(.msg, xp/deduct, Wizard only)}; @assert sql(select 1)={@pemit %#=u(.msg, xp/deduct, SQL connection not available%; deduct canceled)}; think strcat(null(regmatchi(%1, (.+?)(/(.+?))?=(.+?) for (.+), 0 n 0 t a r)), name:, setr(n, trim(%qn)), %r, type:, setr(t, trim(%qt)), %r, amt:, setr(a, trim(%qa)), %r, reason:, setr(r, trim(%qr)), %r, type (validated):, setr(v, grab(cat(normal, v(d.xp_types)), %qt*)), %r, value in experience:, setr(b, switch(rest(%qa), b*, fdiv(first(%qa), v(d.beat-to-exp)), x*, first(%qa),, first(%qa), I don't know what you mean by '%qa')), %r, character dbref:, setr(d, pmatch(%qn)), %r, current beats attr:, setr(x, get(%qd/_special.beats.%qv)), %r,); @assert match(v(d.deduct.allowed_types), %qv)={@pemit %#=u(.msg, xp/deduct, strcat(XP type is, %b, if(strmatch(%qt,), unset (implied 'normal'), '%qt'), %b%; must be, %b, itemize(iter(v(d.deduct.allowed_types), '%i0'),, or)))}; @assert cand(strlen(%qn), strlen(%qa), strlen(%qr))={@pemit %#=u(.msg, xp/deduct, You must at least enter a target's name%, amount to deduct%, and reason)}; @assert hastype(%qd, PLAYER)={@pemit %#=u(.msg, xp/deduct, Could not find player '%qn')}; @assert cor(isapproved(%qp), isapproved(%qp, chargen))={@pemit %#=u(.msg, xp/deduct, '[name(%qp)]' is not approved nor in chargen)}; @assert cand(isint(first(%qa)), gt(first(%qa), 0))={@pemit %#=u(.msg, xp/deduct, Amount must be a positive integer)}; @assert strlen(%qv)={@pemit %#=u(.msg, xp/deduct, I can't find the '%qt' type)}; @assert isnum(%qb)={@pemit %#=u(.msg, xp/deduct, %qb)}; @break cor(strmatch(%qr, *|*), strmatch(%qr, *`*))={@pemit %#=u(.msg, xp/deduct, May not use | or ` in reason)}; @break setr(e, u(validate.spend, %qb, %qx, %qv))={@pemit %#=u(.msg, xp/deduct, %qe)}; @set/quiet %qd=_special.beats.%qv:[first(%qx)] [sub(rest(%qx), mul(%qb, v(d.beat-to-exp)))];think strcat(tranaction begin, u(f.transaction.begin), %r, sanitized reason:, setr(s, u(f.sql.escape, %qr)), %r, add to xp_log:, sql(u(sql.insert.spend, %qd, %#, %qv, mul(%qb, v(d.beat-to-exp)), null(no statpath), %qr, null(no new value), null(no old value))),, %r, tranaction end, u(f.transaction.end)type of experiences:, setr(z, if(not(strmatch(%qv, normal)), [capstr(%qv)]%b)), %r,);@pemit %#=u(.msg, xp/deduct, strcat(You have deducted, %b, u(.plural, %qb, %qzExperience, %qzExperiences), %b, from, %b, name(%qd), %b, for reason '%qr')); @pemit %qd=u(.msg, xp/deduct, strcat(moniker(%#), %b, has just deducted you, %b, u(.plural, %qb, %qzExperience, %qzExperiences), %b, for reason '%qr'));

@set v(d.xpas)/c.xp/deduct=regexp

@set v(d.xpas)/c.xp/deduct=no_parse

think Entry complete.
