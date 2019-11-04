@@ Requires:
@@ - alert()
@@ - isstaff()

/*
Commands:

	+prove <stat|sheet> - prove your stat or sheet to the room

	+prove <item>=<target> - prove to a specific person

*/

@create Prove Functions <PrF>=10
@set PrF=SAFE INHERIT

@create Prove Commands <PrC>=10
@set PrC=SAFE INHERIT
@parent PrC=PrF

@desc PrC=

@force me=&vS PrC=[search(name=Sheet: Rows)]

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Layouts
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %0 - error message
&layout.error PrF=alert(+Prove error) %0

@@ %0 - message
&layout.msg PrF=alert(+Prove) %0

@@ %0 - dbref of the person doing the proving
@@ %1 - name of the stat they're proving
@@ %2 - value of the stat they're proving
@@ %3 - target they're proving to - if nothing, 'the room'.
&layout.stat PrF=ulocal(layout.msg, strcat(moniker(%0), %b, proves, %b, poss(%0), %b, %1, %b, to, %b, if(t(%3), ulocal(layout.list-of-players, %3), the room), :, %b, %2))

@@ %0 - dbref of the person doing the proving
@@ %1 - target they're proving to - if nothing, 'the room'.
&layout.sheet PrF=ulocal(layout.msg, strcat(moniker(%0), %b, proves, %b, poss(%0), %b, sheet to, %b, if(t(%1), ulocal(layout.list-of-players, %1), the room), :, %r, ulocal(%vS/display.sheet, %0, %0, xget(%0, _bio.template))))

@@ %0 - list of dbrefs
&layout.list-of-players PrF=itemize(iter(%0, moniker(itext(0)),, |), |)

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Local functions
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %0 - string list of players
@@ Output: DBref list of valid players found - errors are eaten
&f.validate-players PrF=trim(squish(iter(%0, if(t(pmatch(itext(0))), pmatch(itext(0))))))

@@ %0 - player proving stat
@@ %1 - stat to prove
&f.validate-stat PrF=getstat(%0/%1, t)

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Command manager (not like there's a lot to do here...)
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&cmd-+prove PrC=$+prove*:@switch setr(E, strcat(switch(%0, *=*, strcat(setq(S, first(%0, =)), setq(T, rest(%0, =))), setq(S, %0)), setq(S, trim(squish(%qS))), if(t(%qT), strcat(setq(T, ulocal(f.validate-players, %qT)), if(not(t(%qT)), Could not find the player or players you entered: [rest(%0, =)]))), case(%qS, sheet,,, What stat do you want to +prove?, if(not(t(setr(V, ulocal(f.validate-stat, %#, setr(N, statname(%#/%qS)))))), You don't have a '%qS' stat that +prove could find., setq(S, %qN)))))=, { @trigger me/tr.prove=%#, %qT, %qS, %qV; }, { @pemit %#=ulocal(layout.error, %qE); }

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Triggers
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ Input:
@@ %0 - %#
@@ %1 - targets to show
@@ %2 - stat to show
@@ %3 - value of stat
&tr.prove PrC=@switch/first %1%2=sheet, { @remit loc(%0)=ulocal(layout.sheet, %0, %1); }, *sheet, { @pemit setunion(%1, %0)=ulocal(layout.sheet, %0, %1); }, { @switch %1=, { @remit loc(%0)=ulocal(layout.stat, %0, %2, %3, %1); }, { @pemit setunion(%1, %0)=ulocal(layout.stat, %0, %2, %3, %1); }; };

@tel PrF=PrC

