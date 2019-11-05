/*
================================================================================

WORK IN PROGRESS. But should drop in cleanly. Just... well, expect bugs and read the text below. ALL the text, not just this section.

Currently working on:

- Need to figure out how "Out of seeming benefits" work for XP costs. Should be 1.

================================================================================

This is a COMPILED version of the following files, code credit to Thenomain:

https://github.com/thenomain/GMCCG/blob/master/Z%20-%20Game%20Lines/Changeling%20the%20Lost/CtL1%20-%20Core.txt

https://github.com/thenomain/GMCCG/blob/master/Z%20-%20Game%20Lines/Changeling%20the%20Lost/CtL2%20-%20Conditions%20and%20Tilts.txt

https://github.com/thenomain/GMCCG/blob/master/Z%20-%20Game%20Lines/Changeling%20the%20Lost/CtL3%20-%20Clarity%20System.txt

This file was created on 2019-11-04. Future versions will be updated to the newest date OF THE SOURCE MATERIAL. (Not the date I worked on it.) This will help bug fixers hunt down which commits may not be included in the output.

================================================================================

There are some changes below from the base code:

- Added CG checks. (These are currently testing-in-progress. Bugs are expected.)

- Changed every reference re: ghouls and vampires, to fae-touched and changelings.

- Threw in some very basic Contract checks, not sure I got those right.

- Did the XP thing, including the super-favored type of contracts.

- Added "favored regalia" and changed the OLD "favored regalia" to "seeming regalia". Included chargen checks for it.

- Added "promise" as a bio field for fae-touched

- Added a strcat around the contents of f.allocated.contracts.seeming.

- Changed 'Councelor' to 'Counselor'

- Removed the coded motley item on the sheet, it was being called via v() rather than u() (NOLA's code is old, newer games probably should not do this)

- Made the default of "wyrd" be "1" because having it be derived broke templates for NOLA. Newer installs should use the Thenocode for that value.

- Removed "Frailties" - these will be handled like Kuruth triggers and vampire banes, IE a note.

- Added "Pure Clarity" contract at a player's request

- Added the prereq for Fair Harvest

- Turns out Goblin Debt is available to EVERYONE so I added it to the default Advantages block and set up the regain/spend stuff to not be locked to Changeling/Fae-touched.

- Goblin Debt only goes to 9 according to the book: A changeling can never rack up more than nine Debt points - subsequent points wash right off her. Instead, when she would incur a 10th point, she immediately gains the Hedge Denizen Condition (p. 340).

- NOLA treats attributes as derived values, meaning Vigor/etc automatically add to them. As such, our check for favored attributes must check the original (base) attribute, and the favored attribute matching check needs to snip that little "base_" off the front. This changes the check for chargen attributes juuuuust a little bit. This should not affect anyone's game, as they'll just get "strength" or whatever.
	Actual code change:
		New code: edit(elements(%i0, 2, .), BASE_, )
		Old code: elements(%i0, 2, .)

- NEW STUFF: Created a merit called "Dual Kith" which is balanced for GMC.

================================================================================

Final notes:

	This is confirmed to be without conjoined code from my testing, so such errors can be ignored on the mucode preprocessor.

	This includes one object creation (the clarity system object).

	This is NOT an exact rip of the original Thenocode, since at the time of this file's generation it was not complete.

*/

think Making sure you've got all the objects this stuff goes on. If any of this fails, STOP!

@fo me=&d.sfp me=search(name=Stat Functions Prototype <sfp>)

@fo me=&d.dd me=search(name=Data Dictionary <dd>)

@fo me=&d.dt me=search(name=Data Tags <d:t>)

@fo me=&d.xpas me=search(name=XP Advancement System <xpas>)

@fo me=&d.xpcd me=search(name=XP Cost Database <xpcd>)

@fo me=&d.cg me=search(name=GMC Chargen <cg>)

@fo me=&d.sheet me=search(name=Sheet: Rows)

@fo me=&d.whs me=search(name=WoD Health System <whs>)

@fo me=&d.psrs me=search(name=Pool Spend Regain System <psrs>)

@fo me=&d.nsc me=search(name=Newest Sheet Code <nsc>)

@fo me=&d.sfp [v(d.xpcd)]=search(name=Stat Functions Prototype <sfp>)

think Setting up sheet stuff that might not exist on older games.

&format.block.two-columns [v(d.sheet)]=localize(strcat(setq(w, 39), setq(t, case(%2, name-only, 38, 34)), setq(y, iter(%0, case(%2, name-only, u(display.trait-name-only, %i0, %qt, %qw, flag), ulocal(display.trait-and-value, %i0, %qt, %qw, numeric, .)), |, |)), setq(a, words(%0, |)), setq(b, ceil(fdiv(%qa, 2))), setq(c, lnum(1, %qb)), setq(d, lnum(inc(%qb), inc(%qa))), if(strlen(%1), divider(%1)%r,), vcolumns(%qw:[elements(%qy, %qc, |, |)], %qw:[elements(%qy, %qd, |, |)], |, %b)))

&format.block.two-even-columns [v(d.sheet)]=localize(strcat(setq(w, iter(%0, words(%i0, %r), |)), setq(t, ceil(fdiv(ladd(%qw), 2))), setq(o, ulocal(f.recursion.grouped-columns, first(%qw), rest(%qw), %qt)), setq(1, edit(extract(%0, 1, words(%qo), |), |, %r)), setq(2, edit(extract(%0, inc(words(%qo)), words(%0, |), |), |, %r)), if(strlen(%1), vcolumns([ceil(setr(f, sub(39, fdiv(strlen(%1), 2))))]:%q1, [floor(%qf)]:%q2, %r, %1), vcolumns(39:%q1, 39:%q2, %r))))

&f.recursion.grouped-columns [v(d.sheet)]=case(1, eq(ladd(%0), %2), %0, gt(ladd(%0), %2), extract(%0, 1, dec(words(%0))), ulocal(f.recursion.grouped-columns, cat(%0, first(%1)), rest(%1), %2))

&f.statvalidate.workhorse [v(d.sfp)]=localize(switch(0, u(f.statvalue-good, %1), #-1 VALUE CONTAINS ILLEGAL FORMAT, comp(lcstr(%1), default), strcat(setq(v, get(u(d.data-dictionary)/default.%0)), if(t(%qv), %qv, null(default of <null> will clear stat))), strcat(setq(s, first(get(u(d.data-dictionary)/%0), |)), setq(c, ulocal(f.get-class, %0)), setq(v, case(%qc, flag, if(strmatch(%1,), null(<null>), %qs), list, strcat(setq(e, edit(%1, %b, .)), setq(x, iter(graball(%qe, !*, ., .), ![grab(.%qs, [rest(%i0, !)]*, .)], ., .)), setq(a, iter(setdiff(%qe, %qx, .), grab(.%qs, %i0*, .), ., .)), trim(squish(%qa.%qx, .), b, .)), grab(%qs, %1*, .))), case(%qs, *, %1, #, if(cand(gte(%1, 1), isint(%1)), %1, #-1 VALUE NOT A POSITIVE INTEGER), switch(0, comp(%1,), #-1 VALUE WAS NULL, lt(words(%0, .), 3), %1, strlen(%qv), #-1 VALUE NOT FOUND, %qv)))))

&f.statcheck.normal [v(d.cg)]=localize(strcat(setq(t, if(hasattr([u(d.dd)], %1), 1, #-1 Stat not found)), setq(t, if(cand(t(%qt), strmatch(%0, _*.*_(*))), strcat(setq(i, edit(strip(rest(%0, %(), %)), _, %b)), setq(d, extract(get([u(d.dd)]/%1), 2, 1, |)), case(1, t(member(%qd, *)), 1, and(member(%qd, #), isint(%qi)), 1, t(match(%qd, %qi, .)), 1, #-1 Instance is not valid %(%qi%))), %qt)), setq(v, case(1, and(isnum(%2), t(%3)), add(%2, %3), t(%3), %3, %2)), if(strlen(%qt), ulocal([u(d.sfp)]/f.statvalidate.workhorse, %1, %qv), %qt)))

&f.statcheck [v(d.cg)]=localize(strcat(setq(s, ulocal(v(d.sfp)/f.statpath-without-instance, rest(%1, _))), setq(c, ulocal(v(d.sfp)/f.get-class, %qs)), setq(v, case(%qc, numeric, first(u(%0/%1), .), u(%0/%1))), setq(t, case(1, strmatch(%1, _*.*.*), u(f.statcheck.substat, %0, %1, %2), ulocal(v(d.sfp)/f.hastag?.workhorse, %qs, derived), ulocal(f.statcheck.derived, %0, %1, %qc), strmatch(%qc, list), ulocal(f.statcheck.list, %qs, %qv, %2), ulocal(f.statcheck.normal, %1, %qs, %qv, %2))), if(strlen(%qt), 1, %qt), ., iter(cg-only template other, ulocal(f.prerequisite.%i0, %0, %1, %2),, .)))

think Adding Goblin Debt to EVERYBODY'S sheet.

&advantages.default [v(d.nsc)]=iter(defense weaponry_defense brawl_defense speed initiative size perception goblin_debt [udefault(advantages.[get(%0/_bio.template)], null(null))], ulocal(f.cheat_getstat.with_name, %0, advantage.%i0, numeric),, |)

@dolist search(type=players,eval=[hasattr(##, _bio.template)])={ @set ##=_ADVANTAGE.GOBLIN_DEBT:0; @set ##=_ADVANTAGE.GOBLIN_DEBT_MAXIMUM:9; }

think Creating the Dual Kith merit - house rules for NOLA, skip if you want!

&merit.dual_kith_() [v(d.dd)]=4|Artist.Bright One.Chatelaine.Gristlegrinder.Helldiver.Hunterheart.Leechfinger.Mirrorskin.Nightsinger.Notary.Playmate.Snowskin

&prerequisite.merit.dual_kith_() [v(d.dd)]=if(t(%2), cand(lte(words(lattr(%0/_merit.dual_kith_(*))), 0), u(.is_not, %0, bio.kith, %2)))

&prereq-text.merit.dual_kith_() [v(d.dd)]=Changeling, must be a different kith from your current kith, cannot be taken more than once.

&tags.merit.dual_kith_() [v(d.dt)]=changeling.

think Entering Changeling stuff.

&d.search-order-02-changeling [v(d.sfp)]=contract

&d.search-order-03-changeling [v(d.sfp)]=

&prefix.changeling_-_contracts [v(d.dd)]=contract.

think Creating bio stats.

@fo me=&bio.template [v(d.dd)]=[get(v(d.dd)/bio.template)].Changeling.Fae-Touched

&.max_trait.changeling [v(d.dd)]=advantage.wyrd

&.sphere.changeling [v(d.dd)]=Changeling Fae-Touched

&bio.seeming [v(d.dd)]=Beast.Darkling.Elemental.Fairest.Ogre.Wizened

&tags.bio.seeming [v(d.dt)]=changeling

&bio.kith [v(d.dd)]=Artist.Bright One.Chatelaine.Gristlegrinder.Helldiver.Hunterheart.Leechfinger.Mirrorskin.Nightsinger.Notary.Playmate.Snowskin.

&tags.bio.kith [v(d.dt)]=changeling

&bio.seeming_regalia [v(d.dd)]=case(u(.value, %0, bio.seeming), Beast, Steed, Darkling, Mirror, Elemental, Sword, Fairest, Crown, Ogre, Shield, Wizened, Jewels, ansi(xh, %(Seeming Unset%)))

&default.bio.seeming_regalia [v(d.dd)]=derived

&tags.bio.seeming_regalia [v(d.dt)]=derived.changeling

&bio.favored_regalia [v(d.dd)]=Crown.Jewels.Mirror.Shield.Steed.Sword

&default.bio.favored_regalia [v(d.dd)]=

&tags.bio.favored_regalia [v(d.dt)]=changeling

&bio.court [v(d.dd)]=Spring.Summer.Autumn.Winter.Courtless

&default.bio.court [v(d.dd)]=Courtless

&tags.bio.court [v(d.dt)]=changeling

&bio.motley [v(d.dd)]=*

&tags.bio.motley [v(d.dt)]=changeling.fae-touched

&bio.needle [v(d.dd)]=Bon Vivant.Chess Master.Commander.Composer.Counselor.Daredevil.Dynamo.Protector.Provider.Scholar.Storyteller.Teacher.Traditionalist.Visionary

&tags.bio.needle [v(d.dd)]=changeling

&bio.thread [v(d.dd)]=Acceptance.Anger.Family.Friendship.Hate.Honor.Joy.Love.Memory.Revenge

&tags.bio.thread [v(d.dd)]=changeling

&bio.promise [v(d.dd)]=*

&tags.bio.promise [v(d.dd)]=fae-touched

think Setting up advantages.

@edit [v(d.dt)]/tags.advantage.integrity=$, .fae-touched

&advantage.wyrd [v(d.dd)]=0.1.2.3.4.5.6.7.8.9.10

&default.advantage.wyrd [v(d.dd)]=1

&tags.advantage.wyrd [v(d.dt)]=power.changeling.fae-touched

&advantage.glamour [v(d.dd)]=u(.value_stats, %0, advantage.glamour_maximum)

&default.advantage.glamour [v(d.dd)]=derived

&tags.advantage.glamour [v(d.dt)]=derived.changeling.fae-touched

&advantage.glamour_maximum [v(d.dd)]=if(u(.is_full, %0, bio.template, changeling), elements(10 11 12 13 15 20 25 30 50 75, u(.value, %0, advantage.wyrd)), 10)

&default.advantage.glamour_maximum [v(d.dd)]=derived

&tags.advantage.glamour_maximum [v(d.dt)]=derived.changeling.fae-touched

&advantage.goblin_debt [v(d.dd)]=0.1.2.3.4.5.6.7.8.9

&default.advantage.goblin_debt [v(d.dd)]=0

&tags.advantage.goblin_debt [v(d.dt)]=pool

&notes.advantage.goblin_debt [v(d.dt)]=Gain one point after successfully using a Goblin Contract (see '+help pools')|Staff and STs can use these points when interesting|A changeling can never rack up more than nine Debt points - subsequent points wash right off her. Instead, when she would incur a 10th point, she immediately gains the Hedge Denizen Condition (p. 340).|Anyone can gain Goblin Debt!

&advantage.goblin_debt_maximum [v(d.dd)]=9

&default.advantage.goblin_debt_maximum [v(d.dd)]=9

&tags.advantage.goblin_debt_maximum [v(d.dt)]=pool

&advantage.kenning [v(d.dd)]=if(gt(u(.value_stats, %0, advantage.clarity), fdiv(u(.value_stats, %0, advantage.clarity_maximum), 2)), u(.value_stats, %0, advantage.clarity), n/a)

&default.advantage.kenning [v(d.dd)]=derived

&tags.advantage.kenning [v(d.dt)]=derived.changeling

&notes.advantage.kenning [v(d.dt)]=A player whose character currently suffers Clarity damage in fewer than half her Clarity boxes may make a kenning roll by spending a point of Willpower.|This means you can't spend Willpower on Kenning.

&advantage.perception.changeling [v(d.dd)]=add(if(u(.has, %0, merit.acute_senses), u(.value_stats, %0, advantage.wyrd), mul(2, u(.is_stat, %0, advantage.clarity, advantage.clarity_maximum))), min(0, sub(ceil(fdiv(u(.value_stats, %0, advantage.clarity), 2)), 3)))

think Merit time!

&merit.accute_senses [v(d.dd)]=1

&prerequisite.merit.accute_senses [v(d.dd)]=u(.at_least_one, %0, attribute.wits:3 attribute.composure:3)

&prereq-text.merit.accute_senses [v(d.dd)]=Wits 3+ or Composure 3+

&tags.merit.accute_senses [v(d.dt)]=changeling

&merit.arcadian_metabolism [v(d.dd)]=2

&tags.merit.arcadian_metabolism [v(d.dt)]=changeling

&merit.brownie's_boon [v(d.dd)]=1

&tags.merit.brownie's_boon [v(d.dt)]=changeling

&merit.cloak_of_leaves [v(d.dd)]=3

&prerequisite.merit.cloak_of_leaves [v(d.dd)]=cand(u(.is, %0, bio.court, autumn), u(.at_least, %0, merit.mantle, 3))

&prereq-text.merit.cloak_of_leaves [v(d.dd)]=Autumn Mantle 3+

&tags.merit.cloak_of_leaves [v(d.dt)]=changeling.court.autumn

&merit.cold_hearted [v(d.dd)]=3

&prerequisite.merit.cold_hearted [v(d.dd)]=cand(u(.is, %0, bio.court, winter), u(.at_least, %0, merit.mantle, 3))

&prereq-text.merit.cold_hearted [v(d.dd)]=Winter Mantle 3+

&tags.merit.cold_hearted [v(d.dt)]=changeling.court.winter

&merit.court_goodwill_() [v(d.dd)]=1.2.3.4.5|Spring.Summer.Autumn.Winter

&prerequisite.merit.court_goodwill_() [v(d.dd)]=u(.is_not, %0, bio.court, %1)

&prereq-text.merit.court_goodwill_() [v(d.dd)]=Cannot have Court Goodwill in your own Court.

&tags.merit.court_goodwill_() [v(d.dt)]=changeling.court

&notes.merit.court_goodwill_() [v(d.dt)]=Each court in which a character has Court Goodwill comes with a single dot of Mentor, a changeling who serves as the character's court liaison and helps him understand its rituals, its customs, and its very essence.

&merit.defensive_dreamscaping [v(d.dd)]=2

&tags.merit.defensive_dreamscaping [v(d.dt)]=changeling

&merit.diviner [v(d.dd)]=1.2.3.4.5

&prerequisite.merit.diviner [v(d.dd)]=u(.has_all, %0, attribute.composure:3 attribute.wits:3)

&prereq-text.merit.diviner [v(d.dd)]=Composure 3+, Wits 3+

&tags.merit.diviner [v(d.dt)]=changeling

&merit.dream_warrior [v(d.dd)]=1

&prerequisite.merit.dream_warrior [v(d.dd)]=cand(u(.at_least, %0, advantage.wyrd, 2), u(.at_least_one, %0, attribute.presence:3 attribute.manipulation:3 attribute.composure:3), t(u(.specialty_has, Brawl Weaponry, *)))

&prereq-text.merit.dream_warrior [v(d.dd)]=Wyrd 2+, a Social Attribute 3+, and a Brawl or Weaponry specialty

&tags.merit.dream_warrior [v(d.dt)]=changeling

&merit.dreamweaver [v(d.dd)]=3

&prerequisite.merit.dreamweaver [v(d.dd)]=u(.at_least, %0, advantage.wyrd, 3)

&prereq-text.merit.dreamweaver [v(d.dd)]=Wyrd 3+

&tags.merit.dreamweaver [v(d.dt)]=changeling

&merit.dull_beacon [v(d.dd)]=1.2.3.4.5

&tags.merit.dull_beacon [v(d.dt)]=changeling

&merit.elemental_warrior_() [v(d.dd)]=1.2.3.4.5|*

&prerequisite.merit.elemental_warrior_() [v(d.dd)]=cand(u(.at_least_one, %0, attribute.dexterity:3 attribute.wits:3), u(.at_least_one, %0, skill.brawl:2 skill.firearms:2 skill.weaponry:2), cor(u(.is, %0, bio.seeming, Elemental), u(.has_one, %0, contract.elemental_weapon contract.primal_glory)))

&prereq-text.merit.elemental_warrior_() [v(d.dd)]=Dexterity or Wits 3+; Brawl, Firearms, or Weaponry 2+; Elemental Weapon or Primal Glory (Contracts) or Elemental seeming

&tags.merit.elemental_warrior_() [v(d.dt)]=changeling.style.fighting

&notes.merit.elemental_warrior_() [v(d.dt)]='Type' must be a physical element used by this merit.

&merit.enchanting_performance [v(d.dd)]=1.2.3

&prerequisite.merit.enchanting_performance [v(d.dd)]=u(.at_least_all, %0, attribute.presence:3 skill.expression:3)

&prereq-text.merit.enchanting_performance [v(d.dd)]=Presence 3+, Expression 3+

&tags.merit.enchanting_performance [v(d.dt)]=changeling.style.social

&merit.fae_mount [v(d.dd)]=1.2.3.4.5

&tags.merit.fae_mount [v(d.dt)]=changeling

&merit.faerie_favor [v(d.dd)]=3

&tags.merit.faerie_favor [v(d.dt)]=changeling

&notes.merit.faerie_favor [v(d.dt)]=The character gains the Notoriety Condition among the Lost when she calls in the favor.

&merit.fair_harvest_() [v(d.dd)]=1.2|*

&prerequisite.merit.fair_harvest_() [v(d.dd)]=if(t(%2), lte(words(lattr(%0/_merit.fair_harvest_(*))), 0))

&prereq-text.merit.fair_harvest_() [v(d.dd)]=May only be taken once.

&tags.merit.fair_harvest_() [v(d.dt)]=changeling

&notes.merit.fair_harvest_() [v(d.dt)]='Type' is the emotion harvested.

&merit.firebrand [v(d.dd)]=2

&prerequisite.merit.firebrand [v(d.dd)]=cand(u(.is, %0, bio.court, summer), u(.at_least, %0, merit.mantle, 3))

&prereq-text.merit.firebrand [v(d.dd)]=Summer Mantle 3+

&tags.merit.firebrand [v(d.dt)]=changeling.court.summer

&merit.gentrified_bearing [v(d.dd)]=2

&prerequisite.merit.gentrified_bearing [v(d.dd)]=u(.at_least, %0, advantage.wyrd, 2)

&prereq-text.merit.gentrified_bearing [v(d.dd)]=Wyrd 2+

&tags.merit.gentrified_bearing [v(d.dt)]=changeling.special snowflake

&merit.glamour_fasting [v(d.dd)]=1

&tags.merit.glamour_fasting [v(d.dt)]=changeling

&merit.goblin_bounty [v(d.dd)]=1.2.3.4.5

&tags.merit.goblin_bounty [v(d.dt)]=changeling

&merit.grounded [v(d.dd)]=3

&prerequisite.merit.grounded [v(d.dd)]=cand(u(.is, %0, bio.court, spring), u(.at_least, %0, merit.mantle, 3))

&prereq-text.merit.grounded [v(d.dd)]=Spring Mantle 3+

&tags.merit.grounded [v(d.dt)]=changeling.court.spring

&merit.hedge_brawler [v(d.dd)]=2

&prerequisite.merit.hedge_brawler [v(d.dd)]=u(.at_least_one, %0, skill.brawl:2 skill.firearms:2 skill.weaponry:2)

&prereq-text.merit.hedge_brawler [v(d.dd)]=Brawl, Firearms, or Weaponry 2+

&tags.merit.hedge_brawler [v(d.dt)]=changeling

&merit.hedge_duelist [v(d.dd)]=1.2.3

&prerequisite.merit.hedge_duelist [v(d.dd)]=cand(u(.at_least_one, %0, attribute.presence:2 attribute.manipulation:2), u(.at_least_one, %0, skill.brawl:2 skill.weaponry:2), u(.at_least_one, %0, skill.animal_ken:2 skill.empathy:2 skill.expression:2 skill.intimidation:2 skill.persuasion:2 skill.socialize:2 skill.streetwise:2 skill.subterfuge:2))

&prereq-text.merit.hedge_duelist [v(d.dd)]=Presence or Manipulation 2+, Brawl or Weaponry 2+, any Social Skill 2+

&tags.merit.hedge_duelist [v(d.dt)]=changeling.style.fighting

&merit.hedge_sense [v(d.dd)]=1

&tags.merit.hedge_sense [v(d.dt)]=changeling

&merit.hob_kin [v(d.dd)]=1

&tags.merit.hob_kin [v(d.dt)]=changeling.goblin

&merit.hollow [v(d.dd)]=1.2.3.4.5

&tags.merit.hollow [v(d.dt)]=changeling.location.motley

&notes.merit.hollow [v(d.dt)]=Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.

&merit.mantle [v(d.dd)]=1.2.3.4.5

&tags.merit.mantle [v(d.dt)]=changeling.court

&merit.manymask [v(d.dd)]=3

&prerequisite.merit.manymask [v(d.dd)]=u(.at_least_all, advantage.wyrd:2 attribute.manipulation:3)

&prereq-text.merit.manymask [v(d.dd)]=Wyrd 2+, Manipulation 3+

&tags.merit.manymask [v(d.dt)]=changeling

&merit.market_sense [v(d.dd)]=1

&tags.merit.market_sense [v(d.dt)]=changeling.goblin

&merit.noblesse_oblige [v(d.dd)]=1.2.3

&prerequisite.merit.noblesse_oblige [v(d.dd)]=u(.is_not, %0, bio.court, Courtless)

&prereq-text.merit.noblesse_oblige [v(d.dd)]=Belongs to a Court

&tags.merit.noblesse_oblige [v(d.dt)]=changeling.court

&notes.merit.noblesse_oblige [v(d.dt)]=May be used only with those who share your Court or Court Goodwill|May not be used if Courtless

&merit.pandemoniacal [v(d.dd)]=1.2.3

&prerequisite.merit.pandemoniacal [v(d.dd)]=u(.at_least, %0, advantage.wyrd, 6)

&prereq-text.merit.pandemoniacal [v(d.dd)]=Wyrd 6+

&tags.merit.pandemoniacal [v(d.dt)]=changeling

&merit.parallel_lives [v(d.dd)]=3

&tags.merit.parallel_lives [v(d.dt)]=changeling

&merit.rigid_mask [v(d.dd)]=3

&prerequisite.merit.rigid_mask [v(d.dd)]=u(.at_least, %0, skill.subterfuge, 2)

&prereq-text.merit.rigid_mask [v(d.dd)]=Subterfuge 2+

&tags.merit.rigid_mask [v(d.dt)]=changeling

&notes.merit.rigid_mask [v(d.dt)]=Intentionally dropping your character's Mask deals her a point of lethal damage in addition to the normal rules

&merit.stable_trod [v(d.dd)]=1.2.3.4.5

&tags.merit.stable_trod [v(d.dt)]=changeling.motley

&notes.merit.stable_trod [v(d.dt)]=Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.

&merit.token [v(d.dd)]=#

&tags.merit.token [v(d.dt)]=changeling.motley

&notes.merit.token [v(d.dt)]=Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.

&merit.touchstone [v(d.dd)]=1.2.3.4.5

&tags.merit.touchstone [v(d.dt)]=changeling.changeling

&notes.merit.touchstone [v(d.dt)]=For each dot in this merit, add a +note as to its position and content.

&merit.warded_dreams [v(d.dd)]=1.2.3

&prerequisite.merit.warded_dreams [v(d.dd)]=u(.at_least, %0, attribute.resolve, %2)

&prereq-text.merit.warded_dreams [v(d.dd)]=Resolve equal to or higher than this merit

&tags.merit.warded_dreams [v(d.dt)]=changeling

&merit.workshop [v(d.dd)]=&prerequisite.merit.workshop [v(d.dd)]=u(.has, %0, merit.hollow)

&prereq-text.merit.workshop [v(d.dd)]=Hollow 1+

&tags.merit.workshop [v(d.dt)]=changeling.motley

&notes.merit.workshop [v(d.dt)]=Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.

&merit.dream_shaper [v(d.dd)]=2

&prerequisite.merit.dream_shaper [v(d.dt)]=u(.has, %0, merit.lucid_dreamer)

&prereq-text.merit.dream_shaper [v(d.dt)]=Merit: Lucid Dreamer

&tags.merit.dream_shaper [v(d.dt)]=fae-touched

&merit.expressive [v(d.dd)]=1

&prerequisite.merit.expressive [v(d.dd)]=u(.is_not, %0, bio.template, Changeling)

&prereq-text.merit.expressive [v(d.dd)]=Non-Changeling

&merit.find_the_oathbreaker [v(d.dd)]=2

&prerequisite.merit.find_the_oathbreaker [v(d.dt)]=u(.has, %0, merit.sense_vows)

&prereq-text.merit.find_the_oathbreaker [v(d.dt)]=Merit: Sense Vows

&tags.merit.find_the_oathbreaker [v(d.dt)]=fae-touched

&merit.hedge_delver [v(d.dd)]=2

&prerequisite.merit.hedge_delver [v(d.dt)]=u(.at_least, %0, skill.survival, 2)

&prereq-text.merit.hedge_delver [v(d.dt)]=Survival 2+

&tags.merit.hedge_delver [v(d.dt)]=fae-touched

&merit.oathkeeper [v(d.dd)]=3

&prerequisite.merit.oathkeeper [v(d.dt)]=u(.at_least, %0, attribute.resolve, 3)

&prereq-text.merit.oathkeeper [v(d.dt)]=Resolve 3+

&tags.merit.oathkeeper [v(d.dt)]=fae-touched

&merit.promise_of_debt [v(d.dd)]=1.2.3

&tags.merit.promise_of_debt [v(d.dt)]=fae-touched

&merit.promise_of_love [v(d.dd)]=1.2.3

&tags.merit.promise_of_love [v(d.dt)]=fae-touched

&merit.promise_of_loyalty [v(d.dd)]=3

&tags.merit.promise_of_loyalty [v(d.dt)]=fae-touched

&merit.promise_of_protection [v(d.dd)]=1.2.3.4.5

&tags.merit.promise_of_protection [v(d.dt)]=fae-touched

&merit.promise_to_provide [v(d.dd)]=3

&tags.merit.promise_to_provide [v(d.dt)]=fae-touched

&merit.promise_to_serve [v(d.dd)]=1.2.3

&tags.merit.promise_to_serve [v(d.dt)]=fae-touched

&merit.punish_the_oathbreaker [v(d.dd)]=2

&prerequisite.merit.punish_the_oathbreaker [v(d.dt)]=u(.has, %0, merit.find_the_oathbreaker)

&prereq-text.merit.punish_the_oathbreaker [v(d.dt)]=Merit: Find the Oathbreaker

&tags.merit.punish_the_oathbreaker [v(d.dt)]=fae-touched

&merit.sense_vows [v(d.dd)]=1

&tags.merit.sense_vows [v(d.dt)]=fae-touched

@edit v(d.dt)/tags.merit.allies_()=$, .motley

@fo me=&notes.merit.allies_() [v(d.dt)]=[trim(strcat(get(v(d.dt)/notes.merit.allies_()), |Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.), b, |)]

@edit v(d.dt)/tags.merit.contacts_()=$, .motley

@fo me=&notes.merit.contacts_() [v(d.dt)]=[trim(strcat(get(v(d.dt)/notes.merit.contacts_()), |Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.), b, |)]

&merit.etiquette [v(d.dd)]=1.2.3.4.5

&prerequisite.merit.etiquette [v(d.dd)]=u(.at_least_all, %0, attribute.composure:3 skill.socialize:2)

&prereq-text.merit.etiquette [v(d.dd)]=Composure 3+, Socialize 2+

&tags.merit.etiquette [v(d.dt)]=social.style

&merit.lucid_dreamer [v(d.dd)]=2

&prerequisite.merit.lucid_dreamer [v(d.dd)]=cand(u(.is_not, %0, bio.template, changeling), u(.at_least, %0, attribute.resolve, 3))

&prereq-text.merit.lucid_dreamer [v(d.dd)]=Non-Changeling, Resolve 3+

&tags.merit.lucid_dreamer [v(d.dt)]=mental

@edit v(d.dt)/tags.merit.resources=$, .motley

@fo me=&notes.merit.resources [v(d.dt)]=[trim(strcat(get(v(d.dt)/notes.merit.resources), |Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.), b, |)]

@edit v(d.dt)/tags.merit.safe_place_()=$, .motley

@fo me=&notes.merit.safe_place_() [v(d.dt)]=[trim(strcat(get(v(d.dt)/notes.merit.safe_place_()), |Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.), b, |)]

@edit v(d.dt)/tags.merit.staff_()=$, .motley

@fo me=&notes.merit.staff_() [v(d.dt)]=[trim(strcat(get(v(d.dt)/notes.merit.staff_()), |Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.), b, |)]

@edit v(d.dt)/tags.merit.status_()=$, .motley

@fo me=&notes.merit.status_() [v(d.dt)]=[trim(strcat(get(v(d.dt)/notes.merit.status_()), |Anyone sharing a Changeling Motley with points in this merit gains benefits from all points totaled%, max 5.), b, |)]

think Contracts going in now...

&type.contract.? [v(d.dd)]=flag

&type.contract.?.? [v(d.dd)]=flag

&contract.hostile_takeover [v(d.dd)]=1|Beast.Fairest

&tags.contract.hostile_takeover [v(d.dt)]=changeling.crown.beast.fairest.common

&contract.mask_of_superiority [v(d.dd)]=1|Fairest.Ogre

&tags.contract.mask_of_superiority [v(d.dt)]=changeling.crown.fairest.ogre.common

&contract.paralyzing_presence [v(d.dd)]=1|Darkling.Fairest

&tags.contract.paralyzing_presence [v(d.dt)]=changeling.crown.darkling.fairest.common

&contract.summon_the_loyal_servant [v(d.dd)]=1|Elemental.Fairest

&tags.contract.summon_the_loyal_servant [v(d.dt)]=changeling.crown.elemental.fairest.common

&contract.tumult [v(d.dd)]=1|Fairest.Ogre

&tags.contract.tumult [v(d.dt)]=changeling.crown.fairest.ogre.common

&contract.discreet_summons [v(d.dd)]=1|Darkling.Fairest

&tags.contract.discreet_summons [v(d.dt)]=changeling.crown.darkling.fairest.favored

&contract.mastermind's_gambit [v(d.dd)]=1|Elemental.Fairest

&tags.contract.mastermind's_gambit [v(d.dt)]=changeling.crown.elemental.fairest.favored

&contract.pipes_of_the_beastcaller [v(d.dd)]=1|Beast.Fairest

&tags.contract.pipes_of_the_beastcaller [v(d.dt)]=changeling.crown.beast.fairest.favored

&contract.the_favored_court [v(d.dd)]=1|Fairest.Wizened

&tags.contract.the_favored_court [v(d.dt)]=changeling.crown.fairest.wizened.favored

&contract.spinning_wheel [v(d.dd)]=1|Fairest.Ogre

&tags.contract.spinning_wheel [v(d.dt)]=changeling.crown.fairest.ogre.favored

&contract.blessing_of_perfection [v(d.dd)]=1|Fairest.Wizened

&tags.contract.blessing_of_perfection [v(d.dt)]=changeling.jewels.fairest.wizened.common

&contract.changing_fortunes [v(d.dd)]=1|Ogre.Wizened

&tags.contract.changing_fortunes [v(d.dt)]=changeling.jewels.ogre.wizened.common

&contract.light-shy [v(d.dd)]=1|Darkling.wizened

&tags.contract.light-shy [v(d.dt)]=changeling.jewels.darkling.wizened.common

&contract.murkblur [v(d.dd)]=1|Elemental.Wizened

&tags.contract.murkblur [v(d.dt)]=changeling.jewels.elemental.wizened.common

&contract.trivial_reworking [v(d.dd)]=1|Darkling.Wizened

&tags.contract.trivial_reworking [v(d.dt)]=changeling.jewels.darkling.wizened.common

&contract.changeling_hours [v(d.dd)]=1|Elemental.Wizened

&tags.contract.changeling_hours [v(d.dt)]=changeling.jewels.elemental.wizened.favored

&contract.dance_of_the_toys [v(d.dd)]=1|Beast.Wizened

&tags.contract.dance_of_the_toys [v(d.dt)]=changeling.jewels.beast.wizened.favored

&contract.hidden_reality [v(d.dd)]=1|Fairest.Wizened

&tags.contract.hidden_reality [v(d.dt)]=changeling.jewels.fairest.wizened.favored

&contract.stealing_the_solid_reflection [v(d.dd)]=1|Fairest.Wizened

&tags.contract.stealing_the_solid_reflection [v(d.dt)]=changeling.jewels.fairest.wizened.favored

&contract.tatterdemalion's_workshop [v(d.dd)]=1|Ogre.Wizened

&tags.contract.tatterdemalion's_workshop [v(d.dt)]=changeling.jewels.ogre.wizened.favored

&contract.glimpse_of_a_distant_mirror [v(d.dd)]=1|Beast.Darkling

&tags.contract.glimpse_of_a_distant_mirror [v(d.dt)]=changeling.mirror.beast.darkling.common

&contract.know_the_competition [v(d.dd)]=1|Beast.Darkling

&tags.contract.know_the_competition [v(d.dt)]=changeling.mirror.beast.darkling.common

&contract.portents_and_visions [v(d.dd)]=1|Darkling.Elemental

&tags.contract.portents_and_visions [v(d.dt)]=changeling.mirror.darkling.elemental.common

&contract.read_lucidity [v(d.dd)]=1|Beast.Darkling

&tags.contract.read_lucidity [v(d.dt)]=changeling.mirror.beast.darkling.common

&contract.walls_have_ears [v(d.dd)]=1|Darkling.Wizened

&tags.contract.walls_have_ears [v(d.dt)]=changeling.mirror.darkling.wizened.common

&contract.props_and_scenery [v(d.dd)]=1|Darkling.Ogre

&tags.contract.props_and_scenery [v(d.dt)]=changeling.mirror.darkling.ogre.favored

&contract.reflections_of_the_past [v(d.dd)]=1|Darkling.Fairest

&tags.contract.reflections_of_the_past [v(d.dt)]=changeling.mirror.darkling.fairest.favored

&contract.riddle-kith [v(d.dd)]=1|Darkling.Elemental

&tags.contract.riddle-kith [v(d.dt)]=changeling.mirror.darkling.elemental.favored

&contract.skinmask [v(d.dd)]=1|Darkling.Fairest

&tags.contract.skinmask [v(d.dt)]=changeling.mirror.darkling.fairest.favored

&contract.unravel_the_tapestry [v(d.dd)]=1|Darkling.Wizened

&tags.contract.unravel_the_tapestry [v(d.dt)]=changeling.mirror.darkling.wizened.favored

&contract.cloak_of_night [v(d.dd)]=1|Darkling.Ogre

&tags.contract.cloak_of_night [v(d.dt)]=changeling.shield.darkling.ogre.common

&contract.fae_cunning [v(d.dd)]=1|Elemental.Ogre

&tags.contract.fae_cunning [v(d.dt)]=changeling.shield.elemental.ogre.common

&contract.shared_burden [v(d.dd)]=1|Ogre.Wizened

&tags.contract.shared_burden [v(d.dt)]=changeling.shield.ogre.wizened.common

&contract.thorns_and_brambles [v(d.dd)]=1|Darkling.Ogre

&tags.contract.thorns_and_brambles [v(d.dt)]=changeling.shield.darkling.ogre.common

&contract.trapdoor_spider's_trick [v(d.dd)]=1|Ogre.Wizened

&tags.contract.trapdoor_spider's_trick [v(d.dt)]=changeling.shield.ogre.wizened.common

&contract.fortifying_presence [v(d.dd)]=1|Fairest.Ogre

&tags.contract.fortifying_presence [v(d.dt)]=changeling.shield.fairest.ogre.favored

&contract.hedgewall [v(d.dd)]=1|Beast.Ogre

&tags.contract.hedgewall [v(d.dt)]=changeling.shield.beast.ogre.favored

&contract.vow_of_no_compromise [v(d.dd)]=1|Ogre.Elemental

&tags.contract.vow_of_no_compromise [v(d.dt)]=changeling.shield.ogre.elemental.favored

&contract.whispers_of_morning [v(d.dd)]=1|Ogre.Wizened

&tags.contract.whispers_of_morning [v(d.dt)]=changeling.shield.ogre.wizened.favored

&contract.boon_of_the_scuttling_spider [v(d.dd)]=1|Beast.Darkling

&tags.contract.boon_of_the_scuttling_spider [v(d.dt)]=changeling.steed.beast.darkling.common

&contract.dreamsteps [v(d.dd)]=1|Beast.Fairest

&tags.contract.dreamsteps [v(d.dt)]=changeling.steed.beast.fairest.common

&contract.nevertread [v(d.dd)]=1|Beast.Wizened

&tags.contract.nevertread [v(d.dt)]=changeling.steed.beast.wizened.common

&contract.pathfinder [v(d.dd)]=1|Beast.Wizened

&tags.contract.pathfinder [v(d.dt)]=changeling.steed.beast.wizened.common

&contract.seven-league_leap [v(d.dd)]=1|Beast.Ogre

&tags.contract.seven-league_leap [v(d.dt)]=changeling.steed.beast.ogre.common

&contract.chrysalis [v(d.dd)]=1|Beast.Ogre

&tags.contract.chrysalis [v(d.dt)]=changeling.steed.beast.ogre.favored

&contract.flickering_hours [v(d.dd)]=1|Beast.Elemental

&tags.contract.flickering_hours [v(d.dt)]=changeling.steed.beast.elemental.favored

&contract.leaping_toward_nightfall [v(d.dd)]=1|Beast.Darkling

&tags.contract.leaping_toward_nightfall [v(d.dt)]=changeling.steed.beast.darkling.favored

&contract.mirror_walk [v(d.dd)]=1|Beast.Elemental

&tags.contract.mirror_walk [v(d.dt)]=changeling.steed.beast.elemental.favored

&contract.talon_and_wing [v(d.dd)]=1|Beast.Darkling

&tags.contract.talon_and_wing [v(d.dt)]=changeling.steed.beast.darkling.favored

&contract.cupid's_arrow [v(d.dd)]=1

&tags.contract.cupid's_arrow [v(d.dt)]=changeling.spring.common

&contract.dreams_of_the_earth [v(d.dd)]=1

&tags.contract.dreams_of_the_earth [v(d.dt)]=changeling.spring.common

&contract.gift_of_warm_breath [v(d.dd)]=1

&tags.contract.gift_of_warm_breath [v(d.dt)]=changeling.spring.common

&contract.spring's_kiss [v(d.dd)]=1

&tags.contract.spring's_kiss [v(d.dt)]=changeling.spring.common

&contract.wyrd-faced_stranger [v(d.dd)]=1

&tags.contract.wyrd-faced_stranger [v(d.dt)]=changeling.spring.common

&contract.blessing_of_spring [v(d.dd)]=1

&tags.contract.blessing_of_spring [v(d.dt)]=changeling.spring.favored

&contract.gift_of_warm_blood [v(d.dd)]=1

&tags.contract.gift_of_warm_blood [v(d.dt)]=changeling.spring.favored

&contract.pandora's_gift [v(d.dd)]=1

&tags.contract.pandora's_gift [v(d.dt)]=changeling.spring.favored

&contract.prince_of_ivy [v(d.dd)]=1

&tags.contract.prince_of_ivy [v(d.dt)]=changeling.spring.favored

&contract.waking_the_inner_fae [v(d.dd)]=1

&tags.contract.waking_the_inner_fae [v(d.dt)]=changeling.spring.favored

&contract.baleful_sense [v(d.dd)]=1

&tags.contract.baleful_sense [v(d.dt)]=changeling.summer.common

&contract.child_of_the_hearth [v(d.dd)]=1

&tags.contract.child_of_the_hearth [v(d.dt)]=changeling.summer.common

&contract.helios'_light [v(d.dd)]=1

&tags.contract.helios'_light [v(d.dt)]=changeling.summer.common

&contract.high_summer's_zeal [v(d.dd)]=1

&tags.contract.high_summer's_zeal [v(d.dt)]=changeling.summer.common

&contract.vigilance_of_ares [v(d.dd)]=1

&tags.contract.vigilance_of_ares [v(d.dt)]=changeling.summer.common

&contract.fiery_tongue [v(d.dd)]=1

&tags.contract.fiery_tongue [v(d.dt)]=changeling.summer.favored

&contract.flames_of_summer [v(d.dd)]=1

&tags.contract.flames_of_summer [v(d.dt)]=changeling.summer.favored

&contract.helios'_judgement [v(d.dd)]=1

&tags.contract.helios'_judgement [v(d.dt)]=changeling.summer.favored

&contract.solstice_revelation [v(d.dd)]=1

&tags.contract.solstice_revelation [v(d.dt)]=changeling.summer.favored

&contract.sunburnt_heart [v(d.dd)]=1

&tags.contract.sunburnt_heart [v(d.dt)]=changeling.summer.favored

&contract.autumn's_fury [v(d.dd)]=1

&tags.contract.autumn's_fury [v(d.dt)]=changeling.autumn.common

&contract.last_harvest [v(d.dd)]=1

&tags.contract.last_harvest [v(d.dt)]=changeling.autumn.common

&contract.tale_of_the_baba_yaga [v(d.dd)]=1

&tags.contract.tale_of_the_baba_yaga [v(d.dt)]=changeling.autumn.common

&contract.twilight's_harbinger [v(d.dd)]=1

&tags.contract.twilight's_harbinger [v(d.dt)]=changeling.autumn.common

&contract.witches'_intuition [v(d.dd)]=1

&tags.contract.witches'_intuition [v(d.dt)]=changeling.autumn.common

&contract.famine's_bulwark [v(d.dd)]=1

&tags.contract.famine's_bulwark [v(d.dt)]=changeling.autumn.favored

&contract.mien_of_the_baba_yaga [v(d.dd)]=1

&tags.contract.mien_of_the_baba_yaga [v(d.dt)]=changeling.autumn.favored

&contract.riding_the_falling_leaves [v(d.dd)]=1

&tags.contract.riding_the_falling_leaves [v(d.dt)]=changeling.autumn.favored

&contract.sorcerer's_rebuke [v(d.dd)]=1

&tags.contract.sorcerer's_rebuke [v(d.dt)]=changeling.autumn.favored

&contract.tasting_the_harvest [v(d.dd)]=1

&tags.contract.tasting_the_harvest [v(d.dt)]=changeling.autumn.favored

&contract.the_dragon_knows [v(d.dd)]=1

&tags.contract.the_dragon_knows [v(d.dt)]=changeling.winter.common

&contract.heart_of_ice [v(d.dd)]=1

&tags.contract.heart_of_ice [v(d.dt)]=changeling.winter.common

&contract.ice_queen's_call [v(d.dd)]=1

&tags.contract.ice_queen's_call [v(d.dt)]=changeling.winter.common

&contract.slipknot_dreams [v(d.dd)]=1

&tags.contract.slipknot_dreams [v(d.dt)]=changeling.winter.common

&contract.touch_of_winter [v(d.dd)]=1

&tags.contract.touch_of_winter [v(d.dt)]=changeling.winter.common

&contract.ermine's_winter_coat [v(d.dd)]=1

&tags.contract.ermine's_winter_coat [v(d.dt)]=changeling.winter.favored

&contract.fallow_fields [v(d.dd)]=1

&tags.contract.fallow_fields [v(d.dt)]=changeling.winter.favored

&contract.field_of_regret [v(d.dd)]=1

&tags.contract.field_of_regret [v(d.dt)]=changeling.winter.favored

&contract.mantle_of_frost [v(d.dd)]=1

&tags.contract.mantle_of_frost [v(d.dt)]=changeling.winter.favored

&contract.winter's_curse [v(d.dd)]=1

&tags.contract.winter's_curse [v(d.dt)]=changeling.winter.favored

&contract.blessing_of_forgetfulness [v(d.dd)]=1

&tags.contract.blessing_of_forgetfulness [v(d.dt)]=changeling.goblin

&notes.contract.blessing_of_forgetfulness [v(d.dt)]=Remember to add Goblin Debt when used

&contract.glib_tongue [v(d.dd)]=1

&tags.contract.glib_tongue [v(d.dt)]=changeling.goblin

&notes.contract.glib_tongue [v(d.dt)]=Remember to add Goblin Debt when used

&contract.goblin's_eye [v(d.dd)]=1

&tags.contract.goblin's_eye [v(d.dt)]=changeling.goblin

&notes.contract.goblin's_eye [v(d.dt)]=Remember to add Goblin Debt when used

&contract.goblin's_luck [v(d.dd)]=1

&tags.contract.goblin's_luck [v(d.dt)]=changeling.goblin

&notes.contract.goblin's_luck [v(d.dt)]=Remember to add Goblin Debt when used

&contract.huntsman's_clarion [v(d.dd)]=1

&tags.contract.huntsman's_clarion [v(d.dt)]=changeling.goblin

&notes.contract.huntsman's_clarion [v(d.dt)]=Remember to add Goblin Debt when used

&contract.lost_visage [v(d.dd)]=1

&tags.contract.lost_visage [v(d.dt)]=changeling.goblin

&notes.contract.lost_visage [v(d.dt)]=Remember to add Goblin Debt when used

&contract.mantle_mask [v(d.dd)]=1

&tags.contract.mantle_mask [v(d.dt)]=changeling.goblin

&notes.contract.mantle_mask [v(d.dt)]=Remember to add Goblin Debt when used

&contract.sight_of_truth_and_lies [v(d.dd)]=1

&tags.contract.sight_of_truth_and_lies [v(d.dt)]=changeling.goblin

&notes.contract.sight_of_truth_and_lies [v(d.dt)]=Remember to add Goblin Debt when used

&contract.uncanny [v(d.dd)]=1

&tags.contract.uncanny [v(d.dt)]=changeling.goblin

&notes.contract.uncanny [v(d.dt)]=Remember to add Goblin Debt when used

&contract.wayward_guide [v(d.dd)]=1

&tags.contract.wayward_guide [v(d.dt)]=changeling.goblin

&notes.contract.wayward_guide [v(d.dt)]=Remember to add Goblin Debt when used

&contract.pure_clarity [v(d.dd)]=1|Fairest.Ogre

&tags.contract.pure_clarity [v(d.dt)]=changeling.shield.fairest.ogre.royal

think Chargen checks being created.

&f.allocated.power-trait.changeling [v(d.cg)]=mul(dec(first(get(%0/_advantage.wyrd), .)), 5)

&f.allocated.contracts [v(d.cg)]=localize(strcat(setq(x, u(v(d.dd)/.value, %0, bio.favored_regalia)), setq(s, u(v(d.dd)/.value, %0, bio.seeming_regalia)), setq(y, u(v(d.dd)/.value, %0, bio.court)), setq(a, edit(setdiff(lattr(%0/_contract.*), lattr(%0/_contract.*.*)), _CONTRACT., CONTRACT.)), setq(f, setunion(u(f.list-stats-tags, %0, contract, common.%qx, and), u(f.list-stats-tags, %0, contract, common.%qs, and))), setq(c, setdiff(u(f.list-stats-tags, %0, contract, common.goblin, or), %qf)), setq(r, setinter(u(f.list-stats-tags, %0, contract, favored), u(f.list-stats-tags, %0, contract, %qx.%qy, or),)), words(%qa), `, words(%qf), `, words(%qc), `, words(%qr)))

&f.allocated.contracts.seeming [v(d.cg)]=strcat(setq(x, get(%0/_bio.seeming)), setq(y, edit(setdiff(get(%0/_contract.*), get(%0/_contract.*.*)), _CONTRACT., CONTRACT.)), setq(a, edit(lattr(%0/_contract.*.*), _CONTRACT., CONTRACT.)), setq(s, graball(%qa, contract.*.%qx)), setq(c,), words(%qa), `, words(%qs), `, words(%qc))

&check.bio.fae-touched [v(d.cg)]=virtue vice promise

&check.bio.changeling [v(d.cg)]=seeming kith court needle thread favored_regalia

&check.chargen.attributes.changeling [v(d.cg)]=strcat(setq(f, v(d.changeling.blessing_attributes.[get(%0/_bio.seeming)])), setq(a, lcstr(iter(lattr(%0/_attribute.*.favored), edit(elements(%i0, 2, .), BASE_, )))), setq(i, setinter(%qa, %qf)), setq(c, ulocal(f.pts-valid?.attributes, %0, attribute.%qi:-1)), ulocal(f.allocated.attributes, %0), %b, %(of 5/4/3 + favored%), %b, ulocal(display.check.stats, %0, attributes, attribute.%qa:-1), %r, %b %b%b, ansi(h, Favored Attribute), :, %b, titlestr(itemize(%qa)), %b, %[, case(1, eq(words(%qa), 0), ansi(r, none set), gt(words(%qa), 1), ansi(r, too many set), neq(words(%qi), 1), ansi(r, not allowed for your seeming), not(%qc), ansi(r, bonus point not spent), ansi(g, OK)), %])

&d.changeling.blessing_attributes.darkling [v(d.cg)]=wits dexterity manipulation

&d.changeling.blessing_attributes.beast [v(d.cg)]=resolve stamina composure

&d.changeling.blessing_attributes.elemental [v(d.cg)]=resolve stamina composure

&d.changeling.blessing_attributes.fairest [v(d.cg)]=intelligence strength presence

&d.changeling.blessing_attributes.ogre [v(d.cg)]=intelligence strength presence

&d.changeling.blessing_attributes.wizened [v(d.cg)]=wits dexterity manipulation

&check.chargen.changeling [v(d.cg)]=u(check.contracts, %0, changeling)

&check.chargen.fae-touched [v(d.cg)]=u(check.contracts, %0, fae-touched)

&check.contracts [v(d.cg)]=udefault(check.contracts.[get(%0/_bio.template)], ** check failed **, %0)

&check.contracts.changeling [v(d.cg)]=strcat(setq(9, u(f.allocated.contracts, %0)), setq(a, first(%q9, `)), setq(i, extract(%q9, 2, 1, `)), setq(o, extract(%q9, 3, 1, `)), %b, %b, ansi(h, Total contracts), :, %b, if(eq(%qa, 0), ansi(xh, <none>), %qa), %b, %(of 6%), %b, u(check.contracts.changeling.total, %qa), %r, %b, %b, %b, %b, ansi(h, Favored), :, %b, if(eq(%qi, 0), ansi(xh, <none>), %qi), %b, %(at least 2%), %b, u(check.contracts.changeling.favored, %qo), %r, %b, %b, %b, %b, ansi(h, Royal), :, %b, if(eq(%qo, 0), ansi(xh, <none>), %qo), %b, %(at least 2%), %b, u(check.contracts.changeling.royal, %qo), %r)

&check.contracts.changeling.total [v(d.cg)]=u(display.check.ok-no, eq(%0, 6))

&check.contracts.changeling.favored [v(d.cg)]=u(display.check.ok-no, gte(%0, 2))

&check.contracts.changeling.royal [v(d.cg)]=u(display.check.ok-no, gte(%0, 2))

&check.contracts.fae-touched [v(d.cg)]=strcat(setq(9, u(f.allocated.contracts, %0)), setq(t, ladd(%q9, `)), setq(i, ladd(elements(%q9, 2 3, `), `)), setq(o, elements(%q9, 1, `)), %b, %b, ansi(h, Total contracts), :, %b, if(eq(%qa, 0), ansi(xh, <none>), %qa), %b, %(of 2%), %b, u(check.contracts.fae-touched.total, %qa), %r, %b, %b, %b, %b, ansi(h, Favored), :, %b, if(eq(%qf, 0), ansi(xh, <none>), %qf), %b, %(of 2%), %b, u(check.contracts.fae-touched.favored, %qf), %r, %b, %b, %b, %b, ansi(h, Royal), :, %b, if(eq(%qr, 0), ansi(xh, <none>), %qr), %b, %(of none%), %b, u(check.contracts.fae-touched.royal, %qr), %r)

&check.contracts.fae-touched.total [v(d.cg)]=u(display.check.ok-no, eq(%0, 2))

&check.contracts.fae-touched.favored [v(d.cg)]=u(display.check.ok-no, eq(%0, 2))

&check.contracts.fae-touched.royal [v(d.cg)]=u(display.check.ok-no, eq(%0, 0))

think XP stuff.

&xp.advantage.glamour [v(d.xpcd)]=u(cost.standard, 5, %1, %2)

&xp.contract [v(d.xpcd)]=u(cost.standard, case(1, u(v(d.sfp)/f.hastag?.workhorse, contract.%3, [u(.value, %0, bio.favored_regalia)].common), 2, u(v(d.sfp)/f.hastag?.workhorse, contract.%3, goblin), 2, u(v(d.sfp)/f.hastag?.workhorse, contract.%3, common), 3, u(v(d.sfp)/f.hastag?.workhorse, contract.%3, [u(.value, %0, bio.favored_regalia)].royal), 3, 4), %1, %2)

&d.restricted.types.changeling [v(d.xpas)]=contract

&d.restricted.stats.changeling [v(d.xpas)]=advantage.glamour

think Stat blocks going in.

&bio.default.fae-touched [v(d.nsc)]=birthdate concept motley template virtue vice promise

&bio.default.changeling [v(d.nsc)]=birthdate concept needle thread template court seeming kith motley favored_regalia

&powers.contracts.seeming_bonus [v(d.nsc)]=iter(%1, strcat(first(%i0, :), :, iter(rest(%i0, :), strcat(setq(y, edit(%i0, %b, _)), setq(z, lattr(%0/_contract.%qy.*)), setq(z, edit(%qz, _CONTRACT.[ucstr(%qy)].,, %b, ., _, %b)), if(gt(strlen(%qz), 0), %i0 %([iter(%qz, titlestr(%i0), ., %,%b)]%), %i0)), ., .)), |, |)

&block.powers.changeling [v(d.sheet)]=u(block.powers.contracts, %0, %1)

&filter.powers.contracts [v(d.nsc)]=t(strlen(after(%0, :)))

&powers.contracts [v(d.nsc)]=localize(strcat(setq(f, u(v(d.dd)/.value, %0, bio.favored_regalia)), setq(c, u(v(d.dd)/.value, %0, bio.court)), setq(a, lattr(%0/_contract.*)), setq(t, iter(Crown.Jewels.Mirror.Shield.Steed.Sword.[get(v(d.dd)/bio.court)].Goblin, strcat(%i0, :, filter(v(d.sfp)/f.hastag?.workhorse, edit(%qa, _CONTRACT., CONTRACT.),,, %i0)), ., |)), setq(u, iter(%qt, strcat(first(%i0, :), :, iter(rest(%i0, :), ulocal(f.cheat_getstat.name_only, %0, %i0, flag),, .)), |, |)), setq(x, ulocal(powers.contracts.seeming_bonus, %0, %qu)), setq(x, filter(filter.powers.contracts, %qx, |, |)), setq(x, edit(%qx, %qf:, %qf [ansi(xh, %(blessing%))]:)), setq(x, edit(%qx, %qc:, %qc [ansi(xh, %(mantle%))]:)), %qx))

&block.powers.changeling [v(d.sheet)]=u(block.powers.contracts, %0, %1)

&block.powers.contracts [v(d.sheet)]=strcat(setq(c, u(powers.contracts, %0)), divider(Contracts), %r, ulocal(format.block.two-even-columns, iter(u(powers.contracts, %0), strcat(u(display.subheader.underline, 38, first(%i0, :)), %r, edit(rest(%i0, :), ., %r)), |, |), ansi(xh, |%b)), %r, null(to be continued),)

&display.subheader.dash [v(d.nsc)]=strcat(ansi(xh, %b%b+), center(%b%1%b, sub(%0, 6), ansi(xh, -)), ansi(xh, +%b%b))

&display.subheader.underline [v(d.nsc)]=center(ansi(u, %1), %0)

&display.subheader.dot [v(d.nsc)]=center(%b%1%b, %0, ansi(xh, .))

&advantages.changeling [v(d.nsc)]=kenning

&traits.morality.changeling [v(d.nsc)]=null(null)

&traits.glamour [v(d.nsc)]=u(f.cheat_getstat.pool, %0, glamour)

&block.traits.glamour [v(d.sheet)]=strcat(setq(w, 38), setq(t, 10), setq(x, ulocal(traits.glamour, %0)), setq(c, rest(setr(y, first(%qx, |)), :)), setq(p, last(%qx, :)), u(display.trait-and-value, %qy, %qt, %qw, pool, %b, %qp))

&block.clarity [v(d.sheet)]=strcat(divider(Clarity), %r, u(v(d.ccs)/display.clarity-bar, %0))

&block.traits.changeling [v(d.sheet)]=strcat(setq(w, 38), setq(t, 10), setq(r, ulocal(block.traits.glamour, %0)), setq(z, u(display.trait-and-value, u(traits.supernatural_resistance, %0), inc(strlen(Wyrd)), %qw, numeric)), vcolumns(%qw:%qr, %qw:%qz, |, %b), %r, u(block.clarity, %0), %r,)

&block.traits.fae-touched [v(d.sheet)]=strcat(setq(w, 38), setq(t, 10), setq(r, ulocal(block.traits.glamour, %0)), setq(z, u(display.trait-and-value, u(traits.supernatural_resistance, %0), inc(strlen(Wyrd)), %qw, numeric)), vcolumns(%qw:%qr, %qw:%qz, |, %b), %r,)

think Spend/regain stuff.

&regain.methods.glamour [v(d.psrs)]=|all

&spend.methods.glamour [v(d.psrs)]=[null(nothing but numeric allowed here)]

&amt.spend.numeric.glamour [v(d.psrs)]=if(t(u(amt.spend.numeric.default, %0, %1, %2)), if(lte(%2, elements(1 2 3 4 5 6 7 8 10 15, getstat(%0/Wyrd))), mul(%2, -1), #-1 You can't spend that much at one time), u(amt.spend.numeric.default, %0, %1, %2))

&spend.trigger.glamour [v(d.psrs)]=think strcat(m:, %b, setr(m, u(f.match_method, %1, spend, glamour, %2)), %r, a:, %b, setr(a, u(amt.spend, %1, glamour, %qm)), %r, u:, %b, setr(u, hasattr(%1, _advantage.wyrd)), %r, s:, %b, setr(s, hasattr(%1, _advantage.glamour_maximum)), %r,); @assert cand(%qu, %qs)={@pemit %0=u(.msg, glamour/spend, cat(if(strmatch(%0, %1), You, name(%1)), must have both Wyrd and a Glamour pool))}; @assert strlen(%qm)={@pemit %0=u(.msg, glamour/spend, I could not find the method '%2')}; @assert t(%qa)={@pemit %0=u(.msg, glamour/spend, rest(%qa))}; @assert t(setr(e, u(f.pool.canchange, %1, glamour, %qa)))={@pemit %0=u(.msg, glamour/spend, rest(%qe))}; @assert t(setr(e, u(f.pool.changestat, %1, glamour, %qa)))={@pemit %0=u(.msg, glamour/spend, rest(%qe))}; think e: [setr(e, u(display.number, %0, %1, glamour, spend, %qa, %qm, %4))]; @eval u(f.announcement, %0, %1, spend, %qe);

&regain.trigger.glamour [v(d.psrs)]=think strcat(m:, %b, setr(m, u(f.match_method, %1, regain, glamour, %2)), %r, a:, %b, setr(a, u(amt.regain, %1, glamour, %qm)), %r, u:, %b, setr(u, hasattr(%1, _advantage.wyrd)), %r, s:, %b, setr(s, hasattr(%1, _advantage.glamour_maximum)), %r,); @assert cand(%qu, %qs)={@pemit %0=u(.msg, glamour/regain, cat(if(strmatch(%0, %1), You, name(%1)), must have both Wyrd and a Glamour pool))}; @assert strlen(%qm)={@pemit %0=u(.msg, glamour/regain, I could not find the method '%2')}; @assert t(%qa)={@pemit %0=u(.msg, glamour/regain, rest(%qa))}; @assert t(setr(e, u(f.pool.canchange, %1, glamour, %qa)))={@pemit %0=u(.msg, glamour/regain, rest(%qe))}; @assert t(setr(e, u(f.pool.changestat, %1, glamour, %qa)))={@pemit %0=u(.msg, glamour/regain, rest(%qe))}; think e: [setr(e, u(display.number, %0, %1, glamour, regain, %qa, %qm, %4))]; @eval u(f.announcement, %0, %1, regain, %qe);

&regain.methods.goblin_debt [v(d.psrs)]=|all

&spend.methods.goblin_debt [v(d.psrs)]=[null(nothing but numeric allowed here)]

&spend.trigger.goblin_debt [v(d.psrs)]=@assert t(setr(e, u(f.pool.canchange, %1, goblin_debt, -1)))={@pemit %0=u(.msg, goblin debt/spend, rest(%qe))}; @assert t(setr(e, u(f.pool.changestat, %1, goblin_debt, -1)))={u(.msg, goblin debt/spend, rest(%qe))}; think e: [setr(e, u(display.number, %0, %1, goblin_debt, spend, 1,, %4))]; @eval u(f.announcement, %0, %1, spend, %qe);

&regain.trigger.goblin_debt [v(d.psrs)]=think strcat(m:, %b, setr(m, u(f.match_method, %1, regain, goblin_debt, %2)), %r, a:, %b, setr(a, u(amt.regain, %1, goblin_debt, %qm)), %r,); @assert strlen(%qm)={@pemit %0=u(.msg, goblin debt/regain, I could not find the method '%2')}; @assert t(%qa)={@pemit %0=u(.msg, goblin debt/regain, rest(%qa))}; @assert t(setr(e, u(f.pool.canchange, %1, goblin_debt, %qa)))={@pemit %0=u(.msg, goblin debt/regain, rest(%qe))}; @assert t(setr(e, u(f.pool.changestat, %1, goblin_debt, %qa)))={@pemit %0=u(.msg, goblin debt/regain, rest(%qe))}; think e: [setr(e, u(display.number, %0, %1, goblin_debt, regain, %qa, %qm, %4))]; @eval u(f.announcement, %0, %1, regain, %qe);

think Entering conditions.

@fo me=&COND.ARCADIAN_DREAMS [v(d.ctdb)]=Arcadian Dreams|1|Until her promise-bound is safely out of Arcadia, the fae-touched is plagued with dreams and visions of him. She always has an awareness of him in the back of her mind. If she is in the Hedge, she has a general knowledge of what direction to travel in to reach him and gains a one-die bonus to navigate the Hedge toward him. She can feel his pain as though it were her own.|All Fae-touched|The Avowed reunites with her promise-bound, or he dies before that can happen, in which case she knows about it immediately. The latter constitutes a breaking point for the fae-touched character.|The player chooses to fail any roll. These failures occur due to sudden, distracting suffering by proxy, or due to a poignant reminder of one of her visions in the current situation, which the player can come up with on the fly.|CtL.333

@fo me=&COND.BERSERK [v(d.ctdb)]=Berserk|0|Your character has a spark of berserk rage lit within her. The fury inside demands that she lash out, and the descending red mist makes it hard to tell friend from foe. Each turn, she must succeed at a Resolve + Composure roll or attack the nearest target with whatever weapons she has to hand. Even if she succeeds, she suffers a -3 penalty on all actions other than attacking the nearest target.\%r\%rChangelings with this Condition add one die to Clarity damage rolls.|Some supernatural powers.|The character becomes unconscious or there are no targets left to attack.|n/a|CtL.333-4

@fo me=&COND.COMATOSE [v(d.ctdb)]=Comatose|0|Your character has reached rock bottom. She has lost any ability to distinguish reality from fantasy, and has gone into a deep dream. She believes she is awake, living her life perfectly normally, but is instead lying in a coma. She cannot roll to enter the Gate of Ivory (p. 215) or dream lucidly without help. If this Condition came about through mild Clarity damage, events in her dream may lead her to resolve another Clarity Condition even though she doesn't realize she's dreaming, allowing her to wake up.|Reaching Clarity 0 With Mild Damage|The character regains Clarity, or she realizes she is in a dream and awakens, regaining a point of Clarity as normal.|n/a|CtL.334

@fo me=&COND.PERSISTENT_COMATOSE [v(d.ctdb)]=Persistent Comatose|1|Your character has reached rock bottom. She has lost any ability to distinguish reality from fantasy, and has gone into a deep dream. She believes she is awake, living her life perfectly normally, but is instead lying in a coma. She cannot roll to enter the Gate of Ivory (p. 215) or dream lucidly without help. If this Condition came about through severe Clarity damage, events in her dream may lead her to resolve another Clarity Condition even though she doesn't realize she's dreaming, but this doesn't wake her. If someone can convince her that she's actually dreaming, through oneiromancy or some other method, she can claw her way back to wakefulness.|Reaching Clarity 0 With Severe Damage|The character is convinced she is in a dream and awakens, which requires someone to come and rescue her. Any other Clarity Conditions she may have resolved during this time increase her Clarity as normal, but do not resolve this Condition.|n/a|CtL.334

@fo me=&COND.DEMORALIZED [v(d.ctdb)]=Demoralized|0|Your character is demoralized and hesitant in the face of the enemy. Spending a Willpower point only adds one die to her pool for attacks instead of the usual three. She also suffers a -4 penalty to her Initiative, and a -2 penalty to her Resolve and Composure whenever used to resist or contest a dice pool.\%r\%rIf this Condition doesn't resolve within a week, it fades.\%r\%rChangelings with this Condition add one die to Clarity damage rolls.|Dramatic failure|Achieve exceptional success on an attack roll, win a fight, or survive a fight unharmed.|none|CtL.335

@fo me=&COND.DISORIENTED [v(d.ctdb)]=Disoriented|0|Your character cannot get her bearings and dealing with simple tasks is daunting. The character is at a -2 penalty to any Physical action. She can defend herself normally, but her disorientation prevents her from making ranged attacks at all.\%r\%rChangelings with this Condition add one die to Clarity damage rolls.|Some supernatural powers, blunt physical trauma|The character finds something to help her orient herself to her surroundings, such as a familiar landmark or a friend. If a supernatural power caused this Condition, then it resolves when the power ends.|n/a|CtL.336

@fo me=&COND.DISSOCIATION [v(d.ctdb)]=Dissociation|0|Your character questions whether she is even real. She experiences episodes where she feels like a passenger in someone else's body, unable to control her own thoughts or actions. Sometimes she goes long hours simply watching herself, wondering how much of what she sees is real, and how much is memory of her time in Arcadia. Any time the character has a chance to break with the mundane, such as using a Contract, you can opt to fail the roll to affirm that she's in the real world and resolve this Condition.|Mild Clarity damage in any of your three rightmost boxes, some dramatic failures|The player chooses to fail a roll as described above.|n/a|CtL.336

@fo me=&COND.DISTRACTED [v(d.ctdb)]=Distracted|0|Constant confusion and distractions buffet your character from all sides. She cannot take extended actions, and suffers a 2 die penalty to all rolls involving perception, concentration, and precision.|Being in a highly confusing environment, mild Clarity damage in any of your three rightmost boxes|Leaving the environment\%; if inflicted by Clarity damage, regaining all Willpower.|n/a|CtL.336

@fo me=&COND.DREAM_ASSAILANT [v(d.ctdb)]=Dream Assailant|0|Your character has caused too many significant shifts to the dreamscape, and the eidolons are now actively hostile to you. You take a -5 to any roll to interact with them peacefully or do anything unnoticed, and all failures that involve eidolons your character isn't fighting are dramatic failures. Reduce all eidolon impressions of you to Hostile for Social maneuvering. All paradigm shifts cost two additional successes to enact, and you can't enact subtle shifts at all.\%r\%rIf you resolve this Condition by interacting with an important eidolon or prop, choose one of the following effects to impose on the dreamer or any effect from a milder Shift Condition, which persists after he wakes:\%r\%b * Leave subliminal Manipulation clues as Dream Infiltrator, but roll Wits + Empathy + Wyrd instead.\%r\%b * Inflict the Ravaged Condition (p. 344).\%r\%b * Inflict the Flesh Too Solid Tilt (p. 329) on the dreamer's dream form.|Enact a paradigm shift in a dream|Exit the dream and don't return for one week\%; reintegrate yourself into the dream by taking a number of meaningful actions equal to the dreamer's Resolve without making any shifts to downgrade this Condition to Dream Intruder\%; or succeed at a meaningful action to influence an important eidolon (or the subject's dream self) or use an important prop in a way that's directly related to the waking change you want to make. Only relevant eidolons and props count, subject to Storyteller discretion.|n/a|CtL.336-7

@fo me=&COND.DREAM_INFILTRATOR [v(d.ctdb)]=Dream Infiltrator|0|Your character has caused a significant shift to the dreamscape, and the eidolons are now suspicious of you. You take a -2 to any roll to interact with them peacefully, or a -3 to do anything unnoticed. Reduce all eidolon impressions of you by one for Social maneuvering. All subtle shifts cost one additional success to enact.\%r\%rIf you resolve this Condition by interacting with an important eidolon or prop, choose one of the following effects to impose on the dreamer, which persists after he wakes:\%r\%b * Deliver a subliminal message\%; he will remember the information but not where it came from.\%r\%b * Make a Wits roll and "store" successes as dice in the subject's mind, for use as bonus dice on Manipulation-based rolls you make against him within the next chapter as you take advantage of subliminal clues you left behind.\%r\%b * Impose or remove a Condition that changes the dreamer's attitude toward your character or another, or behavior in general: e.g. Swooned, Leveraged, Competitive, Paranoid, etc.\%; resolving a Condition this way grants Beats as normal.\%r\%b * Increase or decrease the Fortification rating of the dreamer's Bastion by 1 for the rest of the story.\%r\%b Increase or decrease the dreamer's impression of you or another character by two levels on the chart for Social maneuvering (p. 192)\%r\%b * Open Doors equal to your character's Empathy for Social maneuvering against the dreamer toward a particular goal.\%r\%b * Stop the dreamer from recovering Willpower during this night's rest|Enact a paradigm shift in a dream|Upgrade this Condition to another Shift Condition\%; exit the dream and don't return until the dreamer wakes and sleeps again\%; reintegrate yourself into the dream by taking a number of meaningful actions equal to the dreamer's Resolve without making any shifts\%; or succeed at a meaningful action to influence an important eidolon (or the subject's dream self) or use an important prop in a way that's directly related to the waking change you want to make. Only relevant eidolons and props count, subject to Storyteller discretion.|n/a|CtL.337-8

@fo me=&COND.DREAM_INTRUDER [v(d.ctdb)]=Dream Intruder|0|Your character has caused multiple significant shifts to the dreamscape, and the eidolons are now uncomfortable with your presence. You take a -3 to any roll to interact with them peacefully, or a -4 to do anything unnoticed, and all failures that involve eidolons your character isn't fighting are dramatic failures. Reduce all eidolon impressions of you by two for Social maneuvering. All subtle shifts and paradigm shifts cost one additional success to enact.\%r\%rIf you resolve this Condition by interacting with an important eidolon or prop, choose one of the following effects to impose on the dreamer or any effect from Dream Infiltrator, which persists after he wakes:\%r\%b * Deliver a subliminal suggestion\%; he will perform one specific action of your choice within 24 hours of waking, as long as it wouldn't cause him to suffer a breaking point.\%r\%b * Leave subliminal Manipulation clues as Dream Infiltrator, but roll Wits + Empathy instead.\%r\%b * Impose or remove one Persistent Condition that changes the dreamer's mental state, behavior, or attitude toward someone or something: e.g. Obsession, Awestruck, Amnesia, Madness, etc.\%; resolving a Condition this way grant Beats as normal.\%r\%b * Make a Clarity attack against a changeling subject with a dice pool equal to your character's Presence.\%r\%b * Reduce the subject's current Willpower or Glamour points by (your Presence + Wyrd) and gain that many points yourself, up to your usual maximum.\%r\%b * Increase or decrease one of the subject's Mental or Social Attributes or Skills by 1 for the rest of the story.|Enact a paradigm shift in a dream|Upgrade this Condition to another Shift Condition\%; exit the dream and don't return until the dreamer wakes and sleeps again twice\%; reintegrate yourself into the dream by taking a number of meaningful actions equal to the dreamer's Resolve without making any shifts to downgrade this Condition to Dream Infiltrator\%; or succeed at a meaningful action to influence an important eidolon (or the subject's dream self) or use an important prop in a way that's directly related to the waking change you want to make. Only relevant eidolons and props count, subject to Storyteller discretion.|n/a|CtL.338

@fo me=&COND.FATIGUED [v(d.ctdb)]=Fatigued|0|Your character has never been so tired in all her life. Her eyelids are like millstones, her brain a cobwebbed mass of exhaustion. She's reached that point where fatigue becomes a physical thing, and all she can think to do is close her eyes and rest, just for a moment. Every six hours, you must make a reflexive Resolve + Stamina roll to remain awake. If you fail, your character passes out. Even if you succeed, you suffer a cumulative -1 penalty to all dice pools (including rolls to stay awake). Long periods of strenuous activity, like cross-country hiking, fighting, or heavy labor increase the penalty to -2 or -3. Even then, a normal person can only go a number of days without sleep equal to the lower of her Resolve or Stamina, at which point she passes out. Once a Fatigued character passes out, she remains asleep for eight hours plus one additional hour for every six-hour period she stayed awake. Attempts to rouse her during this period suffer a penalty equal to the highest penalty the Fatigued character suffered before passing out.|Staying awake for 24 hours, being dosed with a sedative or anesthetic, some supernatural powers|Sleeping, as described above, or the power ends.|n/a|CtL.338

@fo me=&COND.FRAGILE [v(d.ctdb)]=Fragile|0|The equipment the character is using to aid his action won't last long for some reason, whether because it's an object put together with duct tape and bubble gum, or because his relationship with the people involved sours, or because his computer ends up suffering a blue screen of death and the data is corrupted. A plan may be Fragile because of disrupted communication between the characters, or because of an unexpected hurdle, etc. The equipment ceases to exist in any usable form after a number of uses equal to its creator's dots in the Skill used to build it.|Achieving a failure on a Build Equipment roll|The equipment falls apart one way or another. Plans grant one Beat to each player whose character is involved when this Condition resolves.|n/a|CtL.339

@fo me=&COND.GLAMOUR_ADDICTED [v(d.ctdb)]=Glamour Addicted|1|Your character is addicted to Glamour. This slowly takes over her life, and impedes functionality. She can go a number of days equal to her Resolve before needing to obtain Glamour again. She must harvest or reap a number of Glamour points equal to half her Wyrd (rounded up) during that period, or suffer one lethal damage every day until she does and gain the Deprived Condition (p. 335). This is incredibly painful as her body consumes its own magical energy to satisfy the hunger for Glamour. The mask cracks, like a fractured mirror in which each piece shows a different reflection of the fae underneath. This special type of damage cannot be prevented or healed by any means, nor can the character resolve the Deprived Condition, until the changeling has supped upon Glamour once more.\%r\%rAdd one die to Clarity damage rolls.|Harvesting Glamour every day for a week at Wyrd 6+|Achieve an exceptional success on a roll to harvest Glamour.|Your character takes damage from not being able to harvest Glamour.|CtL.339

@fo me=&COND.GOBLIN_QUEEN [v(d.ctdb)]=Goblin Queen|1|The character has risen far beyond ordinary goblins, and they scrape and bow before her. This Condition functions as Hedge Denizen (p. 340), except as follows:\%r\%b * The character's Mantle rejects her. She cannot invoke her current Court Contracts, nor purchase new ones.\%r\%b * She gains the Status (Goblins) Merit at four dots. If the local Hedge holds any creatures who outrank her, she immediately knows their assumed names and titles.\%r\%b * The character's identity has so profoundly changed that fae beings no longer add her Wyrd as bonus dice to track or find her. If she recovers her Icon while she's a Goblin Queen, she can't reintegrate it into herself.\%r\%b * The Goblin Queen cannot leave the Hedge, except by wrapping pieces of it as a mantle around her, to travel into the mortal realm or Arcadia for up to a number of hours per day equal to her Wyrd. She still suffers the Deprived Condition in the real world.\%r\%b * The Queen gains the Retainer Merit (p. 125) with dots equal to her Wyrd, spread across as many individual Retainers as she likes up to a maximum of five dots per Retainer. These retainers are all hobgoblins\%; see p. 257 for examples. The retainers are unquestioningly loyal and devoted to her.\%r\%b * Changelings with this Condition add two dice to Clarity damage rolls instead of one.|Upgrade of Hedge Denizen|The Queen finds a human child and leaves him to take her place. The child immediately gains the Goblin Queen Condition and all of her Retainers, who protect him until he comes of age to ascend the throne. The child remembers who abandoned him.\%r\%rThe character becomes what she once was again, whether a changeling or otherwise. She takes on her old seeming, kith, and identity--also setting the Fae back on her trail. If the character was mortal previously, her player selects three dots of supernatural Merits for her, as she is irrevocably changed. The newly abandoned queen can use the same process to become human again as well. This resolution constitutes a Clarity attack with two dice for changelings, or a breaking point for others.\%r\%rAlternatively, if the character works off five points of Goblin Debt, she resolves this Condition and regains the Hedge Denizen Condition instead.|The character collects Goblin Debt from another character, selling a Contract or making another kind of hobgoblin deal.|CtL.339-40

@fo me=&COND.HEDGE_ADDICTION [v(d.ctdb)]=Hedge Addiction|1|The Hedge draws the fae-touched character. If she is presented with an opportunity to enter the Hedge, her player must succeed on a Resolve + Composure roll to resist the temptation. The roll suffers a cumulative -1 penalty for each previous time the character has entered the Hedge during this story, to a maximum of -1|Being fae-touched|The character refrains from entering the Hedge for a full story. However, he regains this Condition if he ever does enter the Hedge in the future.|The Avowed enters the Hedge, either because he failed to resist the pull, or because he went willingly.|CtL.340

@fo me=&COND.HEDGE_DENIZEN [v(d.ctdb)]=Hedge Denizen|1|Having relied on Goblin Contracts too much or become too reliant on hobgoblin deals, the character becomes a goblin herself. She retains her normal changeling benefits and weaknesses, except in these cases:\%r\%b * The changeling's mien warps, growing closer to the appearance she had during her servitude in Arcadia. She has one tell of the player's choice, by which former friends and enemies might recognize her.\%r\%b * The Storyteller can no longer spend her Goblin Debt points. The character must work off her debt, per the resolution below.\%r\%b * Arcadian Contracts are the birthright of all denizens of Faerie, but the Hedge is its own in-between place. The character can still buy and use Arcadian Contracts, but pays for all of them as if they were in non-blessing Regalia and may not circumvent this via Pupil's Devotion.\%r\%b * Courts are changeling affairs, and the character no longer is one. The character keeps and can use her old Court Contracts, but cannot purchase new ones. She loses all other benefits of her Court Mantle.\%r\%b * Whenever the sun rises over the Hedge, the character can redistribute the set of GoblinContracts she knows across any Goblin Contracts she wants. If she had three Contracts as a changeling, she can pick any three every morning. Purchasing new Goblin Contracts still costs 2 Experiences each.\%r\%b * Invoking Goblin Contracts as a Hedge Denizen does not incur Debt.\%r\%b * The character can leave the Hedge, but suffers the Deprived Condition until she returns to the Hedge or Arcadia.\%r\%b * If the character was mortal, or another nonchangeling unlucky enough to fall in with hobgoblins, she immediately learns three Goblin Contracts of the player's choice. If she is a Storyteller character, the Storyteller may substitute Dread Powers for any of these (p. 253). She can switch them out each dawn as above.\%r\%b * The character can make deals, sell Contracts, and collect Debt as a hobgoblin. See p. 256 for details on goblin deals.\%r\%b * Changelings with this Condition add one die to Clarity damage rolls.|(unknown possible sources?)|The character becomes what she was again, or she embraces her new self to become a Goblin Queen (p. 339).\%r\%b * Returning to What Was: The character pays off at least one Goblin Debt point. She cannot simply accept a disadvantage from the Storyteller, or use tokens or other shortcuts to lose Debt points--she's a goblin now, and must pay her Debt by seeking out the goblin with whom she entered into the Contract, or any third party involved if that goblin is dead or otherwise gone, and perform a task at his request. After that, she must heal a point of Clarity damage\%; nonchangelings must gain or lose a dot of Integrity or an equivalent trait. She then becomes her old self again.\%r\%b * Any Debt she hasn't worked off yet remains, as do any new Goblin Contracts she learned. If she returns to being mortal, she keeps one Goblin Contract of the player's choice, which she can invoke by taking one point of bashing damage to substitute for each point of Glamour in its cost. Using Goblin Contracts racks up Goblin Debt again.\%r\%b * Embracing What Might Be: The changeling suffers two or more Clarity attacks, and takes Clarity damage (or loses an equivalent trait) from at least one. She must also lose one Touchstone, which she can do by simply willing herself to forget it, although losing one in the usual ways counts also. She now resolves the Hedge Denizen Condition, and takes the Goblin Queen Condition instead. Since mortals have no Touchstones, they can't become Goblin Queens.| The character works off a point of Goblin Debt but can't, or chooses not to, resolve this Condition via Returning to What Was.|CtL.340-2

@fo me=&COND.HUNTED [v(d.ctdb)]=Hunted|1|Someone who poses a serious threat to the character's safety and well-being, physically or emotionally (or both), is after her. For changelings, it's usually an agent of the True Fae, like a Huntsman or loyalist, or perhaps their fetch. Whoever it is might be intent on direct violence, or simply wish to torment her.\%r\%rChangelings with this Condition add one die to Clarity damage rolls.|(unknown possible sources)|The character stops her persecutors, either through direct means like violence, or indirect means like changes in lifestyle that deny them access to her or freeing a Huntsman from the True Fae's service.|The character's persecutors find her.|CtL.342

@fo me=&COND.OATHBREAKER [v(d.ctdb)]=Oathbreaker|1|The character has violated an oath, and receives this Condition in addition to any other effects breaking the oath carries. Changelings instinctively distrust the character. He suffers a -1 on all Social actions with other changelings, and cannot use Glamour to seal their statements. As a known liar, however, he is also immune to having his own statements sealed.\%r\%rChangelings with this Condition add one die to Clarity damage rolls.|Break an oath|The character undertakes a sincere attempt to make restitution for his betrayal. This includes finding all other participants involved in the oath and undertaking whatever task they assign. It also includes receiving forgiveness from the Wyrd itself\%; this is sure to be the focus of a story, and the particulars are up to the Storyteller.|Once per session, the player can choose to automatically dramatically fail a Contract roll, or a Social action with a changeling, and take a Beat. Make the choice before rolling.|CtL.343

@fo me=&COND.OBLIGED [v(d.ctdb)]=Obliged|1|Your character swore a bargain--not an oath--with a human being. The obligation on her part is probably minor, but she can't let it lapse! Not only would that disappoint the person to whom she gave her word, but it would expose her to the Huntsmen and their Gentry masters.\%r\%rWhile under a bargain, the changeling is more difficult to find. Huntsmen must win a Clash of Wills to use their Hunter's Senses power (p. 266) when tracking the changeling, and fae beings no longer add the changeling's Wyrd in dice to do so when she drops her Mask. In addition, once per chapter, when the changeling is at the site of her obligation (the human's home that she must clean, for example, or in the garden she agreed to tend), she may hide without fear of discovery for the rest of the scene. This benefit applies to any pursuer touched by the Wyrd, be it Huntsman, Gentry, hobgoblin, or even another changeling.|Make a bargain with a human|Break the bargain by failing to live up to its terms, or the other party breaks her part of the agreement. Either way, you lose any protections the bargain provided.|Once per story, gain a Beat when you take a great risk or suffer harm while fulfilling your obligation. You can have help from other characters, but you must be directly involved--no subcontracting out.|CtL.343-4

@fo me=&COND.PARANOID [v(d.ctdb)]=Paranoid|0|Your character has been reduced to a state of rampant paranoia. She jumps at shadows, sees threats everywhere, and finds it hard to trust. She suffers a two-die penalty to perception rolls, Social actions, and dice pools to draw upon the Allies, Contacts, Mentor, Retainer, Staff, and Status Merits.\%r\%rChangelings with this Condition add one die to Clarity damage rolls.|Some supernatural powers, some dramatic failures|A week without any fae threat actually manifesting\%; a friend or ally achieving exceptional success on a Social action to convince you of their trustworthiness.|n/a|CtL.344

@fo me=&COND.RAVAGED [v(d.ctdb)]=Ravaged|0|A fae creature sundered your character's dreams, leaving her with sleep but no rest, or ripped her emotions away as Glamour. She becomes a shell of her former self, and you take a two-die penalty on all rolls. Your charac- ter cannot recover Willpower through sleep.\%r\%rChangelings with this Condition add one die to Clarity damage rolls.|Oneiromancy, reaping Glamour|Regaining full Willpower.|n/a|CtL.344

@fo me=&COND.SLEEPWALKING [v(d.ctdb)]=Sleepwalking|1|The lines between waking and sleeping blur to the point where your character doesn't know which he's doing. Sometimes he thinks he did something he didn't do\%; he remembers doing it, but maybe he was dreaming. Other times, he finds out later that he spent hours on a task he has no memory of doing. You character loses time, may not actually complete objectives he thinks he did, and generally has a harder time maintaining relationships and obligations.|Severe Clarity damage in any of your three rightmost boxes|Achieve an exceptional success on an oneiromancy roll or during an extended action.|Fail to complete an obligation because you thought you already did.|CtL.344

@fo me=&COND.SOUL_SHOCKED [v(d.ctdb)]=Soul Shocked|0|Your character died because of fae magic while on a sojourn in dreams, or in a reality that no longer exists, but she still remembers it and suffers a shocked sense of self. Upon gaining this Condition, roll her current Willpower points (not dots) as a dice pool. Ignore 10-again on this roll, and do not roll a chance die if she has no Willpower left. She keeps one Willpower per success, and immediately loses the remainder. While this Condition is in effect, your character does not regain Willpower from Needle, Thread, or equivalent traits. She still regains Willpower from rest, surrender, and other means.|Being "killed" in dream form by fae magic, escaping a Bastion crumbling due to oneiromancy|Regain full Willpower|n/a|CtL.345

@fo me=&COND.STOIC [v(d.ctdb)]=Stoic|0|Your character has shut down the parts of herself that care. She won't open up to anyone and pretends she's fine when she isn't. Gain a two-die bonus to Subterfuge rolls to hide her emotions or avoid talking about a traumatic experience. She doesn't suffer the untrained penalty for any Subterfuge roll. Take a two-die penalty to Hedgespinning rolls. Until she resolves this Condition, she can't heal Clarity damage, and she can't spend Willpower on actions that would reveal her true feelings.|(unknown possible sources)|Opt to fail a roll to resist Empathy or a supernatural effect that would read your character's emotions or mental state\%; enact a paradigm shift while Hedgespinning.|n/a|CtL.345

@fo me=&COND.SWOONED [v(d.ctdb)]=Swooned|0|See 'Swooning'||||CtL..345

@fo me=&COND.VOLATILE [v(d.ctdb)]=Volatile|0|The equipment the character is using to aid his action is ready to blow at any moment, figuratively or literally. One wrong word, one badly placed rune, and it's time to duck and cover. A plan may be Volatile because it backfires terribly, or because a Storyteller character betrays the group, etc. Any failure achieved while benefiting from the equipment is automatically a dramatic failure. The equipment may continue to exist after this Condition is resolved, but if so, reduce its equipment bonus by two dice. This can create equipment penalties if the original bonus was fewer than two dice.|Achieving a failure on a Build Equipment roll|The character suffers a dramatic failure while using the equipment. Plans grant one Beat to each player whose character is involved when this Condition resolves.|n/a|CtL.345

@fo me=&COND.WITHDRAWN [v(d.ctdb)]=Withdrawn|0|Your character doesn't know what to trust anymore, so has decided to withdraw into herself. She finds it hard to motivate herself to action, preferring to remain alone and safe. The character suffers a two-die penalty to all rolls that require her to interact with others in any way.|Mild Clarity damage in any of your three rightmost boxes|The character regains Willpower using her Thread.|n/a|CTL.346

@fo me=&TILT.FLESH_TOO_SOLID [v(d.ctdb)]=Flesh Too Solid|0|The character becomes too immersed in dreams. Physical sensations are even more vivid than in the waking world, but dream wounds leave real scars.\%r\%rEffect: Whenever the character would suffer Dream Health damage, she suffers equivalent physical Health damage instead.|Suffering a dramatic failure on oneiromantic actions and Contracts.|The Tilt normally lasts until the end of the scene.||CtL.329

@fo me=&TILT.INFERNO [v(d.ctdb)]=Inferno|0|(Environmental) The area is on fire. Anything flammable is either already burning or will be soon.\%r\%rEffect: All characters suffer a -2 to all rolls due to smoke and heat. After two turns, any character that breathes also suffers 2B per turn due to smoke inhalation. After three turns, the character also suffers 1L per turn from burns and must succeed on a Dexterity + Stamina roll each turn to avoid catching fire (see p. 190).|Objects or people catching fire and letting it spread can cause this Tilt, as well as supernatural powers or particularly volatile explosions.|Different types of fire require different methods to extinguish\%; in general, cutting off the fire from its fuel sources does the trick. Water, carbon dioxide, sand, and baking soda can be useful, depending on the size and type of the fire. Eventually all fires burn themselves out, but that can be cold comfort in the aftermath of a destructive blaze.||CtL.330

@fo me=&COND.AMNESIA [v(d.ctdb)]=[setq(c, escape(get(v(d.ctdb)/cond.amnesia)))][setq(l, get(v(d.ctst)/i.status.desc))][setq(d, elements(%qc, %ql, |))][setq(t, \%r\%rChangelings with this condition add two dice to Clarity damage rolls.)][setq(c, replace(%qc, %ql, %qd%qt, |))][setq(l, get(v(d.ctst)/i.status.ref))][setq(d, elements(%qc, %ql, |))][setq(t, %,CtL.333)][setq(c, replace(%qc, %ql, %qd%qt, |))]%qc

@fo me=&COND.DEPRIVED [v(d.ctdb)]=[setq(c, escape(get(v(d.ctdb)/cond.deprived)))][setq(l, get(v(d.ctst)/i.status.res))][setq(d, elements(%qc, %ql, |))][setq(t, \%bOr%, if she gained this Condition by reaching Glamour 0%, gaining any Glamour.)][setq(c, replace(%qc, %ql, %qd%qt, |))][setq(l, get(v(d.ctst)/i.status.ref))][setq(d, elements(%qc, %ql, |))][setq(t, %,CtL.335-6)][setq(c, replace(%qc, %ql, %qd%qt, |))]%qc

@fo me=&COND.FUGUE [v(d.ctdb)]=[setq(c, escape(get(v(d.ctdb)/cond.fugue)))][setq(l, get(v(d.ctst)/i.status.source))][setq(d, elements(%qc, %ql, |))][setq(t, \%bSevere Clarity damage in any of your three rightmost boxes.)][setq(c, replace(%qc, %ql, %qd%qt, |))][setq(l, get(v(d.ctst)/i.status.res))][setq(d, elements(%qc, %ql, |))][setq(t, \%bFor changelings%, increase maximum Clarity%, or achieve exceptional success on a roll to contest a fae power.)][setq(c, replace(%qc, %ql, %qd%qt, |))][setq(l, get(v(d.ctst)/i.status.ref))][setq(d, elements(%qc, %ql, |))][setq(t, %,CtL.339)][setq(c, replace(%qc, %ql, %qd%qt, |))]%qc

@fo me=&COND.LOST [v(d.ctdb)]=[setq(c, escape(get(v(d.ctdb)/cond.lost)))][setq(l, get(v(d.ctst)/i.status.desc))][setq(d, elements(%qc, %ql, |))][setq(t, \%bIn the Hedge%, it requires a successful navigation chase (p.200). \%r\%rChangelings with this Condition add one die to Clarity damage rolls.)][setq(c, replace(%qc, %ql, %qd%qt, |))][setq(l, get(v(d.ctst)/i.status.ref))][setq(d, elements(%qc, %ql, |))][setq(t, %,CtL.342)][setq(c, replace(%qc, %ql, %qd%qt, |))]%qc

@fo me=&COND.MADNESS [v(d.ctdb)]=[setq(c, escape(get(v(d.ctdb)/cond.madness)))][setq(l, get(v(d.ctst)/i.status.desc))][setq(d, elements(%qc, %ql, |))][setq(t, \%bChangelings use their current Clarity instead of Integrity.)][setq(c, replace(%qc, %ql, %qd%qt, |))][setq(l, get(v(d.ctst)/i.status.res))][setq(d, elements(%qc, %ql, |))][setq(t, \%bFor changelings%, increase maximum Clarity%, or achieve exceptional success on a roll to contest a fae power.)][setq(c, replace(%qc, %ql, %qd%qt, |))][setq(l, get(v(d.ctst)/i.status.ref))][setq(d, elements(%qc, %ql, |))][setq(t, %,CtL.343)][setq(c, replace(%qc, %ql, %qd%qt, |))]%qc

@fo me=&COND.SHAKEN [v(d.ctdb)]=[setq(c, escape(get(v(d.ctdb)/cond.shaken)))][setq(l, get(v(d.ctst)/i.status.source))][setq(d, elements(%qc, %ql, |))][setq(t, \%bFor changelings%, mild Clarity damage in any of your three rightmost boxes.)][setq(c, replace(%qc, %ql, %qd%qt, |))][setq(l, get(v(d.ctst)/i.status.ref))][setq(d, elements(%qc, %ql, |))][setq(t, %,CtL.344)][setq(c, replace(%qc, %ql, %qd%qt, |))]%qc

@fo me=&COND.SPOOKED [v(d.ctdb)]=[setq(c, escape(get(v(d.ctdb)/cond.spooked)))][setq(l, get(v(d.ctst)/i.status.source))][setq(d, elements(%qc, %ql, |))][setq(t, \%bFor changelings%, mild Clarity damage in any of your three rightmost boxes.)][setq(c, replace(%qc, %ql, %qd%qt, |))][setq(l, get(v(d.ctst)/i.status.ref))][setq(d, elements(%qc, %ql, |))][setq(t, %,CtL.345)][setq(c, replace(%qc, %ql, %qd%qt, |))]%qc

think Entry complete.

think Entering clarity info.

&advantage.clarity [v(d.dd)]=[u(.value_stats, %0, clarity.maximum)].-[u(.value, %0, clarity.damage)]

&default.advantage.clarity [v(d.dd)]=derived

&tags.advantage.clarity [v(d.dt)]=derived.pool

&notes.advantage.clarity [v(d.dd)]=Use the 'clarity' command to apply damage

&clarity.maximum [v(d.dd)]=add(u(.value_stats, %0, attribute.wits attribute.composure), words(lattr(%0/_advantage.icon_(*))))

&default.clarity.maximum [v(d.dd)]=derived

&tags.clarity.maximum [v(d.dt)]=derived.changeling

&clarity.mild [v(d.dd)]=#

&clarity.severe [v(d.dd)]=#

&default.clarity.mild [v(d.dd)]=0

&default.clarity.severe [v(d.dd)]=0

&clarity.damage [v(d.dd)]=ladd(iter(mild severe, u(.value, %0, clarity.%i0)))

&default.clarity.damage [v(d.dd)]=derived

&clarity.penalty [v(d.dd)]=min(0, add(u(.value, %0, clarity.maximum), mul(-1, u(.value, %0, clarity.damage)), -3))

&tags.clarity.penalty [v(d.dt)]=derived

&default.clarity.penalty [v(d.dd)]=derived

&advantage.icon_() [v(d.dd)]=*|*

&prerequisite.advantage.icon_() [v(d.dd)]=0

&prereq-text.advantage.icon_() [v(d.dd)]=May only be set by staff with 'stat/override'

&tags.advantage.icon_() [v(d.dt)]=changeling

&notes.advantage.icon_() [v(d.dt)]=Type: Name of Icon|Value: Description of Icon

&merit.touchstone_() [v(d.dd)]=1|*

&prerequisite.merit.touchstone_() [v(d.dd)]=lte(add(words(lattr(%0/_merit.touchstone_(*))), t(strlen(%2))), sub(u(.value_stat, %0, clarity.maximum), u(.value_stat, %0, attribute.composure)))

&prereq-text.merit.touchstone_() [v(d.dd)]=May not have more Touchstones than Clairty track allows

&tags.merit.touchstone_() [v(d.dt)]=changeling

think Creating the clarity system tracker. (May be buggy.)

@create Changeling Clarity System <ccs>

@fo me=&d.ccs me=search(name=Changeling Clarity System <ccs>)

@set Changeling Clarity System <ccs>=inherit safe

@fo me=&d.dd Changeling Clarity System <ccs>=[search(name=Data Dictionary <dd>)]

@fo me=&d.sfp Changeling Clarity System <ccs>=[search(name=Stat Functions Prototype <sfp>)]

@fo me=@parent Changeling Clarity System <ccs>=[v(d.codp)]

@fo me=&d.ccs [v(d.nsc)]=[search(name=Changeling Clarity System <ccs>)]

&d.symbol.touchstone [v(d.ccs)]=^

&.msg [v(d.ccs)]=ansi(h, <%0>, n, %b%1)

&.plural [v(d.ccs)]=cat(%0, if(eq(%0, 1), %1, %2))

&.sign [v(d.ccs)]=case(sign(%0), 1, +, -1, -)

&.value [v(d.ccs)]=ulocal(v(d.dd)/.value, %0, %1)

&.value_stats [v(d.ccs)]=ulocal(v(d.dd)/.value_stats, %0, %1)

&.is_comatose [v(d.ccs)]=cor(lte(ulocal(v(d.dd)/.value_stats, %0, advantage.clarity), 0), t(lattr(%0/_cond.comatose.*)), t(lattr(%0/_cond.persistent_comatose.*)))

&f.touchstones.active [v(d.ccs)]=setdiff(%1, lnum(1, rest(%0)))

&display.clarity-bar [v(d.ccs)]=ulocal(format.clarity-bar, iter(mild severe, u(.value_stats, %0, clarity.%i0)), ladd(u(.value_stats, %0, clarity.maximum), .), inc(u(.value, %0, attribute.composure)), u(.value_stats, %0, clarity.penalty), %b%b)

&format.clarity-bar [v(d.ccs)]=strcat(setq(w, inc(words(%0))), setq(d, ladd(%0)), setq(t, setinter(%2, lnum(1, %1))), setq(a, words(u(f.touchstones.active, %0, %qt))), setq(p, u(.value, %x,)), %4, iter(X /, iter(lnum(elements(%0, sub(%qw, inum(0)))), ansi(xh, %[, nh, %i1, xh, %]),, @@),, @@), iter(lnum(sub(%1, %qd)), ansi(xh, %[%b%]),, @@), if(neq(0, %3), ansi(xh, strcat(%b, %(, u(.sign, %3), trim(%3, b, -), %b, Perception, %)))), if(strlen(%2), strcat(%r, %4, repeat(%b %b, dec(first(%2))), ansi(xh, repeat(%b[v(d.symbol.touchstone)]%b, words(%qt)),), space(mul(3, sub(%1, add(dec(first(%2)), words(%2))))),)), %b, ansi(xh, %(, xh, edit(u(.plural, %qa, Touchstone, Touchstones), 0%b, No%b), xh, %)),)

&f.clarity.actual_damage [v(d.ccs)]=min(add(%1, u(.value, %0, clarity.%2),), sub(u(.value, %0, clarity.maximum), if(strmatch(%2, mild), u(.value, %0, clarity.severe))))

&f.clarity.hurt.mild [v(d.ccs)]=localize(strcat(setq(m, u(.value, %0, clarity.mild)), setq(s, u(.value, %0, clarity.severe)), setq(d, u(f.clarity.actual_damage, %0, %1, mild)), case(1, u(.is_comatose, %0), #-1 Target is comatose%; cannot take damage, strcat(%qm %qs, |, %qd %qs))))

&f.clarity.hurt.severe [v(d.ccs)]=localize(strcat(setq(m, u(.value, %0, clarity.mild)), setq(s, u(.value, %0, clarity.severe)), setq(d, u(f.clarity.actual_damage, %0, %1, severe)), setq(n, sub(%qm, min(%1, %qm))), case(1, u(.is_comatose, %0), #-1 Target is comatose%; cannot take damage, strcat(%qm %qs, |, %qn %qd))))

&f.clarity.hurt [v(d.ccs)]=localize(case(0, strlen(setr(t, setinter(mild severe all, lcstr(%1)))), #-1 Type is Mild%, Severe%, or All, not(u(.is_comatose, %0)), #-1 Target is comatose%; cannot take damage, not(cor(strmatch(%2, all), strmatch(%qt, all))), u(f.clarity.hurt.all, %0, %qt), cand(isint(%2), gte(%2, 0)), #-1 Damage with positive integer only, u(f.clarity.hurt.%qt, %0, %2)))

&f.clarity.hurt.all [v(d.ccs)]=case(%1, all, u(f.clarity.hurt, %0, severe, 9999), mild, u(f.clarity.hurt, %0, mild, 9999), severe, u(f.clarity.hurt, %0, severe, 9999), #-1 Unknown Damage Type)

&f.clarity.heal [v(d.ccs)]=localize(case(0, add(setr(m, u(.value, %0, clarity.mild)), setr(s, u(.value, %0, clarity.severe))), strcat(#-1 Target is already healthy, if(u(.is_comatose, %0), %bbut is still comatose)), strlen(setr(t, setinter(mild severe all, lcstr(%1)))), #-1 Type is Mild%, Severe%, or All, not(cor(strmatch(%2, all), strmatch(%qt, all))), u(f.clarity.heal.all, %0, %qt), cand(isint(%2), gte(%2, 0)), #-1 Heal with positive integer only, strcat(setq(d, case(%qt, mild, %qm, severe, %qs)), setq(d, max(0, sub(%qd, %2))), %qm %qs|, case(%qt, mild, %qd %qs, severe, %qm %qd, #-1 Panic in f.clarity.heal))))

&f.clarity.heal.all [v(d.ccs)]=case(0, strlen(setr(t, setinter(mild severe all, lcstr(%1)))), #-1 Type is Mild%, Severe%, or All, strcat(setq(m, u(.value, %0, clarity.mild)), setq(s, u(.value, %0, clarity.severe)), %qm %qs|, case(%1, all, 0 0, mild, 0 %qs, severe, %qm 0, #-1 Unknown bug in f.clarity.heal.all)))

&f.test-change [v(d.ccs)]=strcat(setq(o, ladd(%1)), setq(n, ladd(%2)), case(1, cor(gt(%qa, %qo), gt(elements(%2, 2), elements(%1, 2))), ulocal(f.test-change.hurt, %0, %1, %2), lt(ladd(%2), ladd(%1)), ulocal(f.test-chage.heal, %0, %1, %2), null(no change)))

&f.test-change.hurt [v(d.ccs)]=localize(case(1, u(.is_comatose, %0), null(comatose cannot gain damage), strmatch(%1, %2), null(nothing changed so ignore it), strcat(setq(m, u(.value, %0, clarity.maximum)), setq(o, ladd(%1)), setq(n, ladd(%2)), setq(s, gt(elements(%2, 2), elements(%1, 2))), setq(p, if(%qs, Persistent%b)), case(1, gte(%qn, %qm), |Gains %qpComatose Condition, lte(sub(%qm, %qn), 3), |should set a %qpClarity Condition, null(neither)))))

&f.test-change.heal [v(d.ccs)]=strcat(setq(c, lattr(%0/_cond.comatose.*)), setq(p, lattr(%0/_cond.persistent_comatose.*)), case(1, strmatch(%1, %2), null(nothing changed so ignore it), cand(t(%qc), not(t(%qp))), |can resolve a normal Comatose Condition, null(nothing else happened)))

&c.clarity/hurt [v(d.ccs)]=$^\+?clarity\/hurt(.*)$:@pemit %#=u(f.healhurt-workhorse, %#, trim(%1), 0)

&c.clarity/heal [v(d.ccs)]=$^\+?clarity\/heal(.*)$:@pemit %#=u(f.healhurt-workhorse, %#, trim(%1), 1)

@set v(d.ccs)/c.clarity/hurt=regex

@set v(d.ccs)/c.clarity/hurt=no_parse

@set v(d.ccs)/c.clarity/heal=regex

@set v(d.ccs)/c.clarity/heal=no_parse

&f.healhurt-workhorse [v(d.ccs)]=strcat(setq(0, regmatchi(%1, v(d.regex.healhurt), 0 x x y z z)), setq(d, case(%qx, me, %0, null(null), %0, pmatch(%qx))), setq(s, u(v(d.sfp)/f.find-sheet, %qd)), setq(h, case(%2, 1, heal, 0, hurt, ???)), setq(t, grab(|all|mild|severe, %qy*, |)), setq(a, case(%qz, null(null), 1, %qz)), case(0, %q0, u(.msg, clarity/%qh, Command format is: \%[<target>/\%]<type>\%[=<amt>\%]), isdbref(%qd), u(.msg, clarity/%qh, Target not found), cor(isstaff(%#), strmatch(%#, %qd)), u(.msg, clarity/%qh, Only staff can target others), cand(isapproved(%qd), strmatch(u(.value, %qd, bio.template), changeling), hasattr(%qd, _clarity.maximum)), u(.msg, clarity/%qh, Target must be approved changeling), cor(cand(isint(%qa), gt(%qa, 0)), strmatch(%qa, all)), u(.msg, clarity/%qh, Amount must be positive integer or 'all'), strlen(%qt), u(.msg, clarity/%qh, I don't know that type of damage), strcat(setq(c, ulocal(f.clarity.%qh, %qd, %qt, %qa)), setq(r, ulocal(f.test-change.%qh, %qd, first(%qc, |), rest(%qc, |))), case(1, strmatch(%qc, #-1*), u(.msg, clarity/%qh, rest(%qc)), strmatch(%qr, #-1*), u(.msg, clarity/%qr, rest(%qd)), strmatch(setr(e, u(f.healhurt-apply, %0, %qd, %qs, %qh, %qc, %qr)), #-1*), u(.msg, clarity/%qh, rest(%qe)), u(f.healhurt-report, %0, %qd, %qa, if(%2, healing, damage), %qr)))))

&f.healhurt-apply [v(d.ccs)]=localize(strcat(setq(m, first(rest(%4, |))), setq(s, rest(rest(%4, |))), setq(c, graball(%5, *comatose*, |)), case(0, not(strlen(set(%2, _clarity.mild:%qm))), #-1 Clarity Mild not set! Stopping!, not(strlen(set(%2, _clarity.severe:%qs))), #-1 Clarity Severe not set! Stopping after Mild set!, case(1, t(grab(%qc, Gains Persistent Comatose Condition, |)), u(f.healhurt-apply.condition, %1, persistent_comatose, Set by Clarity System for damage taken.), t(grab(%qc, Gains Comatose Condition, |)), u(f.healhurt-apply.condition, %1, comatose, Set by Clarity System for damage taken.), null(nothing else needed looked into)))))

&d.regex.healhurt [v(d.ccs)]=^(([^/]+)/)?([^=]+)(=(.+))?$

&f.healhurt-apply.condition [v(d.ccs)]=set(%0, _COND.%1.[secs()]:cond.%1|%2)

&f.healhurt-report [v(d.ccs)]=localize(strcat(setq(d, if(not(strmatch(%0, %1)), Dealt by [name(%0)] %(%0%))), iter(setunion(%0 %1,), pemit(%i0, u(display.healhurt.full, %1, %i0, %2, %3, %4, %qd))), iter(setdiff(lcon(loc(%1)), %0 %1), pemit(%i0, u(.msg, clarity, u(display.healhurt.action, %1, %i0, %2, %3, %4, %qd))))))

&display.healhurt.action [v(d.ccs)]=localize(strcat(if(setr(y, strmatch(%0, %1)), You, name(%0)), %b, take, if(%qy,, s), %b, %2 Clarity %3, if(strlen(%4), strcat(%b, and, %b, iter(trim(%4, b, |), %i0, |, %,%b))), ., if(strlen(%5), %b%(%5%))))

&display.healhurt.full [v(d.ccs)]=strcat(header(strcat(case(%3, damage, Losing, healing, Gaining, ???ing), %b, %2 Clarity)), %r, u(display.healhurt.action, %0, %1, %2, %3, %4), %r, Clarity is now:, %r, u(display.clarity-bar, %0), %r, footer(%5))

think Entry complete.
