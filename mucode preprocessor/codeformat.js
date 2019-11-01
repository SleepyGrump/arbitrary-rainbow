var iPastes=0;
var oEditor;
$(document).ready(function() {
	oEditor=ace.edit("CodeBox");
	oEditor.focus();
	oEditor.setTheme("ace/theme/chaos");
	oEditor.getSession().setMode("ace/mode/mushcode");
	oEditor.getSession().on("paste", function() {
		setTimeout(function() {
			var sCode=oEditor.getValue()+"\n";
			oEditor.setValue(sCode);
		}, 100);
		iPastes++;
		$(".NumPastes").text(iPastes+" entries pasted.");
		$(".NumFormats").text("");
	}
	);
	$("#CodeBox").bind("click", function() { return false; });
	$(window).bind("click", fnSelectCode)
	$("#UndoButton").prop("disabled", true);
}
);
	
function fnCountCharacters(sString, sCharacter) {
	if (sString.indexOf(sCharacter) == -1) return 0;
	var sModifiedString=sString.replace(new RegExp("\\\\\\"+sCharacter, "g"), "<"+escape(sCharacter)+">").replace(new RegExp("%\\"+sCharacter, "g"), "<"+escape(sCharacter)+">");
	return sModifiedString.split(sCharacter).length - 1;
}

function fnExplodeCode() {
	fnFormatCode("No framing");
	var aBreakAfter=[",", ";", "=", "{", "[", "("];
	var aBreakBefore=["}", "]", ")"];

	var sCode=oEditor.getValue();
	if (sCode.length == 0) {
		return;
	}
	var rxpFormatNewlines=/\r|\n/gi;
	while (sCode.match(rxpFormatNewlines)) {
		sCode=sCode.replace(rxpFormatNewlines, "<N>");
	}
	rxpFormatNewlines=/<N><N>/g;
	while (sCode.match(rxpFormatNewlines)) {
		sCode=sCode.replace(rxpFormatNewlines, "<NN>");
	}
	
	for (var j=0; j < aBreakAfter.length; j++) {
		rxpFormatNewlines=new RegExp("(%|\\\\)\\"+aBreakAfter[j], "g");
		while (sCode.match(rxpFormatNewlines)) {
			sCode=sCode.replace(rxpFormatNewlines, "<"+escape(aBreakAfter[j])+">");
		}
	}

	for (var j=0; j < aBreakBefore.length; j++) {
		rxpFormatNewlines=new RegExp("(%|\\\\)\\"+aBreakBefore[j], "g");
		while (sCode.match(rxpFormatNewlines)) {
			sCode=sCode.replace(rxpFormatNewlines, "<"+escape(aBreakBefore[j])+">");
		}
	}

	var aEntries=sCode.split("<NN>");
	var rxpFormatBreaks;
	for (var i=0; i < aEntries.length; i++) {
		for (var j=0; j < aBreakAfter.length; j++) {
			rxpFormatBreaks=new RegExp("\\"+aBreakAfter[j]+"{1}([^(<N>)])", "g");
			while (aEntries[i].match(rxpFormatBreaks)) {
				aEntries[i]=aEntries[i].replace(rxpFormatBreaks, aBreakAfter[j]+"<N>$1");
			}
		}
		for (var j=0; j < aBreakBefore.length; j++) {
			rxpFormatBreaks=new RegExp("(?!<N>)([^>])\\"+aBreakBefore[j]+"{1}", "g");
			while (aEntries[i].match(rxpFormatBreaks)) {
				aEntries[i]=aEntries[i].replace(rxpFormatBreaks, "$1<N>"+aBreakBefore[j]);
			}
		}
		rxpFormatNewlines=/<N><N>/g;
		while (sCode.match(rxpFormatNewlines)) {
			sCode=sCode.replace(rxpFormatNewlines, "<N>");
		}
		var aEntry=aEntries[i].split("<N>");
		var sStringUpToNow="";
		for (var j=0; j < aEntry.length; j++) {
			var iLevel=1;
			var aIndentMatch=sStringUpToNow.match(/\(|\[|\{/g);
			var aOutdentMatch=sStringUpToNow.match(/\)|\]|\}/g);
			if (aIndentMatch != null) iLevel+=aIndentMatch.length;
			if (aOutdentMatch != null) iLevel-=aOutdentMatch.length;
			if (aEntry[j].match(new RegExp("\\"+aBreakBefore.join("|\\")))) iLevel-=1;
			if (iLevel < 1) iLevel=1;
			sStringUpToNow+=sStringUpToNow == "" ? "" : "<N>";
			sStringUpToNow+=sStringUpToNow == "" ? "" : fnIndent(iLevel);
			sStringUpToNow+=aEntry[j].trim();
		}
		aEntries[i]=sStringUpToNow;
	}

	sCode=aEntries.join("<NN>");

	var rxpFormatDoubleBreaks=/<NN>/g;
	while (sCode.match(rxpFormatDoubleBreaks)) {
		sCode=sCode.replace(rxpFormatDoubleBreaks, "\n\n"+'#'.repeat(80)+"\n\n");
	}
	var rxpFormatLineBreaks=/<N>/g;
	while (sCode.match(rxpFormatLineBreaks)) {
		sCode=sCode.replace(rxpFormatLineBreaks, "\n");
	}

	for (var j=0; j < aBreakAfter.length; j++) {
		rxpFormatNewlines=new RegExp("<"+escape(aBreakAfter[j])+">", "g");
		while (sCode.match(rxpFormatNewlines)) {
			sCode=sCode.replace(rxpFormatNewlines, "%"+aBreakAfter[j]);
		}
	}

	for (var j=0; j < aBreakBefore.length; j++) {
		rxpFormatNewlines=new RegExp("<"+escape(aBreakBefore[j])+">", "g");
		while (sCode.match(rxpFormatNewlines)) {
			sCode=sCode.replace(rxpFormatNewlines, "%"+unescape(aBreakBefore[j]));
		}
	}

	sCode="\n"+'#'.repeat(80)+"\n\n"+sCode+"\n\n";

	oEditor.setValue(sCode);
	oEditor.getSession().setScrollTop(0);
	setTimeout(function() {
		oEditor.navigateTo(0, 0);
		oEditor.focus();
	}, 200);
}

function fnIndent(iTabs) {
	var sTabs="";
	var i=0;
	while (i < iTabs) {
		sTabs+="\t";
		i++;
	}
	return sTabs;
}

function fnFormatCode() {
	var sCode=oEditor.getValue();
	if (sCode.length == 0) {
		return;
	}
	$("#CodeBox").attr("PreviousCode", sCode);

	var aExplicitComments=[];
	var aImplicitComments=[];
	var aWeirdCharacters=[];

	var rxpReplaceNulls=/@@\(([^\)]+)\)/gi;
	while (sCode.match(rxpReplaceNulls)) {
		sCode=sCode.replace(rxpReplaceNulls, "null($1)");
	}
	rxpReplaceNulls=/@@\s*\)/gi;
	while (sCode.match(rxpReplaceNulls)) {
		sCode=sCode.replace(rxpReplaceNulls, "null(nothing))");
	}

	var rxpKillComments=/^\/\*([\s\S]*?)\*\//gm;
	var aMatch=sCode.match(rxpKillComments);
	if (aMatch != null) aExplicitComments.push({"type": "/* comments */", "matches": aMatch});
	while (sCode.match(rxpKillComments)) {
		sCode=sCode.replace(rxpKillComments, "");
	}
	rxpKillComments=/^@@[^\r\n]+[\r\n]+/gim;
	aMatch=sCode.match(rxpKillComments);
	if (aMatch != null) aExplicitComments.push({"type": "@@ comments", "matches": aMatch});
	while (sCode.match(rxpKillComments)) {
		sCode=sCode.replace(rxpKillComments, "");
	}
	rxpKillComments=/^\/\/[^\r\n]+[\r\n]+/gim;
	aMatch=sCode.match(rxpKillComments);
	if (aMatch != null) aExplicitComments.push({"type": "// comments", "matches": aMatch});
	while (sCode.match(rxpKillComments)) {
		sCode=sCode.replace(rxpKillComments, "");
	}
	rxpKillComments=/^--[^\r\n]*[\r\n]+/gim;
	aMatch=sCode.match(rxpKillComments);
	if (aMatch != null) aExplicitComments.push({"type": "--comments", "matches": aMatch});
	while (sCode.match(rxpKillComments)) {
		sCode=sCode.replace(rxpKillComments, "");
	}
	rxpKillComments=/^==[^\r\n]*[\r\n]+/gim;
	aMatch=sCode.match(rxpKillComments);
	if (aMatch != null) aExplicitComments.push({"type": "==comments", "matches": aMatch});
	while (sCode.match(rxpKillComments)) {
		sCode=sCode.replace(rxpKillComments, "");
	}
	rxpKillComments=/^th[ink]* [^\r\n]*[\r\n]+/gim;
	aMatch=sCode.match(rxpKillComments);
	if (aMatch != null) aExplicitComments.push({"type": "think code", "matches": aMatch});
	while (sCode.match(rxpKillComments)) {
		sCode=sCode.replace(rxpKillComments, "");
	}

	var rxpKillWeirdChars=/[^A-Za-z 0-9 \.,\?""'!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~\n\r]+/gi;
	aMatch=sCode.match(rxpKillWeirdChars);
	if (aMatch != null) {
		for (var i=0; i < aMatch.length; i++) {
			fnPushToMatchArray(aMatch[i], aWeirdCharacters);
		}
	}
	while (sCode.match(rxpKillWeirdChars)) {
		sCode=sCode.replace(rxpKillWeirdChars, " ");
	}
	
	var aEscapeableCharacters=[",", ";", "=", "{", "[", "(", "}", "]", ")"];
	for (var j=0; j < aEscapeableCharacters.length; j++) {
		rxpKillWeirdChars=new RegExp("%\\"+aEscapeableCharacters[j], "g");
		while (sCode.match(rxpKillWeirdChars)) {
			sCode=sCode.replace(rxpKillWeirdChars, "<"+escape(aEscapeableCharacters[j])+">");
		}
		rxpKillWeirdChars=new RegExp("\\\\\\"+aEscapeableCharacters[j], "g");
		while (sCode.match(rxpKillWeirdChars)) {
			sCode=sCode.replace(rxpKillWeirdChars, "<"+escape(aEscapeableCharacters[j])+">");
		}
	}

	//Anything after a // is a line comment, remove it.
	rxpKillComments=/([^\n]+)\/\/[^\n]+\n/gim;
	aMatch=sCode.match(rxpKillComments);
	if (aMatch != null) {
		if (aImplicitComments==[]) aImplicitComments=aMatch;
		else aImplicitComments=aImplicitComments.concat(aMatch);
	}
	while (sCode.match(rxpKillComments)) {
		sCode=sCode.replace(rxpKillComments, "$1\n");
	}

	var rxpFormatNewlines=/\r|\n/gi;
	while (sCode.match(rxpFormatNewlines)) {
		sCode=sCode.replace(rxpFormatNewlines, "<N>");
	}
	rxpFormatNewlines=/<N><N>/g;
	while (sCode.match(rxpFormatNewlines)) {
		sCode=sCode.replace(rxpFormatNewlines, "<N>");
	}

	var rxpFormatSpaces=/  /gi;
	while (sCode.match(rxpFormatSpaces)) {
		sCode=sCode.replace(rxpFormatSpaces, " ");
	}
	rxpFormatSpaces=/ <N>/g;
	while (sCode.match(rxpFormatSpaces)) {
		sCode=sCode.replace(rxpFormatSpaces, "");
	}
	rxpFormatSpaces=/<N> /g;
	while (sCode.match(rxpFormatSpaces)) {
		sCode=sCode.replace(rxpFormatSpaces, "");
	}
	rxpFormatSpaces=/\{(<N>| )/g;
		while (sCode.match(rxpFormatSpaces)) {
			sCode=sCode.replace(rxpFormatSpaces, "{");
		}
	rxpFormatSpaces=/(<N>| )\}/g;
	while (sCode.match(rxpFormatSpaces)) {
		sCode=sCode.replace(rxpFormatSpaces, "}");
	}
	rxpFormatSpaces=/\((<N>| )/g;
	while (sCode.match(rxpFormatSpaces)) {
		sCode=sCode.replace(rxpFormatSpaces, "(");
	}
	rxpFormatSpaces=/(<N>| )\)/g;
	while (sCode.match(rxpFormatSpaces)) {
		sCode=sCode.replace(rxpFormatSpaces, ")");
	}
	rxpFormatSpaces=/(<N>| )\]/g;
	while (sCode.match(rxpFormatSpaces)) {
		sCode=sCode.replace(rxpFormatSpaces, "]");
	}
	rxpFormatSpaces=/<N>\[/g;
	while (sCode.match(rxpFormatSpaces)) {
		sCode=sCode.replace(rxpFormatSpaces, "[");
	}

	var rxpFormatCommas=/,\s*<N>/gi;
	while (sCode.match(rxpFormatCommas)) {
		sCode=sCode.replace(rxpFormatCommas, ", ");
	}
	rxpFormatCommas=/,<N>/gi;
	while (sCode.match(rxpFormatCommas)) {
		sCode=sCode.replace(rxpFormatCommas, ", ");
	}
	rxpFormatCommas=/,([^\s])/gi;
	while (sCode.match(rxpFormatCommas)) {
		sCode=sCode.replace(rxpFormatCommas, ", $1");
	}
	rxpFormatCommas=/,(<N>| ),/gi;
	while (sCode.match(rxpFormatCommas)) {
		sCode=sCode.replace(rxpFormatCommas, ",,");
	}
	rxpFormatCommas=/,(<N>| )\)/gi;
	while (sCode.match(rxpFormatCommas)) {
		sCode=sCode.replace(rxpFormatCommas, ",)");
	}

	var rxpFormatEqualsBreaks=/=(<N>| )/gi;
	while (sCode.match(rxpFormatEqualsBreaks)) {
		sCode=sCode.replace(rxpFormatEqualsBreaks, "=");
	}
	var rxpFormatAmpersands=/<N>&/g;
	while (sCode.match(rxpFormatAmpersands)) {
		sCode=sCode.replace(rxpFormatAmpersands, "\n\n&");
	}
	var rxpFormatAtSet=/<N>@set/g;
	while (sCode.match(rxpFormatAtSet)) {
		sCode=sCode.replace(rxpFormatAtSet, "\n\n@set");
	}
	var rxpFormatLineBreaks=/<N>/g;
	while (sCode.match(rxpFormatLineBreaks)) {
		sCode=sCode.replace(rxpFormatLineBreaks, "\n\n");
	}

	//Anything not starting with a @ or a & is probably a comment. Nuke it.
	rxpKillComments=/^(?!&|@)[^\n]+/gim;
	aMatch=sCode.match(rxpKillComments);
	if (aMatch != null) {
		if (aImplicitComments==[]) aImplicitComments=aMatch;
		else aImplicitComments=aImplicitComments.concat(aMatch);
	}
	while (sCode.match(rxpKillComments)) {
		sCode=sCode.replace(rxpKillComments, "");
	}

	var rxpKillExtraNewlines=/[\r\n]{3,}/gi;
	while (sCode.match(rxpKillExtraNewlines)) {
		sCode=sCode.replace(rxpKillExtraNewlines, "\n\n");
	}

	rxpReplaceNulls=/null\(nothing\)/gi;
	while (sCode.match(rxpReplaceNulls)) {
		sCode=sCode.replace(rxpReplaceNulls, "@@");
	}
	
	for (var j=0; j < aEscapeableCharacters.length; j++) {
		sCode=sCode.split("<"+escape(aEscapeableCharacters[j])+">").join("%"+aEscapeableCharacters[j]);
	}

	sCode=sCode.trim();

	var iNumFormated=sCode.split("\n\n").length;
	var sFrame1="think Entering "+iNumFormated+" lines.\n\n";
	var sFrame2="\n\nthink Entry complete.";
	if (arguments.length > 0) {
		sFrame1="";
		sFrame2="";
	}
	if (sCode!="") {
		oEditor.setValue(sFrame1+sCode+sFrame2+"\n");
		fnSelectCode();
	}
	else oEditor.setValue("");
	$(".NumFormats").text(iNumFormated+" lines of code returned.");
	
	var iNumCurliesLeft=fnCountCharacters(sCode, "{");
	var iNumCurliesRight=fnCountCharacters(sCode, "}");
	var iNumBracketsLeft=fnCountCharacters(sCode, "[");
	var iNumBracketsRight=fnCountCharacters(sCode, "]");
	var iNumParensLeft=fnCountCharacters(sCode, "(");
	var iNumParensRight=fnCountCharacters(sCode, ")");
	var iCreateCount=sCode.indexOf("@create") != -1 ? sCode.match(/@create/gi).length : 0;
	var sBracketCounts="<span";
	if (iNumCurliesLeft != iNumCurliesRight) sBracketCounts+=" class='Error'";
	sBracketCounts+=">";
	sBracketCounts+="{}: "+iNumCurliesLeft+"/"+iNumCurliesRight;
	sBracketCounts+="</span>";
	sBracketCounts+="<span";
	if (iNumBracketsLeft != iNumBracketsRight) sBracketCounts+=" class='Error'";
	sBracketCounts+=">";
	sBracketCounts+="[]: "+iNumBracketsLeft+"/"+iNumBracketsRight;
	sBracketCounts+="</span>";
	sBracketCounts+="<span";
	if (iNumParensLeft != iNumParensRight) sBracketCounts+=" class='Error'";
	sBracketCounts+=">";
	sBracketCounts+="(): "+iNumParensLeft+"/"+iNumParensRight;
	sBracketCounts+="</span>";
	$(".BracketCounts").html(sBracketCounts);
	$(".CreateCounts").html(iCreateCount+" object creations found.").toggleClass("Warning", iCreateCount > 0);

	var sSnipCounts="";
	sSnipCounts+="<span class='";
	if (aExplicitComments.length > 0) sSnipCounts+="Container";
	sSnipCounts+="'><span class='Title'>Types of explicitly defined comments removed: "+aExplicitComments.length+"</span>";
	if (aExplicitComments.length > 0) {
		for (var i=0; i < aExplicitComments.length; i++) {
			if (aExplicitComments[i] != null) {
				sSnipCounts+="<span class='DetailedNote'><span class='Title'>"+aExplicitComments[i].type+": "+aExplicitComments[i].matches.length+"</span>";
				sSnipCounts+="<span class='Collapsed'>";
				for (var j=0; j < aExplicitComments[i].matches.length; j++) {
					sSnipCounts+="<span class='Indent'>"+aExplicitComments[i].matches[j].replace(/</g, "&lt;").replace(/>/g, "&gt;")+"</span>";
				}
				sSnipCounts+="</span></span>";
			}
		}
	}
	sSnipCounts+="</span><span class='";
	if (aImplicitComments.length > 0) sSnipCounts+="Container Warning";
	sSnipCounts+="'><span class='Title'>Implicit comments removed: "+aImplicitComments.length+"</span>";
	if (aImplicitComments.length > 0) {
		sSnipCounts+="<span class='Collapsed'>";
		for (var i=0; i < aImplicitComments.length; i++) {
			sSnipCounts+="<span class='Indent'>"+aImplicitComments[i].replace(/</g, "&lt;").replace(/>/g, "&gt;")+"</span>";
		}
		sSnipCounts+="</span>";
	}
	sSnipCounts+="</span><span class='";
	if (aWeirdCharacters.length > 0) sSnipCounts+="Container";
	sSnipCounts+="'><span class='Title'>Weird characters replaced with space: "+aWeirdCharacters.length+"</span>";
	if (aWeirdCharacters.length > 0) {
		sSnipCounts+="<span class='Collapsed'>";
		for (var i=0; i < aWeirdCharacters.length; i++) {
			sSnipCounts+="<span class='Indent'>"+fnInterpretKnownWeirdCharacters(aWeirdCharacters[i].match)+": "+aWeirdCharacters[i].count+"</span>";
		}
		sSnipCounts+="</span></span>";
	}
	sSnipCounts+="</span>";
	$(".SnipCounts").html(sSnipCounts);

	var sWarnings="";
	aMatch=sCode.match(/(\#\d+)/g);
	var aWarnings=[];
	if (aMatch != null)
	for (var i=0; i < aMatch.length; i++) {
		fnPushToMatchArray(aMatch[i], aWarnings);
	}
	if (aWarnings.length > 0) sWarnings+="<span class='Title'>Explicit DB references found! Make sure they match what's on your game or things will break.</span>";
	var rxpConjoinedCode=/[^\n\r]&/g;
	while (oMatch = rxpConjoinedCode.exec(sCode)) {
		if (sCode.substr(oMatch.index - 30, 30).indexOf("@fo") != -1) continue;
		fnPushToMatchArray(oMatch, aWarnings);
	}
	rxpConjoinedCode=/[^\n\r]@/g;
	while (oMatch = rxpConjoinedCode.exec(sCode)) {
		if (sCode.substr(oMatch.index + 1, 2) == "@@") continue;
		fnPushToMatchArray(oMatch, aWarnings);
	}
	rxpConjoinedCode=/\)[^\n\r\(\[\,\%\=]+\(/g;
	while (oMatch = rxpConjoinedCode.exec(sCode)) {
		fnPushToMatchArray(oMatch, aWarnings);
	}
	rxpConjoinedCode=/thenomain/gi;
	while (oMatch = rxpConjoinedCode.exec(sCode)) {
		fnPushToMatchArray(oMatch, aWarnings);
	}
	if (aWarnings.length > 0) sWarnings+="<span class='Title'>Potential conjoined code caught! Please check to make sure the code translated OK!</span>";
	for (var i=0; i < aWarnings.length; i++) {
		sWarnings+="<span class='Indent'>"+aWarnings[i].match+": "+aWarnings[i].count+"</span>";
	}
	$(".Warnings").html(sWarnings);

	$(".Container").unbind("click").bind("click", function() {
		var aDetails=$(this).find(".DetailedNote").toggle();
		if (aDetails.length <= 0) $($(this).children()[1]).toggleClass("Collapsed");
		return false;
	});

	$(".DetailedNote").toggle(false).unbind("click").bind("click", function() {
		$($(this).children()[1]).toggleClass("Collapsed");
		return false;
	});

	$("#UndoButton").prop("disabled", false);
	iPastes=0;
}
function fnInterpretKnownWeirdCharacters(sCharacter) {
	switch (sCharacter) {
		case "\t":
			return "tab";
		break;
	}
	switch (sCharacter.charCodeAt(0)) {
		case 9:
			return "tab";
		break;
	}
	return "\""+sCharacter+"\" ("+sCharacter.charCodeAt(0)+")";
}
function fnPushToMatchArray(sMatch, aArray) {
	for (var i=0; i < aArray.length; i++) {
		if (
		typeof sMatch == "string" && (
		(sMatch.trim(sMatch.substring(0, 1)) == "" && aArray[i].match.charCodeAt(0) == sMatch.charCodeAt(0))
		||
		(aArray[i].match == sMatch)
		)
		) {
			aArray[i].count++;
			return;
		}
	}
	aArray.push({"match": sMatch, "count": 1});
}

function fnUndoFormat() {
	oEditor.setValue($("#CodeBox").attr("PreviousCode"));
	fnSelectCode();
	$(".NumFormats").text("0 entries formatted. Format was undone.");
	$("#UndoButton").prop("disabled", true);
	$(".BracketCounts").empty();
	$(".SnipCounts").empty();
}

function fnSelectCode() {
	oEditor.selectAll();
	oEditor.focus();
}