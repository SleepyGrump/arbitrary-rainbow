think Entering 3 lines.

&cmd-view #6 =$+view:@pemit %#=[switch(words(lattr(loc(%#)/view-*)), 0, There are no views set on your location., The following views are set on your location:%R[iter(lattr(loc(%#)/view-*), %b%b[edit(capstr(lcstr(after(##, VIEW-))), ~, %b)])])][setq(0, iter(lcon(loc(%#)), switch([gte(words(lattr(##/view-*)), 1)]:[strmatch(type(##), PLAYER)][not(hasflag(##, connected))], 1:10, ##, 1:0?, ##)))][switch(words(%q0), 0,, %RThe following objects have views set on them:%R[iter(%q0, %b%b[name(##)])])]

&CMD-VIEW-ITEM #6=$+view *:@swi/first [pos(/, %0)]:[setq(0, locate(%#, before(%0, /), *))]%q0=#-1:#-?, {@pemit %#=I can't find that here!}, #-1:*, {@pemit %#=[switch(words(lattr(%q0/view-*)), 0, There are no views set on that item., The following views are set on that item:%R[iter(lattrp(%q0/view-*), %b%b[titlestr(edit(lcstr(after(##, VIEW-)), ~, %b, _, %b))])])]}, {@pemit %#=ulocal(layout.view, %q0, first(lattrp(%q0/view-[edit(after(%0, /), %b, _)]*)));}

&layout.view #6=if(hasattrp(%0, %1), if(t(match(xget(%0, %1), *wheader*)), u(%0/%1), strcat(wheader(titlestr(edit(ucstr(%1), VIEW-,, ~, %b, _, %b))), %r, wrap(strcat(u(%0/%1)), 74, Left, space(3), space(3)), %r%r, wfooter())), There is no such view on that item (%0/%1).)

think Entry complete.
