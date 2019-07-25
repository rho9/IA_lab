%%%%%%%%%%%%%%%%%%%%%%%%
% TO-DO
%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%
% KNOWLEDGE BASE
%%%%%%%%%%%%%%%%%%%%%%%%

% Classi
classe(1..3,a).
classe(1..3,b).

% Aule
aula(a_lettere1).
aula(a_lettere2).
aula(a_matematica).
aula(a_tecnologia).
aula(a_musica).
aula(a_inglese).
aula(a_spagnolo).
aula(a_religione).

% Laboratori
laboratorio(l_arte).
laboratorio(l_scienze).
laboratorio(l_educazione_fisica).

% Tipologia lezioni
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

% Docenti
docente(d_lettere1;
        d_lettere2
        ).
docente(d_matematica_scienze1;
        d_matematica_scienze2;
        d_matematica_scienze3;
        d_matematica_scienze4
        ).
docente(d_tecnologia).
docente(d_musica).
docente(d_inglese).
docente(d_spagnolo).
docente(d_religione).
docente(d_arte).
docente(d_educazione_fisica).

% Tipologia di orario
% tempo_prolungato(1..3,a).
% tempo_normale(1..3,b).

% Giorni della settimana
giorno(lun;mar;mer;gio;ven).

% Orario lezioni
ora(8,9;9,10;10,11;11,12;12,13;13,14;14,15).

% Lezioni tenute da professori
insegna(d_lettere1,lettere).
insegna(d_lettere2,lettere).
insegna(d_matematica_scienze1,matematica).
insegna(d_matematica_scienze2,matematica).
insegna(d_matematica_scienze3,matematica).
insegna(d_matematica_scienze4,matematica).
insegna(d_tecnologia,tecnologia). 
insegna(d_musica,musica). 
insegna(d_inglese,inglese). 
insegna(d_spagnolo,spagnolo). 
insegna(d_religione,religione). 
insegna(d_arte,arte). 
insegna(d_matematica_scienze1,scienze). 
insegna(d_matematica_scienze2,scienze).
insegna(d_matematica_scienze3,scienze).
insegna(d_matematica_scienze4,scienze).
insegna(d_educazione_fisica ,educazione_fisica).

% Luoghi in cui vengono tenute le lezioni
si_tiene_in(lettere,a_lettere1).
si_tiene_in(lettere,a_lettere2).
si_tiene_in(matematica, a_matematica).
si_tiene_in(tecnologia,a_tecnologia).
si_tiene_in(musica,a_musica).
si_tiene_in(inglese,a_inglese).
si_tiene_in(spagnolo,a_spagnolo).
si_tiene_in(religione,a_religione).
si_tiene_in(arte,l_arte).
si_tiene_in(scienze,l_scienze).
si_tiene_in(educazione_fisica,l_educazione_fisica).

% Numero di ore a settimana
ore_a_settimana(lettere,10).
ore_a_settimana(matematica,4).
ore_a_settimana(scienze,2;
                spagnolo,2;
                musica,2;
                tecnologia,2;
                arte,2;
                educazione_fisica,2
).
ore_a_settimana(inglese,3).
ore_a_settimana(religione,1).

%%%%%%%%%%%%%%%%%%%%%%%%
% VINCOLI
%%%%%%%%%%%%%%%%%%%%%%%%

% 10 ore a settimana (lettere)
10{orario(D,lettere,A,I,F,G,C,S):
        ha_lezione(D,lettere,C,S,I,F,G,A)
}10 :- classe(C,S).
 
 % 4 ore a settimana (matematica)
4{orario(D,matematica,A,I,F,G,C,S):
        ha_lezione(D,matematica,C,S,I,F,G,A)
}4 :- classe(C,S).

% 3 ore a settimana (inglese)
3{orario(D,inglese,A,I,F,G,C,S):
        ha_lezione(D,inglese,C,S,I,F,G,A)
}3 :- classe(C,S).

% 2 ore a settimana (scienze)
2{orario(D,scienze,A,I,F,G,C,S):
        ha_lezione(D,scienze,C,S,I,F,G,A)
}2 :- classe(C,S).

% 2 ore a settimana (spagnolo)
2{orario(D,spagnolo,A,I,F,G,C,S):
        ha_lezione(D,spagnolo,C,S,I,F,G,A)
}2 :- classe(C,S).

% 2 ore a settimana (musica)
2{orario(D,musica,A,I,F,G,C,S):
        ha_lezione(D,musica,C,S,I,F,G,A)
}2 :- classe(C,S).

% 2 ore a settimana (tecnologia)
2{orario(D,tecnologia,A,I,F,G,C,S):
        ha_lezione(D,tecnologia,C,S,I,F,G,A)
}2 :- classe(C,S).

% 2 ore a settimana (arte)
2{orario(D,arte,A,I,F,G,C,S):
        ha_lezione(D,arte,C,S,I,F,G,A)
}2 :- classe(C,S).

% 2 ore a settimana (educazione fisica)
2{orario(D,educazione_fisica,A,I,F,G,C,S):
        ha_lezione(D,educazione_fisica,C,S,I,F,G,A)
}2 :- classe(C,S).

% 1 ora a settimana (religione)
1{orario(D,religione,A,I,F,G,C,S):
        ha_lezione(D,religione,C,S,I,F,G,A)
}1 :- classe(C,S).

% per ogni slot c'è al massimo una lezione con una classe, ogni lezione si tipo di lezione si tiene in un aula precisa
0{ha_lezione(D,L,C,S,I,F,G,A):classe(C,S),si_tiene_in(L,A),insegna(D,L)}1 :- slot(I,F,G,A).

% ci sono 35 slot per ogni aula. Ogni slot è identificato da giorno ora e aula
35{slot(I,F,G,A):ora(I,F),giorno(G)}35 :- aula(A).
35{slot(I,F,G,L):ora(I,F),giorno(G)}35 :- laboratorio(L).

% non ci possono essere sovrapposizioni
:- ha_lezione(_,_,C1,_,I,F,G,A),ha_lezione(_,_,C2,_,I,F,G,A),C1!=C2.
:- ha_lezione(_,_,_,S1,I,F,G,A),ha_lezione(_,_,_,S2,I,F,G,A),S1!=S2.
:- ha_lezione(_,_,C1,S1,I,F,G,A),ha_lezione(_,_,C2,S2,I,F,G,A),C1!=C2,S1!=S2.

% un insegnante non può avere lezione in due posti diversi
:- ha_lezione(D,_,_,_,I,F,G,A1), ha_lezione(D,_,_,_,I,F,G,A2),A1!=A2.

