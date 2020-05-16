think Entering 54 lines.

@create Data Storage Functions <DSF>=10

@set DSF=safe inherit

@force me=&vS DSF=and(t(sql(SELECT 1)), eq(strlen(sql(SELECT 1)), 1))

&VL me=MYSQL_LOGIN_NAME_HERE;

&vD DSF=YOUR_DATABASE_HERE;

&vK me=0

&d.max-attributes DSF=2500

&d.max-name-length DSF=60

&d.max-value-length DSF=7900

&d.permitted-name-characters DSF=-_.@#$^&~?='+/%bABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789

@force me=@startup DSF=@trigger me/tr.makefunctions=[num(DSF)];

&TR.MAKEFUNCTIONS DSF=@dolist lattr(%0/f.global.*)=@function rest(rest(##, .), .)=%0/##; @dolist lattr(%0/f.globalp.*)=@function/preserve rest(rest(##, .), .)=%0/##; @dolist lattr(%0/f.globalpp.*)=@function/preserve/privilege rest(rest(##, .), .)=%0/##;

@switch xget(DSF, vS)=1, {@switch %vL=MYSQL_LOGIN_NAME_HERE, {th %ch%cr--------------------------------------------------------------------------------;th %ch%cr ERROR! - Your MySQL login name is not set! Stop this setup RIGHT NOW! - ERROR!;th %ch%cr--------------------------------------------------------------------------------;};@switch xget(DSF, vD)=YOUR_DATABASE_HERE, {th %ch%cr--------------------------------------------------------------------------------;th %ch%crERROR! - - Your MySQL database is not set! Stop this setup RIGHT NOW! - - ERROR!;th %ch%cr--------------------------------------------------------------------------------;};@switch %vK=1, {@fo me=&d.mushcron me=[search(name=CRON - Myrddin's mushcron)];@switch not(hasattr(d.mushcron))=1, {th %ch%cr--------------------------------------------------------------------------------;th %ch%crERROR! - You don't have Myrddin's MUSHcron! Stop this setup RIGHT NOW! - ERROR!;th %ch%cr--------------------------------------------------------------------------------;};&cron_time_checksql [v(d.mushcron)]=||||00 02 04 06 08 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58|;&cron_job_checksql [v(d.mushcron)]=@if not(t(sql(SELECT 1)))={@cemit Staff=%ch%crSQL is down - [rserror()] - @restart now!;};};@force me=&sql me=CREATE TABLE IF NOT EXISTS tblDataValues (DBref varchar(10) NOT NULL, Name varchar([xget(DSF, d.max-name-length)]) NOT NULL, Value varchar([xget(DSF, d.max-value-length)]), PRIMARY KEY (DBref, Name)) ENGINE=InnoDB;@wait 1=th sql(v(sql));@wait 2=@force me=&sql me=CREATE TABLE IF NOT EXISTS tblKeyValues (DBref varchar(10) NOT NULL, DataName varchar([xget(DSF, d.max-name-length)]) NOT NULL, Name varchar([xget(DSF, d.max-name-length)]) NOT NULL, Value varchar([xget(DSF, d.max-value-length)]), PRIMARY KEY (DBref, DataName, Name), CONSTRAINT ufk_DBref_DataName FOREIGN KEY (DBref, DataName) REFERENCES tblDataValues(DBref, Name) ON DELETE CASCADE) ENGINE=InnoDB;@wait 3=th sql(v(sql));@wait 4=@force me=&sql me=CREATE UNIQUE INDEX uix_dataNames ON tblDataValues (DBref, Name);@wait 5=th sql(v(sql));@wait 6=@force me=&sql me=CREATE UNIQUE INDEX uix_keyNames ON tblKeyValues (DBref, DataName, Name);@wait 7=th sql(v(sql));@wait 8=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_GetDataValue`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) SELECT Value FROM tblDataValues WHERE DBref =up_DBref AND Name =up_Name%%;@wait 9=th sql(v(sql));@wait 10=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_GetKeyValue`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) SELECT Value FROM tblKeyValues WHERE DBref =up_DBref AND DataName =up_DataName AND Name =up_Name%%;@wait 11=th sql(v(sql));@wait 12=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_GetDataName`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) SELECT Name FROM tblDataValues WHERE DBref =up_DBref AND Name =up_Name%%;@wait 13=th sql(v(sql));@wait 14=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_GetKeyName`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) SELECT Name FROM tblKeyValues WHERE DBref =up_DBref AND DataName =up_DataName AND Name =up_Name%%;@wait 15=th sql(v(sql));@wait 16=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_ListData`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Key` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Value` VARCHAR([xget(DSF, d.max-value-length)]), IN `up_KeyValue` VARCHAR([xget(DSF, d.max-value-length)]), IN `up_Format` BIT(1)) SELECT DISTINCT CASE WHEN up_Format =1 THEN CONCAT(D.Name, '/', K.Name) ELSE D.Name END AS Name FROM tblDataValues D LEFT OUTER JOIN tblKeyValues K ON D.DBref=K.DBref AND D.Name=K.DataName WHERE D.DBref =up_DBref AND (up_Name ='' OR D.Name LIKE CONCAT(up_Name, '\%\%\%\%')) AND (up_Key ='' OR K.Name LIKE CONCAT(up_Key, '\%\%\%\%')) AND (up_Value ='' OR D.Value LIKE CONCAT('\%\%\%\%', up_Value, '\%\%\%\%')) AND (up_KeyValue ='' OR K.Value LIKE CONCAT('\%\%\%\%', up_KeyValue, '\%\%\%\%')) %%;@wait 17=th sql(v(sql));@wait 18=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_SetDataValue`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Value` VARCHAR([xget(DSF, d.max-value-length)])) INSERT INTO tblDataValues (`DBref`, `Name`, `Value`) VALUES(up_DBref, up_Name, up_Value) ON DUPLICATE KEY UPDATE `Value` =up_Value%%;@wait 19=th sql(v(sql));@wait 20=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_SetKeyValue`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Value` VARCHAR([xget(DSF, d.max-value-length)])) INSERT INTO tblKeyValues (`DBref`, `DataName`, `Name`, `Value`) VALUES(up_DBref, up_DataName, up_Name, up_Value) ON DUPLICATE KEY UPDATE `Value` =up_Value%%;@wait 21=th sql(v(sql));@wait 22=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_SetDataName`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_NewName` VARCHAR([xget(DSF, d.max-value-length)])) UPDATE tblDataValues SET `Name`=`up_NewName` WHERE `Name` =up_Name AND `DBref`=up_DBref%%;@wait 23=th sql(v(sql));@wait 24=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_SetKeyName`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_NewName` VARCHAR([xget(DSF, d.max-value-length)])) UPDATE tblKeyValues SET `Name`=`up_NewName` WHERE `Name` =up_Name AND `DataName` =up_DataName AND `DBref`=up_DBref%%;@wait 25=th sql(v(sql));@wait 26=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_WipeData`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) DELETE FROM tblDataValues WHERE `Name` =up_Name AND `DBref`=up_DBref%%;@wait 27=th sql(v(sql));@wait 28=@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_WipeKey`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) DELETE FROM tblKeyValues WHERE `Name` =up_Name AND `DBref`=up_DBref AND `DataName` =up_DataName%%;@wait 29=th sql(v(sql));@wait 30=th NOTE: Your game supports SQL. Data will be stored using the SQL method!;}, {th NOTE: Your game does not support SQL. Using the parent method!};

&sql.insert.dataValue DSF=CALL usp_SetDataValue('%0', '[escape(edit(%1, ', &#39;))]', '[escape(edit(%2, ', &#39;))]');

&sql.insert.keyValue DSF=CALL usp_SetKeyValue('%0', '[escape(edit(%1, ', &#39;))]', '[escape(edit(%2, ', &#39;))]', '[escape(edit(%3, ', &#39;))]');

&sql.update.dataName DSF=CALL usp_SetDataName('%0', '[escape(edit(%1, ', &#39;))]', '[escape(edit(%2, ', &#39;))]');

&sql.update.keyName DSF=CALL usp_SetKeyName('%0', '[escape(edit(%1, ', &#39;))]', '[escape(edit(%2, ', &#39;))]', '[escape(edit(%3, ', &#39;))]');

&sql.select.dataValue DSF=SELECT Value FROM tblDataValues WHERE DBref ='%0' AND Name ='[edit(%1, ', &#39;)]';

&sql.select.keyValue DSF=SELECT Value FROM tblKeyValues WHERE DBref ='%0' AND DataName ='[edit(%1, ', &#39;)]' AND Name ='[edit(%2, ', &#39;)]';

&sql.select.dataName DSF=SELECT Name FROM tblDataValues WHERE DBref ='%0' AND Name ='[edit(%1, ', &#39;)]';

&sql.select.keyName DSF=SELECT Name FROM tblKeyValues WHERE DBref ='%0' AND DataName ='[edit(%1, ', &#39;)]' AND Name ='[edit(%2, ', &#39;)]';

&sql.list.data DSF=SELECT DISTINCT CASE WHEN '%5' ='0' THEN D.Name ELSE CONCAT(D.Name, '/', K.Name) END FROM tblDataValues D LEFT OUTER JOIN tblKeyValues K ON D.DBref=K.DBref AND D.Name=K.DataName WHERE D.DBref ='%0' AND ('[edit(%1, ', &#39;)]' ='' OR D.Name LIKE CONCAT('[edit(%1, ', &#39;)]', '\%\%')) AND ('[edit(%2, ', &#39;)]' ='' OR K.Name LIKE CONCAT('[edit(%2, ', &#39;)]', '\%\%')) AND ('[edit(%3, ', &#39;)]' ='' OR D.Value LIKE CONCAT('\%\%', '[edit(%3, ', &#39;)]', '\%\%')) AND ('[edit(%4, ', &#39;)]' ='' OR K.Value LIKE CONCAT('\%\%', '[edit(%4, ', &#39;)]', '\%\%'))

&sql.delete.data DSF=CALL usp_WipeData('%0', '[edit(%1, ', &#39;)]');

&sql.delete.key DSF=CALL usp_WipeKey('%0', '[edit(%1, ', &#39;)]', '[edit(%2, ', &#39;)]');

&l.canset DSF=or(isstaff(%#), and(strmatch(type(%0), THING), hasflag(%0, inherit), isstaff(owner(%0))))

&f.sql-set DSF=strcat(setq(0, if(match(%0, NULL),, %0)), setq(1, if(match(%1, NULL),, %1)), setq(2, if(match(%2, NULL),, %2)), setq(3, if(match(%3, NULL),, %3)), sql(ulocal(sql.insert.[if(t(%3), keyValue, dataValue)], %q0, %q1, %q2, %q3)))

&f.sql-set-name DSF=strcat(setq(0, if(match(%0, NULL),, %0)), setq(1, if(match(%1, NULL),, %1)), setq(2, if(match(%2, NULL),, %2)), setq(3, if(match(%3, NULL),, %3)), sql(ulocal(sql.update.[if(t(%3), keyName, dataName)], %q0, %q1, %q2, %q3)))

&f.parent-set DSF=if(and(t(setr(0, ulocal(f.get-name-index, %0, edit(%1, %b, _)))), isint(%q0)), if(or(t(setr(1, ulocal(f.parent-set-[if(t(%3), key, data)], %0, edit(%1, %b, _), if(t(%3), edit(%2, %b, _), %2), %3, %q0))), eq(strlen(%q1), 0)),, %q1), %q0)

&f.parent-set-name DSF=if(and(t(setr(0, ulocal(f.get-name-index, %0, edit(%1, %b, _)))), isint(%q0)), if(or(t(setr(1, ulocal(f.parent-set-[if(t(%3), key, data)]-name, %0, edit(%1, %b, _), edit(%2, %b, _), edit(%3, %b, _), %q0))), eq(strlen(%q1), 0)),, %q1), %q0)

&f.get-name-index DSF=if(t(hasattrp(%0, _N.%1)), xget(%0, _N.%1), strcat(set(%0, _I:[setr(0, if(hasattr(%0, _I), inc(xget(%0, _I)), 1))]), set(ulocal(f.find-first-free-parent, %0, _N.%1), _N.%1:%q0), set(ulocal(f.find-first-free-parent, %0, _I.%q0), _I.%q0:[edit(%1, _, %b)]), %q0))

&f.get-key-index DSF=if(t(hasattrp(%0, _F.%4.%2)), xget(%0, _F.%4.%2), strcat(set(%0, _K.%4:[setr(0, if(hasattr(%0, _K.%4), inc(xget(%0, _K.%4)), 1))]), set(ulocal(f.find-first-free-parent, %0, _F.%4.%2), _F.%4.%2:%q0), set(ulocal(f.find-first-free-parent, %0, _M.%4.%q0), _M.%4.%q0:[edit(%2, _, %b)]), %q0))

&f.parent-set-data DSF=set(ulocal(f.find-first-free-parent, %0, _V.%4), _V.%4:[if(match(%2, NULL),, %2)])

&f.parent-set-data-name DSF=strcat(set(setr(0, ulocal(f.find-first-free-parent, %0, _N.%1)), _N.%1:), set(%q0, _N.%2:%4), set(ulocal(f.find-first-free-parent, %0, _I.%4), _I.%4:%2))

&f.parent-set-key DSF=if(and(t(setr(0, ulocal(f.get-key-index, %0, %1, %2, %3, %4))), isint(%q0)), if(or(t(setr(1, set(ulocal(f.find-first-free-parent, %0, _J.%4.%q0), _J.%4.%q0:[if(match(%3, NULL),, %3)]))), eq(strlen(%q1), 0)),, %q1), %q0)

&f.parent-set-key-name DSF=if(and(t(setr(0, ulocal(f.get-key-index, %0, %1, %2, %3, %4))), isint(%q0)), if(or(t(setr(1, strcat(set(setr(2, ulocal(f.find-first-free-parent, %0, _F.%4.%2)), _F.%4.%2:), set(%q2, _F.%4.%3:%q0), set(ulocal(f.find-first-free-parent, %0, _M.%4.%q0), _M.%4.%q0:%3)))), eq(strlen(%q1), 0)),, %q1), %q0)

&f.sql-get DSF=edit(sql(iter(ulocal(sql.select.[if(t(%2), keyValue, dataValue)], %0, %1, %2), if(match(itext(0), 'NULL'), '', itext(0)))), &#39;, ')

&f.parent-get DSF=if(t(setr(0, xget(%0, _N.%1))), if(t(%2), xget(%0, _J.%q0.[xget(%0, _F.%q0.%2)]), xget(%0, _V.%q0)))

&f.sql-get-name DSF=edit(sql(iter(ulocal(sql.select.[if(t(%2), keyName, dataName)], %0, %1, %2), if(match(itext(0), 'NULL'), '', itext(0)))), &#39;, ')

&f.parent-get-name DSF=if(t(setr(0, xget(%0, _N.%1))), if(t(%2), xget(%0, _M.%q0.[xget(%0, _F.%q0.%2)]), xget(%0, _I.%q0)), #-1 NOT FOUND)

&f.sql-list DSF=if(t(setr(0, sql(iter(ulocal(sql.list.data, %0, %1, %2, %3, %4, or(t(%2), t(%4))), if(match(itext(0), 'NULL'), '', itext(0))), |, |))), edit(%q0, &#39;, '), #-1 NO RESULTS)

&f.parent-list DSF=strcat(setq(1, edit(%1, %b, _)), setq(2, edit(%2, %b, _)), setq(3, %3), setq(4, %4), if(match(%q1, NULL), setq(1,)), if(match(%q2, NULL), setq(2,)), if(match(%q3, NULL), setq(3,)), if(match(%q4, NULL), setq(4,)), if(hasattrp(%0, _N.%q1), setq(5, _N.%q1), setq(5, lattrp(%0/_N.%q1*))), if(not(and(eq(words(%q5), 1), t(setr(6, xget(%0, %q5))), isnum(%q6))), setq(6, #-1 NO INDEX)), if(or(t(%2), t(%4)), case(1, and(t(%q6), hasattrp(%0, _F.%q6.%q2)), setq(7, _F.%q6.%q2), t(%q6), setq(7, lattrp(%0/_F.%q6.%q2*)), setq(7, lattrp(%0/_F.*.%q2*)))), setq(0, case(1, and(t(%q6), not(or(t(%2), t(%q3), t(%q4)))), xget(%0, _I.%q6), and(t(%q5), not(or(t(%2), t(%q4)))), iter(%q5, if(or(not(t(%q3)), strmatch(xget(%0, _V.[xget(%0, itext(0))]), *%q3*)), xget(%0, _I.[xget(%0, itext(0))])),, |), and(t(%q5), t(%q7)), iter(%q5, if(or(not(t(%q3)), strmatch(xget(%0, _V.[xget(%0, itext(0))]), *%q3*)), iter(%q7, if(or(not(t(%q4)), strmatch(xget(%0, _J.[xget(%0, itext(1))].[xget(%0, itext(0))]), *%q4*)), strcat(xget(%0, _I.[xget(%0, itext(1))]), /, xget(%0, _M.[xget(%0, itext(1))].[xget(%0, itext(0))]))) ,, |)) ,, |), #-1 NO DATA FOUND.)), setq(0, trim(squish(setunion(%q0, %q0, |), |),, |)), if(t(%q0), %q0, #-1 NO DATA FOUND.))

&f.sql-wipe DSF=sql(ulocal(sql.delete.[if(t(%2), key, data)], %0, %1, %2))

&f.parent-wipe DSF=if(and(t(setr(0, xget(%0, _N.%1))), or(not(t(%2)), t(setr(1, xget(%0, _F.%q0.%2))))), if(t(%2), strcat(set(ulocal(f.find-first-free-parent, %0, _K.%q0), _K.%q0:), set(ulocal(f.find-first-free-parent, %0, _F.%q0.%2), _F.%q0.%2:), set(ulocal(f.find-first-free-parent, %0, _M.%q0.%q1), _M.%q0.%q1:), set(ulocal(f.find-first-free-parent, %0, _J.%q0.%q1), _J.%q0.%q1:)), strcat(set(ulocal(f.find-first-free-parent, %0, _N.%1), _N.%1:), set(ulocal(f.find-first-free-parent, %0, _I.%q0), _I.%q0:), set(ulocal(f.find-first-free-parent, %0, _V.%q0), _V.%q0:), iter(lattrp(%0/_F.%q0.*), strcat(setr(1, xget(%0, itext(0))), set(ulocal(f.find-first-free-parent, %0, _K.%q0), _K.%q0:), set(ulocal(f.find-first-free-parent, %0, itext(0)), itext(0):), set(ulocal(f.find-first-free-parent, %0, _M.%q0.%q1), _M.%q0.%q1:), set(ulocal(f.find-first-free-parent, %0, _J.%q0.%q1), _J.%q0.%q1:)),, @@))), #-1 DATA NOT FOUND.)

&f.find-oldest-DSP-parent DSF=if(strmatch(name(%0), *- DSP #*), ulocal(f.find-oldest-DSP-parent, #[last(name(%0), #)]), %0)

&f.find-first-free-parent DSF=if(or(lt(attrcnt(%0), v(d.max-attributes)), hasattr(%0, %1)), %0, if(t(parent(%0)), ulocal(f.find-first-free-parent, parent(%0), %1), null(strcat(setr(0, create(if(strmatch(name(%0), * - DSP *), first(name(%0), - DSP), name(%0)) - DSP %0, 10)), parent(%0, %q0), set(%q0, safe), tel(%q0, ulocal(f.find-oldest-DSP-parent, %0))))%q0))

&f.globalpp.setdata DSF=case(1, not(ulocal(l.canset, %@)), #-1 HIGHER PERMISSIONS REQUIRED., not(isdbref(%0)), #-2 MUST PROVIDE DBREF FOR TARGET., or(not(t(%0)), not(t(%1)), not(t(%2))), #-2 MUST SUPPLY DBREF AND NAME WITH VALUE. USE NULL TO WIPE VALUE., gt(strlen(%1), v(d.max-name-length)), #-2 NAME TOO LONG., and(t(%3), gt(strlen(%2), v(d.max-name-length))), #-2 KEY NAME TOO LONG., not(match(setr(0, strip(%1, v(d.permitted-name-characters))),)), #-2 BAD NAME. MUST NOT CONTAIN %q0., and(t(%3), not(match(setr(0, strip(%2, v(d.permitted-name-characters))),))), #-2 BAD KEY. MUST NOT CONTAIN %q0., gt(strlen(if(t(%3), %3, %2)), v(d.max-value-length)), #-2 VALUE TOO LONG., and(not(%vS), strmatch(%1, _*)), #-2 CANNOT START NAME WITH UNDERSCORE IN PARENT MODE., and(t(%3), not(%vS), strmatch(%2, _*)), #-2 CANNOT START KEY WITH UNDERSCORE IN PARENT MODE., and(not(%vS), not(match(type(%0), THING))), #-2 TARGET MUST BE A THING IN PARENT MODE. |[type(%0)]|, and(t(%3), not(t(ulocal(f.[if(%vS, sql, parent)]-get, %0, if(%vS, %1, edit(%1, %b, _)))))), #-2 DATA NAME NOT FOUND., %vS, ulocal(f.sql-set, %0, %1, %2, %3), ulocal(f.parent-set, %0, %1, %2, %3))

&f.globalpp.setname DSF=case(1, not(ulocal(l.canset, %@)), #-1 HIGHER PERMISSIONS REQUIRED., not(isdbref(%0)), #-2 MUST PROVIDE DBREF FOR TARGET., or(not(t(%0)), not(t(%1)), not(t(%2))), #-2 MUST SUPPLY DBREF AND NAME WITH NEW NAME., gt(strlen(%1), v(d.max-name-length)), #-2 NAME TOO LONG., and(t(%3), gt(strlen(%2), v(d.max-name-length))), #-2 KEY NAME TOO LONG., gt(max(strlen(%3), strlen(%2)), v(d.max-name-length)), #-2 NEW NAME TOO LONG., not(match(setr(0, strip(%1%2%3, v(d.permitted-name-characters))),)), #-2 BAD NAME. MUST NOT CONTAIN %q0., and(not(%vS), strmatch(%1, _*)), #-2 CANNOT START NAME WITH UNDERSCORE IN PARENT MODE., and(t(%3), not(%vS), strmatch(%2, _*)), #-2 CANNOT START KEY WITH UNDERSCORE IN PARENT MODE., or(strmatch(%2, _*), strmatch(%3, _*)), #-2 CANNOT START KEY WITH UNDERSCORE IN PARENT MODE., not(t(ulocal(f.[if(%vS, sql, parent)]-get, %0, if(%vS, %1, edit(%1, %b, _)), if(t(%3), %2)))), #-2 NAME TO CHANGE NOT FOUND., %vS, ulocal(f.sql-set-name, %0, %1, %2, %3), ulocal(f.parent-set-name, %0, %1, %2, %3))

&f.globalpp.getdata DSF=case(1, not(ulocal(l.canset, %@)), #-1 HIGHER PERMISSIONS REQUIRED., %vS, ulocal(f.sql-get, %0, %1, %2), ulocal(f.parent-get, %0, edit(%1, %b, _), edit(%2, %b, _)))

&f.globalpp.getname DSF=case(1, not(ulocal(l.canset, %@)), #-1 HIGHER PERMISSIONS REQUIRED., %vS, ulocal(f.sql-get-name, %0, %1, %2), ulocal(f.parent-get-name, %0, edit(%1, %b, _), edit(%2, %b, _)))

&f.globalpp.listdata DSF=case(1, not(ulocal(l.canset, %@)), #-1 HIGHER PERMISSIONS REQUIRED., %vS, ulocal(f.sql-list, %0, %1, %2, %3, %4), ulocal(f.parent-list, %0, %1, %2, %3, %4))

&f.globalpp.wipedata DSF=case(1, not(ulocal(l.canset, %@)), #-1 HIGHER PERMISSIONS REQUIRED., %vS, ulocal(f.sql-wipe, %0, %1, %2), ulocal(f.parent-wipe, %0, edit(%1, %b, _), edit(%2, %b, _)))

@dolist lattr(DSF/sql.*)=@set DSF/##=no_parse

@dolist lattr(DSF/f.*)=@set DSF/##=no_parse

@dolist lattr(DSF/tr.*)=@set DSF/##=no_parse

think Entry complete.
