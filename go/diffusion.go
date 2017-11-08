//This program will diffuse a room with a given substance based on room and dimension size

// Checked go on 10/21/17

package main
import "fmt"
import "math"
import "time"

func main(){
      var temp float64 = 10.0
      fmt.Println("How big is the box?")
      fmt.Scan(&temp)
      const M int = 10
      var C[M][M][M] float64  //Makes a 3D array
      //Zeroes out the array
      for i := 0; i < M; i++{
            for j := 0; j < M; j++{
                  for k := 0; k < M; k++{
                        C[i][j][k] = 0
                  }
            }
      }
      //Sees if user wants a partition
      var partition int = 0
      fmt.Println("Is there a partition? (0 for no, 1 for yes)")
      fmt.Scan(&partition)
      //Starts the timer for CPU time
      start := time.Now()
      //Variable Declarations
      C[0][0][0] = 1.0e21
      var diff float64 = 0.175
      var room float64 = 5
      var urms float64 = 250.0
      var tstep float64 = (float64(room) / urms) / float64(M)
      var height float64 = float64(room) / float64(M)
      var dC float64 = diff * tstep / (height * height)
      var tacc float64 = 0.0
      var ratio float64 = 0.0
      var change float64
      var partsize int = int(math.Floor(temp / 2))
      fmt.Println("Beginning Box simulation...")
      if partition != 1 && partition != 0{
            fmt.Println("Partition will be set to 0")
            partition = 0
      }
      if partition == 1{
            for i := 0; i < M; i++{
                  for j := 0; j < M; j++{
                        for k := 0; k < M; k++{
                              if i == partsize-1 && j >= partsize-1{
                                    C[i][j][k] = -1.0
                              }
                        }
                  }
            }
      }
      //Loop that will go into every block and diffuse adjacent blocks
      for ratio <= 0.99{
            for i := 0; i < M; i++{
                  for j := 0; j < M; j++{
                        for k := 0; k < M; k++{
                              if C[i][j][k] != -1.0{
                                    //Checks all of the adjacent blocks from the current block
                                    if i != 0 && C[i-1][j][k] != -1.0{
                                          change=(C[i][j][k]-C[i-1][j][k])*dC
                                          C[i][j][k]=C[i][j][k]-change
                                          C[i-1][j][k]=C[i-1][j][k]+change
                                    }
                                    if j != 0 && C[i][j-1][k] != -1.0{
                                          change=(C[i][j][k]-C[i][j-1][k])*dC
                                          C[i][j][k]=C[i][j][k]-change
                                          C[i][j-1][k]=C[i][j-1][k]+change
                                    }
                                    if k != 0 && C[i][j][k-1] != -1.0{
                                          change=(C[i][j][k]-C[i][j][k-1])*dC
                                          C[i][j][k]=C[i][j][k]-change
                                          C[i][j][k-1]=C[i][j][k-1]+change
                                    }
                                    if i != M-1 && C[i+1][j][k] != -1.0{
                                          change=(C[i][j][k]-C[i+1][j][k])*dC
                                          C[i][j][k]=C[i][j][k]-change
                                          C[i+1][j][k]=C[i+1][j][k]+change
                                    }
                                    if j != M-1 && C[i][j+1][k] != -1.0{
                                          change=(C[i][j][k]-C[i][j+1][k])*dC
                                          C[i][j][k]=C[i][j][k]-change
                                          C[i][j+1][k]=C[i][j+1][k]+change
                                    }
                                    if k != M-1 && C[i][j][k+1] != -1.0{
                                          change=(C[i][j][k]-C[i][j][k+1])*dC
                                          C[i][j][k]=C[i][j][k]-change
                                          C[i][j][k+1]=C[i][j][k+1]+change
                                    }
                              }
                        }
                  }
            }
            tacc = tacc + tstep
            //Checks that mass stays the same
            var sumval float64 = 0.0
            var maxval float64 = C[0][0][0]
            var minval float64 = C[0][0][0]
            for i := 0; i < M; i++{
                  for j := 0; j < M; j++{
                        for k := 0; k < M; k++{
                              if C[i][j][k] != -1.0{
                                    maxval = math.Max(C[i][j][k], maxval)  //Finds whichever is greater
                                    minval = math.Min(C[i][j][k], minval)  //Finds whichever is smaller
                                    sumval += C[i][j][k]
                              }
                        }
                  }
            }
            ratio = minval / maxval
            //fmt.Println(tacc, " ", ratio, " ", C[0][0][0])
            //fmt.Println(C[M-1][M-1][M-1])
            //fmt.Println(sumval)
      }
      //Sets wall equal to time since the start
      cpu := time.Since(start)
      fmt.Println("Box diffused in ", tacc, " seconds.")
      fmt.Println("CPU time = ", cpu)
}
