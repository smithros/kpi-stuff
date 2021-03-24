using System;
using System.Threading;
using static lab3.Lab3;

namespace lab3
{
    public class Function2
    {
        public void Run()
        {
            // F2 2.2   MF = MG*(MK*ML) - MK 
             lock (Lab3.locker)
             {
                
                //Thread.Sleep(1000);
                Matrix MG = new Matrix(N);
                Matrix MK = new Matrix(N);
                Matrix ML = new Matrix(N);
                
                Matrix result;

                MG.FillMatrixWithNumber(1);
                MK.FillMatrixWithNumber(1);
                ML.FillMatrixWithNumber(1);

                Console.WriteLine("Function 2 start");
                result = MG.multiply(MK.multiply(ML)).sub(MK);

                Console.WriteLine("Function 2 result \n" + result.toString());
                Console.WriteLine("Function 2 end \n");
             }
        }
    }

}
