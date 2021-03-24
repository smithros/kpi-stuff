using System;
using System.Threading;

/*
 * Koval Rostislav IO-71, Lab3
F1  1.2   C = A + B*(MO*ME) 
F2  2.2   MF = MG*(MK*ML) - MK 
F3  3.14  T = (O + P)*(ML * MS) 
*/

namespace lab3
{
    class Lab3
    {
        public static object locker = new object();
        public static int N = 2;

        static void Main(string[] args)
        {
                Thread MainThread = new Thread(new Lab3().Run);
                MainThread.Start();
                MainThread.Priority = ThreadPriority.Normal;
        }
        public void Run()
        {
            lock (new Lab3())
            {
                Console.WriteLine("Lab 3 start\n");
                Thread thread1 = new Thread(new Function1().Run);
                Thread thread2 = new Thread(new Function2().Run);
                Thread thread3 = new Thread(new Function3().Run);

                thread1.Priority = ThreadPriority.Lowest;
                thread2.Priority = ThreadPriority.Highest;
                thread3.Priority = ThreadPriority.Normal;

           
                thread1.Start();
                //thread1.Join();
           
                thread2.Start();
                //thread2.Join();
         
                thread3.Start();
                //thread3.Join();
                
                Thread.Sleep(100);
                Console.WriteLine("Lab 3 end \n");
               // Console.Write("Press any key to end the program...");
                Console.ReadKey();
            }
        }
    }
}
