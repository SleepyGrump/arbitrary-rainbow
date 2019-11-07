/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/5%20-%20Health%20System/5a%20-%20Health%20Setup%20and%20Data.txt

Compiled 2019-11-07

*/

think Entering 23 lines.

&health.maximum [v(d.dd)]=u(.value_stats_template, %0, attribute.stamina advantage.size, health.maximum)

&tags.health.maximum [v(d.dt)]=derived

&default.health.maximum [v(d.dd)]=derived

&health.types [v(d.dd)]=bashing lethal aggravated

&health.bashing [v(d.dd)]=#

&health.lethal [v(d.dd)]=#

&health.aggravated [v(d.dd)]=#

&default.health.bashing [v(d.dd)]=0

&default.health.lethal [v(d.dd)]=0

&default.health.aggravated [v(d.dd)]=0

&health.damage [v(d.dd)]=ladd(iter(u(health.types), u(.value, %0, health.%i0)))

&tags.health.damage [v(d.dt)]=derived

&default.health.damage [v(d.dd)]=derived

&health.penalty [v(d.dd)]=min(0, add(u(.value, %0, health.maximum), mul(-1, u(.value, %0, health.damage)), u(.value, %0, merit.iron_stamina), -3))

&tags.health.penalty [v(d.dt)]=derived

&default.health.penalty [v(d.dd)]=derived

@create WoD Health System <whs>

@fo me=&d.whs me=search(name=WoD Health System <whs>)

@set WoD Health System <whs>=inherit safe

@fo me=@parent WoD Health System <whs>=[v(d.codp)]

@fo me=&d.data-dictionary [v(d.whs)]=search(name=Data Dictionary <dd>)

@fo me=&d.stat-funcs [v(d.whs)]=search(name=Stat Functions Prototype <sfp>)

&d.health-types [v(d.whs)]=u([u(d.data-dictionary)]/health.types)

think Entry complete.
