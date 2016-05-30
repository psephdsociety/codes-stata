/* Attention: il faut télécharger commande sxpose avant de lancer le dofile */

set more off

* Le nombre de ligne du fichier proposition_gestion_entites.xls à prendre en compte
global nrow 197

tempfile temp_data
save "`temp_data'"

* 1. Récupérer la liste des variables qui sont dans l'enquête à labéliser
quietly ds
global list_enquete "`r(varlist)'"

* 2. Récupérer la liste des labels et ne garder que ceux utiles
import excel "P:\TAXIPP\TAXIPP 0.4\proposition_gestion_entites.xlsx", sheet("input_ERFSIPP") cellrange(A2:L${nrow}) firstrow clear
gen isinlist = 0
foreach var in  $list_enquete {
	replace isinlist = 1 if var_name == "`var'"
}
keep if isinlist == 1
keep var_name var_label

*Transposition
sxpose, clear
global N_var =`c(k)' /* Nombre de variables */

* 3. Ranger les noms des variables et des labels dans des globales
	forvalues i = 1(1)$N_var {
		global varname`i' = _var`i'[1]
		global varlabel`i' = _var`i'[2]
	}

tempfile temp_var
save "`temp_var'"

* 4. Appliquer les globales à la base de données

use "`temp_data'", replace
forvalues i = 1(1)$N_var {
	label var ${varname`i'} "${varlabel`i'}"
}
