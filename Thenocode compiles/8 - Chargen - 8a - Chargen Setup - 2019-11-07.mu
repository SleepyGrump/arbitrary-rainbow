/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/8%20-%20Chargen/8a%20-%20Chargen%20Setup.txt

Compiled 2019-11-07

*/

think Entering 21 lines.

@create GMC Chargen <cg>

@fo me=&d.cg me=[search(name=GMC Chargen <cg>)]

@set GMC Chargen <cg>=inherit safe

@fo me=@parent GMC Chargen <cg>=[v(d.codp)]

&prefix.checks [v(d.cg)]=check.

&prefix.display [v(d.cg)]=format. display.

@fo me=&d.dd [v(d.cg)]=search(name=data dictionary <dd>)

@fo me=&d.dt [v(d.cg)]=search(name=data tags <d:t>)

@fo me=&d.sfp [v(d.cg)]=search(name=stat functions prototype <sfp>)

@fo me=&d.asp [v(d.cg)]=search(name=aspirations system <asp>)

@fo me=&d.cg [v(d.nsc)]=search(name=GMC Chargen <cg>)

@fo me=&d.cg [v(d.xpas)]=search(name=GMC Chargen <cg>)

&c.cg [v(d.cg)]=$^\+?cg$:@pemit %#=Yup, it's chargen. See Also: +help chargen

@set v(d.cg)/c.cg=regexp

&c.chargen [v(d.cg)]=$^\+?chargen$:@pemit %#=You probably want 'cg'. See Also: +help chargen

@set v(d.cg)/c.chargen=regexp

&.msg [v(d.cg)]=ansi(h, <%0>, n, %b%1)

&fil.stats-to-include [v(d.cg)]=cand(strmatch(%0, %1.*), u(v(d.sfp)/fil.list-stats-tags, before(%0, :), %2))

&fil.subitem-not-in-list [v(d.cg)]=not(match(%1, elements(%0, 1, .)))[filter(v(d.cg)/fil.subitem-not-in-list, a.1 a.2 c.1 e.1,,, a b c d)] --> e.1

&f.list-stats-tags [v(d.cg)]=filter([v(d.sfp)]/fil.list-stats-tags, rest(edit(lattr(%0/_%1.*), %b_, %b), _),,, %2, not(strmatch(%3, or)))

&f.points.category [v(d.cg)]=strcat(setq(l, u(f.list-stats-tags, %0, %1, %2)), setr(s, ladd(iter(%ql, first(u(%0/_%i0), .)))))

think Entry complete.
