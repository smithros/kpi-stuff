import java.util.Arrays;

public class Func3 extends Thread {

    private Data data;

    Func3(String name, int priority, Data data){
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

    //O = (MP *MR)*S + T
    @Override
    public void run(){
        System.out.println("Func 3 started");

        int[][] MP =  data.matrixOne();
        int[][] MR =  data.matrixOne();
        int[] S =  data.vectorOne();
        int[] T =  data.vectorOne();

        try {
            int[] result = data.func3(MP,MR,S,T);
            sleep(100);
            System.out.println("Func3 result: " + Arrays.toString(result));
            System.out.println("Func 3 finished");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}