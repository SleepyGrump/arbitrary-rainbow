/*
Commands:

	+fate - roll your fate!
	+fate <#> - roll your fate plus a modifier!
	+fate/quiet - roll your fate quietly.

	+fate/ladder - check out the fate ladder



*/

@create Fate Dice <FD>=10
@parent FD=CODP
@set FD=safe
@desc FD=%R%T+fate - roll your fate!%R%T+fate <#> - roll your fate plus a modifier!%R%T+fate/quiet - roll your fate quietly.%R%R%T+fate/ladder - check out the fate ladder

@@ Note: this part is only necessary if you're also planning to use the Persona Picker and want to keep the feature where it shows you the "ladder word" for a fate value. Comment it in if you're interested.

@@ @force me=@Startup FD=@function getladderword=[num(FD)]/fn-get_word;

@@ The words on the ladder (with their colors)
&d.word_ladder FD=%crHopeless%cn %cr%chAwful%cn %cyMediocre%cn %cySemi-%chCompetent%cn %ch%cyCompetent%cn %cg%chGood%cn %cg%chGreat%cn %ccSuperb%cn %ccOutstanding%cn %cmLegendary%cn %cmDivine%cn

@@ The lowest the ladder appears to go
&d.ladder_start FD=-2

@@ The highest the ladder appears to go
&d.ladder_end FD=8

@@ Do not change below this point.

@@ Output: A single Fate roll
&fn-get_fate_roll FD=iter(lnum(1,5), pickrand(+1 0 -1))

@@ Input: A player dbref
@@ Output: The player's IC name, pronouns, and such
&fn-get_character_name FD=name(%0)


@@ Input: Iterative integer
@@ Output: Fate ladder number, formatted
&fn-get_numeric FD=u(fn-format_numeric, add(%0, v(d.ladder_start)))

@@ Input: Fate ladder number, unformatted
@@ Output: Fate ladder number, formatted
&fn-format_numeric FD=case(1, gt(%0, 0), +%0, eq(%0, 0), 0, %0)

@@ Input: a word.
@@ Output: A or AN depending on whether that word is
&fn-aoran FD=if(switch(stripansi(%0), A*, 1, E*, 1, I*, 1, O*, 1, U*, 1, 0), an, a)

@@ Input: real roll total
@@ Output: word and value
&fn-get_word FD=strcat(setq(I, 0), setq(R, 0), setq(M, v(d.ladder_start)), setq(H, v(d.ladder_end)), setq(W, u(d.word_ladder)), case(1, gte(%0, %qH), strcat(setq(I, words(%qW)), setq(R, sub(%0, %qH))), lte(%0, %qM), strcat(setq(I, 1), setq(R, sub(%qM, %0))), lte(%0, 0), setq(I, add(abs(%qM), %0, 1)), setq(I, add(%0, abs(%qM)))), extract(%qW, %qI, 1), repeat(ansi(case(%qI, 1, r, m), !), %qR), %b, %(, u(fn-format_numeric, %0), %))

@@ Momma command manager
&cmd-+fate FD=$+fate*:@switch %0=/l*, {@trigger me/tr-display-ladder=%#;}, /q*, {@trigger me/tr-test-roll=%#, rest(%0), quiet;}, {@trigger me/tr-test-roll=%#, %0, loud;}

@@ Roll some dice!

@@ Input:
@@ %0 - %#
@@ %1 - Command input
@@ %2 - loud or quiet
&tr-test-roll FD=think strcat(setq(N, trim(%1)), if(switch(%qN, *+*, 1, *-*, 1, 0), setq(N, ladd(setr(M, edit(%qN, +, %b+, -, %b-))))), if(t(%1), if(not(isnum(%qN)), setr(E, '%qN' is not a number.)))); @switch %qE=, { @trigger/quiet me/tr-roll=%0, %qN, %2, %qM; }, { @pemit %0=alert(+fate) %qE; };
+fate a
+fate +3
+Fate 1+2

@@ Input:
@@ %0 - %#
@@ %1 - Roll bonus
@@ %2 - loud or quiet
@@ %3 - Actual roll bonus text
&tr-roll FD=think The roll: [setr(R, u(fn-get_fate_roll))]%RThe modifier: %1%RThe total: [setr(F, ladd(%qR %1))]%RThat's [setr(D, u(fn-get_word, %qF))]!; @switch %2=quiet, { @trigger/quiet me/tr-quiet-roll=%0, %qD, %qF, %1, %3; }, { @trigger/quiet me/tr-display-roll=%0, %qD, %qF, %1, %3; }

@@ Input:
@@ %0 - %#
@@ %1 - Roll result
@@ %2 - Roll total with bonus
@@ %3 - Roll bonus
@@ %4 - Actual roll bonus text
&tr-display-roll FD=@remit loc(%0)=alert(+fate) [u(fn-get_character_name, %0)] challenged fate[case(t(%3), 1, %bwith [u(fn-get_character_poss, %0)] [u(fn-get_word, %3)] bonus[if(not(match(%3, %4)), %b%(%4%))])] and got [if(switch(stripansi(%1), A*, 1, E*, 1, I*, 1, O*, 1, U*, 1, 0), an, a)] %1 result.;

@@ Input:
@@ %0 - %#
@@ %1 - Roll result
@@ %2 - Roll total with bonus
@@ %3 - Roll bonus
@@ %4 - Actual roll bonus text
&tr-quiet-roll FD=@pemit %0=alert(+fate) You quietly challenged fate[case(t(%3), 1, %bwith your [u(fn-get_word, %3)] bonus[if(not(strmatch(%3, *%(%4%))), %b%(%4%))])] and got [if(switch(stripansi(%1), A*, 1, E*, 1, I*, 1, O*, 1, U*, 1, 0), an, a)] %1 result.;

&layout.roll FD=challenged fate[case(t(%3), 1, %bwith your [u(fn-get_word, %3)] bonus[if(not(strmatch(%3, *%(%4%))), %b%(%4%))])] and got [if(switch(stripansi(%1), A*, 1, E*, 1, I*, 1, O*, 1, U*, 1, 0), an, a)] %1 result.;

@@ Show us the ladder.

&tr-display-ladder FD=@pemit %0=[wheader(Fate Ladder)]%R[iter(u(d.word_ladder), %T[rjust(u(fn-get_numeric, sub(inum(0), 1)), 3)]%T[itext(0)],, %R)]%R[wfooter()]

@@ Tests.

+fate/l
+fate/q 2
+fate 5

