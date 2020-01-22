think Adding calculated things to various advantages.

&ADVANTAGE.DEFENSE [v(d.dd)]=add(ladd(u(.value_full, %0, skill.athletics), .), min(ladd(u(.value_full, %0, attribute.wits).[udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(wits))], .), ladd(u(.value_full, %0, attribute.dexterity).[udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(dexterity))], .)), udefault(.value, 0, %0, discipline.celerity))

&ADVANTAGE.WEAPONRY_DEFENSE [v(d.dd)]=if(u(.has, %0, merit.defensive_combat_(weaponry)), add(ladd(u(.value_full, %0, skill.weaponry), .), min(ladd(u(.value_full, %0, attribute.wits), .), ladd(u(.value_full, %0, attribute.dexterity), .)), udefault(.value, 0, %0, discipline.celerity)), 0)

&ADVANTAGE.BRAWL_DEFENSE [v(d.dd)]=if(u(.has, %0, merit.defensive_combat_(brawl)), add(ladd(u(.value_full, %0, skill.brawl), .), min(ladd(u(.value_full, %0, attribute.wits), .), ladd(u(.value_full, %0, attribute.dexterity), .)), udefault(.value, 0, %0, discipline.celerity)), 0)

&ADVANTAGE.SIZE [v(d.dd)]=add(u(.value_stats, %0, special.size), u(.has, %0, merit.giant), mul(u(.has, %0, merit.small_framed), -1), if(u(.has, %0, atavism.looming_presence), u(.value, %0, advantage.lair), 0), switch(udefault(%0/_form.current, u(v(d.sfs)/f.default_form, u(%0/_bio.template))), dalu, 1, gauru, 2, urshul, 1, urhan, -1, 0))

&ADVANTAGE.SPEED [v(d.dd)]=add(u(.value_stats, %0, attribute.strength attribute.dexterity special.species_factor merit.fleet_of_foot discipline.vigor merit.strength_augmentation merit.augmented_speed), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(dexterity)), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(strength)), switch(udefault(%0/_form.current, u(v(d.sfs)/f.default_form, u(%0/_bio.template))), urshul, 3, urhan, 3, 0), switch(get(%0/_bio.seeming), Beast, 3, 0))

&ADVANTAGE.INITIATIVE [v(d.dd)]=add(u(.value_stats, %0, attribute.dexterity attribute.composure merit.fast_reflexes merit.augmented_speed), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(dexterity)), switch(get(%0/_bio.seeming), Beast, 3, 0))

think Setting up base attributes.

&ATTRIBUTE.INTELLIGENCE [v(d.dd)]=add(ladd(u(.value_full, %0, attribute.base_intelligence), .), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(intelligence)), udefault(.has, 0, %0, attribute.base_intelligence.favored))

&ATTRIBUTE.WITS [v(d.dd)]=add(ladd(u(.value_full, %0, attribute.base_wits), .), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(wits)), udefault(.has, 0, %0, attribute.base_wits.favored))

&ATTRIBUTE.RESOLVE [v(d.dd)]=add(ladd(u(.value_full, %0, attribute.base_resolve), .), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(resolve)), udefault(.has, 0, %0, attribute.base_resolve.favored))

&ATTRIBUTE.STRENGTH [v(d.dd)]=add(ladd(u(.value_full, %0, attribute.base_strength), .), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(strength)), ladd(u(.value_full, %0, merit.strength_augmentation), .), ladd(u(.value_full, %0, discipline.vigor), .), switch(udefault(%0/_form.current, u(v(d.sfs)/f.default_form, u(%0/_bio.template))), dalu, 1, gauru, 3, urshul, 2, 0), udefault(.has, 0, %0, attribute.base_strength.favored))

&ATTRIBUTE.DEXTERITY [v(d.dd)]=add(ladd(u(.value_full, %0, attribute.base_dexterity), .), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(dexterity)), switch(udefault(%0/_form.current, u(v(d.sfs)/f.default_form, u(%0/_bio.template))), urhan, 2, gauru, 1, urshul, 2, 0), udefault(.has, 0, %0, attribute.base_dexterity.favored))

&ATTRIBUTE.STAMINA [v(d.dd)]=add(ladd(u(.value_full, %0, attribute.base_stamina), .), ladd(u(.value_full, %0, merit.augmented_resilience), .), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(stamina)), switch(udefault(%0/_form.current, u(v(d.sfs)/f.default_form, u(%0/_bio.template))), dalu, 1, gauru, 2, urshul, 2, urhan, 1, 0), udefault(.has, 0, %0, attribute.base_stamina.favored))

&ATTRIBUTE.PRESENCE [v(d.dd)]=add(ladd(u(.value_full, %0, attribute.base_presence), .), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(presence)), udefault(.has, 0, %0, attribute.base_presence.favored))

&ATTRIBUTE.MANIPULATION [v(d.dd)]=add(ladd(u(.value_full, %0, attribute.base_manipulation), .), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(manipulation)), switch(udefault(%0/_form.current, u(v(d.sfs)/f.default_form, u(%0/_bio.template))), dalu, -1, urshul, -1, urhan, -1, 0), udefault(.has, 0, %0, attribute.base_manipulation.favored))

&ATTRIBUTE.COMPOSURE [v(d.dd)]=add(ladd(u(.value_full, %0, attribute.base_composure), .), udefault(.has, 0, %0, merit.embodiment_of_the_firstborn_(composure)), udefault(.has, 0, %0, attribute.base_composure.favored))

&ATTRIBUTE.BASE_PRESENCE [v(d.dd)]=1.2.3.4.5.6.7.8.9.10|favored

&ATTRIBUTE.BASE_INTELLIGENCE [v(d.dd)]=1.2.3.4.5.6.7.8.9.10|favored

&ATTRIBUTE.BASE_WITS [v(d.dd)]=1.2.3.4.5.6.7.8.9.10|favored

&ATTRIBUTE.BASE_RESOLVE [v(d.dd)]=1.2.3.4.5.6.7.8.9.10|favored

&ATTRIBUTE.BASE_STRENGTH [v(d.dd)]=1.2.3.4.5.6.7.8.9.10|favored

&ATTRIBUTE.BASE_DEXTERITY [v(d.dd)]=1.2.3.4.5.6.7.8.9.10|favored

&ATTRIBUTE.BASE_STAMINA [v(d.dd)]=1.2.3.4.5.6.7.8.9.10|favored

&ATTRIBUTE.BASE_MANIPULATION [v(d.dd)]=1.2.3.4.5.6.7.8.9.10|favored

&ATTRIBUTE.BASE_COMPOSURE [v(d.dd)]=1.2.3.4.5.6.7.8.9.10|favored

think Entry complete.
