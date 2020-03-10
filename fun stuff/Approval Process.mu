/*
Dependencies:
	wheader()
	wfooter()


This is a bit NOLA-specific. Still, the object layout is cool and someone might want to borrow it.


*/

@create Approval Process <AP>=10
@set AP=SAFE

&layout.row-no-values AP=strcat(space(3), ljust(strtrunc(%0, 22), 22), space(4), ljust(strtrunc(%1, 22), 22), space(4), ljust(strtrunc(%2, 22), 22))

&layout.list AP=iter(lnum(add(div(words(%0, if(t(%1), %1, %b)), 3), t(mod(words(%0, if(t(%1), %1, %b)), 3)))), u(layout.row-no-values, u(f.lookup-from-list-of-attributes, %0, itext(0), 0, if(t(%1), %1, %b)), u(f.lookup-from-list-of-attributes, %0, itext(0), 1, if(t(%1), %1, %b)), u(f.lookup-from-list-of-attributes, %0, itext(0), 2, if(t(%1), %1, %b))),, %r)

&f.lookup-from-list-of-attributes AP=if(gte(words(%0, %3), add(mul(%1, 3), %2, 1)), extract(%0, add(mul(%1, 3), %2, 1), 1, %3))

@descformat AP=strcat(wheader(default(title, name(me))), %R%R, wrap(strcat(u(desc)), 74, Left, space(3), space(3)), %r%r, wdivider(More info - +view AP/<view name>), %r, u(layout.list, iter(lattr(me/view-*), titlestr(edit(rest(itext(0), -), _, %b, ~, %b)),, |), |), %r, wfooter())

&title AP=The approval process

@desc AP=What players should do, the short version:%R%R[space(5)]cg/check - make sure there's no red%R[space(5)]+bgadd 1=<answers to background questions if you want 3 extra XP>%R[space(5)]+bgadd 2=<answers to breaking point questions if you are mortal>%R[space(5)]@desc me=<what you look like>%R[space(5)]+note/add <note name>/<note text> - Touchstone, Mentor, etc%R[space(5)]%TMortals also need a Breaking Points note.%R%R[space(5)]cg/submit - when you're ready to roll!%R%R[space(5)]+job/add ##=<how you want to spend your 7 or 10 XP>%R[space(5)]+job/add ##=<what equipment you want>%R%RYou don't have to follow that exact process, but if you do, we'll have what we need when we begin looking you over.

&view-staff_process ap = First, we check %chcg/check%cn. If there's red, there's either a problem or a bug, so we resolve that. Some things we look for manually since cg/check doesn't cover them:%R[space(5)]- Do the specialties make sense?%R[space(5)]- Is the character over 18?%R[space(5)]- Ghouls and Fae-touched only get 5 dots of supernatural merits.%R[space(5)]- Wolves/wolf-bloods can spend merit dots on Rites. Set 'em up and ignore the red, but make sure to let us know so we can count it up manually.%R%RWe check for BG questions. First we check %ch+bg%cn, then %chnotes%cn.%R%RWe check your %ch+sheet%cn for any stats that need notes, like Professional Training and Mentor. We do not care whether your sheet is "twinky" or not - in fact, we'll sometimes suggest stat tweaks for the characters who are supposed to be really, really good at something but whose players might need a hand with the system. If in doubt, ask on the Chargen channel. People are generally happy to suggest ways you can make your PC better at something.%R%RWe check for notes your splat requires, like Touchstone, or any notes from merits on your sheet. All of these will get approved, which prevents them from being changed later.%R%ROn mortals, we check for %chBreaking Point Questions%cn and %chBreaking Points%cn. These are separate from background questions and are mandatory for mortals.%R%RIf you answered the %chBG questions%cn, we give you 10 XP, and if not, 7 XP.%R%RWe ask how you want to %chspend that XP%cn, and do those spends for you. (Your cg/check needs to be all green before we can do this step.)%R%RWe check for a %ch@desc%cn. Doesn't have to be more than a line or even a link, but needs to exist.%R%RWe check to see if you want %chequipment%cn.%R%ROnce all of that is in and there are no outstanding questions, we hit the approve button.

&view-equipment AP=You can buy a few items of your Resources level + 1, plus whatever items make sense for your character at your Resources level or lower. To see a list of the equipment we've got set up, type %ch+eq/list Availability <#>%cn. Note that the +eq list is not complete - if you want something from a book, send us a page reference and we'll add it and get it to you!%R%RPlease note that if you want to use equipment in a plot, you need it in either +eq or an approved note, so this could be important.

&view-notes AP=You're going to need notes. At a minimum, major templates need a Touchstone note, werewolves need Frenzy Triggers, Invictus vampires need either their Oath merit or a note indicating who their oath is to, and some stats require notes. If in doubt, check the book or ask on the Chargen channel. Here are some of the stats that require notes (partial list):%R%R[space(5)]Professional Training%R[space(5)]Mentor%R[space(5)]Staff (check parenthetical - if it's a skill name, no note needed)%R[space(5)]Favored Form%R[space(5)]Safe Place (if it's the name of a known build, no note required)%R[space(5)]Touchstone%R[space(5)]Haven (if the parenthetical in the sheet doesn't make sense)%R[space(5)]Hollow%R[space(5)]Retainer%R[space(5)]Alternate Identity%R[space(5)]Token%R[space(5)]True Friend%R[space(5)]Animal Possession%R[space(5)]Assertive Implement%R[space(5)]Invoke Spirit%R[space(5)]Sacrificial Offering

&view-breaking_points AP=Mortals (and only mortals) need to answer the 5 breaking point questions (http://nola.orcpie.fun/wiki/index.php/Gamehelp:Character_Creation#Breaking_Points_.28Humans_and_Minor_Templates_only.29).%R%RThese are separate from background questions and are mandatory for mortals, even if you're not doing the background questions for extra XP.%R%RTo add your answers to your background, %ch+bgadd <#>=<Breaking Points Questions and answers>%cn.%R%ROnce you've answered those, we will need to figure out your breaking points note from your answers. Staff can help with that part - if you need help generating breaking points, just let us know when you're done writing answers to the questions and we'll take a look and make suggestions.%R%RYou need 5 breaking points which are personalized to your character and which will come up in RP so you can get XP for them. These should not be generic - EVERY mortal gets a breaking point for killing someone. You need something that sets your character off and makes them question everything, something they can't be indifferent to, and that varies for the individual. When you have yours picked, %chnote/add Breaking Points/<your breaking points>%cn.%R%RWhen staff suggests breaking points, we often hit on the following themes:%R- Violence to oneself or others (accidental, purposeful, or because of their actions)%R- Being exposed to a psychological trigger (drugs, abandonment, confinement, a fight)%R- Societal control or lack thereof (chaos, rigid structure, being forced to conform)%R- Taking action or failing to do so in a way that leads to consequences%R- Losing something important (freedom, family, health levels)%R- Facing something they don't want to face (embarrassment, servitude, consequences, getting called out)%R

&view-XP_and_background_qs AP=You get 7 XP if you don't answer the BG questions. (See +bgq in the character generation room for a list.) You get 10 XP if you do answer them.%R%RIf you're going to answer, keep it to just a few sentences and try to give us more than "I try not to think about this" for the one about how your character's story might end. We get a lot of that, but the question is there for a reason. (Also, we'd love to see a few more people answer 'yes' about diablerie...)%R%RSome of the BG Questions can be answered with a simple yes or no, and that is expected. You don't have to pad your answers unless there's more info to give.%R%RIf you find yourself writing an essay, stop and re-evaluate. Staff will cry if we have to read too much. We're saving our eyes for the books, sorry!

&view-description AP=%ch@desc me=<something>%cn - that something might be a link to a picture, a one-line description, a wall of text, whatever. Use %%R to add line breaks and %%T to add tabs. The only thing we're looking for is that you have one and that it follows our policies.%R%RIf you're playing a Changeling, you'll probably want to section your description out into Mask and Mien, but you don't have to - some Changelings hide their Miens even from their own kind.

&view-adult_content AP=Below is a partial rendering of our Adult Content policy. You're required to abide by it whether you've read the whole thing or not. TLDR: Make sure your character is at least 18 years old and do not put sexual assault of any kind in the answers to your background questions. (Yes, sex with people below the age of majority is assault. They cannot legally consent.) You can view the full policy at: http://nola.orcpie.fun/wiki/index.php/Game_Policies#Adult_Content%R%RNOLA is an 18+ game with no exceptions. This is because the World of Darkness, by necessity, contains adult content. Violent and sexual situations will occur, and it is expected that players will deal with them in a mature manner. There are some guidelines as to what we consider appropriate for the game.%R%RTo be extraordinarily clear: please DO NOT MENTION rape, rapists, sexual assault, sexual abuse, sexual abusers, incest, pedophilia, pederasty, pedophiles, or anything else that might be a reference to non-consensual sexual activity in your Background Questions. Can it be in your character's backstory? We literally cannot stop you from having it there. But you cannot inflict this kind of theme on any member of NOLA, player or staff, without their explicit consent. And again: staff explicitly does not consent to this except in cases where it is necessary to adjudicate the game (for example, reporting someone violating this policy).
