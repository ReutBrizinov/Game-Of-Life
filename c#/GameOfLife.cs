using System;
using System.Threading;
namespace GameOfLife
{
    //# If a cell is ON and has fewer than two neighbors that are ON, it turns OFF
    //# If a cell is ON and has either two or three neighbors that are ON, it remains ON.
    //# If a cell is ON and has more than three neighbors that are ON, it turns OFF.
    //# If a cell is OFF and has exactly three neighbors that are ON, it turns ON.


    class Program
    {
        static int gameboard_len = 10;

        public static void Update(int[,] gameboard)
        {
            int[,] temp = new int[gameboard_len, gameboard_len];
            int neighbors = 0;
            for (int i = 1; i < gameboard_len; i++)
            {
                for (int j = 1; j < gameboard_len; j++)
                {
                    neighbors = CountNeighbors(i, j, gameboard);
                    if (gameboard[i, j] == 1)
                    {
                        if (neighbors > 3 || neighbors < 2)
                        {
                            temp[i, j] = 0;
                        }
                        else
                        {
                            temp[i, j] = 1;
                        }
                    }
                    else
                    {
                        if (neighbors == 3)
                        {
                            temp[i, j] = 1;
                        }
                        else
                            temp[i, j] = 0;

                    }




                }
            }

            for (int i = 1; i < gameboard_len; i++)
            {
                for (int j = 1; j < gameboard_len; j++)
                {
                    gameboard[i, j] = temp[i, j];

                }
            }


        }

        public static void Draw(int[,] gameboard)
        {
            Console.Clear();
            for (int i = 0; i < gameboard_len; i++)
            {
                for (int j = 0; j < gameboard_len; j++)
                {
                    if (gameboard[i, j] == 0)
                    {
                        Console.Write(".");
                    }
                    else
                        Console.Write("O");


                }
                Console.WriteLine();

            }

        }

        public static int CountNeighbors(int row, int col, int[,] gameboard)
        {
            int neighbor = 0;
            int N = gameboard_len;
            neighbor += gameboard[((row - 1) % N), ((col - 1) % N)];
            neighbor += gameboard[((row - 1) % N), col];
            neighbor += gameboard[((row - 1) % N), ((col + 1) % N)];
            neighbor += gameboard[row, ((col - 1) % N)];
            neighbor += gameboard[row, ((col + 1) % N)];
            neighbor += gameboard[((row + 1) % N), ((col - 1) % N)];
            neighbor += gameboard[((row + 1) % N), col];
            neighbor += gameboard[((row + 1) % N), ((col + 1) % N)];

            return neighbor;

        }


        static void Main(string[] args)
        {


            int[,] gameboard = new int[gameboard_len, gameboard_len];


            //intionalize
            for (int i = 0; i < gameboard_len; i++)
            {
                for (int j = 0; j < gameboard_len; j++)
                {
                    gameboard[i, j] = 0;
                }

            }
            gameboard[2, 2] = 1;
            gameboard[2, 3] = 1;
            gameboard[2, 4] = 1;


            gameboard[5, 3] = 1;
            gameboard[6, 3] = 1;
            gameboard[6, 4] = 1;
            gameboard[6, 7] = 1;
            gameboard[7, 6] = 1;
            gameboard[8, 5] = 1;

            Draw(gameboard);
            //Game life cycle
            Update(gameboard);
            while (true)
            {
                Update(gameboard);
                Draw(gameboard);
                Thread.Sleep(100);
            }

        }
    }
}
