package aima.core.torta_project;

import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.bayes.impl.CPT;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;

import java.util.*;

public class MPE {


    private static final ProbabilityTable _identity = new ProbabilityTable(
            new double[] { 1.0 });

    private double map_value = 0;

    private int size_max_factor = 0;


    public double getMap_value() {
        return map_value;
    }

//
    // PROTECTED METHODS
    //
    /**
     * <b>Note:</b>Override this method for a more efficient implementation as
     * outlined in AIMA3e pgs. 527-28. Calculate the hidden variables from the
     * Bayesian Network. The default implementation does not perform any of
     * these.<br>
     * <br>
     * Two calcuations to be performed here in order to optimize iteration over
     * the Bayesian Network:<br>
     * 1. Calculate the hidden variables to be enumerated over. An optimization
     * (AIMA3e pg. 528) is to remove 'every variable that is not an ancestor of
     * a query variable or evidence variable as it is irrelevant to the query'
     * (i.e. sums to 1). 2. The subset of variables from the Bayesian Network to
     * be retained after irrelevant hidden variables have been removed.
     *
     * @param X
     *            the query variables.
     * @param e
     *            observed values for variables E.
     * @param bn
     *            a Bayes net with variables {X} &cup; E &cup; Y /* Y = hidden
     *            variables //
     * @param hidden
     *            to be populated with the relevant hidden variables Y.

     */
    protected void calculateVariables(final List<RandomVariable> X,
                                      final AssignmentProposition[] e, final BayesianNetwork bn,
                                      Set<RandomVariable> hidden ) {

        hidden.addAll(bn.getVariablesInTopologicalOrder());

        for (RandomVariable x : X) {
            hidden.remove(x);
        }
        for (AssignmentProposition ap : e) {
            hidden.removeAll(ap.getScope());
        }

        return;
    }

    /**
     * <b>Note:</b>Override this method for a more efficient implementation as
     * outlined in AIMA3e pgs. 527-28. The default implementation does not
     * perform any of these.<br>
     *
     * @param bn
     *            the Bayesian Network over which the query is being made. Note,
     *            is necessary to provide this in order to be able to determine
     *            the dependencies between variables.
     * @param vars
     *            a subset of the RandomVariables making up the Bayesian
     *            Network, with any irrelevant hidden variables alreay removed.
     * @return a possibly opimal ordering for the random variables to be
     *         iterated over by the algorithm. For example, one fairly effective
     *         ordering is a greedy one: eliminate whichever variable minimizes
     *         the size of the next factor to be constructed.
     */
    protected List<RandomVariable> order(BayesianNetwork bn,
                                         Collection<RandomVariable> vars) {
        // Note: Trivial Approach:
        // For simplicity just return in the reverse order received,
        // i.e. received will be the default topological order for
        // the Bayesian Network and we want to ensure the network
        // is iterated from bottom up to ensure when hidden variables
        // are come across all the factors dependent on them have
        // been seen so far.
        List<RandomVariable> order = new ArrayList<RandomVariable>(vars);
        Collections.reverse(order);

        return order;
    }

    //
    // PRIVATE METHODS
    //
    private Factor makeFactor(RandomVariable var, AssignmentProposition[] e,
                              BayesianNetwork bn) {

        Node n = bn.getNode(var);
        if (!(n instanceof FiniteNode)) {
            throw new IllegalArgumentException(
                    "Elimination-Ask only works with finite Nodes.");
        }
        FiniteNode fn = (FiniteNode) n;
        List<AssignmentProposition> evidence = new ArrayList<AssignmentProposition>(); //Proposition: Possible world is defined to be an assignment of values to all of the random variables under consideration
        for (AssignmentProposition ap : e) {
            if (fn.getCPT().contains(ap.getTermVariable())) {
                evidence.add(ap);
            }
        }
        // getFactorFor: Construct a Factor consisting of the Random Variables from the
	    //Conditional Probability Table that are not part of the evidence
        return fn.getCPT().getFactorFor(
                evidence.toArray(new AssignmentProposition[evidence.size()]));
    }

    // va a richiamare maxOut in ProbabilityTable.java
    private Factor maxOut(RandomVariable var, Factor factor,
                                BayesianNetwork bn) {

        return ((ProbabilityTable)factor).maxOut(var);
    }

    // preso da EliminationAsk.java
    private List<Factor> sumOut(RandomVariable var, List<Factor> factors,
                                BayesianNetwork bn) {
        List<Factor> summedOutFactors = new ArrayList<Factor>();
        List<Factor> toMultiply = new ArrayList<Factor>();
        for (Factor f : factors) {
            if (f.contains(var)) {
                toMultiply.add(f);
            } else {
                // This factor does not contain the variable
                // so no need to sum out - see AIMA3e pg. 527.
                summedOutFactors.add(f);
            }
        }

        summedOutFactors.add(pointwiseProduct(toMultiply).sumOut(var));

        return summedOutFactors;
    }

    private Factor pointwiseProduct(List<Factor> factors) {

        Factor product = factors.get(0);
        for (int i = 1; i < factors.size(); i++) {
            product = product.pointwiseProduct(factors.get(i));
        }

        return product;
    }
    // aggiorna size_max_factor con la dimensione del factor e poi lo ritorna
    private Factor count(Factor f){
        int size = ((ProbabilityTable)f).size();
        if(size > size_max_factor)
            size_max_factor = size;
        return f;
    }
    // aggiorna size_max_factor con la dimensione del factor più grande
    private Collection<Factor> count(Collection<Factor> cf){
        for(Factor f:cf) {
            int size = ((ProbabilityTable) f).size();

            if (size > size_max_factor)
                size_max_factor = size;
        }
        return cf;
    }


    public Factor pointwiseStart(List<Factor> factors){
        if(factors.size() > 0){
            Factor zero = factors.get(0);
            factors.remove(zero);
            return pointwiseRecur(factors,zero);

        }else
            return null;
    }


    public Factor pointwiseRecur(List<Factor> factors, Factor mult){
        if(factors.size() == 0)
            return mult;
        else {
            Factor zero = factors.get(0);
            factors.remove(zero);
            return pointwiseRecur(factors,mult.pointwiseProduct(zero));

        }

    }
    // salvo la lista di fattori che hanno random variable
    private List<Factor> factorsFromRV(RandomVariable rv){

        List<Factor> list = new ArrayList<>();
        for(Factor f: cpt){
            if(f.contains(rv))
                list.add(f);
        }
        return list;
    }

    /**
     * Start fa partire l'algoritmo
     * Prima facciamo un giro dove aggiungiamo le cpt in un array cpt
     * Se incontriamo hidden variable contenenti random variable facciamo la sum out
     *
     * Secondo ciclo per ogni variabile map facciamo la maxout
     *
     * Terzo ciclo moltiplichiamo le probabilità rimaste
     *
     * @param X
     *            variabili da assegnare
     * @param eap
     *            evidence assignment proposition
     * @param bn
     *            a Bayes net with variables
     *
     * */

    public Map<RandomVariable, Object> start(List<RandomVariable> X,
                      final AssignmentProposition[] eap,
                      final BayesianNetwork bn){
        cpt = new ArrayList<>();


        Set<RandomVariable> hidden = new HashSet<RandomVariable>();
        calculateVariables(X, eap, bn, hidden);

        List<RandomVariable> rvs = order(bn,bn.getVariablesInTopologicalOrder());



        for(RandomVariable rv:rvs){

                List<AssignmentProposition> evidence = new ArrayList<AssignmentProposition>();
                for (AssignmentProposition ap : eap) {
                    if (((CPT) ((BayesNet) bn).getNode(rv).getCPD()).contains(ap.getTermVariable())) {
                        evidence.add(ap);
                    }
                }

                cpt.add( count( ((CPT) ((BayesNet) bn).getNode(rv).getCPD()).getFactorFor(evidence.toArray(new AssignmentProposition[evidence.size()]))
                )); // aggiunge alla cpt il fattore ottenuto attraverso il confronto con le evidenze

            if(hidden.contains(rv)){
                // sum out!!

                List<Factor> factors = factorsFromRV(rv);
                cpt.removeAll(factors);
                Factor f = pointwiseStart(factors);

                List<Factor> list = new ArrayList<Factor>();
                list.add(f);

                cpt.addAll(count(sumOut(rv,list,bn)));


            }
        }



        for(RandomVariable rv:rvs){
            if(X.contains(rv)){
                List<Factor> factors = factorsFromRV(rv);
                cpt.removeAll(factors);
                Factor f = pointwiseStart(factors);
                if (((ProbabilityTable)f).getVarNum()==1)
                    cpt.add(count(f));
                else
                    cpt.add(count(maxOut(rv,f,bn)));

            }
        }

        List<Double> valuesToMult = new ArrayList<>();
        while(cpt.size() > 1){
            Factor c1 = cptPop();
            if(((ProbabilityTable)c1).size()==1){
                valuesToMult.add(c1.getValues()[0]);
            }else {
                Factor c2 = cptPopSame(c1);
                if (c2 != null) {
                    Factor union = ((ProbabilityTable) c1).unite(c2);
                    cpt.add(count((union)));
                } else {
                    c2 = cptPopSamePath(c1);
                    if (c2 != null) {

                        cpt.add(count(maxOut(((ProbabilityTable) c1).getOneVar(rvs), c2.pointwiseProduct(c1), bn)));


                    } else {
                        cpt.add(cpt.size(), count(c1));
                    }
                }
            }
        }

        ProbabilityTable last = (ProbabilityTable)cptPop();
        Map<RandomVariable, Object> max_assignment = last.maxPaths();
        map_value = last.getMaxProbabily();
        map_value = multiplyForEvidence(map_value,valuesToMult);

        return max_assignment;

    }

    private double multiplyForEvidence(double map_value, List<Double> valuesToMult ){

        for(double v:valuesToMult){
            map_value *= v;

        }

        return map_value;

    }


    public int getSize_max_factor() {
        return size_max_factor;
    }

    List<Factor> cpt;

    private Factor cptPop(){
        Factor c = cpt.get(0);
        cpt.remove(c);
        return c;
    }

    private Factor cptPopSame(Factor r){

        Factor same = null;
        for (Factor c:cpt){
            if(((ProbabilityTable)c).isInPath(r))
                same = c;
            break;
        }
        if (same == null)
            for (Factor c:cpt){
                if(((ProbabilityTable)c).isSameVariable(r))
                    same = c;
                break;
            }

        cpt.remove(same);
        return same;
    }

// ritorna fattore con un elemento nel path uguale al mio path
    private Factor cptPopSamePath(Factor r){

        Factor same = null;
        for (Factor c:cpt){
            if(((ProbabilityTable)c).myPathIsInPath(r))
                same = c;
            break;
        }

        cpt.remove(same);
        return same;
    }
}