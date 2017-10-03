using System;

public class MemTest
{
      static public void Main()
      {
            const int M = 10;
            int room = 5;
            int urms = 250;
            double diff = 0.175;
            double[,,]C = new double [M,M,M];

            Console.WriteLine("Attempting to allocate " + (M*M*M) + " Doubles");
            for(int i = 0; i < M; i++)
            {
                  for(int j = 0; j < M; j++)
                  {
                        for(int k = 0; k < M; k++)
                        {
                              C[i,j,k] = i*M*M + j*M + k + 1;
                        }
                  }
            }

            int tacc = 0;
            int tstep = (room / urms) / M;
            int min, max;
            double avg = min / max;
            while(avg <= 0.99)
            {
                  
            }
            
            Console.WriteLine("Last element is " + C[M-1, M-1, M-1]);
      }
}
