/*
Dependencies:
    alert()
    wheader()
    wfooter()
    isstaff()
    boxtext()
    A player named "GridOwner" <-- make one or this code will open a security risk and throw a lot of errors.

These are commands anyone can use anywhere on the grid, but which only work when the player owns the area (or is on the list of owners).

Purpose: To give players a sense of ownership and security on the grid.

We provide a simple form of locking: +lock o will lock both your Out exit and its corresponding entrance, assuming it's set up correctly. When the door is locked, no one can pass.

Please note that teleportation commands still work as normal - 'home', +meetme, +travel, +ic, etc, will all still bring players into locked buildings, and they can still leave with those commands as well.

In addition, staff can pass these locks, as they need to get to various places on the grid to fix exits as they find them.

 * +lock <exit> - lock an exit you control.

 * +unlock <exit> - unlock an exit you control.

This code also allows you some control over views and description in your room. You will not be able to make or remove the "Owner" view, since that is code-based, but you can add and remove other views, and can completely change the description.

 * +view/add <title>=<view> - add a +view

 * +view/remove <title> - remove a +view

 * +desc <#room or here>=<description> - edit the description
+
This code allows you to control some common flags your room might need:
@@ NEED BETTER SYNTAX HERE
 * +here/set FLAG or !FLAG - flip a flag on and off

The permitted flags are:

 * ABODE - let people @link me=here so they can type 'home' and arrive here.
 * UNFINDABLE - don't show this location on +where

Finally, as the owner of a room, you have the ability to let other people make changes to your space.

 * +owners [<#room or here>] - list everyone who has the ability to modify this area. (You can see this same information on the +view here/Owners view.)

 * +owner/add [<#room or here>=]<player> - allow <player> to change the room you're in the same way you can. Be warned that they can remove you from the owners' list, so only add people you trust! If problems come up with this, please submit a +request to staff.

 * +owner/remove [<#room or here>=]<player> - remove a player from the list of owners. Note: you can remove yourself if you no longer want to manage the location.

Things I might add but am not sure I see a need for:

 * +rooms - list all the rooms you have ownership of?

Staff commands:

 * +ep <name of a local exit or #exit>=<#exit> - pair two exits together. Hereafter, all locks will work on the paired exits as if they were a single door. You can use a name for the local exit, but you'll need to know the dbref of the remote exit.

 * +unpair <name or #exit> - will remove exit pairing from a pair of paired exits.

 * +owners/clear [<#room or here>] - clear out the list of owners completely. Useful if all the owners have gone idle or a new player is taking over a build. Will show you the list of who was cleared.

*/
@open/inventory Exit Parent <EP>;EP
@set EP=INHERIT

@@ Change this to "0" if you don't want staff to pass the lock.
&d.default-lock EP=[isstaff(%#)]

@create Grid Functions <GF>=10
@set GF=INHERIT

@force me=&d.exit-parent GF=num(EP)

@force me=&d.grid-owner GF=search(player=GridOwner)

&.msg GF=alert(Grid Msg) %0

&.remit GF=alert() %0

&.error-msg GF=alert(Grid Err) %0

@@ %0 - viewer
@@ %1 - room they're looking at
@@ %2 - owner
&layout.owner-line GF=strcat(setq(W, width(%0)), setq(N, name(%2)), setq(P, default(%2/position-%1, &position-%1 not set.)), space(3), %qN, %b, repeat(., sub(%qW, add(2, 6, strlen(name(%2)), strlen(%qP)))), %b, %qP)

@@ %0 - viewer
@@ %1 - room they're looking at
&layout.owners GF=strcat(wheader(name(%1) - room owners, %0), setq(O, lattr(%1/_owner-*)), %r, if(gt(words(%qO), 0), strcat(%r, boxtext(strcat(The following, %b, if(gt(words(%qO), 1), people, person), %b, may be reached for OOC questions/comments regarding this build:),,, %0, 3), %r%r, iter(%qO, ulocal(layout.owner-line, %0, %1, rest(itext(0), -)),, %r)), strcat(%r, boxtext(This place has no registered owners at the moment. Please contact staff via %chreq/build%cn if you have questions or comments.,,, %0, 3), %r)), %r, wfooter(, %0))

@@ %0 - person to test
@@ %1 - object to test whether they own
&f.isowner GF=cor(isstaff(%0), cand(isapproved(%0), if(hastype(%1, EXIT), cor(hasattr(loc(%1), _owner-%0), hasattr(loc(xget(%1, _exit-pair)), _owner-%0)), hasattr(%1, _owner-%0))))

@@ %0 - location to get the owners of
&f.get-owners GF=lattr(%0/_owner-*)

@@ %0 - the exit dbref
&f.exit-name GF=trim(first(name(%0), <))

@create Grid Commands <GC>=10
@set GC=INHERIT
@parent GC=GF

&tr.error GC=@pemit %0=ulocal(.error-msg, %1);

&tr.success GC=@pemit %0=ulocal(.msg, %1);

&tr.remit GC=@remit where(%0)=ulocal(.remit, %1);

&cmd-+ep GC=$+ep *=*:@assert isstaff(%#)={ @trigger me/tr.error=%#, You must be staff to use this command.; }; @assert cor(isdbref(setr(E, %0)), t(setr(E, trim(squish(iter(lexits(%L), if(strmatch(fullname(itext(0)), *;%0;*), itext(0))))))))={ @trigger me/tr.error=%#, Could not find the exit '%0'.; }; @assert cor(isdbref(setr(P, %1)), t(setr(P, trim(squish(iter(lexits(%L), if(strmatch(fullname(itext(0)), *;%1;*), itext(0))))))))={ @trigger me/tr.error=%#, Could not find the exit '%1'.; }; @assert words(%qE)={ @trigger me/tr.error=%#, More than one exit matches '%0'.; }; @assert words(%qP)={ @trigger me/tr.error=%#, More than one exit matches '%1'.; }; @assert type(%qE)=EXIT, { @trigger me/tr.error=%#, name(%qE) is not an exit.; }; @assert type(%qP)=EXIT, { @trigger me/tr.error=%#, name(%qP) is not an exit.; }; @set %qE=_exit-pair:%qP; @set %qP=_exit-pair:%qE; @parent %qE=[v(d.exit-parent)]; @parent %qP=[v(d.exit-parent)]; @chown %qE=[v(d.grid-owner)]; @chown %qP=[v(d.grid-owner)]; @set %qE=INHERIT; @set %qP=INHERIT; @trigger me/tr.success=%#, strcat(name(%qE) (%qE) has been linked to, %b, name(%qP) (%qP).);

&cmd-+owners GC=$+owners*:@assert t(case(1, not(t(%0)), setr(R, loc(%#)), setr(R, search(ROOMS=[trim(%0)]))))={ @trigger me/tr.error=%#, Could not figure out what room you're referring to. '[trim(%0)]' doesn't make sense.; }; @pemit %#=ulocal(layout.owners, %#, %qR);

&cmd-+owwner/add GC=$+owner/add *:@assert t(switch(%0, here=*, setr(R, loc(%#)), *=*, setr(R, first(%0, =)), setr(R, loc(%#))))={ @trigger me/tr.error=%#, Could not figure out what room you're referring to. '%qR' doesn't make sense.; }; @assert cand(t(switch(%0, *=me, setr(T, %#), me, setr(T, %#), *=*, setr(T, rest(%0, =)), setr(T, %0))), t(setr(P, pmatch(%qT))))={ @trigger me/tr.error=%#, Could not find a player named '%qT'.; }; @assert cor(isdbref(%qR), t(setr(R, search(ROOMS=%qR))))={ @trigger me/tr.error=%#, Could not find a room named '%qR'.; }; @assert words(%qR)={ @trigger me/tr.error=%#, More than one room matches '[first(%0, =)]'.; }; @assert u(f.isowner, %#, %qR)={ @trigger me/tr.error=%#, You must be an owner of [name(%qR)] to add another owner to the owners list.; }; @assert not(u(f.isowner, %qP, %qR))={ @trigger me/tr.error=%#, moniker(%qP) is already an owner of [name(%qR)].; }; @chown %qR=[v(d.grid-owner)]; @set %qR=_owner-%qP:[moniker(%qP)] was added by [moniker(%#)] on [time()]; @trigger me/tr.success=%#, strcat(moniker(%qP) (%qP) has been added as an owner of, %b, name(%qR) (%qR).);

&cmd-+owwner/remove GC=$+owner/remove *:@assert t(switch(%0, here=*, setr(R, loc(%#)), *=*, setr(R, first(%0, =)), setr(R, loc(%#))))={ @trigger me/tr.error=%#, Could not figure out what room you're referring to. '%qR' doesn't make sense.; }; @assert cand(t(switch(%0, *=me, setr(T, %#), me, setr(T, %#), *=*, setr(T, rest(%0, =)), setr(T, %0))), t(setr(P, pmatch(%qT))))={ @trigger me/tr.error=%#, Could not find a player named '%qT'.; }; @assert cor(isdbref(%qR), t(setr(R, search(ROOMS=%qR))))={ @trigger me/tr.error=%#, Could not find a room named '%qR'.; }; @assert words(%qR)={ @trigger me/tr.error=%#, More than one room matches '[first(%0, =)]'.; }; @assert u(f.isowner, %#, %qR)={ @trigger me/tr.error=%#, You must be an owner of [name(%qR)] to add another owner to the owners list.; }; @assert u(f.isowner, %qP, %qR)={ @trigger me/tr.error=%#, moniker(%qP) is not currently an owner of [name(%qR)].; }; @wipe %qR/_owner-%qP; @trigger me/tr.success=%#, strcat(moniker(%qP) (%qP) has been removed from the owners list of, %b, name(%qR) (%qR).);


&cmd-+lock GC=$+lock *:@assert cor(isdbref(setr(E, %0)), t(setr(E, trim(squish(iter(lexits(%L), if(strmatch(fullname(itext(0)), *;%0;*), itext(0))))))))={ @trigger me/tr.error=%#, Could not find the exit '%0'.; }; @assert words(%qE)={ @trigger me/tr.error=%#, More than one exit matches '%0'.; }; @assert type(%qE)=EXIT, { @trigger me/tr.error=%#, name(%qE) is not an exit.; }; @assert t(setr(P, xget(%qE, _exit-pair)))={ @trigger me/tr.error=%#, name(%qE) is not set up to be locked.; }; @switch t(lock(%qE/DefaultLock))=1, { @trigger me/tr.error=%#, name(%qE) is already locked.; }, { &_lock-exit %qE=[xget(v(d.exit-parent), d.default-lock)]; @lock/DefaultLock %qE=_lock-exit/1; &_lock-exit %qP=[xget(v(d.exit-parent), d.default-lock)]; @lock/DefaultLock %qP=_lock-exit/1; @trigger me/tr.remit=%#, strcat(moniker(%#), %b, just locked, %b, u(f.exit-name, %qE).); @trigger me/tr.remit=%qP, u(f.exit-name, %qP) is now locked.; };

&cmd-+unlock GC=$+unlock *:@assert cor(isdbref(setr(E, %0)), t(setr(E, trim(squish(iter(lexits(%L), if(strmatch(fullname(itext(0)), *;%0;*), itext(0))))))))={ @trigger me/tr.error=%#, Could not find the exit '%0'.; }; @assert words(%qE)={ @trigger me/tr.error=%#, More than one exit matches '%0'.; }; @assert type(%qE)=EXIT, { @trigger me/tr.error=%#, name(%qE) is not an exit.; }; @assert t(setr(P, xget(%qE, _exit-pair)))={ @trigger me/tr.error=%#, name(%qE) is not set up to be locked.; }; @switch t(lock(%qE/DefaultLock))=0, { @trigger me/tr.error=%#, name(%qE) is already unlocked.; }, { @wipe %qE/_lock-exit; @unlock/DefaultLock %qE; @wipe %qP/_lock-exit; @unlock/DefaultLock %qP; @trigger me/tr.remit=%#, strcat(moniker(%#), %b, just unlocked, %b, u(f.exit-name, %qE).); @trigger me/tr.remit=%qP, u(f.exit-name, %qP) is now unlocked.; };

@@ Set up an exit_parent and parent every exit on the grid to it. Useful for a pretty exit look... and maybe for making all the exits have this lock available on them.

@@ Searching exits is weird and a pain. Why the heck can't you search by partial names, bleh.

