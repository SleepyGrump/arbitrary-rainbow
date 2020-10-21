/*
Dependencies: NOLA Finger Code, for the _player-info bits.

Caveats: Change #6 to whatever object you want to put this on before installing!

=====Bugs:=====

 - It is possible to block someone AND whitelist them. If you do that, they will get through because the whitelist overrides the block.

 - Alt detection is imperfect. People might be blocked who shouldn't be. That's why we added +whitelist. We may also be able to modify the alts code to be better at handling things like webportals in the future.

 - Page-locking someone doesn't prevent you from paging them. That's a problem but I don't quite know how to deal with it correctly.

=====Help file:=====

Because not everyone is a coder, we made a few simple commands to let you block other people from paging you:

+block all - stop everybody from paging you.

+block <name> - block a player and all their alts.

+unblock <name> - unblock someone you've blocked.

+unblock all - unblock everyone except the people you've specifically blocked.

+block/clear - take everyone off your blocked players list.

+block, +blocks, and +block/who - list the people you have blocked and whitelisted.

+whitelist <name> - let someone through your "all" block. Everyone else will still be blocked.

+blacklist <name> - block them bypassing from your "all" block.

+whitelist/clear, +blacklist all - wipe your whitelist.

If someone tries to work around your +block by creating a new alt or paging you as a guest, that's harassment and should be reported to staff, because it violates our policies.

*/

&tr.lock-setup #6=@lock/page %0=page-lock/1; &page-lock %0=cor\(isstaff(\%#), member\(v\(whitelisted-PCs\), \%#\), not\(cor\(t\(v\(block-all\)\), member\(v\(blocked-PCs\), \%#\)\)\)\);

&cmd-+block_name #6=$+block *:@assert t(setr(P, switch(%0, all, all, pmatch(%0))))={ @pemit %#=alert(Error) Could not find a player named '%0'.; }; @break isstaff(%qP)={ @pemit %#=alert(Error) [moniker(%qP)] is staff and can't be blocked.; }; @trigger me/tr.+block=%#, %qP, default(%0/reject, Sorry%, [moniker(%#)] is not accepting pages.);

&tr.+block #6=@trigger me/tr.lock-setup=%0; &block-all %0=[strmatch(%1, all)]; @trigger me/tr.add-blocked-person=%0, %1; @pemit %0=alert(Page locker) You have blocked page messages from [switch(%1, all, everyone, moniker(%1))]. Blocked people who try to page you will see: %R%R%2%R%RTo change that message, type '@reject me=<message>'. To turn paging back on, +unblock [switch(%1, all, all, moniker(%1))].;

&tr.add-blocked-person #6=@break strmatch(%1, all); &blocked-PCs %0=setunion(xget(%0, blocked-PCs), u(fn.get-alts, %1)); &blocks %0=setunion(xget(%0, blocks), %1);

&cmd-+unblock #6=$+unblock *:@assert t(setr(P, switch(%0, all, all, pmatch(%0))))={ @pemit %#=alert(Error) Could not find a player named '%0'.; }; @assert switch(%qP, all, xget(%#, block-all), member(xget(%#, blocked-PCs), %qP))={ @pemit %#=alert(Page Locker) You aren't currently blocking [switch(%qP, all, pages from everyone, moniker(%qP))].; }; @trigger me/tr.+unblock=%#, %qP;

&tr.+unblock #6=@trigger me/tr.lock-setup=%0; &block-all %0=[switch(%1, all, 0, xget(%0, block-all))]; @trigger me/tr.unblock-person=%0, %1; @pemit %0=alert(Page locker) You have unblocked pages from [switch(%1, all, everyone, moniker(%1))].;

&tr.unblock-person #6=@break strmatch(%1, all); &blocked-PCs %0=setdiff(xget(%0, blocked-PCs), u(fn.get-alts, %1)); &blocks %0=setdiff(xget(%0, blocks), %1);

&fn.get-alts #6=search(eplayer=cand(not(isstaff(##)), strmatch(get(##/lastip), extract(get(%0/lastip), 1, 2, .).*), hasattr(%0, _player-info), hasattr(##, _player-info), t(setinter(iter(xget(%0, _player-info), extract(itext(0), 1, 3, -), |, |), iter(xget(##, _player-info), extract(itext(0), 1, 3, -), |, |), |))), 2)

&cmd-+block/clear #6=$+block/clear:@assert or(t(xget(%#, blocked-PCs)), t(setr(B, xget(%#, blocks))), t(setr(A, xget(%#, block-all))))={ @pemit %#=alert(Page locker) You currently aren't blocking anyone.; }; @wipe %#/blocked-PCs; @wipe %#/block-all; @wipe %#/blocks; @pemit %#=alert(Page locker) You have [switch(t(%qB)%qA, 10, unblocked [itemize(iter(%qB, moniker(itext(0)),, |), |)], 01, re-enabled pages for everyone, 11, unblocked [itemize(iter(%qB, moniker(itext(0)),, |), |)]%, and re-enabled pages for everyone, cleared your block list)].

&cmd-+block/who #6=$+block/who:@trigger me/tr.+block/who=%#;

&cmd-+block #6=$+block:@trigger me/tr.+block/who=%#;

&cmd-+block/list #6=$+block/list:@trigger me/tr.+block/who=%#;

&cmd-+whitelist #6=$+whitelist:@trigger me/tr.+block/who=%#;

&cmd-+blocks #6=$+blocks:@trigger me/tr.+block/who=%#;

&tr.+block/who #6=@assert or(t(xget(%0, blocked-PCs)), t(setr(B, xget(%0, blocks))), t(setr(A, xget(%0, block-all))), t(setr(W, xget(%0, whitelisted-PCs))))={ @pemit %0=alert(Page locker) You currently aren't blocking or whitelisting anyone.; }; @pemit %0=alert(Page locker) You are currently blocking pages from [switch(t(%qB)%qA, 10, itemize(iter(%qB, moniker(itext(0)),, |), |), 01, everyone, 11, everyone%, as well as [itemize(iter(%qB, moniker(itext(0)),, |), |)] specifically, no one)]. [if(t(%qW), You have whitelisted the following people: [itemize(iter(%qW, moniker(itext(0)),, |), |)])]

&cmd-+whitelist_name #6=$+whitelist *:@assert t(setr(P, pmatch(%0)))={ @pemit %#=alert(Error) Could not find a player named '%0'.; }; @break isstaff(%qP)={ @pemit %#=alert(Error) [moniker(%qP)] is staff and doesn't need to be whitelisted.; }; @trigger me/tr.+whitelist=%#, %qP;

&tr.+whitelist #6=@trigger me/tr.lock-setup=%0; &whitelisted-PCs %0=setunion(xget(%0, whitelisted-PCs), %1); @pemit %0=alert(Page locker) You have whitelisted [moniker(%1)]. They will be able to page you even when you have blocked pages from everyone. To remove them, +blacklist [moniker(%1)].;

&cmd-+blacklist #6=$+blacklist *:@break strmatch(%0, all)={ @trigger me/tr.+whitelist/clear=%#; }; @assert t(setr(P, pmatch(%0)))={ @pemit %#=alert(Error) Could not find a player named '%0'.; }; @assert member(xget(%#, whitelisted-PCs), %qP)={ @pemit %#=alert(Page Locker) [moniker(%qP)] is not currently whitelisted, so cannot be blacklisted. Did you mean +block?; }; @trigger me/tr.+blacklist=%#, %qP;

&tr.+blacklist #6=@trigger me/tr.lock-setup=%0; &whitelisted-PCs %0=setdiff(xget(%0, whitelisted-PCs), %1); @pemit %0=alert(Page locker) You have removed [moniker(%1)] from your whitelist. They will no longer be able to page you when you have blocked pages from everyone.;

&cmd-+whitelist/clear #6=$+whitelist/clear:@trigger me/tr.+whitelist/clear=%#;

&tr.+whitelist/clear #6=@assert t(setr(W, xget(%0, whitelisted-PCs)))={ @pemit %0=alert(Page locker) You currently aren't whitelisting anyone.; }; @wipe %0/whitelisted-PCs; @pemit %0=alert(Page locker) You have cleared your whitelist, which contained [itemize(iter(%qW, moniker(itext(0)),, |), |)]. They will no longer be able to page you when you have blocked pages from everyone.
