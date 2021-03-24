using System;
using System.Threading;
using static lab3.Lab3;

namespace lab3
{
    public class Function3
    {
        public void Run()
        {
            lock (Lab3.locker)
            {
                // F3 3.14  T = (O + P) * (ML * MS)
                
                //Thread.Sleep(1000);
                Vector P = new Vector(N);
                Vector O = new Vector(N);
                Matrix ML = new Matrix(N);
                Matrix MS = new Matrix(N);
                Vector result;

                P.FillVectorWithNumber(1);
                O.FillVectorWithNumber(1);
                ML.FillMatrixWithNumber(1);
                MS.FillMatrixWithNumber(1);

                Console.WriteLine("Function 3 start");
                result = ML.multiply(MS).multiply(O.sum(P));
                Console.WriteLine("Function 3 result \n" + result.toString());
                Console.WriteLine("Function 3 end \n");
            }
        }
    }

}
