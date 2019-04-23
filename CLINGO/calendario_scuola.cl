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
%*insegna(Docente, Materia, Ora, Giorno) :-
  docente(Docente),
  lezione(Materia),
  ora(Ora),
  giorno(Giorno).*%
    

%*materia_insegnata_da(M,D) :-
  lezione(M),
  docente(D).*%

% lettere ha due insegnanti
2{materia_insegnata_da(lettere,D):docente(D)}2.

% matematica ha quattro insegnanti
4{materia_insegnata_da(matematica,D): docente(D)}4.

% tecnologia ha un insegnante
1{materia_insegnata_da(tecnologia,D): docente(D)}1.

% musica ha un insegnante
1{materia_insegnata_da(musica,D): docente(D)}1.

% inglese ha un insegnante
1{materia_insegnata_da(inglese,D): docente(D)}1.

% spagnolo ha un insegnante
1{materia_insegnata_da(spagnolo,D): docente(D)}1.

% religione ha un insegnante
1{materia_insegnata_da(religione,D): docente(D)}1.

% arte ha un insegnante
1{materia_insegnata_da(arte,D): docente(D)}1.

% scienze ha quattro insegnanti
4{materia_insegnata_da(scienze,D): docente(D)}4.

% educazione_fisica ha un insegnante
1{materia_insegnata_da(educazione_fisica,D): docente(D)}1.

%ogni docente insegna una o due materie
1{materia_insegnata_da(M,D): lezione(M)}2  :- docente(D).

no_materie_diverse_stesso_insegnante_caso_uno :-
   materia_insegnata_da(M1,D),
   materia_insegnata_da(M2,D),
   M1!=M2,
   M1!=matematica,
   M2!=scienze.

goal :-
  materia_insegnata_da(M,D),
  not no_materie_diverse_stesso_insegnante_caso_uno.
  
:- not goal.

%*:- materia_insegnata_da(M1,D),
   materia_insegnata_da(M2,D),
   M1!=M2,
   M1!=matematica,
   M2!=scienze.
  
:- materia_insegnata_da(M1,D),
   materia_insegnata_da(M2,D),
   M1!=M2,
   M2!=matematica,
   M1!=scienze.*%

   
%UN PROF INSEGNA DUE MATERIE SOLO SE QUESTE SONO SCIENZE E MATE

#show materia_insegnata_da/2.
% show serve perché altrimenti mostra anche tutto ciò che è in "RISORSE" e non si capisce più nulla