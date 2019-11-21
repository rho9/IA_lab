import com.xeiam.xchart.*;
import com.xeiam.xchart.StyleManager.ChartType;
import com.xeiam.xchart.StyleManager.LegendPosition;

import libreria.distribution.MultivariateNormalDistribution;
//import libreria.filter.*;
import libreria.filter.DefaultMeasurementModel;
import libreria.filter.DefaultProcessModel;
import libreria.filter.KalmanFilter;
import libreria.filter.MeasurementModel;
import libreria.filter.ProcessModel;
import libreria.linear.MatrixUtils;
import libreria.linear.RealMatrix;
import libreria.linear.RealVector;
import libreria.random.RandomGenerator;
import libreria.random.Well19937c;
import libreria.userguide.ExampleUtils;
import libreria.userguide.ExampleUtils.ExampleFrame;
import libreria.util.FastMath;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class CannonBallTest {

    public static class Cannonball {

        private final double[] gravity = { 0, -9.81 };
        private final double[] velocity;
        private final double[] location;

        private final double timeslice;
        private final double measurementNoise;

        private final RandomGenerator rng;

        private final double[][] R;
        private final MultivariateNormalDistribution mnd;

        public Cannonball(RealMatrix R, double timeslice, double angle, double initialVelocity, double measurementNoise, int seed) {
            this.timeslice = timeslice;

            final double angleInRadians = FastMath.toRadians(angle);
            this.velocity = new double[] {
                    initialVelocity * FastMath.cos(angleInRadians),
                    initialVelocity * FastMath.sin(angleInRadians)
            };

            this.location = new double[] { 0, 0 };

            this.measurementNoise = measurementNoise;
            this.rng = new Well19937c(seed);

            this.R = R.getData();
            double[] means = {0.0,0.0,0.0,0.0};

            this.mnd = new MultivariateNormalDistribution(rng, means, this.R);
        }

        public double getX() {
            return location[0];
        }

        public double getY() {
            return location[1];
        }

        //public double getMeasuredX() {return location[0] + rng.nextGaussian() * measurementNoise;       }

        //public double getMeasuredY() {return location[1] + rng.nextGaussian() * measurementNoise;     }

        public double getMeasuredX() {
            return location[0] + this.mnd.sample()[0] * measurementNoise;
        }

        public double getMeasuredY() {
            return location[1] + this.mnd.sample()[2] * measurementNoise;
        }

        public double getXVelocity() {
            return velocity[0];
        }

        public double getYVelocity() {
            return velocity[1];
        }

        public void step() {
            // Break gravitational force into a smaller time slice.
            double[] slicedGravity = gravity.clone();
            for ( int i = 0; i < slicedGravity.length; i++ ) {
                slicedGravity[i] *= timeslice;
            }

            // Apply the acceleration to velocity.
            double[] slicedVelocity = velocity.clone();
            for ( int i = 0; i < velocity.length; i++ ) {
                velocity[i] += slicedGravity[i];
                slicedVelocity[i] = velocity[i] * timeslice;
                location[i] += slicedVelocity[i];
            }

            // Cannonballs shouldn't go into the ground.
            if ( location[1] < 0 ) {
                location[1] = 0;
            }
        }
    }

    public static void cannonballTest(Chart chart, Chart chart2, Chart chart3) {

        // time interval for each iteration
        final double dt = 0.1;
        // the number of iterations to run
        final int iterations = 144;
        // measurement noise (m)
        final double measurementNoise = 10;
        // initial velocity of the cannonball
        final double initialVelocity = 100;
        // shooting angle
        final double angle = 45;

        // A = [ 1, dt, 0,  0 ]  =>  x(n+1) = x(n) + vx(n)
        //     [ 0,  1, 0,  0 ]  => vx(n+1) =        vx(n)
        //     [ 0,  0, 1, dt ]  =>  y(n+1) =              y(n) + vy(n)
        //     [ 0,  0, 0,  1 ]  => vy(n+1) =                     vy(n)
        final RealMatrix A = MatrixUtils.createRealMatrix(new double[][] {
                { 1, dt, 0,  0 },
                { 0,  1, 0,  0 },
                { 0,  0, 1, dt },
                { 0,  0, 0,  1 }
        });

        // The control vector, which adds acceleration to the kinematic equations.
        // 0          =>  x(n+1) =  x(n+1)
        // 0          => vx(n+1) = vx(n+1)
        // -9.81*dt^2 =>  y(n+1) =  y(n+1) - 1/2 * 9.81 * dt^2
        // -9.81*dt   => vy(n+1) = vy(n+1) - 9.81 * dt
        final RealVector controlVector =
                MatrixUtils.createRealVector(new double[] { 0, 0, 0.5 * -9.81 * dt * dt, -9.81 * dt } );

        // The control matrix B only update y and vy, see control vector
        final RealMatrix B = MatrixUtils.createRealMatrix(new double[][] {
                { 0, 0, 0, 0 },
                { 0, 0, 0, 0 },
                { 0, 0, 1, 0 },
                { 0, 0, 0, 1 }
        });

        // After state transition and control, here are the equations:
        //
        //  x(n+1) = x(n) + vx(n)
        // vx(n+1) = vx(n)
        //  y(n+1) = y(n) + vy(n) - 0.5 * 9.81 * dt^2
        // vy(n+1) = vy(n) + -9.81 * dt
        //
        // Which, if you recall, are the equations of motion for a parabola.

        // We only observe the x/y position of the cannonball
        final RealMatrix H = MatrixUtils.createRealMatrix(new double[][] {
                { 1, 0, 0, 0 },
                { 0, 0, 0, 0 },
                { 0, 0, 1, 0 },
                { 0, 0, 0, 0 }
        });

        // The initial error covariance matrix, the variance = noise^2
        final double var = measurementNoise * measurementNoise;
        final RealMatrix initialErrorCovariance = MatrixUtils.createRealMatrix(new double[][] {
                { var,    0,   0,    0 },
                {   0, 1e-3,   0,    0 },
                {   0,    0, var,    0 },
                {   0,    0,   0, 1e-3 }
        });

        // we assume no process noise -> zero matrix
        //final RealMatrix Q = MatrixUtils.createRealMatrix(4, 4);
        final RealMatrix Q = MatrixUtils.createRealMatrix(new double[][] {
                { 10,    0,   0,    0 },
                { 0,    10,   0,    0 },
                { 0,    0,   10,    0 },
                { 0,    0,   0,    10 }
        });

        // the measurement covariance matrix
        final RealMatrix R = MatrixUtils.createRealMatrix(new double[][] {
                {   1,    0,   0,    0 },
                {   0,    1,   0,    0 },
                {   0,    0,   1,    0 },
                {   0,    0,   0,    1 }
        });

        // the measurement covariance matrix for Kalman Filter
        final RealMatrix RK = MatrixUtils.createRealMatrix(new double[][] {
                {     1,    0,     0,    0 },
                {     0,    1,     0,    0 },
                {     0,    0,     1,    0 },
                {     0,    0,     0,    1 }
        });


        // the cannonball itself
        final Cannonball cannonball = new Cannonball(R, dt, angle, initialVelocity, measurementNoise, 1000);

        // This is our guess of the initial state.  I intentionally set the Y value
        // wrong to illustrate how fast the Kalman filter will pick up on that.
        final double speedX = cannonball.getXVelocity();
        final double speedY = cannonball.getYVelocity();
        final RealVector initialState = MatrixUtils.createRealVector(new double[] { 0, speedX, 0, speedY } );

        final ProcessModel pm = new DefaultProcessModel(A, B, Q, initialState, initialErrorCovariance);
        final MeasurementModel mm = new DefaultMeasurementModel(H, RK);
        final KalmanFilter filter = new KalmanFilter(pm, mm);

        final List<Number> realX = new ArrayList<Number>();
        final List<Number> realY = new ArrayList<Number>();
        final List<Number> measuredX = new ArrayList<Number>();
        final List<Number> measuredY = new ArrayList<Number>();
        final List<Number> kalmanX = new ArrayList<Number>();
        final List<Number> kalmanY = new ArrayList<Number>();

        final List<Number> kalmanGainX = new ArrayList<Number>();
        final List<Number> kalmanGainY = new ArrayList<Number>();

        for (int i = 0; i < iterations; i++) {

            // get real location
            realX.add(cannonball.getX());
            realY.add(cannonball.getY());

            // get measured location
            final double mx = cannonball.getMeasuredX();
            final double my = cannonball.getMeasuredY();

            measuredX.add(mx);
            measuredY.add(my);

            // iterate the cannon simulation to the next timeslice.
            cannonball.step();

            final double[] state = filter.getStateEstimation();
            kalmanX.add(state[0]);
            kalmanY.add(state[2]);

            // update the kalman filter with the measurements
            filter.predict(controlVector);
            filter.correct(new double[] { mx, 0, my, 0 } );
        }

        // STAMPIAMO LA MATRICE DEGLI ERRORI
        System.out.println("Matrice degli errori");
        double[][] error = filter.getErrorCovariance();
        printMatrix(error);
        System.out.println();

        // STAMPIAMO LA MATRICE DI KALMAN GAIN
        System.out.println("Matrice del Kalman gain");
        double[][] kalmanGain = filter.getKalmanGain().getData();
        printMatrix(kalmanGain);
        System.out.println();

        chart.setXAxisTitle("Distance (m)");
        chart.setYAxisTitle("Height (m)");

        Series dataset = chart.addSeries("true", realX, realY);
        dataset.setMarker(SeriesMarker.NONE);

        dataset = chart.addSeries("measured", measuredX, measuredY);
        dataset.setLineStyle(SeriesLineStyle.DOT_DOT);
        dataset.setMarker(SeriesMarker.NONE);

        dataset = chart.addSeries("kalman", kalmanX, kalmanY);
        dataset.setLineColor(Color.red);
        dataset.setLineStyle(SeriesLineStyle.DASH_DASH);
        dataset.setMarker(SeriesMarker.NONE);
    }

    public static Chart createChartBis(String title, LegendPosition position) {
        Chart chart = new ChartBuilder().width(650).height(450).build();

        // Customize Chart
        chart.setChartTitle(title);
        chart.getStyleManager().setChartTitleVisible(true);
        chart.getStyleManager().setChartTitleFont(new Font("Arial", Font.PLAIN, 12));
        chart.getStyleManager().setLegendPosition(position);
        chart.getStyleManager().setLegendVisible(true);
        chart.getStyleManager().setLegendFont(new Font("Arial", Font.PLAIN, 12));
        chart.getStyleManager().setLegendPadding(6);
        chart.getStyleManager().setLegendSeriesLineLength(10);
        chart.getStyleManager().setAxisTickLabelsFont(new Font("Arial", Font.PLAIN, 10));

        chart.getStyleManager().setChartBackgroundColor(Color.white);
        chart.getStyleManager().setChartPadding(4);

        chart.getStyleManager().setChartType(ChartType.Line);
        return chart;
    }

    public static JComponent createComponent() {
        JComponent container = new JPanel();
        container.setLayout(new BoxLayout(container, BoxLayout.LINE_AXIS));

        Chart chart = createChart("Cannonball", 550, 450, LegendPosition.InsideNE, true);
        Chart chart2 = createChart("Error", 450, 450, LegendPosition.InsideNE, false);
        Chart chart3 = createChart("Kalman Gain", 450, 450, LegendPosition.InsideNE, false);
        cannonballTest(chart,chart2,chart3);
        container.add(new XChartPanel(chart));

        container.setBorder(BorderFactory.createLineBorder(Color.black, 1));
        return container;
    }

    public static Chart createChart(String title, int width, int height,
                                       LegendPosition position, boolean legendVisible) {
        Chart chart = new ChartBuilder().width(width).height(height).build();

        // Customize Chart
        chart.setChartTitle(title);
        chart.getStyleManager().setChartTitleVisible(true);
        chart.getStyleManager().setChartTitleFont(new Font("Arial", Font.PLAIN, 12));
        chart.getStyleManager().setLegendPosition(position);
        chart.getStyleManager().setLegendVisible(legendVisible);
        chart.getStyleManager().setLegendFont(new Font("Arial", Font.PLAIN, 12));
        chart.getStyleManager().setLegendPadding(6);
        chart.getStyleManager().setLegendSeriesLineLength(10);
        chart.getStyleManager().setAxisTickLabelsFont(new Font("Arial", Font.PLAIN, 10));

        chart.getStyleManager().setChartBackgroundColor(Color.white);
        chart.getStyleManager().setChartPadding(4);

        chart.getStyleManager().setChartType(ChartType.Line);
        return chart;
    }

    @SuppressWarnings("serial")
    public static class Display extends ExampleFrame {

        private JComponent container;

        public Display() {
            setTitle("Commons Math: Kalman Filter - Cannonball");
            setSize(1450, 515);

            container = new JPanel();
            JComponent comp = createComponent();
            container.add(comp);

            add(container);
        }

        @Override
        public Component getMainPanel() {
            return container;
        }
    }

    public static void printMatrix(double[][] matrix){
        for(int i=0; i<matrix[0].length; i++){
            for(int j=0; j<matrix.length; j++){
                System.out.print(matrix[i][j] + "\t");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        ExampleUtils.showExampleFrame(new Display());
    }
}
