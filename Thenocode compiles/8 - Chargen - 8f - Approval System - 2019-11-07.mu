/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/8%20-%20Chargen/8f%20-%20Approval%20System.txt

Compiled 2019-11-07

*/

think Entering 49 lines.

&d.approval_types [v(d.cg)]=chargen|guest|approved|storyteller|npc|staff|unapproved|frozen|dead

&ufunc.isapproved [v(d.cg)]=strcat(setq(p, pmatch(%0)), setq(s, grab(|chargen|guest|approved|storyteller|npc|staff|unapproved|frozen|dead|status|log, %1*, |)), case(%qs, null(null), cor(isstaff(%qp), hasflag(%qp, approved), hasflag(%qp, npc), hasflag(%qp, storyteller)), approved, isapproved(%qp), staff, isstaff(%qp), frozen, cand(not(isapproved(%qp)), hasattr(%qp, _approval.frozen)), dead, cand(not(isapproved(%qp)), hasattr(%qp, _approval.dead)), chargen, cor(isstaff(%qp), not(cor(isapproved(%qp), hasflag(%qp, unapproved), haspower(%qp, guest), strmatch(%qp, config(guest_char_num))))), guest, haspower(%qp, guest), log, default(%qp/_approval.log, #-1 no approval log), status, case(1, isapproved(%qp, guest), guest, isapproved(%qp, staff), staff, isapproved(%qp, chargen), chargen, isapproved(%qp, npc), npc, isapproved(%qp, storyteller), storyteller, isapproved(%qp, approved), approved, isapproved(%qp, dead), dead, isapproved(%qp, frozen), frozen, isapproved(%qp, unapproved), unapproved, #-1 unknown approval status :: %qp :: %qs), hasflag(%qp, %qs)))

&c.cg/approve [v(d.cg)]=$^\+?cg/approve(.*)$:@trigger %!/trig.approval.switch=%#, %1, approve, approved, chargen unapproved frozen

@set v(d.cg)/c.cg/approve=regexp

&trig.approval.switch/approve [v(d.cg)]=@set %1=approved !unapproved !frozen;@set %1=_approval.frozen:;

&c.cg/npc [v(d.cg)]=$^\+?cg/npc(.*)$:@trigger %!/trig.approval.switch=%#, %1, npc, NPC, chargen

@set v(d.cg)/c.cg/npc=regexp

&trig.approval.switch/npc [v(d.cg)]=@set %1=npc !unapproved !frozen;@set %1=_approval.frozen:;

&c.cg/storyteller [v(d.cg)]=$^\+?cg/storyteller(.*)$:@trigger %!/trig.approval.switch=%#, %1, storyteller, storyteller, chargen

@set v(d.cg)/c.cg/storyteller=regexp

&c.cg/st [v(d.cg)]=$^\+?cg/st(.*)$:@trigger %!/trig.approval.switch=%#, %1, storyteller, storyteller, chargen

@set v(d.cg)/c.cg/st=regexp

&trig.approval.switch/storyteller [v(d.cg)]=@set %1=storyteller !unapproved !frozen;@set %1=_approval.frozen:;

&c.cg/unapprove [v(d.cg)]=$^\+?cg/unapprove(.*)$:@trigger %!/trig.approval.switch=%#, %1, unapprove, unapproved, approved NPC storyteller

@set v(d.cg)/c.cg/unapprove=regexp

&trig.approval.switch/unapprove [v(d.cg)]=@set %1=unapproved !approved !npc !storyteller;

&c.cg/chargen [v(d.cg)]=$^\+?cg/chargen(.*)$:@assert hasflag(%#, wizard)={@pemit %#=u(.msg, cg/chargen, Wizards only)};@trigger %!/trig.approval.switch=%#, %1, chargen, chargen, approved NPC storyteller frozen

@set v(d.cg)/c.cg/chargen=regexp

&trig.approval.switch/chargen [v(d.cg)]=@set %1=!approved !unapproved !npc !storyteller;@set %1=_approval.frozen:;

&c.cg/freeze [v(d.cg)]=$^\+?cg/freeze(.*)$:@trigger %!/trig.approval.switch=%#, %1, freeze, frozen, approved unapproved NPC storyteller

@set v(d.cg)/c.cg/freeze=regexp

&trig.approval.switch/freeze [v(d.cg)]=@set %1=unapproved !approved !npc !storyteller;@set %1=_approval.frozen:%2;@name %1=[name(%1)]_[rest(num(%1), #)];@alias %1;

&c.cg/kill [v(d.cg)]=$^\+?cg/kill(/YES)?(.*)$:@assert not(comp(%1, /YES))={@pemit %#=u(.msg, cg/kill, If you really want to do this%, type: cg/kill/YES %2)};@trigger %!/trig.approval.switch=%#, %2, kill, dead, approved unapproved frozen

@set v(d.cg)/c.cg/kill=regexp

&trig.approval.switch/kill [v(d.cg)]=@set %1=unapproved !approved !npc !storyteller;@set %1=_approval.frozen:;@set %1=_approval.dead:%2;@pemit %0=u(.msg, cg/kill, Oh my god! You killed [moniker(%1)]!)

&c.cg/log [v(d.cg)]=$^\+?cg/log(\s?.*)$:think strcat(q1:%b, setr(1, trim(%1)), %r, qp:%b, setr(p, if(strlen(%q1), pmatch(%q1), %#)), %r, ql:%b, setr(l, revwords(isapproved(%qp, log), |)), %r,);@assert t(%qp)={@pemit %#=u(.msg, cg/log, Character not found.)};@assert cor(strmatch(%#, %qp), isstaff(%#))={@pemit %#=u(.msg, cg/log, You can only look at your own approval log.)};@assert t(%ql)={@pemit %#=u(.msg, cg/log, No approval log to list.)};@pemit %#=u(display.approval.log, %#, %qp, %ql)

@set v(d.cg)/c.cg/log=regexp

&c.cg/status [v(d.cg)]=$^\+?cg/status(\s?.*)$:think strcat(q1:%b, setr(1, trim(%1)), %r, qp:%b, setr(p, if(strlen(%q1), pmatch(%q1), %#)), %r, qs:%b, setr(s, isapproved(%qp, status)), %r,);@assert t(%qp)={@pemit %#=u(.msg, cg/status, Character not found.)};@assert cor(strmatch(%#, %qp), isstaff(%#))={@pemit %#=u(.msg, cg/status, You can only look at your own status.)};@pemit %#=u(.msg, cg/status, cat(if(strmatch(%#, %qp), Your, [moniker(%qp)]'s), approval status is:, if(t(%qs), titlestr(edit(%qs, _, %b)), Error %(%qs%))));

@set v(d.cg)/c.cg/status=regexp

&trig.approval.switch [v(d.cg)]=think strcat(q1:%b, setr(1, trim(%1)), %r, qp:%b, setr(p, pmatch(before(%q1, =))), %r, qc:%b, setr(c, strip(trim(rest(%q1, =)), :)), %r, qa:%b, setr(a, isapproved(%qp, status)), %r,);@assert cor(isstaff(%0), u(f.approval.not-self, %0, %q1))={@pemit %0=u(.msg, cg/%2, You can't %2 yourself. Nice try.)};@assert isstaff(%0)={@pemit %0=u(.msg, cg/%2, Staff only.)};@assert %qp={@pemit %0=u(.msg, cg/%2, Character not found.)};@assert strlen(%qc)={@pemit %0=u(.msg, cg/%2, Please include comment.)};@assert t(grab(%4, %qa))={@pemit %0=u(.msg, cg/%2, u(display.approve.change.error, %4, %qa))};think setr(r, u(f.approval.log.add, %0, %qp, %3, u(format.approve.log-add.comment, %qa, %3, %qc)));@pemit %0=u(.msg, cg/%2, u(display.approval.change, %qp, %qa, %3, %qc));@trig %!/trig.approval.switch/%2=%0, %qp, %qr;

&.msg [v(d.cg)]=ansi(h, <%0>, n, %b%1)

&.plural [v(d.cg)]=cat(%0, if(eq(%0, 1), %1, %2))

&f.approval.not-self [v(d.cg)]=cor(strlen(%1), not(strmatch(pmatch(%1), %0)), not(strmatch(%1, me)))

&f.approval.log.add [v(d.cg)]=localize(strcat(set(%1, _approval.log:[trim([get(%1/_approval.log)]|[setr(x, u(format.approval.log-item, %0, %1, %2, %3))], l, |)]), %qx))

&f.total_secs_approved [v(d.cg)]=localize(strcat(setq(a, get(%0/_approval.log)), setq(l, iter(%qa, elements(%i0, 2, :), |)), setq(l, if(t(%qa), cat(%ql, secs()))), setq(a, matchall(%qa, approved:*, |)), ladd(iter(%qa, sub(elements(%ql, inc(%i0)), elements(%ql, %i0))))))

&display.approve.change.error [v(d.cg)]=Character must be [itemize(%0,, or)]. Character is [lcstr(%1)].

&display.approval.change [v(d.cg)]=strcat(moniker(%0), %b, status changed from '%1' to '%2', if(strlen(%3), %bwith comment '%3',))

&format.approve.log-add.comment [v(d.cg)]=strcat('%0' -> '%1', if(%2, %, %2))

&format.approval.log-item [v(d.cg)]=%2:[secs()]:[moniker(%0)]:%0:%3

&display.approval.log [v(d.cg)]=localize(strcat(setq(a, lmax(iter(%2, strlen(elements(%i0, 1, :)), |))), setq(t, lmax(iter(%2, strlen(u(format.approval.timestamp, elements(%i0, 2, :))), |))), setq(s, lmax(iter(%2, add(strlen(elements(%i0, 3, :)), strlen(elements(%i0, 4, :)), 3,), |))), wheader(Approval Log for [moniker(%1)]), %r, iter(%2, wrap(u(format.approval.log.line, %i0, %qa, %qt, %qs, *), width(%0), null(just), null(lefttext), null(righttext), add(%qa, %qt, %qs, 9)), |, %r), %r, wfooter(u(.plural, words(%2, |), entry, entries))))

&format.approval.log.line [v(d.cg)]=cat(ljust(titlestr(edit(elements(%0, 1, :), _, %b)), %1), %b, ljust(u(format.approval.timestamp, elements(%0, 2, :)), %2), %b, ljust([elements(%0, 3, :)] %([elements(%0, 4, :)]%), %3), %b, trim(rest(elements(%0, 5, :), %,)))

&format.approval.timestamp [v(d.cg)]=timefmt($H:$M $d.$m.$y, %0)

@fo me=&d.jrs me=[search(name=Jobs Request System <jrs>)]

&d.content.cg/submit [v(d.jrs)]=Hello! This job is generated by 'cg/submit', asking staff to approve your character for role-play. They will be doing four things: %r%r%b %b 1) Checking your stats : cg/check [name(%#)] %r%b %b 2) Approving your Aspirations : %r%b%b %b %b - asp/list [name(%#)] %r%b%b %b %b - asp/approve [name(%#)]/<number> %r%b %b 3) Checking for your Breaking Points : +notes [name(%#)] %r%b %b 4) Reading your backgrounds : bgcheckall [name(%#)] %r%rIf they think everything is okay, they will 'cg/approve' you and complete this job.%r%rKeep an eye on '+myjobs' and your '@mail' to see if they have any questions or issues that need resolving.%r%r-- %r%rStaff must ALWAYS use 'cg/check' before 'cg/approve'.

&c.cg/submit [v(d.jrs)]=$^\+?cg/submit:@assert isapproved(%#, chargen)={@pemit %#=u(.msg, cg/submit, You can only ask to be approved when you're in chargen.)};@trigger %!/trig.command.request=/cgsubmit [moniker(%#)]=[u(d.content.cg/submit, %#)], %#;

@set v(d.jrs)/c.cg/submit=regexp

&d.cgsubmit.bucket [v(d.jrs)]=APPS

&d.cgsubmit.assign [v(d.jrs)]=+allstaff

&d.cgsubmit.msg [v(d.jrs)]=&d.cgsubmit.prefix [v(d.jrs)]=CGEN

think Entry complete.
