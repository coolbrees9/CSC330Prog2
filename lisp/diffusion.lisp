#!/usr/bin/sbcl --script
;Lisp checked for mass consistency on 11/4/17
(defvar C)
;Sets the box size to user input
(write-line "What is the size of the box?")
(defvar M)
(setf M (read))
;Asks and sets partition based on user input
(write-line "Is there a partition? (0 for no, 1 for yes)")
(defvar partition)
(setf partition (read))
;Checks if user inputted either 1 or 0 for partition
(if (and (/= partition 0)(/= partition 1))
      (progn
            (write-line "Partition will be set to 0")
            (setf partition 0)
      )
)
;Makes a 3D array
(setf C (make-array (list M M M)))
;;;Variable declarations
(defvar change)
(defvar sumval)
(defvar diff 0.175)
(defvar rooms 5.0)
(defvar urms 250.0)
(defvar tstep (/ rooms urms M))
(defvar height (/ rooms M))
(defvar dC (/ (* diff tstep) (* height height) ) )
(defvar tacc 0.0)
(defvar cuberatio 0.0)
(defvar partsize (/ M 2))
(setf (aref C 0 0 0) (* 1(expt 10 21))) ;Makes first element in cube 1e21
(defvar minval (aref C 0 0 0))
(defvar maxval (aref C 0 0 0))
(if (eq partition 1)
      (progn
            (dotimes (i M)
                  (dotimes (j M)
                        (dotimes (k M)
                              (if (and (eq i (- partsize 1))(>= j (- partsize 1)))
                                    (setf (aref C i j k) -1.0)
                              )
                        )
                  )
            )
      )
)
(write-line "Beginning Box simulation...")
;(print minval)
;(print dC)
;(print diff)
;(print tstep)
;(print height)
(let ((cpu1 (get-internal-real-time))  ;Sets current cpu and run time 
      (run1 (get-internal-run-time)))
;Loop that checks when min and max value are equal
(loop while (<= cuberatio  0.99)  do
      (dotimes (i M)
            (dotimes (j M)
                  (dotimes (k M)
                        (if (/= (aref C i j k) -1.0)
                        (progn
                              (if (and (/= i 0) (/= (aref C (- i 1) j k) -1.0))
                              (progn
                                    (setf change (* dC(- (aref C i j k)(aref C (- i 1) j k))))
                                    (setf (aref C i j k)(- (aref C i j k)change))
                                    (setf (aref C (- i 1) j k)(+ (aref C (- i 1) j k)change))
                              )
                              )
                              (if (and (/= j 0) (/= (aref C i (- j 1) k) -1.0))
                              (progn
                                    (setf change (* dC(- (aref C i j k)(aref C i (- j 1) k))))
                                    (setf (aref C i j k)(- (aref C i j k)change))
                                    (setf (aref C i (- j 1) k)(+ (aref C i (- j 1) k)change))
                              )
                              )
                              (if (and (/= k 0)(/= (aref C i j (- k 1)) -1.0))
                              (progn
                                    (setf change (* dC(- (aref C i j k)(aref C i j (- k 1)))))
                                    (setf (aref C i j k)(- (aref C i j k)change))
                                    (setf (aref C i j (- k 1))(+ (aref C i j (- k 1))change))
                              )
                              )
                              (if (and (/= i (- M 1))(/= (aref C (+ i 1) j k) -1.0))
                              (progn
                                    (setf change (* dC(- (aref C i j k)(aref C (+ i 1) j k))))
                                    (setf (aref C i j k)(- (aref C i j k)change))
                                    (setf (aref C (+ i 1) j k)(+ (aref C (+ i 1) j k)change))
                              )
                              )
                              (if (and (/= j (- M 1))(/= (aref C i (+ j 1) k) -1.0))
                              (progn
                                    (setf change (* dC(- (aref C i j k)(aref C i (+ j 1) k))))
                                    (setf (aref C i j k)(- (aref C i j k)change))
                                    (setf (aref C i (+ j 1) k)(+ (aref C i (+ j 1) k)change))
                              )
                              )
                              (if (and (/= k (- M 1))(/= (aref C i j (+ k 1)) -1.0))
                              (progn
                                    (setf change (* dC(- (aref C i j k)(aref C i j (+ k 1)))))
                                    (setf (aref C i j k)(- (aref C i j k)change))
                                    (setf (aref C i j (+ k 1))(+ (aref C i j (+ k 1))change))
                              )
                              )
                        )
                        )
                  )
            )
      )
      (setf tacc(+ tacc tstep))
      ;(print tacc)
      ;;;Checks for mass consistency
      (setf sumval 0.0)
      (setf minval (aref C 0 0 0) )
      (setf maxval (aref C 0 0 0) )
      (dotimes (i M)
           (dotimes (j M)
                  (dotimes (k M)
                        (if (/= (aref C i j k) -1.0)
                        (progn
                              (setf maxval (max maxval (aref C i j k)))  ;Determines which is largest of the 2
                              (setf minval (min minval (aref C i j k)))  ;Determines which is smallest of the 2
                              (setf sumval (+ sumval (aref C i j k)))
                        )
                        )
                  )
            )
      )
      (setf cuberatio (/ minval maxval) )
      ;;;Prints different values
      ;(format t "Time: ~,2d  Ratio: ~,2d  index: ~,2d ~%" tacc cuberatio (aref C 0 0 0)) 
      ;(print (aref C (- M 1)(- M 1)(- M 1)))
      ;(format t "Sum: ~,2d ~%" sumval)

)
(let ((run2 (get-internal-run-time))
      (cpu2 (get-internal-real-time)))  ;Gets current cpu time and run time
(format t "Box diffused in ~,,2d seconds. ~%" tacc)
(format t "CPU time =  ~f ~%" (/ (- cpu2 cpu1) internal-time-units-per-second))  ;Prints cpu time 
(format t "Run time = ~f ~%" (/ (- run2 run1) internal-time-units-per-second)))) ;Prints run time
