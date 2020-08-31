package torta_project.test;

import aima.core.torta_project.MPE;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.proposition.AssignmentProposition;
import bnparser.BifReader;

import java.util.*;

public class TestMPE_MAP {


    private static List<RandomVariable> evidence = new ArrayList<>();

    public static void printrv(List<RandomVariable> rvs) {

        for (RandomVariable r : rvs) {
            System.out.println(rvs.indexOf(r) + "\t" + r.getName());
        }
    }


    public static AssignmentProposition[] assegnaEvidenze(Scanner tastiera, List<RandomVariable> rvs) {
        AssignmentProposition[] ap;

        System.out.println("Quanti assegnamenti vuoi fare?");
        int numAss = tastiera.nextInt();
        ap = new AssignmentProposition[numAss];
        for (int i = 0; i < ap.length; i++) {

            System.out.println("Dimmi il numero della variabile");
            int numVar = tastiera.nextInt();
            System.out.println("Hai scelto la variabile " + rvs.get(numVar).getName() + ", il suo dominio è " + rvs.get(numVar).getDomain());
            System.out.println("Inserisci un valore del dominio: ");
            String valDom = tastiera.next();
            evidence.add(rvs.get(numVar));
            ap[i] = new AssignmentProposition(rvs.get(numVar), valDom);
        }

        return ap;

    }

    // qrv sono quelle che decido io
    public static RandomVariable[] assegnaVarMAP(Scanner tastiera, List<RandomVariable> rvs) {
        RandomVariable[] qrv;

        System.out.println("Quante variabili MAP vuoi?");
        int numAss = tastiera.nextInt();
        qrv = new RandomVariable[numAss];
        for (int i = 0; i < qrv.length; i++) {

            System.out.println("Dimmi il numero della variabile");
            int numVar = tastiera.nextInt();
            qrv[i] = rvs.get(numVar);
        }

        return qrv;

    }
    //qrv sono tutte quelle non assegnate
    public static RandomVariable[] assegnaVarMPE(List<RandomVariable> rvs) {

        ArrayList<RandomVariable> qArrayList = new ArrayList<>();

        for (RandomVariable rv : rvs)
            if (!evidence.contains(rv))
                qArrayList.add(rv);
        RandomVariable[] qrv = qArrayList.toArray(new RandomVariable[qArrayList.size()]);

        return qrv;

    }


    public static void main(String[] args) {

        BayesianNetwork bn = BifReader.readBIF("../retiSamiam/Reti/Medium_20-50/xml/insurance.xbif");
        List<RandomVariable> rvs = bn.getVariablesInTopologicalOrder();

        printrv(rvs); //stampo le random vars della rete
        MPE mpe = new MPE();
        Scanner tastiera = new Scanner(System.in);
        System.out.println("Scegli tra MPE e MAP");
        String risposta = tastiera.nextLine();
        boolean mpeB = risposta.equalsIgnoreCase("mpe");
        AssignmentProposition[] ap = assegnaEvidenze(tastiera, rvs);
        RandomVariable[] qrv = mpeB ? assegnaVarMPE(rvs) : assegnaVarMAP(tastiera, rvs);

        long startTime = System.nanoTime();
        try {
            Map<RandomVariable, Object> assignment = mpe.start(new ArrayList<>(Arrays.asList(qrv)), ap, bn);
            long endTime = System.nanoTime();

            long timeElapsed = endTime - startTime;

            System.out.println("Execution time in milliseconds : " +
                    timeElapsed / 1000000);

            //dimensione del fattore + grande
            System.out.println("Biggest factor " + mpe.getSize_max_factor());
            System.out.println(assignment);
            System.out.println("MAP Value: " + mpe.getMap_value());
            //System.out.println(fileName + ";" + rvs.size() + ";" + mpe.getSize_max_factor() + ";" + timeElapsed + ";" + ap.size() + ";" + qrv.size());
        } catch (Exception e) {
            System.out.println(" Error heap space - " + rvs.size() + " nodi");
        }
    }
}
