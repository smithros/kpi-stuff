using System;
using static lab3.Lab3;

namespace lab3
{
    public class Matrix
    {

        public Matrix(int N)
        {
            Random r = new Random();
            grid = new long[N, N];
            for (int i = 0; i < N; ++i)
                for (int k = 0; k < N; ++k)
                    grid[i, k] = r.Next(20);
        }

        public void FillMatrixWithNumber(int number)
        {
            for (var i = 0; i < N; i++)
            {
                for (var j = 0; j < N; j++)
                {
                    grid[i, j] = number;
                }
            }
        }

        public Matrix(long[,] grid)
        {
            this.grid = (long[,])
            grid.Clone();
        }

        public long get(int i, int k)
        {
            return grid[i, k];
        }

        private long[,] grid;

        public int getSize()
        {
            return grid.GetLength(0);
        }

        public Matrix multiply(Matrix m)
        {
            int N = getSize();
            long[,] newGrid = new long[N, N];
            for (int i = 0; i < N; ++i)
            {
                for (int k = 0; k < N; ++k)
                {
                    newGrid[i, k] = 0;
                    for (int j = 0; j < N; ++j)
                    {
                        newGrid[i, k] += grid[i, j] * m.get(j, k);
                    }
                }
            }
            return new Matrix(newGrid);
        }

        public Vector multiply(Vector v)
        {
            int N = getSize();
            long[] newGrid = new long[N];
            for (int i = 0; i < N; ++i)
            {
                newGrid[i] = 0;
                for (int k = 0; k < N; ++k)
                {
                    newGrid[i] += v.get(k) * grid[i, k];
                }
            }
            return new Vector(newGrid);
        }

        public Matrix multiply(long a)
        {
            int N = getSize();
            long[,] newGrid = new long[N, N];
            for (int i = 0; i < N; ++i)
            {
                for (int k = 0; k < N; ++k)
                {
                    newGrid[i, k] = grid[i, k] * a;
                }
            }
            return new Matrix(newGrid);
        }

        public Matrix sum(Matrix m)
        {
            int N = getSize();
            long[,] newGrid = new long[N, N];
            for (int i = 0; i < N; ++i)
            {
                for (int k = 0; k < N; ++k)
                {
                    newGrid[i, k] = grid[i, k] + m.get(i, k);
                }
            }
            return new Matrix(newGrid);
        }

        public Matrix sub(Matrix m)
        {
            int N = getSize();
            long[,] newGrid = new long[N, N];
            for (int i = 0; i < N; ++i)
            {
                for (int k = 0; k < N; ++k)
                {
                    newGrid[i, k] = grid[i, k] - m.get(i, k);
                }
            }
            return new Matrix(newGrid);
        }

        public long min()
        {
            long res = grid[0, 0];
            int N = getSize();
            for (int i = 0; i < N; ++i)
            {
                for (int k = 0; k < N; ++k)
                {
                    if (res < grid[i, k])
                        res = grid[i, k];
                }
            }
            return res;
        }

        public long max()
        {
            long res = grid[0, 0];
            int N = getSize();
            for (int i = 0; i < N; ++i)
            {
                for (int k = 0; k < N; ++k)
                {
                    if (res > grid[i, k])
                        res = grid[i, k];
                }
            }
            return res;
        }

    public String toString()
    {
            String res = "";
            int N = getSize();
            for (int i = 0; i < N; ++i)
            {
                for (int k = 0; k < N; ++k)
                {
                    res += grid[i, k] + "\t";
                }
                res += "\n";
            }
            return res;
        }
    }
}
