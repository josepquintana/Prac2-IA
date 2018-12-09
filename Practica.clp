
; Practica 2 - IA

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
	(multislot objs (type INSTANCE)) ; instance of Objetivo que es recomendado alguna de las enfermedades de la Persona
)

(deftemplate MAIN::ObjetivosNoRecomendados
	(multislot objs (type INSTANCE)) ; instance of Objetivo que es no_recomendado alguna de las enfermedades de la Persona
)

(deftemplate MAIN::Persona
	(slot nombre							(type INTEGER)) ; nombre de la persona
	(slot edad								(type INTEGER)) ; numerical edad
	(slot grupo_edad					(type STRING))  ; OLD, VERY_OLD, SUPER_OLD, ULTRA_OLD
	(multislot dolencias			(type INSTANCE)) ; dolencias (enf,incp,lesn) que padece el individiu
	(slot dias_actividad			(type INTEGER)) ; 0-> sedentaria, 1..7 -> dias que practica actividades
	(slot nivel_cardio				(type STRING))  ; BASICO, MEJORA, MANTENIMIENTO
	(slot nivel_equilibrio		(type STRING))  ; BASICO, MEJORA, MANTENIMIENTO
	(slot nivel_flexibilidad	(type STRING))  ; BASICO, MEJORA, MANTENIMIENTO
	(slot nivel_fuerza				(type STRING))  ; BASICO, MEJORA, MANTENIMIENTO
	(slot nivel_resistencia		(type STRING))  ; BASICO, MEJORA, MANTENIMIENTO
	(slot nivel_salud_mental	(type STRING))  ; BASICO, MEJORA, MANTENIMIENTO
)


(defrule MAIN::init "initial rule"
  (declare (salience 99))
  =>
  (printout t crlf "################################################################" crlf crlf)
	(printout t "                  SISTEMA DE RECOMENDACION" crlf)
  (printout t "                DE EJERCICIOS Y ACTIVIDADES" crlf)
  (printout t crlf "################################################################" crlf crlf)
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
  (printout t ?question " ")
  ; (printout t " (NUM.): ")
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

(defrule ASK_QUESTIONS::say_Hi "First Question"
	(declare (salience 20))
	(nueva_persona)
	(not (nombre asked))
	=>
	(printout t "Buenos dias!" crlf crlf)
	(printout t "Antes de nada, podria indicarnos su nombre por favor." crlf crlf)
	(bind ?nombre (ask_question_basic ">"))
	(printout t crlf "Bienvenid@ " ?nombre "!!" crlf crlf)
	(printout t "Vamos a proceder a realizarle unas preguntas sobre su condicion" crlf)
	(printout t "fisica y sobre posibles dolencias que usted pudiera padecer, con" crlf)
	(printout t "la finalidad de poder recomendarle unas sesiones de ejercicios y" crlf)
	(printout t "actividades fisicas adecuadas para su estado de salud y condicion." crlf crlf)

	(assert (Persona (nombre ?nombre)))
	(assert (nombre asked))
)

(defrule ASK_QUESTIONS::ask_Edad
  (declare (salience 15))
	(not (edad asked))
	?pers <- (Persona (edad ?edad) (grupo_edad ?ge))
  =>
  (bind ?edad (ask_question_integer "Cuantos anos tiene?" 65 999))
  (bind ?ge null)

	(if (and (>= ?edad 65) (< ?edad 75)) then (bind ?ge "OLD"))
	(if (and (>= ?edad 75) (< ?edad 85)) then (bind ?ge "VERY_OLD"))
  (if (and (>= ?edad 85) (< ?edad 95)) then (bind ?ge "SUPER_OLD"))
	(if (>= ?edad 95) 									 then (bind ?ge "ULTRA_OLD"))
	;comprobar edades incorrectas

	(modify ?pers (edad ?edad) (grupo_edad ?ge))
	(assert (edad asked))
)

(defrule ASK_QUESTIONS::ask_Enfermedades
  (declare (salience 10))
  (not (enfermedades asked))
  ?ref <- (Persona (dolencias $?dolencias))
  =>
  (if (ask_question_yes_no "Padece alguna enfermedad?") then
		(bind ?BD_enfermedades (create$ Artrosis Cardiovascular Obesidad Osteoporosis Diabetes Respiratorios Asma Depresion Mononucleosis))
		(bind ?list_answers (ask_question_multichoice "Cuales?" ?BD_enfermedades))
  	(progn$ (?curr-answer ?list_answers)
			(bind ?enf (nth$ ?curr-answer ?BD_enfermedades))
			(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia (format nil "%s" ?enf)))))
   		; (switch ?curr-answer
    	; 	(case 1 then
			; 		(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Artrosis")))))
	    ;   (case 2 then
			; 	  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Cardiovascular")))))
	    ;   (case 3 then
			; 	  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Obesidad")))))
	    ;   (case 4 then
			; 	  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Osteoporosis")))))
			; 	(case 5 then
			; 	  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Diabetes")))))
	    ;   (case 6 then
			; 	  (bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Enfermedad)) (eq ?inst:dolencia "Respiratorios")))))
	    ; )
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
		(bind ?BD_incapacidades (create$ "Paraplegia" "Paralisis Cerebral" "Distrofia Muscular"))
    (bind ?list_answers (ask_question_multichoice "Cuales?" ?BD_incapacidades))
    (progn$ (?curr-answer ?list_answers)
			(bind ?inc (nth$ ?curr-answer ?BD_incapacidades))
    	(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Incapacidad)) (eq ?inst:dolencia (format nil "%s" ?inc)))))
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
		(bind ?BD_partes_cuerpo (create$ Pierna Brazo Espalda Cadera Torso Tobillo))
		(bind ?answer (ask_question_one_choice "En que parte del cuerpo sufre la lesion?" ?BD_partes_cuerpo))

		(bind ?parte_cuerpo (nth$ ?answer ?BD_partes_cuerpo))
  	(bind $?dolencias (insert$ $?dolencias (+ (length$ $?dolencias) 1) (find-instance ((?inst Lesion)) (and (eq ?inst:tipo ?tipo) (eq ?inst:parte_cuerpo (lowcase ?parte_cuerpo)))))) ;; pierna sin comillas pq es SYMBOL
  )
	(modify ?ref (dolencias $?dolencias))
  (assert (lesiones asked))
)

(defrule ASK_QUESTIONS::set_DiasActividad
	(declare (salience 5))
	(not (dias_actividad asked))
	?ref <- (Persona)
  =>
	(if (ask_question_yes_no "Se considera una persona con una vida totalmente sedentaria")
		then
			(bind ?da 0)
			(assert (is_Sedentary))
		else
			(bind ?da (ask_question_integer "Cuantos dias por setmana practica actividad fisicas?" 1 7))
	)
	(modify ?ref (dias_actividad ?da))
	(assert (dias_actividad asked))
)

(defrule ASK_QUESTIONS::set_NivelesSedentario
	(declare (salience 5))
	(and (is_Sedentary) (not (niveles_sedentario set)))
	?pers <- (Persona); (nivel_cardio ?nc) (nivel_equilibrio ?ne) (nivel_flexibilidad ?nx) (nivel_fuerza ?nf) (nivel_resistencia ?nr) (nivel_salud_mental ?nsm))
	=>
	(bind ?basico "BASICO")
	(modify ?pers (nivel_cardio ?basico) (nivel_equilibrio ?basico) (nivel_flexibilidad ?basico) (nivel_fuerza ?basico) (nivel_resistencia ?basico) (nivel_salud_mental ?basico))
	(assert (niveles_sedentario set))
)

(defrule ASK_QUESTIONS::set_NivelesObjetivos
	(declare (salience 5))
	(not (niveles set))
	(not (is_Sedentary))
	?pers <- (Persona (grupo_edad ?ge) (dias_actividad ?da) (nivel_cardio ?nc) (nivel_equilibrio ?ne) (nivel_flexibilidad ?nx) (nivel_fuerza ?nf) (nivel_resistencia ?nr) (nivel_salud_mental ?nsm))
	=>
	(bind ?nivel "none")
	(bind $?niveles (create$ "cardio" "equilibrio" "flexibilidad" "fuerza" "resistencia" "salud mental"))
	(progn$ (?curr-nivel ?niveles)
		(bind ?question (format nil "De estos dias %d que practica actividades fisicas, en cuantos de ellos dedica tiempo a mejorar sus capacidades de %s?" ?da ?curr-nivel))
		(bind ?dias_curr-nivel (ask_question_integer ?question 0 ?da))
		(if (> ?dias_curr-nivel 0)
		  then
				(bind ?question (format nil "En los %d dias que dedica tiempo a entrenar %s, cuantas horas le dedica al dia?" ?dias_curr-nivel ?curr-nivel))
				(bind ?horas_dia_curr-nivel (ask_question_integer ?question 1 24))
				(bind ?horas_semanales (* ?horas_dia_curr-nivel ?dias_curr-nivel))

				(if (>= ?horas_semanales 10)
					then (bind ?nivel "MANTENIMIENTO")
					else (bind ?nivel "MEJORA")
				)
			else
				(bind ?nivel "BASICO")
		)

		(if (eq ?curr-nivel "cardio") 			then (bind ?nc ?nivel))
		(if (eq ?curr-nivel "equilibrio") 	then (bind ?ne ?nivel))
		(if (eq ?curr-nivel "flexibilidad") then (bind ?nx ?nivel))
		(if (eq ?curr-nivel "fuerza") 			then (bind ?nf ?nivel))
		(if (eq ?curr-nivel "resistencia") 	then (bind ?nr ?nivel))
		(if (eq ?curr-nivel "salud mental") then (bind ?nsm ?nivel))
	)

	(modify ?pers
		(nivel_cardio       ?nc)
		(nivel_equilibrio   ?ne)
		(nivel_flexibilidad ?nx)
		(nivel_fuerza 			?nf)
		(nivel_resistencia  ?nr)
		(nivel_salud_mental ?nsm)
	)
	(assert (niveles set))
)

(defrule ASK_QUESTIONS::printPerson
  (declare (salience 2))
  ?ref <- (Persona (nombre ?nombre) (edad ?e) (grupo_edad ?ge) (dolencias $?dols) (dias_actividad ?da) (nivel_cardio ?nc) (nivel_equilibrio ?ne) (nivel_flexibilidad ?nx) (nivel_fuerza ?nf) (nivel_resistencia ?nr) (nivel_salud_mental ?nsm))
  =>
  (printout t crlf crlf "###### > Datos Persona" crlf)
	(printout t crlf " > Nombre:             " ?nombre)
  (printout t crlf " > Edad:               " ?e " anos [" ?ge "]")
  (printout t crlf " > Dolencias:          ")
  (if (>= (length$ $?dols) 1) then
		(progn$ (?curr-dol ?dols)
   		(printout t crlf "    + " (send ?curr-dol get-dolencia))
  	)
		else (printout t "[none]")
	)
  (if (>= (length$ $?dols) 1) then (printout t crlf)) ; just for indentation purposes
	(printout t crlf " > Num dias Actividad: " ?da " dias")
	(printout t crlf " > Nivel_cardio:       " ?nc)
	(printout t crlf " > Nivel_equilibrio:   " ?ne)
	(printout t crlf " > Nivel_flexibilidad  " ?nx)
	(printout t crlf " > Nivel_fuerza:       " ?nf)
	(printout t crlf " > Nivel_resistencia:  " ?nr)
	(printout t crlf " > Nivel_salud_mental: " ?nsm)
  (printout t crlf crlf "########################################" crlf)
)

(defrule ASK_QUESTIONS::dataReadCorrect
  (declare (salience 1))
  =>
  (printout t crlf)
  (printout t "                  <<    Data Entered   >>")
  (printout t crlf)
  (focus PROCESS_DATA)
)

(defrule PROCESS_DATA::my_TEST_RULE
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

(deffunction PROCESS_DATA::translate_nivel_to_intensidad(?nivel)
	(if (eq ?nivel "BASICO") 				then (bind ?intensidad baja))
	(if (eq ?nivel "MEJORA") 				then (bind ?intensidad media))
	(if (eq ?nivel "MANTENIMIENTO") then (bind ?intensidad alta))
	(return ?intensidad)
)

(defrule PROCESS_DATA::ini_scores
 	(declare (salience 99))
 	(not (puntuaciones inicializadas))
  =>
  (bind $?actividades (find-all-instances ((?inst Actividad)) TRUE))
	(progn$ (?act-i ?actividades)
		; (printout t "Act_" ?act-i-index ": " (send ?act-i get-actividad) "_" (send ?act-i get-parte_trabajada) crlf)
		(make-instance (gensym) of ValoracionActividades (actividad ?act-i) (puntuacion 0))
	)
	(printout t "DB_Actividades: " (length$ (find-all-instances ((?it ValoracionActividades)) TRUE)) crlf)
	(assert (ObjetivosRecomendados))
	(assert (ObjetivosNoRecomendados))
	(assert (puntuaciones inicializadas))
)

(defrule PROCESS_DATA::find_ObjectivosRecomendados ; de momento solo para enfermedades
	(declare (salience 95))
	(not (objetivos_recomendados found))
	(Persona (dolencias $?dolencias))
	?obj_ref <- (ObjetivosRecomendados (objs $?objs))
	;;; problema amb class i template per accedir al mateix temps a objetivos_recomendados y a les actividades
	=>
	(progn$ (?curr-dol ?dolencias)
		(if (or (eq (class ?curr-dol) Enfermedad) (eq (class ?curr-dol) Incapacidad)) then
			(bind $?objRecomendadosEnf (send ?curr-dol get-recomendado))
			(progn$ (?curr-objR ?objRecomendadosEnf)
				(if (not (member$ ?curr-objR ?objs)) then
					(bind ?obj_name (send ?curr-objR get-objetivo))
					(bind ?obj_intensidad (send ?curr-objR get-intensidad))
					(bind $?objs (insert$ $?objs (+ (length$ $?objs) 1) (find-instance ((?inst Objetivo)) (and (eq ?inst:objetivo ?obj_name) (eq ?inst:intensidad ?obj_intensidad)))))
				)
			)
		)
	)

	(modify ?obj_ref (objs $?objs))
	(assert (objetivos_recomendados found))
)

(defrule PROCESS_DATA::find_ObjetivosNoRecomendados ; de momento solo para enfermedades
	(declare (salience 95))
	(not (objetivos_no_recomendados found))
	(Persona (dolencias $?dolencias))
	?obj_ref <- (ObjetivosNoRecomendados (objs $?objs))
	=>
	(progn$ (?curr-dol ?dolencias)
		(if (or (eq (class ?curr-dol) Enfermedad) (eq (class ?curr-dol) Incapacidad)) then
			(bind $?objNoRecomendadosEnf (send ?curr-dol get-no_recomendado))
			(progn$ (?curr-objNR ?objNoRecomendadosEnf)
				(if (not (member$ ?curr-objNR ?objs)) then
					(bind ?obj_name (send ?curr-objNR get-objetivo))
					(bind ?obj_intensidad (send ?curr-objNR get-intensidad))
					(bind $?objs (insert$ $?objs (+ (length$ $?objs) 1) (find-instance ((?inst Objetivo)) (and (eq ?inst:objetivo ?obj_name) (eq ?inst:intensidad ?obj_intensidad)))))
				)
			)
		)
	)
	(modify ?obj_ref (objs $?objs))
	(assert (objetivos_no_recomendados found))
)

(defrule PROCESS_DATA::printObjs
	(declare (salience 90))
	(ObjetivosRecomendados (objs $?objs_R))
	(ObjetivosNoRecomendados (objs $?objs_NoR))
	=>
	(progn$ (?i_obj ?objs_R)
		(printout t "ObjR  : " (send ?i_obj get-objetivo) "_" (send ?i_obj get-intensidad) crlf)
	)
	(printout t crlf)
	(progn$ (?i_obj ?objs_NoR)
		(printout t "ObjNoR: " (send ?i_obj get-objetivo) "_" (send ?i_obj get-intensidad) crlf)
	)
	(printout t crlf crlf)
)

(defrule PROCESS_DATA::evaluate_ActividadOrientadaAObjetivoRecomendadoEnfermedad ; iteracio sobre les Activiats consultant els objectius dels templates -> puntuar Acitivitat
	(declare (salience 50))
	(not (evaluate_1 done))
	(ObjetivosRecomendados (objs $?objs))
	; ?va_ref <- (object (is-a ValoracionActividades) (actividad ?act) (puntuacion ?puntos)) ; una execucio per cada instancia de Val_Act
	; ferho amb ref nomes al deftemplate i dewspres fer un find-all-instances de ValoracionActividades!!!!!
	=>
	(bind $?all_valorar_actividades (find-all-instances ((?inst ValoracionActividades)) TRUE))
	(progn$ (?i_va ?all_valorar_actividades)
		(bind ?i_act (send ?i_va get-actividad))
		; (printout t ">>> " (send ?i_act get-actividad) crlf)
		(bind $?objs_Actividad (send ?i_act get-orientado_a)) ; Actividad >----->>orientado_a>>-----> Objetivo
		(progn$ (?i_objA ?objs_Actividad) ;; tots els objectius orientats_a del l'activitat ?act
			; (printout t "     O_" (send ?i_objA get-objetivo) "_" (send ?i_objA get-intensidad) crlf)
			(if (member$ ?i_objA ?objs) then ;; si el i_obj de la Actividad iteradaEnLaRegla es de los recomendados --> puntuar bien
				(send ?i_va put-puntuacion (+ (send ?i_va get-puntuacion) 250))
			)
		)
	)
	(assert (evaluate_1 done))
)

(defrule PROCESS_DATA::evaluate_ActividadOrientadaAObjetivoNoRecomendadoEnfermedad ; iteracio sobre les Activiats consultant els objectius dels templates -> puntuar Acitivitat
	(declare (salience 50))
	(not (evaluate_2 done))
	?objs_ref <- (ObjetivosNoRecomendados (objs $?objs))
	=>
	; (printout t "evaluate_ActividadOrientadaAObjetivoNoRecomendadoEnfermedad" crlf)
	(bind $?all_valorar_actividades (find-all-instances ((?inst ValoracionActividades)) TRUE))
	(progn$ (?i_va ?all_valorar_actividades)
		(bind ?i_act (send ?i_va get-actividad))
		; (if (eq ?i_va-index 12) then (printout t "Act: " (send ?i_act get-actividad) crlf))
		(bind $?objs_Actividad (send ?i_act get-orientado_a)) ; Actividad >----->>orientado_a>>-----> Objetivo
		(progn$ (?i_objA ?objs_Actividad) ;; tots els objectius orientats_a del l'activitat ?act
			; (if (and (eq ?i_va-index 12) (eq ?i_objA-index 1)) then (printout t "orientado_a " (send ?i_objA get-objetivo) "_" (send ?i_objA get-intensidad) crlf))
			(if (member$ ?i_objA ?objs) then ;; si el i_obj de la Actividad iteradaEnLaRegla es de los recomendados --> puntuar mal
				; (if (and (eq ?i_va-index 12) (eq ?i_objA-index 1)) then (printout t "     O_" (send ?i_objA get-objetivo) "_" (send ?i_objA get-intensidad) crlf))
				(send ?i_va put-puntuacion (- (send ?i_va get-puntuacion) 250))
			)
		)
	)
	(assert (evaluate_2 done))
)

(defrule PROCESS_DATA::evaluate_IntensidadActividadVsEstadoFisicoPersona ; iteracio (a nivell de regles) consultant les actividades:intensidad with persona:estado_fisico
	(declare (salience 50))
	; (not (evaluate_3 done))
	?pers <- (Persona (nivel_cardio ?nc) (nivel_equilibrio ?ne) (nivel_flexibilidad ?nx) (nivel_fuerza ?nf) (nivel_resistencia ?nr) (nivel_salud_mental ?nsm))
	?va_ref <- (object (is-a ValoracionActividades) (actividad ?act) (puntuacion ?puntos))
	=>
	(printout t "Doing evaluate_3 on " (send ?act get-actividad) crlf)

	(bind ?max_intensidad "baja")
	(bind ?orientado_a (send ?act get-orientado_a))
	(progn$ (?i_or_a ?orientado_a)
		(bind ?i_objetivo (send ?i_or_a get-objetivo))
		(bind ?i_intensidad (send ?i_or_a get-intensidad))

		(if (eq "Padel" (send ?act get-actividad)) then (printout t "   Checking obj: " ?i_objetivo "_" ?i_intensidad crlf))

		(if (eq ?i_objetivo "Cardio")
			then
				(printout t "Obj_cardio" crlf)
				; (if (neq (format nil "%s" ?i_intensidad) ?nc)

		)
		;
		; (if (eq ?i_objetivo "equilibrio") 	then (bind ?ne ?nivel))
		; (if (eq ?i_objetivo "flexibilidad") then (bind ?nx ?nivel))
		; (if (eq ?i_objetivo "fuerza") 			then (bind ?nf ?nivel))
		; (if (eq ?i_objetivo "resistencia") 	then (bind ?nr ?nivel))
		; (if (eq ?i_objetivo "salud mental") then (bind ?nsm ?nivel))

		; (printout t ?i_or_a_intensidad crlf)
		; comparar amb el nivel_cardio de la persona
	)
)

;;;;;;;;;;;;;;;;;;; I'm here. Primera implementacio feta. valora els exercicis segons si estan recomenats o no per la enfermetat

;;;; to do:

;; filtrar millor per aconseguir estado_fisico. Relacio amb la edad
;; tractat lesions!
;; generar 3..7 sessions segons estat fisic (si te moltes malaties i sha flipat baixarli)
;; barrejar exercicis_type en les sessions
;; anar sumant la duracio de ex_i i posarho a classe Sessio!
;; finally print_class_sessio



(defrule PROCESS_DATA::all_processed
	(declare (salience 1))
	=>
	(printout t crlf crlf "#### ValoracionActividades:" crlf crlf)
	(assert	(all_processed done))
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
  ; (declare (salience 1))
	(all_processed done)
  ?va_ref <- (object (is-a ValoracionActividades) (actividad ?act) (puntuacion ?puntos))
  =>
  ; (printout t "  " (send ?act get-actividad) "_" (send ?act get-duracion) "min  >> " ?puntos " puntos" crlf)
)

; end
