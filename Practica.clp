
(defmodule MAIN (export ?ALL))
(defmodule READ_DATA (import MAIN ?ALL)(export ?ALL))
(defmodule PROCESS_DATA (import MAIN ?ALL)(export ?ALL))
(defmodule PRINT_SOL (import MAIN ?ALL)(export ?ALL))

(deftemplate MAIN::Enfermedad
   (slot nombreEnfermedad (type STRING))
)

(defrule MAIN::init
  (declare (salience 99))
  =>
  (printout t crlf)
  (printout t ">> IA: Ejercicios para la salud <<")
  (printout t crlf)

  (focus READ_DATA)
)

(deffunction READ_DATA::ask_possible_values (?question $?allowed-values)
"Write a question and read one the the possible values (allowed-values)"
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
