%%%%%%%%%%%%%%%%%%%%%%%%
% RISORSE
%%%%%%%%%%%%%%%%%%%%%%%%

% Aule
aula(aula_lettere).
aula(aula_matematica).
aula(aula_tecnologia).
aula(aula_musica).
aula(aula_inglese).
aula(aula_spagnolo).
aula(aula_religione).

% Laboratori
laboratorio(lab_arte).
laboratorio(lab_scienze).
laboratorio(lab_educazione_fisica).

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

% Docenti disponibili
docente(docente_lettere_uno).
docente(docente_lettere_due).
docente(docente_mate_scie_uno).
docente(docente_mate_scie_due).
docente(docente_mate_scie_tre).
docente(docente_mate_scie_quattro).
docente(docente_tecnologia).
docente(docente_musica).
docente(docente_inglese).
docente(docente_spagnolo).
docente(docente_religione).
docente(docente_arte).
docente(docente_educazione_fisica).

% Classi
classe(prima_A).
classe(prima_B).
classe(seconda_A).
classe(seconda_B).
classe(terza_A).
classe(terza_B).

% Tipologia classi
tempo_prol(prima_A).
tempo_prol(seconda_A).
tempo_prol(terza_A).
tempo_norm(pirma_B).
tempo_norm(seconda_B).
tempo_norm(terza_B).

% Giorni della settimana di scuola
giorno(lun).
giorno(mar).
giorno(mer).
giorno(gio).
giorno(ven).

% Orario scuola
ora(otto_nove).
ora(nove_dieci).
ora(dieci_undici).
ora(undici_dodici).
ora(dodici_tredici).
ora(tredici_quattordici).
ora(quattordici_quindici).

%%%%%%%%%%%%%%%%%%%%%%%%
% VINCOLI PROFESSORI
%%%%%%%%%%%%%%%%%%%%%%%%   

insegna(docente_lettere_uno,lettere). 
insegna(docente_lettere_due,lettere). 
insegna(docente_mate_scie_uno,matematica). 
insegna(docente_mate_scie_due,matematica). 
insegna(docente_mate_scie_tre,matematica). 
insegna(docente_mate_scie_quattro,matematica). 
insegna(docente_tecnologia,tecnologia). 
insegna(docente_musica,musica). 
insegna(docente_inglese,inglese). 
insegna(docente_spagnolo,spagnolo). 
insegna(docente_religione,religione). 
insegna(docente_arte,arte). 
insegna(docente_mate_scie_uno,scienze). 
insegna(docente_mate_scie_due,scienze). 
insegna(docente_mate_scie_tre,scienze). 
insegna(docente_mate_scie_quattro,scienze).
insegna(docente_educazione_fisica ,educazione_fisica).


%%%%%%%%%%%%%%%%%%%%%%%%
% VINCOLI LEZIONI
%%%%%%%%%%%%%%%%%%%%%%%%

% ogni classe ha 10 ore di lettere a settimana
10{ore_a_settimana(lettere,aula_lettere,O,G,C):ora(O),giorno(G)}10 :- classe(C).

% ogni classe ha 4 ore di matematica a settimana
4{ore_a_settimana(matematica,aula_matematica,O,G,C):ora(O),giorno(G)}4 :- classe(C).

% ogni classe ha 2 ore di scienze a settimana
2{ore_a_settimana(scienze,lab_scienze,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ogni classe ha 3 ore di inglese a settimana
3{ore_a_settimana(inglese,aula_inglese,O,G,C):ora(O),giorno(G)}3 :- classe(C).

% ogni classe ha 2 ore di spagnolo a settimana
2{ore_a_settimana(spagnolo,aula_spagnolo,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ogni classe ha 2 ore di musica a settimana
2{ore_a_settimana(musica,aula_musica,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ogni classe ha 2 ore di tecnologia a settimana
2{ore_a_settimana(tecnologia,aula_tecnologia,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ogni classe ha 2 ore di arte a settimana
2{ore_a_settimana(arte,lab_arte,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ogni classe ha 2 ore di educazione fisica a settimana
2{ore_a_settimana(educazione_fisica,lab_educazione_fisica,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ogni classe ha un ora di religione a settimana
1{ore_a_settimana(religione,aula_religione,O,G,C):ora(O),giorno(G)}1 :- classe(C).


%%%%%%%%%%%%%%%%%%%%%%%%
% VINCOLI TEMPORALI
%%%%%%%%%%%%%%%%%%%%%%%%

% ogni classe può seguire al più una lezione nello stesso momento
0{classe_segue(L,O,G,C):lezione(L),ora(O),giorno(G)}1 :- classe(C).

% ogni professore può tenere al più una lezione nello stesso momento
0{prof_insegna(D,L,O,G):insegna(D,L),ora(O),giorno(G)}1 :- docente(D).

% ogni aula può essere utilizzata al più da una sola classe nello stesso momento
0{aula_usata(D,L,O,G,A):insegna(D,L),ora(O),giorno(G)}1 :- aula(A).

% uguale per lab
0{aula_usata(D,L,O,G,LAB):insegna(D,L),ora(O),giorno(G)}1 :- laboratorio(LAB).

% le classi a tempo prolungato non possono avere lezione durante l'ora di pranzo: tredici_quattordici
0{classe_segue(L,tredici_quattordici,G,C):lezione(L),giorno(G)}0 :- tempo_prol(C).

% le classi a tempo normale non possono avere lezione dalle quattordici alla quindici
0{classe_segue(L,quattordici_quindici,G,C):lezione(L),giorno(G)}0 :- tempo_norm(C).

goal :- ore_a_settimana(Lezione1, Aula, Ora1, Giorno1, Classe),
		prof_insegna(Docente1, Lezione2, Ora2, Giorno2),
		classe_segue(Docente, Lezione, Ora, Giorno),
		aula_usata(Docente2, Lezione3, Ora3, Giorno3, Luogo).
:- not goal.

% classe seguita sempre da stessi prof SCELTA NOSTRA, NON è DA SPECIFICHE
% 0-> nessuno. 1 -> docente_uno. 2 -> docente_due
lettere(0,0,0,0,0,0).
matematica(0,0,0,0,0,0).
scienze(0,0,0,0,0,0).

% classi(prima_A, seconda_A, terza_A, prima_B, seconda_B, terza_B). ordine con cui vengono associati i numeri: x+y mi da la posizione
num_sezioni(2).
num_anni(3).

%prof_assegnato(L,M,S,V) :-
%  lettere(L),
%  num_anni(A),

#show ore_a_settimana/5.
% show serve perché altrimenti mostra anche tutto ciò che è in "RISORSE" e non si capisce più nulla