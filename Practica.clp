
(defmodule MAIN (export ?ALL))
(defmodule READ_DATA (import MAIN ?ALL)(export ?ALL))
(defmodule PROCESS_DATA (import MAIN ?ALL)(export ?ALL))
(defmodule PRINT_SOL (import MAIN ?ALL)(export ?ALL))

(deftemplate MAIN::Person
  ; input person characteristics
  (slot ageGroup (type STRING)) ; OLD, VERY_OLD, SUPER_OLD, ULTRA_OLD
  (slot cardiovascular (type STRING)(default "n"))
  (slot respiratory (type STRING)(default "n"))
  (slot diabetes (type STRING)(default "n"))
  (slot obesity (type STRING)(default "n"))
  (slot osteoporosis (type STRING)(default "n"))
  (slot colesterol (type STRING)(default "n"))
  (slot muscular (type STRING)(default "n"))
  (slot fall (type STRING)(default "n"))
  (slot reduced_mobility(type STRING)(default "n"))

)

(defrule MAIN::init
  (declare (salience 99))
  =>
  (printout t crlf)
  (printout t "###############################################################")
  (printout t crlf)
  (format t "                       OLD PEOPLE%n")
  (printout t crlf)
  (printout t "###############################################################")
  (printout t crlf)

  (focus READ_DATA)
)

(deffunction READ_DATA::ask_question_allowed_values (?question $?allowed-values)
; "Escribe una pregunta y lee uno de los valores posibles (allowed-values)"
	(printout t ?question)
    (printout t $?allowed-values " : ")
	(bind ?answer (read))
	(if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
	(while (not (member$ ?answer ?allowed-values)) do
		(printout t ?question)
		(bind ?answer (read))
		(if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
	)
    (printout t crlf)
	(return ?answer)
)

(deffunction RECOPILAR_INFO::ask_question_integer (?question)
; "Escribe una pregunta y lee un entero"
  (printout t ?question)
  (printout t "(NUMBER): ")
  (bind ?answer (read))
  (while (not (integerp ?answer)) do
    (printout t ?question)
    (printout t "(NUMBER): ")
    (bind ?answer (read))
  )
  (printout t crlf)
  (return ?answer)
)

; Questions to collect data from the user

(defrule READ_DATA::setAgeGroup
  (declare (salience 10))
  ?ref <- (Person)
  (not (test_ageGroup))
  =>
  (bind ?age (ask_question_integer "How old are you? "))
  (if (>= ?age 95) then (modify ?ref (ageGroup "ULTRA_OLD")))
  (if (>= ?age 85) then (modify ?ref (ageGroup "SUPER_OLD")))
  (if (>= ?age 75) then (modify ?ref (ageGroup "VERY_OLD")))
  (if (>= ?age 65) then (modify ?ref (ageGroup "OLD")))
  (assert (test_ageGroup))
)

(defrule READ_DATA::setDiseases
  (declare (salience 10))
  ?ref <- (Person)
  (not (test_Disease))
  =>
  (modify ?ref (cardiovascular (ask_question_allowed_values "Cardiovascular? " y n)))
  (modify ?ref (respiratory (ask_question_allowed_values "Respiratory? " y n)))
  (modify ?ref (diabetes (ask_question_allowed_values "Diabetes? " y n)))
  (modify ?ref (obesity (ask_question_allowed_values "Obesityr? " y n)))
  (assert (test_Disease))
)

(defrule RECOPILAR_INFO::dataReadCorret
    (declare (salience 1))
    =>
    (focus PROCESS_DATA)
    (printout t crlf)
    (format t "##########################################################################%n%n")
    (format t "     Data Read ...   %n%n")
    (format t "##########################################################################%n%n")
)

; Proccess the data read from the user
