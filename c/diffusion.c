//This program will calculate how long it will take to diffuse the size of a room with a substance 
#include <stdio.h>
#include <stdlib.h>
#define mval(MEM,i,j,k) MEM[i*M*M+j*M+k]
int main(int argc, char** argv)
{
      //Variable declarations
      const int M = 10;
      int room = 5;
      int i,j,k,l,m,n;
      double diff = 0.175;
      int urms = 250;
      double* C = malloc(M*M*M*sizeof(double));

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
      int tstep = (room / urms) / M;
      double height = room / M;
      int tacc = 0;
      double min, max;
      double avg = min / max;
      while(avg <= 0.99)
      {
            tacc = tacc + tstep;
            for(i = 0; i < M; i++)
            {
                  for(j = 0; j < M; j++)
                  {
                        for(k = 0; k < M; k++)
                        {
                              mval(C,i,j,k) = (diff * (mval(C,l,m,n) - mval(C,i,j,k)) * tstep) / (height * height);
                              mval(C,i,j,k) = mval(C,i,j,k) + C;
                              mval(C,l,m,n) = mval(C,l,m,n) - C;
                        }
                  }
            }
            avg = min / max;
      }
      //printf("The last array element is %f\n", C[M*M*M-1]);
      free(C);
}
