@@ Requires:
@@ - alert()
@@ - isstaff()
@@ - wheader()
@@ - wfooter()
@@ - The "APPROVED" flag

/*
Commands:

	+channel - list all channels
	+channel/create <title>
	+channel/create <title>=<details>

	+channel/claim <existing channel> - (staff only) claim an existing channel and make it possible to administer the channel via this system. Will automatically create a channel log for this channel. If one already exists, use the second form of this command.

	+channel/claim <existing channel>=<dbref> - as above, but with an existing log object.

Only the owner (or staff) can perform the following commands:

	+channel/header <title>=<value> - set a channel's header (the "<format>" part)
	+channel/desc <title>=<value> - set a channel's description

	+channel/public <title> - set a channel public
	+channel/private <title> - set a channel private

	+channel/spoof <title> - set a channel spoofable (anonymous)
	+channel/nospoof <title> - set a channel non-spoofable (not anonymous)

	+channel/loud <title> - set a channel noisy (emits connects/disconnects)
	+channel/quiet <title> - set a channel quiet (no connects/disconnects)

	+channel/destroy <title> - nukes a channel (must be the owner or staff)

@@ Planned feature:
	+channel/give <title>=<player> - give a channel to someone else

@@ @ccreate <name>
@@ @create <name> Channel
@@ @cset/object <name>=<dbref of @create call>
@@ @cset/log <name>=50
@@ @cset/timestamp_logs <name>=1
@@ -
@@ &channel.#dbref CDB=<name>|creator|datetimestamp
@@ &creator-dbref #dbref=<dbref>
@@ -
@@ @cset/public|private <name>
@@ @cset/spoof|nospoof <name>
@@ -
@@ @cset/header <name>=<color thing>
@@ -
@@ @cdestroy <name>

*/

@create Channel Database <CDB>=10
@set CDB=SAFE

@create Channel Functions <CHF>=10
@set CHF=SAFE INHERIT
@parent CHF=CDB

@create Channel Commands <CHC>=10
@set CHC=SAFE INHERIT OPAQUE
@parent CHC=CHF

@force me=&vD CHF=[num(CDB)]

@desc CHC=%RCommands:%R%R%T+channel - list all channels%R%T+channel/create <title>%R%T+channel/create <title>=<details>%R%R%T+channel/claim <existing channel> - (staff only) claim an existing channel and make it possible to administer the channel via this system. Will automatically create a channel log for this channel. If one already exists, use the second form of this command.%R%R%T+channel/claim <existing channel>=<dbref> - as above, but with an existing log object.%R%ROnly the owner (or staff) can perform the following commands:%R%R%T+channel/header <title>=<value> - set a channel's header (the "<format>" part)%R%T+channel/desc <title>=<value> - set a channel's description%R%R%T+channel/public <title> - set a channel public%R%T+channel/private <title> - set a channel private%R%R%T+channel/spoof <title> - set a channel spoofable (anonymous)%R%T+channel/nospoof <title> - set a channel non-spoofable (not anonymous)%R%R%T+channel/loud <title> - set a channel noisy (emits connects/disconnects)%R%T+channel/quiet <title> - set a channel quiet (no connects/disconnects)%R%R%T+channel/destroy <title> - nukes a channel (must be the owner or staff)%R

@@ Add your channels here, separated by |'s.
@@ This should be whatever shows up in @clist.
@@ -
@@ This is really only for channels created not using this system, since there's no way to get a list of them separated by pipes (vital since it's possible to have multi-word channel names). If you haven't created any channels yet, leave it blank.

&d.existing-channels CDB=

@@ How many channels are non-staffers allowed to create?
@@ Set to 0 to disable player creation of channels.

&d.max-player-channels CDB=1


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Layouts
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %0 - error message
&layout.error CHF=alert(Channel error) %0

@@ %0 - message
&layout.msg CHF=alert(Channel) %0

@@ %0 - active status
@@ %1 - dbref of channel object
&layout.channel-line CHF=ljust(strcat(%b, case(%0, 1, Active:, Inactive:), %b, name(%1), %b, -, %b, ulocal(f.get-channel-details, %1)), 75)...

&layout.channels CHF=strcat(wheader(All channels), %R, iter(lattr(%vD/channel.*), ulocal(layout.channel-line, ulocal(f.can-create-channels, ulocal(f.get-channel-owner, rest(itext(0), .))), rest(itext(0), .)),, %R), %R, wfooter(+channel <name> for details))

@@ %0 - dbref of channel object
&layout.channel-details CHF=strcat(wheader(ulocal(f.get-channel-name, %0) channel details), %R%R%b, %chLogger dbref:%cn %0, %R%R%b, %chOwner:%cn%b, moniker(ulocal(f.get-channel-owner, %0)) %(, ulocal(f.get-channel-owner, %0), %), %R%R%b%chHistory:%cn, %b, ulocal(f.get-channel-details, %0), %R%R, wfooter())

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Local functions
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ %0 - player
&f.can-create-channels CHF=or(isstaff(%0), and(hasflag(%0, APPROVED), lt(words(xget(%0, _channels-created)), xget(%vD, d.max-player-channels))))

@@ %0 - the command input
&f.find-command-switch CHF=strcat(setq(0,), setq(1,), setq(2, switch(%0, /*/*, first(rest(first(%0), /), /), /*, rest(first(%0), /), )), null(iter(sort(lattr(%!/switch.*.%q2*)), case(1, match(last(itext(0), .), %q2), setq(0, %q0 [itext(0)]), strmatch(last(itext(0), .), %q2*), setq(1, %q1 [itext(0)])))), trim(if(t(%q0), first(%q0), %q1), b))

@@ %0 - player
@@ %1 - dbref of channel
&f.can-modify-channel CHF=and(ulocal(f.can-create-channels, %0), or(isstaff(%0), match(ulocal(f.get-channel-owner, %1), %0)))

@@ %0 - title of channel
&f.get-channel-dbref CHF=squish(trim(iter(lattr(%vD/channel.*), if(match(ulocal(f.get-channel-name, rest(itext(0), .)), %0), rest(itext(0), .)))))

@@ %0 - dbref of channel
&f.get-channel-owner CHF=xget(%0, creator-dbref)

@@ %0 - dbref of channel
&f.get-channel-name CHF=xget(%0, channel-name)

@@ %0 - dbref of channel
&f.get-channel-details CHF=xget(%vD, channel.%0)

@@ %0 - title of the new channel
&f.is-banned-name CHF=ladd(strcat(iter(lattr(%vD/channel.*), match(ulocal(f.get-channel-name, rest(itext(0), .)), %0)), %b, match(default(%vD, d.existing-channels, 0), %1, |)))

@@ %0 - title of channel
&f.clean-channel-name CHF=capstr(%0)

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Command manager
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&cmd-+channel CHC=$+channel*:@switch setr(E, strcat(setq(C, ulocal(f.find-command-switch, %0)), if(not(t(%qC)), Could not find command: +channel%0)))=, { @trigger me/%qC=%#, %0; }, { @pemit %#=ulocal(layout.error, %qE); }

@set CHC/cmd-+channel=!no_parse

@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Command switches
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

&switch.0.s CHC=@pemit %0=ulocal(layout.channels);

&switch.1. CHC=@pemit %0=if(and(t(trim(%1)), not(strmatch(%1, s*))), if(t(setr(0, ulocal(f.get-channel-dbref, trim(%1)))), ulocal(layout.channel-details, %q0), ulocal(layout.error, Could not find channel '[trim(%1)]')), ulocal(layout.channels));

&switch.1.create CHC=@trigger me/tr.channel-create=%0, rest(%1);

&switch.2.header CHC=@trigger me/tr.channel-header=%0, before(rest(%1), =), rest(%1, =);

&switch.2.desc CHC=@trigger me/tr.channel-desc=%0, before(rest(%1), =), rest(%1, =);

&switch.3.spoof CHC=@trigger me/tr.channel-spoof=%0, rest(%1);

&switch.3.nospoof CHC=@trigger me/tr.channel-nospoof=%0, rest(%1);

&switch.4.public CHC=@trigger me/tr.channel-public=%0, rest(%1);

&switch.4.private CHC=@trigger me/tr.channel-private=%0, rest(%1);

&switch.5.loud CHC=@trigger me/tr.channel-loud=%0, rest(%1);

&switch.5.quiet CHC=@trigger me/tr.channel-quiet=%0, rest(%1);

&switch.6.claim CHC=@trigger me/tr.channel-claim=%0, first(%1, =), rest(%1, =);

&switch.99.destroy CHC=@switch/first %1=*=*, { @trigger me/tr.destroy-channel=%0, first(rest(%1), =), rest(%1, =); }, { @trigger me/tr.confirm-destroy=%0, rest(%1); }


@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@
@@ Triggers
@@ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ @@

@@ Input:
@@ %0 - %#
@@ %1 - channel title
&tr.channel-create CHC=@switch setr(E, trim(squish(strcat(if(not(ulocal(f.can-create-channels, %0)), You are not allowed to create channels. This could be because players are not permitted to create channels or because you have already created your max quota of channels.), %b, if(not(t(setr(T, ulocal(f.clean-channel-name, first(%1, =))))), You need to include a title for the new channel.), %b, if(t(ulocal(f.is-banned-name, %qT)), You can't use the name '%qT' because it is in use or not allowed.), setq(D, rest(%1, =))))))=, { @switch setr(E, if(t(setr(N, create(%qT Channel Object, 10))),, Could not create '%qT Channel Object'. %qN))=, { @set %vD=channel.%qN:[strcat(%qT was created by, %b, moniker(%0) %(%0%) on, %b, time()., if(t(%qD), %bIts description was set to: '%qD'))]; @set %qN=channel-name:%qT; @set %qN=creator-dbref:%0; @ccreate %qT; @cset/object %qT=%qN; @desc %qN=[if(t(%qD), %qD, The '%qT' channel.)]; @cset/log %qT=200; @cset/timestamp_logs %qT=1; @cset/private %qT; @set %0=_channels-created:[setunion(%qN, xget(%0, _channels-created))]; @pemit %0=ulocal(layout.msg, Channel '%qT' created. It was automatically set 'Private'. +channel/public %qT if you want to change it. It was automatically set 'Nospoof'. To set your channel header%, type +channel/header %qT=<%1>. Color codes are allowed.); }, { @pemit %0=ulocal(layout.error, %qE); }; }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - channel title
@@ %2 - header
&tr.channel-header CHC=@switch setr(E, trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.), %b, if(not(t(%2)), You need to include a header value for the channel.)))))=, { @set %vD=channel.%qN:[strcat(xget(%vD, channel.%qN), %b, Header changed to '%2' on, %b, time(), %b, by, %b, name(%0) %(%0%).)]; @cset/header %qT=%2; @pemit %0=ulocal(layout.msg, Changed the header of '%qT' to '%2'.); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - channel title
@@ %2 - description
&tr.channel-desc CHC=@switch setr(E, trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.), setq(D, if(not(t(%2)), The '%qT' channel., %2))))))=, { @set %vD=channel.%qN:[strcat(xget(%vD, channel.%qN), %b, Desc changed to '%qD' on, %b, time(), %b, by, %b, name(%0) %(%0%).)]; @desc %qN=%qD; @pemit %0=ulocal(layout.msg, Changed the desc of '%qT' to '%qD'.); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - channel title
&tr.channel-public CHC=@switch setr(E, trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.)))))=, { @set %vD=channel.%qN:[strcat(xget(%vD, channel.%qN), %b, Set public on, %b, time(), %b, by, %b, name(%0) %(%0%).)]; @cset/public %qT; @pemit %0=ulocal(layout.msg, Changed '%qT' to 'Public'.); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - channel title
&tr.channel-private CHC=@switch setr(E, trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.)))))=, { @set %vD=channel.%qN:[strcat(xget(%vD, channel.%qN), %b, Set private on, %b, time(), %b, by, %b, name(%0) %(%0%).)]; @cset/public %qT; @pemit %0=ulocal(layout.msg, Changed '%qT' to 'Private'.); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - channel title
&tr.channel-loud CHC=@switch setr(E, trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.)))))=, { @set %vD=channel.%qN:[strcat(xget(%vD, channel.%qN), %b, Set loud on, %b, time(), %b, by, %b, name(%0) %(%0%).)]; @cset/loud %qT; @pemit %0=ulocal(layout.msg, Changed '%qT' to 'Loud'.); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - channel title
&tr.channel-quiet CHC=@switch setr(E, trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.)))))=, { @set %vD=channel.%qN:[strcat(xget(%vD, channel.%qN), %b, Set quiet on, %b, time(), %b, by, %b, name(%0) %(%0%).)]; @cset/quiet %qT; @pemit %0=ulocal(layout.msg, Changed '%qT' to 'Quiet'.); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - channel title
&tr.channel-spoof CHC=@switch setr(E, trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.)))))=, { @set %vD=channel.%qN:[strcat(xget(%vD, channel.%qN), %b, Set spoofable on, %b, time(), %b, by, %b, name(%0) %(%0%).)]; @cset/spoof %qT; @pemit %0=ulocal(layout.msg, Changed '%qT' to 'Spoofable'.); }, { @pemit %0=ulocal(layout.error, %qE); }

@@ Input:
@@ %0 - %#
@@ %1 - channel title
&tr.channel-nospoof CHC=@switch setr(E, trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.)))))=, { @set %vD=channel.%qN:[strcat(xget(%vD, channel.%qN), %b, Set non-spoofable on, %b, time(), %b, by, %b, name(%0) %(%0%).)]; @cset/nospoof %qT; @pemit %0=ulocal(layout.msg, Changed '%qT' to 'Non-spoofable'.); }, { @pemit %0=ulocal(layout.error, %qE); }


@@ Input:
@@ %0 - %#
@@ %1 - channel title
@@ %2 - existing log object (if exists)
&tr.channel-claim CHC=@assert isstaff(%0)={ @pemit %0=ulocal(layout.error, Staff only.); }; @assert t(comalias(%0, %1))={ @pemit %0=ulocal(layout.error, Can't find a channel you joined named '%1'. Please enter the exact name of the channel - it is case sensitive - and make sure you have joined the channel.); }; @assert or(cand(isdbref(%2), match(type(%2), THING), t(setr(N, %2))), t(setr(N, create(%1 Channel Object, 10))))={ @pemit %0=ulocal(layout.error, if(t(%2), '%2' is not a valid channel log object., Could not create '%1 Channel Object'.)); }; @set %vD=channel.%qN:[strcat(%1 was claimed by, %b, moniker(%0) %(%0%) on, %b, time().)]; @set %qN=channel-name:%1; @set %qN=creator-dbref:%0; @cset/object %1=%qN; @desc %qN=[default(%qN/desc, The '%1' channel.)]; @cset/log %1=200; @cset/timestamp_logs %1=1; @set %0=_channels-created:[setunion(%qN, xget(%0, _channels-created))]; @set %vD=d.existing-channels:[setdiff(xget(%vD, d.existing-channels), %1, |)]; @pemit %0=ulocal(layout.msg, Channel '%1' claimed. It's yours now. Take good care of it!);

@@ Input:
@@ %0 - %#
@@ %1 - title
&tr.confirm-destroy CHC=@switch setr(E, trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.)))))=, { @set %0=_channel-nuke:%qN|[secs()]; @pemit %0=ulocal(layout.msg, Before you continue%, make absolutely certain that %qT is the channel you want to destroy. There are [words(cwho(%1, on))] people on this channel. If you're absolutely certain you want to destroy this channel%, type +channel/destroy %qT=YES); }, { @pemit %0=ulocal(layout.error, %qE); }


@@ Input:
@@ %0 - %#
@@ %1 - title
@@ %2 - hopefully 'YES'
&tr.destroy-channel CHC=@switch trim(squish(strcat(if(not(t(setr(N, ulocal(f.get-channel-dbref, setr(T, ulocal(f.clean-channel-name, %1)))))), Could not find channel '%qT'. You must use the exact name of the channel you wish to modify.), %b, if(not(ulocal(f.can-modify-channel, %0, %qN)), You are not staff or the owner of the channel '%qT' and cannot change it.), %b, if(or(not(strmatch(%qN, first(setr(W, xget(%0, _channel-nuke)), |))), gt(sub(secs(), rest(%qW, |)), 300), not(match(%2, YES))), Your destruction timeout expired or you didn't type 'YES'. Please try again.))))=, { @cdestroy %qT; @wipe %vD/channel.%qN; @destroy %qN; @pemit %0=alert(Channel) The channel '%qT' has been destroyed.; }, { @pemit %0=ulocal(layout.error, %qE); };

@tel CDB=CHF
@tel CHF=CHC

