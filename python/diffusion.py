#!/usr/bin/python

M = 10
room = 5
urms = 250
diff = 0.175
tacc = 0
tstep = (room / urms) / M
height = room / M

C = [[[0.0 for k in range(M)] for j in range(M)] for i in range(M)]

for i in range(0, M):
      for j in range(0, M):
            for k in range(0, M):
                  C[i][j][k] = i*M*M + j*M + k + 1
                  C[i][j][k] = C[i][j][k] * 3.1415926535897

print "Last element is ", C[M-1][M-1][M-1]
