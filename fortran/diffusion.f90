!Program that will diffuse an entire room with the given diffusion constant
program diffusion
!Using the already made 3D array from file cube_mem

! Checked for mass consistency on 10/16/17

USE cube_mem
real(kind=8) :: cubesum
integer :: mem_stat
integer :: partition
print *, "How big is the cube?"
read *, mdim  !Equals whatever the user inputs as the blocks
call fill_cube  !Calls the fill_cube method 
!cubesum = sum(cube)
!print *, "Sum of the cube is ", cubesum

deallocate(cube, STAT=mem_stat)  !Frees up the cube
if(mem_stat/=0.0)STOP "ERROR DEALLOCATING ARRAY"

END PROGRAM diffusion

SUBROUTINE fill_cube
      USE cube_mem
      !Variable declarations
      integer :: partition, partsize
      integer :: i,j,k,l,m,n
      integer :: mem_stat
      real :: diff, room, urms, tstep, height, dC
      real :: tacc, ratio, sumval, maxc, minc, change
      real :: start, finish
      print *, "Is there a partition? (0 for no, 1 for yes)"
      read *, partition  !Sees if user wants a partition or not
      print *, "Beginning Box simulation..."
      !Starts counting the cpu time 
      call cpu_time(start)
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
      if(partition .eq. 1) then
            partsize = mdim / 2
      endif
      if(partition .ne. 1 .and. partition .ne. 0) then
            print *, "Partition will be set to 0"
            partition = 0
      end if
      if(partition .eq. 1) then
            do i = 1, mdim
                  do j = 1, mdim
                        do k = 1, mdim
                              if(i .eq. partsize .and. j .ge. partsize) then
                                    cube(i,j,k) = -1.0
                              end if
                        end do
                  end do
            end do
      end if
!Loop that goes through entire cube to diffuse adjacent blocks
do while(ratio <= 0.99)
      do i = 1, mdim
            do j = 1, mdim
                  do k = 1, mdim
                        if(cube(i,j,k) .ne. -1.0) then
                              !Checks all of the adjacent blocks from the current block
                                    if(i /= 1 .and. cube(i-1,j,k) .ne. -1.0) then
                                          change=(cube(i,j,k)-cube(i-1,j,k))*dC
                                          cube(i,j,k)=cube(i,j,k)-change
                                          cube(i-1,j,k)=cube(i-1,j,k)+change
                                    end if
                                    if(j /= 1 .and. cube(i,j-1,k) .ne. -1.0) then
                                          change=(cube(i,j,k)-cube(i,j-1,k))*dC
                                          cube(i,j,k)=cube(i,j,k)-change
                                          cube(i,j-1,k)=cube(i,j-1,k)+change
                                    end if
                                    if(k /= 1 .and. cube(i,j,k-1) .ne. -1.0) then
                                          change=(cube(i,j,k)-cube(i,j,k-1))*dC
                                          cube(i,j,k)=cube(i,j,k)-change
                                          cube(i,j,k-1)=cube(i,j,k-1)+change
                                    end if
                                    if(i /= mdim .and. cube(i+1,j,k) .ne. -1.0) then
                                          change=(cube(i,j,k)-cube(i+1,j,k))*dC
                                          cube(i,j,k)=cube(i,j,k)-change
                                          cube(i+1,j,k)=cube(i+1,j,k)+change
                                    end if
                                    if(j /= mdim .and. cube(i,j+1,k) .ne. -1.0) then
                                          change=(cube(i,j,k)-cube(i,j+1,k))*dC
                                          cube(i,j,k)=cube(i,j,k)-change
                                          cube(i,j+1,k)=cube(i,j+1,k)+change
                                    end if
                                    if(k /= mdim .and. cube(i,j,k+1) .ne. -1.0) then
                                          change=(cube(i,j,k)-cube(i,j,k+1))*dC
                                          cube(i,j,k)=cube(i,j,k)-change
                                          cube(i,j,k+1)=cube(i,j,k+1)+change
                                    end if
                        end if
                  end do
            end do
      end do
      tacc = tstep + tacc
      !Makes sure Mass stays same
      sumval = 0.0
      maxc = cube(1,1,1)
      minc = cube(1,1,1)
      do i = 1, mdim
            do j = 1, mdim
                  do k = 1, mdim
                        if(cube(i,j,k) .ne. -1.0) then
                        maxc = max(cube(i,j,k), maxc)  !Determines which is greater than out of the two
                        minc = min(cube(i,j,k), minc)  !Determines which is less than out of the two
                        sumval = sumval + cube(i,j,k)  !Automatically sums up the cube
                        end if
                  end do
            end do
      end do
      ratio = minc / maxc  !Determines if cube is finished
      !print *, tacc, " ", ratio, " ", cube(1,1,1)
      !print *, cube(mdim-1,mdim-1,mdim-1)
      !print *, sumval
end do
!Stops counting the cpu time
call cpu_time(finish)
print *, "Box finished in ", tacc, " seconds"
print *, "Sum of the cube = ", sumval
print *, "Wall time =",finish-start,"seconds."
END SUBROUTINE fill_cube
