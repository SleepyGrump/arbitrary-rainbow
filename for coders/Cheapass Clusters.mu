@@ -----------------------------------------------------------------------------
@@      TinyMUX Type-Agnostic Data Storage Module (AKA cheapass @clusters)
@@ -----------------------------------------------------------------------------
@@ Tested with MUX 2.10.1.14 #3 and MySQL version 5.7.20.
@@ -----------------------------------------------------------------------------
@@                                 IMPORTANT
@@ -----------------------------------------------------------------------------
@@ 1. Read through the code below until it says "Don't change anything past this
@@    point!" Change whatever you need to to work with your game.
@@ -
@@ 2. If you exceed 10 parents on a single object, you will need to increase the
@@    game's configured parent_recursion_limit to something higher. This does
@@    not apply to the SQL storage method.
@@ -
@@ 3. Warning: this code overrides FiranMux's "setname()" function. If you use
@@    that function on your game (it only works if you compile with
@@    --enable-firanmux) you may want to alter this code to change it to
@@    something better for your game.
@@ -
@@ 4. If you use this, be aware that anyone with access to setdata can set
@@    literally anything in the value field. That's why it's locked to staffers
@@    by default - nobody wants someone to get bitted on accident.
@@ -----------------------------------------------------------------------------
@@                                REQUIREMENTS
@@ -----------------------------------------------------------------------------
@@ - Myrddin's mushcron IF you choose to automatically keep your SQL connection
@@   alive
@@ - isstaff()
@@ - header() and footer() if you install the bog-simple proof of concept object
@@ - @startup allowed on objects (default value) - if this is not set, move the
@@    @function declarations to #1 or wherever necessary for startups to work.
@@ - @function for wizards (default value) - same here
@@ -----------------------------------------------------------------------------
@@                               DOCUMENTATION
@@ -----------------------------------------------------------------------------
@@ Goal: Stop worrying about data storage. This can be managed in two possible
@@ ways: without SQL via the parenting method, and with SQL via table lookups.
@@ The parenting method is where you fill an object up with attributes, and when
@@ it is full, create a parent for it, parent it to the new object, and keep
@@ setting data to the parent. This works up to 10 levels by default, and
@@ should allow up to 25,000+ pieces of data before you have to edit your
@@ netmux.conf file, so it can be installed without site access (by a wizard).
@@ -
@@ If your game supports SQL, setup will automatically switch to it, producing
@@ an effectively unlimited amount of storage. Either way, the coder shouldn't
@@ have to worry about the method of storage - the access functions are the
@@ same.
@@ -
@@ This storage method supports "keys", additional pieces of data stored on the
@@ same "data name". If a key is passed in, the value will be stored under the
@@ key and related to the data name. You'll end up with data like so:
@@ -
@@  DBref: #7
@@  Name: Balloon
@@  Balloon Value: A big red balloon with an unusually straight white cord.
@@  Balloon Size: 18"
@@  Balloon Color: Red
@@  Balloon Owner: Pennywise
@@  Balloon Purpose: Terror
@@ -
@@ In SQL, the keys would be stored in a lookup table and matched to a data
@@ storage table. In the parent method, you'd end up with 3 attributes per data
@@ name/value and 3 per key, plus one global index and one index per data name
@@ with keys. (Index, 3 name/value attributes, key index, 3 attributes per key.)
@@ Once the data is set, regardless of storage method, the code
@@ "getdata(#7, balloon, color)" would get you "Red". "getdata(#7, balloon)"
@@ will get you "A big red balloon with an unusually straight white cord.".
@@ Because context is important, there is redundancy designed to prevent data
@@ loss, even if that loss is just the data name or key's case. This way you can
@@ have a "pretty" name for your field.
@@ -
@@ One word of warning: the data name must by nature be unique to the dbref. If
@@ you don't get those two values unique, the target will be overwritten, just
@@ as it would with set(). The same goes for DBref/Data name/Key names.
@@ -----------------------------------------------------------------------------
@@                                   CAVEATS
@@ -----------------------------------------------------------------------------
@@ In Parent Mode, you cannot:
@@  - Put data on players or rooms. This is because:
@@     - Where would the parent objects for a player or room be stored?
@@       Remember, players can always see objects in their own inventories.
@@     - Re-parenting players or rooms would mess with your default player/room
@@       parents.
@@    If you're OK with that, you can remove the check on the parent set
@@    functions.
@@  - Start your data values with an underscore. This is because set(target,
@@    name:_value) does something completely different than you'd think - it
@@    means "copy 'name' from object 'value' to object 'target'". The preferred
@@    syntax for setting a value to start with underscore is &name
@@    target=_value, but because we're doing this via a @function, we can't
@@    call SET that way. There's a line you can comment out in your source code
@@    in set.cpp around line 1311, starting with "if (*p == '_')" and ending at
@@    the next "}", but since that involves messing with source code and would
@@    require you to recompile your game, it is NOT enabled by default. If you
@@    enable it, you can remove that check from the parent set functions.
@@ -----------------------------------------------------------------------------
@@ Functions:
@@  setdata(target, name, value)
@@  setdata(target, name, key, value)
@@  setdata(target, name, NULL)                 <-- Empties the value field
@@  setdata(target, name, key, NULL)            <-- Empties the value field
@@ -
@@  setname(target, name, new name)
@@  setname(target, name, key, new key name)
@@ -
@@  getdata(target, name)
@@  getdata(target, name, key)
@@ -
@@  getname(target, name)
@@  getname(target, name, key)
@@ -
@@  listdata(target, name, key, name value, key value)
@@    Only target is required. All other fields are optional and will be
@@    partial-searched if given. Exact matches will be returned as solo results.
@@    If no exact matches are found, all partial matches will be returned in
@@    this format if no key is requested and no key value is searched:
@@       Name|name|name
@@    If a key or key value are searched, listdata will return this format:
@@       Name/key|name/key
@@ -
@@  wipedata(target, name)
@@  wipedata(target, name, key)
@@ -----------------------------------------------------------------------------
@@                                 CHANGE LOG
@@ -----------------------------------------------------------------------------
@@ 2018-01-09 Added escape() to sql inserts so values pass as intended.
@@ 2018-01-11 Pass insert values as registers so we can explicitly replace nulls
@@            with nothing where necessary.
@@ 2018-03-27 Noticed and fixed a bug with the SQL detection routine
@@ -----------------------------------------------------------------------------


@create Data Storage Functions <DSF>=10
@set DSF=safe inherit

@@ -----------------------------------------------------------------------------
@@ Do we have SQL at the time of install? (If your server wasn't running, here's
@@ where you fix that!) Make sure SQL is running and accessible when you run
@@ this line. This value can be changed between 0 and 1 at any time. Note that
@@ you will only be able to access one type of data at a time, though - SQL or
@@ object-based.
@@ -----------------------------------------------------------------------------

@force me=&vS DSF=and(t(sql(SELECT 1)), eq(strlen(sql(SELECT 1)), 1))

@@ -----------------------------------------------------------------------------
@@ CHANGE THIS or setup will be broken! You can find this value in your
@@ netmux.conf file under sql_user. If you don't have access to that, ask God.
@@ This value gets evaluated at install-time ONLY.
@@ -----------------------------------------------------------------------------

&VL me=MYSQL_LOGIN_NAME_HERE;

&vD DSF=YOUR_DATABASE_HERE;

@@ -----------------------------------------------------------------------------
@@ Flip this to 1 only if you need a way to keep your SQL connection alive.
@@ Otherwise, feel free to comment it out. (Some code, like Thenomain's
@@ WikiNews, keeps SQL running regularly already. We don't want to duplicate
@@ that function, it'll slow your game down and it's not polite to your SQL
@@ server.)
@@ -----------------------------------------------------------------------------

&vK me=0

@@ -----------------------------------------------------------------------------
@@ Exercise caution expanding this. On MUX with extensive testing I've found that
@@ you can push this up to 2662, but my tests were inconclusive when I started
@@ playing with attribute length. Data loss is possible with values higher than
@@ 2550. Playing it safe and setting this low enough that there's lots of room.
@@ -----------------------------------------------------------------------------

&d.max-attributes DSF=2500

@@ -----------------------------------------------------------------------------
@@ Max length of a "name" field. There's a little padding here compared to what
@@ MUX allows because we add an index in parent mode that allows us to look up
@@ keys.
@@ -----------------------------------------------------------------------------

&d.max-name-length DSF=60

@@ -----------------------------------------------------------------------------
@@ Max length of a "value" field. 7900 because I ran into trouble with numbers
@@ past 7940 with long attribute names. Also, I like round numbers.
@@ -----------------------------------------------------------------------------

&d.max-value-length DSF=7900

@@ -----------------------------------------------------------------------------
@@ All permitted characters in a "name" field. This applies to keys as well.
@@ Converted characters:
@@  In SQL mode: ' becomes &#39;
@@  In parent mode: %b becomes _
@@ Note: actual attribute name characters allowed are: -_.@#$^&*~?=+| (and '
@@ though it isn't documented) - as found in 'help &'
@@ Another non-documented character allowed in attributes: /, which lets us do
@@ pseudo-nesting of keys if we choose.
@@ Excluding | because it would interfere with the output of listdata().
@@ Excluding * because it gets used as a search code in parent mode.
@@ -----------------------------------------------------------------------------

&d.permitted-name-characters DSF=-_.@#$^&~?='+/%bABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789

@@ -----------------------------------------------------------------------------
@@ All characters are permitted in a "value" field.
@@ Sample values (yes, they are vulnerable to injection):
@@    bittype(#123, wizard)
@@    wipe(#13/*)
@@    list|of|things
@@ -----------------------------------------------------------------------------



@@ -----------------------------------------------------------------------------
@@ DO NOT CHANGE ANYTHING PAST THIS POINT! (Unless you know what you're doing.)
@@ -----------------------------------------------------------------------------



@force me=@startup DSF=@trigger me/tr.makefunctions=[num(DSF)];

&TR.MAKEFUNCTIONS DSF=@dolist lattr(%0/f.global.*)=@function rest(rest(##, .), .)=%0/##; @dolist lattr(%0/f.globalp.*)=@function/preserve rest(rest(##, .), .)=%0/##; @dolist lattr(%0/f.globalpp.*)=@function/preserve/privilege rest(rest(##, .), .)=%0/##;

@switch xget(DSF, vS)=1,{

	@switch %vL=MYSQL_LOGIN_NAME_HERE,{
		th %ch%cr--------------------------------------------------------------------------------;
		th %ch%cr ERROR! - Your MySQL login name is not set! Stop this setup RIGHT NOW! - ERROR!;
		th %ch%cr--------------------------------------------------------------------------------;
	};
	@switch xget(DSF, vD)=YOUR_DATABASE_HERE,{
		th %ch%cr--------------------------------------------------------------------------------;
		th %ch%crERROR! - - Your MySQL database is not set! Stop this setup RIGHT NOW! - - ERROR!;
		th %ch%cr--------------------------------------------------------------------------------;
	};

	@switch %vK=1, {
		@fo me=&d.mushcron me=[search( name=CRON - Myrddin's mushcron )];
		@switch not(hasattr(d.mushcron))=1,{
			th %ch%cr--------------------------------------------------------------------------------;
			th %ch%crERROR! - You don't have Myrddin's MUSHcron! Stop this setup RIGHT NOW! - ERROR!;
			th %ch%cr--------------------------------------------------------------------------------;
		};
		&cron_time_checksql [v(d.mushcron)]=||||00 02 04 06 08 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58|

		&cron_job_checksql [v(d.mushcron)]=@if not(t(sql(SELECT 1)))={@cemit Staff=%ch%crSQL is down - [rserror()] - @restart now!;}
	}

/*

@@ SKIP THIS BIT IF YOU ALREADY HAVE DATA.
@@ This is just for testing purposes because I filled my DB with lots of crap
@@ and would like to wipe it.
	@force me=&sql me=DROP TABLE IF EXISTS tblKeyValues;
	th sql(v(sql));

	@force me=&sql me=DROP TABLE IF EXISTS tblDataValues;
	th sql(v(sql));

*/

	@force me=&sql me=CREATE TABLE IF NOT EXISTS tblDataValues (DBref varchar(10) NOT NULL, Name varchar([xget(DSF, d.max-name-length)]) NOT NULL, Value varchar([xget(DSF, d.max-value-length)]), PRIMARY KEY (DBref, Name)) ENGINE=InnoDB;

	th sql(v(sql));

	@force me=&sql me=CREATE TABLE IF NOT EXISTS tblKeyValues (DBref varchar(10) NOT NULL, DataName varchar([xget(DSF, d.max-name-length)]) NOT NULL, Name varchar([xget(DSF, d.max-name-length)]) NOT NULL, Value varchar([xget(DSF, d.max-value-length)]), PRIMARY KEY (DBref, DataName, Name), CONSTRAINT ufk_DBref_DataName FOREIGN KEY (DBref, DataName) REFERENCES tblDataValues(DBref, Name) ON DELETE CASCADE) ENGINE=InnoDB;

	th sql(v(sql));

	@force me=&sql me=CREATE UNIQUE INDEX uix_dataNames ON tblDataValues (DBref, Name);

	th sql(v(sql));

	@force me=&sql me=CREATE UNIQUE INDEX uix_keyNames ON tblKeyValues (DBref, DataName, Name);

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_GetDataValue`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) SELECT Value FROM tblDataValues WHERE DBref = up_DBref AND Name = up_Name%%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_GetKeyValue`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) SELECT Value FROM tblKeyValues WHERE DBref = up_DBref AND DataName = up_DataName AND Name = up_Name%%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_GetDataName`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) SELECT Name FROM tblDataValues WHERE DBref = up_DBref AND Name = up_Name%%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_GetKeyName`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) SELECT Name FROM tblKeyValues WHERE DBref = up_DBref AND DataName = up_DataName AND Name = up_Name%%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_ListData`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Key` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Value` VARCHAR([xget(DSF, d.max-value-length)]), IN `up_KeyValue` VARCHAR([xget(DSF, d.max-value-length)]), IN `up_Format` BIT(1)) SELECT DISTINCT CASE WHEN up_Format = 1 THEN CONCAT(D.Name, '/', K.Name) ELSE D.Name END AS Name FROM tblDataValues D LEFT OUTER JOIN tblKeyValues K ON D.DBref=K.DBref AND D.Name=K.DataName WHERE D.DBref = up_DBref AND (up_Name = '' OR D.Name LIKE CONCAT(up_Name, '\%\%\%\%')) AND (up_Key = '' OR K.Name LIKE CONCAT(up_Key, '\%\%\%\%')) AND (up_Value = '' OR D.Value LIKE CONCAT('\%\%\%\%', up_Value, '\%\%\%\%')) AND (up_KeyValue = '' OR K.Value LIKE CONCAT('\%\%\%\%', up_KeyValue, '\%\%\%\%')) %%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_SetDataValue`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Value` VARCHAR([xget(DSF, d.max-value-length)])) INSERT INTO tblDataValues (`DBref`, `Name`, `Value`) VALUES(up_DBref, up_Name, up_Value) ON DUPLICATE KEY UPDATE `Value` = up_Value%%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_SetKeyValue`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Value` VARCHAR([xget(DSF, d.max-value-length)])) INSERT INTO tblKeyValues (`DBref`, `DataName`, `Name`, `Value`) VALUES(up_DBref, up_DataName, up_Name, up_Value) ON DUPLICATE KEY UPDATE `Value` = up_Value%%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_SetDataName`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_NewName` VARCHAR([xget(DSF, d.max-value-length)])) UPDATE tblDataValues SET `Name`=`up_NewName` WHERE `Name` = up_Name AND `DBref`= up_DBref%%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_SetKeyName`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_NewName` VARCHAR([xget(DSF, d.max-value-length)])) UPDATE tblKeyValues SET `Name`=`up_NewName` WHERE `Name` = up_Name AND `DataName` = up_DataName AND `DBref`= up_DBref%%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_WipeData`(IN `up_DBref` VARCHAR(10), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) DELETE FROM tblDataValues WHERE `Name` = up_Name AND `DBref`= up_DBref%%;

	th sql(v(sql));

	@force me=&sql me=CREATE DEFINER=`%vL`@`localhost` PROCEDURE `usp_WipeKey`(IN `up_DBref` VARCHAR(10), IN `up_DataName` VARCHAR([xget(DSF, d.max-name-length)]), IN `up_Name` VARCHAR([xget(DSF, d.max-name-length)])) DELETE FROM tblKeyValues WHERE `Name` = up_Name AND `DBref`= up_DBref AND `DataName` = up_DataName%%;

	th sql(v(sql));

	th NOTE: Your game supports SQL. Data will be stored using the SQL method!;

},{th NOTE: Your game does not support SQL. Using the parent method!}

@@ -----------------------------------------------------------------------------
@@ SQL commands go here.
@@ -----------------------------------------------------------------------------

&sql.insert.dataValue DSF=CALL usp_SetDataValue('%0', '[escape(edit(%1, ', &#39;))]', '[escape(edit(%2, ', &#39;))]');

&sql.insert.keyValue DSF=CALL usp_SetKeyValue('%0', '[escape(edit(%1, ', &#39;))]', '[escape(edit(%2, ', &#39;))]', '[escape(edit(%3, ', &#39;))]');

&sql.update.dataName DSF=CALL usp_SetDataName('%0', '[escape(edit(%1, ', &#39;))]', '[escape(edit(%2, ', &#39;))]');

&sql.update.keyName DSF=CALL usp_SetKeyName('%0', '[escape(edit(%1, ', &#39;))]', '[escape(edit(%2, ', &#39;))]', '[escape(edit(%3, ', &#39;))]');

&sql.select.dataValue DSF=SELECT Value FROM tblDataValues WHERE DBref = '%0' AND Name = '[edit(%1, ', &#39;)]';

&sql.select.keyValue DSF=SELECT Value FROM tblKeyValues WHERE DBref = '%0' AND DataName = '[edit(%1, ', &#39;)]' AND Name = '[edit(%2, ', &#39;)]';

&sql.select.dataName DSF=SELECT Name FROM tblDataValues WHERE DBref = '%0' AND Name = '[edit(%1, ', &#39;)]';

&sql.select.keyName DSF=SELECT Name FROM tblKeyValues WHERE DBref = '%0' AND DataName = '[edit(%1, ', &#39;)]' AND Name = '[edit(%2, ', &#39;)]';

&sql.list.data DSF=SELECT DISTINCT CASE WHEN '%5' = '0' THEN D.Name ELSE CONCAT(D.Name, '/', K.Name) END FROM tblDataValues D LEFT OUTER JOIN tblKeyValues K ON D.DBref=K.DBref AND D.Name=K.DataName WHERE D.DBref = '%0' AND ( '[edit(%1, ', &#39;)]' = '' OR D.Name LIKE CONCAT( '[edit(%1, ', &#39;)]', '\%\%')) AND ( '[edit(%2, ', &#39;)]' = '' OR K.Name LIKE CONCAT( '[edit(%2, ', &#39;)]', '\%\%')) AND ( '[edit(%3, ', &#39;)]' = '' OR D.Value LIKE CONCAT('\%\%', '[edit(%3, ', &#39;)]', '\%\%')) AND ( '[edit(%4, ', &#39;)]' = '' OR K.Value LIKE CONCAT('\%\%', '[edit(%4, ', &#39;)]', '\%\%'))

&sql.delete.data DSF=CALL usp_WipeData('%0', '[edit(%1, ', &#39;)]');

&sql.delete.key DSF=CALL usp_WipeKey('%0', '[edit(%1, ', &#39;)]', '[edit(%2, ', &#39;)]');

/*

@@ I encountered a potential bug with stored procedures (it might just be my
@@ machine experiencing this):
@@   https://github.com/brazilofmux/tinymux/issues/693
@@ Until it is fixed, we should use raw queries for all SQL selects.
@@ When the fix is installed, or if the bug doesn't happen for you, run this:

&sql.select.dataValue DSF=CALL usp_GetDataValue('%0', '[edit(%1, ', &#39;)]')

&sql.select.keyValue DSF=CALL usp_GetDataValue('%0', '[edit(%1, ', &#39;)]', '[edit(%2, ', &#39;)]')

&sql.select.dataName DSF=CALL usp_GetDataName('%0', '[edit(%1, ', &#39;)]')

&sql.select.keyName DSF=CALL usp_GetDataName('%0', '[edit(%1, ', &#39;)]', '[edit(%2, ', &#39;)]')

&sql.list.data DSF=CALL usp_ListData('%0', '[edit(%1, ', &#39;)]', '[edit(%2, ', &#39;)]', '[edit(%3, ', &#39;)]', '[edit(%4, ', &#39;)]', [or(t(%2), t(%4))])

@@ To test for the bug, run this code.
@@ Warning: you will have to @restart your MUX if you have the bug.

	th sql(CALL usp_SetDataValue('%#'%, 'Test'%, 'testing'))
	th sql(SELECT Value FROM tblDataValues WHERE Name = 'Test' AND DBRef='%#')
	th sql(CALL usp_GetDataValue('%#'%, 'Test'))
	th sql(SELECT Value FROM tblDataValues WHERE Name = 'Test' AND DBRef='%#')

@@ If your SQL server is still connected to your MUX, congratulations, you don't
@@ have the bug! You can use the stored procedures (these commented-out things)
@@ for SELECTs, which is good because they're safer than raw code.

@@ If you get #-1 SQL UNAVAILABLE, sorry, you're out of luck. @restart and
@@ install the update whenever it's released.

*/

@@/ -----------------------------------------------------------------------------
@@ Who can run this? Strong recommendation: at least wizard. Should take care of
@@ your inherit objects and code stuff - we only want this being called by
@@ system code if possible.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - Calling object, if there is one.
@@ -----------------------------------------------------------------------------
@@ Result: 1 or 0
@@ -----------------------------------------------------------------------------
@@ Note: I thought about separate 'get' permissions, but decided that staffers
@@ might use this to set data on a player that they don't want them to see,
@@ like notes. Allowing getdata() to work around that would be a security hole.
@@ Better to let the end user - the coder - build their way around it so that
@@ players only get access to what they're supposed to be able to see.
@@ -----------------------------------------------------------------------------

&l.canset DSF=or(isstaff(%#), and(strmatch(type(%0), THING), hasflag(%0, inherit), isstaff(owner(%0))))

@@ -----------------------------------------------------------------------------
@@ Set the data via SQL.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key or value
@@  %3 - key value (optional)
@@ -----------------------------------------------------------------------------
@@ Results: Nothing unless there's an error, just like set().
@@ -----------------------------------------------------------------------------

&f.sql-set DSF=strcat(setq(0, if(match(%0, NULL), , %0)), setq(1, if(match(%1, NULL), , %1)), setq(2, if(match(%2, NULL), , %2)), setq(3, if(match(%3, NULL), , %3)), sql(ulocal(sql.insert.[if(t(%3), keyValue, dataValue)], %q0, %q1, %q2, %q3)))

&f.sql-set-name DSF=strcat(setq(0, if(match(%0, NULL), , %0)), setq(1, if(match(%1, NULL), , %1)), setq(2, if(match(%2, NULL), , %2)), setq(3, if(match(%3, NULL), , %3)), sql(ulocal(sql.update.[if(t(%3), keyName, dataName)], %q0, %q1, %q2, %q3)))

@@ -----------------------------------------------------------------------------
@@ Set the data via parent mode.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key or value
@@  %3 - key value (optional)
@@ -----------------------------------------------------------------------------
@@ Results: Nothing unless there's an error, just like set().
@@ -----------------------------------------------------------------------------
@@ Notes: To succesfully store data in a fully retrievable fashion, it needs to
@@ be indexed. The following attributes must be set:
@@  &_I target=data index (to be incremented with every new data piece)
@@  &_N.NAME target=INDEX - where Name is the "name" submitted by the user and
@@   INDEX is the value from I.
@@  &_I.INDEX target=Real data name goes here. This lets us look up the
@@   pretty-formatted name of the data.
@@  &_V.INDEX target=Value goes here.
@@ The same applies for keys - they need:
@@  &_K.INDEX target=KEYINDEX (current key index count FOR THIS DATA ITEM)
@@  &_F.INDEX.NAME target=KEYINDEX (this key's index)
@@  &_M.INDEX.KEYINDEX target=The key's pretty-formatted name.
@@  &_J.INDEX.KEYINDEX target=The key's pretty-formatted value.
@@ Starting letters chosen mostly arbitrarily.
@@ -----------------------------------------------------------------------------

&f.parent-set DSF=
	if(
		and(
			t(setr(0, ulocal(f.get-name-index, %0, edit(%1, %b, _)))),
			isint(%q0)
		),
		if(
			or(
				t(setr(1, ulocal(f.parent-set-[if(t(%3), key, data)], %0, edit(%1, %b, _), if(t(%3), edit(%2, %b, _), %2), %3, %q0))),
				eq(strlen(%q1), 0)
			),
			,
			%q1
		),
		%q0
	)

&f.parent-set-name DSF=
	if(
		and(
			t(setr(0, ulocal(f.get-name-index, %0, edit(%1, %b, _)))),
			isint(%q0)
		),
		if(
			or(
				t(setr(1, ulocal(f.parent-set-[if(t(%3), key, data)]-name, %0, edit(%1, %b, _), edit(%2, %b, _), edit(%3, %b, _), %q0))),
				eq(strlen(%q1), 0)
			),
			,
			%q1
		),
		%q0
	)

@@ -----------------------------------------------------------------------------
@@ Get the name attr's index. (Required for lookup.)
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key or value
@@  %3 - key value (optional)
@@ -----------------------------------------------------------------------------
@@ Results: A number.
@@ -----------------------------------------------------------------------------

&f.get-name-index DSF=if(
	t(hasattrp(%0, _N.%1)),
	xget(%0, _N.%1),
	strcat(
		set(%0, _I:[setr(0, if(hasattr(%0, _I), inc(xget(%0, _I)), 1))]),
		set(ulocal(f.find-first-free-parent, %0, _N.%1), _N.%1:%q0),
		set(ulocal(f.find-first-free-parent, %0, _I.%q0), _I.%q0:[edit(%1, _, %b)]),
		%q0
	))

@@ -----------------------------------------------------------------------------
@@ Get the key attr's index. (Required for lookup.)
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key
@@  %3 - key value (optional)
@@  %4 - the name attr's index
@@ -----------------------------------------------------------------------------
@@ Results: A number.
@@ -----------------------------------------------------------------------------

&f.get-key-index DSF=if(
	t(hasattrp(%0, _F.%4.%2)),
	xget(%0, _F.%4.%2),
	strcat(
		set(%0, _K.%4:[setr(0, if(hasattr(%0, _K.%4), inc(xget(%0, _K.%4)), 1))]),
		set(ulocal(f.find-first-free-parent, %0, _F.%4.%2), _F.%4.%2:%q0),
		set(ulocal(f.find-first-free-parent, %0, _M.%4.%q0), _M.%4.%q0:[edit(%2, _, %b)]),
		%q0
	))

@@ -----------------------------------------------------------------------------
@@ Set a name's value, plus set a name. Same arguments.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key or value
@@  %3 - key value (optional, makes %2 be key)
@@  %4 - the name attr's index
@@ -----------------------------------------------------------------------------
@@ Results: Nothing.
@@ -----------------------------------------------------------------------------

&f.parent-set-data DSF=set(ulocal(f.find-first-free-parent, %0, _V.%4), _V.%4:[if(match(%2, NULL),, %2)])

&f.parent-set-data-name DSF=strcat(
	set(setr(0, ulocal(f.find-first-free-parent, %0, _N.%1)), _N.%1:),
	set(%q0, _N.%2:%4),
	set(ulocal(f.find-first-free-parent, %0, _I.%4), _I.%4:%2)
)

@@ -----------------------------------------------------------------------------
@@ Set a key's value and name, same arguments and results.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key
@@  %3 - key value
@@  %4 - the name attr's index
@@ -----------------------------------------------------------------------------
@@ Results: Nothing.
@@ -----------------------------------------------------------------------------

&f.parent-set-key DSF=if(
		and(
			t(setr(0, ulocal(f.get-key-index, %0, %1, %2, %3, %4))),
			isint(%q0)
		),
		if(
			or(
				t(setr(1, set(
					ulocal(f.find-first-free-parent, %0, _J.%4.%q0),
					_J.%4.%q0:[if(match(%3, NULL),, %3)]
				))),
				eq(strlen(%q1), 0)
			),
			,
			%q1
		),
		%q0
	)

&f.parent-set-key-name DSF=if(
		and(
			t(setr(0, ulocal(f.get-key-index, %0, %1, %2, %3, %4))),
			isint(%q0)
		),
		if(
			or(
				t(setr(1, strcat(
					set(
						setr(2, ulocal(f.find-first-free-parent, %0, _F.%4.%2)),
						_F.%4.%2:
					),
					set(%q2, _F.%4.%3:%q0),
					set(ulocal(f.find-first-free-parent, %0, _M.%4.%q0), _M.%4.%q0:%3)
				))),
				eq(strlen(%q1), 0)
			),
			,
			%q1
		),
		%q0
	)

@@ -----------------------------------------------------------------------------
@@ Get the data via SQL.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key (optional)
@@ -----------------------------------------------------------------------------
@@ Results: The value of the dbref/name/optional key.
@@ -----------------------------------------------------------------------------

&f.sql-get DSF=edit(sql(iter(ulocal(sql.select.[if(t(%2), keyValue, dataValue)], %0, %1, %2), if(match(itext(0), 'NULL'), '', itext(0)))), &#39;, ')

@@ -----------------------------------------------------------------------------
@@ Get the data via parent mode.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key (optional)
@@ -----------------------------------------------------------------------------
@@ Results: The value of the dbref/name/optional key.
@@ -----------------------------------------------------------------------------

&f.parent-get DSF=
	if(
		t(setr(0, xget(%0, _N.%1))),
		if(
			t(%2),
			xget(%0, _J.%q0.[xget(%0, _F.%q0.%2)]),
			xget(%0, _V.%q0)
		)
	)

@@ -----------------------------------------------------------------------------
@@ Get the name via SQL.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key (optional)
@@ -----------------------------------------------------------------------------
@@ Results: The name of the dbref/name/optional key.
@@ -----------------------------------------------------------------------------

&f.sql-get-name DSF=edit(sql(iter(ulocal(sql.select.[if(t(%2), keyName, dataName)], %0, %1, %2), if(match(itext(0), 'NULL'), '', itext(0)))), &#39;, ')

@@ -----------------------------------------------------------------------------
@@ Get the name via parent mode.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key (optional)
@@ -----------------------------------------------------------------------------
@@ Results: The name of the dbref/name/optional key.
@@ -----------------------------------------------------------------------------

&f.parent-get-name DSF=
	if(
		t(setr(0, xget(%0, _N.%1))),
		if(
			t(%2),
			xget(%0, _M.%q0.[xget(%0, _F.%q0.%2)]),
			xget(%0, _I.%q0)
		),
		#-1 NOT FOUND
	)

@@ -----------------------------------------------------------------------------
@@ List the data via SQL.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key (optional)
@@  %3 - name value to search (optional)
@@  %4 - key value to search (optional)
@@ -----------------------------------------------------------------------------
@@ Results: A list of names or keys matching the given strings.
@@ -----------------------------------------------------------------------------

&f.sql-list DSF=
	if(
		t(setr(0, sql(iter(ulocal(sql.list.data, %0, %1, %2, %3, %4, or(t(%2), t(%4))), if(match(itext(0), 'NULL'), '', itext(0))), |, |))),
		edit(%q0, &#39;, '),
		#-1 NO RESULTS
	)

@@ -----------------------------------------------------------------------------
@@ List the data via parent mode.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key (optional)
@@  %3 - name value to search (optional)
@@  %4 - key value to search (optional)
@@ -----------------------------------------------------------------------------
@@ Results: A list of names or keys matching the given string. If a key is
@@ given, the name must be exact.
@@ -----------------------------------------------------------------------------

&f.parent-list DSF=strcat(
		setq(1, edit(%1, %b, _)),
		setq(2, edit(%2, %b, _)),
		setq(3, %3),
		setq(4, %4),
		if(match(%q1, NULL), setq(1,)),
		if(match(%q2, NULL), setq(2,)),
		if(match(%q3, NULL), setq(3,)),
		if(match(%q4, NULL), setq(4,)),
		if(
			hasattrp(%0, _N.%q1),
			setq(5, _N.%q1),
			setq(5, lattrp(%0/_N.%q1*))
		),
		if(
			not(and(
				eq(words(%q5), 1),
				t(setr(6, xget(%0, %q5))),
				isnum(%q6)
			)),
			setq(6, #-1 NO INDEX)
		),
		if(
			or(t(%2), t(%4)),
			case(1,
				and(t(%q6), hasattrp(%0, _F.%q6.%q2)),
				setq(7, _F.%q6.%q2),

				t(%q6),
				setq(7, lattrp(%0/_F.%q6.%q2*)),

				setq(7, lattrp(%0/_F.*.%q2*))
			)
		),
		setq(0,
			case(1,
				and(t(%q6), not(or(t(%2), t(%q3), t(%q4)))),
				xget(%0, _I.%q6),

				and(t(%q5), not(or(t(%2), t(%q4)))),
				iter(%q5, if(
					or(not(t(%q3)), strmatch(xget(%0, _V.[xget(%0, itext(0))]), *%q3*)),
					xget(%0, _I.[xget(%0, itext(0))])
				), ,|),

				and(t(%q5), t(%q7)),
				iter(%q5,
					if(or(
						not(t(%q3)),
						strmatch(xget(%0, _V.[xget(%0, itext(0))]), *%q3*)
					),
					iter(%q7,
						if(
							or(not(t(%q4)), strmatch(xget(%0, _J.[xget(%0, itext(1))].[xget(%0, itext(0))]), *%q4*)),
							strcat(
								xget(%0, _I.[xget(%0, itext(1))]),
								/,
								xget(%0, _M.[xget(%0, itext(1))].[xget(%0, itext(0))])
							)
						)
					,, |))
				,, |),

				#-1 NO DATA FOUND.
			)
		),
		setq(0, trim(squish(setunion(%q0, %q0, |), |),, |)),
		if(t(%q0), %q0, #-1 NO DATA FOUND.)
	)

@@ -----------------------------------------------------------------------------
@@ Wipe the data via SQL.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key (optional)
@@ -----------------------------------------------------------------------------
@@ Results: Nothing unless there's an error.
@@ -----------------------------------------------------------------------------

&f.sql-wipe DSF=sql(ulocal(sql.delete.[if(t(%2), key, data)], %0, %1, %2))

@@ -----------------------------------------------------------------------------
@@ Wipe the data via parent mode.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object
@@  %1 - name
@@  %2 - key (optional)
@@ -----------------------------------------------------------------------------
@@ Results: Nothing unless there's an error.
@@ -----------------------------------------------------------------------------

&f.parent-wipe DSF=
	if(
		and(
			t(setr(0, xget(%0, _N.%1))),
			or(
				not(t(%2)),
				t(setr(1, xget(%0, _F.%q0.%2)))
			)
		),
		if(
			t(%2),
			strcat(
				set(ulocal(f.find-first-free-parent, %0, _K.%q0), _K.%q0:),
				set(ulocal(f.find-first-free-parent, %0, _F.%q0.%2), _F.%q0.%2:),
				set(ulocal(f.find-first-free-parent, %0, _M.%q0.%q1), _M.%q0.%q1:),
				set(ulocal(f.find-first-free-parent, %0, _J.%q0.%q1), _J.%q0.%q1:)
			),
			strcat(
				set(ulocal(f.find-first-free-parent, %0, _N.%1), _N.%1:),
				set(ulocal(f.find-first-free-parent, %0, _I.%q0), _I.%q0:),
				set(ulocal(f.find-first-free-parent, %0, _V.%q0), _V.%q0:),
				iter(
					lattrp(%0/_F.%q0.*),
					strcat(
						setr(1, xget(%0, itext(0))),
						set(ulocal(f.find-first-free-parent, %0, _K.%q0), _K.%q0:),
						set(ulocal(f.find-first-free-parent, %0, itext(0)), itext(0):),
						set(ulocal(f.find-first-free-parent, %0, _M.%q0.%q1), _M.%q0.%q1:),
						set(ulocal(f.find-first-free-parent, %0, _J.%q0.%q1), _J.%q0.%q1:)
					),,@@
				)
			)
		),
		#-1 DATA NOT FOUND.
	)

@@ -----------------------------------------------------------------------------
@@ Find the "top" parent, also called the original, the great-great-something
@@ grand-parent, the oldest object to be set with these data values.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object to search
@@ -----------------------------------------------------------------------------
@@ Result: a DBref
@@ -----------------------------------------------------------------------------

&f.find-oldest-DSP-parent DSF=if(strmatch(name(%0), *- DSP #*), ulocal(f.find-oldest-DSP-parent, #[last(name(%0), #)]), %0)

@@ -----------------------------------------------------------------------------
@@ Find the first parent that does NOT hit the attr cap, or the parent that
@@ has the attribute on it, if it already exists.
@@ -----------------------------------------------------------------------------
@@ Arg:
@@  %0 - target object to parent
@@  %1 - target attribute
@@ -----------------------------------------------------------------------------
@@ Result: a DBref
@@ -----------------------------------------------------------------------------
@@ Side effects: If the attribute doesn't already exist, and the target object
@@ is full, and the target object has no parent to search, an object is created
@@ with the name "<name> - DSP #<dbref>". This object is then set to be the
@@ target object's parent, and teleported into the oldest parent.
@@ -----------------------------------------------------------------------------

&f.find-first-free-parent DSF=
	if(
		or(
			lt(attrcnt(%0), v(d.max-attributes)),
			hasattr(%0, %1)
		),
		%0,
		if(
			t(parent(%0)),
			ulocal(f.find-first-free-parent, parent(%0), %1),
			null(strcat(
				setr(0, create(if(strmatch(name(%0), * - DSP *), first(name(%0), - DSP), name(%0)) - DSP %0, 10)),
				parent(%0, %q0),
				set(%q0, safe),
				tel(%q0, ulocal(f.find-oldest-DSP-parent, %0))
			))%q0
		)
	)

@@ -----------------------------------------------------------------------------
@@ Set the data (global user function, should be wiz-only)
@@ -----------------------------------------------------------------------------
@@ Rules:
@@ 1. Throw errors if data won't fit rather than just wedging it in.
@@ 2. If data exists on target object, overwrite it.
@@ 3. If data does not exist on target object, and target object has not
@@    exceeded attribute count quota, add it.
@@ 4. If data does not exist on target object and target object has reached
@@    attribute count quota, go to the object's parent and repeat until a
@@    suitable object has been found, and add the data to that object.
@@ -----------------------------------------------------------------------------
@@ Args:
@@  %0 - target object
@@  %1 - attr name
@@  %2 - key or value
@@  %3 - value, makes %2 be key
@@ -----------------------------------------------------------------------------
@@ Function definition:
@@  setdata(target, name, value)
@@  setdata(target, name, key, value)
@@  setdata(target, name, NULL)              <-- Empties the value
@@  setdata(target, name, key, NULL)         <-- Empties the value
@@ -----------------------------------------------------------------------------
@@ Special: Sending NULL for the value makes the VALUE get wiped. (The field is
@@ still there, the value is gone.)
@@ -----------------------------------------------------------------------------
@@ Results: Nothing unless there's an error, just like set().
@@ -----------------------------------------------------------------------------

&f.globalpp.setdata DSF=
	case(1,
		not(ulocal(l.canset, %@)),
		#-1 HIGHER PERMISSIONS REQUIRED.,

		not(isdbref(%0)),
		#-2 MUST PROVIDE DBREF FOR TARGET.,

		or(not(t(%0)), not(t(%1)), not(t(%2))),
		#-2 MUST SUPPLY DBREF AND NAME WITH VALUE. USE NULL TO WIPE VALUE.,

		gt(strlen(%1), v(d.max-name-length)),
		#-2 NAME TOO LONG.,

		and(t(%3), gt(strlen(%2), v(d.max-name-length))),
		#-2 KEY NAME TOO LONG.,

		not(match(setr(0, strip(%1, v(d.permitted-name-characters))),)),
		#-2 BAD NAME. MUST NOT CONTAIN %q0.,

		and(t(%3), not(match(setr(0, strip(%2, v(d.permitted-name-characters))),))),
		#-2 BAD KEY. MUST NOT CONTAIN %q0.,

		gt(strlen(if(t(%3), %3, %2)), v(d.max-value-length)),
		#-2 VALUE TOO LONG.,

		and(not(%vS), strmatch(%1, _*)),
		#-2 CANNOT START NAME WITH UNDERSCORE IN PARENT MODE.,

		and(t(%3), not(%vS), strmatch(%2, _*)),
		#-2 CANNOT START KEY WITH UNDERSCORE IN PARENT MODE.,

		and(not(%vS), not(match(type(%0), THING))),
		#-2 TARGET MUST BE A THING IN PARENT MODE. |[type(%0)]|,

		and(t(%3), not(t(ulocal(f.[if(%vS, sql, parent)]-get, %0, if(%vS, %1, edit(%1, %b, _)))))),
		#-2 DATA NAME NOT FOUND.,

		%vS,
		ulocal(f.sql-set, %0, %1, %2, %3),

		ulocal(f.parent-set, %0, %1, %2, %3)
	)


@@ -----------------------------------------------------------------------------
@@ Change a data-item's name
@@ -----------------------------------------------------------------------------
@@ Args:
@@  %0 - target object
@@  %1 - attr name
@@  %2 - key or new name
@@  %3 - new key name, makes %2 be key
@@ Function definition:
@@  setname(target, name, new name)
@@  setname(target, name, key, new key name)
@@ -----------------------------------------------------------------------------

&f.globalpp.setname DSF=
	case(1,
		not(ulocal(l.canset, %@)),
		#-1 HIGHER PERMISSIONS REQUIRED.,

		not(isdbref(%0)),
		#-2 MUST PROVIDE DBREF FOR TARGET.,

		or(not(t(%0)), not(t(%1)), not(t(%2))),
		#-2 MUST SUPPLY DBREF AND NAME WITH NEW NAME.,

		gt(strlen(%1), v(d.max-name-length)),
		#-2 NAME TOO LONG.,

		and(t(%3), gt(strlen(%2), v(d.max-name-length))),
		#-2 KEY NAME TOO LONG.,

		gt(max(strlen(%3), strlen(%2)), v(d.max-name-length)),
		#-2 NEW NAME TOO LONG.,

		not(match(setr(0, strip(%1%2%3, v(d.permitted-name-characters))),)),
		#-2 BAD NAME. MUST NOT CONTAIN %q0.,

		and(not(%vS), strmatch(%1, _*)),
		#-2 CANNOT START NAME WITH UNDERSCORE IN PARENT MODE.,

		and(t(%3), not(%vS), strmatch(%2, _*)),
		#-2 CANNOT START KEY WITH UNDERSCORE IN PARENT MODE.,

		or(strmatch(%2, _*), strmatch(%3, _*)),
		#-2 CANNOT START KEY WITH UNDERSCORE IN PARENT MODE.,

		not(t(ulocal(f.[if(%vS, sql, parent)]-get, %0, if(%vS, %1, edit(%1, %b, _)), if(t(%3), %2)))),
		#-2 NAME TO CHANGE NOT FOUND.,

		%vS,
		ulocal(f.sql-set-name, %0, %1, %2, %3),

		ulocal(f.parent-set-name, %0, %1, %2, %3)
	)

@@ -----------------------------------------------------------------------------
@@ Get data of a field (global user function, should be wiz-only)
@@ -----------------------------------------------------------------------------
@@ Args:
@@  %0 - target object
@@  %1 - name
@@  %2 - optional key
@@ -----------------------------------------------------------------------------
@@ Function definition:
@@  getdata(target, name)
@@  getdata(target, name, key)
@@ -----------------------------------------------------------------------------
@@ Results: The value of the dbref/name/key
@@ -----------------------------------------------------------------------------

&f.globalpp.getdata DSF=
	case(1,
		not(ulocal(l.canset, %@)),
		#-1 HIGHER PERMISSIONS REQUIRED.,
		%vS,
		ulocal(f.sql-get, %0, %1, %2),
		ulocal(f.parent-get, %0, edit(%1, %b, _), edit(%2, %b, _))
	)

@@ -----------------------------------------------------------------------------
@@ Get proper name of a field (global user function, should be wiz-only)
@@ -----------------------------------------------------------------------------
@@ Args:
@@  %0 - target object
@@  %1 - name
@@  %2 - optional key
@@ -----------------------------------------------------------------------------
@@ Function definition:
@@  getname(target, name)
@@  getname(target, name, key)
@@ -----------------------------------------------------------------------------
@@ Results: The proper, original format of the name, pretty case included.
@@ -----------------------------------------------------------------------------

&f.globalpp.getname DSF=
	case(1,
		not(ulocal(l.canset, %@)),
		#-1 HIGHER PERMISSIONS REQUIRED.,
		%vS,
		ulocal(f.sql-get-name, %0, %1, %2),
		ulocal(f.parent-get-name, %0, edit(%1, %b, _), edit(%2, %b, _))
	)

@@ -----------------------------------------------------------------------------
@@ List data by name (global user function, should be wiz-only)
@@ -----------------------------------------------------------------------------
@@ Args:
@@  %0 - target object
@@  %1 - name (optional)
@@  %2 - key (optional)
@@  %3 - name value to search (optional)
@@  %4 - key value to search (optional)
@@ -----------------------------------------------------------------------------
@@ Function definition:
@@  listdata(target, name, key, name value, key value)
@@ -----------------------------------------------------------------------------
@@ Results: A pipe-separated list of names. If a key or key value are searched,
@@ the list will be in Name/Key format, separated by pipes. Partial names, keys,
@@ and values are welcome.
@@ -----------------------------------------------------------------------------

&f.globalpp.listdata DSF=
	case(1,
		not(ulocal(l.canset, %@)),
		#-1 HIGHER PERMISSIONS REQUIRED.,
		%vS,
		ulocal(f.sql-list, %0, %1, %2, %3, %4),
		ulocal(f.parent-list, %0, %1, %2, %3, %4)
	)

@@ -----------------------------------------------------------------------------
@@ Wipe data completely (not just empty it) (global user function, should be
@@ wiz-only)
@@ -----------------------------------------------------------------------------
@@ Args:
@@  %0 - target object
@@  %1 - name
@@  %2 - optional key
@@ -----------------------------------------------------------------------------
@@ Function definition:
@@  wipedata(target, name)
@@  wipedata(target, name, key)
@@ -----------------------------------------------------------------------------
@@ Results: Nothing unless there's an error.
@@ -----------------------------------------------------------------------------

&f.globalpp.wipedata DSF=
	case(1,
		not(ulocal(l.canset, %@)),
		#-1 HIGHER PERMISSIONS REQUIRED.,
		%vS,
		ulocal(f.sql-wipe, %0, %1, %2),
		ulocal(f.parent-wipe, %0, edit(%1, %b, _), edit(%2, %b, _))
	)

@@ -----------------------------------------------------------------------------
@@ Set every attribute no_parse. Won't help if you call the functions using set,
@@ but if you call them directly, they won't interpret your code.
@@ -----------------------------------------------------------------------------

@dolist lattr(DSF/sql.*)=@set DSF/##=no_parse
@dolist lattr(DSF/f.*)=@set DSF/##=no_parse
@dolist lattr(DSF/tr.*)=@set DSF/##=no_parse


@@ -----------------------------------------------------------------------------
@@ All done! Anything past this point is gravy.
@@ -----------------------------------------------------------------------------

@@ -----------------------------------------------------------------------------

@@ And here's a simple tester. All it does is let staff add data to a specified
@@ object, and let players view it.
@@ -
@@ Commands:
@@  +setdata <name>=<value>
@@  +setdata/quiet <name>=<value>
@@  +setdata <name>/<key>=<value>
@@  +setdata/quiet <name>/<key>=<value>
@@  +getdata <name>
@@  +getdata <name>/<key>
@@  +wipedata <name>
@@  +wipedata <name>/<key>
@@  +datastats
@@  +listdata
@@  +listdata <name>
@@  +listdata <name>=<value>
@@  +listdata <name>/<key>
@@  +listdata <name>=<value>/<key>
@@  +listdata <name>/<key>=<value>
@@  +listdata <name>=<value>/<key>=<value>


@create Basic Data Storage Object <BDSO>=10
@set BDSO=safe

@create Data Storage Command Tester <DSCT>=10
@set DSCT=safe inherit

&l.canset DSCT=isstaff(%0)

&l.canget DSCT=1

@fo me=&vD DSCT=[num(BDSO)]
@fo me=&vF DSCT=[num(DSF)]

@@ Get all the data objects.
@@ -
@@ Args:
@@  %0 - target object
@@ Results: List of dbrefs.

&f.list-parents DSCT=if(t(parent(%0)), parent(%0) [ulocal(f.list-parents, parent(%0))])

@@ Set the data loudly.
@@ Format: +setdata name=value
@@ Result: +getdata of the new data.

&cmd-+setdata DSCT=$+setdata *=*:@switch/first 1=strmatch(%0, */*),{},not(ulocal(l.canset, %#)),{@pemit %#=You are not staff and cannot set data.},{@if or(t(setr(0, setdata(%vD, %0, %1))), eq(strlen(%q0), 0)) = @force %#=+getdata %0, @pemit %#=alert() %q0;}

@@ Set the data quietly.
@@ Format: +setdata name=value
@@ Result: Nothing unless there's an error.

&cmd-+setdata/quiet DSCT=$+setdata/quiet *=*:@switch/first 1=strmatch(%0, */*),{}, not(ulocal(l.canset, %#)),{@pemit %#=You are not staff and cannot set data.},{@switch [setr(0, setdata(%vD, %0, %1))]=,{},@pemit %#=alert() %q0;}

@@ Set the key loudly.
@@ Format: +setkey name/key=value
@@ Result: +getdata of the new data.

&cmd-+setkey DSCT=$+setdata */*=*:@switch/first 1=not(ulocal(l.canset, %#)),{@pemit %#=You are not staff and cannot set data.},{@if or(t(setr(0, setdata(%vD, %0, %1, %2))), eq(strlen(%q0), 0)) = @force %#=+getdata %0/%1, @pemit %#=alert() %q0;}

@@ Set the key quietly.
@@ Format: +setdata name/key=value
@@ Result: Nothing unless there's an error.

&cmd-+setkey/quiet DSCT=$+setdata/quiet */*=*:@switch/first 1=not(ulocal(l.canset, %#)),{@pemit %#=You are not staff and cannot set data.},{@switch [setr(0, setdata(%vD, %0, %1, %2))]=,{},@pemit %#=%q0;}

@@ Set the data's new name loudly.
@@ Format: +setname name=new name
@@ Result: +getdata of the new data.

&cmd-+setname DSCT=$+setname *=*:@switch/first 1=strmatch(%0, */*),{},not(ulocal(l.canset, %#)),{@pemit %#=You are not staff and cannot set data names.},{@if or(t(setr(0, setname(%vD, %0, %1))), eq(strlen(%q0), 0)) = @force %#=+getdata %1, @pemit %#=alert() %q0;}

@@ Set the new data name quietly.
@@ Format: +setname name=new name
@@ Result: Nothing unless there's an error.

&cmd-+setname/quiet DSCT=$+setname/quiet *=*:@switch/first 1=strmatch(%0, */*),{},not(ulocal(l.canset, %#)),{@pemit %#=You are not staff and cannot set data names.},{@switch [setr(0, setname(%vD, %0, %1))]=,{},@pemit %#=alert() %q0;}

@@ Set the key's new name loudly.
@@ Format: +setkey name/key=new name
@@ Result: +getdata of the new data.

&cmd-+setkeyname DSCT=$+setname */*=*:@switch/first 1=not(ulocal(l.canset, %#)),{@pemit %#=You are not staff and cannot set key names.},{@if or(t(setr(0, setname(%vD, %0, %1, %2))), eq(strlen(%q0), 0)) = @force %#=+getdata %0/%2, @pemit %#=alert() %q0;}

@@ Set the key's new name quietly.
@@ Format: +setdata name/key=new name
@@ Result: Nothing unless there's an error.

&cmd-+setkeyname/quiet DSCT=$+setname/quiet */*=*:@switch/first 1=not(ulocal(l.canset, %#)),{@pemit %#=You are not staff and cannot set key names.},{@switch [setr(0, setname(%vD, %0, %1, %2))]=,{},@pemit %#=%q0;}

@@ Get the data.
@@ Format: +getdata name
@@ Result: Data or a list of possible names it could be.

&cmd-+getdata DSCT=$+getdata *:@switch/first 1=strmatch(%0, */*), {},
	not(ulocal(l.canget, %#)), {@pemit %#=You are not allowed to get data.},
	t(setr(0, getdata(%vD, %0))),
	{
		@pemit %#=strcat(
			header(getname(%vD, %0)),
			%R%R,
			wrap(if(t(strmatch(%q0, *|*)), itemize(%q0, |), %q0), sub(width(%#), 2), left, %b, %b),
			%R,
			if(
				t(setr(1, listdata(%vD, %0, NULL))),
				strcat(
					%R,
					header(More information),
					iter(%q1, strcat(
						%r,
						wrap(strcat(
							ljust(rest(itext(0), /):, 20),
							ljust(setr(1, getdata(%vD, %0, rest(itext(0), /))), sub(width(%#), 25)),
							if(gt(strlen(%q1), sub(width(%#), 25)), ...)
						), sub(width(%#), 2), left, %b, %b)
					), |, @@)
				)
			),
			%R,
			footer()
		);
	},
	and(eq(words(setr(1, listdata(%vD, %0)), |), 1), t(%q1)), {@force %#=+getdata %q1;},
	{@pemit %#=strcat(
		alert(),
		%b,
		%0 not found.,
		if(
			t(%q1),
			strcat(
				%b,
				Did you mean,
				%b,
				itemize(%q1, |, or),
				?
			)
		)
	);}

@@ Get a key.
@@ Format: +getdata name/key
@@ Result: Data or a list of possible keys it could be.

&cmd-+getkey DSCT=$+getdata */*:@switch/first 1=not(ulocal(l.canget, %#)), {@pemit %#=You are not allowed to get data.}, t(setr(0, getdata(%vD, %0, %1))), {@pemit %#=[strcat(header(strcat(getname(%vD, %0), %b-%b, getname(%vD, %0, %1))), %R, wrap(%q0, sub(width(%#), 2), left, %b, %b), %R, footer())];}, and(t(setr(1, listdata(%vD, %0, %1))), eq(words(%q1, |), 1)), {@force %#=+getdata %q1;}, {@pemit %#=[strcat(alert(), %b, %0/%1 not found., if(t(%q1), %bDid you mean: [itemize(%q1, |, or)]?))];}

@@ Maybe wipe data.
@@ Format: +wipedata name
@@ Result: Error or "are you sure"

&cmd-+wipedata DSCT=$+wipedata *:@switch/first 1=strmatch(%0, */*), {}, strmatch(%0, *=YES), {}, not(ulocal(l.canset, %#)), {@pemit %#=You are not staff and cannot wipe data.}, not(t(setr(N, getname(%vD, %0)))), {@pemit %#=alert() Could not find %0! You must use the exact name.;}, {@pemit %#=alert(WARNING) You are about to delete %qN[if(t(setr(1, listdata(%vD, %qN, NULL))),%, which has [words(%q1, |)] keys)]. Are you sure? If so, type +wipedata %qN=YES; &_wipedata %#=%qN|[secs()];}

@@ Maybe wipe a key.
@@ Format: +wipedata name/key
@@ Result: Error or "are you sure"

&cmd-+wipekey DSCT=$+wipedata */*:@switch/first 1=strmatch(%1, *=YES), {}, not(ulocal(l.canset, %#)), {@pemit %#=You are not staff and cannot wipe data.}, not(t(setr(N, getname(%vD, %0, %1)))), {@pemit %#=alert() Could not find %0/%1! You must use the exact name and key.;}, {@pemit %#=alert(WARNING) You are about to delete the [setr(0, getname(%vD, %0))] key '[setr(1, getname(%vD, %0, %1))]'. Are you sure? If so, type +wipedata %q0/%q1=YES; &_wipedata %#=%q0/%q1|[secs()];}

@@ Wipe the data.
@@ Format: +wipedata name=YES OR +wipedata/unsafe name
@@ Result: Error or success

&cmd-+wipedata/unsafe DSCT=$+wipedata* *:@switch/first 1=strmatch(%1, */*), {}, not(ulocal(l.canset, %#)), {@pemit %#=You are not staff and cannot wipe data.}, or(and(strmatch(%1, *=YES), hasattr(%#, _wipedata), match(first(setr(0, xget(%#, _wipedata)), |), first(%1, =), |), lt(sub(secs(), rest(%q0, |)), 300)), match(%0, /unsafe)), {@trigger me/tr.wipedata=first(%1, =), %#;}, or(strmatch(%1, *=YES), match(%0, /unsafe)), {@pemit %#=alert() Could not delete your data. You need to either type +wipedata [first(%1, =)] or +wipedata/unsafe.;}

&tr.wipedata DSCT=@eval strcat(setr(N, getname(%vD, %0)), setr(K, listdata(%vD, %0, NULL))); @if or(t(setr(0, wipedata(%vD, %0))), eq(strlen(%q0), 0)) = @pemit %1=alert() The data on '%qN'[if(t(%qK), %band all [words(%qK, |)] of its keys)] has been wiped., @pemit %1=alert() %q0;

@@ Wipe the key.
@@ Format: +wipedata name/key=YES OR +wipedata/unsafe name/key
@@ Result: Error or success

&cmd-+wipekey/unsafe DSCT=$+wipedata* */*:@switch/first 1=not(ulocal(l.canset, %#)), {@pemit %#=You are not staff and cannot wipe data.}, or(and(strmatch(%2, *=YES), hasattr(%#, _wipedata), match(first(setr(0, xget(%#, _wipedata)), |), %1/[first(%2, =)], |), lt(sub(secs(), rest(%q0, |)), 300)), match(%0, /unsafe)), {@trigger me/tr.wipekey=%1, first(%2, =), %#;}, or(strmatch(%2, *=YES), match(%0, /unsafe)), {@pemit %#=alert() Could not delete your key. You need to either type +wipedata %1/[first(%2, =)] or +wipedata/unsafe %1/[first(%1, =)].;}

&tr.wipekey DSCT=@eval strcat(setr(N, getname(%vD, %0)), setr(K, getname(%vD, %0, %1))); @if or(t(setr(0, wipedata(%vD, %0, %1))), eq(strlen(%q0), 0)) = @pemit %2=alert() The data on '%qN' in '%qK' has been wiped., @pemit %2=alert() %q0;

@@ Trigger: show a list of data.
@@ Arguments:
@@ %0 - person to show list to
@@ %1 - list to display
@@ %2 - name searched
@@ %3 - value searched
@@ %4 - key searched
@@ %5 - key value searched

&tr.showlist DSCT=@pemit %0=strcat(
	header(squish(trim(strcat(
		Search,
		%b,
		if(t(%2), names starting with '%2', all names),
		%b,
		if(t(%3), containing text '%3'),
		if(
			or(t(%4), t(%5)),
			strcat(
				%b, for, %b,
				if(t(%4), keys starting with '%4', all keys),
				%b,
				if(t(%5), containing text '%5')
			)
		)
	)))),
	%R,
	setq(0, sub(width(%0), 2)),
	setq(1, sub(%q0, 2)),
	wrap(
		table(%1,
			if(
				lt(setr(2, div(%q1, 3)), 10),
				div(%q1, 2),
				%q2
			),
			%q1,
			|
		),
		%q0,
		l,
		%b
	),
	%R,
	footer()
)

@@ Search the data.
@@ Format: +listdata
@@ Result: Show data.

&cmd-+listdata DSCT=$+listdata:@switch/first 1=t(setr(0, listdata(%vD))), {@trigger me/tr.showlist=%#, %q0;}, {@pemit %#=alert() No data found.;}

@@ Search the data.
@@ Format: +listdata <name>
@@ Result: Show data.

&cmd-+listdata_name DSCT=$+listdata *:@switch/first 1=strmatch(%0, */*), {}, strmatch(%0, *=*), {}, t(setr(0, listdata(%vD, %0))), {@trigger me/tr.showlist=%#, %q0, %0;}, {@pemit %#=alert() No data found.;}

@@ Search the data.
@@ Format: +listdata <name>/<key>
@@ Result: Show data.

&cmd-+listdata_key DSCT=$+listdata */*:@switch/first 1=or(strmatch(%0, *=*), strmatch(%1, *=*)), {}, t(setr(0, listdata(%vD, %0, %1))), {@trigger me/tr.showlist=%#, %q0, %0,, %1;}, {@pemit %#=alert() No data found.;}

@@ Search the data.
@@ Format: +listdata <name>=<value>
@@ Result: Show data.

&cmd-+listdata_name_search DSCT=$+listdata *=*:@switch/first 1=or(strmatch(%0, */*), strmatch(%1, */*)), {}, t(setr(0, listdata(%vD, %0,, %1))), {@trigger me/tr.showlist=%#, %q0, %0, %1;}, {@pemit %#=alert() No data found.;}

@@ Search the data.
@@ Format: +listdata <name>=<value>/<key>
@@ Result: Show data.

&cmd-+listdata_name_search_key DSCT=$+listdata *=*/*:@switch/first 1=strmatch(%2, *=*), {}, t(setr(0, listdata(%vD, %0, %2, %1))), {@trigger me/tr.showlist=%#, %q0, %0, %1, %2;}, {@pemit %#=alert() No data found.;}

@@ Search the data.
@@ Format: +listdata <name>/<key>=<value>
@@ Result: Show data.

&cmd-+listdata_name_key_search DSCT=$+listdata */*=*:@switch/first 1=strmatch(%0, *=*), {}, t(setr(0, listdata(%vD, %0, %1,, %2))), {@trigger me/tr.showlist=%#, %q0, %0,, %1, %2;}, {@pemit %#=alert() No data found.;}

@@ Search the data.
@@ Format: +listdata <name>=<value>/<key>=<value>
@@ Result: Show data.

&cmd-+listdata_name_search_key_search DSCT=$+listdata *=*/*=*:@switch/first 1=t(setr(0, listdata(%vD, %0, %2, %1, %3))), {@trigger me/tr.showlist=%#, %q0, %0, %1, %2, %3;}, {@pemit %#=alert() No data found.;}

@@ Show some data stats.
@@ Format: +datastats
@@ Result: The stats.

&cmd-+datastats DSCT=$+datastats:@switch/first 1=not(ulocal(l.canget, %#)),
	{@pemit %#=You are not allowed to get data.},
	{
		@pemit %#=
		strcat(
		[header()],
		%RBase object: %vD,
		if(
			xget(%vF, vS),
			strcat(
				%R[header(SQL mode)],
				%RTotal DBref/Name combinations stored:,
				%b,
				sql(SELECT COUNT(DISTINCT Name, DBref) FROM tblDataValues WHERE DBref='%vD'),
				%RTotal DBref/Name/Key combinations stored:,
				%b,
				sql(SELECT COUNT(DISTINCT Name, DataName, DBref) FROM tblKeyValues),
				%R
			),
			strcat(
				%R[header(Parent mode)],
				%RParents: [if(t(setr(P, ulocal(f.list-parents, %vD))), %qP, None)],
				%R[iter(%vD %qP, if(
					t(itext(0)),
					[header()]
					%RName: [name(itext(0))] ([itext(0)])
					%RAttributes: [attrcnt(itext(0))]
					%RObject memory used: [objmem(itext(0))]
					%RTotal names stored: [words(lattr(itext(0)/_N.*))]
					%RTotal keys stored: [words(lattr(itext(0)/_F.*))]%R
				),,@@)]
			)
		),
		[footer()]
		)
	}

@@ -----------------------------------------------------------------------------
@@ AND... tests. Piles and piles of tests.
@@ -
@@ Run these carefully if you do - I found that I'd get @set halt after about 700
@@ commands, so that's my max. YMMV.
@@ -
@@ These run SLOW. This is because they're spammy and hit the rate limiter.
@@ -
@@ Attribute names: 63 characters, max I could fit from my tests without data loss.
@@ Data: 7830 characters, max I could fit, again without data loss.
@@ -
@@ Data loss on MUX looks like the tail end of an attribute or value being cut off,
@@ which is why I'm working with known data below. It gets weird with accent
@@ characters and code interpretations and even the names of objects, which is
@@ why the limits are so fuzzy.

/*

+setdata Balloon=A big red balloon with an unusually straight white cord.
+setdata Balloon/Size=18"
+setdata Balloon/Color=Red
+setdata Balloon/Owner=Pennywise
+setdata Balloon/Purpose=Terror
+setdata Balloon/Type=Weapon
+setdata Balloon/Tally=Unknown

+getdata Balloon
+getdata Balloon/*
+getdata Balloon/NULL
+getdata Balloon/c
+getdata Balloon/asdf
+getdata Balloon/color

+setdata Hockey Stick=A hockey stick with a bit of blood on it.
+setdata Hockey Stick/Size=Standard
+setdata Hockey Stick/Color=White
+setdata Hockey Stick/Owner=Casey Jones
+setdata Hockey Stick/Purpose=Vigilante justice
+setdata Hockey Stick/Type=Weapon
+setdata Hockey Stick/Tally=Lots

+getdata Hockey
+getdata /type

+listdata
+listdata b
+listdata b=straight
+listdata b=crooked
+listdata /type=weapon
@force me=th listdata(#21) - bunch of names
@force me=th listdata(#21, bal) - one name
@force me=th listdata(#21, b,, straight) - one name
@force me=th listdata(#21, b,, crooked) - nothing
@force me=th listdata(#21, b, typ,, wea) - one name and key
@force me=th listdata(#21, b, typ,, pen) - nothing
@force me=th listdata(#21, NULL, typ,, wea) - two names and keys


+wipedata Balloon
+wipedata/unsafe Hockey Stick

+setdata Ability=Strength|Dexterity|Constitution|Intelligence|Wisdom|Charisma
+setdata Ability/Type=Integer
+setdata Ability/Max=18 at 1st level

+setdata Strength=Strength measures muscle and physical power. A character with a Strength score of 0 is unconscious. Your character's Strength modifier is factored into the following:%R%R%T- Melee attack rolls and attack rolls made with thrown weapons (such as grenades).%R%T- Damage rolls when using melee weapons or thrown weapons (but not grenades).%R%T- Athletics skill checks.%R%T- Strength checks (for breaking down doors and the like).%R%T- How much gear your character can carry.
+setdata Strength/Abbreviation=Str

+setdata Dexterity=Dexterity measures agility, balance, and reflexes. A character with a Dexterity score of 0 is unconscious. Your character's Dexterity modifier is factored into the following:%R%R%T- Ranged attack rolls, such as those made with projectile weapons and energy weapons, as well as some Spells.%R%T- Energy Armor Class (EAC) and Kinetic Armor Class (KAC).%R%T- Reflex saving throws (for leaping out of harm's way).%R%T- Acrobatics, Piloting, Sleight of Hand, and Stealth skill checks.
+setdata Dexterity/Abbreviation=Dex

+setdata Constitution=Constitution represents your character's health. A living creature whose Constitution score reaches 0 dies. Your character's Constitution modifier is factored into the following:%R%R%T- Stamina Points: Stamina points represent the damage your character can shrug off before it starts to be a problem. If this score changes enough to alter its modifier, your character's Stamina Points increase or decrease accordingly.%R%T- Fortitude saves (to resist diseases, poisons, and similar threats).
+setdata Constitution/Abbreviation=Con

+setdata Intelligence=Intelligence represents how well your character learns and reasons, and is often associated with knowledge and education. Animals have Intelligence scores of 1 or 2, and any creature capable of understanding a language has a score of at least 3. A character with an Intelligence score of 0 is unconscious. Your character's Intelligence modifier is factored into the following:%R%R%T- The number of bonus languages your character knows at the start of the game. Even if this modifier is a penalty, your character can still use her starting languages unless her Intelligence score is lower than 3.%R%T- The number of skill ranks gained each level, though your character always gets at least 1 skill rank per level.%R%T- Computers, Culture, Engineering, Life Science, Medicine, Physical Science, and some Profession skill checks.%R%T- Bonus technomancer Spells. The minimum Intelligence score needed to cast a technomancer Spell is 10 + the Spell's level.
+setdata Intelligence/Abbreviation=Int

+setdata Wisdom=Wisdom describes a character's common sense, intuition, and willpower. A character with a Wisdom score of 0 is unconscious. Your character's Wisdom modifier is factored into the following:%R%R%T- Will saving throws (for defending against things like magical mind control).%R%T- Mysticism, Perception, Sense Motive, Survival, and some Profession skill checks.%R%T- Bonus mystic Spells. The minimum Wisdom score needed to cast a mystic Spell is 10 + the Spell's level.
+setdata Wisdom/Abbreviation=Wis

+setdata Charisma=Charisma measures a character's personality, personal magnetism, ability to lead, and appearance. A character with a Charisma score of 0 is unconscious. Your character's Charisma modifier is factored into the following:%R%R%T- Bluff, Diplomacy, Disguise, Intimidate, and some Profession skill checks.%R%T- Checks that represent attempts to influence others, including the envoy's Extraordinary abilities.
+setdata Charisma/Abbreviation=Cha

+setdata Skill=Acrobatics|Athletics|Bluff|Computers|Culture|Diplomacy|Disguise|Engineering|Intimidate|Life Science|Medicine|Mysticism|Perception|Piloting|Profession|Sense Motive|Sleight of Hand|Stealth|Survival

+setdata Acrobatics=You can keep your balance while traversing narrow or treacherous surfaces, escape from restraints, and tumble to avoid attacks. You also use Acrobatics to determine the success of difficult maneuvers while flying.
+setdata Acrobatics/Attribute=Dexterity
+setdata Acrobatics/Balance=As part of a move action, you can use Acrobatics to move across narrow surfaces and uneven ground without falling. A successful check allows you to move at half your land speed across such a surface. While balancing, you are flat-footed. If you fail the Acrobatics check to begin moving across a narrow surface or uneven ground, your move action ends at the point just before you'd need to begin balancing. If you fail the check while already balancing (having succeeded on a previous turn), you fall prone and the GM may rule that you start falling, depending on the type of surface you are moving across.%R%RIf you take damage while balancing, you must immediately attempt an Acrobatics check at the initial DC. On a success, you remain balancing (and can continue to move if it is your turn). If you fail, you fall prone and, depending on the type of surface you are balancing upon, the GM can rule that you start falling. You can't take 20 on Acrobatics checks to balance.%R%RThe DCs for Acrobatics checks to balance are based on the width of the surface you are traversing, but can also be adjusted based on environmental circumstances such as slope and surface conditions. Such modifiers are cumulative; use all that apply.%R%R%TSurface Width%T%T%TDC%R%TGreater than 3 feet wide*%T0%R%T3-1 feet wide*%T%T%T5%R%T11-7 inches wide%T%T10%R%T6-2 inches wide%T%T%T15%R%TLess than 2 inches wide%T%T20%R* No Acrobatics check is needed to move across these surfaces unless a DC modifier (see the table below) increases the DC to 10 or higher.%R%TCircumstance*%T%T%T%T%TDC Modifier%R%TSlightly obstructed (gravel, sand)%T%T+2%R%TSeverely obstructed (cavern, rubble)%T%T+5%R%TSlightly slippery (wet)%T%T%T%T+2%R%TSeverely slippery (icy)%T%T%T%T+5%R%TSlightly sloped (<45 degrees)%T%T%T+2%R%TSeverely sloped (>45 degrees)%T%T%T+5%R%TSlightly unsteady (rough spaceflight)%T%T+2%R%TModerately unsteady (jostled spacecraft)%T+5%R%TSeverely unsteady (earthquake)%T%T%T+10%R* These circumstances apply to the balance and tumble tasks of Acrobatics and the jump task of Athletics.


+getdata ability
+getdata a


@@ MORE TESTING.

&tr.test-keys me=@dolist lnum(%0, %1)=+setdata/quiet %2/S.##=[repeat(0123456789, rand(1,10))]

&tr.test-data me=@dolist lnum(%0, %1)={+setdata/quiet [setr(A, L.##.[iter(lnum(rand(sub(sub(60,strlen(##)),3))),pickrand(a b c d e f g h i j k l m n o p q r s t u v w x y z),,@@)])]=[repeat(0123456789, rand(1,10))]; @trigger/quiet #13/tr.test-keys=%0, %1, %qA;}; @switch gt(%1, %2)=1,{@pemit %#=All done! %0 | %1 | %2 |;},{@wait/until 10=@trigger/quiet me/tr.test-data=%1, add(%1, 10), %2;}

@trigger/quiet me/tr.test-data=5450, 5451, 5451

@@ Some integrity checks, substitute DBRefs and character names where appropriate:

@find BDSO
@@ There should be 3-4 BDSO objects.

@@ Now let's randomize the data a little better...

@wait me=+getdata _L.8800.
@dolist/notify lnum(8100, 8800)=+setdata/quiet _L.##.[iter(lnum(rand(sub(59,strlen(##)))),pickrand(a b c d e f g h i j k l m n o p q r s t u v w x y z),,@@)]=[repeat(0123456789, rand(783))]

th xget(#581, _L.8800.LFITQQSANYQJIIXFPVWLYWPIPXQTSUOSWJMRGAMVUZTVVTAQLUQ)

@wait me=+getdata _L.9500.
@dolist/notify lnum(8800, 9500)=+setdata/quiet _L.##.[iter(lnum(rand(sub(59,strlen(##)))),pickrand(a b c d e f g h i j k l m n o p q r s t u v w x y z),,@@)]=[repeat(0123456789, rand(783))]

*/