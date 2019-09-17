package torta_project.test;

import aima.core.torta_project.MPE;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.domain.FiniteDomain;
import aima.core.probability.proposition.AssignmentProposition;
import bnparser.BifReader;

import java.io.File;
import java.util.*;

public class TestBatch {


    // sceglie casualmente num(quante) variabili e vi assegna un valore casuale all'interno del dominio
    // ritorna le evidenze assegnate
    public static List<AssignmentProposition> randomEvidence(List<RandomVariable> rvs, int num){
        List<AssignmentProposition> apList = new ArrayList<>();
        Random rand = new Random();
        for (int i = 0; i < num; i++) {
            int randomIndex = rand.nextInt(rvs.size());
            RandomVariable randomElement = rvs.get(randomIndex);
            Set domain = ((FiniteDomain) rvs.get(randomIndex).getDomain()).getPossibleValues();
            int ranDomI = rand.nextInt(domain.size());
            Object ranDom = domain.toArray()[ranDomI];
            apList.add(new AssignmentProposition(randomElement,ranDom));
            rvs.remove(randomIndex);
        }
        return apList;
    }

    // sceglie randomicamente le variabili MAP
    public static List<RandomVariable> randomMAP(List<RandomVariable> rvs, int num){
        List<RandomVariable> rvList = new ArrayList<>();
        Random rand = new Random();
        for (int i = 0; i < num; i++) {
            int randomIndex = rand.nextInt(rvs.size());
            RandomVariable randomElement = rvs.get(randomIndex);
            rvList.add(randomElement);
            rvs.remove(randomIndex);
        }
        return rvList;
    }


    public static void main(String[] args) {

        String FOLDER = "../retiSamiam/Reti/Small_20/xml/"; //nome folder con reti
        File folder = new File(FOLDER);
        File[] listOfFiles = folder.listFiles();
        List<String> filesName = new ArrayList<>();
        for (int i = 0; i < listOfFiles.length; i++) {
            if (listOfFiles[i].isFile()) {
                filesName.add(listOfFiles[i].getName());
            }
        }

        for(String fileName:filesName){
            BayesianNetwork bn = BifReader.readBIF(FOLDER + fileName);
            List<RandomVariable> rvs = bn.getVariablesInTopologicalOrder();
            MPE mpe = new MPE();
            int[] assignmentNum = {2}; //decido il numero di assegnamenti (evidenze) effettuare
            int[] mapNum = {(int)Math.round(rvs.size())}; //quante variabili MAP tirare a caso
            for(int an : assignmentNum){
                for(int mn : mapNum){
                    List<RandomVariable> rvs2 = new ArrayList<>();
                    for(RandomVariable r:rvs)
                        rvs2.add(r); //copia di rvs

                    List<AssignmentProposition> ap = randomEvidence(rvs2,an);
                    int mapNumReal = Math.min(mn,rvs2.size()); //numero di variabili map che vogliamo assegnare
                    List<RandomVariable> qrv = randomMAP(rvs2, mapNumReal); //query random variable

                    //System.out.println("+++");
                    //System.out.println(fileName);
                    //System.out.println("Assignment: " + ap.size());
                    //System.out.println("Query: " + qrv.size());

                    long startTime = System.nanoTime();
                    try {
                        Map<RandomVariable, Object> assignment = mpe.start(qrv, ap.toArray(new AssignmentProposition[ap.size()]), bn);
                        long endTime = System.nanoTime();
                        long timeElapsed = endTime - startTime;

                        //System.out.println("Execution time in milliseconds : " + timeElapsed / 1000000);
                        //System.out.println("Biggest factor "+ mpe.getSize_max_factor());
                        //System.out.println(assignment);
                        //System.out.println("MAP Value: " + mpe.getMap_value());

                        //stampa grandezza rete, grandezza del fattore più grande (la tabella delle prob), tempo che ha impiegato ms, quante variabili ha assegnato, e quali sono MAP
                        System.out.println("filename: " + fileName + "\trvs_size: " + rvs.size() + "\tmax_mpe_factor: " + mpe.getSize_max_factor() + "\ttime_elapsed: " + timeElapsed + "\tap_size: " + ap.size() + "\tmap_RV_size: " + qrv.size());
                    }catch (Exception e){
                        System.out.println(fileName + " Error heap space - " + rvs.size() + " nodi");
                    }
                }
            }
        }
    }
}