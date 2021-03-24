using System;
using static lab3.Lab3;

namespace lab3
{
    public class Vector {

        private long[] grid;

        public Vector(int N) {
            grid = new long[N];
            Random r = new Random();
            for (int i = 0; i < N; ++i)
                grid[i] = r.Next(20);
        }

        public void FillVectorWithNumber(int number)
        {
            for (var i = 0; i < N; i++)
            {
               grid[i] = number;
            }
        }

        public Vector(long[] grid) {
            this.grid = grid;
        }

        public int getSize() {
            return grid.Length;
        }

        public long get(int i) {
            return grid[i];
        }

        public Vector sum(Vector v) {
            int N = getSize();
            long[] newGrid = new long[N];
            for (int i = 0; i < N; ++i)
                newGrid[i] = grid[i] + v.get(i);
            return new Vector(newGrid);
        }

        public Vector sub(Vector v)
        {
            int N = getSize();
            long[] newGrid = new long[N];
            for (int i = 0; i < N; ++i)
                newGrid[i] = grid[i] - v.get(i);
            return new Vector(newGrid);
        }

        public long multiply(Vector v)
        {
            int N = getSize();
            long newGrid = new long();
            for (int i = 0; i < N; ++i)
            {
                newGrid = grid[i] * v.get(i);
            }
            return newGrid;
        }

        public Vector multiply(long a)
        {
            int N = getSize();
            long[] newGrid = new long[N];
            for (int i = 0; i < N; ++i)
            {
                newGrid[i] = grid[i] * a;
            }
            return new Vector(newGrid);
        }

        public Vector sort() {
            int N = getSize();
            long[] newGrid = (long[]) grid.Clone();
            for (int i = 0; i < N; ++i)
            {
                for (int k = 0; k < N - i - 1; ++k)
                {
                    if (newGrid[k] > newGrid[k + 1])
                    {
                        long t = newGrid[k];
                        newGrid[k] = newGrid[k + 1];
                        newGrid[k + 1] = t;
                    }
                }
            }
            return new Vector(newGrid);
        }

    public String toString() {
            String res = "";
            int N = getSize();
            for (int i = 0; i < N; ++i)
                res += grid[i] + " ";
            return res;
        }
    }

}
