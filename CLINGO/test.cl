%%%%%%%%%%%%%%%%%%%%%%%%
% TEST
%%%%%%%%%%%%%%%%%%%%%%%%

aula(aula_lettere1).
aula(aula_lettere2).
aula(aula_matematica).

classe(prima_A).
classe(prima_B).
%classe(seconda_A).
%classe(seconda_B).
%classe(terza_A).
%classe(terza_B).

% Lezioni
lezione(lettere).
lezione(matematica).
%*lezione(tecnologia).
lezione(musica).
lezione(inglese).
lezione(spagnolo).
lezione(religione).
lezione(arte).
lezione(scienze).
lezione(educazione_fisica).*%

% Orario scuola
ora(otto_nove).
ora(nove_dieci).
ora(dieci_undici).
ora(undici_dodici).
ora(dodici_tredici).
ora(tredici_quattordici).
ora(quattordici_quindici).

% Giorni della settimana di scuola
giorno(lun).
giorno(mar).
giorno(mer).
giorno(gio).
giorno(ven).

si_tiene_in(lettere,aula_lettere1).
si_tiene_in(lettere,aula_lettere2).
si_tiene_in(matematica,aula_matematica).

insegna(docente_lettere_uno,lettere). 
insegna(docente_lettere_due,lettere). 
insegna(docente_matematica,matematica). 

% ogni aula può essere utilizzata al più da una sola classe nello stesso momento

:- aula_usata(A,O1,G),aula_usata(A,O2,G),O1!=O2.
:- aula_usata(A1,O,G),aula_usata(A2,O,G),A1!=A2.
:- aula_usata(A,O,G1),aula_usata(A,O,G2),G1!=G2.

:- classe_segue(L,O1,G,C),classe_segue(L,O2,G,C),O1!=O2.
:- classe_segue(L1,O,G,C),classe_segue(L2,O,G,C),L1!=L2.
:- classe_segue(L,O,G1,C),classe_segue(L,O,G2,C),G1!=G2.
:- classe_segue(L,O,G,C1),classe_segue(L,O,G,C2),C1!=C2.

aula_usata(A,O,G):- aula(A),ora(O),giorno(G).

classe_segue(L,O,G,C):- lezione(L),ora(O),giorno(G),classe(C).

%*:- aula(A),ora(O1),giorno(G),aula(A),ora(O2),giorno(G),O1!=O2.
:- aula(A),ora(O),giorno(G1),aula(A),ora(O),giorno(G2),G1=G2.
:- aula(A1),ora(O),giorno(G),aula(A2),ora(O),giorno(G),A1=A2.*%


% ogni classe può seguire al più una lezione nello stesso momento
%:- lezione(L1),ora(O1),giorno(G1),classe(C1),lezione(L2),ora(O2),giorno(G2),classe(C2),O1!=O2;G1!=G2;L1!=L2;C1!=C2.

% ogni classe può seguire al più una lezione nello stesso momento
%0{classe_segue(L,O,G,C):lezione(L),ora(O),giorno(G)}1 :- classe(C).

% ogni aula può essere utilizzata al più da una sola classe nello stesso momento
%0{aula_usata(O,G,A):ora(O),giorno(G)}1 :- aula(A).

% ogni classe ha 10 ore di lettere a settimana
10{ore_a_settimana(lettere,A,O,G,C):si_tiene_in(lettere,A),ora(O),giorno(G)}10 :- classe(C). % corretto

4{ore_a_settimana(matematica,A,O,G,C):si_tiene_in(matematica,A),ora(O),giorno(G)}4 :- classe(C). % corretto

goal :- %aula_usata(O,G,A),
		%classe_segue(L,O,G,C),
		ore_a_settimana(L,A,O,G,C).

:- not goal.

#show goal.
