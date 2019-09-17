package torta_project.test;

import aima.core.torta_project.MPE;
import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.proposition.AssignmentProposition;
import bnparser.BifReader;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class TestEarthquake {

    public static void main(String[] args) {
        BayesianNetwork bn = BifReader.readBIF("../R/earthquake.xml");
        List<RandomVariable> rvs = bn.getVariablesInTopologicalOrder();

        RandomVariable B = null;
        RandomVariable J = null;
        RandomVariable M = null;
        RandomVariable E = null;
        RandomVariable A = null;

        System.out.println("DOMINIO");
        for (RandomVariable rv :rvs) {
            if (rv.getName().equals("Burglary"))
                B = rv;
            else if (rv.getName().equals("JohnCalls"))
                J = rv;
            else if (rv.getName().equals("MaryCalls"))
                M = rv;
            else if (rv.getName().equals("Earthquake"))
                E = rv;
            else if (rv.getName().equals("Alarm"))
                A = rv;
            System.out.println(rv.getName() + "\t" + rv.getDomain());
        }

        //variabili da assegnare (q -> query)
        RandomVariable[] qrv = new RandomVariable[2];
        qrv[0] = B;
        qrv[1] = E;

        //evidenze (variabili che assegnamo a priori)
        AssignmentProposition[] ap = new AssignmentProposition[2];
        ap[0] = new AssignmentProposition(M, "False");
        ap[1] = new AssignmentProposition(J, "False");

        System.out.println("\nRISULTATO");
        MPE mpe = new MPE();
        Map<RandomVariable, Object> assignment = mpe.start(Arrays.asList(qrv), ap, bn);
        System.out.println(assignment);
    }
}



