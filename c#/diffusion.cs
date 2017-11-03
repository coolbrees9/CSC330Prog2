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
            Console.WriteLine("Is there a partition? (0 for no, 1 for yes)");
            int partition = Convert.ToInt32(Console.ReadLine());  //Checks if user wants a partition
            if(partition != 1 && partition != 0)
            {
                  Console.WriteLine("Partition will turn off.");
                  partition = 0;
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
            diffuse(C,M,partition);  //Calls the method diffuse
      }
      //Method to go through the array and diffuse the box
      static void diffuse(double[,,] C, int M, int partition)
      {
            //More variables
            decimal partsize = 0;
            if(partition == 1)
                  partsize = Decimal.Floor(M / 2);
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
            double change;
            if(partition == 1)
            {
                  for(int i = 0; i < M; i++)
                  {
                        for(int j = 0; j < M; j++)
                        {
                              for(int k = 0; k < M; k++)
                              {
                                    if((i == partsize-1) && (j >= partsize-1))
                                    {
                                          C[i,j,k] = -1.0;
                                    }
                              }
                        }
                  }      
            }
            //Loop that checks if the boxes are not all equal
            do
            {
                  for(int i = 0; i < M; i++)
                  {
                        for(int j = 0; j < M; j++)
                        {
                              for(int k = 0; k < M; k++)
                              {
                                    if(C[i,j,k] != -1.0)
                                    {
                                                if(i != 0 && C[i-1,j,k] != -1.0)
                                                {
                                                      change=(C[i,j,k]-C[i-1,j,k])*dC;
                                                      C[i,j,k]=C[i,j,k]-change;
                                                      C[i-1,j,k]=C[i-1,j,k]+change;
                                                }
                                                if(j != 0 && C[i,j-1,k] != -1.0)
                                                {
                                                      change=(C[i,j,k]-C[i,j-1,k])*dC;
                                                      C[i,j,k]=C[i,j,k]-change;
                                                      C[i,j-1,k]=C[i,j-1,k]+change;
                                                }
                                                if(k != 0 && C[i,j,k-1] != -1.0)
                                                {
                                                      change=(C[i,j,k]-C[i,j,k-1])*dC;
                                                      C[i,j,k]=C[i,j,k]-change;
                                                      C[i,j,k-1]=C[i,j,k-1]+change;
                                                }
                                                if(i != M-1 && C[i+1,j,k] != -1.0)
                                                {
                                                      change=(C[i,j,k]-C[i+1,j,k])*dC;
                                                      C[i,j,k]=C[i,j,k]-change;
                                                      C[i+1,j,k]=C[i+1,j,k]+change;
                                                }
                                                if(j != M-1 && C[i,j+1,k] != -1.0)
                                                {
                                                      change=(C[i,j,k]-C[i,j+1,k])*dC;
                                                      C[i,j,k]=C[i,j,k]-change;
                                                      C[i,j+1,k]=C[i,j+1,k]+change;
                                                }
                                                if(k != M-1 && C[i,j,k+1] != -1.0)
                                                {
                                                      change=(C[i,j,k]-C[i,j,k+1])*dC;
                                                      C[i,j,k]=C[i,j,k]-change;
                                                      C[i,j,k+1]=C[i,j,k+1]+change;
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
                                    if(C[i,j,k] != -1.0)
                                    {
                                          maxc = Math.Max(C[i,j,k], maxc);
                                          minc = Math.Min(C[i,j,k], minc);
                                          sum += C[i,j,k];
                                    }
                              }
                        }
                  }
                  ratio = minc / maxc;      //Sees if min and max are equal in order to end while loop
                  //Prints the different variable types in loop
                  Console.WriteLine(tacc + " " + ratio + " " + C[0,0,0]);
                  //Console.WriteLine(C[M-1,M-1,M-1]);
                  Console.WriteLine(sum);
            } while(ratio <= 0.99);
            Console.WriteLine("Total sum is " + sum);
            Console.WriteLine("Box completed in " + tacc + " seconds.");
      }
}
