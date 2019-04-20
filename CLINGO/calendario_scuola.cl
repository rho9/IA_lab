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
docente(docente_matematica_scienze_uno).
docente(docente_matematica_scienze_due).
docente(docente_scienze_uno).
docente(docente_scienze_due).
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
  
% ogni docente insegna una sola materia
1{insegna_materia(D,M): lezione(M)}1 :- docente(D).



#show insegna_materia/2.
% show serve perché altrimenti mostra anche tutto ciò che è in "RISORSE" e non si capisce più nulla