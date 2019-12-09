@@ Add CG checks that remind players to get their free dots of totem and First Tongue

@@ Also, Werewolves can spend up to 5 points of merit dots on rites. Not sure how to do that yet...

@@ &f.allocated.rites [v(d.cg)]=ladd(iter(lattr(%0/_rite.*), get(%0/%i0)))

@@ &check.rites [v(d.cg)]=strcat(setq(g, u(f.allocated.rites, %0)), %b%b, ansi(h, Rites), :, %b, %qg out of 2, %b, u(display.check.ok-no, eq(%qg, 2)), %r)

@@ For now we just cover regular merits.

&f.allocated.merits.werewolf [v(d.cg)]=add(t(get(%0/_merit.language_%(First_Tongue%))), t(get(%0/_merit.totem)))

&check.chargen.werewolf [v(d.cg)]=strcat(u(check.merits.werewolf, %0), u(check.renown, %0), u(check.gifts, %0), u(check.rites, %0))

&check.merits.werewolf [v(d.cg)]=strcat(%b, %b, ansi(h, Free Language %(First Tongue%) and free Totem), :, %b, u(display.check.ok-no, eq(u(f.allocated.merits.werewolf, %0), 2)), %r)

@@ Wolf-blooded get a free Tell and Totem - NOLA house rules nuked the Pack Bond merit and auto-grant Totem to wolf-blooded.

&f.allocated.merits.wolf-blooded [v(d.cg)]=add(t(get(%0/_merit.totem)), get(%0/[first(lattr(%0/_merit.tell_(*)))]))

&check.chargen.wolf-blooded [v(d.cg)]=strcat(%b, %b, ansi(h, Free Tell and free Totem), :, %b, u(display.check.ok-no, eq(u(f.allocated.merits.wolf-blooded, %0), 4)), %r)

@@ Custom prereq: Heirs of Trois-Frere mystery cult initiation can also take Totem.

&prerequisite.merit.totem [v(d.dd)]=or(u(.is_one_of, %0, bio.template, werewolf.wolf-blooded), u(.has, %0, merit.mystery_cult_initiation_(heirs_of_trois-frere)))

&prereq-text.merit.totem [v(d.dd)]=You must either be a wolf-blooded, werewolf, or a member of the Mystery Cult of the Heirs of Trois-Frere.

&tags.merit.totem [v(d.dt)]=werewolf.wolf-blooded.shared.human.atariya.dreamer.infected.plain.lost boy.psychic vampire.ghoul


&merit.pack_bond [v( d.dd )]=

&tags.merit.pack_bond [v( d.dt )]=


@@ Ghost Wolves get one fewer dot of Renown than regular wolves.

&check.renown [v(d.cg)]=strcat(setq(r, lattr(v(d.dd)/renown.*)), setq(a, edit(filter(v(d.sfp)/fil.list-stats-tags, %qr,,, [get(%0/_bio.auspice)].[get(%0/_bio.tribe)]), RENOWN.,)), setq(c, edit(lattr(%0/_renown.*), _RENOWN.,)), setq(t, 0), divider(Chargen Levels: Renown), %r, iter(setunion(%qc, %qa), strcat(%b%b, ansi(h, titlestr(%i0)), :, %b, setr(x, default(%0/_renown.%i0, 0)), setq(t, add(%qt, %qx)), if(cand(t(match(%qa, %i0)), lt(%qx, 1)), ansi(n, %b%[, r, must exist, n, %])),),, %r), %r, %b%b, ansi(h, Points Spent), : %qt/, setr(z, switch(get(%0/_bio.tribe), Ghost Wolves, 2, 3)), %b, u(display.check.ok-no, eq(%qt, %qz)), %r,)

@@ Werewolf gifts are too wide.

&display.gift [v(d.sheet)]=strcat(setq(n, first(%0, :)), setq(r, rest(%0, :)), setq(u, grab(%qr, Unlock.*, :)), setq(s, match(first(get(v(d.dd)/gift.[edit(%qn, %b, _)]), |), Unlock, .)), if(cand(strmatch(%qr, Unlock.*), eq(words(%qr, :), 1)), setq(r, .[rest(%qu, .)]), setq(r, remove(%qr, %qu, :))), if(cand(%qs, not(%qu)), setq(n, ansi(n, %qn%b, xh, %(not unlocked%)))), setq(t, strcat(rest(first(%qr, :), .), if(t(setr(z, first(first(%qr, :), .))), strcat(%b, %(, first(first(%qr, :), .), %))))), setq(l, sub(%1, add(strlen(%qn), strlen(%qt), 8))), %qn, %b, ansi(xh, repeat(%2, %ql)), %b, %qt, iter(rest(%qr, :), %r[rjust(strcat(rest(%i0, .), %b, %(, first(%i0, .), %)), sub(%1, 6))], :, @@))

