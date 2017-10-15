#Program that will create and diffuse a room with given substance and return the time it takes
#!/usr/bin/python
M=10
room=5
urms=250
diff=0.175
tacc=0
tstep=(room/urms)/M
height=room/M
h2=height*height
dC=(diff*tstep)/h2
ratio=0.0
C = [[[0.0 for k in range(M)]for j in range(M)]for i in range(M)]  #Makes a 3D array based on M dimensions

#Loop to set every array element to 0
#for i in range(0,M):
#      for j in range(0,M):
#            for k in range(0,M):
#                  C[i][j][k] = 0.0
C[0][0][0]=1.0*math.pow(10,21)
#Loop that will go through entire array and diffuse each cube
while (ratio <= 0.99):
      print "Entering while"
      for i in range(0,M):
            for j in range(0,M):
                  for k in range(0,M):
                        for l in range(0,M):
                              for m in range(0,M):
                                    for n in range(0,M):
                                          if i==l and j==m and k==n+1 or i==l and j==m and k==n-1 or \
                                             i==l and j==m+1 and k==n or i==l and j==m-1 and k==n or \
                                             i==l+1 and j==m and k==n or i==l-1 and j==m and k==n:
                                                change=(C[i][j][k]-C[l][m][n])*dC
                                                C[i][j][k]=C[i][j][k]-change
                                                C[l][m][n]=C[l][m][n]+change
      tacc=tacc+tstep
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
