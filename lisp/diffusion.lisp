#!/usr/bin/sbcl --script
;Lisp checked for mass consistency on 11/4/17
(defvar C)
(write-line "What is the size of the box?")
(defvar M)
(setf M (read))
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
(setf (aref C 0 0 0) (* 1(expt 10 21))) ;Makes first element in cube 1e21
(defvar minval (aref C 0 0 0))
(defvar maxval (aref C 0 0 0))
(write-line "Beginning Box simulation...")
;(print (aref C 0 0 0))
;(print minval)
;(print dC)
;(print diff)
;(print tstep)
;(print height)
;Loop that checks when min and max value are equal

(loop while (<= cuberatio  0.99)  do
      (dotimes (i M)
            (dotimes (j M)
                  (dotimes (k M)
                        (if (/= i 0)
                        (progn
                              (setf change (* dC(- (aref C i j k)(aref C (- i 1) j k))))
                              (setf (aref C i j k)(- (aref C i j k)change))
                              (setf (aref C (- i 1) j k)(+ (aref C (- i 1) j k)change))
                        )
                        )
                        (if (/= j 0)
                        (progn
                              (setf change (* dC(- (aref C i j k)(aref C i (- j 1) k))))
                              (setf (aref C i j k)(- (aref C i j k)change))
                              (setf (aref C i (- j 1) k)(+ (aref C i (- j 1) k)change))
                        )
                        )
                        (if (/= k 0)
                        (progn
                              (setf change (* dC(- (aref C i j k)(aref C i j (- k 1)))))
                              (setf (aref C i j k)(- (aref C i j k)change))
                              (setf (aref C i j (- k 1))(+ (aref C i j (- k 1))change))
                        )
                        )
                        (if (/= i (- M 1))
                        (progn
                              (setf change (* dC(- (aref C i j k)(aref C (+ i 1) j k))))
                              (setf (aref C i j k)(- (aref C i j k)change))
                              (setf (aref C (+ i 1) j k)(+ (aref C (+ i 1) j k)change))
                        )
                        )
                        (if (/= j (- M 1))
                        (progn
                              (setf change (* dC(- (aref C i j k)(aref C i (+ j 1) k))))
                              (setf (aref C i j k)(- (aref C i j k)change))
                              (setf (aref C i (+ j 1) k)(+ (aref C i (+ j 1) k)change))
                        )
                        )
                        (if (/= k (- M 1))
                        (progn
                              (setf change (* dC(- (aref C i j k)(aref C i j (+ k 1)))))
                              (setf (aref C i j k)(- (aref C i j k)change))
                              (setf (aref C i j (+ k 1))(+ (aref C i j (+ k 1))change))
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
                        (setf maxval (max maxval (aref C i j k)))  ;Determines which is largest of the 2
                        (setf minval (min minval (aref C i j k)))  ;Determines which is smallest of the 2
                        (setf sumval (+ sumval (aref C i j k)))
                        ;(print minval)
                        ;(print maxval)
                  )
            )
      )
      (setf cuberatio (/ minval maxval) )
      ;;;Prints different values
      (format t "Time: ~,2d  Ratio: ~,2d  index: ~,2d ~%" tacc cuberatio (aref C 0 0 0)) 
      ;(print (aref C (- M 1)(- M 1)(- M 1)))
      (format t "Sum: ~,2d ~%" sumval)

)
(format t "Box diffused in ~,,2d seconds. ~%" tacc)
