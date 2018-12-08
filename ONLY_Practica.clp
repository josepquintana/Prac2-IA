
(defmodule MAIN (export ?ALL))
(defmodule ASK_QUESTIONS (import MAIN ?ALL)(export ?ALL))
(defmodule PROCESS_DATA (import MAIN ?ALL)(export ?ALL))
(defmodule PRINT_WORKOUT (import MAIN ?ALL)(export ?ALL))

(defclass MAIN::Valoracion_Actividades
  (is-a USER) (role concrete)
   (slot actividad (type INSTANCE)(create-accessor read-write))
   (slot puntuacion (type INTEGER)(default 0)(create-accessor read-write))
)

(defclass MAIN::Test
  (is-a USER) (role concrete)
   ; (slot actividad (type INSTANCE)(create-accessor read-write))
   (slot slot1 (type INTEGER)(default 0)(create-accessor read-write))
)

(deftemplate MAIN::Persona
  (slot grupo_edad (type STRING)) ; OLD, VERY_OLD, SUPER_OLD, ULTRA_OLD
  (multislot dolencias (type INSTANCE))
  (slot estado_fisico (type STRING)) ; BASICO, MEJORA, MANTENIMIENTO
)

(deftemplate MAIN::Sesion
  (multislot actividades (type INSTANCE))
  (slot duracion (type INTEGER))
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
  (printout t crlf)

  (assert (nueva_persona))
  (focus ASK_QUESTIONS)
)

; Read data from user

(deffunction ASK_QUESTIONS::ask_question_basic(?question)
  ; Ask a question
  (printout t ?question " ")
  (printout t ": ")
  (bind ?answer (read))
  (return ?answer)
)

(deffunction ASK_QUESTIONS::ask_question_allowed_values (?question $?allowed-values)
 ; "Escribe una pregunta y lee uno de los valores posibles (allowed-values)"
	(printout t ?question " ")
  (printout t $?allowed-values " : ")
	(bind ?answer (read))
	(if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
	(while (not (member ?answer ?allowed-values)) do
		(printout t ?question)
		(bind ?answer (read))
		(if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
	)
  (printout t crlf)
	(return ?answer)
)

(deffunction ASK_QUESTIONS::ask_question_yes_no(?question)
 ; "Escribe una pregunta y lee uno de los valores posibles (yes no)"
 (bind ?answer (ask_question_allowed_values ?question si no s n))
 (if (or (eq ?answer si) (eq ?answer s))
  then TRUE
  else FALSE
 )
)

(deffunction ASK_QUESTIONS::ask_question_integer (?question)
 ; Escribe una pregunta y lee un entero
  (printout t ?question " ")
  (printout t "(NUMERO): ")
  (bind ?answer (read))
  (while (not (integerp ?answer)) do
    (printout t ?question)
    (printout t "(NUMERO): ")
    (bind ?answer (read))
  )
  (printout t crlf)
  (return ?answer)
)

;;; Funcion para hacer una pregunta con un conjunto definido de valores de repuesta
(deffunction ASK_QUESTIONS::ask_question_multichoice (?question $?allowed-values)
	(printout t ?question " " crlf)
  (progn$ (?var ?allowed-values)
   (printout t ?var-index ". " ?var crlf)
  )
  (printout t crlf "Indique las respuestas separadas por un espacio: ")
  (bind ?all_answers (readline))
  (bind ?answers (str-explode ?all_answers))
  (bind ?list_answers (create$ ))
  (progn$ (?var ?answers)
   (if (and (integerp ?var) (and (>= ?var 1) (<= ?var (length$ ?allowed-values))))
    then
     (if (not (member$ ?var ?list_answers))
      then (bind ?list_answers (insert$ ?list_answers (+ (length$ ?list_answers) 1) ?var))
     )
   )
  )
	(return ?list_answers)
)


(defrule ASK_QUESTIONS::initialize_Persona
  (declare (salience 25))
  (nueva_persona)
  (not (Persona))
  =>

  (printout t "aksjkajdkfjbsensdka" crlf)
)

(defrule ASK_QUESTIONS::setGrupoEdad
  (declare (salience 20))
  =>
  (bind ?edad (ask_question_integer "Cuantos anos tiene?"))
  (bind ?ga null)
  (if (>= ?edad 95) then (bind ?ga "ULTRA_OLD"))
  (if (>= ?edad 85) then (bind ?ga "SUPER_OLD"))
  (if (>= ?edad 75) then (bind ?ga "VERY_OLD"))
  (if (>= ?edad 65) then (bind ?ga "OLD"))
  (assert (Persona (grupo_edad ?ga)))
)

(defrule ASK_QUESTIONS::ask_Enfermedades
  (declare (salience 10))
  ; (Persona (grupo_edad ?ga))
  (not (test_Enfermedades))
  ?ref <- (Persona)
  ; ?refdol <- (Persona $?dolencias)
  =>
  (if (ask_question_yes_no "Padece alguna enfermedad?")
    then
     (bind ?list_answers (ask_question_multichoice "Cuales?" Artrosis Cardiovascular Obesidad Osteoporosis))
     (progn$ (?curr-answer ?list_answers)
      (switch ?curr-answer
       (case 1
        then (printout t "You chose 1" crlf))
       (case 2
        then (printout t "You chose 2" crlf))
       (case 3
        then (printout t "You chose 3" crlf))
       (case 4
        then (printout t "You chose 4" crlf))
       (case 5
        then (assert (formato Documental)))
      )
     )
   )
  (assert (test_Enfermedades))
)

(defrule ASK_QUESTIONS::ask_Incapacidades
  (declare (salience 10))
  (not (test_Incapacidades))
  ?ref <- (Persona)
  =>


  (assert (test_Incapacidades))
)

(defrule ASK_QUESTIONS::ask_Lesiones
  (declare (salience 10))
  ; (Persona (grupo_edad ?ga))
  (not (test_Lesiones))
  ?ref <- (Persona)
  =>


  (assert (test_Lesiones))
)

(defrule ASK_QUESTIONS::dataReadCorrect
  (declare (salience 1))
  =>
  (printout t crlf)
  (printout t "                  <<    Data Entered   >>")
  (printout t crlf)
  (focus PROCESS_DATA)
)


(defrule PROCESS_DATA::myrule
  (declare (salience 100))
  ?ref <- (Persona (grupo_edad ?ag))
  =>
  (printout t crlf)
  (printout t crlf)
  (printout t "####### MY TEST RULE #######" crlf)

  (bind ?var_test (make-instance i1 of Test))
  (send ?var_test put-slot1 12)
  (bind ?var_test (make-instance i2 of Test))
  (send ?var_test put-slot1 24)



  (bind $?all_test (find-all-instances ((?inst Test)) TRUE))
	(progn$ (?i ?all_test)
		(printout t (send ?i get-slot1) crlf)
	)

	(printout t "L: " (length$ $?all_test) crlf)

  ; (bind ?nom (send ?e1 get-equipo))
  ; (printout t ?nom crlf)

  (printout t crlf "####### MY TEST RULE #######")
  (printout t crlf)
  (printout t crlf)
)
; Proccess the data read from the user

(defrule PROCESS_DATA::ini_scores
 (declare (salience 99))
  =>
  (bind $?actividades (find-all-instances ((?inst Actividad)) TRUE))
	(progn$ (?act-i ?actividades)
		(make-instance (gensym) of Valoracion_Actividades (actividad ?act-i)(puntuacion 0))
	)
)


(defrule PROCESS_DATA::recopilar
 (declare (salience 10))
 =>
 (bind ?list (find-all-instances ((?inst Actividad)) TRUE))
 (loop-for-count (?i 1 (length$ ?list)) do
  (bind ?aux (nth$ ?i ?list))
  ;aquí hacemos lo que queramos
  (printout t ?i crlf)
 )
)


(defrule PROCESS_DATA::printActivity
 (declare (salience 10))
 ?inst <- (object (is-a Valoracion_Actividades))
 =>
 (printout t "Acitivdad: " (instance-name ?inst) ":" (send ?inst get-puntuacion))
)
