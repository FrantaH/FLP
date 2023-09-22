% -- Projekt: FLP - Varianta termínu - 4.	Rubikova kostka
% -- Autor: František Horázný
% -- Login: xhoraz02
% -- Rok: 2022

/** Využito ukázkového kódu zpracování vstupu v prologu
FLP 2020
autor: Martin Hyrs, ihyrs@fit.vutbr.cz
*/


start :-
		prompt(_, ''),
		read_lines(LL),
		split_lines(LL,S),
		ids(S,1),
		halt.



read_lines(Ls) :-
	read_line(L,C),
	( C == end_of_file, Ls = [] ;
	  read_lines(LLs), Ls = [L|LLs]
	).

/** cte radky ze standardniho vstupu, konci na LF nebo EOF */
read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),% atom_codes(C,[Cd]),
		[C|LL] = L).

/** testuje znak na EOF nebo LF */
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code == 10).



/** vstupem je seznam radku (kazdy radek je seznam znaku) */
split_lines([],[]).
split_lines([L|Ls],[H|T]) :- split_lines(Ls,T), split_line(L,H).

/** rozdeli radek na podseznamy */
split_line([],[[]]) :- !.
split_line([' '|T], [[]|S1]) :- !, split_line(T,S1).
split_line([32|T], [[]|S1]) :- !, split_line(T,S1).    % aby to fungovalo i s retezcem na miste seznamu
split_line([H|T], [[H|G]|S1]) :- split_line(T,[G|S1]). % G je prvni seznam ze seznamu seznamu G|S1


% spouští algoritmus opakovaně s větší a větší hloubkou (IDS algoritmus)
ids(In,Depth) :- process(In,[],Depth) ; (Depth_new is Depth + 1, ids(In,Depth_new)).

% test na složenou kostku, při dosažení maximální hloubky konec a fail a samotné provedení pohybu a rekurzivní volání algoritmu.
process(In,Seen,_) :- test_end(In),reverse([In|Seen],R), maplist(write_lines2,R),!.
process(_,_,0) :- !,fail.
process(In,Seen,Counter) :- move(In,Out,Seen), CC is Counter - 1, process(Out,[In|Seen],CC).

% test na již viděný stav
move(In,_,Seen) :- member(In,Seen), !, fail.
move(In,Out,_) :- move(In,Out).

% 6 různých pohybů na kostce, otočení proti směru hodin by šlo přidáním pravidla process s využitím místo move(In,Out) -> move (Out, In)
% , ale častěji by se prováděli zbytečné testy na dvojité otočení (180°), proto to není využito.
move([	%vrsek
	[[A1,A8,A7]],
	[[A2,A,A6]],
	[[A3,A4,A5]],
	[B,C,D,E],
	Q1,
	Q2,
	Q3,
	Q4,
	Q5
	],
	[
	[[A7,A6,A5]],
	[[A8,A,A4]],
	[[A1,A2,A3]],
	[E,B,C,D],
	Q1,
	Q2,
	Q3,
	Q4,
	Q5
	]).
move([	%spodek
	Q1,
	Q2,
	Q3,
	Q4,
	Q5,
	[A,B,C,D],
	[[A1,A8,A7]],
	[[A2,A0,A6]],
	[[A3,A4,A5]]
	],
	[
	Q1,
	Q2,
	Q3,
	Q4,
	Q5,
	[B,C,D,A],
	[[A7,A6,A5]],
	[[A8,A0,A4]],
	[[A1,A2,A3]]
	]).
move([	%předek
	[[A1,A8,A7]],
	[[A2,A0,A6]],
	[[A3,A4,A5]],
	[[B1,B8,B7],[C1,C8,C7],[D1,D8,D7],[E1,E8,E7]],
	[[B2,B0,B6],[C2,C0,C6],[D2,D0,D6],[E2,E0,E6]],
	[[B3,B4,B5],[C3,C4,C5],[D3,D4,D5],[E3,E4,E5]],
	[[F1,F8,F7]],
	[[F2,F0,F6]],
	[[F3,F4,F5]]
	],
	[
	[[A1,A8,A7]],
	[[A2,A0,A6]],
	[[C1,C2,C3]],
	[[B7,B6,B5],[F7,C8,C7],[D1,D8,D7],[E1,E8,A5]],
	[[B8,B0,B4],[F8,C0,C6],[D2,D0,D6],[E2,E0,A4]],
	[[B1,B2,B3],[F1,C4,C5],[D3,D4,D5],[E3,E4,A3]],
	[[E7,E6,E5]],
	[[F2,F0,F6]],
	[[F3,F4,F5]]	
	]).
move([	%pravý bok
	[[A1,A8,A7]],
	[[A2,A0,A6]],
	[[A3,A4,A5]],
	[[B1,B8,B7],[C1,C8,C7],[D1,D8,D7],[E1,E8,E7]],
	[[B2,B0,B6],[C2,C0,C6],[D2,D0,D6],[E2,E0,E6]],
	[[B3,B4,B5],[C3,C4,C5],[D3,D4,D5],[E3,E4,E5]],
	[[F1,F8,F7]],
	[[F2,F0,F6]],
	[[F3,F4,F5]]
	],
	[
	[[A1,A8,D3]],
	[[A2,A0,D2]],
	[[A3,A4,D1]],
	[[B1,B8,A7],[C7,C6,C5],[F5,D8,D7],[E1,E8,E7]],
	[[B2,B0,A6],[C8,C0,C4],[F6,D0,D6],[E2,E0,E6]],
	[[B3,B4,A5],[C1,C2,C3],[F7,D4,D5],[E3,E4,E5]],
	[[F1,F8,B7]],
	[[F2,F0,B6]],
	[[F3,F4,B5]]
	]).
move([	%zadek
	[[A1,A8,A7]],
	[[A2,A0,A6]],
	[[A3,A4,A5]],
	[[B1,B8,B7],[C1,C8,C7],[D1,D8,D7],[E1,E8,E7]],
	[[B2,B0,B6],[C2,C0,C6],[D2,D0,D6],[E2,E0,E6]],
	[[B3,B4,B5],[C3,C4,C5],[D3,D4,D5],[E3,E4,E5]],
	[[F1,F8,F7]],
	[[F2,F0,F6]],
	[[F3,F4,F5]]
	],
	[
	[[E3,E2,E1]],
	[[A2,A0,A6]],
	[[A3,A4,A5]],
	[[B1,B8,B7],[C1,C8,A1],[D7,D6,D5],[F3,E8,E7]],
	[[B2,B0,B6],[C2,C0,A8],[D8,D0,D4],[F4,E0,E6]],
	[[B3,B4,B5],[C3,C4,A7],[D1,D2,D3],[F5,E4,E5]],
	[[F1,F8,F7]],
	[[F2,F0,F6]],
	[[C5,C6,C7]]
	]).
move([	%levý bok
	[[A1,A8,A7]],
	[[A2,A0,A6]],
	[[A3,A4,A5]],
	[[B1,B8,B7],[C1,C8,C7],[D1,D8,D7],[E1,E8,E7]],
	[[B2,B0,B6],[C2,C0,C6],[D2,D0,D6],[E2,E0,E6]],
	[[B3,B4,B5],[C3,C4,C5],[D3,D4,D5],[E3,E4,E5]],
	[[F1,F8,F7]],
	[[F2,F0,F6]],
	[[F3,F4,F5]]
	],
	[
	[[B1,A8,A7]],
	[[B2,A0,A6]],
	[[B3,A4,A5]],
	[[F1,B8,B7],[C1,C8,C7],[D1,D8,A3],[E7,E6,E5]],
	[[F2,B0,B6],[C2,C0,C6],[D2,D0,A2],[E8,E0,E4]],
	[[F3,B4,B5],[C3,C4,C5],[D3,D4,A1],[E1,E2,E3]],
	[[D5,F8,F7]],
	[[D6,F0,F6]],
	[[D7,F4,F5]]
	]).

% test na složenou kostku
test_end([
	[[A,A,A]],
	[[A,A,A]],
	[[A,A,A]],
	[[B,B,B],[C,C,C],[D,D,D],[E,E,E]],
	[[B,B,B],[C,C,C],[D,D,D],[E,E,E]],
	[[B,B,B],[C,C,C],[D,D,D],[E,E,E]],
	[[F,F,F]],
	[[F,F,F]],
	[[F,F,F]]
	]).


/** vypise seznam radku (kazdy radek samostatne) */
write_lines2([]) :- nl.
write_lines2([H|T]) :- write_line(H), write_lines2(T).

% úprava pro výpis bez záverek a čárek
write_line([]) :- nl.
write_line([H|T]) :- print_arr_formated(H), write(' '), write_line(T).

print_arr_formated(H) :- atomic_list_concat(H, HH), write(HH).