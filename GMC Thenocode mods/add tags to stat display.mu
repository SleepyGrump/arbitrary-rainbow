/*

I decided it was useful to show the tags of a stat:

 .oO( Hostile Takeover [Contract] )Oo........................................o.

  Values: 1
  Details: Beast and Fairest

  Templates: Changeling

> Tags: changeling, crown, beast, fairest, and common <<< Here.
 .o..........................................................................o.

*/

&display.stat.values.display.one [v(d.ss)]=strcat(wheader([edit(%qn, %(%), %(<type>%))] %[[ulocal([u(d.stat-funcs)]/f.statname.workhorse, first(%qp, .))]%]), %r, setq(x, u([u(d.stat-funcs)]/f.hastag?.workhorse, %qp, derived)), setq(t, ulocal([u(d.data-tags)]/tags.%qp)), %b, %b, ansi(h, Values), :, %b, if(t(%qx), Derived Function, u(display.stat-valuelist, first(%qs, |))), if(cand(hasattr(u(d.data-dictionary), default.%qp), not(%qx)), strcat(%r, %b, %b, ansi(h, Default), :, %b, get([u(d.data-dictionary)]/default.%qp),)), case(words(%qs, |), 3, strcat(%r, %b, %b, ansi(h, Type), :, %b, u(display.stat-valuelist, elements(%qs, 2, |), or), %r, %b, %b, ansi(h, Details), :, %b, u(display.stat-valuelist, last(%qs, |))), 2, if(strmatch(%qp, *%(%)), strcat(%r, %b, %b, ansi(h, Type), :, %b, u(display.stat-valuelist, rest(%qs, |), or)), strcat(%r, %b, %b, ansi(h, Details), :, %b, u(display.stat-valuelist, rest(%qs, |))))), setq(r, ulocal(display.stat-prereqlist, %qp)), setq(n, ulocal([u(d.data-tags)]/notes.%qp)), if(cor(t(trim(%qr, b, |)), t(%qn)), %r), if(t(setr(x, first(%qr, |))), wrap(strcat(%r, ansi(h, Templates), :, %b, itemize(%qx, ., or)), sub(width(%#), 2), left, %b%b)), if(t(setr(x, elements(%qr, 2, |))), wrap(strcat(%r, ansi(h, Chargen), :, %b, itemize(%qx, .)), sub(width(%#), 2), left, %b%b)), if(t(setr(x, last(%qr, |))), wrap(strcat(%r, ansi(h, Prerequisites), :, %b, %qx), sub(width(%#), 2), left, %b%b)), if(cand(t(trim(%qr, b, |)), t(%qn)), %r), if(t(%qn), ansi(n, %b%b, h, Notes, n, :%r, n, iter(%qn, wrap(* %i0, sub(width(%#), 4), left, %b%b%b%b,, 2), |, %r))), if(t(%qt), ansi(n, %R%R%b%b, h, Tags, n, :%b, n, itemize(%qt, .))), %r, wfooter(if(u([u(d.stat-funcs)]/f.hastag?.workhorse, %qp, Chargen-Only), Chargen Only)))

