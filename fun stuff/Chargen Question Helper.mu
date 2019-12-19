@@ Dependencies: alert(), wheader(), wfooter()

@create Background Question Helper <BGQ>=10
@set BGQ=INHERIT COMMANDS

&d.questions-default BGQ=What do you want to accomplish with this character?|How do you see this character's story arc concluding?|Who are your character's living connections? Family, friends, lovers, enemies. Are they PCs or NPCs?|What is your character afraid of?|What does your character hate?|What does your character love?|What disgusts your character?|Is your character local? If not, how long have they been in New Orleans?|Is your character a Signatory of the Accords?

&d.questions-mortal BGQ=wheader(Mortal and mostly-Mortal questions, %0)|Does your character know of the Supernatural?|Has your character ever been hunted or fed upon by a supernatural being (knowingly or not)?|Is your character a member of a Mystery Cult?|If not a Signatory, does your character know of the Accords?

&d.questions-vampire BGQ=wheader(Vampire questions, %0)|Has your character spent any time in Torpor?|Have you ever committed Diablerie? If so, how long ago?|Is your character addicted to vitae?|Does your character have any Vinculi?|[wheader(Touchstones, %0)]|Don't forget to set your Touchstones note - +note/add Touchstones/<details>.

&d.questions-werewolf BGQ=wheader(Werewolf questions, %0)|Why did your character join their tribe?|Has your character ever broken any aspect of the Oath of the Moon?|Did your character know about werewolves before the First Change?|Has your character ever entered Death Rage? If so, did they kill someone they didn't mean to?|[wheader(Frenzy triggers, %0)]|Don't forget to set your Frenzy Triggers note - +note/add Frenzy Triggers/<details>.

&d.questions-changeling BGQ=wheader(Changeling questions, %0)|When did your character enter Arcadia?|What was the nature of your character's durance?|How did your character escape Arcadia?|When did your character escape back to the real world?|Did your character escape with anyone?|[wheader(Touchstones, %0)]|Don't forget to set your Touchstones note - +note/add Touchstones/<details>|You also need a Frailties note if your Wyrd is 2 or higher. +note/add Frailties/<details>

&d.breaking-points BGQ=wheader(Breaking point questions, %0)|What is the worst thing your character has ever done?|What is the worst thing your character can imagine themself doing?|What is the worst thing your character can imagine someone else doing?|What has the character forgotten? (Clarification: This question is about any hidden secrets the character doesn't know about from their past, supernatural or mundane, that could change their lives or their mental state if they knew about it.)|What is the most traumatic thing that has ever happened to your character?

&d.professional_training BGQ=wheader(Professional training, %0)|Set your Professional Training skills, specialties, etc, in a +note with: +note/add Professional Training/<details>.

&d.mentor BGQ=wheader(Mentor, %0)|Set your Mentor details in a +note with: +note/add Mentor/<details>.

&layout.questions BGQ=edit(strcat(wheader(Background questions, %1), %r, iter(%0, strcat(case(stripansi(mid(itext(0), 0, 1)), .,, %b,, space(3)), itext(0)), |, %R%R), %r%r, wfooter(, %1)), %R%R%R, %R%R)

&f.get-cg-questions BGQ=strcat(u(d.questions-default, %0), |, udefault(me/d.questions-[setr(T, xget(%0, _bio.template))], u(d.questions-mortal, %0), %0), case(%qT, Vampire,, Werewolf,, Changeling,, strcat(|, u(d.breaking-points, %0))), if(t(lattr(%0/_merit.professional_training_(*))), strcat(|, u(d.professional_training, %0))), if(t(lattr(%0/_merit.mentor_(*))), strcat(|, u(d.mentor, %0))))

@desc BGQ=%R%TTo get a list of the questions you'll need to answer in your +bg, type %ch+bgq%cn.%R%R%TThis list is taken from http://nola.orcpie.fun/wiki/index.php/Gamehelp:Character_Creation%R%R%TIf there is ever a difference between the website and this list, go with the website.%R%R%TYou are still expected to read the rest of the wiki, especially the game policies. Please see the last bullet point of this policy regarding references to rape in any context: http://nola.orcpie.fun/wiki/index.php/Game_Policies#Adult_Content%R

&cmd-+bgq BGQ=$+bgq:@assert t(xget(%#, _bio.template))={ @pemit %#=alert(BGQ) You need to choose your template first: stat/template <template> - type 'stat template' for a list of available templates.; };@pemit %#=%R%TBased on your template, if you want the extra 3 XP for answering background questions, you should answer the following questions in your +bg:%R%R[u(layout.questions, u(f.get-cg-questions, %#), %#)]

