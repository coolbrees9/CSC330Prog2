#!/usr/bin/python
#This program will diffuse an entrie room based on its size and M
import math
import sys

# Python checked for consistency.  Code will run much faster if you can reduce the six inner loops down to three.

#User will input the size of the cube
M = int(input("What is the size of the  box "))
if M <= 0:
      print "%s is an invalid number" % M
      sys.exit()
#Checks if user wants a partition
partition = int(input("Is there a partition? (0 for no, 1 for yes)"))
if partition != 1 or partition != 0:
      print "Partition will be set to 0"
partsize = math.floor(M / 2)
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
print "Beginning box simulation..."
if partition == 1:
      for i in range(0, M):
            for j in range(0, M):
                  for k in range(0, M):
                        if (i == partsize-1) and (j >= partsize-1): 
                              C[i][j][k] = -1.0
#Loop that will go through entire array and diffuse each cube
while (ratio <= 0.99):
      for i in range(0, M):
            for j in range(0, M):
                  for k in range(0, M):
                        if C[i][j][k] != -1.0:
                              if(i != 0 and C[i-1][j][k] != -1.0):
                                    change=(C[i][j][k]-C[i-1][j][k])*dC
                                    C[i][j][k]=C[i][j][k]-change
                                    C[i-1][j][k]=C[i-1][j][k]+change
                              if(j != 0 and C[i][j-1][k] != -1.0):
                                    change=(C[i][j][k]-C[i][j-1][k])*dC
                                    C[i][j][k]=C[i][j][k]-change
                                    C[i][j-1][k]=C[i][j-1][k]+change
                              if(k != 0 and C[i][j][k-1] != -1.0):
                                    change=(C[i][j][k]-C[i][j][k-1])*dC
                                    C[i][j][k]=C[i][j][k]-change
                                    C[i][j][k-1]=C[i][j][k-1]+change
                              if(i != M-1 and C[i+1][j][k] != -1.0):
                                    change=(C[i][j][k]-C[i+1][j][k])*dC
                                    C[i][j][k]=C[i][j][k]-change
                                    C[i+1][j][k]=C[i+1][j][k]+change
                              if(j != M-1 and C[i][j+1][k] != -1.0):
                                    change=(C[i][j][k]-C[i][j+1][k])*dC
                                    C[i][j][k]=C[i][j][k]-change
                                    C[i][j+1][k]=C[i][j+1][k]+change
                              if(k != M-1 and C[i][j][k+1] != -1.0):
                                    change=(C[i][j][k]-C[i][j][k+1])*dC
                                    C[i][j][k]=C[i][j][k]-change
                                    C[i][j][k+1]=C[i][j][k+1]+change
      tacc=tacc+tstep
      #Checks if mass stays consistent
      sumval=0.0
      minval=C[0][0][0]
      maxval=C[0][0][0]
      for i in range(0,M):
            for j in range(0,M):
                  for k in range(0,M):
                        if C[i][j][k] != -1.0:
                              maxval=max(C[i][j][k],maxval)  #Checks which of the 2 is gretater
                              minval=min(C[i][j][k],minval)  #Checks which of the 2 is smaller
                              sumval+=C[i][j][k]
      ratio=minval/maxval
      print tacc, " ", ratio, " ", C[0][0][0]
      #print C[M-1][M-1][M-1]
      print sumval, ratio
print "Box diffused in ", tacc, " seconds"
