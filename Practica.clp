
(defmodule MAIN (export ?ALL))
(defmodule ASK_QUESTIONS (import MAIN ?ALL)(export ?ALL))
(defmodule PROCESS_DATA (import MAIN ?ALL)(export ?ALL))
(defmodule PRINT_WORKOUT (import MAIN ?ALL)(export ?ALL))

(defclass MAIN::Person
  (is-a USER) (role concrete)
   (slot grupo_edad (type STRING)) ; OLD, VERY_OLD, SUPER_OLD, ULTRA_OLD
   (multislot dolencias (type INSTACE)(default 0)(create-accessor read-write))
   (slot estado_fisico (type STRING)) ; BASICO, MEJORA, MANTENIMIENTO
)

(defclass MAIN::Actividades
  (is-a USER) (role concrete)
   (slot actividad (type INSTANCE)(create-accessor read-write))
   (slot puntuacion (type INTEGER)(default 0)(create-accessor read-write))
)

(defrule MAIN::init "initial rule"
  (declare (salience 99))
  =>
  (printout t crlf)
  (printout t "################################################################")
  (printout t crlf)
  (printout t crlf)
  (format t "                  SISTEMA DE RECOMENDACION%n")
  (format t "                 DE EJERCICIOS Y ACTIVIDADES%n")
  (printout t crlf)
  (printout t "################################################################")
  (printout t crlf)

  (focus ASK_QUESTIONS)
)

; Read data from user

(deffunction ASK_QUESTIONS::ask_question_basic(?question)
  ; Ask a question
  (printout t ?question)
  (printout t ": ")
  (bind ?answer (read))
  (return ?answer)
)

(deffunction ASK_QUESTIONS::ask_question_allowed_values (?question $?allowed-values)
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

(deffunction ASK_QUESTIONS::ask_question_yes_no(?question $?allowed-values)
 ; "Escribe una pregunta y lee uno de los valores posibles (yes no)"
 (bind ?answer (ask_question_allowed_values "?question" si no ))
 (return ?answer)
)

(deffunction ASK_QUESTIONS::ask_question_integer (?question)
 ; Escribe una pregunta y lee un entero
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

(defrule ASK_QUESTIONS::setAgeGroup
  (declare (salience 20))
  (not (Person))
  =>
  (bind ?age (ask_question_integer "How old are you? "))
  (bind ?ag null)
  (if (>= ?age 95) then (bind ?ag "ULTRA_OLD"))
  (if (>= ?age 85) then (bind ?ag "SUPER_OLD"))
  (if (>= ?age 75) then (bind ?ag "VERY_OLD"))
  (if (>= ?age 65) then (bind ?ag "OLD"))
  (assert (Person (ageGroup ?ag)))
)

(defrule ASK_QUESTIONS::setDiseases
  (declare (salience 10))
  (not (test_Disease))
  ?ref <- (Person)
  =>
  (modify ?ref (cardiovascular (ask_question_allowed_values "Cardiovascular? " y n)))
  (modify ?ref (respiratory (ask_question_allowed_values "Respiratory? " y n)))
  (modify ?ref (diabetes (ask_question_allowed_values "Diabetes? " y n)))
  (modify ?ref (obesity (ask_question_allowed_values "Obesity? " y n)))
  (assert (test_Disease))
)

(defrule ASK_QUESTIONS::dataReadCorrect
  (declare (salience 1))
  =>
  (printout t crlf)
  (printout t "                  <<    Data Entered   >>")
  (printout t crlf)
  (focus PROCESS_DATA)
)

; Proccess the data read from the user
;
; (defrule PROCESS_DATA::ini_scores
;  (declare (salience 99))
;   =>
;   (bind $?exercises (find-all-instances ((?inst Exercise)) TRUE))
; 	(progn$ (?ex-i ?exercises)
; 		(make-instance (gensym) of Exercises (exercise ?ex-i)(assessment 0))
; 	)
; )
