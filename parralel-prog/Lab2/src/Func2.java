import java.util.Arrays;

public class Func2 extends Thread {

    private Data data;

    Func2(String name, int priority, Data data){
        setName(name);
        setPriority(priority);
        this.data = data;

    }

    public Data getData() {
        return data;
    }

    public void setData(Data data) {
        this.data = data;
    }


    //MF = g*TRANS(MG)*(MK*ML)
    @Override
    public void run(){
        System.out.println("Func 2 started");

        int[][] MG = data.matrixOne();
        int[][] MK = data.matrixOne();
        int[][] ML = data.matrixOne();
        int g = data.getN();

        try {
            int[][] result = data.func2(g,MG,MK,ML);
            sleep(100);
            System.out.println("Func2 result: " + Arrays.deepToString(result));
            System.out.println("Func 2 finished");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
