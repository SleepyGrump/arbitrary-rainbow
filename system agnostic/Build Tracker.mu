/*

IN DEVELOPMENT.

================================================================================

Dependencies:
	wheader()
	wfooter()
	alert()

================================================================================

Anyone can do this stuff:

	+build/info - tells you all about the build - residents, guests, settings, etc. Basically "Who do I call when my players decide to burn this place to the ground?"

	+build/mail <text> - automatically mails the text you write to everyone who lives in the location. Note: if no one lives there, open a +request.

If the build is linkable or you are on the "administrators" list for the build, the following commands are available within the room:

	+build/movein - Move in. Your name will be added to the Guests or Residents list depending on whether you're on the "administrators" list for the build. When you type 'home', you'll go to the place.

	+build/moveout - Move out whenever you like. Your 'home' will be set to the OOC Room.

The following can only be performed by staff or the residents of a location:

	+build/authorize <player> - add a player to the "administrators" list - they can change descs, views, settings, etc. They can also add other administrators.

	+build/deauthorize <player> - remove a player from the "administrators" list.

Now actual build management commands:

	+build/desc <desc> - let the residents set the desc
	+build/view <name>=<value> - set a +view

	+build/set linkable - lets people add themselves as guests freely.
	+build/set public - open to the public at large, OK to be published in the directory
	+build/set private - private space for a player or players (default)

	@desc here=<desc> - lets you desc if you're a resident or if you're staff

Directory admin stuff, consider doing this but nothing uses it yet:

	+build/shortdesc <shortdesc> - a short description for the directory

	+build/tag <words> - tag the builds with things like "Residential", "OOC", "Cult hangout", "Unclaimed", etc.

	+build/untag <words> - remove a tag

	+build/alias <alias> - must be a short version of the build name, must be unique from all the other aliases on the grid. This would be what people would type to travel to a place once we implement +travel. If you haven't got an alias, people will have to use the DBRef.

Only staff can use these commands:

	+build/lock - lock the desc, views, and various build settings. Not even administrators or staff can change things if it's locked, so this should be used rarely.

	+build/unlock - unlock the build to permit administrators to change it.

================================================================================

Directory usage stuff, don't do this yet:

	+dir - what does this even do? List everything? List tags?
	+dir/list * - tag?
	+dir/find <buildname>*
	+dir/travel <build alias> - override +travel to do this as well.
	+dir/info <build alias>

Potential problems that need to be worked out before the above can be done:

	- +dir is a departure from the previous +build syntax.
	- Players would admin this by administering their builds. Is that OK?
	- We don't currently have any way to expire builds.
	- How does +dir tie in with +map?

================================================================================

Other code:

	cg/freeze should remove players from residency and guesthood.

================================================================================

*/

@@ WARNING: Not drop-in ready, change the name below to match your grid.

@force me=&d.rp me=[search(name=Room Parent)]

@set [v(d.rp)]=COMMANDS !HALTED INHERIT FLOATING

@@ Run this command when you're ready to turn this thing on for real.

@dolist children(v(d.rp))={@pemit %#=@@ [name(##)]%R@set ##=!HALTED;}

@@ If you don't do the above, none of this will work.

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

&cmd-+build/info [v(d.rp)]=$+build/info:@pemit %#=ulocal(layout.room-info, %#);



