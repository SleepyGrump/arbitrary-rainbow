@dig/teleport Room Parent

@force me=&d.rp me=[num(here)]

@set [v(d.rp)]=FLOATING HALTED LINK_OK NO_COMMAND OPAQUE

@dig/teleport OOCR Parent

@force me=&d.orp me=[num(here)]

@set [v(d.orp)]=HALTED

@ExitFormat [v(d.orp)]=if(t(words(%0)), strcat(%r, wheader(Exits, %#), %r, fitcolumns(iter(%0, name(##),, |), |, %#, 3), %r, wfooter(, %#)), wfooter(No exits., %#))

@parent [v(d.orp)]=[v(d.rp)]

@Desc [v(d.rp)]=%r%tThis is the basic room desc.%r

@DescFormat [v(d.rp)]=strcat(boxtext(%0,,, %#, 3), %r, if(t(lattr(%!/view-*)), strcat(%r, wheader(+views - +view here/<name> to view, %#), %r, fitcolumns(iter(lattr(%!/view-*), titlestr(edit(rest(itext(0), -), _, %b, ~, %b)),, |), |, %#, 3))))

&f.people-and-objects-count [v(d.rp)]=if(or(t(%0), t(%1)), strcat(if(t(%0), strcat(%0, %b, case(%0, 1, person, people))), if(and(t(%0), t(%1)), %band%b), if(t(%1), strcat(%1, %b, case(%1, 1, object, objects))), %b, present), There is no one present.)

&f.list-people [v(d.rp)]=strcat(setq(0, sub(width(%1), 33)), iter(%0, strcat(space(3), ljust(mid(ansi(case(1, istemp(itext(0)), uh, and(not(isstaff(itext(0))), strmatch(type(##), PLAYER)), h), moniker(itext(0))), 0, 20), 21), %b, rjust(elements(secs2hrs(idle(##)), 1), 3), space(2), mid(short-desc(##), 0, if(gt(strlen(short-desc(itext(0))), %q0), sub(%q0, 3), %q0)), if(gt(strlen(short-desc(itext(0))), %q0), ...)),, %R))

&f.list-objects [v(d.rp)]=strcat(setq(0, sub(width(%1), 6)), setq(1, getlongest(iter(%0, moniker(itext(0)),, |), |)), setq(1, add(%q1, if(isstaff(%1), 8, 1))), setq(2, getlongest(iter(%0, short-desc(itext(0)),, |), |)), if(gt(add(%q1, %q2, 2), %q0), strcat(setq(1, div(sub(%q0, 2), 2)), setq(2, sub(%q1, mod(sub(%q0, 2), 2))))), iter(%0, strcat(space(3), ljust(mid(strcat(if(isstaff(%#), ljust(itext(0), 7)), moniker(itext(0))), 0, sub(%q1, 1)), %q1), %b, mid(short-desc(itext(0)), 0, if(gt(strlen(short-desc(itext(0))), %q2), sub(%q2, 3), %q2)), if(gt(strlen(short-desc(##)), %q2), ...)),, %R))

&FILTER-ISOBJECT [v(d.rp)]=strmatch(type(%0), THING)

@ConFormat [v(d.rp)]=if(and(not(isstaff(%#)), hasflag(me, BLIND)), null(This is the quiet room.), strcat(setq(P, if(isstaff(%#), lcon(me, CONNECT), cansee(lcon(me, CONNECT)))), setq(0, words(%qP)), setq(1, words(setr(O, filter(filter-isobject, lcon(me))))), wfooter(ulocal(f.people-and-objects-count, %q0, %q1), %#), if(t(%q0), strcat(%r, ulocal(f.list-people, %qP, %#))), if(t(%q1), strcat(%r, ulocal(f.list-objects, %qO, %#)))))

&f.get-cardinal-directions [v(d.rp)]=iter(%0, if(hasflag(##, uninspected), ##, null(Not a cardinal direction.)))

&f.get-compass-parts [v(d.rp)]=strcat(if(strmatch(%0, *<N>*), N, |), ., if(strmatch(%0, *<S>*), S, |), ., if(strmatch(%0, *<E>*), E, -), ., if(strmatch(%0, *<W>*), %bW, %b-), ., if(strmatch(%0, *<NW>*), NW, %b%b), ., if(strmatch(%0, *<NE>*), NE, %b), ., if(strmatch(%0, *<SW>*), SW, %b%b), ., if(strmatch(%0, *<SE>*), SE, %b))

@ExitFormat [v(d.rp)]=strcat(setq(0, iter(setr(9, ulocal(f.get-cardinal-directions, %0)), name(##),, |)), setq(2, sub(setr(3, sub(width(%#), 6)), 8)), if(t(%q0), strcat(%R, wheader(City exits, %#), %R, setq(1, ulocal(f.get-compass-parts, %q0)), space(3), ljust(mid(extract(%q0, 1, 1, |), 0, %q2), %q2), %b, extract(%q1, 5, 1, .), %b, extract(%q1, 1, 1, .), %b, extract(%q1, 6, 1, .), %R, space(3), ljust(mid(extract(%q0, 2, 1, |), 0, %q2), %q2), %b, extract(%q1, 4, 1, .), %b+%b, extract(%q1, 3, 1, .), %R, space(3), ljust(mid(extract(%q0, 3, 1, |), 0, %q2), %q2), %b, extract(%q1, 7, 1, .), %b, extract(%q1, 2, 1, .), %b, extract(%q1, 8, 1, .), %R, fitcolumns(extract(%q0, 4, words(%q0, |), |), |, %#, 3))), if(t(setdiff(%0, %q9)), strcat(%r, wfooter(Local exits, %#), %r, fitcolumns(iter(iter(%0, if(not(hasflag(##, uninspected)), ##, null(Not a business exit.))), name(##),, |), |, %#, 3), %r, wfooter(, %#)), if(and(not(t(%q0)), not(t(%0))), wfooter(No exits., %#), wfooter(, %#))))

@NameFormat [v(d.rp)]=wheader(strcat(name(me), if(isstaff(%#), %b([num(me)]))), %#)

