//This program will calculate how long it will take to diffuse the size of a room with a substance 
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// C Code checked on 10/10/17 for mass consistency

void diffuse(double*** C, int M);
int main(int argc, char** argv)
{
      const int M;
      printf("What is the size of the box?\n");
      //Variable declarations
      scanf("%d", &M);
      if(M <= 0)
      {
            printf("Invalid number");
            exit(0);
      }
      int i,j,k;
      //Makes the array into cube form
      double ***C = malloc(M*sizeof(double**));
      for(i = 0; i < M; i++)
      {
            C[i] = malloc(M*sizeof(double*));
            for(j = 0; j < M; j++)
            {
                  C[i][j] = malloc(M*sizeof(double));
            }
      }
      //Zeroes out the array
      for(i = 0; i < M; i++)
      {
            for(j = 0; j < M; j++)
            {
                  for(k = 0; k < M; k++)
                  {
                        C[i][j][k] = 0.0;
                  }
            }
      }
      printf("Beginning Box Simulation...\n");
      diffuse(C, M);  //Calls the method diffuse
      free(C);     //Empties C to save space
}
//Method to go through the array and diffuse the box
void diffuse(double*** C, int M)
{
      //More variables
      C[0][0][0] = 1.0 * pow(10,21);  //Makes first cell 1.0e21
      double room = 5.0;
      double diff = 0.175;
      double urms = 250.0;  //Given constant for g/mol of gas
      double tstep = (double) (room / urms) / M;
      double height = (double) room / M;
      double tacc = 0.0;
      double ratio = 0.0;
      double sum = 0.0;
      double dC = diff * tstep / (height * height);
      //Loop that checks if the boxes are not all equal
      do
      {
            for(int i = 0; i < M; i++)
            {
                  for(int j = 0; j < M; j++)
                  {
                        for(int k = 0; k < M; k++)
                        {
                              for(int l = 0; l < M; l++)
                              {
                                    for(int m = 0; m < M; m++)
                                    {
                                          for(int n = 0; n < M; n++)
                                          {
                                                //Checks all of the adjacent blocks from the current block
                                                if(((i==l) && (j==m) && (k==n+1)) || ((i==l) && (j==m) && (k==n-1)) || ((i==l) && (j==m+1) && (k==n)) ||
                                                   ((i==l) && (j==m-1) && (k==n)) || ((i==l+1) && (j==m) && (k==n)) || ((i==l-1) && (j==m) && (k==n)))
                                                {
                                                      double change = (C[i][j][k] - C[l][m][n]) * dC;
                                                      C[i][j][k] = C[i][j][k] - change;
                                                      C[l][m][n] = C[l][m][n] + change;
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }
            tacc = tacc + tstep;
            //Makes sure there is mass consistency
            double maxc = C[0][0][0];
            double minc = C[0][0][0];
            sum = 0.0;
            for(int i = 0; i < M; i++)
            {
                  for(int j = 0; j < M; j++)
                  {
                        for(int k = 0; k < M; k++)
                        {
                              maxc = fmax(C[i][j][k], maxc);
                              minc = fmin(C[i][j][k], minc);
                              sum += C[i][j][k];
                        }
                  }
            }
            ratio = minc / maxc;      //Sees if min and max are equal in order to end while loop
            //Prints the different variable types in loop
            /*printf("%f %f %f\n", tacc, ratio, C[0][0][0]);
              printf("%f\n", C[M-1][M-1][M-1]);
              printf("%f\n", sum);*/
      } while(ratio <= 0.99);
      printf("Total sum is %f.\n", sum);
      printf("Box completed in %f seconds.\n", tacc);
}
