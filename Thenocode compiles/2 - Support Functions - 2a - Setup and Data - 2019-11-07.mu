/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/2%20-%20Support%20Functions/2a%20-%20Setup%20and%20Data.txt

Compiled 2019-11-07

*/

think Entering 16 lines.

@create Stat Functions Prototype <sfp>

@set Stat Functions Prototype <sfp>=inherit safe

@fo me=&d.sfp me=[search(name=Stat Functions Prototype <sfp>)]

@fo me=@parent Stat Functions Prototype <sfp>=search(name=Code Object Data Parent <codp>)

@fo me=&d.data-dictionary [v(d.sfp)]=search(name=Data Dictionary <dd>)

@fo me=&d.data-tags [v(d.sfp)]=search(name=Data Tags <d:t>)

@fo me=&d.sfp [v(d.dd)]=search(name=Stat Functions Prototype <sfp>)

&.grabexact [v(d.sfp)]=localize(if(t(setr(m, grab(%0, %1, %2, %2))), %qm, grab(sort(%0, ?, %2, %2), %1*, %2)))

&.crumple [v(d.sfp)]=trim(squish(%0, %1), b, %1)

&.pmatch [v(d.sfp)]=localize(strcat(setq(p, if(strmatch(%0, me), %#, objeval(%#, pmatch(%0)))), if(cor(t(%qp), not(t(%1))), %qp, first(search(eplayer=strmatch(name(##), %0*))))))

&d.search-order [v(d.sfp)]=iter(sort(lattr(%!/d.search-order-*)), v(%i0))

&d.search-order-01 [v(d.sfp)]=attribute skill merit advantage

&d.search-order-09 [v(d.sfp)]=bio

&d.type.specials [v(d.sfp)]=special health

&filter.search-types [v(d.sfp)]=t(match(u(d.search-order), first(%0, .)))

&sortby.types [v(d.sfp)]=[setq(o, u(d.search-order))][sub(match(%qo, first(%0, .)), match(%qo, first(%1, .)))]

think Entry complete.
