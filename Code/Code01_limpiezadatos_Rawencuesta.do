*******************************************************
* CÓDIGO 1 - LIMPIEZA DE BASE DE DATOS RAW
* Proyecto: Impacto del Metro de Bogotá en vendedores ambulantes
* Curso: Haciendo Economía 2025-II
* Participantes: Samuel Blanco Castellanos, Sofía Obando, Laura Valentina, 
*******************************************************

clear all
set more off

*******************************************************
* 1. DEFINICIÓN DE RUTAS
*******************************************************
global root "C:\Users\Lenovo\Documents\Universidad\Material Clases\Haciendo Economía\Proyecto"
global rawdata "$root\RawData"
global cleandata "$root\CleanData"
global created "$root\CreatedData"

*******************************************************
* 2. IMPORTAR BASE DE DATOS RAW DESDE EXCEL
*******************************************************
import excel using "$rawdata\Resultados encuesta.xlsx", firstrow clear
rename *, strtoname
rename *, lower

*******************************************************
* 3. RENOMBRAR VARIABLES PRINCIPALES
*******************************************************
rename marcatemporal timestamp
rename dirección direccion
rename nombredelencuestador encuestador
rename tipodenegocio tipo_negocio
rename hacecuántotrabajustedco tiempo_trabajo
rename enpromediocuántoscliente clientes_dia
rename hanotadoalgúncambioensu cambio_ventas
rename yencuantoaloqueleest cambio_ganancia
rename teniendoencuentalossigu afecta_personas
rename j afecta_movilidad
rename k afecta_precios
rename l afecta_competencia
rename cómohancambiadolosclien cambio_clientes
rename quétiempotiemporpermanece tiempo_jornada
rename hatenidoquemoversedesu reubicacion
rename hatenidopérdidasdeprodu perdidas
rename desdelaconstruccióndelme horas_extra
rename cuándoterminenlasobrasd expectativa_ganancia
rename hacebidoalgúnavisooI info_distrito
rename silaconstruccióndelmetr impacto_sin_apoyo
rename unavezesteterminadoelm cambio_con_apoyo
rename cómopercibelaseguridad percepcion_seguridad
rename ensuspropiaspalabrasc impacto_descripcion
rename comentariosopreguntas comentarios
rename tamañooextensióndelnegocio tamano_negocio
rename distanciadelnegocioalmetro distancia_metro
rename observacionesextra observaciones

*******************************************************
* 4. LIMPIEZA DE VARIABLES DE TIEMPO
*******************************************************
capture confirm string variable timestamp
if _rc==0 {
    gen double datetime = clock(timestamp, "YMDhms")
    drop timestamp
    rename datetime timestamp
    format timestamp %tcDD/Mon/YYYY_HH:MM:SS
}
gen fecha = dofc(timestamp)
format fecha %tdDD/Mon/YYYY
gen str8 hora = string(hh(timestamp), "%02.0f")+":"+string(mm(timestamp), "%02.0f")+":"+string(ss(timestamp), "%02.0f")
order fecha hora, first
drop timestamp

*******************************************************
* 5. CODIFICACIÓN DE VARIABLES CATEGÓRICAS
*******************************************************

* Tipo de negocio
gen tipo_tmp = .
replace tipo_tmp = 1 if regexm(tipo_negocio, "Comida preparada")
replace tipo_tmp = 2 if regexm(tipo_negocio, "Comida procesada")
replace tipo_tmp = 3 if regexm(tipo_negocio, "Accesorios")
replace tipo_tmp = 4 if regexm(tipo_negocio, "Tecnolog")
replace tipo_tmp = 5 if tipo_tmp==.
label define tipo_lbl 1 "Comida preparada" 2 "Comida procesada" 3 "Accesorios y ropa" 4 "Tecnología" 5 "Otro"
label values tipo_tmp tipo_lbl
drop tipo_negocio
rename tipo_tmp tipo_negocio

* Tiempo trabajando
gen tmp_tiempo = .
replace tmp_tiempo = 1 if regexm(tiempo_trabajo, "1 y 2")
replace tmp_tiempo = 2 if regexm(tiempo_trabajo, "3 y 4")
replace tmp_tiempo = 3 if regexm(tiempo_trabajo, "5 y 6")
replace tmp_tiempo = 4 if regexm(tiempo_trabajo, "Más de 6")
label define tiempo_lbl 1 "1-2 años" 2 "3-4 años" 3 "5-6 años" 4 "Más de 6 años"
label values tmp_tiempo tiempo_lbl
drop tiempo_trabajo
rename tmp_tiempo tiempo_trabajo

* Clientes por día
gen tmp_clientes = .
replace tmp_clientes = 1 if regexm(clientes_dia, "Menos de 10")
replace tmp_clientes = 2 if regexm(clientes_dia, "10 y 20")
replace tmp_clientes = 3 if regexm(clientes_dia, "21 y 40")
replace tmp_clientes = 4 if regexm(clientes_dia, "Más de 40")
label define clientes_lbl 1 "Menos de 10" 2 "10–20" 3 "21–40" 4 "Más de 40"
label values tmp_clientes clientes_lbl
drop clientes_dia
rename tmp_clientes clientes_dia

* Cambio en ventas
gen tmp_ventas = .
replace tmp_ventas = 1 if regexm(cambio_ventas, "aumentado")
replace tmp_ventas = 2 if regexm(cambio_ventas, "mantenido")
replace tmp_ventas = 3 if regexm(cambio_ventas, "disminuido un poco")
replace tmp_ventas = 4 if regexm(cambio_ventas, "disminuido mucho")
label define ventas_lbl 1 "Aumentado" 2 "Igual" 3 "Disminuido un poco" 4 "Disminuido mucho"
label values tmp_ventas ventas_lbl
drop cambio_ventas
rename tmp_ventas cambio_ventas

* Cambio en ganancia
gen tmp_ganancia = .
replace tmp_ganancia = 1 if regexm(cambio_ganancia, "más que antes")
replace tmp_ganancia = 2 if regexm(cambio_ganancia, "igual que antes")
replace tmp_ganancia = 3 if regexm(cambio_ganancia, "menos que antes")
label define ganancia_lbl 1 "Más que antes" 2 "Igual que antes" 3 "Menos que antes"
label values tmp_ganancia ganancia_lbl
drop cambio_ganancia
rename tmp_ganancia cambio_ganancia

*******************************************************
* 6. VARIABLES DE PERCEPCIÓN Y CONDICIONES
*******************************************************

* Expectativa de ganancias
gen tmp_exp = .
replace tmp_exp = 1 if regexm(expectativa_ganancia, "mejorar")
replace tmp_exp = 2 if regexm(expectativa_ganancia, "igual")
replace tmp_exp = 3 if regexm(expectativa_ganancia, "empeorar")
replace tmp_exp = 4 if regexm(expectativa_ganancia, "no sabe")
label define exp_lbl 1 "Mejorar" 2 "Igual" 3 "Empeorar" 4 "No sabe"
label values tmp_exp exp_lbl
drop expectativa_ganancia
rename tmp_exp expectativa_ganancia

* Información recibida
gen tmp_info = .
replace tmp_info = 1 if regexm(info_distrito, "varias")
replace tmp_info = 2 if regexm(info_distrito, "una vez")
replace tmp_info = 3 if regexm(info_distrito, "nunca")
label define info_lbl 1 "Varias veces" 2 "Una vez" 3 "Nunca"
label values tmp_info info_lbl
drop info_distrito
rename tmp_info info_distrito

* Impacto sin apoyo
gen tmp_sin = .
replace tmp_sin = 1 if regexm(impacto_sin_apoyo, "No se afectaría")
replace tmp_sin = 2 if regexm(impacto_sin_apoyo, "ligeramente")
replace tmp_sin = 3 if regexm(impacto_sin_apoyo, "moderadamente")
replace tmp_sin = 4 if regexm(impacto_sin_apoyo, "gravemente")
label define sin_lbl 1 "No se afectaría" 2 "Ligeramente" 3 "Moderadamente" 4 "Gravemente"
label values tmp_sin sin_lbl
drop impacto_sin_apoyo
rename tmp_sin impacto_sin_apoyo

* Cambio con apoyo
gen tmp_con = .
replace tmp_con = 1 if regexm(cambio_con_apoyo, "No cambiaría")
replace tmp_con = 2 if regexm(cambio_con_apoyo, "Mejoraría un poco")
replace tmp_con = 3 if regexm(cambio_con_apoyo, "Mejoraría mucho")
replace tmp_con = 4 if regexm(cambio_con_apoyo, "Empeoraría un poco")
replace tmp_con = 5 if regexm(cambio_con_apoyo, "Empeoraría mucho")
label define con_lbl 1 "No cambiaría" 2 "Mejoraría un poco" 3 "Mejoraría mucho" 4 "Empeoraría un poco" 5 "Empeoraría mucho"
label values tmp_con con_lbl
drop cambio_con_apoyo
rename tmp_con cambio_con_apoyo

* Percepción de seguridad
gen tmp_seg = .
replace tmp_seg = 1 if regexm(percepcion_seguridad, "Más inseguro")
replace tmp_seg = 2 if regexm(percepcion_seguridad, "Más seguro") | regexm(percepcion_seguridad, "Menos inseguro")
replace tmp_seg = 3 if regexm(percepcion_seguridad, "Sin cambios")
label define seg_lbl 1 "Más inseguro" 2 "Más seguro" 3 "Sin cambios"
label values tmp_seg seg_lbl
drop percepcion_seguridad
rename tmp_seg percepcion_seguridad

*******************************************************
* 7. TAMAÑO Y DISTANCIA AL METRO
*******************************************************
replace tamano_negocio = "Pequeño" if !inlist(tamano_negocio, "Pequeño", "Mediano", "Grande")
encode tamano_negocio, gen(tam)
label define tam_lbl 1 "Pequeño" 2 "Mediano" 3 "Grande"
label values tam tam_lbl
drop tamano_negocio
rename tam tamano_negocio

gen strL _s = lower(distancia_metro)
replace _s = trim(_s)
replace _s = subinstr(_s, ",", ".", .)
gen double _dist = .
replace _dist = real(regexs(1)) if regexm(_s, "([0-9]+(\.[0-9]+)?)\s*(metros|metro|m)\b")
replace _dist = real(regexs(1))*1000 if missing(_dist) & regexm(_s, "([0-9]+(\.[0-9]+)?)\s*(kil[oó]metros?|km)\b")
replace _dist = real(regexs(1))*200 if missing(_dist) & regexm(_s, "([0-9]+(\.[0-9]+)?)\s*cuadra[s]?\b")
replace _dist = real(regexs(1)) if missing(_dist) & regexm(_s, "^\s*([0-9]+(\.[0-9]+)?)\s*$")
drop distancia_metro _s
rename _dist distancia_metro
label variable distancia_metro "Distancia al metro (metros)"
format distancia_metro %9.0f

*******************************************************
* 8. GUARDAR BASE LIMPIA FINAL
*******************************************************
save "$created\encuesta_clean_final.dta", replace
export delimited using "$created\encuesta_clean_final.csv", replace encoding(utf8)
*******************************************************
display ">>> LIMPIEZA FINALIZADA: Base guardada en CreatedData"
*******************************************************
