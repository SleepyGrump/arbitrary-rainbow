/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/7%20-%20Sheet/7b%20-%20Blocks.txt

Compiled 2019-11-07

*/

think Entering 17 lines.

&bio.default [v(d.nsc)]=iter(udefault(%!/bio.default.%1, full_name birthdate concept template virtue vice, %0), if(t(%i0), ulocal(f.cheat_getstat.with_name, %0, bio.%i0, string), %b),, |)

&attributes.mental.default [v(d.nsc)]=iter(intelligence wits resolve, ulocal(f.cheat_getstat.with_name, %0, attribute.%i0, numeric),, |)

&attributes.physical.default [v(d.nsc)]=iter(strength dexterity stamina, ulocal(f.cheat_getstat.with_name, %0, attribute.%i0, numeric),, |)

&attributes.social.default [v(d.nsc)]=iter(presence manipulation composure, ulocal(f.cheat_getstat.with_name, %0, attribute.%i0, numeric),, |)

&skills.default [v(d.nsc)]=iter(mental physical social, strcat(# [capstr(%i0)], |, ulocal(skills.%i0.default, %0)),, |)

&skills.mental.default [v(d.nsc)]=iter(academics computer crafts investigation medicine occult politics science, u(f.cheat_getstat.skill-n-specs, %0, %i0),, |)

&skills.physical.default [v(d.nsc)]=iter(athletics brawl drive firearms larceny stealth survival weaponry, u(f.cheat_getstat.skill-n-specs, %0, %i0),, |)

&skills.social.default [v(d.nsc)]=iter(animal_ken empathy expression intimidation persuasion socialize streetwise subterfuge, u(f.cheat_getstat.skill-n-specs, %0, %i0),, |)

&merits.default [v(d.nsc)]=iter(filter(fil.subtraits, sort(edit(lattr(%0/_merit.*), _MERIT.,))), case(ulocal(v(d.sfp)/f.get-class, merit.%i0), list, ulocal(f.cheat_getstat.with_name, %0, merit.%i0, list), ulocal(f.cheat_getstat.trait-n-subtrait, %0, %i0, merit)),, |)

&fil.subtraits [v(d.nsc)]=not(strmatch(%0, *.*))

&traits.default [v(d.nsc)]=strcat(u(traits.willpower.default, %0), |, u(traits.morality.default, %0))

&traits.willpower.default [v(d.nsc)]=ulocal(f.cheat_getstat.pool, %0, willpower)

&traits.morality.default [v(d.nsc)]=ulocal(f.cheat_getstat.morality, %0, integrity)

&traits.supernatural_resistance [v(d.nsc)]=ulocal(f.cheat_getstat.with_name, %0, filter(v(d.sfp)/fil.list-stats-tags, lattr(v(d.dd)/advantage.*),,, power.[get(%0/_bio.template)], 1), numeric)

&traits.power_pool [v(d.nsc)]=ulocal(f.cheat_getstat.pool, %0, elements(filter(v(d.sfp)/fil.list-stats-tags, lattr(v(d.dd)/advantage.*),, ., pool.[get(%0/_bio.template)], 1), 2, .))

&advantages.default [v(d.nsc)]=iter(defense weaponry_defense brawl_defense speed initiative size perception [udefault(advantages.[get(%0/_bio.template)], null(null))], ulocal(f.cheat_getstat.with_name, %0, advantage.%i0, numeric),, |)

&health.default [v(d.nsc)]=localize(strcat(ulocal(v(d.health)/display.health-bar, iter(u(v(d.dd)/health.types), u(v(d.dd)/.value, %0, health.%i0)), ladd(ulocal(f.cheat_getstat.numeric, %0, health.maximum), .)), |, ulocal(f.cheat_getstat.with_name, %0, health.penalty, numeric)))

think Entry complete.
