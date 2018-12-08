
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; INI_CLASSES (.PONT) ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Sat Dec 08 18:22:38 CET 2018
;
;+ (version "3.5")
;+ (build "Build 663")


(defclass %3ACLIPS_TOP_LEVEL_SLOT_CLASS "Fake class to save top-level slot information"
	(is-a USER)
	(role abstract)
	(single-slot inte
		(type STRING)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(multislot recomendado
		(type INSTANCE)
;+		(allowed-classes Objetivo)
		(cardinality 1 ?VARIABLE)
;+		(inverse-slot indicado)
		(create-accessor read-write))
	(multislot no_recomendado
		(type INSTANCE)
;+		(allowed-classes Objetivo)
		(cardinality 1 ?VARIABLE)
;+		(inverse-slot contra_indicado)
		(create-accessor read-write))
	(single-slot objetivo
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot orientado_a
		(type INSTANCE)
;+		(allowed-classes Objetivo)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot material
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot intensidad_recomendada
		(type SYMBOL)
		(allowed-values baja media alta)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot equipo
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot duracion
;+		(comment "[min]")
		(type INTEGER)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot contra_indicado
		(type INSTANCE)
;+		(allowed-classes Dolencia)
		(cardinality 1 ?VARIABLE)
;+		(inverse-slot no_recomendado)
		(create-accessor read-write))
	(multislot indicado
		(type INSTANCE)
;+		(allowed-classes Dolencia)
		(cardinality 1 ?VARIABLE)
;+		(inverse-slot recomendado)
		(create-accessor read-write))
	(single-slot actividad
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot parte_cuerpo
		(type SYMBOL)
		(allowed-values pierna brazo espalda cadera torso)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot dolencia
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot rehabilitacion
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot intensidad
		(type SYMBOL)
		(allowed-values baja media alta)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Actividad
	(is-a USER)
	(role concrete)
	(single-slot duracion
;+		(comment "[min]")
		(type INTEGER)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot actividad
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot parte_cuerpo
		(type SYMBOL)
		(allowed-values pierna brazo espalda cadera torso)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(multislot orientado_a
		(type INSTANCE)
;+		(allowed-classes Objetivo)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write)))

(defclass Calentamiento
	(is-a Actividad)
	(role concrete))

(defclass Ejercicio
	(is-a Actividad)
	(role concrete)
	(single-slot material
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Deporte
	(is-a Actividad)
	(role concrete)
	(single-slot equipo
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Objetivo
	(is-a USER)
	(role concrete)
	(single-slot intensidad
		(type SYMBOL)
		(allowed-values baja media alta)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot objetivo
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot contra_indicado
		(type INSTANCE)
;+		(allowed-classes Dolencia)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(multislot indicado
		(type INSTANCE)
;+		(allowed-classes Dolencia)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write)))

(defclass Dolencia
	(is-a USER)
	(role concrete)
	(single-slot dolencia
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Enfermedad
	(is-a Dolencia)
	(role concrete)
	(multislot recomendado
		(type INSTANCE)
;+		(allowed-classes Objetivo)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(multislot no_recomendado
		(type INSTANCE)
;+		(allowed-classes Objetivo)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write)))

(defclass Lesion
	(is-a Dolencia)
	(role concrete)
	(multislot parte_cuerpo
		(type SYMBOL)
		(allowed-values pierna brazo espalda cadera torso)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot rehabilitacion
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Incapacidad
	(is-a Dolencia)
	(role concrete))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; END_CLASSES (.PONT) ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; INI_INSTANCES (.PINS) ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Sat Dec 08 18:22:38 CET 2018
;
;+ (version "3.5")
;+ (build "Build 663")

(definstances instances


([Practica_Class17] of  Enfermedad

	(dolencia "Cardiovascular")
	(no_recomendado [Practica_Class28])
	(recomendado [Practica_Class23]))

([Practica_Class18] of  Objetivo

	(indicado [Practica_Class50])
	(intensidad baja)
	(objetivo "Fuerza"))

([Practica_Class20] of  Objetivo

	(indicado
		[Practica_Class41]
		[Practica_Class42]
		[Practica_Class50])
	(intensidad baja)
	(objetivo "Flexibilidad"))

([Practica_Class21] of  Objetivo

	(indicado
		[Practica_Class41]
		[Practica_Class42])
	(intensidad baja)
	(objetivo "Resistencia"))

([Practica_Class22] of  Objetivo

	(intensidad baja)
	(objetivo "Equilibrio"))

([Practica_Class23] of  Objetivo

	(indicado
		[Practica_Class17]
		[Practica_Class41]
		[Practica_Class42]
		[Practica_Class50])
	(intensidad baja)
	(objetivo "Cardio"))

([Practica_Class27] of  Objetivo

	(contra_indicado [Practica_Class41])
	(intensidad media)
	(objetivo "Cardio"))

([Practica_Class28] of  Objetivo

	(contra_indicado
		[Practica_Class17]
		[Practica_Class41]
		[Practica_Class42])
	(indicado [Practica_Class41])
	(intensidad alta)
	(objetivo "Cardio"))

([Practica_Class29] of  Objetivo

	(intensidad media)
	(objetivo "Equilibrio"))

([Practica_Class30] of  Objetivo

	(contra_indicado [Practica_Class42])
	(intensidad alta)
	(objetivo "Equilibrio"))

([Practica_Class31] of  Objetivo

	(contra_indicado [Practica_Class41])
	(intensidad media)
	(objetivo "Flexibilidad"))

([Practica_Class32] of  Objetivo

	(contra_indicado
		[Practica_Class41]
		[Practica_Class50])
	(intensidad alta)
	(objetivo "Flexibilidad"))

([Practica_Class33] of  Objetivo

	(contra_indicado [Practica_Class42])
	(indicado [Practica_Class41])
	(intensidad media)
	(objetivo "Fuerza"))

([Practica_Class34] of  Objetivo

	(contra_indicado
		[Practica_Class42]
		[Practica_Class50])
	(intensidad alta)
	(objetivo "Fuerza"))

([Practica_Class35] of  Objetivo

	(intensidad media)
	(objetivo "Resistencia"))

([Practica_Class36] of  Objetivo

	(intensidad alta)
	(objetivo "Resistencia"))

([Practica_Class37] of  Objetivo

	(intensidad media)
	(objetivo "Salud Mental"))

([Practica_Class41] of  Enfermedad

	(dolencia "Obesidad")
	(no_recomendado
		[Practica_Class28]
		[Practica_Class27]
		[Practica_Class32]
		[Practica_Class31])
	(recomendado
		[Practica_Class23]
		[Practica_Class20]
		[Practica_Class21]
		[Practica_Class28]
		[Practica_Class33]))

([Practica_Class42] of  Enfermedad

	(dolencia "Osteoporosis")
	(no_recomendado
		[Practica_Class28]
		[Practica_Class30]
		[Practica_Class34]
		[Practica_Class33])
	(recomendado
		[Practica_Class23]
		[Practica_Class20]
		[Practica_Class21]))

([Practica_Class43] of  Lesion

	(dolencia "Rotura")
	(parte_cuerpo brazo)
	(rehabilitacion FALSE))

([Practica_Class44] of  Lesion

	(dolencia "Rotura")
	(parte_cuerpo pierna)
	(rehabilitacion FALSE))

([Practica_Class45] of  Lesion

	(dolencia "Rotura")
	(parte_cuerpo cadera)
	(rehabilitacion FALSE))

([Practica_Class46] of  Lesion

	(dolencia "Esguince")
	(parte_cuerpo pierna)
	(rehabilitacion TRUE))

([Practica_Class47] of  Incapacidad

	(dolencia "Paraplegia"))

([Practica_Class50] of  Enfermedad

	(dolencia "Artrosis")
	(no_recomendado
		[Practica_Class32]
		[Practica_Class34])
	(recomendado
		[Practica_Class23]
		[Practica_Class20]
		[Practica_Class18]))

([Practica_Class53] of  Deporte

	(actividad "Baloncesto")
	(duracion 60)
	(equipo TRUE)
	(orientado_a
		[Practica_Class28]
		[Practica_Class31]
		[Practica_Class18]
		[Practica_Class36])
	(parte_cuerpo brazo pierna espalda cadera))

([Practica_Class54] of  Calentamiento

	(actividad "EstiramientoBrazos")
	(duracion 10)
	(orientado_a
		[Practica_Class32]
		[Practica_Class20]
		[Practica_Class31])
	(parte_cuerpo brazo))

([Practica_Class55] of  Calentamiento

	(actividad "EstiramientosPiernas")
	(duracion 10)
	(orientado_a
		[Practica_Class32]
		[Practica_Class20]
		[Practica_Class31])
	(parte_cuerpo pierna))

([Practica_Class56] of  Ejercicio

	(actividad "Flexiones")
	(duracion 10)
	(material FALSE)
	(orientado_a
		[Practica_Class33]
		[Practica_Class36])
	(parte_cuerpo brazo torso))

([Practica_Class57] of  Ejercicio

	(actividad "PressDeBanca")
	(duracion 15)
	(material TRUE)
	(orientado_a [Practica_Class34])
	(parte_cuerpo torso brazo))

([Practica_Class58] of  Ejercicio

	(actividad "PressDeBanca")
	(duracion 15)
	(material FALSE)
	(orientado_a [Practica_Class36])
	(parte_cuerpo torso))

([Practica_Class59] of  Objetivo
)


)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; END_INSTANCES (.PINS) ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; INI_RULES (.CLP) ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

(deffunction ASK_QUESTIONS::ask_question_integer (?question ?min_value)
 ; Escribe una pregunta y lee un entero (el 2nd parametro es el valor minimo de la respuesta)
  (printout t ?question " ")
  (printout t "(NUMERO): ")
  (bind ?answer (read))
  (while (or (not (integerp ?answer)) (< ?answer ?min_value)) do
    (printout t ?question " ")
    (printout t "(NUMERO) [min " ?min_value "]: ")
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

(defrule ASK_QUESTIONS::setGrupoEdad
  (declare (salience 20))
	(nueva_persona)
	(not (ask_GrupoEdad))
  =>
  (bind ?edad (ask_question_integer "Cuantos anos tiene?" 65))
  (bind ?ge null)

	(if (and (>= ?edad 65) (< ?edad 75)) then (bind ?ge "OLD"))
	(if (and (>= ?edad 75) (< ?edad 85)) then (bind ?ge "VERY_OLD"))
  (if (and (>= ?edad 85) (< ?edad 95)) then (bind ?ge "SUPER_OLD"))
	(if (>= ?edad 95) 									 then (bind ?ge "ULTRA_OLD"))
	;comprobar edades incorrectas
  (assert (Persona (grupo_edad ?ge) (dolencias (create$ ))))
	(assert (ask_GrupoEdad))
)

(defrule ASK_QUESTIONS::ask_Enfermedades
  (declare (salience 10))
  (not (ask_Enfermedades))
  ?ref <- (Persona (grupo_edad ?ge) (dolencias $?dolencias))
  =>
  (if (ask_question_yes_no "Padece alguna enfermedad?")
   then
    (bind ?list_answers (ask_question_multichoice "Cuales?" Artrosis Cardiovascular Obesidad Osteoporosis))
    (progn$ (?curr-answer ?list_answers)
     (switch ?curr-answer
      (case 1
       then
				(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Artrosis")))))
      (case 2
       then
			  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Cardiovascular")))))
      (case 3
       then
			  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Obesidad")))))
      (case 4
			 then
			  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Osteoporosis")))))
     )
    )
  )
	; (modify ?ref (dolencias $?dolencias))
  ; (assert (Persona (grupo_edad ?ge) (dolencias $?dolencias)))
	(assert (ask_Enfermedades))
)

(defrule ASK_QUESTIONS::ask_Incapacidades
  (declare (salience 10))
  (not (ask_Incapacidades))
	?ref <- (Persona (grupo_edad ?ge) (dolencias $?dolencias))
  =>
	(if (ask_question_yes_no "Sufre alguna incapacidad?")
    then
      (bind ? ?list_answers ask_question_multichoice "Cuales?" Paraplegia)
      (progn$ (?curr-answer ?list_answers)
       (switch ?curr-answer
        (case 1 then
          (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Artrosis")))))
       )
      )
  )
  (assert (ask_Incapacidades))
)

(defrule ASK_QUESTIONS::ask_Lesiones
  (declare (salience 10))
  ; (Persona (grupo_edad ?ga))
  (not (test_Lesiones))
  ?ref <- (Persona)
  =>


  (assert (ask_Lesiones))
)

(defrule ASK_QUESTIONS::printPerson
  (declare (salience 2))
  ?ref <- (Persona (grupo_edad ?ag) (dolencias $?dolencias))
  =>
  (printout t crlf crlf "## Datos Persona" crlf)
  (printout t "Grupo Edad: " ?ag crlf)
  (printout t "Dolencias: " crlf)
  (progn$ (?curr-dol ?dolencias)
	   (printout t "  " (send ?curr-dol get-dolencia) crlf)
  )
  (printout t "####" crlf)
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

  (bind $?all_test (find-all-instances ((?inst Enfermedad)) TRUE))
	(progn$ (?i ?all_test)
		(printout t (send ?i get-dolencia) crlf)
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


; (defrule PROCESS_DATA::recopilar
;  (declare (salience 10))
;  =>
;  (bind ?list (find-all-instances ((?inst Actividad)) TRUE))
;  (loop-for-count (?i 1 (length$ ?list)) do
;   (bind ?aux (nth$ ?i ?list))
;   ;aquí hacemos lo que queramos
;   (printout t "Puntuacion" crlf)
;  )
; )



(defrule PROCESS_DATA::printPointsActivity
  (declare (salience 1))
  ?inst <- (object (is-a Valoracion_Actividades) (actividad ?act) (puntuacion ?puntos))
  =>
  ; (printout t "Puntuacion Acitivdad: " (instance-name ?inst) ": " (send ?inst get-puntuacion) " puntos" crlf)
  (printout t "Puntuacion Actividad: " ?act ": " ?puntos " puntos" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; END_RULES (.CLP) ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
