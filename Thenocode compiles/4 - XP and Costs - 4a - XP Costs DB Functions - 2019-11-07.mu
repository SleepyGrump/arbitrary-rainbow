/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/4%20-%20XP%20and%20Costs/4a%20-%20XP%20Costs%20DB%20Functions.txt

Compiled 2019-11-07

*/

think Entering 21 lines.

@create XP Cost Database <xpcd>=10

@set XP Cost Database <xpcd>=inherit safe

@force me=&d.xpcd me=search(name=XP Cost Database <xpcd>)

@fo me=@parent XP Cost Database <xpcd>=[v(d.codp)]

&prefix.calculations XP Cost Database <xpcd>=cost.

&prefix.xp_costs XP Cost Database <xpcd>=xp.

@fo me=&d.dd XP Cost Database <xpcd>=[search(name=Data Dictionary <dd>)]

@fo me=&d.dt XP Cost Database <xpcd>=[search(name=Data Tags <dt>)]

@fo me=&d.sfp XP Cost Database <xpcd>=[search(name=Stat Functions Prototype <sfp>)]

&.lmax [v(d.xpcd)]=fold(.lmax.fold, %0)

&.lmax.fold [v(d.xpcd)]=max(%0, %1)

&.lmin [v(d.xpcd)]=fold(.lmin.fold, %0)

&.lmin.fold [v(d.xpcd)]=min(%0, %1)

&.between [v(d.xpcd)]=cand(gte(%0, min(%1, %2)), lte(%0, max(%1, %2)))

&.between_else [v(d.xpcd)]=cand(gt(%0, min(%1, %2)), lt(%0, max(%1, %2)))

&.value [v(d.xpcd)]=u(v(d.dd)/.value, %0, %1, %2, %3)

&.at_least [v(d.xpcd)]=u(v(d.dd)/.at_least, %0, %1, %2, %3)

&.is [v(d.xpcd)]=u(v(d.dd)/.is, %0, %1, %2, %3)

&.is_full [v(d.xpcd)]=u(v(d.dd)/.is_full, %0, %1, %2, %3)

&.value_full [v(d.xpcd)]=u(v(d.dd)/.value_full, %0, %1, %2, %3)

&cost.standard [v(d.xpcd)]=mul(%0, sub(%2, %1))

think Entry complete.
