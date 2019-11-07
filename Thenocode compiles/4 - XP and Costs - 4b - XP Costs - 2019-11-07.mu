/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/4%20-%20XP%20and%20Costs/4b%20-%20XP%20Costs.txt

Compiled 2019-11-07

*/

think Entering 7 lines.

&xp.attribute [v(d.xpcd)]=u(cost.standard, 4, %1, %2)

&xp.skill [v(d.xpcd)]=u(cost.standard, 2, %1, %2)

&xp.skill.?.? [v(d.xpcd)]=1

&xp.advantage.willpower [v(d.xpcd)]=u(cost.standard, 1, %1, %2)

&xp.advantage.integrity [v(d.xpcd)]=udefault(xp.advantage.integrity.[get(%0/_bio.template)], u(xp.advantage.integrity.default), %0, %1, %2)

&xp.advantage.integrity.default [v(d.xpcd)]=u(cost.standard, 3, %1, %2)

&xp.merit [v(d.xpcd)]=u(cost.standard, 1, %1, %2)

think Entry complete.
