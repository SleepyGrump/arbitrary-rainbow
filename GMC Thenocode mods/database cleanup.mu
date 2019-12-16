@@ Goal: Get all the merits/rites/etc that were entered with prereqs but where the type tag was forgotten (IE merit.Choirster has prerequisite.Choirster rather than prereqisite.merit.Choirster) and move them to the correct location.

@@ The above was my fault, I accidentally entered a bunch of bad data. Whee!

&va me=a b c d e f g h i j k l m n o p q r s t u v w x y z

&f.get-type me=first(setdiff(lattr(v(d.dd)/*.%0), PREREQUISITE.%0 PREREQ-TEXT.%0), .)

@@ This is because sometimes we have a real damn big list so we want to search based on the first *two* letters rather than just the first letter.

&tr.alphabet-search me=@dolist %vA={@trigger/quiet me/tr.alphabet-search-2=%0##,%1,%2;}

&tr.alphabet-search-2 me=@dolist %vA={@trigger/quiet me/tr.alphabet-search-3=%0##,%1,%2;}

&tr.alphabet-search-3 me=@dolist %vA={@trigger/quiet me/tr.find-prereqs=%0##,%1,%2;}

&tr.merit-search me=@dolist %vA={@trigger/quiet me/tr.alphabet-search-3=merit.%0##,%1,%2;}

@@ This attribute will actually move stuff.

&tr.find-prereqs me=@switch/first t(lattr(%2/%1.%0*))=1, { @dolist lattr(%2/%1.%0*)={ @switch/first not(strmatch(##, *.*.*))=1, { @mvattr %2=##, %1.[u(f.get-type, setr(P, last(##, .)))].%qP; }; }; }

@@ The "tell me what we're doing first" version. Replace it with the one above when you're ready.

&tr.find-prereqs me=@switch/first t(lattr(%2/%1.%0*))=1, { @dolist lattr(%2/%1.%0*)={ @switch/first not(strmatch(##, *.*.*))=1, { @pemit %#=@mvattr %2=##, %1.[u(f.get-type, setr(P, last(##, .)))].%qP; }; }; };

@@ The meaty stuff.

&tr.check-prerequisite me=@dolist %0={@trigger/quiet me/tr.alphabet-search=##,PREREQUISITE,[v(d.dd)];}

&tr.check-prereq-text me=@dolist %0={@trigger/quiet me/tr.alphabet-search=##,PREREQ-TEXT,[v(d.dd)];}

&tr.check-tags me=@dolist %0={@trigger/quiet me/tr.alphabet-search=##,TAGS,[v(d.dt)];}

&tr.merit-check-prerequisite me=@dolist %0={@trigger/quiet me/tr.merit-search=##,PREREQUISITE,[v(d.dd)];}

&tr.merit-check-prereq-text me=@dolist %0={@trigger/quiet me/tr.merit-search=##,PREREQ-TEXT,[v(d.dd)];}

&tr.merit-check-tags me=@dolist %0={@trigger/quiet me/tr.merit-search=##,TAGS,[v(d.dt)];}

&cmd-checkdb me=$+checkdb *:@trigger me/tr.check-%0=%vA;
&cmd-checkdb-merit me=$+checkdb/merit *:@trigger me/tr.merit-check-%0=%vA;

@@ This is necessary to prevent yourself from getting halted for nesting too many things:

@queuemax me=100000

@@ If you do get halted, @set me=!halt and up your queuemax.

@@ Actually running the tests. No results is good!

+checkdb PREREQ-TEXT
+checkdb PREREQUISITE
+checkdb TAGS

+checkdb/merit PREREQ-TEXT
+checkdb/merit PREREQUISITE
+checkdb/merit TAGS

@@ TODO: find unlinked tags/prereqs etc.

@@ TODO: find bad prereqs.

