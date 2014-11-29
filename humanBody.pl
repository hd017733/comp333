/*   "Human Body" -- a sample adventure game, by Hootan Daneshfar. 
	 http://www.csc.villanova.edu/~dmatusze/8310/assignments/adventure.html 
	 http://www.csc.villanova.edu/~dmatusze/8310/sleepy.pl */

/* In standard Prolog, all predicates are "dynamic": they
   can be changed during execution. SWI-Prolog requires such
   predicates to be specially marked. */

:- dynamic at/2, i_am_at/1, i_am_holding/1, alive/1, dead/1, freedom/1,
            visible_object/1.

/* This routine is purely for debugging purposes. */

dump :- listing(at), listing(i_am_at), listing(i_am_holding),
        listing(alive), listing(visible_object).

/* This defines my current location. */

i_am_at(esophagus).

path(esophagus, s, stomach).

/* These facts describe how the organs are connected. */

path(stomach, s, intestines) :- \+ alive(germ).	
path(stomach, s, intestines) :-
	alive(germ),
	write('You need to kill the germ.'), nl,
	!, fail.

 
path(stomach, n, esophagus).

path(stomach, s, intestines).
path(intestines, n, stomach).

path(intestines, w, appendix).
path(appendix, e, intestines).

path(appendix, w, freedom) :-  freedom(turkey).
path(appendix, w, freedom) :-
	write('You need to rupture the appendix first.'), nl,
	!, fail.

path(intestines, s, rectum).
path(rectum, n, intestines).



/* These facts tell where the various objects in the game
   are located. */

at(plasmaRay, esophagus).
at(germ, stomach).



/* These facts specify some game-specific information. */

alive(germ).

visible_object('plasmaRay').
visible_object('germ').


/* These rules describe how to grab a germ or plasmaRay  */

grab(germ) :-
    i_am_at(stomach),
	write('Dont touch that! you will get sick!!'), nl,
	!, fail.


grab(germ) :- 
	write('no germ to grab!!'), nl,
	!, fail.

grab(X) :-
        i_am_holding(X),
        write('already holding Plasma Ray'),
		nl,
		write('head toward the stomach and '),
		nl,
	    write('plasmaRayAttack the germ! '),
        nl.

grab(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(i_am_holding(X)),
        write('OK, got it.'),
        nl.

grab(_) :-
        write('It is not here.'),
        nl. 


n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).



/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        look.

go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
	visible_object(X),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).



leave :-
	write('exiting through the nearest exit.'), nl, nl,
	finish.


plasmaRayAttack(appendix) :-
	i_am_at(appendix),
	write('You fire the plasmaRay and burst a hole through the appendix.'), nl, nl,
	write('The mission is almost complete! Your mouth is starting to water. '), nl,
	write('You can almost already smell the whole chicken roasting inside '), nl,
	write('the duck, and the whole duck roasting inside the turkey, and the '), nl,
	write('the turkey roasting while wrapped in 25 lbs of bacon.  '), nl, nl,
	write('Just head west to compelete the mission! '), nl,
	retract(freedom(turkey)). 
	
	
	
plasmaRayAttack(germ) :-
	plasmaRayAttack.


plasmaRayAttack :-
	\+ i_am_holding(plasmaRay),
	write('You aren''t holding the plasmaRay!.'), nl,
	!, fail.

plasmaRayAttack :-
	i_am_at(stomach),
	\+ alive(germ),
	write('The germ is dead, but you continue shooting at it.'), nl.

plasmaRayAttack :-
	i_am_at(Place),
	\+ at(germ, Place),
	write('You shoot the plamsRAY, but you hit nothing'), nl.



plasmaRayAttack :-
	i_am_at(stomach),
	write('You shoot the plamsRAY.'), nl,
	write('Success! You killed the germ!'), nl,
	retract(alive(germ)). 

plasmaRayAttack :- /* For debugging... */
	write('You must have forgotten a case!', nl).




make_visible(X) :-
	visible_object(X).

make_visible(X) :-
	assert(visible_object(X)).











/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finish :-
        nl,
        write('The game is over. Please enter the "halt." command.'),
        nl.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Available commands are:'), nl,
        write('start.                   -- to start the game.'), nl,
        write('n. s. w. e.              -- to go north, south, west, east.'), nl,
        write('grab(Object).            -- to grab something.'), nl,
		write('plasmaRayAttack(Object). -- to attack something.'), nl,
        write('look.                    -- to examine current location.'), nl,
        write('instructions.            -- display instruction set.'), nl,
		write('leave.                   -- quit game.'), nl,
        write('halt.                    -- close window.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(esophagus) :-
	write('You are world famous Genetic engineer "Professor Xavier" You have used '), nl,
	write('cutting-edge science to shrink yourself. You and your wheelchair weigh  '), nl,
	write('27 picograms and you are inside the body of a sick turkey. More specifically,'), nl,
	write('you are sliding down the turkeys esophagus. Your mission is to kill the germ '), nl,
	write('making the turkey sick and to exit the turkey by heading south        -> ,'), nl,	
	write('(all so you can make it back to the mansion in time to cook and stuff the  ,'), nl,
	write('turkey for Thanksgiving. ) '), nl.



describe(stomach) :-
        write('You are in the stomach!'), nl.
	
describe(intestines) :- 
	write('you are in the intestines!'), nl. 

describe(appendix) :-
        write('You are staring at the appendix when you have a brilliant idea. '), nl, 
		write('You decide to burst through the appendix so you can escape the   '), nl,
		write('body of the Turkey via the open wound   '), nl.
	
describe(rectum) :-
		write('You are now stuck in the rectum of the turkey!'), nl,
        write('This place is too nasty and there is too much '), nl,
		write('stuffs in the way!!'), nl, nl,
		write('You should go a different way!!'), nl.

describe(freedom) :-
        write('Mission Complete!! You destroyed the germ'), nl,
		write('and saved the turkey!!! Now it is time to'), nl,
		write('decapitate,cook,stuff, and eat the turkey! '), nl, nl, nl,
		write('Enter Command "halt." to exit game. '), nl.



/* This is a special form, to call predicates during load time. */

:- retractall(i_am_holding(_)), start.
		