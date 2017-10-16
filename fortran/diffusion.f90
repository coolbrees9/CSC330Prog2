!Program that will diffuse an entire room with the given diffusion constant
program diffusion
!Using the already made 3D array from file cube_mem

! Checked for mass consistency on 10/16/17

USE cube_mem
real(kind=8) :: cubesum
integer :: mem_stat

print *, "How big is the cube?"
read *, mdim  !Equals whatever the user inputs as the blocks

call fill_cube  !Calls the fill_cube method 
cubesum = sum(cube)
print *, "Sum of the cube is ", cubesum

deallocate(cube, STAT=mem_stat)  !Frees up the cube
if(mem_stat/=0.0)STOP "ERROR DEALLOCATING ARRAY"

END PROGRAM diffusion

SUBROUTINE fill_cube
      USE cube_mem
      !Variable declarations
      integer :: i,j,k,l,m,n
      integer :: mem_stat
      real :: diff, room, urms, tstep, height, dC
      real :: tacc, ratio, sumval, maxc, minc, change
      diff = 0.175
      room = 5.0
      urms = 250.0
      tstep = (room / urms) / mdim
      height = room / mdim
      dC = diff * tstep / (height * height)
      tacc = 0.0
      ratio = 0.0
      allocate(cube(mdim,mdim,mdim), STAT=mem_stat)
      cube(1,1,1) = 1.0 * 10.0**21.0
      if(mem_stat/=0)STOP "MEMORY ALLOCATION ERROR"
!Loop that goes through entire cube to diffuse adjacent blocks
do while(ratio <= 0.99)
      loop1: do i = 1, mdim
            loop2: do j = 1, mdim
                  loop3:do k = 1, mdim
                        loop4:do l = 1, mdim
                              loop5: do m = 1, mdim
                                    loop6: do n = 1, mdim
                                          if (  ((i==l).and.(j==m).and.(k==n+1)).or.((i==l).and.(j==m).and.(k==n-1))&
                                                &.or.((i==l).and.(j==m+1).and.(k==n)).or.((i==l).and.(j==m-1).and.(k==n))&
                                                &.or.((i==l+1).and.(j==m).and.(k==n)).or.((i==l-1).and.(j==m).and.(k==n))) then
                                                change = (cube(i,j,k) - cube(l,m,n)) * dC
                                                cube(i,j,k) = cube(i,j,k) - change
                                                cube(l,m,n) = cube(l,m,n) + change
                                          end if
                                    end do loop6
                              end do loop5
                        end do loop4
                  end do loop3
            end do loop2
      end do loop1
      tacc = tstep + tacc
      !Makes sure Mass stays same
      sumval = 0.0
      maxc = cube(1,1,1)
      minc = cube(1,1,1)
      loop7: do i = 1, mdim
            loop8: do j = 1, mdim
                  loop9: do k = 1, mdim
                        maxc = max(cube(i,j,k), maxc)  !Determines which is greater than out of the two
                        minc = min(cube(i,j,k), minc)  !Determines which is less than out of the two
                        sumval = sumval + cube(i,j,k)!sum(cube)  !Automatically sums up the cube
                  end do loop9
            end do loop8
      end do loop7
      ratio = minc / maxc  !Determines if cube is finished
      !print *, tacc, " ", ratio, " ", cube(1,1,1)
      !print *, cube(mdim-1,mdim-1,mdim-1)
      !print *, sumval
end do
print *, "Box finished in ", tacc, " seconds"
END SUBROUTINE fill_cube
