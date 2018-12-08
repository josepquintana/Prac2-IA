
;; Practica 2 - IA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; INI_CLASSES (.PONT) ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Sat Dec 08 23:55:30 CET 2018
;
;+ (version "3.5")
;+ (build "Build 663")


(defclass %3ACLIPS_TOP_LEVEL_SLOT_CLASS "Fake class to save top-level slot information"
	(is-a USER)
	(role abstract)
	(single-slot inte
		(type STRING)
		(create-accessor read-write))
	(multislot recomendado
		(type INSTANCE)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(multislot no_recomendado
		(type INSTANCE)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot objetivo
		(type STRING)
		(create-accessor read-write))
	(single-slot tipo
		(type SYMBOL)
		(allowed-values Rotura Esguince Luxacion)
		(create-accessor read-write))
	(multislot orientado_a
		(type INSTANCE)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot material
		(type SYMBOL)
		(allowed-values FALSE TRUE)
		(create-accessor read-write))
	(single-slot intensidad_recomendada
		(type SYMBOL)
		(allowed-values baja media alta)
		(create-accessor read-write))
	(single-slot equipo
		(type SYMBOL)
		(allowed-values FALSE TRUE)
		(create-accessor read-write))
	(single-slot duracion
		(type INTEGER)

		(create-accessor read-write))
	(multislot contra_indicado
		(type INSTANCE)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(multislot indicado
		(type INSTANCE)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot actividad
		(type STRING)

		(create-accessor read-write))
	(single-slot parte_cuerpo
		(type SYMBOL)
		(allowed-values pierna brazo espalda cadera torso tobillo)

		(create-accessor read-write))
	(single-slot dolencia
		(type STRING)

		(create-accessor read-write))
	(single-slot rehabilitacion
		(type SYMBOL)
		(allowed-values FALSE TRUE)

		(create-accessor read-write))
	(single-slot intensidad
		(type SYMBOL)
		(allowed-values baja media alta)
		(create-accessor read-write)))

(defclass Actividad
	(is-a USER)
	(role concrete)
	(single-slot duracion
		(type INTEGER)
		(create-accessor read-write))
	(single-slot actividad
		(type STRING)

		(create-accessor read-write))
	(multislot orientado_a
		(type INSTANCE)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot parte_cuerpo
		(type SYMBOL)
		(allowed-values pierna brazo espalda cadera torso tobillo)
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
		(create-accessor read-write)))

(defclass Deporte
	(is-a Actividad)
	(role concrete)
	(single-slot equipo
		(type SYMBOL)
		(allowed-values FALSE TRUE)
		(create-accessor read-write)))

(defclass Objetivo
	(is-a USER)
	(role concrete)
	(single-slot intensidad
		(type SYMBOL)
		(allowed-values baja media alta)
		(create-accessor read-write))
	(single-slot objetivo
		(type STRING)
		(create-accessor read-write)))

(defclass Dolencia
	(is-a USER)
	(role concrete)
	(single-slot dolencia
		(type STRING)
		(create-accessor read-write)))

(defclass Enfermedad
	(is-a Dolencia)
	(role concrete)
	(multislot recomendado
		(type INSTANCE)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(multislot no_recomendado
		(type INSTANCE)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write)))

(defclass Lesion
	(is-a Dolencia)
	(role concrete)
	(single-slot tipo
		(type SYMBOL)
		(allowed-values Rotura Esguince Luxacion)
		(create-accessor read-write))
	(single-slot parte_cuerpo
		(type SYMBOL)
		(allowed-values pierna brazo espalda cadera torso tobillo)
		(create-accessor read-write))
	(single-slot rehabilitacion
		(type SYMBOL)
		(allowed-values FALSE TRUE)
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

	; Sat Dec 08 23:55:30 CET 2018
	;
	;+ (version "3.5")
	;+ (build "Build 663")

(definstances instances
	([Practica_Class1] of  Lesion

		(dolencia "Luxacion_Tobillo")
		(parte_cuerpo tobillo)
		(rehabilitacion TRUE)
		(tipo Luxacion))

	([Practica_Class17] of  Enfermedad

		(dolencia "Cardiovascular"))

	([Practica_Class18] of  Objetivo

		(intensidad baja)
		(objetivo "Fuerza"))

	([Practica_Class20] of  Objetivo

		(intensidad baja)
		(objetivo "Flexibilidad"))

	([Practica_Class21] of  Objetivo

		(intensidad baja)
		(objetivo "Resistencia"))

	([Practica_Class22] of  Objetivo

		(intensidad baja)
		(objetivo "Equilibrio"))

	([Practica_Class23] of  Objetivo

		(intensidad baja)
		(objetivo "Cardio"))

	([Practica_Class27] of  Objetivo

		(intensidad media)
		(objetivo "Cardio"))

	([Practica_Class28] of  Objetivo

		(intensidad alta)
		(objetivo "Cardio"))

	([Practica_Class29] of  Objetivo

		(intensidad media)
		(objetivo "Equilibrio"))

	([Practica_Class30] of  Objetivo

		(intensidad alta)
		(objetivo "Equilibrio"))

	([Practica_Class31] of  Objetivo

		(intensidad media)
		(objetivo "Flexibilidad"))

	([Practica_Class32] of  Objetivo

		(intensidad alta)
		(objetivo "Flexibilidad"))

	([Practica_Class33] of  Objetivo

		(intensidad media)
		(objetivo "Fuerza"))

	([Practica_Class34] of  Objetivo

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

		(dolencia "Obesidad"))

	([Practica_Class42] of  Enfermedad

		(dolencia "Osteoporosis"))

	([Practica_Class43] of  Lesion

		(dolencia "Rotura_Brazo")
		(parte_cuerpo brazo)
		(rehabilitacion FALSE)
		(tipo Rotura))

	([Practica_Class44] of  Lesion

		(dolencia "Rotura_Pierna")
		(parte_cuerpo pierna)
		(rehabilitacion FALSE)
		(tipo Rotura))

	([Practica_Class45] of  Lesion

		(dolencia "Rotura_Cadera")
		(parte_cuerpo cadera)
		(rehabilitacion FALSE)
		(tipo Rotura))

	([Practica_Class46] of  Lesion

		(dolencia "Esguince_Pierna")
		(parte_cuerpo pierna)
		(rehabilitacion TRUE)
		(tipo Esguince))

	([Practica_Class47] of  Incapacidad

		(dolencia "Paraplegia"))

	([Practica_Class50] of  Enfermedad

		(dolencia "Artrosis"))

	([Practica_Class53] of  Deporte

		(actividad "Baloncesto")
		(duracion 60)
		(equipo TRUE)
		(orientado_a
			[Practica_Class28]
			[Practica_Class31]
			[Practica_Class18]
			[Practica_Class36])
		(parte_cuerpo brazo))

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
		(parte_cuerpo brazo))

	([Practica_Class57] of  Ejercicio

		(actividad "PressDeBanca")
		(duracion 15)
		(material TRUE)
		(orientado_a [Practica_Class34])
		(parte_cuerpo torso))

	([Practica_Class58] of  Ejercicio

		(actividad "PressDeBanca")
		(duracion 15)
		(material FALSE)
		(orientado_a [Practica_Class36])
		(parte_cuerpo torso))
) ;closes the definstances clause

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; END_INSTANCES (.PINS) ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; INI_RULES (.CLP) ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule MAIN (export ?ALL))
(defmodule ASK_QUESTIONS (import MAIN ?ALL)(export ?ALL))
(defmodule PROCESS_DATA  (import MAIN ?ALL)(export ?ALL))
; (defmodule PROCESS_DATA  (import MAIN ?ALL)(export ?ALL))
(defmodule PRINT_WORKOUT (import MAIN ?ALL)(export ?ALL))

(defclass MAIN::ValoracionActividades
  (is-a USER) (role concrete)
	(slot actividad (type INSTANCE)(create-accessor read-write))
	(slot puntuacion (type INTEGER)(default 0)(create-accessor read-write))
)

(defclass MAIN::SesionEjercicios
	(is-a USER) (role concrete)
	(slot dia (type INTEGER)(create-accessor read-write))
	(multislot actividades (type INSTANCE)(create-accessor read-write))
	(slot duracion (type INTEGER)(default 0)(create-accessor read-write))
)

(deftemplate MAIN::ObjetivosRecomendados
	(multislot obj (type INSTANCE)) ; instance of Objectivo que es recomendado alguna de las enfermedades de la Persona
)

(deftemplate MAIN::ObjetivosNoRecomendados
	(multislot obj (type INSTANCE))
)

(deftemplate MAIN::Persona
  (slot grupo_edad (type STRING)) ; OLD, VERY_OLD, SUPER_OLD, ULTRA_OLD
  (multislot dolencias (type INSTANCE))
  (slot estado_fisico (type STRING)) ; BASICO, MEJORA, MANTENIMIENTO
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

(deffunction ASK_QUESTIONS::format_answer_list (?multichoice ?question $?values)
	(printout t ?question " " crlf)
	(progn$ (?var ?values)
		(printout t ?var-index ". " ?var crlf)
	)
	(if ?multichoice
	 	then
			(printout t crlf "Indique las respuestas separadas por un espacio: ")
			(bind ?all_answers (readline))
			(bind ?answer (str-explode ?all_answers))
			(printout t crlf)
			(return ?answer)
		else
			(printout t crlf "Indique una unica respuesta: ")
			(bind ?answer (read))
			(printout t crlf)
			(return ?answer)
	)
)

(deffunction ASK_QUESTIONS::ask_question_basic(?question)
  ; Ask a question
  (printout t ?question " ")
  (printout t ": ")
  (bind ?answer (read))
  (return ?answer)
)

(deffunction ASK_QUESTIONS::ask_question_yes_no(?question)
 ; "Escribe una pregunta y lee uno de los valores posibles (yes no)"
 	(printout t ?question " [si/no] : ")
 	(bind ?answer (read))
 	(if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
	(bind ?allowed-values (create$ si no s n yes no y n))
 	(while (not (member$ ?answer ?allowed-values)) do
		(printout t ?question " [si/no] : ")
	 	(bind ?answer (read))
	 	(if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
 	)
	(printout t crlf)
	(bind ?yes_values (create$ si s yes y))
	(if (member$ ?answer ?yes_values)
		then (bind ?res TRUE)
		else (bind ?res FALSE)
	)
	(return ?res)
)

(deffunction ASK_QUESTIONS::ask_question_integer (?question ?min_value ?max_value)
 ; Escribe una pregunta y lee un entero (el 2nd parametro es el valor minimo de la respuesta)
  (printout t ?question)
  (printout t " (NUM.): ")
  (bind ?answer (read))
	(while (or (not (integerp ?answer)) (or (< ?answer ?min_value) (> ?answer ?max_value))) do
    (printout t ?question)
    (printout t " [min " ?min_value ", max " ?max_value "]: ")
    (bind ?answer (read))
  )
  (printout t crlf)
  (return ?answer)
)

(deffunction ASK_QUESTIONS::ask_question_one_choice (?question $?allowed-values)
 ; "Escribe una pregunta y lee uno de los valores posibles (allowed-values)"
 	(bind ?answer (format_answer_list FALSE ?question $?allowed-values))
	(while (or (not (integerp ?answer)) (or (< ?answer 1) (> ?answer (length$ ?allowed-values)))) do
		(bind ?answer (format_answer_list FALSE ?question $?allowed-values))
	)
  (printout t crlf)
	(return ?answer)
)

(deffunction ASK_QUESTIONS::ask_question_multichoice (?question $?allowed-values)
	(bind ?answers (format_answer_list TRUE ?question $?allowed-values))
	(bind ?list_answers (create$ ))
  (progn$ (?var ?answers)
   	(if (and (integerp ?var) (and (>= ?var 1) (<= ?var (length$ ?allowed-values)))) then
     	(if (not (member$ ?var ?list_answers)) then
				(bind ?list_answers (insert$ ?list_answers (+ (length$ ?list_answers) 1) ?var))
     	)
   	)
  )
	(printout t crlf)
	(return ?list_answers)
)

(defrule ASK_QUESTIONS::set_GrupoEdad
  (declare (salience 20))
	(nueva_persona)
	(not (grupo_edad asked))
  =>
  (bind ?edad (ask_question_integer "Cuantos anos tiene?" 65 999))
  (bind ?ge null)

	(if (and (>= ?edad 65) (< ?edad 75)) then (bind ?ge "OLD"))
	(if (and (>= ?edad 75) (< ?edad 85)) then (bind ?ge "VERY_OLD"))
  (if (and (>= ?edad 85) (< ?edad 95)) then (bind ?ge "SUPER_OLD"))
	(if (>= ?edad 95) 									 then (bind ?ge "ULTRA_OLD"))
	;comprobar edades incorrectas

  (assert (Persona (grupo_edad ?ge)))
	(assert (grupo_edad asked))
)

(defrule ASK_QUESTIONS::ask_Enfermedades
  (declare (salience 10))
  (not (enfermedades asked))
  ?ref <- (Persona (dolencias $?dolencias))
  =>
  (if (ask_question_yes_no "Padece alguna enfermedad?") then
  	(bind ?list_answers (ask_question_multichoice "Cuales?" Artrosis Cardiovascular Obesidad Osteoporosis))
  	(progn$ (?curr-answer ?list_answers)
   		(switch ?curr-answer
    		(case 1 then
					(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Artrosis")))))
	      (case 2 then
				  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Cardiovascular")))))
	      (case 3 then
				  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Obesidad")))))
	      (case 4 then
				  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Osteoporosis")))))
	    )
  	)
  )
	(modify ?ref (dolencias $?dolencias))
	(assert (enfermedades asked))
)

(defrule ASK_QUESTIONS::ask_Incapacidades
  (declare (salience 10))
  (not (incapacidades asked))
	?ref <- (Persona (dolencias $?dolencias))
  =>
	(if (ask_question_yes_no "Sufre alguna incapacidad?") then
    (bind ?list_answers (ask_question_multichoice "Cuales?" Paraplegia))
    (progn$ (?curr-answer ?list_answers)
     	(switch ?curr-answer
      	(case 1 then
        	(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Incapacidad)) (eq ?inst:dolencia "Paraplegia")))))
     	)
    )
  )
	(modify ?ref (dolencias $?dolencias))
  (assert (incapacidades asked))
)

(defrule ASK_QUESTIONS::ask_if_Lesiones
  (declare (salience 10))
  (not (if_Lesiones asked))
  =>
	(if (ask_question_yes_no "Actualmente sufre alguna lestion?") then (assert (is_Lesionado)))
  (assert (if_Lesiones asked))
)

(defrule ASK_QUESTIONS::ask_Lesiones
  (declare (salience 10))
	(is_Lesionado)	; solo se hara esta pregunta si el usuario esta ha contestado que esta lesionado
  (not (lesiones asked))
	?ref <- (Persona (dolencias $?dolencias))
  =>
  (bind ?list_tipos (ask_question_multichoice "De que tipo de lesion se trata?" Rotura Esguince Luxacion))
  (progn$ (?curr-tipo ?list_tipos)
		(if (= 1 ?curr-tipo) then (bind ?tipo Rotura))
		(if (= 2 ?curr-tipo) then (bind ?tipo Esguince))
		(if (= 3 ?curr-tipo) then (bind ?tipo Luxacion))
		(printout t "Referente a su lesion numero " ?curr-tipo-index " de tipo " ?tipo " -> ")
		(bind ?parte_cuerpo (ask_question_one_choice "En que parte del cuerpo sufre la lesion?" Pierna Brazo Espalda Cadera Torso Tobillo))
	   	(switch ?parte_cuerpo
	    	(case 1 then
	      	(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Lesion)) (and (eq ?inst:tipo ?tipo) (eq ?inst:parte_cuerpo pierna))))) ) ;; pierna sin comillas pq es SYMBOL
				(case 2 then
      		(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Lesion)) (and (eq ?inst:tipo ?tipo) (eq ?inst:parte_cuerpo brazo))))) )
				(case 3 then
	      	(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Lesion)) (and (eq ?inst:tipo ?tipo) (eq ?inst:parte_cuerpo espalda))))) )
				(case 4 then
	      	(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Lesion)) (and (eq ?inst:tipo ?tipo) (eq ?inst:parte_cuerpo cadera))))) )
				(case 5 then
	      	(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Lesion)) (and (eq ?inst:tipo ?tipo) (eq ?inst:parte_cuerpo torso))))) )
				(case 6 then
					(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Lesion)) (and (eq ?inst:tipo ?tipo) (eq ?inst:parte_cuerpo tobillo))))) )
			)
  )
	(modify ?ref (dolencias $?dolencias))
  (assert (lesiones asked))
)

(defrule ASK_QUESTIONS::set_EstadoFisico
	(declare (salience 5))
	(not (estado_fisico asked))
	?ref <- (Persona (grupo_edad ?ge) (estado_fisico ?estado_fisico))
  =>
	(bind ?ef 150)
	(if (ask_question_yes_no "Se considera una persona con una vida totalmente sedentaria")
		then
			(bind ?ef (- ?ef 150))
		else
			(bind ?dias (ask_question_integer "Cuantos dias por setmana practica actividad fisicas?" 1 7))
			(switch ?dias
				(case 1 then
					(bind ?ef (- ?ef 100)))
				(case 2 then
					(bind ?ef (- ?ef 75)))
				(case 3 then
					(bind ?ef (- ?ef 25)))
				(case 4 then
					(bind ?ef (- ?ef 0)))
				(case 5 then
					(bind ?ef (+ ?ef 25)))
				(case 6 then
					(bind ?ef (+ ?ef 75)))
				(case 7 then
					(bind ?ef (+ ?ef 100)))
			)
	)
	(if (< ?ef 100) 									  then (bind ?estado_fisico "BASICO"))
	(if (and (>= ?ef 100) (<= ?ef 200)) then (bind ?estado_fisico "MANTENIMIENTO"))
	(if (> ?ef 200) 							      then (bind ?estado_fisico "MEJORA"))

	(modify ?ref (estado_fisico ?estado_fisico))
	(assert (estado_fisico asked))
)

(defrule ASK_QUESTIONS::printPerson
  (declare (salience 2))
  ?ref <- (Persona (grupo_edad ?ag) (dolencias $?dols) (estado_fisico ?ef))
  =>
  (printout t crlf crlf "#### > Datos Persona" crlf crlf)
  (printout t " > Grupo Edad: " ?ag crlf)
  (printout t " > Dolencias: ")
  (if (>= (length$ $?dols) 1) then
		(progn$ (?curr-dol ?dols)
   		(printout t crlf "     - " (send ?curr-dol get-dolencia))
  	)
		else (printout t "[none]")
	)
	(printout t crlf " > Estado Fisico: " ?ef crlf)
  (printout t crlf "########################################" crlf)
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
  (printout t "#######  <MY TEST RULE> #######" crlf)

  (printout t crlf "####### </MY TEST RULE> #######")
  (printout t crlf)
  (printout t crlf)
)

; Proccess the data read from the user

(defrule PROCESS_DATA::ini_scores
 	(declare (salience 99))
 	(not (puntuaciones inicializadas))
  =>
  (bind $?actividades (find-all-instances ((?inst Actividad)) TRUE))
	(progn$ (?act-i ?actividades)
		(make-instance (gensym) of ValoracionActividades (actividad ?act-i) (puntuacion 0))
	)
	(assert (puntuaciones inicializadas))
)

(defrule PROCESS_DATA::find_ObjectivosRecomendados
	(not (objetivos_recomendados found))
	?ref <- (Persona (dolencias $?dolencias))
	=>
	; (bind $?objs (create$ ))
	(progn$ (?curr-dol ?dolencias)
		(bind $?recomendados (send ?curr-dol get-recomendado))
		(progn$ (?curr-objR ?recomendados)
			(printout t "Cur-rec: " (send ?curr-objR get-objetivo) " " (send ?curr-objR get-intensidad) crlf)
		)
	; (if (member$ ?answer ?yes_values))
	)



	(assert (objetivos_recomendados found))
)

(defrule PROCESS_DATA::evaluate

	=>

)

; (defrule PROCESS_DATA::recopilar "Testing..."
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
	; no hace falta un loop ya que se ejecutara esta regla para cada valor de la classe ValoracionActividades
  (declare (salience 1))
  ?inst <- (object (is-a ValoracionActividades) (actividad ?act) (puntuacion ?puntos))
  =>
  ; (printout t "Puntuacion Acitivdad: " (instance-name ?inst) ": " (send ?inst get-puntuacion) " puntos" crlf)
  (printout t "Puntuacion Actividad " ?act ": " (send ?act get-actividad) " " ?puntos " puntos" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; END_RULES (.CLP) ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
