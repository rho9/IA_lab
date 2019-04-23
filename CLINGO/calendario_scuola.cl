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
docente(docente_uno).
docente(docente_due).
docente(docente_tre).
docente(docente_quattro).
docente(docente_cinque).
docente(docente_sei).
docente(docente_sette).
docente(docente_otto).
docente(docente_nove).
docente(docente_dieci).
docente(docente_undici).
docente(docente_dodici).
docente(docente_tredici).

% Classi
classe(prima_A).
classe(prima_B).
classe(seconda_A).
classe(seconda_B).
classe(terza_A).
classe(terza_B).

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
insegna(docente_educazione_fisica,educazione_fisica).


%%%%%%%%%%%%%%%%%%%%%%%%
% VINCOLI LEZIONI
%%%%%%%%%%%%%%%%%%%%%%%%

% ore lettere a settimana
10{ore_a_settimana(lettere,O,G,C):ora(O),giorno(G)}10 :- classe(C).

% ore matematica a settimana
4{ore_a_settimana(matematica,O,G,C):ora(O),giorno(G)}4 :- classe(C).

% ore scienze a settimana
2{ore_a_settimana(scienze,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ore inglese a settimana
3{ore_a_settimana(inglese,O,G,C):ora(O),giorno(G)}3 :- classe(C).

% ore spagnolo a settimana
2{ore_a_settimana(spagnolo,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ore musica a settimana
2{ore_a_settimana(musica,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ore tecnologia a settimana
2{ore_a_settimana(tecnologia,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ore arte a settimana
2{ore_a_settimana(arte,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ore educazione fisica a settimana
2{ore_a_settimana(educazione_fisica,O,G,C):ora(O),giorno(G)}2 :- classe(C).

% ore religione a settimana
1{ore_a_settimana(religione,O,G,C):ora(O),giorno(G)}1 :- classe(C).

#show ore_a_settimana/4.
% show serve perché altrimenti mostra anche tutto ciò che è in "RISORSE" e non si capisce più nulla