/*
This requires the SQL Job archiver from Chime and Thenomain, here: https://github.com/thenomain/Mu--Support-Systems/blob/23c703d788e85ba2eb865b94fed69e240e9e9899/SQL%20Job%20Archives.txt

It also requires the following softcode functions:
  wheader()
  wfooter()
  alert()
  isstaff()

Warning: the contents of each job comment will be evaluated for display purposes with +ajob #. This can cause unexpected side effects. However, unless you're approving jobs that contain actual code, you're probably fine.

The help file:

We archive our +jobs to a SQL server. Staff can view/search these jobs with:

:+ajob/search <search term> - find a list of archived jobs containing the search term.
:+ajob <identity> - view an archived job

Search terms need a label, an equals sign, and if you want multiple search terms, separate them by commas:

* PLAYER=<name>
* STARTDATE=<some date in the format YYYY-MM-DD>
* ENDDATE=<some date in the format YYYY-MM-DD>
* TITLE=<text>
* TEXT=<text> - this is the default, so if you don't include "<term>=" at the front of it, the code will assume you just want to search the text.

So for example: +ajob/search PLAYER=Lysander,TITLE=Pitch - would return all of Lysander's pitches.

*/

&sql.search_jobs sja=SELECT DISTINCT S.archive_id, title, bucket, opened_by FROM aj6_archive_summary S LEFT OUTER JOIN aj6_archive_comment C ON S.archive_id=C.archive_id WHERE %0 LIMIT 0, 25

&sql.search_count sja=SELECT COUNT(DISTINCT S.archive_id) FROM aj6_archive_summary S LEFT OUTER JOIN aj6_archive_comment C ON S.archive_id=C.archive_id WHERE %0

@@ All parameters are optional
@@ %0 - player
@@ %1 - start date
@@ %2 - end date
@@ %3 - title
@@ %4 - text
&sql.search_where sja=strcat(1=1, if(t(%0), %bAND (S.opened_by LIKE '%0\\\\\\\%' OR S.assigned_to LIKE '%0\\\\\\\%' OR S.tagged_for LIKE '%0\\\\\\\%' OR C.by_whom LIKE '%0\\\\\\\%')), if(cand(t(%1), t(%2)), %bAND C.post_time BETWEEN '%1' AND '%2', if(t(%1), %bAND C.post_time >= '%1', if(t(%2), %bAND C.post_time <= '%2'))), if(t(%3), %bAND S.title LIKE '\\\\\\\%%3\\\\\\\%'), if(t(%4), %bAND C.txt LIKE '\\\\\\\%%4\\\\\\\%'))

&sql.get_archived_job sja=SELECT * FROM aj6_archive_summary S LEFT OUTER JOIN aj6_archive_comment C ON S.archive_id=C.archive_id WHERE S.archive_id=%0 ORDER BY C.post_time ASC

@@ %0 - the search call
@@ %1 - the term to pick out
&f.get-search-term sja=if(strmatch(%0, *%1=*), edit(extract(ucstr(%0), match(ucstr(%0), *%1=*, %,), 1, %,), %1=,), case(%1, TEXT, iter(%0, if(not(strmatch(itext(0), *=*)), itext(%0)), %,, @@)))

@@ %0 - the viewer
@@ %1 - the search
@@ %2 - the SQL results
@@ %3 - the number of results
@@ %4 - the query
&layout.search_results sja=if(t(%2), strcat(wheader(Jobs search, %0), %r, space(3), Search terms: %1, %r, iter(%2, u(layout.search_line, itext(0)), |, %r), %r%r, space(3), The total number of results (max 25 but there may be more): %3, %r%r, space(3), The query: %4, %r, wfooter(+ajob <ID> for more information., %0)))

&layout.search_line sja=strcat(space(3), rjust(extract(%0, 1, 1, ~), 5, ), ., %b, extract(%0, 3, 1, ~), %b-%b, extract(%0, 2, 1, ~) by, %b, extract(%0, 4, 1, ~))

@@ %0 - the viewer
@@ %1 - the SQL results
&layout.ajob_header sja=strcat(space(3), ljust(Bucket:, 15), extract(%1, 3, 1, ~), %r, space(3), ljust(Title:, 15), extract(%1, 2, 1, ~), %r, space(3), ljust(Opened on:, 15), extract(%1, 13, 1, ~), %r, space(3), ljust(Opened by:, 15), extract(%1, 6, 1, ~), %r, space(3), ljust(Assigned to:, 15), extract(%1, 7, 1, ~), %r, space(3), ljust(Status:, 15), Archived, %r)

@@ %0 - the viewer
@@ %1 - the result row
&layout.ajob_comment sja=if(t(edit(extract(%1, 8, 999, ~), ~, )), strcat(wheader(extract(%1, 13, 1, ~), %0), %r, space(3), case(extract(%1, 12, 1, ~), ADD, Added, MAI, Mailed, CRE, Created, TRN, Moved, ASN, Assigned, DUE, Due date changed, COM, Commented, APR, Approved, DNY, Denied, SRC, Source changed, ESC, Priority changed), %b, by, %b, extract(%1, 14, 1, ~):, %b, eval(edit(extract(%1, 15, 1, ~), \\\\\\%, %%))))

@@ %0 - the viewer
@@ %1 - the SQL results
&layout.ajob sja=if(t(%1), strcat(wheader(Archived Job #[extract(%1, 1, 1, ~)], %0), %r, u(layout.ajob_header, %0, %1), iter(%1, u(layout.ajob_comment, %0, itext(0)), |, %r), %r, wfooter(, %0)))

&cmd-+ajob/search sja=$+ajob/search *:@assert isstaff(%#)={@pemit %#=alert(JOBS) You must be staff to use this command.}; @assert t(setr(Q, u(sql.search_jobs, setr(W, u(sql.search_where, u(f.get-search-term, %0, PLAYER), u(f.get-search-term, %0, STARTDATE), u(f.get-search-term, %0, ENDDATE), u(f.get-search-term, %0, TITLE), u(f.get-search-term, %0, TEXT))))))={@pemit %#=alert(JOBS) Something went wrong setting up the query.}; @switch t(setr(R, u(layout.search_results, %#, %0, sql(%qQ, |, ~), sql(u(sql.search_count, %qW)), %qQ)))=1, { @pemit %#=%qR; }, { @pemit %#=strcat(alert(JOBS), %b, if(eq(strlen(%qR), 0), No results found., Error in query - did you do dates in YYYY-MM-DD format?), %b, Query was: %qQ, %r%r, Raw output was:, %b, %qR); };

&cmd-+ajob sja=$+ajob *:@assert isstaff(%#)={@pemit %#=alert(JOBS) You must be staff to use this command.}; @switch t(setr(R, u(layout.ajob, %#, sql(u(sql.get_archived_job, %0), |, ~), %qQ)))=1, { @pemit %#=%qR; }, { @pemit %#=strcat(alert(JOBS), %b, if(eq(strlen(%qR), 0), Job '%0' was not found., Error in query - did you give an exact numeric job ID? Job '%0' was not found.)); };
