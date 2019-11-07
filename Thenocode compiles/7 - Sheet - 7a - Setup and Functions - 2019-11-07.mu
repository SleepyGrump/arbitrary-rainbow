/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/7%20-%20Sheet/7a%20-%20Setup%20and%20Functions.txt

Compiled 2019-11-07

*/

think Entering 29 lines.

@create Newest Sheet Code <nsc>=10

@fo me=&d.nsc me=[num(Newest Sheet Code <nsc>)]

@set Newest Sheet Code <nsc>=inherit safe

@fo me=&d.sfp [v(d.nsc)]=search(name=Stat Functions Prototype <sfp>)

@fo me=&d.health [v(d.nsc)]=search(name=WoD Health System <whs>)

@fo me=&d.dd [v(d.nsc)]=search(name=Data Dictionary <dd>)

@fo me=@parent [v(d.nsc)]=[v(d.codp)]

&prefix.dot-functions [v(d.nsc)]=.

&prefix.block_bio [v(d.nsc)]=bio.

&prefix.block_attribute [v(d.nsc)]=attributes.

&prefix.block_skill [v(d.nsc)]=skills.

&prefix.block_merit [v(d.nsc)]=merits.

&prefix.block_traits [v(d.nsc)]=traits.

&prefix.block_advantages [v(d.nsc)]=advantages.

&prefix.block_health [v(d.nsc)]=health.

&prefix.block_powers [v(d.nsc)]=powers.

&.titlestr [v(d.nsc)]=titlestr(edit(%0, _, %b))

&.isstaff [v(d.nsc)]=isstaff(%0)

&c.sheet [v(d.nsc)]=$^\+?sheet([\s\S]+)?$:think cat(target:, setr(t, if(t(%1), trim(%1), %#)), %r, pmatch:, setr(p, pmatch(%qt)), %r, sheet loc:, setr(s, u(v(d.sfp)/f.find-sheet, %qp)), %r, which sheet?:, setr(w, default(%#/.sheet.display, rows)), %r, where sheet display:, setr(a, locate(%!, Sheet: %qw, i))); @assert t(%qp)={@pemit %#=Player not found.}; @assert isdbref(%qs)={@pemit %#=Sheet not found.}; @assert cor(u(.isstaff, %#), not(%qt), strmatch(%qp, %#))={@pemit %#=Staff only.}; @assert t(%qa)={@pemit %#=I can't find the sheet display type you want me to find. This is a lame error.}; @pemit %#=u(%qw/display.sheet, %qs, %qp, get(%qs/_bio.template));

@set v(d.nsc)/c.sheet=regex

&f.cheat_getstat.numeric [v(d.nsc)]=if(comp(setr(t, ulocal(v(d.sfp)/f.getstat.workhorse.numeric, %0, _%1)), null(null)), %qt, 0)

&f.cheat_getstat.string [v(d.nsc)]=default(%0/_%1, <not set>)

&f.cheat_getstat.list [v(d.nsc)]=localize(strcat(setq(1, u(v(d.sfp)/f.statpath-without-instance, %1)), setq(v, get(v(d.dd)/%q1)), setq(s, elements(%qv, 2, |)), setq(v, elements(%qv, 1, |)), iter(get(%0/_%1), strcat(%i0, ., elements(%qs, match(%qv, %i0, .), .)), ., :)))

&f.cheat_getstat.with_name [v(d.nsc)]=strcat(u(.titlestr, rest(%1, .)), :, ulocal(f.cheat_getstat.%2, %0, %1))

&f.cheat_getstat.name_only [v(d.nsc)]=u(.titlestr, rest(%1, .))

&f.cheat_getstat.trait-n-subtrait [v(d.nsc)]=strcat(ulocal(f.cheat_getstat.with_name, %0, %2.%1, numeric), if(words(setr(s, sort(lattr(%0/_%2.%1.*)))), |[iter(%qs, * [u(.titlestr, edit(%i0, ucstr(_%2.%1.),))],, |)]))

&f.cheat_getstat.skill-n-specs [v(d.nsc)]=u(f.cheat_getstat.trait-n-subtrait, %0, %1, skill)

&f.cheat_getstat.pool [v(d.nsc)]=strcat(titlestr(edit(%1, _, %b)), :, ulocal(f.cheat_getstat.numeric, %0, advantage.%1), |, titlestr(edit(%1, _, %b)), %b, Maximum:, ulocal(f.cheat_getstat.numeric, %0, advantage.%1_maximum))

&f.cheat_getstat.morality [v(d.nsc)]=if(strlen(%2), %2:[ulocal(f.cheat_getstat.numeric, %0, advantage.%1, numeric)], ulocal(f.cheat_getstat.with_name, %0, advantage.%1, numeric))

think Entry complete.
