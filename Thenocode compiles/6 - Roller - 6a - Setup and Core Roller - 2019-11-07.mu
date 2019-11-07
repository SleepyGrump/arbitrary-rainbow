/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/6%20-%20Roller/6a%20-%20Setup%20and%20Core%20Roller.txt

Compiled 2019-11-07

*/

think Entering 24 lines.

@create nWoD Roller <nr>

@fo me=&d.nr me=[num(nWoD Roller <nr>)]

@set nWoD Roller <nr>=safe inherit

@fo me=@parent nWoD Roller <nr>=[v(d.codp)]

@fo me=&d.stat-setter [v(d.nr)]=search(name=Stat Functions Prototype <sfp>)

@fo me=&d.data-dictionary [v(d.nr)]=search(name=Data Dictionary <dd>)

@fo me=&d.spend-regain [v(d.nr)]=search(name=Pool Spend Regain System <psrs>)

@fo me=&d.jobs [v(d.nr)]=search(name=Job Global Object <JGO>)

@fo me=@va [v(d.nr)]=[get(get(v(d.nr)/d.jobs)/va)]

&.sign [v(d.nr)]=case(1, strmatch(%0, #-*), %0, strmatch(%0, -*), -, +)

&.value_full [v(d.nr)]=ulocal([u(d.data-dictionary)]/.value_full, %0, %1)

&.class [v(d.nr)]=ulocal([u(d.data-dictionary)]/.class, %0)

&.statpath [v(d.nr)]=ulocal([u(d.stat-setter)]/f.statpath.workhorse, %0, %1)

&.statname [v(d.nr)]=ulocal([u(d.stat-setter)]/f.statname.workhorse, %0)

&.hastag? [v(d.nr)]=ulocal([u(d.stat-setter)]/f.hastag?.workhorse, %0, %1, strmatch(%2, a*))

&.alert [v(d.nr)]=ansi(h, <%0>)

&.msg [v(d.nr)]=ansi(h, <%0>, n, %b%1)

&.crumple [v(d.nr)]=trim(squish(%0, %1), b, %1)

&f.roller [v(d.nr)]=strcat(setr(0, lrand(1, 10, %0)), :, setr(1, lrand(1, 10, sub(words(%q0), u(f.n-again-check, %q0, %2)))), :, trim(u(f.roller.recursive, %q0 %q1, %1)))

&f.roller.recursive [v(d.nr)]=if(setr(2, u(f.n-again-check, %0, %1)), cat(setr(3, lrand(1, 10, %q2)), ulocal(f.roller.recursive, %q3, %1)))

&f.n-again-check [v(d.nr)]=words(regraball(%0, [lnum(%1, 11, |)]))

&f.successes.standard [v(d.nr)]=u(f.n-again-check, edit(%0, :, %b), %1)

&f.successes.chance [v(d.nr)]=if(eq(first(%0, :), 1), -1, u(f.successes.standard, %0, 10))

&f.successes.weakness [v(d.nr)]=max(0, sub(u(f.successes.standard, %0, %1), if(strlen(elements(%0, 2, :)), words(graball(edit(rest(%0, :), :, %b), 1)), words(graball(edit(%0, :, %b), 1)))))

think Entry complete.
