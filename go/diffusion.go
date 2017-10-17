//This program will diffuse a room with a given substance based on room and dimension size
package main
import "fmt"
import "math"

func main(){
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
      //Loop that will go into every block and diffuse adjacent blocks
      for ratio <= 0.99{
            for i := 0; i < M; i++{
                  for j := 0; j < M; j++{
                        for k := 0; k < M; k++{
                              for l := 0; l < M; l++{
                                    for m := 0; m < M; m++{
                                          for n := 0; n < M; n++{
                                                if( ((i==l) && (j==m) && (k==n+1)) || ((i==l) && (j==m) && (k==n-1)) ||
                                                    ((i==l) && (j==m+1) && (k==n)) || ((i==l) && (j==m-1) && (k==n)) ||
                                                    ((i==l+1) && (j==m) && (k==n)) || ((i==l-1) && (j==m) && (k==n)) ){
                                                      var change float64 = (C[i][j][k] - C[l][m][n]) * dC
                                                      C[i][j][k] = C[i][j][k] - change
                                                      C[l][m][n] = C[l][m][n] + change
                                                }
                                          }
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
                              maxval = math.Max(C[i][j][k], maxval)  //Finds whichever is greater
                              minval = math.Min(C[i][j][k], minval)  //Finds whichever is smaller
                              sumval += C[i][j][k]
                        }
                  }
            }
            ratio = minval / maxval

            /*fmt.Println(tacc, " ", ratio, " ", C[0][0][0])
            fmt.Println(C[M-1][M-1][M-1])
            fmt.Println(sumval)*/
      }
      fmt.Println("Box diffused in ", tacc, " seconds.")
}
