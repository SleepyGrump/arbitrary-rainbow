/*
Dependencies:
    alert()
    wheader()
    wfooter()
    isstaff()
    boxtext()
    titlestr()
    A player named "GridOwner" <-- make one or this code will open a security risk and throw a lot of errors.

Documentation:

These are commands anyone can use anywhere on the grid, but some of them only work when the player is on the list of owners for the room.

Purpose: To give players a sense of ownership and security on the grid.

We provide a simple form of locking: +lock o will lock both your Out exit and its corresponding entrance, assuming it's set up correctly. When the door is locked, no one can pass.

Please note that teleportation commands still work as normal - 'home', +meetme, +travel, +ic, etc, will all still bring players into locked buildings, and they can still leave with those commands as well.

In addition, staff can pass these locks, as they need to get to various places on the grid to fix exits as they find them.

 * +lock <exit> - lock an exit you control.

 * +unlock <exit> - unlock an exit you control.

This code also allows you some control over views and description in your room. You will not be able to make or remove the "Owner" view, since that is code-based, but you can add and remove other views, and can completely change the description.

 * +view/set [<location>/]<title>=<view> - add, update, or remove a +view

 * +view/add [<location>/]<title>=<view> - add a +view

 * +view/remove [<location>/]<title> - remove a +view

 * +desc <#room or here>=<description> - edit the description

Finally, as the owner of a room, you have the ability to let other people make changes to your space.

 * +owners [<#room or here>] - list everyone who has the ability to modify this area. (You can see this same information on the +view here/Owners view.)

 * +owner/add [<#room or here>=]<player> - allow <player> to change the room you're in the same way you can. Be warned that they can remove you from the owners' list, so only add people you trust! If problems come up with this, please submit a +request to staff.

 * +owner/remove [<#room or here>=]<player> - remove a player from the list of owners. Note: you can remove yourself if you no longer want to manage the location.

Staff commands:

 * +ep <name of a local exit or #exit>=<#exit> - pair two exits together. Hereafter, all locks will work on the paired exits as if they were a single door. You can use a name for the local exit, but you'll need to know the dbref of the remote exit.

*/
@create Exit Parent <EP>=10
@set EP=INHERIT

@@ Change this to "0" if you don't want staff to pass the lock.
&d.default-lock EP=[isstaff(%#)]

@desc EP=if(hasflag(me, transparent), A path leading to..., A path leading to [name(loc(me))].)

@descformat EP=strcat(alert(), %b, name(me) -, %b, ulocal(desc))

@create Grid Functions <GF>=10
@set GF=INHERIT

@create Grid Commands <GC>=10
@set GC=INHERIT
@parent GC=GF

@force me=&d.exit-parent GF=num(EP)

@force me=&d.grid-owner GF=search(player=GridOwner)

@force me=&d.gf me=num(GF)

@force me=&d.gc me=num(GC)

@@ This step parents all the exits on the grid to your new exit parent.

@dolist search(TYPE=exit)=@parent ##=[num(EP)];

@@ SIDE NOTE:
@@ 
@@ At this point, you should probably go into your netmux.conf and add the line "exit_parent 123" where "123" is the number of EP without the #.
@@ 
@@ If you don't do that, future exits will not look the same as existing exits.
@@ 

@tel EP=[v(d.gf)]
@tel [v(d.gf)]=[v(d.gc)]

&.msg [v(d.gf)]=alert(Grid Msg) %0

&.remit [v(d.gf)]=alert() %0

&.error-msg [v(d.gf)]=alert(Grid Err) %0

@@ %0 - viewer
@@ %1 - room they're looking at
@@ %2 - owner
&layout.owner-line [v(d.gf)]=strcat(setq(W, width(%0)), setq(N, name(%2)), setq(P, default(%2/position-%1, &position-%1 not set.)), space(3), %qN, %b, repeat(., sub(%qW, add(2, 6, strlen(name(%2)), strlen(%qP)))), %b, %qP)

@@ %0 - viewer
@@ %1 - room they're looking at
&layout.owners [v(d.gf)]=strcat(wheader(name(%1), %0), %r, wdivider(Room owners), setq(O, ulocal(f.get-owners, %1)), %r, if(gt(words(%qO), 0), strcat(%r, boxtext(strcat(The following, %b, if(gt(words(%qO), 1), people, person), %b, may be reached for OOC questions/comments regarding this build:),,, %0, 3), %r%r, iter(%qO, ulocal(layout.owner-line, %0, %1, itext(0)),, %r)), strcat(%r, boxtext(strcat(This place has no registered owners at the moment. Please contact staff via %chreq/build%cn if you have questions or comments., if(hasattr(%1, view-owner), strcat(%r%r, The old owner view:, %b, ulocal(%1/view-owner))), if(and(hasattr(%1, view-owners), not(match(xget(%1, view-owners), This location has owners. Use +owners to view them.))), strcat(%r%r, The old owners view:, %b, ulocal(%1/view-owners)))),,, %0, 3), %r)), %r, wfooter(, %0))

@@ %0 - person to test
@@ %1 - object to test whether they own
&f.isowner [v(d.gf)]=cor(isstaff(%0), cand(isapproved(%0), if(hastype(%1, EXIT), cor(hasattr(loc(%1), _owner-%0), hasattr(loc(xget(%1, _exit-pair)), _owner-%0)), hasattr(%1, _owner-%0))))

@@ %0 - location to get the owners of
&f.get-owners [v(d.gf)]=trim(squish(iter(lattr(%0/_owner-*), if(isapproved(rest(itext(0), -)), rest(itext(0), -)))))

@@ %0 - the exit dbref
&f.exit-name [v(d.gf)]=trim(first(name(%0), <))

&tr.error [v(d.gc)]=@pemit %0=ulocal(.error-msg, %1);

&tr.success [v(d.gc)]=@pemit %0=ulocal(.msg, %1);

&tr.remit [v(d.gc)]=@remit case(type(%0), ROOM, %0, where(%0))=ulocal(.remit, %1);

&cmd-+ep [v(d.gc)]=$+ep *=*:@assert isstaff(%#)={ @trigger me/tr.error=%#, You must be staff to use this command.; }; @assert cor(isdbref(setr(E, %0)), t(setr(E, trim(squish(iter(lexits(%L), if(strmatch(fullname(itext(0)), *;%0;*), itext(0))))))))={ @trigger me/tr.error=%#, Could not find the exit '%0'.; }; @assert cor(isdbref(setr(P, %1)), t(setr(P, trim(squish(iter(lexits(%L), if(strmatch(fullname(itext(0)), *;%1;*), itext(0))))))))={ @trigger me/tr.error=%#, Could not find the exit '%1'.; }; @assert words(%qE)={ @trigger me/tr.error=%#, More than one exit matches '%0'.; }; @assert words(%qP)={ @trigger me/tr.error=%#, More than one exit matches '%1'.; }; @assert type(%qE)=EXIT, { @trigger me/tr.error=%#, name(%qE) is not an exit.; }; @assert type(%qP)=EXIT, { @trigger me/tr.error=%#, name(%qP) is not an exit.; }; @set %qE=_exit-pair:%qP; @set %qP=_exit-pair:%qE; @parent %qE=[v(d.exit-parent)]; @parent %qP=[v(d.exit-parent)]; @chown %qE=[v(d.grid-owner)]; @chown %qP=[v(d.grid-owner)]; @set %qE=INHERIT; @set %qP=INHERIT; @trigger me/tr.success=%#, strcat(name(%qE) (%qE) has been linked to, %b, name(%qP) (%qP).);

&cmd-+owners [v(d.gc)]=$+owner*:@break strmatch(%0, */*)={ @assert switch(%0, /add *, 1, /remove *, 1, 0)={ @trigger me/tr.error=%#, Did you mean one of the following commands: +owner/add or +owner/remove?; }; }; @assert t(setr(T, switch(%0, s *, rest(%0),, loc(%#), %bhere, loc(%#), s, loc(%#), trim(%0))))={ @trigger me/tr.error=%#, Couldn't figure out what you meant by '%0'.; }; @assert t(case(1, isdbref(%qT), setr(R, %qT), match(%qT, here), setr(R, loc(%#)), setr(R, search(ROOMS=%qT))))={ @trigger me/tr.error=%#, Could not figure out what room you're referring to. '%qT' doesn't make sense.; }; @assert eq(words(%qR), 1)={ @trigger me/tr.error=%#, More than one room matched '%qT'.; }; @pemit %#=ulocal(layout.owners, %#, %qR);

&cmd-+view/owners [v(d.gc)]=$+view here/own*:@force %#=+owners;

&cmd-+view/owners [v(d.gc)]=$+view own*:@force %#=+owners;

&cmd-+owwner/add [v(d.gc)]=$+owner/add *:@assert t(switch(%0, here=*, setr(R, loc(%#)), *=*, setr(R, first(%0, =)), setr(R, loc(%#))))={ @trigger me/tr.error=%#, Could not figure out what room you're referring to. '%qR' doesn't make sense.; }; @assert cand(t(switch(%0, *=me, setr(T, %#), me, setr(T, %#), *=*, setr(T, rest(%0, =)), setr(T, %0))), t(setr(P, pmatch(%qT))))={ @trigger me/tr.error=%#, Could not find a player named '%qT'.; }; @assert cor(isdbref(%qR), t(setr(R, search(ROOMS=%qR))))={ @trigger me/tr.error=%#, Could not find a room named '%qR'.; }; @assert words(%qR)={ @trigger me/tr.error=%#, More than one room matches '[first(%0, =)]'.; }; @assert u(f.isowner, %#, %qR)={ @trigger me/tr.error=%#, You must be an owner of [name(%qR)] to add another owner to the owners list.; }; @assert not(u(f.isowner, %qP, %qR))={ @trigger me/tr.error=%#, moniker(%qP) is already an owner of [name(%qR)].; }; @assert isapproved(%qP)={ @trigger me/tr.error=%#, name(%qP) is not approved and cannot be made an owner.; }; @chown %qR=[v(d.grid-owner)]; @set %qR=_owner-%qP:[moniker(%qP)] was added by [moniker(%#)] on [time()]; &view-owners %qR=This location has owners. Use +owners to view them.; @trigger me/tr.success=%#, strcat(moniker(%qP) (%qP) has been added as an owner of, %b, name(%qR) (%qR).);

&cmd-+owwner/remove [v(d.gc)]=$+owner/remove *:@assert t(switch(%0, here=*, setr(R, loc(%#)), *=*, setr(R, first(%0, =)), setr(R, loc(%#))))={ @trigger me/tr.error=%#, Could not figure out what room you're referring to. '%qR' doesn't make sense.; }; @assert cand(t(switch(%0, *=me, setr(T, %#), me, setr(T, %#), *=*, setr(T, rest(%0, =)), setr(T, %0))), t(setr(P, pmatch(%qT))))={ @trigger me/tr.error=%#, Could not find a player named '%qT'.; }; @assert cor(isdbref(%qR), t(setr(R, search(ROOMS=%qR))))={ @trigger me/tr.error=%#, Could not find a room named '%qR'.; }; @assert words(%qR)={ @trigger me/tr.error=%#, More than one room matches '[first(%0, =)]'.; }; @assert u(f.isowner, %#, %qR)={ @trigger me/tr.error=%#, You must be an owner of [name(%qR)] to add another owner to the owners list.; }; @assert u(f.isowner, %qP, %qR)={ @trigger me/tr.error=%#, moniker(%qP) is not currently an owner of [name(%qR)].; }; @wipe %qR/_owner-%qP; @switch/first words(ulocal(f.get-owners, %qR))=0, { @wipe %qR/view-owner*; }; @trigger me/tr.success=%#, strcat(moniker(%qP) (%qP) has been removed from the owners list of, %b, name(%qR) (%qR).);

&cmd-+lock [v(d.gc)]=$+lock *:@assert cor(isdbref(setr(E, %0)), t(setr(E, trim(squish(iter(lexits(%L), if(strmatch(fullname(itext(0)), *;%0;*), itext(0))))))))={ @trigger me/tr.error=%#, Could not find the exit '%0'.; }; @assert words(%qE)={ @trigger me/tr.error=%#, More than one exit matches '%0'.; }; @assert type(%qE)=EXIT, { @trigger me/tr.error=%#, name(%qE) is not an exit.; }; @assert t(setr(P, xget(%qE, _exit-pair)))={ @trigger me/tr.error=%#, name(%qE) is not set up to be locked.; }; @switch t(lock(%qE/DefaultLock))=1, { @trigger me/tr.error=%#, name(%qE) is already locked.; }, { &_lock-exit %qE=[xget(v(d.exit-parent), d.default-lock)]; @lock/DefaultLock %qE=_lock-exit/1; &_lock-exit %qP=[xget(v(d.exit-parent), d.default-lock)]; @lock/DefaultLock %qP=_lock-exit/1; @trigger me/tr.remit=%#, strcat(moniker(%#), %b, just locked, %b, u(f.exit-name, %qE).); @trigger me/tr.remit=%qP, u(f.exit-name, %qP) is now locked.; };

&cmd-+unlock [v(d.gc)]=$+unlock *:@assert cor(isdbref(setr(E, %0)), t(setr(E, trim(squish(iter(lexits(%L), if(strmatch(fullname(itext(0)), *;%0;*), itext(0))))))))={ @trigger me/tr.error=%#, Could not find the exit '%0'.; }; @assert words(%qE)={ @trigger me/tr.error=%#, More than one exit matches '%0'.; }; @assert type(%qE)=EXIT, { @trigger me/tr.error=%#, name(%qE) is not an exit.; }; @assert t(setr(P, xget(%qE, _exit-pair)))={ @trigger me/tr.error=%#, name(%qE) is not set up to be locked.; }; @switch t(lock(%qE/DefaultLock))=0, { @trigger me/tr.error=%#, name(%qE) is already unlocked.; }, { @wipe %qE/_lock-exit; @unlock/DefaultLock %qE; @wipe %qP/_lock-exit; @unlock/DefaultLock %qP; @trigger me/tr.remit=%#, strcat(moniker(%#), %b, just unlocked, %b, u(f.exit-name, %qE).); @trigger me/tr.remit=%qP, u(f.exit-name, %qP) is now unlocked.; };

&cmd-+view/set [v(d.gc)]=$+view/set *=*:@assert t(switch(%0, here/*, setr(R, loc(%#)), */*, setr(R, first(%0, /)), setr(R, loc(%#))))={ @trigger me/tr.error=%#, Could not figure out what room you're referring to. '%qR' doesn't make sense.; }; @assert cand(t(switch(%0, */*, setr(T, rest(%0, /)), setr(T, %0))), valid(attrname, setr(T, strcat(view-, edit(%qT, %b, _)))))={ @trigger me/tr.error=%#, '%qT' is not a valid view title.; }; @assert cor(isdbref(%qR), t(setr(R, search(ROOMS=%qR))))={ @trigger me/tr.error=%#, Could not find a room named '%qR'.; }; @assert words(%qR)={ @trigger me/tr.error=%#, More than one room matches '[first(%0, /)]'.; }; @assert u(f.isowner, %#, %qR)={ @trigger me/tr.error=%#, You must be an owner of [name(%qR)] to add +views.; }; @assert not(strmatch(%qT, own*))={ @trigger me/tr.error=%#, '%qT' is too similar to 'owner'. You can't use it as a view title because it might confuse people.; }; @set %qR=%qT:[setq(O, xget(%qR, %qT))]%1; @trigger me/tr.success=%#, strcat(You have, %b, case(%1,, removed, if(t(%qO), updated, created)), %b, a +view on, %b, name(%qR) (%qR), %b, called, %b, ', titlestr(edit(%qT, view-,, _, %b, ~, %b)), '., if(t(%qO), strcat(%b, The old text was:, %b, %qO)));

&cmd-+view/add [v(d.gc)]=$+view/add *=*:@force %#=+view/set %0=%1;

&cmd-+view/remove [v(d.gc)]=$+view/remove *:@force %#=+view/set %0=;

&cmd-+desc [v(d.gc)]=$+desc *=*:@assert t(switch(%0, here, setr(R, loc(%#)), setr(R, %0)))={ @trigger me/tr.error=%#, Could not figure out what room you're referring to. '%qR' doesn't make sense.; }; @assert cor(isdbref(%qR), t(setr(R, search(ROOMS=%qR))))={ @trigger me/tr.error=%#, Could not find a room named '%qR'.; }; @assert words(%qR)={ @trigger me/tr.error=%#, More than one room matches '%0'.; }; @assert t(%1)={ @trigger me/tr.error=%#, You must include a description.; }; @assert u(f.isowner, %#, %qR)={ @trigger me/tr.error=%#, You must be an owner of [name(%qR)] to edit the description.; }; @set %qR=desc:[setq(O, xget(%qR, desc))]%1; @trigger me/tr.success=%#, strcat(You have updated the description on, %b, name(%qR) (%qR). The old text was:, %b, %qO); @trigger me/tr.remit=%qR, moniker(%#) has updated the description of this room.;
