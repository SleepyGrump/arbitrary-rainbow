/*
Dependencies: wheader(), wfooter(), alert(), the Equipment code, the Spirit Sheet Parent (for bans/benefits/aspirations of totems)

This is a mod for Thenomain's GMCCG (gotta be to list them pack merits). If you want something more generic, hit up Aether's factions code.

Side note: when counting totem points, we go with NOLA's house rule that you can have up to 2 Wolf-blooded Retainers who add one dot of Totem each. Other games might wish to remove this.

== Packs ==

===Commands:===

+packs - list all the packs

+pack <name> - list members of a pack, shows additional information if you are staff or a member of the pack

To set your position within a pack:

  &pack-position me=High Muckity Muck!

===Staff commands:===

stat/override player/Pack=<pack> - make it so a non-Werewolf/Wolf-blood shows up

Make sure that pack names match across players.

+pack/notes <pack>=<notes> - make a recruiting pitch, etc.

+pack/totem <pack>=<dbref> - must be the DBRef of the spirit totem if there is one

+pack/territory <pack>=<dbref> - dbref of a room

*/

@create Pack Data <PD>=10

@create Pack Functions <PF>=10
@set PF=INHERIT

@create Pack Manager <PM>=10
@set PM=COMMANDS INHERIT

@parent PM=PF
@parent PF=PD

@force me=&vD PF=[num(PD)]
@force me=&vE PF=[search(name=Equipment Functions <EQF>)]

@force me=&d.pm me=[num(PM)]
@force me=&d.pf me=[num(PF)]
@force me=&d.pd me=[num(PD)]

@tel PD=PF
@tel PF=PM

@desc [v(d.pm)]=Commands:%R%R+packs - list all the packs%R%R+pack <name> - list members of a pack, shows additional information if you are staff%R%RTo set your position within a pack:%R%R%T&pack-position me=High Muckity Muck!%R%RStaff commands:%R%Rstat/override player/Pack=<pack> - make it so a non-Werewolf/Wolf-blood shows up%R%RMake sure that pack names match across players.%R%R+pack/notes <pack>=<notes> - make a recruiting pitch, etc.%R%R+pack/totem <pack>=<dbref> - must be the DBRef of the spirit totem if there is one%R%R+pack/territory <pack>=<dbref> - dbref of a room%R

@@ -----------------------------------------------------------------------------
@@ Data
@@ -----------------------------------------------------------------------------

&d.motley_merits [v(d.pd)]=Hollow Stable_Trod Workshop Safe_Place_(*)

@@ -----------------------------------------------------------------------------
@@ Layouts
@@ -----------------------------------------------------------------------------

@@ %0 - error message
&layout.error [v(d.pf)]=alert(+packs error) %0

@@ %0 - message
&layout.msg [v(d.pf)]=alert(+packs) %0

@@ %0 - viewer
&layout.packs [v(d.pf)]=strcat(%b, wheader(Packs on [mudname()], %0), %r, %b, %cuPack name%cn, ansi(u, space(sub(width(%0), 18))), %cuMembers%cn, %r, iter(ulocal(f.get-packs), ulocal(layout.pack-line, %0, itext(0)), |, %r), %r, wfooter(+pack <name> for more info!))

@@ %0 - viewer
@@ %1 - pack name
&layout.pack-line [v(d.pf)]=strcat(setq(0, words(ulocal(f.get-members, %1))), %b, %1, %b, repeat(., sub(width(%0), add(strlen(%1), strlen(%q0), 4))), %b, %q0)

@@ %0 - viewer
@@ %1 - pack name
@@ %2 - member DBref
&layout.pack-member [v(d.pf)]=strcat(setq(0, default(%2/pack-position, No &pack-position set)), %b, name(%2), %b, repeat(., sub(width(%0), add(strlen(name(%2)), 4, strlen(%q0)))), %b, %q0)

@@ %0 - viewer
@@ %1 - pack name
@@ %2 - members
@@ %3 - merit
&layout.motley_merits [v(d.pf)]=strcat(setq(0, squish(ulocal(f.get-pack-merit, %2, %3))), if(gt(words(rest(%q0, |)), 1), strcat(%r%r%b, Total, %b, titlestr(edit(lcstr(%3), _merit.,, _, %b)), :, %b, first(%q0, |), %b, %(, Usable by, %b, itemize(iter(squish(rest(%q0, |)), name(itext(0)),, |), |), %))))

@@ %0 - viewer
@@ %1 - pack name
&layout.pack-info [v(d.pf)]=strcat(%b, wheader(titlestr(%1), %0), %r%b, %cuMembers%cn, ansi(u, space(sub(width(%0), 22))), %cuPack position%cn, %r, iter(setr(0, ulocal(f.get-members, %1)), ulocal(layout.pack-member, %0, %1, itext(0)),, %r), %r%r%b, Territory:, %b, if(t(setr(1, ulocal(f.get-pack-territory, %1))), name(%q1), No territory.), %r%r%b, Notes:, %b, ulocal(f.get-notes, %1), if(or(isstaff(%0), member(%q0, %0)), ulocal(layout.private-pack-info, %0, %1, %q0)), %r%r, wfooter())

@@ %0 - viewer
@@ %1 - pack name
@@ %2 - members
&layout.private-pack-info [v(d.pf)]=strcat(%r%r, wdivider(Private info), setq(0, ulocal(f.get-pack-totem-points, %2)), %r%r%b, Totem:, %b, if(t(setr(1, ulocal(f.get-pack-totem, %1))), strcat(name(%q1) %(, first(%q0, |) points, %), %r%r%b, Aspiration:, %b, xget(%q1, aspiration), %r%r%b, Ban:, %b, xget(%q1, ban), %r%r%b, Benefits:, %b, xget(%q1, benefits), %b, %(, Benefits usable by, %b, itemize(iter(squish(rest(%q0, |)), name(itext(0)),, |), |), %)), No totem set. %([first(%q0, |)] points to spend%)), %r%r%b, wdivider(Pack/Motley/Coterie merits, %0), setq(2,), null(iter(v(d.motley_merits), iter(%2, setq(2, setunion(%q2, lattr(itext(0)/_merit.[itext(1)])))))), iter(%q2, ulocal(layout.motley_merits, %0, %1, %2, itext(0)),, @@), %r%r, wdivider(Equipment purchases in [setr(M, extract(time(), 2, 1))]%, [setr(Y, last(time()))]), %r%r, ulocal(layout.pack-equipment, %0, %1, %2, %qM, %qY))

@@ %0 - viewer
@@ %1 - pack name
@@ %2 - members
@@ %3 - month
@@ %4 - year
&layout.pack-equipment [v(d.pf)]=strcat(setq(0, trim(squish(iter(%2, if(not(and(match(extract(setr(1, convsecs(extract(xget(itext(0), _APPROVAL.LOG), 2, 1, :))), 2, 1), %3), match(extract(%q1, 5, 1), %4))), ulocal(%vE/layout.equipment-by-month-year, %0, itext(0), %3, %4, Availability)),, %r), %r), b, %r)), if(t(%q0), %q0, %bNo equipment purchased yet this month %(not counting starting equipment%).))

@@ -----------------------------------------------------------------------------
@@ Functions
@@ -----------------------------------------------------------------------------

&f.players-with-packs [v(d.pf)]=search(eplayer=cand(isapproved(##, approved), not(isstaff(##)), hasattr(##, _bio.pack)))

&f.get-packs [v(d.pf)]=strcat(setq(0,), null(iter(ulocal(f.players-with-packs), setq(0, setunion(%q0, xget(itext(0), _bio.pack), |)),, @@)), %q0)

@@ %0 - pack name
&f.get-members [v(d.pf)]=strcat(setq(0,), null(iter(ulocal(f.players-with-packs), if(match(xget(itext(0), _bio.pack), %0, |), setq(0, setunion(%q0, itext(0)))),, @@)), %q0)

@@ %0 - pack name
&f.get-attribute [v(d.pf)]=edit(%0, %b, _)

@@ %0 - pack name
&f.get-notes [v(d.pf)]=default(%vD/notes-[ulocal(f.get-attribute, %0)], No notes set.)

@@ %0 - pack name
&f.get-pack-totem [v(d.pf)]=default(%vD/totem-[ulocal(f.get-attribute, %0)], #-1 NO TOTEM)

@@ %0 - pack name
&f.get-pack-territory [v(d.pf)]=default(%vD/territory-[ulocal(f.get-attribute, %0)], #-1 NO TERRITORY)

@@ %0 - pack members
@@ %1 - merit
&f.get-pack-merit [v(d.pf)]=strcat(min(5, ladd(iter(%0, xget(itext(0), %1)))), |, iter(%0, if(hasattr(itext(0), %1), itext(0))))

@@ %0 - pack members
@@ %1 - merit
&f.get-pack-equipment [v(d.pf)]=strcat(min(5, ladd(iter(%0, xget(itext(0), %1)))), |, iter(%0, if(hasattr(itext(0), %1), itext(0))))

@@ %0 - pack members
&f.get-pack-totem-points [v(d.pf)]=strcat(ladd(iter(%0, strcat(xget(itext(0), _merit.totem), %b, if(match(getstat(itext(0)/template), Werewolf), min(words(lattr(itext(0)/_merit.retainer_(*))), 2), 0)))), |, iter(%0, if(or(hasattr(itext(0), _merit.totem), not(member(Changeling.Vampire, getstat(itext(0)/template), .))), itext(0))))

@@ -----------------------------------------------------------------------------
@@ Commands
@@ -----------------------------------------------------------------------------

&cmd-+packs [v(d.pm)]=$+packs:@pemit %#=ulocal(layout.packs, %#)

&cmd-+pack_title [v(d.pm)]=$+pack *:@assert t(ulocal(f.get-members, %0))={@pemit %#=ulocal(layout.error, Can't find a pack named '%0'.)}; @pemit %#=ulocal(layout.pack-info, %#, %0)

&cmd-+pack [v(d.pm)]=$+pack:@pemit %#=if(hasattr(%#, _bio.pack), ulocal(layout.pack-info, %#, xget(%#, _bio.pack)), ulocal(layout.error, You don't currently have a pack set.))

&cmd-+pack/totem [v(d.pm)]=$+pack/totem *=*:@assert isstaff(%#)={@pemit %#=ulocal(layout.error, Staff has to set this.)}; @assert or(isdbref(%1), strmatch(%1,))={@pemit %#=ulocal(layout.error, %1 is not a dbref. Change it to the dbref of the totem object.)}; @assert t(ulocal(f.get-members, %0))={@pemit %#=ulocal(layout.error, Can't find a pack named '%0'.)}; @set %vD=totem-[ulocal(f.get-attribute, %0)]:%1; @pemit %#=ulocal(layout.msg, Pack totem for [titlestr(%0)] has been set to: [ulocal(f.get-pack-totem, %0)].)

&cmd-+pack/notes [v(d.pm)]=$+pack/notes *=*:@assert isstaff(%#)={@pemit %#=ulocal(layout.error, Staff has to set this.)}; @assert t(ulocal(f.get-members, %0))={@pemit %#=ulocal(layout.error, Can't find a pack named '%0'.)}; @set %vD=notes-[ulocal(f.get-attribute, %0)]:%1; @pemit %#=ulocal(layout.msg, Pack notes for [titlestr(%0)] have been set to: [ulocal(f.get-notes, %0)].)

&cmd-+pack/territory [v(d.pm)]=$+pack/territory *=*:@assert isstaff(%#)={@pemit %#=ulocal(layout.error, Staff has to set this.)}; @assert or(isdbref(%1), strmatch(%1,))={@pemit %#=ulocal(layout.error, %1 is not a dbref. Change it to the dbref of the territory sub-neighborhood.)}; @assert t(ulocal(f.get-members, %0))={@pemit %#=ulocal(layout.error, Can't find a pack named '%0'.)}; @set %vD=territory-[ulocal(f.get-attribute, %0)]:%1; @pemit %#=ulocal(layout.msg, Pack territory for [titlestr(%0)] has been set to: [ulocal(f.get-pack-territory, %0)].)

