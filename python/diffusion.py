#!/usr/bin/python
#This program will diffuse an entrie room based on its size and M
import math

M=3
room=5.0
urms=250.0
diff=0.175
tacc=0.0
tstep=(float)((room/urms)/M)
height=(float)(room/M)
dC=(float)((diff*tstep)/(height*height))
ratio=0.0
C = [[[0.0 for k in range(M)] for j in range(M)] for i in range(M)]  #Makes a 3D array based on M dimensions
C[0][0][0]=1.0*math.pow(10,21)  #Sets the first element to 1.0e21
#Loop that will go through entire array and diffuse each cube
while (ratio <= 0.99):
      for i in range(0,M):
            for j in range(0,M):
                  for k in range(0,M):
                        for l in range(0,M):
                              for m in range(0,M):
                                    for n in range(0,M):
                                          if i==l and j==m and k==n+1 or i==l and j==m and k==n-1 or\
                                             i==l and j==m+1 and k==n or i==l and j==m-1 and k==n or\
                                             i==l+1 and j==m and k==n or i==l-1 and j==m and k==n:
                                                change=(C[i][j][k]-C[l][m][n])*dC
                                                C[i][j][k]=C[i][j][k]-change
                                                C[l][m][n]=C[l][m][n]+change
      tacc=tacc+tstep
      #Checks if mass stays consistent
      sumval=0.0
      minval=C[0][0][0]
      maxval=C[0][0][0]
      for i in range(0,M):
            for j in range(0,M):
                  for k in range(0,M):
                        maxval=max(C[i][j][k],maxval)
                        minval=min(C[i][j][k],minval)
                        sumval+=C[i][j][k]
      ratio=minval/maxval
      print tacc, " ", ratio, " ", C[0][0][0]
      print C[M-1][M-1][M-1]
      print sumval
print "Box diffused in ", tacc, " seconds"
