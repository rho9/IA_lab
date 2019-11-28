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
10{orario(D,lettere,A,I,F,G,C,S): insegna(D,lettere), si_tiene_in(lettere,A),ora(I,F),giorno(G)}10 :- classe(C,S).
 
% 4 ore a settimana (matematica)
4{orario(D,matematica,A,I,F,G,C,S): insegna(D,matematica), si_tiene_in(matematica,A),ora(I,F),giorno(G)}4 :- classe(C,S).

% 3 ore a settimana (inglese)
3{orario(D,inglese,A,I,F,G,C,S): insegna(D,inglese), si_tiene_in(inglese,A),ora(I,F),giorno(G)}3 :- classe(C,S).

% 2 ore a settimana (scienze)
2{orario(D,scienze,A,I,F,G,C,S): insegna(D,scienze), si_tiene_in(scienze,A),ora(I,F),giorno(G)}2 :- classe(C,S).

% 2 ore a settimana (spagnolo)
2{orario(D,spagnolo,A,I,F,G,C,S): insegna(D,spagnolo), si_tiene_in(spagnolo,A),ora(I,F),giorno(G)}2 :- classe(C,S).

% 2 ore a settimana (musica)
2{orario(D,musica,A,I,F,G,C,S): insegna(D,musica), si_tiene_in(musica,A),ora(I,F),giorno(G)}2 :- classe(C,S).

% 2 ore a settimana (tecnologia)
2{orario(D,tecnologia,A,I,F,G,C,S): insegna(D,tecnologia), si_tiene_in(tecnologia,A),ora(I,F),giorno(G)}2 :- classe(C,S).

% 2 ore a settimana (arte)
2{orario(D,arte,A,I,F,G,C,S): insegna(D,arte), si_tiene_in(arte,A),ora(I,F),giorno(G)}2 :- classe(C,S).

% 2 ore a settimana (educazione fisica)
2{orario(D,educazione_fisica,A,I,F,G,C,S): insegna(D,educazione_fisica), si_tiene_in(educazione_fisica,A),ora(I,F),giorno(G)}2 :- classe(C,S).

% 1 ora a settimana (religione)
1{orario(D,religione,A,I,F,G,C,S): insegna(D,religione), si_tiene_in(religione,A),ora(I,F),giorno(G)}1 :- classe(C,S).

% per ogni slot c'è al massimo una lezione con una classe, ogni lezione si tiene in un'aula precisa
0{orario(D,L,A,I,F,G,C,S): classe(C,S),si_tiene_in(L,A),insegna(D,L)}1 :- slot(I,F,G,A).

% un insegnante non può avere lezione in due posti diversi nello stesso momento
:- orario(D,_,A1,I,F,G,_,_),
   orario(D,_,A2,I,F,G,_,_),
   A1!=A2.

% le classi a tempo prolungato vanno a mensa quindi non hanno lezione
:- orario(_,_,_,I,F,_,C,S),
   tempo_prolungato(C,S),
   mensa(I,F).

% i professori che insegnano una materia ad una classe non cambiano
:- orario(D1,L,_,_,_,_,C,S),
   orario(D2,L,_,_,_,_,C,S),
   D1!=D2.

% una classe non può avere lezione in due posti diversi nello stesso momento
:- orario(_,_,A1,I,F,G,C,S),
   orario(_,_,A2,I,F,G,C,S),
   A1!=A2.

% gli alunni con un regime a frequenza normale finiscono un'ora prima
:- orario(_,_,_,14,15,_,C,S),
   tempo_normale(C,S).