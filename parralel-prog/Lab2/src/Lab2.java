import java.util.Scanner;

public class Lab2 extends Thread{
    public static void main(String[] args) {
        new Lab2().start();
    }

    @Override
    public void run(){
        setName("Lab2");
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter matrix shape: ");
        int N = scanner.nextInt();
        System.out.println("Lab2 already started!");

        Data data = new Data(N);
        Func1 func1 = new Func1("Func1",4/*Thread.NORM_PRIORITY*/, data);
        Func2 func2 = new Func2("Func2",8/*Thread.MAX_PRIORITY*/, data);
        Func3 func3 = new Func3("Func3",5/*Thread.MIN_PRIORITY*/, data);

        func1.start();
        func2.start();
        func3.start();

        try {
            func1.join();
            func2.join();
            func3.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Lab2 finished");

    }
}
