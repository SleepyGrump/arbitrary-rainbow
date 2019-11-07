/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/3%20-%20Stat%20Setter/3a%20-%20Stat%20Setup.txt

Compiled 2019-11-07

*/

think Entering 10 lines.

@create Stat Setter <ss>

@fo me=&d.ss me=search(name=Stat Setter <ss>)

@set Stat Setter <ss>=inherit safe

@fo me=@parent Stat Setter <ss>=[v(d.codp)]

@fo me=&d.stat-funcs [v(d.ss)]=search(name=Stat Functions Prototype <sfp>)

@fo me=&d.data-dictionary [v(d.ss)]=search(name=Data Dictionary <dd>)

@fo me=&d.data-tags [v(d.ss)]=search(name=Data Tags <d:t>)

&f.find-sheet [v(d.ss)]=u(u(d.stat-funcs)/f.find-sheet, %0)

&.msg [v(d.ss)]=ansi(h, <%0>, n, %b%1)

&.pmatch [v(d.ss)]=localize(strcat(setq(p, if(strmatch(%0, me), %#, objeval(%#, pmatch(%0)))), if(cor(t(%qp), not(t(%1))), %qp, first(search(eplayer=strmatch(name(##), %0*))))))

think Entry complete.
