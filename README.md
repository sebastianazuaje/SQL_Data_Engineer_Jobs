# Introducción
💻 Profundizando en el mercado laboral! Con un enfoque hacia el Data Analysis 📊 y sus puestos de trabajo en todo el mundo 🌐 este proyecto explora el Top 10 puestos de trabajo mejor pagados 💰, las habilidades informáticas más demandadas 🔥 e incluso las habilidades más óptimas mejores pagadas 📈 en análisis de datos.

Queries de SQL? echa un vistazo aquí: [SQL_projects](/Tech_jobs_SQL/)

# Antecedentes
Motivado tras ampliar mis estudios informáticos busco navegar por el mercado laboral de un analista de datos de manera efectiva. Tras ver vídeos de Luke Barousse, famoso youtuber y data analyst, visité su repositorio de Github con más de 700.000 puestos de trabajo en todo el mundo y de diferentes plataformas, almacenados en una base de datos relacional.

Con el fin de conocer las habilidades necesarias y entender mi situación en el mercado a la hora de exigir un salario, nace este proyecto.

### Con mis queries busco responder las siguientes preguntas:

1. Cuáles son los puestos mejor pagados para un analista de datos?
2. Cuáles son las skills requeridas para estos puestos de trabajo?
3. Cuáles son las skills más demandadas para ser un analista de datos?
4. Cuáles skills están asociadas a un mayor salario?
5. Cuáles son las skills óptimas para aprender?

# Herramientas que utilicé
Para mi análisis profundo en el mercado laboral de los analistas de datos recurrí a varias herramientas:

- *Visual Studio Code:* Mi herramienta preferida para trabajar en ambientes virtualesy manejar distintos lenguajes de programación, en este caso para ejecutar mis queries.

- *PostgreSQL:* El gestor de base de datos que más domino, ideal para una base de datos tan grande como esta.

- *Git y Github:* Esencial para el manejo de versiones y compartir mis Scripts SQL y mis análisis.

# El análisis
Cada una de las queries busca abordar aspectos diferentes del mercado laboral de un analista de datos. Así abordé las preguntas:

### 1. Puestos mejor pagados para un analista de datos

Para identificar el **top 10** puestos de trabajo **mejor pagados** filtré las posiciones de analista de datos **(Data Analyst)** por el salario medio anual y por la ubicación, enfocado también en trabajos **en remoto**. Esta Query resalta las oportunidades mejor pagadas en el campo.

```sql
SELECT 
    job_id AS id_trabajo,
    job_title_short AS alias_trabajo,
    job_location AS ubicacion,
    salary_year_avg AS salario_anual,
    job_schedule_type AS tipo_esquema,
    job_posted_date AS fecha_publicacion,
    job_title AS titulo_puesto,
    name AS compañía
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id  
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location IN ('Anywhere') AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10
```
### Insights:
![Top 10 trabajos por compañía](/assets/Top_10_trabajos_company.png)
*Este gráfico muestra el top 10 de compañías a nivel mundial que mejor pagan la posición de **Analista de datos** o que lo incluyen en su descripción del puesto. Las posiciones en cuestión son en **Remoto.***
### 2. Skills requeridas para estos puestos de trabajo

Utilizando el top 10 puestos de trabajo de la Query anterior, aquí combiné la tabla de los trabajos posteados junto con la tabla de skills a través del id presente en ambas tablas. De esta forma puedo observar las **skills demandadas** en aquellos puestos **del top**. 
(Reclutadores tomen nota)

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS conteo_demanda
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY 
    conteo_demanda DESC
LIMIT 5
```
|skills_id|skills |conteo_demanda
|---------|-------|-------------
|0        |sql    |7291
|181      |excel  |4611
|1        |python |4330
|182      |tableau|3745
|5        |r      |2609

### Insights: 
1. **SQL** como fundamento clave con 7291 menciones, lidera la demanda, mostrando que la habilidad para gestionar y consultar bases de datos sigue siendo fundamental para los analistas de datos.

2. La productividad de **Excel** (4611 menciones) sigue siendo esencial, subrayando su relevancia en el análisis rápido y la presentación de datos, lo cual sigue siendo clave para tareas de análisis y reportes.

3. Preferencia por herramientas de visualización y análisis. **Tableau** (3745) y **Python** (4330) tienen una demanda muy similar, lo cual indica la necesidad de habilidades de visualización junto a un lenguaje flexible para análisis avanzado y modelos. **R** no se queda atrás ya que es muy similar a **Python** y comparten librerias incluso, pero la popularidad de la Pitón queda clara una vez más en esta Query.

### 3. Skills más demandadas para ser un analista de datos

Al igual que la Query anterior, junté la tabla de skills y de trabajos posteados pero esta vez filtrando los trabajos por la posición de **Analista de Datos** de esta forma pude contar y filtrar de mayor a menor, la cantidad de veces que las skills aparecen en las diferentes ofertas.

```sql
WITH top_trabajos AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        job_title,
        name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id  
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_location IN ('Anywhere') AND
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10 
)

SELECT 
    top_trabajos.*,
    skills AS habilidades
FROM 
    top_trabajos
INNER JOIN 
    skills_job_dim ON top_trabajos.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC
```
### Insights:

![Salario promedio por empresa](/assets/salario_por_compania.png) 
*Este gráfico de barras muestra el salario promedio de cada empresa en el conjunto de datos. AT&T tuvo el promedio más alto, seguida de Pinterest, UCLA Health Careers y SmartAsset.*

![Frecuencia de habilidades en diferentes roles laborales](/assets/frecuencia_skills.png)
*Este gráfico de barras muestra las habilidades mencionadas con más frecuencia en diferentes roles laborales. SQL, Tableau, Python y Excel fueron algunas de las habilidades más comunes, lo que indica su gran demanda en estos roles relacionados con los datos.*

### 4. Skills asociadas a un mayor salario

En esta Query busco el promedio salarial anual asociado a cada skill, sin importar su ubicación para identificar como analista de datos las skills a adquirir o mejorar con **mayor recompensa financiera.**

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS promedio_paga
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY 
    promedio_paga DESC
  LIMIT 5
--LIMIT 25
```
|skills   |promedio_paga
|---------|-------------
|pyspark  |$208,172
|bitbucket|$189,155
|couchbase|$160,515
|watson   |$160,515
|datarobot|$155,486

### Insights:
1. Especialización en Tecnologías de Big Data. **PySpark** lidera con el salario promedio anual más alto ($208,172), indicando una alta valoración en competencias de procesamiento de grandes volúmenes de datos y Big Data.

2. Demanda de Habilidades en Gestión y Colaboración de Código. **Bitbucket**, con un salario promedio de $189,155, refleja la importancia creciente de la gestión colaborativa de código y el control de versiones, habilidades críticas en proyectos de análisis de datos en equipo.

3. Alta Paga para Habilidades de Nicho. Herramientas especializadas como **Couchbase** y **Watson** ($160,515 cada una) muestran que los data analysts con conocimientos en bases de datos no relacionales y tecnologías de **IA/ML** están entre los mejor remunerados, aunque con menor demanda que habilidades de uso general.

### 5. Skills óptimas para aprender

Teniendo en cuenta las skills óptimas como aquellas altas en demanda y con un alto salario asociado, en esta Query utilizando CTEs con los resultados temporales de las queries 3 y 4 obtengo las **skills más demandadas y asociadas a los mayores salarios**. Al final probé ordenarlas primero por mayor demanda y luego por mayor salario. 

```sql
WITH demanda_skills AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS conteo_demanda
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True 
    GROUP BY
        skills_dim.skill_id
), promedio_salarial AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS promedio_paga
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    demanda_skills.skill_id,
    demanda_skills.skills,
    conteo_demanda,
    promedio_paga
FROM
    demanda_skills
INNER JOIN promedio_salarial ON demanda_skills.skill_id = promedio_salarial.skill_id
ORDER BY
    promedio_paga DESC,
    conteo_demanda DESC
    
LIMIT 25
```
|Skill ID|Skill        |Conteo Demanda|Promedio Paga
|--------|-------------|--------------|-------------
|95	     |PySpark      |2	          |$208,172
|218	 |Bitbucket    |2	          |$189,155
|85	     |Watson       |1	          |$160,515
|65	     |Couchbase	   |1	          |$160,515
|206	 |DataRobot	   |1	          |$155,486
|220	 |GitLab	   |3	          |$154,500
|35	     |Swift	       |2	          |$153,750
|102	 |Jupyter	   |3	          |$152,777
|93	     |Pandas	   |9	          |$151,821
|59	     |Elasticsearch|1	          |$145,000
|27	     |Golang       |1	          |$145,000
|94	     |Numpy	       |5	          |$143,513
|75	     |Databricks   |10	          |$141,907
|169	 |Linux	       |2	          |$136,508
|213	 |Kubernetes   |2	          |$132,500
|219	 |Atlassian	   |5	          |$131,162
|250	 |Twilio	   |1	          |$127,000
|96	     |Airflow	   |5	          |$126,103
|106	 |Scikit-Learn |2	          |$125,781
|211	 |Jenkins	   |3	          |$125,436
|238	 |Notion	   |1	          |$125,000
|3	     |Scala	       |5	          |$124,903
|57	     |PostgreSQL   |4	          |$123,879
|81	     |GCP	       |3	          |$122,500
|191	 |MicroStrategy|2	          |$121,619

### Insights:
#### 1. Demanda VS pago medio:

- Habilidades altamente demandadas y bien remuneradas: Algunas habilidades como **Databricks** (10 demandas, $141,907) y **Pandas** (9 demandas, $151,821) destacan tanto en demanda como en salario.
- Alta remuneración con baja demanda: Habilidades como **PySpark** ($208,172, 2 demandas) y **Bitbucket** ($189,155, 2 demandas) tienen pagos altos pero una demanda baja, posiblemente por ser herramientas especializadas en ciertos entornos o proyectos específicos.
#### 2. Habilidades de nicho con alta remuneración:
- Salarios máximos en herramientas específicas: Algunas habilidades como **Watson** ($160,515, 1 demanda), **Couchbase** ($160,515, 1 demanda) y **DataRobot** ($155,486, 1 demanda) tienen pagos **superiores a $150,000**, pero con demanda baja. Este comportamiento puede reflejar la especialización de estas herramientas en áreas como la inteligencia artificial (Watson) o bases de datos no relacionales (Couchbase), donde la experiencia en estas tecnologías resulta en salarios competitivos.
#### 3. Diversidad en las habilidades con alta demanda:
- Las habilidades más demandadas (entre 3 y 10 demandas) incluyen tecnologías ampliamente utilizadas en análisis de datos y desarrollo, como **Jupyter** (3 demandas, $152,777), **Numpy** (5 demandas, $143,513) y **PostgreSQL** (4 demandas, $123,879).
- **GCP** (Google Cloud Platform) es la única plataforma de nube en esta lista (3 demandas, $122,500), destacando el rol creciente de la nube en análisis de datos y machine learning.
#### 4. Herramientas de colaboración y despliegue:
- Tecnologías para colaboración y control de versiones como **GitLab** (3 demandas, $154,500), **Bitbucket** (2 demandas, $189,155) y **Atlassian** (5 demandas, $131,162) están bien representadas. Esto sugiere una preferencia por analistas de datos con conocimientos de desarrollo colaborativo, útil en entornos de trabajo en equipo.
- Herramientas de automatización de pipelines y despliegue, como **Airflow** (5 demandas, $126,103) y **Jenkins** (3 demandas, $125,436), reflejan la demanda de habilidades en DevOps para data analysts, indicando la necesidad de habilidades mixtas en desarrollo y despliegue.
#### 5. Presencia de herramientas de programación especializadas:
- Lenguajes de programación y bibliotecas clave, como **Scala** (5 demandas, $124,903) y **Swift** (2 demandas, $153,750), sugieren que el conocimiento de lenguajes de nicho es apreciado y valorado, especialmente en sectores específicos como el procesamiento de grandes volúmenes de datos y aplicaciones móviles respectivamente.
#### 6. Competencias en herramientas de BI y análisis avanzado:
- **MicroStrategy** (2 demandas, $121,619) y **Kubernetes** (2 demandas, $132,500) reflejan la importancia de competencias en herramientas de **BI** y de manejo de infraestructura en la **nube**, lo cual se valora cada vez más en analistas de datos avanzados.

# Lo que aprendí

# Conclusiones 