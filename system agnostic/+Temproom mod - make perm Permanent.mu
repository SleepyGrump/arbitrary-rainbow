@@ WARNING: Not drop-in ready! There are explicit DBRefs in here, change them as appropriate.

@force me=&d.tmp me=[search(name=Temproom Maker <trm>)]

&C.HERE/PERM [v(d.tmp)]=$+here/perm*:@switch parent(setr(R, loc(%#)))=v(d.parent), {@if [isstaff(%#)]={think setr(O, v(d.grid-owner));@eval u(f.monitor, temproom: %N makes "[name(%qR)]" permanent.); @remit %qR=[u(d.attention)] %N sets this location permanent.;@set %qR=SAFE !STICKY; @if get(setr(N, u(%qR/f.num.entrance, %qR))/desc)=, { @desc %qN=An entrance leading to [name(%qR)]; }; @if get(setr(X, u(%qR/f.num.exit, %qR))/desc)=, { @set %qX=transparent; @desc %qX=An exit leading to...; }; @trigger me/tr.transfer-room=%qR, %qX, %qN;}, {@pemit %#=Only staff may set and unset the permenance of a temproom.}}, {@pemit %#=This location is not a temproom.}

&TR.TRANSFER-ROOM [v(d.tmp)]=@chown %2=[setr(O, v(d.grid-owner))];@chown %1=%qO;@chown %0=%qO;@set %0=!halt !inherit;@set %1=!halt;@set %2=!halt;@chzone %0=none;@parent %0=[v(d.room-parent)];@wipe me/room.%0;

&D.GRID-OWNER [v(d.tmp)]=#95

&D.ROOM-PARENT [v(d.tmp)]=#98

