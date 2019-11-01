/*
The entire point of this object is to collect all the layout functions I usually use. Here are the ones everyone probably knows:

	alert
	header
	footer
	divider
	wheader - alias of header
	wfooter - alias of footer
	wdivider - alias of divider
	subheader - alias of divider

Some of these are probably new to you:

	boxtext(text, delimiter, columns, viewer dbref) - take text, wrap it so it doesn't touch the edges of the viewer's screen. Optionally turn it into columns. No, not everyone wants to figure out vcolumns.

	fitcolumns(list, delimiter, viewer dbref) - display a list in as many columns as will fit on the screen, max 6.

	getlongest (probably belongs in a string-editing library)

This is not intended for player use though players can obviously call them. These are for things like "making the game pretty".

Future expansion potential:

	- Separate the colors from the characters in use so they're easier to set.

	- Add default functions like "vcolumns" and a few other things that every game uses and no one really has a spot for.

*/

@create Layout Functions <LF>=10
@set LF=SAFE INHERIT

@Startup LF=@dolist v(d.function_objects)=@trigger me/tr.makefunctions=##;

&TR.MAKEFUNCTIONS LF=@dolist lattr(%0/f.global.*)=@function rest(rest(##, .), .)=%0/##; @dolist lattr(%0/f.globalp.*)=@function/preserve rest(rest(##, .), .)=%0/##; @dolist lattr(%0/f.globalpp.*)=@function/preserve/privilege rest(rest(##, .), .)=%0/##;

@force me=&D.FUNCTION_OBJECTS LF=[strcat(xget(#1, d.function_objects), %b, num(LF))]

/*
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~@@
@@ All done? Great! Here are the bits you're most likely to want to customize.
@@ Feel free to make your edges with multiple characters; it does the math for
@@ you.
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~@@

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/*
@@ This header set produces something like the below:
.~( My sexy header! )~~~~~~~~~~~~~~------------------------------~~~~~~~~~~~~~~.
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer efficitur
 diam nisi, id lobortis metus pharetra et. Fusce eu ligula non ante hendrerit
 gravida. Quisque quis ligula leo. Fusce fermentum felis pulvinar metus dictum
 suscipit. Mauris nisl velit, ornare quis luctus a, sollicitudin a sem. Nunc
 finibus condimentum feugiat. Quisque interdum tellus metus. Aliquam erat
 volutpat. Quisque convallis velit viverra, tempus nisl ut, suscipit dolor.
 Quisque et eleifend enim. Suspendisse id posuere velit, ut bibendum tortor.
 Cras volutpat lectus non lacus aliquam efficitur. Aliquam laoreet in neque nec
 auctor.
(~~~~~~~--------------~~~~~~~( Floating divider. )~~~~~~~---------------~~~~~~~)
 Praesent enim nisl, maximus sed ante non, venenatis pulvinar est. Proin magna
 augue, vulputate vel varius in, finibus vitae justo. Vivamus non urna at
 lectus fermentum malesuada. Duis in sagittis neque, sed finibus nulla. Nam et
 ornare lorem. Nam mollis venenatis nulla, vel eleifend mauris ullamcorper a.
 Phasellus lacinia varius mauris, ac pulvinar tellus molestie in. Proin
 vestibulum fermentum lorem sed pharetra. Phasellus sodales diam id sapien
 faucibus, eget semper neque sagittis. Cras ac massa semper, faucibus arcu
 porta, sagittis diam. Donec feugiat ante leo, ut dictum quam ornare a. Morbi
 vulputate quam vel ipsum ornare rhoncus. Nulla tincidunt nisl justo, vel
 laoreet nunc tristique sit amet. Phasellus vestibulum elementum vestibulum.
 Integer mattis neque vel sapien faucibus, id ultrices neque lobortis. Etiam ut
 aliquet metus, eget facilisis sem.
.~~~~~~~~~~~~~~~--------------------------------~~~~~~~~~~~~~~~( And footer. )~.
.~( Hey! )~: Here's the alert text!
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
*/

&d.fade-width LF=15
&d.fade-edge LF=%cr~%cn
&d.fade-middle LF=%ch%cx-%cn
&d.before-text LF=%cw(%cn
&d.after-text LF=%cw)%cn
&d.header-left LF=%cw.%cn%cr~%cn
&d.header-right LF=%cw.%cn
&d.footer-left LF=%cw.%cn
&d.footer-right LF=%cr~%cn%ch%cw.%cn
&d.divider-left LF=%cw(%cn
&d.divider-right LF=%cw)%cn
&d.alert-left LF=%cw.%cn%cr~%cn
&d.alert-right LF=%cr~%cn%cw:%cn
&d.default-alert LF=%cwHey!%cn

/*
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/*
@@ The next header set produces something like the below:
/=[ My technological header! ]=================================================|
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer efficitur
 diam nisi, id lobortis metus pharetra et. Fusce eu ligula non ante hendrerit
 gravida. Quisque quis ligula leo. Fusce fermentum felis pulvinar metus dictum
 suscipit. Mauris nisl velit, ornare quis luctus a, sollicitudin a sem. Nunc
 finibus condimentum feugiat. Quisque interdum tellus metus. Aliquam erat
 volutpat. Quisque convallis velit viverra, tempus nisl ut, suscipit dolor.
 Quisque et eleifend enim. Suspendisse id posuere velit, ut bibendum tortor.
 Cras volutpat lectus non lacus aliquam efficitur. Aliquam laoreet in neque nec
 auctor.
+===============================[ Tech divider ]===============================+
 Praesent enim nisl, maximus sed ante non, venenatis pulvinar est. Proin magna
 augue, vulputate vel varius in, finibus vitae justo. Vivamus non urna at
 lectus fermentum malesuada. Duis in sagittis neque, sed finibus nulla. Nam et
 ornare lorem. Nam mollis venenatis nulla, vel eleifend mauris ullamcorper a.
 Phasellus lacinia varius mauris, ac pulvinar tellus molestie in. Proin
 vestibulum fermentum lorem sed pharetra. Phasellus sodales diam id sapien
 faucibus, eget semper neque sagittis. Cras ac massa semper, faucibus arcu
 porta, sagittis diam. Donec feugiat ante leo, ut dictum quam ornare a. Morbi
 vulputate quam vel ipsum ornare rhoncus. Nulla tincidunt nisl justo, vel
 laoreet nunc tristique sit amet. Phasellus vestibulum elementum vestibulum.
 Integer mattis neque vel sapien faucibus, id ultrices neque lobortis. Etiam ut
 aliquet metus, eget facilisis sem.
\==============================================================[ And footer. ]=|
/==[ ALERT ]=| Here's the alert text.
/==[ RED ALERT ]=| Highlighted red and produced with: @emit alert(RED ALERT, cr)
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
*/

&d.fade-edge lf=%ch%cb=%cn
&d.fade-middle lf=%ch%cx=%cn
&d.before-text lf=%ch%cw[%cn
&d.after-text lf=%ch%cw]%cn
&d.header-left lf=%ch%cw/%cn%ch%cb=%cn
&d.header-right lf=%ch%cw|%cn
&d.footer-left lf=%ch%cw\\%cn
&d.footer-right lf=%ch%cb=%cn%ch%cw|%cn
&d.divider-left lf=%ch%cw+%cn
&d.divider-right lf=%ch%cw+%cn
&d.default-alert lf=%chALERT%cn
&d.alert-left LF=%ch%cw/%cn%ch%cb=%cn
&d.alert-right LF=%ch%cb=%cn%ch%cw|%cn
&d.fade-width lf=10

/*
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/*
@@ The next header is pure experimental:
.~..oO( Experimental )Oo......................................................~.
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer efficitur
 diam nisi, id lobortis metus pharetra et. Fusce eu ligula non ante hendrerit
 gravida. Quisque quis ligula leo. Fusce fermentum felis pulvinar metus dictum
 suscipit. Mauris nisl velit, ornare quis luctus a, sollicitudin a sem. Nunc
 finibus condimentum feugiat. Quisque interdum tellus metus. Aliquam erat
 volutpat. Quisque convallis velit viverra, tempus nisl ut, suscipit dolor.
 Quisque et eleifend enim. Suspendisse id posuere velit, ut bibendum tortor.
 Cras volutpat lectus non lacus aliquam efficitur. Aliquam laoreet in neque nec
 auctor.
<~~...........................oO( Experiment! )Oo............................~~>
 Praesent enim nisl, maximus sed ante non, venenatis pulvinar est. Proin magna
 augue, vulputate vel varius in, finibus vitae justo. Vivamus non urna at
 lectus fermentum malesuada. Duis in sagittis neque, sed finibus nulla. Nam et
 ornare lorem. Nam mollis venenatis nulla, vel eleifend mauris ullamcorper a.
 Phasellus lacinia varius mauris, ac pulvinar tellus molestie in. Proin
 vestibulum fermentum lorem sed pharetra. Phasellus sodales diam id sapien
 faucibus, eget semper neque sagittis. Cras ac massa semper, faucibus arcu
 porta, sagittis diam. Donec feugiat ante leo, ut dictum quam ornare a. Morbi
 vulputate quam vel ipsum ornare rhoncus. Nulla tincidunt nisl justo, vel
 laoreet nunc tristique sit amet. Phasellus vestibulum elementum vestibulum.
 Integer mattis neque vel sapien faucibus, id ultrices neque lobortis. Etiam ut
 aliquet metus, eget facilisis sem.
^~~..........................................................oO( Weird )Oo.~~^
.~...oO( Attention )Oo...~: Test!
@@ Have fun with them! They really set the character of the game.
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
*/

&d.fade-width LF=15
&d.fade-edge LF=%cg.%cn
&d.fade-middle LF=%ch%cg.%cn
&d.before-text LF=%cg.%cco%cmO%cw(%cn
&d.after-text LF=%cw)%cmO%cco%cg.%cn
&d.header-left LF=%cw.%cn%cg~%cn%cw.%cn
&d.header-right LF=%cw.%cn%cg~%cn%cw.%cn
&d.footer-left LF=%cw^%cn%cm~%cn%cc~%cn
&d.footer-right LF=%cc~%cn%cm~%cn%cw^%cn
&d.divider-left LF=%cw<%cn%cm~%cn%cc~%cn
&d.divider-right LF=%cc~%cn%cm~%cn%cw>%cn
&d.alert-left LF=%cw.%cn%cg~%cn%cw.%cn
&d.alert-right LF=%cc~%cn%cm~%cn%cw:%cn
&d.default-alert LF=%cwAttention%cn

/*

How to test:

th header(Experimental)
th divider(Experiment!)
th footer(Weird, huh?)
th alert() Test!

*/

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~@@
@@ Global functions
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~@@

@@ %0 - text (optional)
@@ %1 - person it's being shown to (optional)
&f.globalpp.header LF=strcat(setq(0, if(t(%0), strlen(setr(4, strcat(u(d.before-text), %b, %0, %b, u(d.after-text)))), 0)), setq(1, sub(u(f.get-width, if(t(%1), %1, %#)), add(%q0, strlen(setr(5, u(d.header-left))), strlen(setr(6, u(d.header-right)))))), setq(2, min(div(%q1, 4), v(d.fade-width))), setq(3, sub(%q1, mul(%q2, 2))), %q5,  %q4, u(f.repeating-divider, %q2, %q3), %q6)

@@ %0 - text (optional)
@@ %1 - person it's being shown to (optional)
&f.globalpp.divider LF=strcat(setq(5, u(d.divider-left)), setq(6, u(d.divider-right)), setq(1, sub(u(f.get-width, if(t(%1), %1, %#)), add(strlen(%q5), strlen(%q6)))), if(t(%0), strcat(setq(0, strlen(setr(4, strcat(u(d.before-text), %b, %0, %b, u(d.after-text))))), setq(1, sub(%q1, %q0)), setq(2, min(div(%q1, 8), v(d.fade-width))), setq(3, fdiv(setr(7, sub(%q1, mul(%q2, 4))), 2)), %q5, u(f.repeating-divider, %q2, %q3),  %q4, u(f.repeating-divider, %q2, add(%q3, mod(%q7, 2))), %q6), strcat(%q5, u(f.repeating-divider, setr(2, min(div(%q1, 4), v(d.fade-width))), sub(%q1, mul(%q2, 2))), %q6)))

@@ %0 - text (optional)
@@ %1 - person it's being shown to (optional)
&f.globalpp.footer LF=strcat(setq(0, if(t(%0), strlen(setr(4, strcat(u(d.before-text), %b, %0, %b, u(d.after-text)))), 0)), setq(1, sub(u(f.get-width, if(t(%1), %1, %#)), add(%q0, strlen(setr(5, u(d.footer-left))), strlen(setr(6, u(d.footer-right)))))), setq(2, min(div(%q1, 4), v(d.fade-width))), setq(3, sub(%q1, mul(%q2, 2))), %q5, u(f.repeating-divider, %q2, %q3), %q4, %q6)

@@ %0 - text (optional)
@@ %1 - ansi to highlight text with (optional)
&f.globalpp.alert LF=strcat(u(d.alert-left), u(d.before-text), %b, if(t(%0), if(t(%1), ansi(%1, %0), %0), if(t(%1), ansi(%1, u(d.default-alert)), u(d.default-alert))), %b, u(d.after-text), u(d.alert-right))

@@ %0 - a list
@@ %1 - delimiter (optional)
@@ Output: the length of the longest item in a list.
&f.globalpp.getlongest LF=strcat(setq(0, 0), null(iter(%0, if(gt(setr(1, strlen(itext(0))), %q0), setq(0, %q1)), if(t(%1), %1, %b))), %q0)

@@ %0 - list of text
@@ %1 - delimiter (optional)
@@ %2 - user (optional)
@@ Output: the list separated into the number of columns that can fit on the screen, max 6.
&f.globalpp.fitcolumns LF=strcat(setq(0, if(t(%1), %1, %b)), setq(1, ulocal(f.get-max-columns, %2, getlongest(%0, %q0))), boxtext(case(1, gt(%q1, 1), %0, and(lte(%q1, 1), strmatch(%q0, %b)), %0, edit(%0, %q0, %R)), if(gt(%q1, 1), %q0), if(gt(%q1, 1), %q1), %2))

@@ Function: wrap text for display, optionally columnizing it.
@@ Arguments:
@@  %0 - the text to box
@@  %1 - the delimiter to split it by if a table is desired
@@  %2 - the number of columns to display in a table (default 3)
@@  %3 - the user this is getting shown to (optional)

&f.globalpp.boxtext LF=strcat(setq(0, ulocal(f.get-width, if(t(%3), %3, %#))), setq(1, sub(%q0, 2)), if(or(t(%1), t(%2)), strcat(setq(2, %q1), setq(3, if(t(%2), %2, 3)), setq(4, sub(%q3, 1)), wrap(table(%0, div(sub(%q2, %q4), %q3), %q2, %1), %q1, left, %b)), wrap(%0, %q1, left, %b)))

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~@@
@@ Aliases
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~@@

&f.globalpp.subheader LF=divider(%0, %1)

&f.globalpp.wheader LF=header(%0, %1)

&f.globalpp.wdivider LF=divider(%0, %1)

&f.globalpp.wfooter LF=footer(%0, %1)

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~@@
@@ Local functions
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~@@

@@ %0 - width of the left and right edges
@@ %1 - width of the middle
&f.repeating-divider LF=strcat(repeat(u(d.fade-edge), %0), repeat(u(d.fade-middle), %1), repeat(u(d.fade-edge), %0))

@@ %0 - %#
@@ %1 - minimum width
@@ Output: a number between 1 and 6.
&f.get-max-columns LF=strcat(setq(0, sub(ulocal(f.get-width, %0), 2)), setq(1, if(t(%1), %1, 10)), case(1, gt(%q1, ulocal(f.calc-width, %q0, 2)), 1, gt(%q1, ulocal(f.calc-width, %q0, 3)), 2, gt(%q1, ulocal(f.calc-width, %q0, 4)), 3, gt(%q1, ulocal(f.calc-width, %q0, 5)), 4, gt(%q1, ulocal(f.calc-width, %q0, 6)), 5, 6))

@@ %0 - the width of the screen
@@ %1 - the number of columns
&f.calc-width LF=sub(ceil(fdiv(%0, %1)), sub(%1, 1))

&f.get-width LF=max(min(width(if(t(%0), %0, %#)), 80), 50)

