/*

NOLA's bloodlines code - pure GMC, with some brought up to date from the old 1e bloodlines. Bloodline concepts credit to Ganymede, who did the work of writing them up on NOLA's wiki.

I've included this here because the version on Thenomain's GMCCG repo relies on old 1e unconverted rules and there are a few bugs in it.

Feel free to edit and make your own, or reuse as-is with appropriate credit given to NOLA and Ganymede.

*/

think Entering 362 lines.

&bio.bloodline [v(d.dd)]=.

&prerequisite.bio.bloodline [v(d.dd)]=t(match(v(d.bloodline.[get(%0/_bio.clan)]), if(t(%2), %2, xget(%0, _bio.bloodline)), .))

&prereq-text.bio.bloodline [v(d.dd)]=Bloodline must match clan.

&tags.bio.bloodline [v(d.dt)]=vampire.ghoul

&notes.bio.bloodline [v(d.dt)]=iter(get(v(d.dd)/bio.clan), ansi(h, %i0, n, :%b, n, edit(get(v(d.dd)/d.bloodline.%i0), ., %,%b)), ., |)

&d.bloodline.daeva [v(d.dd)]=The Carnival.Septimi.Spina

@fo me=&BIO.BLOODLINE [v(d.dd)]=[trim(setunion(get(v(d.dd)/bio.bloodline), get(v(d.dd)/d.bloodline.daeva) .), b, .)]

@edit v(d.dt)/tags.discipline.protean=$, .the carnival

&devotion.contort [v(d.dd)]=-

&prerequisite.devotion.contort [v(d.dd)]=cand(u(.is, %0, bio.bloodline, .The Carnival), u(.at_least, %0, discipline.protean, 2))

&prereq-text.devotion.contort [v(d.dd)]=.The Carnival Bloodline Devotion;Protean 2

&tags.devotion.contort [v(d.dt)]=vampire.the carnival

&xp.devotion.contort [v(d.xpcd)]=1

&devotion.merge [v(d.dd)]=-

&prerequisite.devotion.merge [v(d.dd)]=cand(u(.is, %0, bio.bloodline, .The Carnival), u(.at_least_all, %0, discipline.majesty:2 discipline.protean:2))

&prereq-text.devotion.merge [v(d.dd)]=.The Carnival Bloodline Devotion;Majesty 2, Protean 2

&tags.devotion.merge [v(d.dt)]=vampire.the carnival

&xp.devotion.merge [v(d.xpcd)]=2

&devotion.octopod [v(d.dd)]=-

&prerequisite.devotion.octopod [v(d.dd)]=cand(u(.is, %0, bio.bloodline, .The Carnival), u(.at_least_all, %0, discipline.celerity:2 discipline.protean:2 discipline.vigor:2))

&prereq-text.devotion.octopod [v(d.dd)]=.The Carnival Bloodline Devotion;Celerity 2, Protean 2, Vigor 2

&tags.devotion.octopod [v(d.dt)]=vampire.the carnival

&xp.devotion.octopod [v(d.xpcd)]=3

&devotion.power_up [v(d.dd)]=-

&prerequisite.devotion.power_up [v(d.dd)]=cand(u(.is, %0, bio.bloodline, .The Carnival), u(.at_least_all, %0, discipline.celerity:2 discipline.protean:4 discipline.vigor:2))

&prereq-text.devotion.power_up [v(d.dd)]=.The Carnival Bloodline Devotion;Celerity 2, Protean 4, Vigor 2

&tags.devotion.power_up [v(d.dt)]=vampire.the carnival

&notes.devotion.power_up [v(d.dt)]=It's Over 9000

&xp.devotion.power_up [v(d.xpcd)]=4

@edit v(d.dt)/tags.discipline.nightmare=$, .spina

&devotion.churchtower_sermon [v(d.dd)]=Presence + Intimidation + Majesty vs. Composure + Blood Potency

&prerequisite.devotion.churchtower_sermon [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Spina), u(.at_least_all, %0, discipline.majesty:1 discipline.nightmare:1))

&prereq-text.devotion.churchtower_sermon [v(d.dd)]=Spina Bloodline Devotion;Majesty 1, Nightmare 1

&tags.devotion.churchtower_sermon [v(d.dt)]=vampire.spina

&xp.devotion.churchtower_sermon [v(d.xpcd)]=1

&devotion.fair_warning [v(d.dd)]=-

&prerequisite.devotion.fair_warning [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Spina), u(.at_least_all, %0, discipline.celerity:2 discipline.majesty:2 discipline.vigor:2))

&prereq-text.devotion.fair_warning [v(d.dd)]=Spina Bloodline Devotion;Celerity 2, Majesty 2, Vigor 2

&tags.devotion.fair_warning [v(d.dt)]=vampire.spina

&xp.devotion.fair_warning [v(d.xpcd)]=3

&devotion.the_importance_of_conversation [v(d.dd)]=-

&prerequisite.devotion.the_importance_of_conversation [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Spina), u(.at_least_all, %0, discipline.majesty:2 discipline.vigor:2))

&prereq-text.devotion.the_importance_of_conversation [v(d.dd)]=Spina Bloodline Devotion;Majesty 2, Vigor 2

&tags.devotion.the_importance_of_conversation [v(d.dt)]=vampire.spina

&xp.devotion.the_importance_of_conversation [v(d.xpcd)]=2

&devotion.the_penalty_for_discourtesy [v(d.dd)]=-

&prerequisite.devotion.the_penalty_for_discourtesy [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Spina), u(.at_least_all, %0, discipline.nightmare:2 discipline.vigor:2))

&prereq-text.devotion.the_penalty_for_discourtesy [v(d.dd)]=Spina Bloodline Devotion;Nightmare 2, Vigor 2

&tags.devotion.the_penalty_for_discourtesy [v(d.dt)]=vampire.spina

&xp.devotion.the_penalty_for_discourtesy [v(d.xpcd)]=2

@edit v(d.dt)/tags.discipline.auspex=$, .septimi

&devotion.burning_touch [v(d.dd)]=-

&prerequisite.devotion.burning_touch [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Septimi), u(.at_least_all, %0, discipline.celerity:3 discipline.vigor:3))

&prereq-text.devotion.burning_touch [v(d.dd)]=Septimi Bloodline Devotion;Celerity 3, Vigor 3

&tags.devotion.burning_touch [v(d.dt)]=vampire.septimi

&xp.devotion.burning_touch [v(d.xpcd)]=3

&devotion.divine_vengeance [v(d.dd)]=-

&prerequisite.devotion.divine_vengeance [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Septimi), u(.at_least_all, %0, discipline.auspex:2 discipline.celerity:2 discipline.majesty:2 discipline.vigor:2))

&prereq-text.devotion.divine_vengeance [v(d.dd)]=Septimi Bloodline Devotion;Auspex 2, Celerity 2, Majesty 2, Vigor 2

&tags.devotion.divine_vengeance [v(d.dt)]=vampire.septimi

&xp.devotion.divine_vengeance [v(d.xpcd)]=4

&devotion.exorcism [v(d.dd)]=-

&prerequisite.devotion.exorcism [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Septimi), u(.at_least_all, %0, discipline.auspex:2 discipline.vigor:2))

&prereq-text.devotion.exorcism [v(d.dd)]=Septimi Bloodline Devotion;Auspex 2, Vigor 2

&tags.devotion.exorcism [v(d.dt)]=vampire.septimi

&xp.devotion.exorcism [v(d.xpcd)]=2

&devotion.the_light_of_truth [v(d.dd)]=Resolve + Investigation + Auspex

&prerequisite.devotion.the_light_of_truth [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Septimi), u(.at_least_all, %0, discipline.auspex:1 discipline.majesty:1))

&prereq-text.devotion.the_light_of_truth [v(d.dd)]=Septimi Bloodline Devotion;Auspex 1, Majesty 1

&tags.devotion.the_light_of_truth [v(d.dt)]=vampire.septimi

&xp.devotion.the_light_of_truth [v(d.xpcd)]=2

&d.bloodline.gangrel [v(d.dd)]=Ahrimanes.Bacchae.Dead Wolves

@fo me=&BIO.BLOODLINE [v(d.dd)]=[trim(setunion(get(v(d.dd)/bio.bloodline), get(v(d.dd)/d.bloodline.gangrel), .), b, .)]

@edit v(d.dt)/tags.discipline.auspex=$, .ahrimanes

&devotion.consume_the_spirit [v(d.dd)]=Strength + Occult + Animalism vs. Power + Resistance

&prerequisite.devotion.consume_the_spirit [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Ahrimanes), u(.at_least_all, %0, discipline.animalism:4 discipline.resilience:2))

&prereq-text.devotion.consume_the_spirit [v(d.dd)]=Ahrimanes Bloodline Devotion;Animalism 4, Resilience 2

&tags.devotion.consume_the_spirit [v(d.dt)]=vampire.ahrimanes

&xp.devotion.consume_the_spirit [v(d.xpcd)]=3

&devotion.rend_the_gauntlet [v(d.dd)]=Resolve + Occult + Animalism

&prerequisite.devotion.rend_the_gauntlet [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Ahrimanes), u(.at_least_all, %0, discipline.auspex:4 discipline.protean:2))

&prereq-text.devotion.rend_the_gauntlet [v(d.dd)]=Ahrimanes Bloodline Devotion;Auspex 4, Protean 2

&tags.devotion.rend_the_gauntlet [v(d.dt)]=vampire.ahrimanes

&xp.devotion.rend_the_gauntlet [v(d.xpcd)]=3

&devotion.spirit_summoning [v(d.dd)]=Presence + Occult + Animalism (vs. Power + Resistance)

&prerequisite.devotion.spirit_summoning [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Ahrimanes), u(.at_least, %0, discipline.animalism, 4))

&prereq-text.devotion.spirit_summoning [v(d.dd)]=Ahrimanes Bloodline Devotion;Animalism 4

&tags.devotion.spirit_summoning [v(d.dt)]=vampire.ahrimanes

&xp.devotion.spirit_summoning [v(d.xpcd)]=2

&devotion.spiritual_aid [v(d.dd)]=Resolve + Occult + Animalism

&prerequisite.devotion.spiritual_aid [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Ahrimanes), u(.at_least_all, %0, discipline.animalism:2 discipline.auspex:2))

&prereq-text.devotion.spiritual_aid [v(d.dd)]=Ahrimanes Bloodline Devotion;Animalism 2, Auspex 2

&tags.devotion.spiritual_aid [v(d.dt)]=vampire.ahrimanes

&xp.devotion.spiritual_aid [v(d.xpcd)]=2

@edit v(d.dt)/tags.discipline.majesty=$, .bacchae

&devotion.friends_in_low_places [v(d.dd)]=-

&prerequisite.devotion.friends_in_low_places [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Bacchae), u(.at_least_all, %0, discipline.majesty:3 discipline.resilience:1))

&prereq-text.devotion.friends_in_low_places [v(d.dd)]=Bacchae Bloodline Devotion;Majesty 3, Resilience 1

&tags.devotion.friends_in_low_places [v(d.dt)]=vampire.bacchae

&xp.devotion.friends_in_low_places [v(d.xpcd)]=2

&devotion.i_gotta_feeling [v(d.dd)]=Presence + Expression + Animalism (vs. Resolve)

&prerequisite.devotion.i_gotta_feeling [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Bacchae), u(.at_least_all, %0, discipline.animalism:2 discipline.majesty:4 discipline.protean:2))

&prereq-text.devotion.i_gotta_feeling [v(d.dd)]=Bacchae Bloodline Devotion;Animalism 2, Majesty 4, Protean 2

&tags.devotion.i_gotta_feeling [v(d.dt)]=vampire.bacchae

&xp.devotion.i_gotta_feeling [v(d.xpcd)]=4

&devotion.i_know_you_want_me [v(d.dd)]=Presence + Empathy + Majesty vs. Resolve + Blood Potency

&prerequisite.devotion.i_know_you_want_me [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Bacchae), u(.at_least_all, %0, discipline.animalism:2 discipline.majesty:2 discipline.resilience:2))

&prereq-text.devotion.i_know_you_want_me [v(d.dd)]=Bacchae Bloodline Devotion;Animalism 2, Majesty 2, Resilience 2

&tags.devotion.i_know_you_want_me [v(d.dt)]=vampire.bacchae

&xp.devotion.i_know_you_want_me [v(d.xpcd)]=3

&devotion.party_up [v(d.dd)]=-

&prerequisite.devotion.party_up [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Bacchae), u(.at_least_all, %0, discipline.animalism:1 discipline.majesty:1))

&prereq-text.devotion.party_up [v(d.dd)]=Bacchae Bloodline Devotion;Animalism 1, Majesty 1

&tags.devotion.party_up [v(d.dt)]=vampire.bacchae

&xp.devotion.party_up [v(d.xpcd)]=1

@edit v(d.dt)/tags.discipline.vigor=$, .dead wolves

&devotion.dalu [v(d.dd)]=-

&prerequisite.devotion.dalu [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Dead Wolves), u(.at_least_all, %0, discipline.animalism:1 discipline.protean:2 discipline.vigor:1))

&prereq-text.devotion.dalu [v(d.dd)]=Dead Wolves Bloodline Devotion;Animalism 1, Protean 2, Vigor 1

&tags.devotion.dalu [v(d.dt)]=vampire.dead wolves

&xp.devotion.dalu [v(d.xpcd)]=2

&devotion.gauru [v(d.dd)]=-

&prerequisite.devotion.gauru [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Dead Wolves), u(.at_least_all, %0, discipline.animalism:2 discipline.protean:4 discipline.vigor:2))

&prereq-text.devotion.gauru [v(d.dd)]=Dead Wolves Bloodline Devotion;Animalism 2, Protean 4, Vigor 2

&tags.devotion.gauru [v(d.dt)]=vampire.dead wolves

&xp.devotion.gauru [v(d.xpcd)]=4

&devotion.the_hunter's_gaze [v(d.dd)]=-

&prerequisite.devotion.the_hunter's_gaze [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Dead Wolves), u(.at_least_all, %0, discipline.animalism:3 discipline.vigor:3))

&prereq-text.devotion.the_hunter's_gaze [v(d.dd)]=Dead Wolves Bloodline Devotion;Animalism 3, Vigor 3

&tags.devotion.the_hunter's_gaze [v(d.dt)]=vampire.dead wolves

&xp.devotion.the_hunter's_gaze [v(d.xpcd)]=3

&devotion.urshul [v(d.dd)]=-

&prerequisite.devotion.urshul [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Dead Wolves), u(.at_least_all, %0, discipline.animalism:3 discipline.protean:3))

&prereq-text.devotion.urshul [v(d.dd)]=Dead Wolves Bloodline Devotion;Animalism 3, Protean 3

&tags.devotion.urshul [v(d.dt)]=vampire.dead wolves

&xp.devotion.urshul [v(d.xpcd)]=3

&devotion.first_tongue [v(d.dd)]=-

&prerequisite.devotion.first_tongue [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Dead Wolves), u(.at_least_all, %0, discipline.animalism:1 discipline.protean:2))

&prereq-text.devotion.first_tongue [v(d.dd)]=Dead Wolves Bloodline Devotion;Animalism 1, Protean 2

&tags.devotion.first_tongue [v(d.dt)]=vampire.dead wolves

&xp.devotion.first_tongue [v(d.xpcd)]=1

&d.bloodline.mekhet [v(d.dd)]=Alucinor.Khaibit.Norvegi.Sta-Au

@fo me=&BIO.BLOODLINE [v(d.dd)]=[trim(setunion(get(v(d.dd)/bio.bloodline), get(v(d.dd)/d.bloodline.mekhet), .), b, .)]

@edit v(d.dt)/tags.discipline.nightmare=$, .alucinor

&devotion.blissful_sleep [v(d.dd)]=Manipulation + Persuasion + Nightmare vs Composure + Blood Potency

&prerequisite.devotion.blissful_sleep [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Alucinor), u(.at_least_all, %0, discipline.auspex:2 discipline.nightmare:2))

&prereq-text.devotion.blissful_sleep [v(d.dd)]=Alucinor Bloodline Devotion;Auspex 2, Nightmare 2

&tags.devotion.blissful_sleep [v(d.dt)]=vampire.alucinor

&xp.devotion.blissful_sleep [v(d.xpcd)]=2

&devotion.dream-bending [v(d.dd)]=Presence + Intimidation + Nightmare

&prerequisite.devotion.dream-bending [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Alucinor), u(.at_least_all, %0, discipline.nightmare:2 discipline.obfuscate:2))

&prereq-text.devotion.dream-bending [v(d.dd)]=Alucinor Bloodline Devotion;Nightmare 2, Obfuscate 2

&tags.devotion.dream-bending [v(d.dt)]=vampire.alucinor

&xp.devotion.dream-bending [v(d.xpcd)]=2

&devotion.imprint [v(d.dd)]=Presence + Persuasion + Nightmare vs Composure + Blood Potency

&prerequisite.devotion.imprint [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Alucinor), u(.at_least_all, %0, discipline.auspex:4 discipline.nightmare:2))

&prereq-text.devotion.imprint [v(d.dd)]=Alucinor Bloodline Devotion;Auspex 4, Nightmare 2

&tags.devotion.imprint [v(d.dt)]=vampire.alucinor

&xp.devotion.imprint [v(d.xpcd)]=3

&devotion.morpheus'_oubliette [v(d.dd)]=Intelligence + Empathy + Obfuscate vs. Composure + Blood Potency

&prerequisite.devotion.devotion.morpheus'_oubliette [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Alucinor), u(.at_least_all, %0, discipline.nightmare:3 discipline.obfuscate:5))

&prereq-text.devotion.devotion.morpheus'_oubliette [v(d.dd)]=Alucinor Bloodline Devotion;Nightmare 3, Obfuscate 5

&tags.devotion.devotion.morpheus'_oubliette [v(d.dt)]=vampire.alucinor

&xp.devotion.devotion.morpheus'_oubliette [v(d.xpcd)]=4

@edit v(d.dt)/tags.discipline.vigor=$, .khaibit

&devotion.udjat [v(d.dd)]=-

&prerequisite.devotion.udjat [v(d.dd)]=u(.is, %0, bio.bloodline, khaibit)

&prereq-text.devotion.udjat [v(d.dd)]=Khaibit Bloodline Devotion

&tags.devotion.udjat [v(d.dt)]=vampire.khaibit

&notes.devotion.udjat [v(d.dt)]=Gained for free upon joining the Khaibit|The first time a character experiences a clear manifestation of Obtenebration, he must succeed at a Resolve + Composure roll or suffer the Shaken Condition

&xp.devotion.udjat [v(d.xpcd)]=0

&devotion.tyet [v(d.dd)]=-

&prerequisite.devotion.tyet [v(d.dd)]=cand(u(.is, %0, bio.bloodline, khaibit), u(.at_least, %0, discipline.vigor, 2))

&prereq-text.devotion.tyet [v(d.dd)]=Khaibit Bloodline Devotion;Vigor 2

&tags.devotion.tyet [v(d.dt)]=vampire.khaibit

&notes.devotion.tyet [v(d.dt)]=The first time a character experiences a clear manifestation of Obtenebration, he must succeed at a Resolve + Composure roll or suffer the Shaken Condition

&xp.devotion.tyet [v(d.xpcd)]=2

&devotion.pseshkf [v(d.dd)]=-

&prerequisite.devotion.pseshkf [v(d.dd)]=cand(u(.is, %0, bio.bloodline, khaibit), u(.at_least, %0, discipline.vigor, 2))

&prereq-text.devotion.pseshkf [v(d.dd)]=Khaibit Bloodline Devotion;Vigor 2

&tags.devotion.pseshkf [v(d.dt)]=vampire.khaibit

&notes.devotion.pseshkf [v(d.dt)]=The first time a character experiences a clear manifestation of Obtenebration, he must succeed at a Resolve + Composure roll or suffer the Shaken Condition

&xp.devotion.pseshkf [v(d.xpcd)]=2

&devotion.ba [v(d.dd)]=-

&prerequisite.devotion.ba [v(d.dd)]=cand(u(.is, %0, bio.bloodline, khaibit), u(.at_least, %0, discipline.obfuscate, 2))

&prereq-text.devotion.ba [v(d.dd)]=Khaibit Bloodline Devotion;Obfuscate 2

&tags.devotion.ba [v(d.dt)]=vampire.khaibit

&notes.devotion.ba [v(d.dt)]=The first time a character experiences a clear manifestation of Obtenebration, he must succeed at a Resolve + Composure roll or suffer the Shaken Condition

&xp.devotion.ba [v(d.xpcd)]=2

&devotion.iteru [v(d.dd)]=-

&prerequisite.devotion.biterua [v(d.dd)]=cand(u(.is, %0, bio.bloodline, khaibit), u(.at_least, %0, discipline.celerity, 2))

&prereq-text.devotion.iteru [v(d.dd)]=Khaibit Bloodline Devotion;Celerity 2

&tags.devotion.iteru [v(d.dt)]=vampire.khaibit

&notes.devotion.iteru [v(d.dt)]=The first time a character experiences a clear manifestation of Obtenebration, he must succeed at a Resolve + Composure roll or suffer the Shaken Condition

&xp.devotion.iteru [v(d.xpcd)]=2

@edit v(d.dt)/tags.discipline.vigor=$, .norvegi

&devotion.face_off [v(d.dd)]=Presence + Medicine + Auspex - target's Stamina + Composure (extended action, requires 10 successes)

&prerequisite.devotion.face_off [v(d.dd)]=cand(u(.is, %0, bio.bloodline, norvegi), u(.at_least_all, %0, discipline.auspex:2 discipline.obfuscate:4 discipline.vigor:2))

&prereq-text.devotion.face_off [v(d.dd)]=Norvegi Bloodline Devotion;Auspex 2, Obfuscate 4, Vigor 2

&tags.devotion.face_off [v(d.dt)]=vampire.norvegi

&xp.devotion.face_off [v(d.xpcd)]=4

&devotion.fleshdart [v(d.dd)]=Strength + Athletics + Vigor - target's Defense

&prerequisite.devotion.fleshdart [v(d.dd)]=cand(u(.is, %0, bio.bloodline, norvegi), u(.at_least_all, %0, discipline.celerity:1 discipline.vigor:1))

&prereq-text.devotion.fleshdart [v(d.dd)]=Norvegi Bloodline Devotion;Celerity 1, Vigor 1

&tags.devotion.fleshdart [v(d.dt)]=vampire.norvegi

&xp.devotion.fleshdart [v(d.xpcd)]=1

&devotion.liquefy [v(d.dd)]=-

&prerequisite.devotion.liquefy [v(d.dd)]=cand(u(.is, %0, bio.bloodline, norvegi), u(.at_least_all, %0, discipline.celerity:3 discipline.vigor:3))

&prereq-text.devotion.liquefy [v(d.dd)]=Norvegi Bloodline Devotion;Celerity 3, Vigor 3

&tags.devotion.liquefy [v(d.dt)]=vampire.norvegi

&xp.devotion.liquefy [v(d.xpcd)]=3

&devotion.skewer [v(d.dd)]=-

&prerequisite.devotion.skewer [v(d.dd)]=cand(u(.is, %0, bio.bloodline, norvegi), u(.at_least_all, %0, discipline.celerity:2 discipline.vigor:2))

&prereq-text.devotion.skewer [v(d.dd)]=Norvegi Bloodline Devotion;Celerity 2, Vigor 2

&tags.devotion.skewer [v(d.dt)]=vampire.norvegi

&xp.devotion.skewer [v(d.xpcd)]=2

@edit v(d.dt)/tags.discipline.protean=$, .sta-au

&devotion.dead_traces [v(d.dd)]=-

&prerequisite.devotion.dead_traces [v(d.dd)]=cand(u(.is, %0, bio.bloodline, sta-au), u(.at_least, %0, discipline.auspex, 2))

&prereq-text.devotion.dead_traces [v(d.dd)]=Sta-Au Bloodline Devotion;Auspex 2

&tags.devotion.dead_traces [v(d.dt)]=vampire.sta-au

&xp.devotion.dead_traces [v(d.xpcd)]=1

&devotion.the_familiar_dead [v(d.dd)]=-

&prerequisite.devotion.the_familiar_dead [v(d.dd)]=cand(u(.is, %0, bio.bloodline, sta-au), u(.at_least, %0, discipline.obfuscate, 4))

&prereq-text.devotion.the_familiar_dead [v(d.dd)]=Sta-Au Bloodline Devotion;Obfuscate 4

&tags.devotion.the_familiar_dead [v(d.dt)]=vampire.sta-au

&xp.devotion.the_familiar_dead [v(d.xpcd)]=2

&devotion.ghost_walk [v(d.dd)]=-

&prerequisite.devotion.ghost_walk [v(d.dd)]=cand(u(.is, %0, bio.bloodline, sta-au), u(.at_least_all, %0, discipline.obfuscate:3 discipline.protean:5))

&prereq-text.devotion.ghost_walk [v(d.dd)]=Sta-Au Bloodline Devotion;Obfuscate 4, Protean 5

&tags.devotion.ghost_walk [v(d.dt)]=vampire.sta-au

&xp.devotion.ghost_walk [v(d.xpcd)]=4

&devotion.whisper_of_war [v(d.dd)]=-

&prerequisite.devotion.whisper_of_war [v(d.dd)]=cand(u(.is, %0, bio.bloodline, sta-au), u(.at_least_all, %0, discipline.celerity:3 discipline.protean:3))

&prereq-text.devotion.whisper_of_war [v(d.dd)]=Sta-Au Bloodline Devotion;Celerity 3, Protean 3

&tags.devotion.whisper_of_war [v(d.dt)]=vampire.sta-au

&xp.devotion.whisper_of_war [v(d.xpcd)]=3

&d.bloodline.nosferatu [v(d.dd)]=Adroanzi.Azerkatil.Cimitiere.Galloi

@fo me=&BIO.BLOODLINE [v(d.dd)]=[trim(setunion(get(v(d.dd)/bio.bloodline), get(v(d.dd)/d.bloodline.nosferatu), .), b, .)]

@edit v(d.dt)/tags.discipline.animalism=$, .adroanzi

&devotion.jubokko [v(d.dd)]=-

&prerequisite.devotion.jubokko [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Adroanzi), u(.at_least_all, %0, discipline.animalism:3 discipline.nightmare:3))

&prereq-text.jubokko [v(d.dd)]=Adroanzi Bloodline Devotion;Animalism 3, Nightmare 3

&tags.devotion.jubokko [v(d.dt)]=vampire.adroanzi

&xp.devotion.jubokko [v(d.xpcd)]=3

&devotion.silent_passage [v(d.dd)]=-

&prerequisite.devotion.silent_passage [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Adroanzi), u(.at_least_all, %0, discipline.animalism:1 discipline.obfuscare:1))

&prereq-text.silent_passage [v(d.dd)]=Adroanzi Bloodline Devotion;Animalism 1, Ofuscate 1

&tags.devotion.silent_passage [v(d.dt)]=vampire.adroanzi

&xp.devotion.silent_passage [v(d.xpcd)]=1

&devotion.synergy [v(d.dd)]=-

&prerequisite.devotion.synergy [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Adroanzi), u(.at_least_all, %0, discipline.animalism:2 discipline.vigor:2))

&prereq-text.synergy [v(d.dd)]=Adroanzi Bloodline Devotion;Animalism 2, Vigor 2

&tags.devotion.synergy [v(d.dt)]=vampire.adroanzi

&xp.devotion.synergy [v(d.xpcd)]=2

&devotion.treant [v(d.dd)]=-

&prerequisite.devotion.treant [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Adroanzi), u(.at_least_all, %0, discipline.animalism:4 discipline.vigor:4))

&prereq-text.treant [v(d.dd)]=Adroanzi Bloodline Devotion;Animalism 4, Vigor 4

&tags.devotion.treant [v(d.dt)]=vampire.adroanzi

&xp.devotion.treant [v(d.xpcd)]=4

@edit v(d.dt)/tags.discipline.celerity=$, .azerkatil

&devotion.cauldron_of_blood [v(d.dd)]=Resolve + Occult + Vigor vs. Stamina + Blood Potency

&prerequisite.devotion.cauldron_of_blood [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Azerkatil), u(.at_least_all, %0, discipline.celerity:3 discipline.nightmare:2 discipline.vigor:3))

&prereq-text.cauldron_of_blood [v(d.dd)]=Azerkatil Bloodline Devotion;Celerity 3, Nightmare 2, Vigor 3

&tags.devotion.cauldron_of_blood [v(d.dt)]=vampire.azerkatil

&xp.devotion.cauldron_of_blood [v(d.xpcd)]=4

&devotion.dragon's_fire [v(d.dd)]=-

&prerequisite.devotion.dragon's_fire [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Azerkatil), u(.at_least_all, %0, discipline.celerity:2 discipline.nightmare:2 discipline.vigor:2))

&prereq-text.dragon's_fire [v(d.dd)]=Azerkatil Bloodline Devotion;Celerity 2, Nightmare 2, Vigor 2

&tags.devotion.dragon's_fire [v(d.dt)]=vampire.azerkatil

&xp.devotion.dragon's_fire [v(d.xpcd)]=3

&devotion.serene_ferocity [v(d.dd)]=-

&prerequisite.devotion.serene_ferocity [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Azerkatil), u(.at_least_all, %0, discipline.celerity:2 discipline.vigor:2))

&prereq-text.serene_ferocity [v(d.dd)]=Azerkatil Bloodline Devotion;Celerity 2, Vigor 2

&tags.devotion.serene_ferocity [v(d.dt)]=vampire.azerkatil

&xp.devotion.serene_ferocity [v(d.xpcd)]=2

&devotion.will_against_the_wyrm [v(d.dd)]=-

&prerequisite.devotion.will_against_the_wyrm [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Azerkatil), u(.at_least_all, %0, discipline.nightmare:1 discipline.obfuscate:1))

&prereq-text.will_against_the_wyrm [v(d.dd)]=Azerkatil Bloodline Devotion;Nightmare 1, Obfuscate 1

&tags.devotion.will_against_the_wyrm [v(d.dt)]=vampire.azerkatil

&xp.devotion.will_against_the_wyrm [v(d.xpcd)]=1

@edit v(d.dt)/tags.discipline.auspex=$, .cimitiere

&devotion.call_the_loa [v(d.dd)]=-

&prerequisite.devotion.call_the_loa [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Cimitiere), u(.at_least_all, %0, discipline.auspex:4))

&prereq-text.call_the_loa [v(d.dd)]=Cimitiere Bloodline Devotion;Auspex 4

&tags.devotion.call_the_loa [v(d.dt)]=vampire.cimitiere

&xp.devotion.call_the_loa [v(d.xpcd)]=2

&devotion.the_loa's_banishment [v(d.dd)]=-

&prerequisite.devotion.the_loa's_banishment [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Cimitiere), u(.at_least_all, %0, discipline.auspex:4 discipline.vigor:2))

&prereq-text.the_loa's_banishment [v(d.dd)]=Cimitiere Bloodline Devotion;Auspex 4, Vigor 2

&tags.devotion.the_loa's_banishment [v(d.dt)]=vampire.cimitiere

&xp.devotion.the_loa's_banishment [v(d.xpcd)]=3

&devotion.the_loa's_favor [v(d.dd)]=Manipulation + Occult + Auspex - Gauntlet rating

&prerequisite.devotion.the_loa's_favor [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Cimitiere), u(.at_least_all, %0, discipline.auspex:4 discipline.nightmare:2))

&prereq-text.the_loa's_favor [v(d.dd)]=Cimitiere Bloodline Devotion;Auspex 4, Nightmare 2

&tags.devotion.the_loa's_favor [v(d.dt)]=vampire.cimitiere

&xp.devotion.the_loa's_favor [v(d.xpcd)]=3

&devotion.the_loa's_presence [v(d.dd)]=-

&prerequisite.devotion.the_loa's_presence [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Cimitiere), u(.at_least_all, %0, discipline.nightmare:2 discipline.obfuscate:4))

&prereq-text.the_loa's_presence [v(d.dd)]=Cimitiere Bloodline Devotion;Nightmare 2, Obfuscate 4

&tags.devotion.the_loa's_presence [v(d.dt)]=vampire.cimitiere

&xp.devotion.the_loa's_presence [v(d.xpcd)]=3

@edit v(d.dt)/tags.discipline.majesty=$, .Galloi

&devotion.transgression_of_attis [v(d.dd)]=Presence + Occult + Blood Potency

&prerequisite.devotion.transgression_of_attis [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Galloi), u(.at_least_all, %0, discipline.majesty:2 discipline.nightmare:2 discipline.obfuscate:2))

&prereq-text.transgression_of_attis [v(d.dd)]=Galloi Bloodline Devotion;Majesty 2, Nightmare 2, Obfuscate 2

&tags.devotion.transgression_of_attis [v(d.dt)]=vampire.Galloi

&xp.devotion.transgression_of_attis [v(d.xpcd)]=3

&devotion.enliven_the_flesh [v(d.dd)]=Presence + Occult + Majesty

&prerequisite.devotion.enliven_the_flesh [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Galloi), u(.at_least_all, %0, discipline.obfuscate:2 discipline.majesty:2 discipline.vigor:1))

&prereq-text.enliven_the_flesh [v(d.dd)]=Galloi Bloodline Devotion; Obfuscate 2, Majesty 2, Vigor 1

&tags.devotion.enliven_the_flesh [v(d.dt)]=vampire.Galloi

&xp.devotion.enliven_the_flesh [v(d.xpcd)]=2

&devotion.even_the_servant_shines [v(d.dd)]=-

&prerequisite.devotion.even_the_servant_shines [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Galloi), u(.at_least_all, %0, discipline.obfucate:2 discipline.majesty:2 discipline.vigor:1))

&prereq-text.even_the_servant_shines [v(d.dd)]=Galloi Bloodline Devotion; Obfuscate 2, Majesty 2, Vigor 1

&tags.devotion.even_the_servant_shines [v(d.dt)]=vampire.Galloi

&xp.devotion.even_the_servant_shines [v(d.xpcd)]=2

&devotion.fooling_the_eye [v(d.dd)]=Manipulation + Stealth + Obfuscate vs subject's Composure + Blood Potency (if unwilling)

&prerequisite.devotion.fooling_the_eye [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Galloi), u(.at_least_all, %0, discipline.obfuscate:3))

&prereq-text.fooling_the_eye [v(d.dd)]=Galloi Bloodline Devotion; Obfuscate 3

&tags.devotion.fooling_the_eye [v(d.dt)]=vampire.Galloi

&xp.devotion.fooling_the_eye [v(d.xpcd)]=1

&d.bloodline.ventrue [v(d.dd)]=Apollinaire.Icarians.Rotgrafen

@fo me=&BIO.BLOODLINE [v(d.dd)]=[trim(setunion(get(v(d.dd)/bio.bloodline), get(v(d.dd)/d.bloodline.ventrue), .), b, .)]

@edit v(d.dt)/tags.discipline.auspex=$, .apollinaire

&devotion.bargain_with_the_air [v(d.dd)]=-

&prerequisite.devotion.bargain_with_the_air [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Apollinaire), u(.at_least_all, %0, discipline.animalism:2 discipline.auspex:2))

&prereq-text.bargain_with_the_air [v(d.dd)]=Apollinaire Bloodline Devotion;Animalism 2, Auspex 2

&tags.devotion.bargain_with_the_air [v(d.dt)]=vampire.apollinaire

&xp.devotion.bargain_with_the_air [v(d.xpcd)]=2

&devotion.manifest_the_portal [v(d.dd)]=-

&prerequisite.devotion.manifest_the_portal [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Apollinaire), u(.at_least_all, %0, discipline.auspex:3 discipline.resilience:3))

&prereq-text.manifest_the_portal [v(d.dd)]=Apollinaire Bloodline Devotion;Auspex 3, Resilience 3

&tags.devotion.manifest_the_portal [v(d.dt)]=vampire.apollinaire

&xp.devotion.manifest_the_portal [v(d.xpcd)]=3

&devotion.open_baye [v(d.dd)]=Wits + Occult + Auspex

&prerequisite.devotion.open_baye [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Apollinaire), u(.at_least_all, %0, discipline.animalism:2 discipline.auspex:2 discipline.dominate:2 discipline.resilience:2))

&prereq-text.open_baye [v(d.dd)]=Apollinaire Bloodline Devotion;Animalism 2, Auspex 2, Dominate 2, Resilience 2

&tags.devotion.open_baye [v(d.dt)]=vampire.apollinaire

&xp.devotion.open_baye [v(d.xpcd)]=4

&devotion.the_sixth_sense [v(d.dd)]=-

&prerequisite.devotion.the_sixth_sense [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Apollinaire), u(.at_least_all, %0, discipline.auspex:2))

&prereq-text.the_sixth_sense [v(d.dd)]=Apollinaire Bloodline Devotion;Auspex 2

&tags.devotion.the_sixth_sense [v(d.dt)]=vampire.apollinaire

&xp.devotion.the_sixth_sense [v(d.xpcd)]=1

@edit v(d.dt)/tags.discipline.vigor=$, .icarians

&devotion.fear_denies_faith [v(d.dd)]=-

&prerequisite.devotion.fear_denies_faith [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Icarians), cand(u(.has, %0, disicpline.animalism), u(.has_one_of, %0, discipline.resilience discipline.vigor)))

&prereq-text.devotion.fear_denies_faith [v(d.dd)]=Icarians Bloodline Devotion;Animalism 1, and one of Resilience 1 or Vigor 1

&tags.devotion.fear_denies_faith [v(d.dt)]=vampire.icarians

&xp.devotion.fear_denies_faith [v(d.xpcd)]=1

&devotion.pain_cleanses_the_body [v(d.dd)]=Stamina + Athletics + Vigor

&prerequisite.devotion.pain_cleanses_the_body [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Icarians), u(.at_least_all, %0, discipline.resilience:3 discipline.vigor:3))

&prereq-text.devotion.pain_cleanses_the_body [v(d.dd)]=Icarians Bloodline Devotion;Resilience 3, Vigor 3

&tags.devotion.pain_cleanses_the_body [v(d.dt)]=vampire.icarians

&xp.devotion.pain_cleanses_the_body [v(d.xpcd)]=3

&devotion.purge_the_unclean [v(d.dd)]=-

&prerequisite.devotion.purge_the_unclean [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Icarians), u(.at_least_all, %0, discipline.dominate:2 discipline.vigor:2))

&prereq-text.devotion.purge_the_unclean [v(d.dd)]=Icarians Bloodline Devotion;Dominate 2, Vigor 2

&tags.devotion.purge_the_unclean [v(d.dt)]=vampire.icarians

&xp.devotion.purge_the_unclean [v(d.xpcd)]=2

&devotion.work_earns_salvation [v(d.dd)]=Intelligence + Empathy + Dominate - target's Resolve

&prerequisite.devotion.work_earns_salvation [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Icarians), u(.at_least_all, %0, discipline.animalism:2 discipline.dominate:2))

&prereq-text.devotion.work_earns_salvation [v(d.dd)]=Icarians Bloodline Devotion;Animalism 2, Dominate 2

&tags.devotion.work_earns_salvation [v(d.dt)]=vampire.icarians

&xp.devotion.work_earns_salvation [v(d.xpcd)]=2

@edit v(d.dt)/tags.discipline.protean=$, .rotgrafen

&devotion.the_hidden_master [v(d.dd)]=-

&prerequisite.devotion.the_hidden_master [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Rotgrafen), u(.at_least_all, %0, discipline.animalism:5 discipline.protean:1))

&prereq-text.devotion.the_hidden_master [v(d.dd)]=Rotgrafen Bloodline Devotion;Animalism 5, Protean 1

&tags.devotion.the_hidden_master [v(d.dt)]=vampire.rotgrafen

&xp.devotion.the_hidden_master [v(d.xpcd)]=3

&devotion.rime_of_salt [v(d.dd)]=-

&prerequisite.devotion.rime_of_salt [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Rotgrafen), u(.at_least_all, %0, discipline.protean:2))

&prereq-text.devotion.rime_of_salt [v(d.dd)]=Rotgrafen Bloodline Devotion;Protean 2

&tags.devotion.rime_of_salt [v(d.dt)]=vampire.rotgrafen

&xp.devotion.rime_of_salt [v(d.xpcd)]=1

&devotion.swift_flows_the_blood [v(d.dd)]=Intelligence + Medicine + Protean

&prerequisite.devotion.swift_flows_the_blood [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Rotgrafen), u(.at_least_all, %0, discipline.protean:2 discipline.resilience:2))

&prereq-text.devotion.swift_flows_the_blood [v(d.dd)]=Rotgrafen Bloodline Devotion;Protean 2, Resilience 2

&tags.devotion.swift_flows_the_blood [v(d.dt)]=vampire.rotgrafen

&xp.devotion.swift_flows_the_blood [v(d.xpcd)]=2

&devotion.theft_of_vitae [v(d.dd)]=-

&prerequisite.devotion.theft_of_vitae [v(d.dd)]=cand(u(.is, %0, bio.bloodline, Rotgrafen), u(.at_least_all, %0, discipline.dominate:4 discipline.protean:2 discipline.resilience:2))

&prereq-text.devotion.theft_of_vitae [v(d.dd)]=Rotgrafen Bloodline Devotion;Dominate 4, Protean 2, Resilience 2

&tags.devotion.theft_of_vitae [v(d.dt)]=vampire.rotgrafen

&xp.devotion.theft_of_vitae [v(d.xpcd)]=2

think Entry complete.
think Don't forget to add the entry to the sheet under default.bio.vampire!