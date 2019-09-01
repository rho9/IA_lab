%%%%%%%%%%%%%%%%%%%%%%%%
% TO-DO
%%%%%%%%%%%%%%%%%%%%%%%%

% frequenza di attività extrascolastiche
% check che professori, aule e classi facciano le stesse cose

%%%%%%%%%%%%%%%%%%%%%%%%
% RISORSE
%%%%%%%%%%%%%%%%%%%%%%%%

% Aule
aula(a_lettere1;
     a_lettere2;
     a_matematica;
     a_tecnologia;
     a_musica;
     a_inglese;
     a_spagnolo;
     a_religione).

% Laboratori
laboratorio(l_arte;
            l_scienze;
            l_educazione_fisica).

% Docenti
docente(d_lettere1;
        d_lettere2;
        d_matematica_scienze1;
        d_matematica_scienze2;
        d_tecnologia;
        d_musica;
        d_inglese;
        d_spagnolo;
        d_religione;
        d_arte;
        d_educazione_fisica).

% Classi
classe(1..3,a).
classe(1..3,b).

% Tipologie di lezioni
lezione(lettere;
        matematica;
        tecnologia;
        musica;
        inglese;
        spagnolo;
        religione;
        arte;
        scienze;
        educazione_fisica).

% Regimi di frequenza
tempo_prolungato(1..3,a).
tempo_normale(1..3,b).

% Giorni della settimana
giorno(lun;
       mar;
       mer;
       gio;
       ven).

% Orario lezioni
ora(8,9;
    9,10;
    10,11;
    11,12;
    12,13;
    13,14;
    14,15).

% Orario mensa
mensa(12,13).

% Quali lezioni tengono i professori
insegna(
        (d_lettere1;
         d_lettere2),
            lettere;
        (d_matematica_scienze1;
         d_matematica_scienze2),
            (matematica;
             scienze);
        d_tecnologia,tecnologia;
        d_musica,musica;
        d_inglese,inglese;
        d_spagnolo,spagnolo;
        d_religione,religione;
        d_arte,arte;
        d_educazione_fisica,educazione_fisica).

% Aule e laboratori in cui vengono tenute le lezioni
si_tiene_in(lettere,(a_lettere1;a_lettere2);
            matematica, a_matematica;
            tecnologia,a_tecnologia;
            musica,a_musica;
            inglese,a_inglese;
            spagnolo,a_spagnolo;
            religione,a_religione;
            arte,l_arte;
            scienze,l_scienze;
            educazione_fisica,l_educazione_fisica).


%%%%%%%%%%%%%%%%%%%%%%%%
% VINCOLI
%%%%%%%%%%%%%%%%%%%%%%%%

% ci sono 35 slot per ogni aula. Ogni slot è identificato da giorno, fascia oraria (I,F) ed aula
35{slot(I,F,G,A): ora(I,F),giorno(G)}35 :- aula(A).

% ci sono 35 slot per ogni laboratorio. Ogni slot è identificato da giorno, fascia oraria (I,F) ed aula
35{slot(I,F,G,L): ora(I,F),giorno(G)}35 :- laboratorio(L).

% 10 ore a settimana (lettere)
10{orario(D,lettere,A,I,F,G,C,S): ha_lezione(D,lettere,C,S,I,F,G,A)}10 :- classe(C,S).
 
% 4 ore a settimana (matematica)
4{orario(D,matematica,A,I,F,G,C,S): ha_lezione(D,matematica,C,S,I,F,G,A)}4 :- classe(C,S).

% 3 ore a settimana (inglese)
3{orario(D,inglese,A,I,F,G,C,S): ha_lezione(D,inglese,C,S,I,F,G,A)}3 :- classe(C,S).

% 2 ore a settimana (scienze)
2{orario(D,scienze,A,I,F,G,C,S): ha_lezione(D,scienze,C,S,I,F,G,A)}2 :- classe(C,S).

% 2 ore a settimana (spagnolo)
2{orario(D,spagnolo,A,I,F,G,C,S): ha_lezione(D,spagnolo,C,S,I,F,G,A)}2 :- classe(C,S).

% 2 ore a settimana (musica)
2{orario(D,musica,A,I,F,G,C,S): ha_lezione(D,musica,C,S,I,F,G,A)}2 :- classe(C,S).

% 2 ore a settimana (tecnologia)
2{orario(D,tecnologia,A,I,F,G,C,S): ha_lezione(D,tecnologia,C,S,I,F,G,A)}2 :- classe(C,S).

% 2 ore a settimana (arte)
2{orario(D,arte,A,I,F,G,C,S): ha_lezione(D,arte,C,S,I,F,G,A)}2 :- classe(C,S).

% 2 ore a settimana (educazione fisica)
2{orario(D,educazione_fisica,A,I,F,G,C,S): ha_lezione(D,educazione_fisica,C,S,I,F,G,A)}2 :- classe(C,S).

% 1 ora a settimana (religione)
1{orario(D,religione,A,I,F,G,C,S): ha_lezione(D,religione,C,S,I,F,G,A)}1 :- classe(C,S).

% per ogni slot c'è al massimo una lezione con una classe, ogni lezione si tiene in un aula precisa
0{ha_lezione(D,L,C,S,I,F,G,A): classe(C,S),si_tiene_in(L,A),insegna(D,L)}1 :- slot(I,F,G,A).

% SERVE? se serve ricordarsi di modificare la relazione
% all'interno di una stessa aula non si possono tenere più lezioni nello stesso momento
%:- ha_lezione(_,_,C1,S1,I,F,G,A),
%   ha_lezione(_,_,C2,S2,I,F,G,A),
%   C1!=C2;S1!=S2.

% un insegnante non può avere lezione in due posti diversi nello stesso momento
:- ha_lezione(D,_,_,_,I,F,G,A1),
   ha_lezione(D,_,_,_,I,F,G,A2),
   A1!=A2.

% le classi a tempo prolungato vanno a mensa quindi non hanno lezione
:- ha_lezione(_,_,C,S,I,F,_,_),
   tempo_prolungato(C,S),
   mensa(I,F).

% i professori che insegnano una materia ad una classe non cambiano
:- ha_lezione(D1,L,C,S,_,_,_,_),
   ha_lezione(D2,L,C,S,_,_,_,_),
   D1!=D2.

% una classe non può avere lezione in due posti diversi nello stesso momento
:- ha_lezione(_,_,C,S,I,F,G,A1),
   ha_lezione(_,_,C,S,I,F,G,A2),
   A1!=A2.

% gli alunni con un regime a frequenza normale finiscono un'ora prima
:- ha_lezione(_,_,C,S,14,15,_,_),
   tempo_normale(C,S).
   %ora(14,15).