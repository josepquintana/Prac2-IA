
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
  (slot grupo_edad (type STRING)) ; OLD, VERY_OLD, SUPER_OLD, ULTRA_OLD
  (multislot dolencias (type INSTANCE))
  (slot estado_fisico (type STRING)) ; BASICO, MEJORA, MANTENIMIENTO
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
		(bind ?BD_enfermedades (create$ Artrosis Cardiovascular Obesidad Osteoporosis Diabetes Respiratorios Asma Depresion))
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

; (defrule ASK_QUESTIONS::ask_PracticaDeporte
; 	(declare (salience 5))
; 	?ref <- (Persona (estado_fisico ?estado_fisico))
; 	(test (eq ?estado_fisico "MEJORA"))
; 	=>
; 	(if (ask_question_yes_no "Practica deporte de alto nivel fisico habitualmente?") then
; 		(bind ?deportes (find-all-instances ((?inst Actividad)) (eq (class ?inst) Deporte)))
; 		(progn$ ?i_dep ?deportes)
; 	)
;
;
; )

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

(defrule PROCESS_DATA::evaluate_ActividadOrientadaAObjetivoRecomendadoEnfermedad ; iteracio (a nivell de regles) sobre les Activiats consultant els objectius dels templates -> puntuar Acitivitat
	(declare (salience 10))
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

(defrule PROCESS_DATA::evaluate_ActividadOrientadaAObjetivoNoRecomendadoEnfermedad ; iteracio (a nivell de regles) sobre les Activiats consultant els objectius dels templates -> puntuar Acitivitat
	(declare (salience 10))
	(not (evaluate_2 done))
	?objs_ref <- (ObjetivosNoRecomendados (objs $?objs))
	=>
	(bind $?all_valorar_actividades (find-all-instances ((?inst ValoracionActividades)) TRUE))
	(progn$ (?i_va ?all_valorar_actividades)
		(bind ?i_act (send ?i_va get-actividad))
		(bind $?objs_Actividad (send ?i_act get-orientado_a)) ; Actividad >----->>orientado_a>>-----> Objetivo
		(progn$ (?i_objA ?objs_Actividad) ;; tots els objectius orientats_a del l'activitat ?act
			(if (member$ ?i_objA ?objs) then ;; si el i_obj de la Actividad iteradaEnLaRegla es de los recomendados --> puntuar mal
						(printout t "     O_" (send ?i_objA get-objetivo) "_" (send ?i_objA get-intensidad) crlf)
				(send ?i_va put-puntuacion (- (send ?i_va get-puntuacion) 250))
			)
		)
	)
	(assert (evaluate_2 done))
)


;;;;;;;;;;;;;;;;;;; I'm here. Primera implementacio feta. valora els exercicis segons si estan recomenats o no per la enfermetat

;;;; to do:

;; puntuar segons nivell de estat fisicas
;; tractat incapacitats y lesions!
;; generar 3..7 sessions segons estat fisic (si te moltes malaties i sha flipat baixarli)
;; barrejar exercicis_type en les sessions
;; anar sumant la duracio de ex_i i posarho a classe Sessio!
;; finally print_class_sessio



(defrule PROCESS_DATA::evaluate
	=>
	(assert	(all_processed))
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
	(not (all_processed))
  ?va_ref <- (object (is-a ValoracionActividades) (actividad ?act) (puntuacion ?puntos))
  =>
  (printout t "Puntuacion Actividad: " (send ?act get-actividad) "_" (send ?act get-duracion) "min  >> " ?puntos " puntos" crlf)
)

; end
