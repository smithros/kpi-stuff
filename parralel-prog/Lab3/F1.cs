using System;
using System.Threading;
using static lab3.Lab3;

namespace lab3
{
    public class Function1
    { 
        public void Run()
        {
            //F1  1.2 C = A + B*(MO*ME) 
           lock (Lab3.locker)
           {
                //Thread.Sleep(1000);
                Vector A = new Vector(N);
                Vector B = new Vector(N);
                Matrix MO = new Matrix(N);
                Matrix ME = new Matrix(N);
               
                Vector result;

                A.FillVectorWithNumber(1);
                B.FillVectorWithNumber(1);
                MO.FillMatrixWithNumber(1);
                ME.FillMatrixWithNumber(1);

                Console.WriteLine("Function 1 start");
                result = A.sum(MO.multiply(ME).multiply(B));
                Console.WriteLine("Function 1 result \n" + result.toString());
                Console.WriteLine("Function 1 end \n");
           }
        }
    }

}
