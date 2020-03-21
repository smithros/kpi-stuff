using System;

namespace PRO_Lab1
{
    /*
    ---------------------------------
    -- Lab1: C#
    -- A = max(B) * (D*MZ) - e*R
    -- Коваль Ростислав
    -- ІО-71
    ---------------------------------
    */
    using System.Threading;
    public class Program
    {
        public const int N = 9;
        public const int P = 3;
        public const int H = N / P;
        public static int b = 0;
        public static int e = 0;

        public static int[] B = new int[N];
        public static int[] D = new int[N];
        public static int[] R = new int[N];
        public static int[] A = new int[N];

        public static int[,] MZ = new int[N, N];

        private static Mutex mutexForB = new Mutex();
        private static readonly object copyD = new object();
        private static Mutex mutexForE = new Mutex();

        private static Semaphore inputSemaphore = new Semaphore(0, 2);
        private static Semaphore calcT1Semaphore = new Semaphore(0, 1);
        private static Semaphore calcT2Semaphore = new Semaphore(0, 1);
        
        private static EventWaitHandle event1 = new EventWaitHandle(false, EventResetMode.ManualReset);
        private static EventWaitHandle event2 = new EventWaitHandle(false, EventResetMode.ManualReset);
        private static EventWaitHandle event3 = new EventWaitHandle(false, EventResetMode.ManualReset);


        public static void T1()
        {
            Console.WriteLine("T1 Started");
            // очікування на ввід в Т3
            inputSemaphore.WaitOne();
            
            // Обчислення b1 
            int b1 = 0;
            for (int i = 0; i < H; i++)
            {
                b1 = B[0];
                if (b1 < B[i]) {
                    b1 = B[i];
                }
            }

            // Обчислення b
            mutexForB.WaitOne();
            b = Math.Max(b, b1);
            mutexForB.ReleaseMutex();

            // 
            event1.Set();
            event2.WaitOne();
            event3.WaitOne();
            
            // cтворення копій
            int b_1;
            int e1;
            int[] D1 = new int[N];

            // критична ділянка для копіювання
          
            lock (copyD)
            {
                for (int i = 0; i < N; i++)
                {
                    D1[i] = D[i];
                }
            }

            mutexForB.WaitOne();
            b_1 = b;
            mutexForB.ReleaseMutex();

            mutexForE.WaitOne();
            e1 = e;
            mutexForE.ReleaseMutex();

            // Обчислення частинного результату
            int[] F1 = new int[H];

            for (int i = 0; i < H; i++)
            {
                F1[i] = 0;
                for (int j = 0; j < N; j++)
                {
                    F1[i] += b_1 * (D1[j] * MZ[i, j]);
                }
            }

            for (int i = 0; i < H; i++)
            {
                R[i] *= e1;
            }

            for (int i = 0; i < H; i++)
            {
                A[i] = F1[i] - R[i];
            }

            calcT1Semaphore.Release();
            Console.WriteLine("T1 Finished");
        }


        public static void T2()
        {
            Console.WriteLine("T2 Started");
            // очікування на ввід в Т3
            inputSemaphore.WaitOne();

            // Обчислення b2 
            int b2 = 0;
            for (int i = 0; i < H; i++)
            {
                b2 = B[0];
                if (b2 < B[i])
                {
                    b2 = B[i];
                }
            }

            // Обчислення b
            mutexForB.WaitOne();
            b = Math.Max(b, b2);
            mutexForB.ReleaseMutex();

            // 
            event2.Set();
            event1.WaitOne();
            event3.WaitOne();

            // cтворення копій
            int b_2;
            int e2;
            int[] D2 = new int[N];

            // критична ділянка для копіювання
            lock (copyD)
            {
                for (int i = 0; i < N; i++)
                {
                    D2[i] = D[i];
                }
            }


            mutexForB.WaitOne();
            b_2 = b;
            mutexForB.ReleaseMutex();

            mutexForE.WaitOne();
            e2 = e;
            mutexForE.ReleaseMutex();

            // Обчислення частинного результату
            int[] F2 = new int[N];

            for (int i = H; i < 2*H; i++)
            {
     
                for (int j = 0; j < N; j++)
                {
                    F2[i] += b_2 * (D2[j] * MZ[i, j]); 
                }
            }

            for (int i = H; i < 2*H; i++)
            {
                R[i] *= e2;
            }

            for (int i = H; i < 2*H; i++)
            {
                A[i] = F2[i] - R[i];
            }

            calcT2Semaphore.Release();
            Console.WriteLine("T2 Finished");
        }

        public static void T3()
        {
            Console.WriteLine("T3 Started");
            // Введення даних
            e = 1;
            for (int i = 0; i < N; i++)
            {
                B[i] = 1;
                D[i] = 1;
                R[i] = 1;
            }
            for (int i = 0; i < N; i++)
            {
                for (int j = 0; j < N; j++)
                {
                    MZ[i, j] = 1;
                }
            }

            inputSemaphore.Release(2);

            // Обчислення b3 
            int b3 = 0;
            for (int i = 0; i < H; i++)
            {
                b3 = B[0];
                if (b3 < B[i])
                {
                    b3 = B[i];
                }
            }

            // Обчислення b
            mutexForB.WaitOne();
            b = Math.Max(b, b3);
            mutexForB.ReleaseMutex();
            
            event3.Set();
            event1.WaitOne();
            event2.WaitOne();

            // cтворення копій
            int b_3;
            int e3;
            int[] D3 = new int[N];

            // критична ділянка для копіювання
            lock (copyD)
            {
                for (int i = 0; i < N; i++)
                {
                    D3[i] = D[i];
                }
            }

            mutexForB.WaitOne();
            b_3 = b;
            mutexForB.ReleaseMutex();

            mutexForE.WaitOne();
            e3 = e;
            mutexForE.ReleaseMutex();

            // Обчислення частинного результату
            int[] F3 = new int[N];

            for (int i = 2*H; i < N; i++)
            {
                F3[i] = 0;
                for (int j = 0; j < N; j++)
                {
                    F3[i] += b_3 * (D3[j] * MZ[i, j]); 
                }
            }

            for (int i = 2*H; i < N; i++)
            {
                R[i] *= e3;
            }

            for (int i = 2*H; i < N; i++)
            {
                A[i] = F3[i] - R[i];
            }

            calcT1Semaphore.WaitOne();
            calcT2Semaphore.WaitOne();


            Console.WriteLine("Result :");
            for (int i = 0; i < N; i++)
            {
                Console.WriteLine("{0}", A[i]);
            }
            Console.WriteLine("T3 Finished");
        }

        public static void Main(string[] args)
        {
            Console.WriteLine("Main Started");
            Thread t1 = new Thread(new ThreadStart(T1));
            Thread t2 = new Thread(new ThreadStart(T2));
            Thread t3 = new Thread(new ThreadStart(T3));
            t1.Start();
            t2.Start();
            t3.Start();

            t3.Join();
            Console.WriteLine("Main Finished");
        }
    }
}