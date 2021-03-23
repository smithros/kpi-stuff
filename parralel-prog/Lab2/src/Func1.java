import java.util.Arrays;

public class Func1 extends Thread {

    private Data data;

    Func1(String name, int priority, Data data){
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

    // ME = MAX(B) *(MA*MD)
    @Override
    public void run(){
        System.out.println("Func 1 started");

        int[][] MA = data.matrixOne();
        int[][] MD = data.matrixOne();
        int[] B = data.vectorOne();

        try {
            int[][] result = data.func1(B,MA,MD);
            sleep(100);
            System.out.println("Func1 result: "+ Arrays.deepToString(result));
            System.out.println("Func 1 finished");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
