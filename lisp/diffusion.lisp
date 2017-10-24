#!/usr/bin/sbcl --script
(defvar C)
(defvar M 10)
;Makes a 3D array
(setf C (make-array '(M M M)))
;;;Variable declarations
(defvar diff 0.175)
(defvar rooms 5.0)
(defvar urms 250.0)
(defvar tstep (/ rooms urms M))
(defvar height (/ rooms M))
(defvar dC (/ (* diff tstep) (* height height)))
(defvar tacc 0.0)
(defvar cube_ratio 0.0)
(setf (aref C 0 0 0)(expt 1 21)) ;Makes first element in cube 1e21
(print "Beginning Box simulation...")
;Loop that checks when min and max value are equal
(loop while (<= cube_ratio  0.99) do
      (dotimes (i M)
            (dotimes (j M)
                  (dotimes (k M)
                        (dotimes (l M)
                              (dotimes (m M)
                                    (dotimes (n M)
                                          (if (and (= i l)(= j m)(= k + n 1))or (and (= i l)(= j m)(= k - n 1))/
                                           or (and (= i l)(= j + m 1)(= k n))or (and (= i l)(= j - m 1)(= k n))/
                                           or (and (= i + l 1)(= j m)(= k n))or (and (= i - l 1)(= j m)(= k n))
                                                (defvar change (* - (aref C i j k)(aref C l m n) dC))
                                                (setf (aref C i j k)(+ (aref C i j k) change))
                                                (setf (aref C l m n)(- (aref C l m n) change))
                                          )
                                    )
                              )
                        )
                  )
            )
      )
      (setf tacc(+ tacc tstep))
      ;;;Checks for mass consistency
      (defvar sumval 0.0)
      (defvar minval (aref C 0 0 0))
      (defvar maxval (aref C 0 0 0))
      (dotimes (i M)
            (dotimes (j M)
                  (dotimes (k M)
                        (setf maxval
                        (setf minval
                        (setf sumval(+ sumval (aref C i j k)))
                  )
            )
      )
      (setf cube_ratio(/ minval maxval)
      ;;;Prints different values
      (print tacc " " cube_ratio " " (aref C 0 0 0))
      (print (aref C - M 1 - M 1 - M 1))
      (print sumval)
)
(print "Box diffused in " tacc " seconds")
