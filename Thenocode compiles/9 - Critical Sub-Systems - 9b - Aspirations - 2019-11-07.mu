/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/9%20-%20Critical%20Sub-Systems/9b%20-%20Aspirations.txt

Compiled 2019-11-07

&f.filter.all was missing a comma after if( strlen( %qf ).

*/

think Entering 54 lines.

@create Aspirations System <asp>

@set Aspirations System <asp>=safe inherit

@fo me=&d.asp me=[search(name=Aspirations System <asp>)]

@parent Aspirations System <asp>=codp

@fo me=&d.asp [v(d.cg)]=search(name=Aspirations System <asp>)

@fo me=&d.jrs [v(d.asp)]=search(name=Jobs Request System <jrs>)

@fo me=&d.bucket [v(d.asp)]=u(get(v(d.jrs)/va)/FN_FIND-BUCKET, ASP)

@fo me=&d.jgroup [v(d.asp)]=u(get(v(d.jrs)/va)/FN_FIND-JGROUP, +allstaff)

@assert search(name=Jobs Request System <jrs>)={think ansi(rhu, WARNING!!!, nh, %bCould not find "Jobs Request System <jrs>"! Aspirations code will not work until this is fixed.)}

&.msg [v(d.asp)]=ansi(h, <%0>, n, %b%1)

&.lmax [v(d.asp)]=lmax(%0, %1)

&.wheader [v(d.asp)]=wheader(%0)

&.wfooter [v(d.asp)]=wfooter(%0)

&.wdivider [v(d.asp)]=wdivider(%0)

&.titlestr [v(d.asp)]=titlestr(%0)

&sortby.index [v(d.asp)]=sub(rest(%0, .), rest(%1, .))

&filter.term [v(d.asp)]=strmatch(elements(get(%1/%0), 2, |), %2)

&filter.status [v(d.asp)]=strmatch(first(elements(get(%1/%0), 1, |), :), %2)

&filter.aspiration.keyword [v(d.asp)]=strmatch(elements(get(%1/%0), 3, |), *%2*)

&filter.fulfilled.keyword [v(d.asp)]=strmatch(elements(get(%1/%0), 4, |), *%2*)

&f.filter.all [v(d.asp)]=strcat(setq(c, lattr(%0/_aspiration.*)), setq(t, trim(edit(grab(%1, term:*, |), term:,))), setq(s, trim(edit(grab(%1, status:*, |), status:,))), setq(a, trim(edit(grab(%1, keyword:*, |), keyword:,))), setq(f, trim(edit(grab(%1, fulfill:*, |), fulfill:,))), if(strlen(%qt), setq(c, filter(filter.term, %qc,,, %0, %qt)), setq(c, %qc)), if(strlen(%qs), setq(c, filter(filter.status, %qc,,, %0, %qs)), setq(c, %qc)), if(strlen(%qa), setq(c, filter(filter.aspiration.keyword, %qc,,, %0, %qa)), setq(c, %qc)), if(strlen(%qf), setq(c, filter(filter.fulfilled.keyword, %qc,,, %0, %qf)), setq(c, %qc)), sortby(sortby.index, %qc))

&f.next-index [v(d.asp)]=localize(first(setdiff(lnum(1, inc(last(setr(l, sort(edit(lattr(%0/_aspiration.*), _ASPIRATION.,)))))), %ql)))

&c.aspiration [v(d.asp)]=$^\+?asp(/[^]+)?(.*)?$:think strcat(switch entered:, %b, setr(s, trim(rest(%1, /))), %r, switches known:, %b, setr(k, sort(iter(lattr(%!/c.aspiration*), rest(%i0, /),, |), a, |, |)), %r, switch matched:, %b, setr(m, grab(|%qk, %qs*, |)), %r, content:, %b, setr(c, trim(%2)), %r,);@assert not(haspower(%#, guest))={@pemit %#=u(.msg, asp, I'm sorry%, guest%, but this isn't *for* you.)};@assert cor(not(%qs), t(%qm))={@pemit %#=u(.msg, asp, I don't know the switch '%qs'. I know: [itemize(lcstr(trim(%qk, b, |)), |)])};@pemit %#=case(1, cand(t(%qs), t(%qm)), u(c.aspiration/%qm, %qc), t(%qc), strcat(if(strmatch(%qc, */*), [setq(p, pmatch(first(%qc, /)))][setq(n, rest(%qc, /))], [setq(p, %#)][setq(n, %qc)]), case(0, cor(isstaff(%#), strmatch(%#, %qp)), u(.msg, asp, You cannot check someone else's aspiration.), hastype(%qp, player), u(.msg, asp, No such player), isint(%qn), u(.msg, asp, You didn't enter a number%; did you mean 'asp/list %qn'?), u(display.aspiration.details, %qp, %qn))), u(display.aspiration.list, %#, lattr(%#/_aspiration.*)));

@set v(d.asp)/c.aspiration=regex

@set v(d.asp)/c.aspiration=no_parse

&c.aspiration/pitch [v(d.asp)]=strcat(setq(f, trim(first(%0, =))), setq(r, trim(rest(%0, =))), if(strlen(%qr), u(f.aspiration/pitch.action, %qf, %qr), u(f.list.aspirations, if(strlen(%qf), pmatch(%qf), %#), pitched, asp/pitch)))

&c.aspiration/approve [v(d.asp)]=strcat(setq(p, trim(first(%0, /))), setq(r, trim(rest(%0, /))), if(strlen(%qr), u(f.aspiration/approve.action, %qp, %qr), u(f.list.aspirations, if(strlen(%qp), %qp, %#), approved, asp/approve)))

&c.aspiration/deny [v(d.asp)]=strcat(setq(p, trim(first(%0, =))), setq(n, trim(rest(%0, =))), u(f.aspiration/deny.action, %qp, %qn))

&c.aspiration/drop [v(d.asp)]=strcat(setq(n, trim(first(%0, =))), setq(r, trim(rest(%0, =))), u(f.aspiration/drop.request, %qn, %qr))

&c.aspiration/fulfill [v(d.asp)]=strcat(setq(f, trim(first(%0, =))), setq(r, trim(rest(%0, =))), case(0, strlen(%qr), u(f.list.aspirations, if(strlen(%qf), %qf, %#), fulfilled, asp/fulfill), strmatch(%qf, */*), u(f.aspiration/fulfill.request, %qf, %qr), u(f.aspiration/fulfill.approve, first(%qf, /), rest(%qf, /), %qr)))

&c.aspiration/filter [v(d.asp)]=u(.msg, planned, asp/list %[<player>/%]filter filter filter)

&c.aspiration/list [v(d.asp)]=strcat(setq(p, pmatch(first(%0, =))), setq(n, trim(rest(%0, =))), case(0, isstaff(%#), u(.msg, asp/list, Staff only.), t(%qp), u(.msg, asp/list, '[trim(first(%0, =))]' isn't a player), isint(%qn), u(display.aspiration.list, %qp, lattr(%qp/_aspiration.*)), u(display.aspiration.details, %qp, %qn)))

&c.aspiration/filter [v(d.asp)]=u(.msg, planned, asp/filter %[<player>/%]<filter> <filter> <filter>)

&f.create.job [v(d.asp)]=trigger(v(d.jrs)/trig.create.job, %0, u(d.bucket), 2, %1, %2, u(d.jgroup))

&f.aspiration/pitch.action [v(d.asp)]=strcat(setq(t, grab(|long-term|short-term, %0*, |)), setq(a, translate(edit(%1, |,), p)), setq(n, u(f.next-index, %#)), case(0, t(%qt), u(.msg, asp/pitch, Please pick 'short-term' or 'long-term'), strlen(%qa), u(.msg, asp/pitch, You need to enter an aspiration, at least), strcat(set(%#, _aspiration.%qn:pitched:[secs()]|%qt|%qa), u(.msg, asp/pitch, u(display.pitch.player-message, %#, %qn, %qt, %qa)), if(not(isapproved(%#, chargen)), u(f.create.job, %#, u(display.pitch.title, %#, %qt), u(display.pitch.contents, %#, %qn, %qt, %qa))))))

&display.pitch.player-message [v(d.asp)]=strcat(You have asked for a new %2 aspiration:, %b, ansi(h, %3), if(not(isapproved(%#, chargen)), strcat(%r%r, It is currently waiting as aspiration #%1., %r, A job has been created for you concerning it. Please be patient and wait for staff to complete it. Thanks.)))

&display.pitch.title [v(d.asp)]=PITCH: [capstr(%1)] aspiration for [name(%0)]

&display.pitch.contents [v(d.asp)]=strcat(setr(n, name(%0)), %b, is pitching a new %2 aspiration:, %r%r, ansi(h, %3), %r%r, If you approve of this%, type:, %r, %b %b asp/approve %qn/%1, %r%r, If not%, type:, %r, %b %b asp/deny %qn=%1, %r%r, Either way%, be sure to close this job with the reason that you are closing it.)

&f.aspiration/fulfill.request [v(d.asp)]=strcat(setq(n, %0), setq(r, translate(edit(%1, |,), p)), setq(a, get(%#/_aspiration.%qn)), setq(s, first(%qa, :)), setq(a, last(%qa, |)), case(0, t(%qa), u(.msg, asp/fulfill, You have no such aspiration), strmatch(%qs, approved), u(.msg, asp/fulfill, The aspiration is '%qs' and can't be fulfilled), strlen(%qr), u(.msg, asp/fulfill, You have no such aspiration), strcat(u(.msg, asp/fulfill, u(display.fulfill.player-message, %#, %qn, %qa, %qr)), u(f.create.job, %#, u(display.fulfill.title, %#, %qn), u(display.fulfill.contents, %#, %qn, %qa, %qr)))))

&display.fulfill.player-message [v(d.asp)]=strcat(You have asked to fulfill aspiration #%1:, %b, ansi(h, %2), %r%r, Your reason:, %b, ansi(h, %3), %r%r, A job has been created for you concerning it. Please be patient and wait for staff to complete it. Thanks.)

&display.fulfill.title [v(d.asp)]=FULFILL: Aspiration #%1 for [name(%0)]

&display.fulfill.contents [v(d.asp)]=strcat(setr(n, name(%0)), %b, is asking to fullfill Aspiration #%1:, %b, ansi(h, %2), %r%r, The reasoning:, %b, ansi(h, %3), %r%rIf you approve of this%, type:, %r, %b %b asp/fulfill %qn/%1=%3, %r%r, Then close this job., %r%r, Otherwise%, start a discussion with the player or close this job with a reason why not.)

&f.aspiration/fulfill.approve [v(d.asp)]=strcat(setq(p, pmatch(%0)), setq(a, get(%qp/_aspiration.%1)), setq(s, first(%qa, :)), case(0, isstaff(%#), u(.msg, asp/fulfill, Staff only.), t(%qp), u(.msg, asp/fulfill, No such player.), strlen(%qa), u(.msg, asp/fulfill, No such aspiration.), strmatch(%qs, approved), u(.msg, asp/fulfill, Aspiration #%1 is '%qs'. It must be 'approved' to fulfill.), strlen(%2), u(.msg, asp/fulfill, You must fulfill with a reason%, probably given by the player.), strcat(setq(n, replace(%qa, 1, fulfilled, :)), setq(n, %qn|[edit(%2, |,)]), set(%qp, _aspiration.%1:%qn), u(.msg, asp/fulfill, Fulfilled [name(%qp)]'s Aspiration #%1 with reason: [edit(%2, |,)]), %r, u(.msg, asp/fulfill, Remember to approve their job and give them a Beat!))))

&f.aspiration/drop.request [v(d.asp)]=strcat(setq(n, %0), setq(r, translate(edit(%1, |,), p)), setq(a, get(%#/_aspiration.%qn)), setq(s, first(%qa, :)), setq(a, last(%qa, |)), case(0, t(%qa), u(.msg, asp/drop, You have no such aspiration), cor(strmatch(%qs, pitched), strmatch(%qs, approved)), u(.msg, asp/drop, The aspiration is '%qs' and can't be dropped), cor(strmatch(%qs, pitched), strlen(%qr)), u(.msg, asp/drop, You must include a reason), case(%qs, pitched, strcat(u(.msg, asp/drop, strcat(Deleting Aspiration #%qn pitch:, %b, ansi(h, %qa), %r, space(11), Be sure to tell staff in your job!)), set(%#, _aspiration.%qn:)), approved, strcat(u(.msg, asp/drop, u(display.drop.player-message, %#, %qn, %qa, %qr)), u(f.create.job, %#, u(display.drop.title, %#, %qn), u(display.drop.contents, %#, %qn, %qa, %qr))))))

&display.drop.player-message [v(d.asp)]=strcat(You have asked to drop aspiration #%1:, %b, ansi(h, %2), %r%r, Your reason:, %b, ansi(h, %3), %r%r, A job has been created for you concerning it. Please be patient and wait for staff to complete it. Thanks.)

&display.drop.title [v(d.asp)]=DROP: Aspiration #%1 for [name(%0)]

&display.drop.contents [v(d.asp)]=strcat(setr(n, name(%0)), %b, is asking to drop Aspiration #%1:, %b, ansi(h, %2), %r%r, The reasoning:, %b, ansi(h, %3), %r%rIf you approve of this%, type:, %r, %b %b asp/deny %qn=%1, %r%r, Then complete this job., %r%r, Otherwise%, start a discussion with the player or complete this job with a reason why not.)

&f.aspiration/deny.action [v(d.asp)]=strcat(setq(p, pmatch(%0)), setq(a, get(%qp/_aspiration.%1)), setq(s, first(%qa, :)), case(0, isstaff(%#), u(.msg, asp/deny, Staff only.), t(%qp), u(.msg, asp/deny, No such player.), strlen(%qa), u(.msg, asp/deny, No such aspiration.), cor(strmatch(%qs, pitched), strmatch(%qs, approved)), u(.msg, asp/deny, Aspiration #%1 is '%qs'. It needs to be 'pitched' or 'approved'.), strcat(u(.msg, asp/deny, strcat(Deleting, %b, moniker(%qp), 's Aspiration #%1 pitch:, %b, elements(%qa, 3, |), %r, space(11), Remember to process their job with a reason why.)), set(%qp, _aspiration.%1:))))

&f.aspiration/approve.action [v(d.asp)]=strcat(setq(p, pmatch(%0)), setq(a, get(%qp/_aspiration.%1)), setq(s, first(%qa, :)), case(0, isstaff(%#), u(.msg, asp/approve, Staff only.), t(%qp), u(.msg, asp/approve, No such player.), strlen(%qa), u(.msg, asp/approve, No such aspiration.), strmatch(%qs, pitched), u(.msg, asp/approve, Aspiration #%1 is '%qs'. It must be 'pitched' to fulfill.), strcat(setq(n, replace(%qa, 1, approved, :)), set(%qp, _aspiration.%1:%qn), u(.msg, asp/approve, Approved [name(%qp)]'s Aspiration #%1. They may now fulfill it.), %r, u(.msg, asp/approve, Remember to complete their job.))))

&f.list.aspirations [v(d.asp)]=case(0, t(hastype(setr(p, pmatch(%0)), player)), u(.msg, %2, Cannot find '%0'.), cor(isstaff(%#), strmatch(%qp, %#)), u(.msg, %2, You may only list your own aspirations.), strcat(setq(f, grab(*|pitched|approved|fulfilled, %1*, |)), setq(a, u(f.get.aspirations.status, %qp, %qf)), u(display.aspiration.list, %qp, %qa, if(dec(strlen(%qf)), %qf))))

&f.get.aspirations.status [v(d.asp)]=filter(filter.status, lattr(%0/_aspiration.*),,, %0, %1)

&display.aspiration.list [v(d.asp)]=strcat(setq(t, if(words(%2), %2, approved pitched)), setq(m, inc(max(2, strlen(u(.lmax, sort(edit(%1, _ASPIRATION.,))))))), setq(w, sub(width(%#), 3)), setq(r, sub(%qw, add(%qm, 1))), u(.wheader, Aspirations: [itemize(u(.titlestr, %qt))]), %r, iter(%qt, strcat(if(dec(words(%2)), u(.wdivider, capstr(%i0))%r), setq(a, filter(filter.status, %1,,, %0, %i0)), setq(n, sort(edit(%qa, _ASPIRATION.,))), if(words(%qa), iter(%qn, u(format.aspiration.one-line, %i0, %0, %qm, %qw, %qr),, %r), ansi(n, space(add(%qm, 2)), h, Nothing to display.))),, %r), %r, u(.wfooter, if(not(words(%2)), cat(words(u(f.get.aspirations.status, %0, fulfilled)), Fulfilled))))

&format.aspiration.one-line [v(d.asp)]=wrap(strcat(rjust(ansi(h, %i0.), %2), %b, elements(setr(g, get(%1/_aspiration.%i0)), 3, |), %b, ansi(xh, %([elements(%qg, 2, |)]%)), if(t(setr(g, elements(%qg, 4, |))), %rFulfilled: %qg)), %4, left, %b, null(right), inc(%2), %r, %3)

&display.aspiration.details [v(d.asp)]=strcat(setq(a, get(%0/_aspiration.%1)), u(.wheader, Aspiration #%1), %r, case(0, t(%qa), ansi(h, %b No aspiration to display), strcat(%b%b, %(, u(.titlestr, first(%qa, :)), %b-%b, convsecs(rest(first(%qa, |), :)), %b-%b, u(.titlestr, elements(%qa, 2, |)), %), %r%r, wrap(strcat(elements(%qa, 3, |), if(t(setr(b, elements(%qa, 4, |))), %rFulfilled: %qb)), sub(width(%#), 4), left, %b%b))), %r, u(.wfooter))

think Entry complete.
