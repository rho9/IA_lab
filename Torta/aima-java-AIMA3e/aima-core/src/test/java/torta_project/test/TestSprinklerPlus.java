package torta_project.test;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.torta_project.MPE;
import bnparser.BifReader;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class TestSprinklerPlus {

    public static void main(String[] args) {
        BayesianNetwork bn = BifReader.readBIF("../R/SprinklerPlus.xml");
        List<RandomVariable> rvs = bn.getVariablesInTopologicalOrder();

        RandomVariable Cloudy = null;
        RandomVariable Season = null;
        RandomVariable Rain = null;
        RandomVariable Sprinkler = null;
        RandomVariable Grass_wet = null;
        RandomVariable Road_wet = null;

        System.out.println("DOMINIO");
        for (RandomVariable rv :rvs) {
            if (rv.getName().equals("Cloudy"))
                Cloudy = rv;
            else if (rv.getName().equals("Season"))
                Season = rv;
            else if (rv.getName().equals("Rain"))
                Rain = rv;
            else if (rv.getName().equals("Sprinkler"))
                Sprinkler = rv;
            else if (rv.getName().equals("Grass"))
                Grass_wet = rv;
            else if (rv.getName().equals("Road"))
                Road_wet = rv;
            System.out.println(rv.getName() + "\t" + rv.getDomain());
        }

        //variabili da assegnare (q -> query)
        RandomVariable[] qrv = new RandomVariable[1];
        qrv[0] = Sprinkler;

        //evidenze (variabili che assegnamo a priori)
        AssignmentProposition[] ap = new AssignmentProposition[4];
        ap[0] = new AssignmentProposition(Season, "Fall");
        ap[1] = new AssignmentProposition(Cloudy, "Yes");
        ap[2] = new AssignmentProposition(Road_wet, "No");
        ap[3] = new AssignmentProposition(Grass_wet, "Yes");

        System.out.println("\nRISULTATO");
        MPE mpe = new MPE();
        long startTime = System.currentTimeMillis();
        Map<RandomVariable, Object> assignment = mpe.start(Arrays.asList(qrv), ap, bn);
        long stoptime = System.currentTimeMillis();
        System.out.println(assignment);
        long elapsed_time=stoptime-startTime;
        System.out.println("Tempo trascorso: " + elapsed_time + "ms");
    }
}



