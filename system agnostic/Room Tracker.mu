/*

IN DEVELOPMENT.

================================================================================

Dependencies:
	wheader()
	wfooter()
	alert()

================================================================================

Anyone can do this stuff:

	+room/info - tells you all about the room - residents, guests, settings, etc. Basically "Who do I call when my players decide to burn this place to the ground?"

	+room/mail <text> - automatically mails the text you write to everyone who lives in the location. Note: if no one lives there, open a +request.

	+room/list - list all your rooms. (A room is "yours" if you live there or are an administrator.)

	+room/travel <room> - go to your rooms.

If the room is linkable or you are on the "administrators" list for the room, the following commands are available within the room:

	+room/movein - Move in. Your name will be added to the Guests or Residents list depending on whether you're on the "administrators" list for the room. When you type 'home', you'll go to the place.

	+room/moveout - Move out whenever you like. Your 'home' will be set to the OOC Room.

The following can only be performed by staff or the residents of a location:

	+room/authorize <player> - add a player to the "administrators" list - they can change descs, views, settings, etc. They can also add other administrators.

	+room/deauthorize <player> - remove a player from the "administrators" list.

Now actual room management commands:

	+room/desc <desc> - let the residents set the desc
	+room/view <name>=<value> - set a +view

	+room/set linkable - lets people add themselves as guests freely.
	+room/set public - open to the public at large, OK to be published in the directory
	+room/set private - private space for a player or players (default)

	@desc here=<desc> - lets you desc if you're a resident or if you're staff

Directory admin stuff, consider doing this but nothing uses it yet:

	+room/shortdesc <shortdesc> - a short description for the directory

	+room/tag <words> - tag the rooms with things like "Residential", "OOC", "Cult hangout", "Unclaimed", etc.

	+room/untag <words> - remove a tag

	+room/alias <alias> - must be a short version of the room name, must be unique from all the other aliases on the grid. This would be what people would type to travel to a place once we implement +travel. If you haven't got an alias, people will have to use the DBRef.

Only staff can use these commands:

	+room/lock - lock the desc, views, and various room settings. Not even administrators or staff can change things if it's locked, so this should be used rarely.

	+room/unlock - unlock the room to permit administrators to change it.

Staff only, not sure I'll do these:

	+room/dig <name> - dig a room off the location you're in, parent it to the correct room parent, and chown it to the GridOwner. Teleport the user into it. Basically this is a dupe of +temproom code but instead of a temp room it's permanent by default.

	+room/check - look over every room and exit in the area for missing descs, permissions, etc. "Room 3 doesn't have any authorized players" would be a valid error. We'd have to spider-walk the build but that's doable. Set a max limit for spidering? 10 rooms?

================================================================================

Directory usage stuff, don't do this yet:

	+dir - what does this even do? List everything? List tags?
	+dir/list * - tag?
	+dir/find <roomname>*
	+dir/travel <room alias> - override +travel to do this as well.
	+dir/info <room alias>

Potential problems that need to be worked out before the above can be done:

	- +dir is a departure from the previous +room syntax.
	- Players would admin this by administering their rooms. Is that OK?
	- We don't currently have any way to expire rooms.
	- How does +dir tie in with +map?

================================================================================

Other code:

	cg/freeze should remove players from residency and guesthood.

================================================================================

*/

@@ WARNING: Not drop-in ready, change the name below to match your grid. If you don't already have a room parent... @dig one, and in the netmux.conf file for your game, add: room_parent <the dbref without the #>

@force me=&d.rp me=[search(name=Room Parent)]

@@ Here's how to @parent every room on your grid to that parent:
@@ @dolist children(v(d.rp))={ @parent ## = [v(d.rp)]}


@@ If you don't run the output of the code above, none of this will work. Of course, that presumes your original room parent was halted, like mine. :P If not, doesn't matter.

@@ OK, on to the actual code.

@@ =============================================================================
@@ Layouts
@@ =============================================================================

&layout.room-info [v(d.rp)]=strcat(wheader(name(%!), %0), %r%r, wfooter(, %0))

@@ =============================================================================
@@ Functions
@@ =============================================================================

@@ =============================================================================
@@ Commands
@@ =============================================================================

&cmd-+room/info [v(d.rp)]=$+room/info:@pemit %#=ulocal(layout.room-info, %#);



@@ Studying old temproom code to see how it's done currently.

/*
C.TEMPROOM [R]: $^\+?temproom (.*)$:@assert [or( isstaff( %# ), u( f.valid-room?
 , loc( %# )))]={ @pemit %#=You're not in a location that can take a temproom.
 }; think >> [setr( s, u( f.scrub_name, %1 ))] %r >> [setr( n, u( f.format.
 roomname, %qs, loc(%#) ))] %r >> [setr( e, u( f.format.entrance, %qs ))] %r >>
 [setr( x, u( f.format.exit, %qs ))];@assert valid( roomname, %qn )={@pemit
 %#=u( .msg, temproom, I can't take that name for a temproom. ) }; @assert
 valid( exitname, %qn )={ @pemit %#=u( .msg, temproom, I can't make that name
 into a good exit name. ) }; @assert not(t( match( elements( %qe, 2, %; ), v(
 d.illegal-anagrams ))))={ @pemit %#=u( .msg, temproom, The exit name would be
 too close to commonly used commands. ) }; @assert not(cor( t( locate( %#,
 elements( %qe, 2, %; ), E )), t( locate( %#, elements( %qe, 3, %; ), E ))))={
 @pemit %#=u( .msg, temproom, That would create an exit with an identical name
 as an exit in that room. )}; @trigger [v(d.digger)]/tr.dig-room=loc( %# ),
 %qn, %qe, %qx, %#; @eval u( f.monitor, temproom: [name( %# )] creates "%qs"
 off [name( loc( %# ))] ([loc( %# )]));
D.ILLEGAL-ANAGRAMS: i p o out l who
.MSG: alert(%0) %1

F.FORMAT.ROOMNAME: [titlestr(%0)] - [name(%1)]
F.FORMAT.ENTRANCE: trim(%0 <[setr(0, u(f.first_letters, %0))]>;%q0;%0;[strip(
 iter(%0, if(not(match(v(d.illegal-anagrams), itext(0))), itext(0)%;), %b,
 null(nothing)), %b)], r, %;)
F.FORMAT.EXIT: Out <O>;o;out;exit;leave
F.FIRST_LETTERS: ucstr(iter(tr(%0, _/-%(%), %b%b%b%b%b), strtrunc(%i0, 1), ,
 @@))
F.VALID-ROOM?: or(strmatch(parent(%0), v(d.room-parent)), strmatch(#287, %0))
TR.FINISH-ENTRANCE: @eval [setq(e, first(filter(fil.num-of-full-name,
 lexits(%0), , , %1)))] [setq(r, loc(%qe))]; @dolist [v(d.flags.entrance)]={@
 set %qe=%i0}; @desc %qe=A path to [name(%qr)].; @osuccess %qe=goes to
 [name(%qr)].; @success %qe=You go off to...; @odrop %qe=arrives from
 [name(%0)].; &room.%qr %!=[secs()].%qr.%qe.xxx.%2
TR.FINISH-ROOM: @eval [setq(r, %0)] [setq(x, exit(%0))]; @dolist [v(d.flags.
 room)]={@set %qr=%i0}; @dolist [v(d.flags.exit)]={@set %qx=%i0}; @parent
 %qr=[v(d.parent)]; @set %qr=STICKY; @link %qr=[loc(%qx)]; @chzone %qr=[v(d.
 temproom-zmo)]; @osuccess %qx=leaves back to [name(loc(%qx))]; @success
 %qx=You return to...; @odrop %qx=arrives from [name(%qr)].; &room.%qr
 %!=[replace(v(room.%qr), 4, %qx, .)];
FIL.NUM-OF-FULL-NAME: strmatch(fullname(%0), %1)
D.DIGGER: #292
D.PARENT: #293
D.GRID-OWNER [#12]: #95
D.ROOM-PARENT [#12]: #98

TR.TRANSFER-ROOM [#12]: @chown %2=[setr(O, v(d.grid-owner))];@chown %1=%qO;@
 chown %0=%qO;@set %0=!halt !inherit;@set %1=!halt;@set %2=!halt;@chzone
 %0=none;@parent %0=[v(d.room-parent)];@wipe me/room.%0;
C.HERE/PERM [#12]: $+here/perm*:@switch parent(setr(R, loc(%#)))=v(d.parent),
 {@if [isstaff(%#)]={think setr(O, v(d.grid-owner));@eval u(f.monitor,
 temproom: %N makes "[name(%qR)]" permanent.); @remit %qR=[u(d.attention)] %N
 sets this location permanent.;@set %qR=SAFE; @if get(setr(N, u(%qR/f.num.
 entrance, %qR))/desc)=, { @desc %qN=An entrance leading to [name(%qR)]; }; @if
 get(setr(X, u(%qR/f.num.exit, %qR))/desc)=, { @set %qX=transparent; @desc
 %qX=An exit leading to...; }; @trigger me/tr.transfer-room=%qR, %qX, %qN;},
 {@pemit %#=Only staff may set and unset the permenance of a temproom.}},
 {@pemit %#=This location is not a temproom.}


Digger:

D.HOME: #291
TR.DIG-ROOM: @tel %0; @dig %1=%2,%3; @trigger [v(d.home)]/tr.finish-entrance=%0,
  %2, %4
Amhear: @trigger [v(d.home)]/tr.finish-room=%1; @emit A new temproom has been
 created with the name '[name(%1)]'.; @tel [v(d.home)]
Listen: * created as room *.
*/