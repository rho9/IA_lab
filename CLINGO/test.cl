%%%%%%%%%%%%%%%%%%%%%%%%
% TEST
%%%%%%%%%%%%%%%%%%%%%%%%

aula(aula_lettere1).
aula(aula_lettere2).

classe(prima_A).
%classe(prima_B).
%classe(seconda_A).
%classe(seconda_B).
%classe(terza_A).
%classe(terza_B).

% Lezioni
lezione(lettere).
lezione(matematica).
lezione(tecnologia).
lezione(musica).
lezione(inglese).
lezione(spagnolo).
lezione(religione).
lezione(arte).
lezione(scienze).
lezione(educazione_fisica).

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

insegna(docente_lettere_uno,lettere). 
insegna(docente_lettere_due,lettere). 


% ogni classe può seguire al più una lezione nello stesso momento
%0{classe_segue(L,O,G,C):lezione(L),ora(O),giorno(G)}1 :- classe(C).

% ogni aula può essere utilizzata al più da una sola classe nello stesso momento
%0{aula_usata(L,O,G,C,A):classe_segue(L,O,G,C)}1 :- aula(A).

% ogni classe ha 10 ore di lettere a settimana
3{ore_a_settimana(lettere,A,O,G,C):si_tiene_in(lettere,A),ora(O),giorno(G)}3 :- classe(C). % corretto

goal :- aula_usata(L1,O1,G1,C1,A1),
		%classe_segue(L3,O3,G3,C3),
		ore_a_settimana(L2,A2,O2,G2,C2).
:- not goal.

#show goal.