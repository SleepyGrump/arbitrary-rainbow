/*

Note: this was written when I primarily coded on RHost. It works on both TinyMUX and Rhost, and has been tested extensively.

Goal: Roll some dice. ANY dice.


 Usage: +dice[/flags] <N>d<S>[+<M>|-<M>] [+|-] [<N>d<S>...]
            N: Number of dice to roll.
            S: Sides on the die you're rolling.
            M: Number to modify the total result of that roll by.

   Spaces around inter-roll operations ( + or - ) are required. Inter-roll operations are not required; you can roll multiple dice with a single +dice command, i.e. +dice 1d20+5 2d6+12. You can even mix operations in with regular rolls. For example, +dice 1d20+5 2d6+12 + 3d6 1d4-1 would roll 1d20+5, then 2d6+12 and 3d6, and add those two together, then 1d4-1, displaying each result separately.

 Type +dhelp flags for more.


 Flags:
  /q: Roll quietly to yourself. No one else will see it.
  /p<X>: Page X the roll you're making. Defaults to yourself.
         Names should have no spaces and must be separated by commas.
  /min<X>: Result returned will be a minimum of X.
  /max<X>: Result returned will be a maximum of X.
  /t<X>: Numbers equal to or above X will be tallied and noted separately.
  /b<X>: Numbers equal to or below X will be tallied and noted separately.
  /rr<X>: Numbers equal to or above X will be rerolled open-endedly.
  /rb<X>: Numbers equal to or below X will be rerolled open-endedly.
  /lr<X>: Limit open-ended rerolling to a maximum of X times.
  /sub<X>: Numbers equal to or below X subtract from total tally.
  /asub<X>: Numbers equal to or above X subtract from total tally.
  /skip<X>: Skip the lowest X dice. Will be dropped from every roll.
  /d<X>: Lone numbers in the roll are assumed to be dice with X sides.

  Note: <X> may be omitted. It is assumed to be 1 unless otherwise noted.

   Flags are most useful for the dice bag feature, which lets you easily save and reroll a roll via shortcuts. Dice bag rolls include the flags you save them with, so they can make basic rolling for any game system simple.


 Examples:
  +dice 1d20+5 2d6+1 - Roll a D&D character's attack and damage.
  +dice/min1 1d20+4 2d6+4 + 4d6 1d4+1
  +dice/t4 6d6 + 4d6 - Roll Shadowrun skill + bonus dice, target number 4.
  +dice/sub1/rr10/t6 10d10 - Old WoD roll, difficulty 6.
  +dice/t8/rr9 8d10 - New WoD roll, rerolling 9s.

*/

@create Non-Standard Dice Roller <NSDR>=10
@desc NSDR=%R Usage: +dice\[/flags\] <N>d<S>\[+<M>|-<M>\] \[+|-\] \[<N>d<S>...\]%R %b %b %b %b %b %bN: Number of dice to roll.%R %b %b %b %b %b %bS: Sides on the die you're rolling.%R %b %b %b %b %b %bM: Number to modify the total result of that roll by.%R%R %b Spaces around inter-roll operations ( + or - ) are required. Inter-roll operations are not required; you can roll multiple dice with a single +dice command, i.e. +dice 1d20+5 2d6+12. You can even mix operations in with regular rolls. For example, +dice 1d20+5 2d6+12 + 3d6 1d4-1 would roll 1d20+5, then 2d6+12 and 3d6, and add those two together, then 1d4-1, displaying each result separately.%R%R Type +dhelp flags for more.%R


&cmd-+dhelp_flags NSDR=$+dhelp f*:@pemit %#=%R Flags:%R %b/q: Roll quietly to yourself. No one else will see it.%R %b/p<X>: Page X the roll you're making. Defaults to yourself.%R %b %b %b %b Names should have no spaces and must be separated by commas.%R %b/min<X>: Result returned will be a minimum of X.%R %b/max<X>: Result returned will be a maximum of X.%R %b/t<X>: Numbers equal to or above X will be tallied and noted separately.%R %b/b<X>: Numbers equal to or below X will be tallied and noted separately.%R %b/rr<X>: Numbers equal to or above X will be rerolled open-endedly.%R %b/rb<X>: Numbers equal to or below X will be rerolled open-endedly.%R %b/lr<X>: Limit open-ended rerolling to a maximum of X times.%R %b/sub<X>: Numbers equal to or below X subtract from total tally.%R %b/asub<X>: Numbers equal to or above X subtract from total tally.%R %b/skip<X>: Skip the lowest X dice. Will be dropped from every roll.%R %b/d<X>: Lone numbers in the roll are assumed to be dice with X sides.%R%R %bNote: <X> may be omitted. It is assumed to be 1 unless otherwise noted.%R%R %b Flags are most useful for the dice bag feature, which lets you easily save and reroll a roll via shortcuts. Dice bag rolls include the flags you save them with, so they can make basic rolling for any game system simple.%R


&prefix-public NSDR=[name(%0)]'s +dice:

&prefix-private NSDR=+dice:

@force me=@vv NSDR=[strmatch(version(), *Rhost*)]

&fn-rolldice NSDR=if(or(and(not(t(%4)), not(t(%3))), lte(%4, %3)), iter(lnum(%0), setq(0, add(rand(%1),1))[null(iter(%2, [if(strmatch(itext(0), *t*), if(gte(%q0, ulocal(fn-getsetting, %2, /t)), setq(0, ansi(hg, %q0))[setq(1, add(%q1, 1))]))][if(strmatch(itext(0), *b*), if(lte(%q0, ulocal(fn-getsetting, %2, /b)), setq(0, ansi(hg, %q0))[setq(1, add(%q1, 1))]))][if(strmatch(itext(0), *lr*), setq(2, max(ulocal(fn-getsetting, %2, /lr), 0)))][if(strmatch(itext(0), *rr*), if(gte(%q0, ulocal(fn-getsetting, %2, /rr)), setq(0, %q0 [ulocal(fn-rolldice, 1, %1, %2, %q2, %4)])))][if(strmatch(itext(0), *rb*), if(lte(%q0, ulocal(fn-getsetting, %2, /rb)), setq(0, %q0 [ulocal(fn-rolldice, 1, %1, %2, %q2, %4)])))][if(strmatch(itext(0), *sub*), if(lte(%q0, ulocal(fn-getsetting, %2, /sub)), setq(0, ansi(hr, %q0))[setq(1, sub(%q1, 1))]))][if(strmatch(itext(0), *asub*), if(gte(%q0, ulocal(fn-getsetting, %2, /asub)), setq(0, ansi(hr, %q0))[setq(1, sub(%q1, 1))]))], /))] %q0)[if(t(%q1), : %q1)])

&fn-getsetting NSDR=setq(0, first(after(%0, %1), /))[if(t(%q0), %q0, switch(%0, *%1*, 1, 0))]

&fn-droplowestX NSDR=setq(0, %0)[null(iter(extract(sort(trim(squish(%q0)), n), 1, %1), setq(0, ldelete(trim(squish(%q0)), match(%q0, itext(0))))))]%q0

&fn-setdicevars NSDR=switch(%0, *d*+*, setq(N, first(%0, d))[setq(S, first(rest(%0, d), +))][setq(A, rest(%0, +))], *d*-*, setq(N, first(%0, d))[setq(S, first(rest(%0, d), -))][setq(A, -[rest(%0, -)])], *+*d*, setq(N, first(rest(%0, +), d))[setq(S, rest(%0, d))][setq(A, first(%0, +))], *-*d*, setq(N, first(rest(%0, -), d))[setq(S, rest(%0, d))][setq(A, first(%0, -))], *d*, setq(N, first(%0, d))[setq(S, rest(%0, d))][setq(A, 0)], if(t(ulocal(fn-getsetting, %1, /d)), setq(N, %0)[setq(S, ulocal(fn-getsetting, %1, /d))][setq(A, 0)], setq(N, 1)[setq(S, 1)][setq(A, %0)]))

&fn-evaldice NSDR=setq(1, ladd(setr(0,ulocal(fn-rolldice, %0, %1, %3)) 0 0 %2))[null(iter(%3, [if(strmatch(itext(0), *min*), if(lte(%q1, ulocal(fn-getsetting, %3, /min)), setq(1, ulocal(fn-getsetting, %3, /min))))][if(strmatch(itext(0), *max*), if(gte(%q1, ulocal(fn-getsetting, %3, /max)), setq(1, ulocal(fn-getsetting, %3, /max))))][if(strmatch(itext(0), *skip*), setq(1, ladd(stripansi(ulocal(fn-droplowestX, first(%q0, :), ulocal(fn-getsetting, %3, /skip))) 0 0 %2)))], /))]<%q1%cn>[if(or(and(isnum(%2), neq(%2, 0)), gt(%0, 1), strmatch(%q0, *:*)), %b([trim(squish(%q0))]))]

&cmd-+dice NSDR=$+dice* *:@eval setq(E, iter(%1, setq(T, switch(itext(0), +,, -,,+*, setq(Y, 1),-*, setq(Y, 1), u(fn-setdicevars, itext(0), %0))[if(not(t(%qY)),if(or(not(t(%qN)), not(isnum(%qN)), gt(%qN, 99), lte(%qN, 0)), You need to enter a valid number of dice to roll.%b)[if(or(not(t(%qS)), not(isnum(%qS)), gt(%qS, 10000), lte(%qS, 0)),You need to enter a valid number of sides on the dice you're rolling.%b)][if(not(isnum(%qA)), You need to enter a valid number to add or subtract from your roll.%b)])])[if(strmatch(%qM, %qT),, setr(M, %qT))], , if(%vv, @@(), @@))[if(t(%qY), You must include spaces between operations.%b)][iter(%0,switch(itext(0), p*, setq(T, ulocal(fn-getsetting, %0, /p)), q*, setq(T, %#), min*,, max*,, t*,, b*,, rr*,, rb*,, lr*,, sub*,, asub*,, skip*,, d*,,,, itext(0) is not a valid flag.%b), /, if(%vv, @@(), @@))][if(not(t(%qT)), setq(T, lcon(loc(%#))))][if(strmatch(%qT, *%,*), iter(%qT, setq(O, pmatch(itext(0)))[if(not(t(%qO)), Could not find player '[itext(0)]'.%b,setq(P, %qP %qO))], %,, if(%vv, @@(), @@))[setq(T, %qP)])][setq(T, setdiff(setunion(%qT, %#), 1))][setq(P, if(t(setr(P, setdiff(%qP, %#))), Paged to [setq(P, iter(%qP, name(itext(0)),, |))][if(%vv, elist(%qP,, |), itemize(%qP, |))]:%b))][null(iter(%1, setq(X, extract(%1, add(inum(0), 1), 1))[switch(itext(0), +, setq(F, %qF +)[setq(R, %qR +)], -, setq(F, %qF -)[setq(R, %qR -)], u(fn-setdicevars, itext(0), %0)[setq(C, ulocal(fn-evaldice, %qN, %qS, %qA, %0))][setq(L, %qL [first(rest(%qC, <), >)])][setq(R, %qR %qNd%qS[if(and(t(%qA), isnum(%qA), neq(%qA, 0)), switch(%qA, -*, %qA, +%qA))]: %qC)][if(and(case(%qX, +, 0, -, 0, 1), case(itext(0), +, 0, -, 0, 1)), setq(R, %qR.[if(t(%qF), %bTotal: <[setq(F, + %qF)][ladd(iter(edit(stripansi(%qL), -%b, -), case(extract(%qF, inum(0), 1), -, -[itext(0)], itext(0))) 0 0)]>.)][setq(F,)][setq(L,)]))])]))]); @switch %qE=,{@pemit/list %qT=%qP[u(prefix-[if(gt(words(%qT), 1), public, private)], %#)][iter(%0, [if(strmatch(itext(0), *min*), %bMin: [ulocal(fn-getsetting, %0, /min)].)][if(strmatch(itext(0), *max*), %bMax: [ulocal(fn-getsetting, %0, /max)].)][if(strmatch(itext(0), *t*), %bTarget #: [ulocal(fn-getsetting, %0, /t)].)][if(strmatch(itext(0), *b*), %bTarget # (below): [ulocal(fn-getsetting, %0, /b)].)][if(strmatch(itext(0), *rr*), %bReroll: [ulocal(fn-getsetting, %0, /rr)].)][if(strmatch(itext(0), *rb*), %bReroll (below): [ulocal(fn-getsetting, %0, /rb)].)][if(strmatch(itext(0), *lr*), %bLimit rerolls: [ulocal(fn-getsetting, %0, /lr)].)][if(strmatch(itext(0), *sub*), %bSubtract [ulocal(fn-getsetting, %0, /sub)] and lower from successes.)][if(strmatch(itext(0), *asub*), %bSubtract [ulocal(fn-getsetting, %0, /asub)] and higher from successes.)][if(strmatch(itext(0), *skip*), %bSkip lowest [ulocal(fn-getsetting, %0, /skip)].)], /, if(%vv, @@(), @@))]%qR;},{@pemit %#=[u(prefix-private)] Error > %qE;};



&credit NSDR=Melpomene@NOLA


@@ &fn-multiedit NSDR=setq(0, %0)[null(iter(%1,setq(0, edit(%q0, first(itext(0), ~), rest(itext(0), ~))),|))]%q0

@@ &cmd-+dice NSDR=$+dice* *:@eval setq(E,iter(%1, setq(T, switch(itext(0), +,, -,,+*, setq(Y, 1),-*, setq(Y, 1), u(fn-setdicevars, itext(0), %0))[if(not(t(%qY)),if(or(not(t(%qN)), not(isnum(%qN)), gt(%qN, 99), lte(%qN, 0)), You need to enter a valid number of dice to roll.%b)[if(or(not(t(%qS)), not(isnum(%qS)), gt(%qS, 10000), lte(%qS, 0)),You need to enter a valid number of sides on the dice you're rolling.%b)][if(not(isnum(%qA)), You need to enter a valid number to add or subtract from your roll.%b)])])[if(strmatch(%qM,%qT),,setr(M, %qT))], ,if(strmatch(version(),*Rhost*),@@(),@@))[if(t(%qY), You must include spaces between operations.%b)][switchall(%0, */min*, if(not(isnum(rest(%0, n))), You must set a minimum number when using /min<#>.%b), */max*, if(not(isnum(rest(%0, x))), You must set a maximum number when using /max<#>.%b),,, You must choose a valid switch.%b)]); @switch %qE=,{@remit %l=%N's +dice: [setq(F,+)][null(iter(%1, if(and(t(%qP), not(case(%qP, +, 1, -, 1, 0)), not(case(itext(0), +, 1, -, 1, 0)), t(%qL), not(strmatch(%qF, +))),setq(R, %qR = <[ladd(iter(u(fn-multiedit, stripansi(%qL),>~|<~|-%b~-), case(extract(%qF, inum(0), 1), -, -[itext(0)], itext(0))) 0 0)]>.[setq(C,)][setq(F,+)][setq(L,)]),if(and(t(%qP), not(case(%qP, +, 1, -, 1, 0)), not(case(itext(0), +, 1, -, 1, 0))),setq(R, %qR.[setq(C,)][setq(F,+)][setq(L,)])))[switch(itext(0), *d*+*, setq(C, u(fn-evaldice, first(itext(0), d), first(rest(itext(0), d), +), rest(itext(0), +), %0))[setq(L, %qL [first(rest(%qC, :))])], *d*-*, setq(C, u(fn-evaldice, first(itext(0), d), first(rest(itext(0), d), -), -[rest(itext(0), -)], %0))[setq(L, %qL [first(rest(%qC, :))])], *+*d*, setq(C, u(fn-evaldice, first(rest(itext(0), +), d), rest(itext(0), d), first(itext(0), +), %0))[setq(L, %qL [first(rest(%qC, :))])], *-*d*, setq(C, u(fn-evaldice, first(rest(itext(0), -), d), rest(itext(0), d), first(itext(0), -), %0))[setq(L, %qL [first(rest(%qC, :))])], *d*, setq(C, u(fn-evaldice, first(itext(0), d), rest(itext(0), d), 0, %0))[setq(L, %qL [first(rest(%qC, :))])], +, setq(F, %qF +)[setq(C, +)], -, setq(F, %qF -)[setq(C, -)], setq(C, itext(0))[setq(L, %qL [itext(0)])])][setq(P, %qC)][setq(R, %qR %qC)], ,if(strmatch(version(),*Rhost*),@@(),@@)))]%qR[if(and(t(%qL), not(strmatch(%qF, +))),%b= <[ladd(iter(u(fn-multiedit, stripansi(%qL),<~|>~|-%b~-), case(extract(%qF, inum(0), 1), -, -[itext(0)], itext(0))) 0 0)]>.,.)][switchall(%0, */min*, %bMinimum: [ulocal(fn-getsetting, %0, /min)]., */max*, %bMaximum: [ulocal(fn-getsetting, %0, /max)]., */t*, %bTarget #: [ulocal(fn-getsetting, %0, /t)]., )];},{@pemit %#=Error: %qE;};


@@ The rest of this is not finished! And probably never will be. Oh well.

/*


&cmd-+dbag NSDR=$+dbag:

&cmd-+d NSDR=$+d *:

&cmd-+dbag/save NSDR=$+dbag/save *:

&cmd-+dbag/toss NSDR=$+dbag/toss *:


*/