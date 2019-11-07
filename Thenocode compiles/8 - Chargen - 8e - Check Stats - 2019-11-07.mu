/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/8%20-%20Chargen/8e%20-%20Check%20Stats.txt

Compiled 2019-11-07

*/

think Entering 22 lines.

&f.statcheck [v(d.cg)]=localize(strcat(setq(s, ulocal(v(d.sfp)/f.statpath-without-instance, rest(%1, _))), setq(c, ulocal(v(d.sfp)/f.get-class, %qs)), setq(v, case(%qc, numeric, first(u(%0/%1), .), u(%0/%1))), setq(t, case(1, strmatch(%1, _*.*.*), u(f.statcheck.substat, %0, %1, %2), ulocal(v(d.sfp)/f.hastag?.workhorse, %qs, derived), ulocal(f.statcheck.derived, %0, %1, %qc), strmatch(%qc, list), ulocal(f.statcheck.list, %qs, %qv, %2), ulocal(f.statcheck.normal, %1, %qs, %qv, %2))), if(strlen(%qt), 1, %qt), ., iter(cg-only template other, ulocal(f.prerequisite.%i0, %0, %1, %2),, .)))

&f.statcheck.normal [v(d.cg)]=localize(strcat(setq(t, if(hasattr([u(d.dd)], %1), 1, #-1 Stat not found)), setq(t, if(cand(t(%qt), strmatch(%0, _*.*_(*))), strcat(setq(i, edit(strip(rest(%0, %(), %)), _, %b)), setq(d, extract(get([u(d.dd)]/%1), 2, 1, |)), case(1, t(member(%qd, *)), 1, and(member(%qd, #), isint(%qi)), 1, t(match(%qd, %qi, .)), 1, #-1 Instance is not valid %(%qi%))), %qt)), setq(v, case(1, and(isnum(%2), t(%3)), add(%2, %3), t(%3), %3, %2)), if(strlen(%qt), ulocal([u(d.sfp)]/f.statvalidate.workhorse, %1, %qv), %qt)))

&f.statcheck.derived [v(d.cg)]=case(0, hasattr(%0, %1), #-1 Derived stat is not set, not(strmatch(%2, string)), 1, strmatch(%2, numeric), if(isint(first(ulocal(v(d.sfp)/f.getstat.workhorse.numeric, %0, %1), .)), 1, #-1 Derived stat is non-numeric), if(strlen(ulocal(v(d.sfp)/f.getstat.workhorse.%2, %0, %1)), 1, #-1 Derived stat returns null))

&f.statcheck.substat [v(d.cg)]=localize(case(1, not(cand(isint(setr(t, first(u(%0/[elements(%1, 1 2, .)]), .))), gt(%qt, 0))), if(strmatch(%1, _skill.*), #-1 Specialties cannot be set if skill is zero or non-numeric, #-1 Substat cannot be set if main stat is zero or non-numeric), cand(strmatch(%1, _skill.*), gt(add(u(%0/%1), %2), 1)), #-1 Specialty substats must have a value of 1, 1))

&f.statcheck.list [v(d.cg)]=localize(strcat(setq(l, setinter(first(get(v(d.dd)/%0), |), setunion(%1, edit(%2, %b, .), .), .)), if(gte(words(%ql, .), 1), %ql, #-1 No list items valid)))

&f.badstat? [v(d.cg)]=not(land(u(f.statcheck, %1, %0), .))

&f.badstats [v(d.cg)]=iter(u([u(d.sfp)]/d.search-order), filter(f.badstat?, lattr(%0/_%i0.*),,, %0))

&c.cg/check [v(d.cg)]=$^\+?cg/check(.*):think strcat(player dbref:, %b, setr(p, if(t(strlen(trim(%1))), pmatch(trim(%1)), %#)), %r, sheet dbref:, %b, setr(s, u(u(d.sfp)/f.find-sheet, %qp)), %r, sheet template:, %b, setr(t, u(%qs/_bio.template))); @pemit %#=case(0, not(isapproved(%#, guest)), u(.msg, cg/check, Players only), t(%qp), u(.msg, cg/check, Player cannot be found), cor(isstaff(%#), not(comp(%qp, %#))), u(.msg, cg/check, You must be staff or checking yourself), t(%qs), u(.msg, cg/check, Can't find the sheet), t(%qt), u(.msg, cg/check, No template set), strcat(wheader(Checking [name(%qp)]'s Stats), %r, if(cor(isapproved(%qp, chargen), isapproved(%qp, unapproved), isstaff(%qp)), strcat(ulocal(check.bio, %qp, %qs, %qt), %r, ulocal(check.chargen, %qs, %qt, %qp),), u(display.cgen_stamp, %qp)%r), ulocal(check.badstats, %qs), %r, wfooter()))

@set v(d.cg)/c.cg/check=regex

&display.check.ok-no [v(d.cg)]=if(t(%0), ansi(n, \%[, g, OK, n, \%]), ansi(n, \%[, r, no, n, \%]))

&display.cgen_stamp [v(d.cg)]=cat(%b Chargen Approval Stamp:, elements(rest(setr(z, u(%0/_cgstamp)), |), 2 3 5), by, rest(first(%qz, |), Approved by%b))

&display.check.stats [v(d.cg)]=u(display.check.ok-no, u(f.pts-valid?.%1, %0, %2))

&check.bio [v(d.cg)]=strcat(setq(1, strcat(ansi(h, Gender), :, %b, setr(g, get(%0/sex)), %b, u(display.check.ok-no, match(f m, strtrunc(%qg, 1))), `, ansi(h, Concept), :, %b, if(hasattr(%0, _bio.concept), ansi(g, exists), ansi(r, blank)), `, iter(full_name birthdate, strcat(ansi(h, titlestr(edit(%i0, _, %b))), :, %b, setr(i, u(%1/_bio.%i0)), %b, u(display.check.ok-no, comp(%qi,))),, `))), setq(2, iter(cat(template, udefault(check.bio.%2, u(check.bio.default), %1)), strcat(ansi(h, titlestr(edit(%i0, _, %b))), :, %b, setr(i, u(%1/_bio.%i0)), %b, u(display.check.ok-no, comp(%qi,))),, `)), divider(Biography Check, width(%#)), %r, vcolumns(38:%q1, 37:%q2, `, %b, %b%b))

&check.bio.default [v(d.cg)]=virtue vice

&check.chargen [v(d.cg)]=strcat(divider(Chargen Levels, width(%#)), %r, %b%b, ansi(h, Attributes), :%b, udefault(check.chargen.attributes.%1, u(check.chargen.attributes.default, %0), %0), ulocal(check.chargen.attributes, %0, %1), %r, %b%b, ansi(h, Skills), :%b, udefault(check.chargen.skills.%1, u(check.chargen.skills.default, %0), %0), %r, ulocal(check.chargen.specialties, %0, %1), %r, %b%b, ansi(h, Aspirations), :%b, setq(a, u(f.allocated.aspirations, %0)), Short-Term:, %b, first(%qa, /), /2%,%b, Long-Term:, %b, rest(%qa, /), /1%b, u(display.check.stats, %0, aspirations), %r, %b%b, ansi(h, Merits), :%b, setq(a, u(f.allocated.merits, %0)), ladd(%qa, /), /10, %b%(, rest(%qa, /), %b, on Power Stat%), %b, u(display.check.stats, %0, merits), %r, u(check.chargen.%1, %0, %2))

&check.chargen.attributes.default [v(d.cg)]=strcat(u(f.allocated.attributes, %0), %b, %(of 5/4/3%), %b, u(display.check.stats, %0, attributes),)

&check.chargen.skills.default [v(d.cg)]=strcat(u(f.allocated.skills, %0), %b, %(of 11/7/4%), %b, u(display.check.stats, %0, skills))

&check.chargen.specialties [v(d.cg)]=strcat(setq(a, ulocal(f.allocated.specialties, %0)), setq(s, first(%qa, `)), setq(r, rest(%qa, `)), %b%b, ansi(h, Specialties), :%b, iter(%qs, ulocal(u(d.sfp)/f.statname.workhorse, rest(%i0, .)),, %,%b), ulocal(check.specialties.%1, %qr), %r%b%b, ansi(h, Final Specialties Check), %b, ->, %b, words(%qs), /3, %b, ulocal(display.check.stats, %0, specialties))

&check.specialties.changeling [v(d.cg)]=strcat(%b Changeling -%b, iter(elements(%0, 1, `), u(u(d.sfp)/f.statname-workhorse, rest(%i0, .)),, %,%b), if(strlen(elements(%0, 2, `), %r%b Seeming-%b)), iter(elements(%0, 2, `), u(u(d.sfp)/f.statname-workhorse, rest(%i0, .)),, %,%b), if(strlen(elements(%0, 3, `), %r%b Kith-%b)), iter(elements(%0, 3, `), u(u(d.sfp)/f.statname-workhorse, rest(%i0, .)),, %,%b))

&check.badstats [v(d.cg)]=strcat(wdivider(Invalid Stats), %r, setq(p, u(f.badstats, %0)), setq(i, iter(%qp, strcat(%(, lcstr(first(rest(%i0, _), .)), %)%b, ansi(c, u(u(d.sfp)/f.statname.workhorse, rest(%i0, .))), :, %b, itemize(trim(iter(u(f.statcheck, %0, %i0), if(not(%i0), [titlestr(rest(%i0))]|), ., @@), b, |), |)),, %r)), if(strlen(%qi), trim(wrap(%qi, sub(width(%#), 4), left, %b%b), r), %b All Stats Valid))

&c.cg/forcecheck [v(d.cg)]=$^\+?cg/forcecheck(.*):@pemit %#='cg/check' should now work for anyone who is not approved.

@set v(d.cg)/c.cg/forcecheck=regex

think Entry complete.
