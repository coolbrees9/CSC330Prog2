//This program will calculate how long it will take to diffuse the size of a room with a substance 
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#define mval(MEM,i,j,k) MEM[i*M*M+j*M+k]
int main(int argc, char** argv)
{
      //Variable declarations
      const int M = 10;
      int room = 5;
      int i,j,k,l,m,n;
      double diff = 0.175;
      int urms = 250;
      clock_t start, end, final;
      time_t wstart = time(NULL);
      start = clock();
      double* C = malloc(M*M*M*sizeof(double));
      //Makes the 3D array
      for(i = 0; i < M; i++)
      {
            for(j = 0; j < M; j++)
            {
                  for(k = 0; k < M; k++)
                  {
                        mval(C,i,j,k) = i*M*M + j*M + k + 1.0;
                  }
            }
      }
      //More variables 
      C[0,0,0] = 1.0 * pow(10,21);
      double tstep = (double) (room / urms) / M;
      double height = (double) room / M;
      double tacc = 0.0;
      double min = mval(C,0,0,1);
      double max = C[0,0,0];
      double avg = min / max;
      double dC = C[0,0,1] - C[0,0,0];
      //Loop that checks if the boxes are not all equal
      while(avg <= 0.99)
      {
            tacc = tacc + tstep;
            for(i = 0; i < M; i++)
            {
                  for(l = 0; l < M; l++)
                  {
                        for(j = 0; j < M; j++)
                        {
                              for(m = 0; m < M; m++)
                              {
                                    for(k = 0; k < M; k++)
                                    {
                                          for(n = 0; n < M; n++)
                                          {
                                                mval(C,i,j,k) = (diff * (mval(C,l,m,n) - mval(C,i,j,k)) * tstep) / (height * height);
                                                mval(C,i,j,k) = mval(C,i,j,k) + (C[M*M*M-1] - dC);
                                                mval(C,l,m,n) = mval(C,l,m,n) - (C[M*M*M-1] - dC);
                                                min = C[l,m,n];
                                          }
                                    }
                              }
                        }
                  }
            }
            avg = min / max;
      }
      //Calculating the CPU and wall time and printing out
      end = clock();
      final = (double) (end - start) / CLOCKS_PER_SEC;
      printf("CPU time: %.2f\n", final);
      printf("Wall Clock time: %.2f\n", (double) (time(NULL) - wstart));
      printf("The last array element is %f\n", C[M*M*M-1]);
      free(C);
}
