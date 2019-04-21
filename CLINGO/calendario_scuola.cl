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
% VINCOLI
%%%%%%%%%%%%%%%%%%%%%%%%

% 6 ore di lezione al giorno, quindi 3 materie al giorno
% 6{lezioni_per_giorno(G,L): lezione(L)}6:- giorno(G).

%non so chi insegna, ma non ci sono sovrapposizioni nè di prof, nè di aulee
insegna(Docente, Materia, Ora, Giorno) :-
  docente(Docente),
  lezione(Materia),
  ora(Ora),
  giorno(Giorno).
    

%ogni materia è tenuta da almeno un professore
1{materia_insegnata_da(M,D): docente(D)}2  :- lezione(M).

% un professore non può insegnare due materie diverse a meno che queste non siano matematica e scienze
:- materia_insegnata_da(M1,D),
   materia_insegnata_da(M2,D),
   M1!=M2,
   M1!=matematica,
   M2!=scienze.

:- materia_insegnata_da(M1,D),
   materia_insegnata_da(M2,D),
   M1!=M2,
   M2!=matematica,
   M1!=scienze.
   
% solo mate, scienze e lettere hanno due professori
:- materia_insegnata_da(M,D1),
   materia_insegnata_da(M,D2),
   D1!=D2,
   M!=lettere.
   
:- materia_insegnata_da(M,D1),
   materia_insegnata_da(M,D2),
   D1!=D2,
   M!=matematica.
   
:- materia_insegnata_da(M,D1),
   materia_insegnata_da(M,D2),
   D1!=D2,
   M!=scienze.
   
%TUTTI I PROFESSORI DEVONO INSEGNARE QUALCOSA!!!

#show materia_insegnata_da/2.
% show serve perché altrimenti mostra anche tutto ciò che è in "RISORSE" e non si capisce più nulla