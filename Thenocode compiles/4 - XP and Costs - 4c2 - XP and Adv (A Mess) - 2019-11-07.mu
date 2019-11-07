/*

https://raw.githubusercontent.com/thenomain/GMCCG/master/4%20-%20XP%20and%20Costs/4c2%20-%20XP%20and%20Adv%20(A%20Mess).txt.txt

Compiled 2019-11-07

*/

think Entering 5 lines.

&f.last-purchase xpas=u(f.time.sql2unix, sql(u(sql.select.last-touched, %0, %1)))

&f.time-until-next-purchase xpas=min(0,)

&timer.? xpcd=sub(2419200, u(f.last-purchase, %0, %1))

&timer.merit.status_() xpcd=max(sub(2419200, u(f.last-purchase, %0, %1)), sub(2419200, u(v(d.cg)/f.total_secs_approved, %0)))

&timer.merit.mystery_cult_initiation_() xpcd=max(sub(2419200, u(f.last-purchase, %0, %1)), sub(2419200, u(v(d.cg)/f.total_secs_approved, %0)))

think Entry complete.
