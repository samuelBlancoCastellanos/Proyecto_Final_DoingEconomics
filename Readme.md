# Impacto de la Construcción del Metro de Bogotá en Vendedores Ambulantes de la Calle 72  
### Haciendo Economía – 2025-II  
**Autores:** Samuel Blanco Castellanos, Sofía Obando, Laura Valentina, Julian, David Catral

---

## Descripción del Proyecto

Este repositorio contiene todo el desarrollo del proyecto del curso **Haciendo Economía 2025-II**, cuyo objetivo es analizar cómo la construcción del Metro de Bogotá afecta las ventas, condiciones laborales y actividades económicas de los **vendedores ambulantes del corredor comercial de la Calle 72 (Chapinero)**.

El proyecto sigue un flujo reproducible que incluye:

1. Trabajo de campo  
2. Digitalización de datos  
3. Limpieza y codificación de la base  
4. Análisis descriptivo  
5. Preparación de insumos para Power BI  
6. Organización final del repositorio

---

## Estructura del Repositorio

### 📁 `Code/`
Scripts en Stata para limpieza y procesamiento de datos.

Incluye:

- **`Code01_LimpiezadatosRaw.do`**  
  - Define rutas  
  - Importa datos RAW  
  - Renombra variables  
  - Codifica todas las preguntas de la encuesta  
  - Normaliza distancia, tiempo y tamaño del negocio  
  - Genera la base final para análisis  

Esta carpeta almacenará también los scripts de análisis descriptivo, modelación y visualización.

---

### 📁 `CreatedData/`
Bases de datos **procesadas y listas para análisis**.

Incluye:

- `encuesta_clean_final.dta`  
- `encuesta_clean_final.csv`

Estas bases contienen los datos completamente limpios, codificados y listos para Power BI, Stata o R.

---

### 📁 `ENTREGABLES/`
Carpeta destinada a los documentos formales del curso:

- Informe de trabajo de campo  
- Evidencia fotográfica autorizada  
- Avances del documento final  
- Tablas y anexos para entregas

---

### 📁 `Literature/`
Material bibliográfico utilizado en el marco conceptual:

- Artículos académicos  
- Literatura gris  
- Documentos institucionales del Distrito  
- Noticias y reportes

Incluye los documentos procesados para el esquema PRISMA.

---

### 📁 `RawData/`
Datos **sin procesar** provenientes del trabajo de campo.

Incluye:

- `Resultados encuesta.xlsx`  
- Archivos originales capturados durante la recolección  

**Nota:** Esta carpeta no debe modificarse. Toda limpieza se realiza mediante los scripts en `Code/`.

---

## Flujo de Trabajo

1. Importación de la base RAW  
2. Renombrado y estandarización de variables  
3. Codificación numérica de todas las respuestas  
4. Limpieza de texto, fechas, horas, tamaños y distancias  
5. Exportación final a formatos `.dta` y `.csv`  
6. Análisis descriptivo y visualización en Power BI  

---

## Reproducibilidad

Para ejecutar la limpieza completa:

```stata
do Code/Code01_LimpiezadatosRaw.do

