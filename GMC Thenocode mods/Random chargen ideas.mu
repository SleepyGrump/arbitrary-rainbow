@@ Requirements: wheader(), wfooter(), alert()

@create Random CG suggestions <RCS>=10
@set RCS=SAFE INHERIT

@fo me=&d.dd RCS=search(name=Data Dictionary <dd>)
@fo me=&d.nsc RCS=search(name=Newest Sheet Code <nsc>)
@fo me=&d.rcg RCS=search(name=Random CG suggestions <RCS>)

@desc [v(d.rcg)]=%R%BCommands:%R%R%Tcg/rand - trust the random. The random is your friend.%R%Tcg/concept - trust the random generator with your concept!%R%Tcg/dualkith - don't cross the kiths! Or do. Because it's awesome!%R


&d.month [v(d.rcg)]=January February March April May June July August September October November December

&d.January [v(d.rcg)]=lnum(1, 31)
&d.February [v(d.rcg)]=lnum(1, 28)
&d.March [v(d.rcg)]=lnum(1, 31)
&d.April [v(d.rcg)]=lnum(1, 30)
&d.May [v(d.rcg)]=lnum(1, 31)
&d.June [v(d.rcg)]=lnum(1, 30)
&d.July [v(d.rcg)]=lnum(1, 31)
&d.August [v(d.rcg)]=lnum(1, 31)
&d.September [v(d.rcg)]=lnum(1, 30)
&d.October [v(d.rcg)]=lnum(1, 31)
&d.November [v(d.rcg)]=lnum(1, 30)
&d.December [v(d.rcg)]=lnum(1, 31)

&d.eyes [v(d.rcg)]=brown blue green amber gray hazel
&d.hair [v(d.rcg)]=white gray red orange blond brown black

&d.colors [v(d.rcg)]=red orange yellow green blue purple brown black white rainbow
&d.letters [v(d.rcg)]=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

&d.skills [v(d.rcg)]=Academics|Computer|Crafts|Investigation|Medicine|Occult|Politics|Science|Athletics|Brawl|Drive|Firearms|Larceny|Stealth|Survival|Weaponry|Animal Ken|Empathy|Expression|Intimidation|Persuasion|Socialize|Streetwise|Subterfuge

&d.attributes [v(d.rcg)]=Strength|Dexterity|Stamina|Intelligence|Wits|Resolve|Composure|Presence|Manipulation

&d.virtue [v(d.rcg)]=Chastity Temperance Charity Diligence Patience Kindness Humility Fortitude Confidence

&d.vice [v(d.rcg)]=Rashness Impertinence Wrath Gluttony Vulgarity Vanity Pride Ambition Envy

&d.first_names [v(d.rcg)]=Avery Riley Jordan Angel Parker Sawyer Quinn Blake Hayden Taylor Alexis Rowan Charlie Emerson Finley Ariel Emery Morgan Elliot London Elliott Karter Reese Remington Payton Amari Phoenix Kendall Harley Rylan Marley Dallas Skyler Spencer Sage Kyrie Lyric Ellis Rory Remi Justice Ali Haven Tatum Kamryn

&d.last_names [v(d.rcg)]=Smith Johnson Williams Jones Brown Davis Miller Wilson Moore Taylor Anderson Thomas Jackson White Harris Martin Thompson Garcia Martinez Robinson Clark Rodriguez Lewis Lee Walker Hall Allen Young Hernandez King Wright Lopez Hill Scott Green Adams Baker Gonzalez Nelson Carter Mitchell Perez Roberts Turner Phillips Campbell Parker Evans Edwards Collins Stewart Sanchez Morris Rogers Reed Cook Morgan Bell Murphy Bailey Rivera Cooper Richardson Cox Howard Ward Torres Peterson Gray Ramirez James Watson Brooks Kelly Sanders Price Bennett Wood Barnes Ross Henderson Coleman Jenkins Perry Powell Long Patterson Hughes Flores Washington Butler Simmons Foster Gonzales Bryant Alexander Russell Griffin Diaz Hayes

&d.prefixes [v(d.rcg)]=Mr. Ms. Mx. Dr. Hon. Professor
&d.suffixes [v(d.rcg)]=Esquire II III IV V VI VII VIII Jr. Sr. DDS.

&d.job [v(d.rcg)]=programmer|trouble magnet|garbage collector|college student|hermit|mad scientist|sane scientist|horticulturalist|layabout|stay-at-home parent|writer|retail wage slave|fast food wage slave|ride-share driver|babysitter|wait staff|hotel staffer|janitor|barista|college dropout|professional homeless person|columnist|cartoonist|actor|comedian|doctor|lawyer|preacher|spammer|international super spy|super soldier|dog breeder|cat breeder|rodent breeder|entomologist|teacher|politician|librarian|fire-fighter|hacker|therapist|sex worker|banker|thief|cat burglar|dentist

&d.mood [v(d.rcg)]=angry happy sad bored friendly thoughtful caring posh solid respectable skeptical curious ambitious cantankerous stodgy self-sacrificing sarcastic

&d.who-is [v(d.rcg)]=independently wealthy|dazed and confused|misanthropic|jealous|poor as dirt|a straight shooter|afraid of commitment|on vacation|gullible|in a motorcycle club|perpetually tripping over their own feet|on the run

&d.who-has [v(d.rcg)]=a heart of gold|[setq(0, u(f.rand.list, mood))][art(%q0)] %q0 sibling|[rand(1, 100)] cats|[setq(0, u(f.rand.list, colors))][art(%q0)] %q0 car|nothing to their name|absolutely zero chill|children|a mortgage|been there, done that|a single nerve left|a steel spine|nothing left to lose

&f.bio [v(d.rcg)]=setdiff(udefault(v(d.nsc)/bio.default.%0, full_name birthdate concept virtue vice), template pack motley coterie seeming_regalia embrace_date bloodline)

&f.bio-stat [v(d.rcg)]=if(t(v(f.%0)), udefault(f.%0, Can't decide!, %1), udefault(f.rand-stat, Can't decide!, %0, %1))

&f.rand-stat [v(d.rcg)]=if(match(*, setr(0, u(f.pickrand, bio.%0))), udefault(f.rand.list, Can't decide!, %0), %q0)

&f.full_name [v(d.rcg)]=trim(squish(strcat(if(t(rand(2)), u(f.rand.list, prefixes)), %b, u(f.rand.list, first_names), %b, if(t(rand(2)), u(f.rand.list, letters).), %b, u(f.rand.list, last_names), %b, if(t(rand(2)), u(f.rand.list, suffixes)))))

&f.rand.year [v(d.rcg)]=rand(switch(%0, Vampire, 1000, Ghoul, 1500, Psychic Vampire, 1500, Changeling, 1900, sub(last(time()), 100)), sub(last(time()), 18))

&f.birthdate [v(d.rcg)]=strcat(setr(M, u(f.rand.list, month)), %b, u(f.rand.list, %qM), %,%b, u(f.rand.year, %qT))

&f.concept [v(d.rcg)]=strcat(titlestr(u(f.rand.list, mood)), %b, u(f.rand.list, job), %b, if(t(rand(2)), strcat(with, %b, u(f.rand.list, who-has)), strcat(who is, %b, u(f.rand.list, who-is))))

&f.pickrand [v(d.rcg)]=pickrand(xget(v(d.dd), %0), .)

&f.rand.list [v(d.rcg)]=strcat(setq(1, u(d.%0)), pickrand(%q1, switch(%q1, *|*, |, %b)))

&cmd-cg/rand [v(d.rcg)]=$cg/rand:@pemit %#=strcat(setq(T, u(f.pickrand, bio.template)), wheader(Random CG idea!), %r%r, %bYou should play, %b, art(%qT), %b, %qT, %b, with, %b, u(f.rand.list, eyes), %b, eyes and, %b, u(f.rand.list, hair), %b, hair. Here are some suggestions for your bio:, %r%r%t, ljust(Template:, 20), %b, %qT%r, iter(u(f.bio, %qT), strcat(%t, ljust(statname(itext(0)):, 20), %b, u(f.bio-stat, itext(0), %qT)),, %R), %r%r%b, Your best skill should be, %b, u(f.rand.list, skills), %b, and you should have high, %b, u(f.rand.list, attributes)., %r%r, wfooter())

&cmd-cg/concept [v(d.rcg)]=$cg/concept:@pemit %#=strcat(alert(You should play a...), %b, u(f.concept))

&cmd-cg/dualkith [v(d.rcg)]=$cg/dualkith:@pemit %#=strcat(alert(You should play a...), %b, u(f.pickrand, bio.kith), /, u(f.pickrand, bio.kith))

