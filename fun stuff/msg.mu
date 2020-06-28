/*
********************************************************************************
Dependencies: alert(), interval()

Interval expects either a player name or a secs() string.
Here's interval() in case you don't have it, stick it on Layout Functions:

&f.globalp.interval LF=if(t(setr(0, extract(squish(trim(strcat(setq(I, sub(secs(), if(isnum(%0), %0, sub(secs(), idle(%0))))), setq(W, div(%qI, 604800)), if(gt(%qW, 0), setq(I, sub(%qI, mul(%qW, 604800)))), setq(D, div(%qI, 86400)), if(gt(%qD, 0), setq(I, sub(%qI, mul(%qD, 86400)))), setq(H, div(%qI, 3600)), if(gt(%qH, 0), setq(I, sub(%qI, mul(%qH, 3600)))), setq(M, div(%qI, 60)), if(gt(%qM, 0), setq(I, sub(%qI, mul(%qM, 60)))), setq(S, %qI), if(t(%qW), %qWw)|, if(t(%qD), %qDd)|, if(t(%qH), %qHh)|, if(t(%qM), %qMm)|, if(t(%qS), %qSs)), b, |), |), 1, 2, |, %b))), %q0, 0s)

********************************************************************************
Key features:
	- remembers who you last messaged so you don't have to type it again
	- remembers the last type of message you sent
	- queues messages for delivery while you're offline or messages are turned off
	- lets you colorize, highlight, etc, a standardized prefix
	- lets you block people IC (with a personalized IC message if you like)
	- lets you hide/gag people's messages IC - warning, they get eaten
	- shows you your message status on login

********************************************************************************
CHANGELOG:

2020-05-02: Changed the layout, fixed that one weird bug where fallthrough didn't work, and made it a little more nice, code-wise. Separated concerns a little so layout will make sense. Added simple substitution commands like +txt and so on.

********************************************************************************

Wiki help files:

==MSG==

Here are the base commands:

* msg <player>=<text> - send a message
* msg/<type> <player>=<text> - send a <type> kind of message (examples: text, HUD, comm, telepathy, etc)
* msg <text> - send message with the same settings as the last one

You can use any of the following in place of msg:

* +txt
* +text
* +phone
* +telepathy
* +tel

See also: [[Gamehelp:Message|Message]]

==Message==

Messaging is vital to roleplay, whether through text, phone, comm, or telepathy. We've done our best to keep it as simple, yet flexible, as possible.

* msg <player>=<text> - send a message
* msg/<type> <player>=<text> - send a <type> kind of message (examples: text, HUD, comm, telepathy, etc)
* msg <text> - send message with the same settings as the last one

After the first msg is sent, it remembers the last person (or group of people!) you messaged, and the last type of message you sent, so you can just type "msg <stuff>".

The message itself can be anything, but displays special behaviors when it starts with :, ;, or |. For examples of these, see below:

* :tests			<-- Gallifrey tests
* ;'s test		<-- Gallifrey's test
* |A test happens.	<-- A test happens.
* Testing!		<-- Gallifrey says, "Testing!"

See also: [[Gamehelp:Message Colors and Shortcuts|Message Colors and Shortcuts]], [[Gamehelp:Message Spam|Message Spam]], and [[Gamehelp:Managing Messages|Managing Messages]]

==Message Colors and Shortcuts==

Some people like to customize messages to stand out better. To customize your sent messages:

&msg-send-ra me=%cw%cR%[RED ALERT%]

Now whenever you type msg/ra name=message, they'll see a bright red RED ALERT message. The letters "ra" effectively become a shortcut for "red alert", and your friends see the message as urgently as you meant to show it.

==Message Spam==

Because messages can be spammy, we've implemented several different ways to stop them in-character.

msg/off - turn off messages for a while. The first 50 you receive will be stored and replayed when you return.

msg/on - re-enables messaging

msg/block <name> - block them and tell them they're blocked - they'll get a "you are blocked" style message. You can also use msg/block <name>=<reason> to set the block message to whatever you want.

msg/unblock <name> - let them message you again

msg/hide <name> - hide all messages from a person without telling them the messages aren't going through. Warning: those messages get lost forever and you'll have no way of seeing them.

msg/unhide <name> - unhide messages from the person


==Managing Messages==

msg/off - turn messages off for a while. People who try to message you will be notified that you're unreachable, and their messages will be queued for when you return, up to 50 max.

msg/on - return, and view your messages.

msg/view - view any queued messages. Queued messages are deleted after they're viewed.

msg/summary or just msg - view a summary of your message status.

*/

/*

Old code:

&F.SEND_MSG SGP - Main Globals=[pemit(setunion(%0, %#), <%1> [name(%#)] to [itemize(iter(%0, name(itext()),, |), |)]: %2)]
&F.HANDLE_MSG SGP - Main Globals=[setq(t, switch(%0, *=*, first(%0, =)[setq(m, rest(%0, =))], default(%#/_last_%1, %#)[setq(m, %0)]))][setq(t, trim(%qt)))][setq(m, trim(%qm))][setq(m, switch(%qm, :*, [name(%#)] [rest(%qm, :)], ;*, [name(%#)][rest(%qm, ;)], %qm))][case(0, t(setr(t, u(f.player.to-list, %qt))), pemit(%#, [alert(Error)] To list must be valid player names or aliases in a space-separated list.), u(f.send_msg, %qt, %1, %qm)[set(%#, _last_%1:%qt)])]
&C.+TEXT_MSG SGP - Main Globals=$+text *:[u(f.handle_msg, %0, text)]
&C.+PHONE_MSG SGP - Main Globals=$+phone *:[u(f.handle_msg, %0, phone)]
&C.+TELEPATHY_MSG SGP - Main Globals=$+telepathy *:[u(f.handle_msg, %0, telepathy)]
&C.+TELEPATHY2_MSG SGP - Main Globals=$+tele *:[u(f.handle_msg, %0, telepathy)]
&C.+TELEPATHY3_MSG SGP - Main Globals=$+tp *:[u(f.handle_msg, %0, telepathy)]
&C.+TXT_MSG SGP - Main Globals=$+txt *:[u(f.handle_msg, %0, text)]

*/

@create Message Commands <MSG>=10
@set MSG=inherit

@aconnect MSG=@trigger me/switch.msg.summary=%#,1;

&cmd-+txt MSG=$+txt*:@trigger me/switch.msg=/text%0, %#;

@set MSG/cmd-+txt=no_parse

&cmd-+text MSG=$+text*:@trigger me/switch.msg=/text%0, %#;

@set MSG/cmd-+text=no_parse

&cmd-+phone MSG=$+phone*:@trigger me/switch.msg=/phone%0, %#;

@set MSG/cmd-+phone=no_parse

&cmd-+tel MSG=$+tel*:@trigger me/switch.msg=/telepathy[switch(%0, epathy *, %b[rest(%0)], %0)], %#;

@set MSG/cmd-+tel=no_parse

&cmd-txt MSG=$txt*:@trigger me/switch.msg=/text%0, %#;

@set MSG/cmd-txt=no_parse

&cmd-text MSG=$text*:@trigger me/switch.msg=/text%0, %#;

@set MSG/cmd-text=no_parse

&cmd-phone MSG=$phone*:@trigger me/switch.msg=/phone%0, %#;

@set MSG/cmd-phone=no_parse

&cmd-tel MSG=$tel*:@trigger me/switch.msg=/telepathy[switch(%0, epathy *, %b[rest(%0)], %0)], %#;

@set MSG/cmd-tel=no_parse

&cmd-msg MSG=$msg*:@switch/first 1=and(strmatch(%0, /*), t(setr(S, first(lattr(me/switch.msg.[first(rest(%0, /), if(strmatch(first(%0), /*/*), /))]*))))), { @trigger me/%qS=first(%0), rest(%0), %#; }, { @trigger me/switch.msg=%0, %#; }

@set MSG/cmd-msg=no_parse

&switch.msg.summary MSG=@pemit setr(P, if(isdbref(%0), %0, %2))=strcat(if(t(%1), %r), alert(MSG) Message delivery, %b, if(t(xget(%qP, msg-receive-off)), disabled, enabled), .%b, if(t(setr(L, xget(%qP, last-msg-target))), strcat(You last messaged, %b, ansi(h, name(%qL)), %b, via, %b, ansi(h, xget(%qP, last-msg-type)), .%b)), if(t(setr(0, lattr(%qP/msg-block-*))), strcat(You have blocked the following people:, %b, itemize(iter(%q0, name(last(itext(0), -)),, |), |), .%b)), if(t(setr(0, lattr(%qP/msg-hide-*))), strcat(You have hidden all messages from the following people:, %b, itemize(iter(%q0, name(last(itext(0), -)),, |), |), .%b)), if(t(setr(0, lattr(%qP/msg-send-*))), strcat(You have the following message shortcuts:, %b, itemize(iter(%q0, strcat(last(itext(0), -), :%b, ulocal(%qP/[itext(0)])),, |), |), .%b)), You have, %b, setr(0, words(lattr(%qP/_msg-*))), %b, unseen messages., if(gt(%q0, 0), %bType 'msg/view' to view them.), if(t(%1), %r));

&switch.msg.off MSG=&msg-receive-off %2=1; @pemit %2=alert(MSG) Message delivery disabled. First 50 messages will be queued for display when you turn messages back on.

&switch.msg.on MSG=@wipe %2/msg-receive-off; @pemit %2=alert(MSG) Message delivery enabled.; @trigger me/switch.msg.view=%0, %1, %2;

&switch.msg.view MSG=@switch/first t(setr(L, lattr(%2/_msg-*)))=1, {@pemit %2=alert(MSG) Here are the messages you missed.; @dolist/notify %qL={@pemit %2=strcat(\[, interval(rest(##, -)) ago, \], %b, xget(%2, ##)); @wipe %2/##;}; @wait me=@pemit %2=alert(MSG) All caught up.;}, {@pemit %2=alert(MSG) You have no unseen messages.;};

&switch.msg.block MSG=@eval setq(P, pmatch(first(%1, =))); @assert t(%qP)={@pemit %2=alert(MSG) Could not find player '[first(%1, =)]' (%qP).;}; @eval strcat(setq(R, rest(%1, =)), if(not(t(%qR)), setq(R, 1))); &msg-block-%qP %2=%qR; @pemit %2=alert(MSG) You have blocked [name(%qP)] from sending you messages. When [subj(%qP)] [case(subj(%qP), they, try, tries)] to message you, [subj(%qP)] will receive a message that says:%R[alert(MSG NOT SENT)] [name(%2)] has blocked you[if(match(%qR, 1), ., %bbecause: [s(%qR)])]

&switch.msg.unblock MSG=@eval setq(P, pmatch(first(%1, =))); @assert t(%qP)={@pemit %2=alert(MSG) Could not find player '[first(%1, =)]' (%qP).;}; @assert hasattr(%2, msg-block-%qP)={@pemit %2=alert(MSG) You are not currently blocking [name(%qP)].}; @wipe %2/msg-block-%qP; @pemit %2=alert(MSG) You are no longer blocking [name(%qP)] from sending you messages.

&switch.msg.hide MSG=@eval setq(P, pmatch(first(%1, =))); @assert t(%qP)={@pemit %2=alert(MSG) Could not find player '[first(%1, =)]' (%qP).;}; &msg-hide-%qP %2=1; @pemit %2=alert(MSG) You have hidden all messages from [name(%qP)]. Those messages will be lost forever, and [subj(%qP)] will not be notified that the message was not received.

&switch.msg.unhide MSG=@eval setq(P, pmatch(first(%1, =))); @assert t(%qP)={@pemit %2=alert(MSG) Could not find player '[first(%1, =)]' (%qP).;}; @assert hasattr(%2, msg-hide-%qP)={@pemit %2=alert(MSG) You are not currently blocking [name(%qP)].}; @wipe %2/msg-hide-%qP; @pemit %2=alert(MSG) You are no longer hiding messages from [name(%qP)].

@@ %0 - sender
@@ %1 - title
&layout.title MSG=if(t(%1), udefault(%0/msg-send-%1, strcat(%ch<%cn, %1, %ch>%cn)), %ch<%cnmessage%ch>%cn)

@@ %0 - sender
@@ %1 - recipients
@@ %2 - type
@@ %3 - message
&layout.msg MSG=strcat(ulocal(layout.title, %0, %2), %b, To, %b, itemize(iter(%1, name(itext(0)), |, |), |), :, %b, switch(%3, :*, name(%0) [rest(%3, :)], ;*, name(%0)[rest(%3, ;)], |*, %([name(%0)]%) [rest(%3, |)], name(%0) sends%, "%3"))

&switch.msg MSG=@break t(xget(%1, msg-receive-off))={@pemit %1=alert(MSG) You cannot send messages while your ability to receive messages is turned off. Type msg/on to enable the message system.;};@break not(t(%0))={@trigger me/switch.msg.summary=%1;};@eval setq(T, if(not(strmatch(%0, %b*)), strip(first(%0), /), xget(%1, last-msg-type)));@eval setq(L, switch(trim(%0), /* *=*, first(rest(%0), =), *=*, first(%0, =), edit(xget(%1, last-msg-target), |, %b)));@eval setq(V, trim(switch(%0, *=*, rest(%0, =), /* *, rest(%0), /*,, %0)));@break not(t(%qV))={@trigger me/switch.msg.summary=%1;};@eval strcat(setq(P, iter(%qL, case(itext(0), me, %1, pmatch(itext(0))),, |)), setq(P, setunion(%qP, %qP, |)));@eval iter(%qP, if(not(t(itext(0))), setq(E, %qE Could not find player '[if(t(%qL), extract(%qL, inum(0), 1), itext(0))]' ([itext(0)]).)), |); @break not(t(%qP))={@pemit %1=alert(MSG) You need to choose someone to send the message to. }; @break t(squish(trim(%qE)))={@pemit %1=alert(MSG) %qE;};@set %1=last-msg-target:%qP;@if t(%qT)={@set %1=last-msg-type:%qT;};@pemit %1=ulocal(layout.msg, %1, %qP, %qT, %qV);@dolist/delimit | [setdiff(setunion(%qP, %qP, |), %1, |)]={@switch/first 1=hasattr(##, msg-hide-%1), {}, hasattr(##, msg-block-%1), {@pemit %1=alert(MSG BLOCKED) [name(##)] has blocked you[if(match(setr(B, u(##/msg-block-%1)), 1), ., %bbecause: %qB)];}, and(or(t(xget(##, msg-receive-off)), not(hasflag(##, connect))), gte(words(lattr(##/_msg-*)), 50)), {@pemit %1=alert(MSG NOT DELIVERED) [name(##)] is not available and [poss(##)] message queue is full. Resend your message later.;}, or(t(xget(##, msg-receive-off)), not(hasflag(##, connect))), {&_msg-[secs()] ##=ulocal(layout.msg, %1, %qP, %qT, %qV);@pemit %1=alert(MSG DELAYED) Added message to [name(##)]'s message queue.;}, {@pemit ##=ulocal(layout.msg, %1, %qP, %qT, %qV);}}

@set MSG/switch.msg=no_parse


