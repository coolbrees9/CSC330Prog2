//This program will diffuse a room with a given substance's diffusion constant
using System;

// C# checked on 10/15/17 

public class MemTest
{
      static public void Main()
      {
            Console.WriteLine("What is the size of the box?");
            //Variable declarations
            int M = Convert.ToInt32(Console.ReadLine());  //Converts user input to int value for box size
            if(M <= 0)
            {
                  Console.WriteLine("Invalid number");
                  System.Environment.Exit(1);
            }
            double[,,]C = new double [M,M,M]; //Creates the 3D array
            //Loop that zeroes out the array
            for(int i = 0; i < M; i++)
            {
                  for(int j = 0; j < M; j++)
                  {
                        for(int k = 0; k < M; k++)
                        {
                              C[i,j,k] = 0.0;
                        }
                  }
            }
            Console.WriteLine("Beginning Diffusion process...");
            diffuse(C,M);  //Calls the method diffuse
      }
      //Method to go through the array and diffuse the box
      static void diffuse(double[,,] C, int M)
      {
            //More variables
            C[0,0,0] = 1.0 * Math.Pow(10,21);  //Makes first cell 1.0e21
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
                                                            double change = (C[i,j,k] - C[l,m,n]) * dC;
                                                            C[i,j,k] = C[i,j,k] - change;
                                                            C[l,m,n] = C[l,m,n] + change;
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
                  tacc = tacc + tstep;
                  //Makes sure there is mass consistency
                  double maxc = C[0,0,0];
                  double minc = C[0,0,0];
                  sum = 0.0;
                  for(int i = 0; i < M; i++)
                  {
                        for(int j = 0; j < M; j++)
                        {
                              for(int k = 0; k < M; k++)
                              {
                                    maxc = Math.Max(C[i,j,k], maxc);
                                    minc = Math.Min(C[i,j,k], minc);
                                    sum += C[i,j,k];
                              }
                        }
                  }
                  ratio = minc / maxc;      //Sees if min and max are equal in order to end while loop
                  //Prints the different variable types in loop
                  /*Console.WriteLine(tacc + " " + ratio + " " + C[0,0,0]);
                  Console.WriteLine(C[M-1,M-1,M-1]);
                  Console.WriteLine(sum);*/
            } while(ratio <= 0.99);
            Console.WriteLine("Total sum is " + sum);
            Console.WriteLine("Box completed in " + tacc + " seconds.");
      }
}
