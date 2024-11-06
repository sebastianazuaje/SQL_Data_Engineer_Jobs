# Introducción
💻 Profundizando en el mercado laboral! Con un enfoque hacia el Data Engineer 🔧 y sus puestos de trabajo en todo el mundo 🌐 este proyecto explora el Top 10 puestos de trabajo mejor pagados 💰, las habilidades informáticas más demandadas 🔥 e incluso las habilidades más óptimas mejores pagadas 📈 en ingeniería de datos.

Queries de SQL? echa un vistazo aquí: [SQL_projects](/Tech_jobs_SQL/)

# Antecedentes
Esta es una continuación de mis proyectos anteriores "SQL Data Analyst y Data Scientost Jobs" en el que busqué desvelar las habilidades necesarias y entender mi situación en el mercado a la hora de exigir un salario en empresas tecnológicas. 

### Con mis queries busco responder las siguientes preguntas:

1. Cuáles son los puestos mejor pagados para un ingeniero de datos en remoto?
2. Cuáles son las skills requeridas para estos puestos de trabajo?
3. Cuáles son las skills más demandadas para ser un ingeniero de datos?
4. Cuáles skills están asociadas a un mayor salario?
5. Cuáles son las skills óptimas para aprender?

# Herramientas que utilicé
Para mi análisis profundo en el mercado laboral de los científicos de datos recurrí a varias herramientas:

- *Visual Studio Code:* Mi herramienta preferida para trabajar en ambientes virtuales y manejar distintos lenguajes de programación, en este caso para ejecutar mis queries.

- *PostgreSQL:* El gestor de base de datos que más domino, ideal para una base de datos tan grande como esta.

- *Git y Github:* Esencial para el manejo de versiones y compartir mis Scripts SQL y mis análisis.

- *ChatGPT:* IA para interpretación de los JSON resultado de la Query e investigación en simultáneo de las skills desconocidas.

# El análisis
Cada una de las queries busca abordar aspectos diferentes del mercado laboral de un ingeniero de datos. Así abordé las preguntas:

### 1. Puestos mejor pagados para un científico de datos en remoto

Para identificar el **top 10** puestos de trabajo **mejor pagados** filtré las posiciones de ingeniero de datos **(Data Scientist)** por el salario medio anual y por la ubicación, enfocado también en trabajos **en remoto**. Esta Query resalta las oportunidades mejor pagadas en el campo.

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
    job_title_short = 'Data Engineer' AND
    job_location IN ('Anywhere') AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10
```
### Insights:
![Top 10 trabajos por compañía](/assets/Top_10_trabajos_company.png)
*Este gráfico muestra el top 10 de compañías a nivel mundial que mejor pagan la posición de **Ingeniero de datos** o que lo incluyen en su descripción del puesto. Las posiciones en cuestión son en **Remoto.***
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
    job_title_short = 'Data Engineer' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY 
    conteo_demanda DESC
LIMIT 5
```
|skills |conteo_demanda
|-------|-------------
|sql    |14213
|python |13893
|aws    |8570
|azure  |6997
|spark  |6612

### Insights: 
1. **La competencia clave:** Vuelve a liderar la demanda **SQL** (14,213 menciones) y se destaca como esencial para los data engineers, lo cual indica que la capacidad de manejar y optimizar bases de datos es un requisito central en el rol.

2. **Lenguaje versátil:**  Siguiendo con **Python** (13,893 menciones) que está casi al nivel de SQL, lo que refleja su versatilidad en el análisis de datos, automatización de procesos y, en muchos casos, en el desarrollo de pipelines de datos.

3. **AWS vs. Azure en la Nube:** Considerand que **AWS** (8,570 menciones) y Azure (6,997 menciones) son las principales plataformas de computación en la nube solicitadas, podemos evidenciar la competencia entre ambas plataformas. El mercado busca un ingeniero de datos con experiencia en al menos una de ellas.

4. **Habilidad de Procesamiento:** Cerrando el top tenemos a **Spark** que destaca en habilidades en procesamiento de datos a gran escala y en tiempo real, necesarias en empresas que manejan grandes volúmenes de datos, tiene sentido que se halle debajo de **SQL y Python** ya que la **Spark** utiliza estos dos a una mayor velocidad de procesamiento y son por tanto, un prerrequisito de **Spark**.

### 3. Skills más demandadas para ser un analista de datos

Al igual que la Query anterior, junté la tabla de skills y de trabajos posteados pero esta vez filtrando los trabajos por la posición de **Científico de Datos** de esta forma pude contar y filtrar de mayor a menor, la cantidad de veces que las skills aparecen en las diferentes ofertas.

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
        job_title_short = 'Data Engineer' AND
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
*Este gráfico de barras muestra las compañías mencionadas en la primera consulta, la siguiente gráfica nos explica aquellas Skills demandadas por estas compañías*

![Frecuencia de habilidades en diferentes roles laborales](/assets/frecuencia_skills.png)
*Este gráfico de barras muestra las Skills de las compañías anteriores en orden de frecuencia de aparición, siendo las mas frecuentes: Python, Spark, Hadoop, Kafka y Scala. Esto indica su gran demanda en estos roles relacionados con **procesamiento de datos en tiempo real** (*Hadoop, Kafka*) y a gran escala con preferencias a lenguajes de **Big Data** (*Python, Scala, Apache Spark*) en ecosistemas escalables y distribuidos.

#### Y SQL, AWS y Azure? 
El hecho de que no figuren en las empresas con mejores salarios pero si en la mayoría de las ofertas de empleo sugiere que las mismas empresas confían en infraestructuras personalizadas o que busquen habilidades más especializadas dando por hecho el manejo de la nube como un prerrequisito.

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
    job_title_short = 'Data Engineer' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY 
    promedio_paga DESC
  LIMIT 5
--LIMIT 25
```
|top 5 skills   |promedio_paga
|---------|-------------
|assembly |$192,500
|mongo    |$182,223
|ggplot2  |$176,250
|rust     |$172,819
|clojure  |$170,867

### Insights:
1. **Assembly** lidera con el mayor promedio lo que sugiere que las empresas están dispuestas a pagar un alto salario por habilidades de bajo nivel que requieren un conocimiento profundo de hardware y optimización de sistemas, típicamente necesarias en sectores como el desarrollo de sistemas embebidos y aplicaciones de alto rendimiento.

2. Demanda de Tecnologías Especializadas y Poco Comunes. **Rust** y **Clojure** son lenguajes menos comunes en comparación con otros lenguajes de programación populares. La alta paga para estos lenguajes puede deberse a una compesanción de las empresas hacia la escasez de expertos en estas tecnologías, destacando la importancia de habilidades de nicho y que ofrecen soluciones seguras y concurrentes (en el caso de **Rust**) y programación funcional avanzada (en el caso de **Clojure**).

3. Creciente valor de las bases de datos NoSQL. **MongoDB** además es la única en la lista indicando que las empresas valoran su alto rendimiento y flexibilidad en sus aplicaciones con datos no estructurados.

4. Herramientas de visualización avanzada. Comunmente utilizada en R, **ggplot2** presenta alta remuneración económica debido a su capacidad de generar visualizaciones de datos complejos. Las empresas valoran quienes dominen esta herramienta para la toma de decisiones fundamentada en data. 

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
        job_title_short = 'Data Engineer' AND
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
        job_title_short = 'Data Engineer' AND
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
| skill_id | skills     | conteo_demanda | promedio_paga |
| -------- | ---------- | -------------- | ------------- |
| 0        | sql        | 568            | $129,191        |
| 1        | python     | 535            | $132,200        |
| 76       | aws        | 367            | $132,865        |
| 74       | azure      | 254            | $129,574        |
| 92       | spark      | 237            | $139,838        |
| 80       | snowflake  | 202            | $134,373        |
| 96       | airflow    | 151            | $138,518        |
| 78       | redshift   | 141            | $132,980        |
| 4        | java       | 139            | $138,087        |
| 98       | kafka      | 134            | $150,549        |
| 75       | databricks | 130            | $130,072        |
| 3        | scala      | 113            | $141,777        |
| 97       | hadoop     | 98             | $137,707        |
| 2        | nosql      | 93             | $136,430        |
| 61       | sql server | 82             | $121,364        |
| 81       | gcp        | 76             | $133,388        |
| 182      | tableau    | 76             | $115,246        |
| 210      | git        | 74             | $128,352        |
| 183      | power bi   | 65             | $116,949        |
| 95       | pyspark    | 64             | $139,428        |
| 214      | docker     | 64             | $134,286        |
| 79       | oracle     | 63             | $121,980        |
| 194      | ssis       | 61             | $115,272        |
| 5        | r          | 60             | $121,065        |
| 213      | kubernetes | 56             | $158,190        |
### Insights:
1. **Python y SQL** como competencias esenciales: **Python** (535 menciones, $132,200) y **SQL** (568 menciones, $129,191) son altamente demandadas y tienen buenos salarios, lo que indica que siguen siendo habilidades fundamentales para roles en datos. La combinación de demanda y buena paga sugiere que estas habilidades son esenciales para casi cualquier posición de análisis o ingeniería de datos.

2. **Kafka y Kubernetes**: Altas paga con demanda moderada: Aunque **Kafka** ($150,549) y **Kubernetes** ($158,190) tienen una demanda más baja (134 y 56 menciones respectivamente), su alta paga indica que estas habilidades técnicas avanzadas son muy valoradas por las empresas. Esto sugiere que los roles que requieren experiencia en sistemas distribuidos y contenedores están bien remunerados y reflejan una especialización avanzada.

3. **Spark y Airflow** en procesamiento de datos avanzado: **Spark** (237 menciones, $139,838) y **Airflow** (151 menciones, $138,518) son demandados y ofrecen salarios competitivos, lo que refleja la necesidad de habilidades en procesamiento y gestión de flujos de trabajo de datos a gran escala. Esto muestra que las empresas buscan optimizar sus pipelines de datos y están dispuestas a invertir en habilidades de procesamiento distribuido y automatización.

# Conclusiones 

## Insights

### 1. Puestos mejor pagados para un ingeniero de datos en remoto

 Las posiciones de Data Engineer son de las mejor remuneradas en el mundo del Big Data y las empresas están dispuestas a ofrecer jugosos salarios por aquellos con conocimientos demostrables de sus skills relevantes.

### 2. Skills requeridas para estos puestos de trabajo

**SQL** es el pilar indiscutible para un ingeniero de datos, por lo que esta skill debe dominarse antes de avanzar siquiera con los demás lenguaje de programación. Las herramientas de espacios colaborativos en la nube son más comunes que nunca por lo que también es necesario saber operar en ellos y por último tener conocimientos de herramientas de procesamiento de datos a gran escala. Abarcando así y de manera satisfactoria la mayor parte de las demandas de habilidad del mercado laboral de un Data Engineer.

### 3. Skills más demandadas para ser un ingeniero de datos

Las empresas con los mejores salarios exigen un control en entornos colaborativos y herramientas de procesamiento, junto con un dominio de lenguajes de programación orientada a objetos. Es decir, pagan mejor a aquellos ingenieros de datos que procesan datos en tiempo real efectivamente, pues estos entornos escalables si no están optimizados cuestan mas dinero para la empresa.

### 4. Skills asociadas a un mayor salario

El mercado tecnológico recompensa generosamente a los ingenieros de datos que sean capaces de asegurar la estructura de los pipelines, tengan conocimiento de hardware y que sean capaces de comunicar información de datos complejos de manera efectiva. Mayor responsabilidad, mayor paga.

### 5. Skills óptimas para aprender

Las habilidades óptimas combinan conocimientos amplios en programación y bases de datos con capacidades específicas en infraestructura de datos avanzada. Esto sugiere que las empresas están dispuestas a pagar salarios elevados para roles que, además de cubrir lo básico, añaden valor a través de la capacidad de escalar, automatizar y optimizar el procesamiento de datos a gran escala.

## Pensamientos finales

En el camino de un ingeniero de datos vale más tener una sólida base de **SQL y Python** para el manejo de bases de datos. Luego escoger espacios en la nube como **AWS, Azure o GCP** y  dominar frameworks como **Hadoop o Apache Spark** después de tener una sólida base de conocimientos de las anteriores skills y por último me especializaría en sistemas distribuidos como **Kafka**. Ese sería mi camino de éxito.