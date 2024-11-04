# Introducción
💻 Profundizando en el mercado laboral! Con un enfoque hacia el Data Scientist 📊 y sus puestos de trabajo en todo el mundo 🌐 este proyecto explora el Top 10 puestos de trabajo mejor pagados 💰, las habilidades informáticas más demandadas 🔥 e incluso las habilidades más óptimas mejores pagadas 📈 en análisis de datos.

Queries de SQL? echa un vistazo aquí: [SQL_projects](/Tech_jobs_SQL/)

# Antecedentes
Esta es una continuación de mi proyecto anterior "SQL Data Analyst Jobs" en el que busqué desvelar las habilidades necesarias y entender mi situación en el mercado a la hora de exigir un salario como analista de datos. Sin embargo, mi formación es la de un data scientist y por lo tanto, realicé queries relevantes para entender las habilidades, remuneración económica y demanda en el mercado laboral partiendo del objetivo de convertirme en data scientist. 

### Con mis queries busco responder las siguientes preguntas:

1. Cuáles son los puestos mejor pagados para un científico de datos en remoto?
2. Cuáles son las skills requeridas para estos puestos de trabajo?
3. Cuáles son las skills más demandadas para ser un científico de datos?
4. Cuáles skills están asociadas a un mayor salario?
5. Cuáles son las skills óptimas para aprender?

# Herramientas que utilicé
Para mi análisis profundo en el mercado laboral de los científicos de datos recurrí a varias herramientas:

- *Visual Studio Code:* Mi herramienta preferida para trabajar en ambientes virtualesy manejar distintos lenguajes de programación, en este caso para ejecutar mis queries.

- *PostgreSQL:* El gestor de base de datos que más domino, ideal para una base de datos tan grande como esta.

- *Git y Github:* Esencial para el manejo de versiones y compartir mis Scripts SQL y mis análisis.

- *ChatGPT:* IA para interpretación de los JSON resultado de la Query e investigación en simultáneo de las skills desconocidas.

# El análisis
Cada una de las queries busca abordar aspectos diferentes del mercado laboral de un científico de datos. Así abordé las preguntas:

### 1. Puestos mejor pagados para un científico de datos en remoto

Para identificar el **top 10** puestos de trabajo **mejor pagados** filtré las posiciones de científico de datos **(Data Scientist)** por el salario medio anual y por la ubicación, enfocado también en trabajos **en remoto**. Esta Query resalta las oportunidades mejor pagadas en el campo.

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
    job_title_short = 'Data Scientist' AND
    job_location IN ('Anywhere') AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10
```
### Insights:
![Top 10 trabajos por compañía](/assets/Top_10_trabajos_company.png)
*Este gráfico muestra el top 10 de compañías a nivel mundial que mejor pagan la posición de **Científico de datos** o que lo incluyen en su descripción del puesto. Las posiciones en cuestión son en **Remoto.***
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
    job_title_short = 'Data Scientist' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY 
    conteo_demanda DESC
LIMIT 5
```
|skills |conteo_demanda
|-------|-------------
|python |10390
|sql    |7488
|r      |4674
|aws    |2593
|tableau|2458

### Insights: 
1. **Python y R lideran de manera destacada** Con 10,390 menciones, **Python** es la habilidad más demandada, superando ampliamente a otras. Esto reafirma que es el lenguaje de programación esencial y predominante en el campo de la ciencia de datos, probablemente debido a su versatilidad y extensas bibliotecas especializadas como **Pandas, NumPy y Scikit-learn**. **R** sin embargo, con 4,674 sigue teniendo relevancia en el sector académico y de investigación. Su demanda es significativamente menor comparada con **Python y SQL**, lo que podría indicar un uso más especializado en comparación con **Python**.

2. **SQL sigue siendo crítico:**  Con 7,488 menciones, **SQL** es la segunda habilidad más demandada, lo que resalta la importancia de la gestión y consulta de bases de datos. Los empleadores buscan candidatos que puedan manipular y analizar grandes volúmenes de datos almacenados en **bases de datos relacionales**.

3. **Plataformas de nube y visualización de datos:**. **AWS** (2,593 menciones) y **Tableau** (2,458 menciones) muestran una demanda relevante, lo que sugiere que los empleadores valoran las competencias en infraestructura en la nube y la capacidad de comunicar hallazgos a través de visualización de datos. Esto indica una tendencia hacia la necesidad de habilidades complementarias que permitan gestionar datos en entornos escalables y presentar resultados de manera efectiva.

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
*Este gráfico de barras muestra el salario promedio de cada empresa en el conjunto de datos. Selby Jennings tuvo el promedio más alto, seguida de Algo Capital Group, Teramid, Lawrence Harvey y Storm4.*

![Frecuencia de habilidades en diferentes roles laborales](/assets/frecuencia_skills.png)
*Este gráfico de barras muestra las habilidades mencionadas con más frecuencia en diferentes roles laborales. Python, SQL, AWS, Pytorch y Tensorflow como las habilidades más comunes en estas empresas, lo que indica su gran demanda en estos roles relacionados con **ETL** de **bases de datos relacionales** y modelos de **Machine Learning**.*

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
    job_title_short = 'Data Scientist' AND
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
|gdpr     |$217,738
|golang   |$208,750
|atlassian|$189,700
|selenium |$180,000
|opencv   |$172,500

### Insights:
1. Encuanto al desarrollo y progracmación  **Golang** es ideal para la creación de aplicaciones escalables y de alto rendimiento, mientras que **OpenCV** se usa en aplicaciones de visión por computadora. Ambas habilidades requieren un conocimiento profundo de la programación y son valoradas en proyectos de **IA**, robótica y sistemas de backend eficientes.

2. Se remunera la automatización y prueba de software. **Selenium** se asocia con la automatización de pruebas, lo cual es fundamental para asegurar la calidad del software en entornos de desarrollo ágil. Esta habilidad complementa otras habilidades de desarrollo al permitir la verificación automática de funcionalidades en aplicaciones web, mejorando la productividad y reduciendo errores manuales.

3. Alta Paga por una buena gestión de datos. **GDPR** se enfoca en la protección de datos y la privacidad, un área de creciente importancia para cualquier empresa que maneje información personal. La implementación de estándares de cumplimiento es esencial para mantener la confianza del cliente y evitar sanciones legales, lo que explica su alta remuneración.

4. Las herramientas de colaboración de **Atlassian** están asociadas a la gestión de proyectos en equipos, integrando aspectos de planificación y seguimiento de tareas. Esta habilidad es crucial para empresas que buscan gestionar proyectos de desarrollo de software de forma eficiente, vinculando equipos de desarrollo con procesos de control de calidad, utilizando **Selenium** por ejemplo, y **Jira** para la planificación.

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
        job_title_short = 'Data Scientist' AND
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
        job_title_short = 'Data Scientist' AND
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
| skill_id | Top 25 skills| conteo_demanda | promedio_paga |
| -------- | ------------ | -------------- | ------------- |
| 1        | python       | 763            | $143,828        |
| 0        | sql          | 591            | $142,833        |
| 5        | r            | 394            | $137,885        |
| 182      | tableau      | 219            | $146,970        |
| 76       | aws          | 217            | $149,630        |
| 92       | spark        | 149            | $150,188        |
| 99       | tensorflow   | 126            | $151,536        |
| 74       | azure        | 122            | $142,306        |
| 101      | pytorch      | 115            | $152,603        |
| 93       | pandas       | 113            | $144,816        |
| 186      | sas          | 110            | $129,920        |
| 7        | sas          | 110            | $129,920        |
| 97       | hadoop       | 82             | $143,322        |
| 106      | scikit-learn | 81             | $148,964        |
| 181      | excel        | 77             | $129,224        |
| 94       | numpy        | 73             | $149,089        |
| 80       | snowflake    | 72             | $152,687        |
| 183      | power bi     | 72             | $131,390        |
| 4        | java         | 64             | $145,706        |
| 75       | databricks   | 63             | $139,631        |
| 81       | gcp          | 59             | $155,811        |
| 210      | git          | 58             | $132,599        |
| 8        | go           | 57             | $164,691        |
| 185      | looker       | 57             | $158,715        |
| 3        | scala        | 56             | $156,702        |

### Insights:
#### 1. Habilidades de Machine Learning e IA bien remuneradas:

- **PyTorch** ($152,603), **TensorFlow** ($151,536), y **scikit-learn** ($148,964) son destacadas en la lista de habilidades de machine learning con promedios de paga altos. Esto subraya la tendencia de la industria hacia la implementación y desarrollo de modelos de aprendizaje profundo y aprendizaje automático.

- **Looker** ($158,715) y **Power BI** ($131,390) destacan como herramientas de Business Intelligence que, aunque no tienen la demanda más alta, ofrecen buenos promedios de paga. Esto resalta la importancia creciente de las habilidades de visualización y análisis de datos para la toma de decisiones estratégicas en las empresas.

#### 2. Habilidades tradicionales con alta demanda:
- **Excel** ($129,224) y **SAS** ($129,920) tienen un menor promedio de paga en comparación con las tecnologías más modernas. Esto sugiere que, aunque siguen siendo útiles, su valor en el mercado está por debajo de las tecnologías más recientes y avanzadas.
- La demanda mas alta la protagonizan **Python**(763) y **SQL** (591) destacándose como esenciales en el ámbito de la ciencia de datos. Esto reafirma que las empresas priorizan la capacidad de manejar y analizar datos con herramientas versátiles (**Python**) y la habilidad para interactuar eficientemente con bases de datos (**SQL**). 

#### 3. Procesamiento de datos en la nube:
- **GCP (Google Cloud Platform)** y **Go** tienen las mayores cifras de promedio de paga con $155,811 y $164,691, respectivamente. Esto refleja una alta demanda y escasez de profesionales con experiencia en estas áreas, destacando su importancia en el desarrollo de infraestructuras escalables y sistemas de backend. 
- **AWS** ($149,630) y **Spark** ($150,188) muestran tanto alta demanda como un promedio de paga significativo, indicando que las empresas están dispuestas a pagar bien por habilidades que permiten manejar grandes volúmenes de datos y gestionar infraestructuras en la nube.

# Lo que aprendí

A lo largo del desarrollo de este proyecto me encontré con algunos desafíos que demandaron lo mejor de mí y de mis conocimientos, aquí algunas cosas aprendidas en el proceso:

- 🐅🐈**Parecidos pero no iguales:**
Las competencias de un ciéntifico de datos VS las de un analista de datos, tienen ciertas semjanzas como el indispensable manejo de **SQL, Python o R** y de las herramientas de visualización. Pero se tienden a especializar por la *gestión de datos en la nube* y el manejo de *modelos de machine learning* mas especializados.

- 🔒🔑**Complementación:**
Mientras que un analista de datos se encarga de interpretar y procesar los datos, muchas de las labores de los puestos de trabajo de un científico de datos tienen que ver con desarrollar herramientas que permitan procesar los mismos.

- 💆📂**De nuevo con SQL:**
Ya puedes ir corrigiendo esos *error en la query* porque **SQL** mantiene los mismos números en su demanda bien sea para un analista bien sea para un científico de datos.

# Conclusiones 

## Insights

### 1. Puestos mejor pagados para un científico de datos en remoto

 Las habilidades tradicionales siguen siendo fundamentales y son ampliamente demandadas, mientras que las competencias más avanzadas y especializadas pueden ofrecer mayores remuneraciones. Esto sugiere que, para maximizar el valor en el mercado laboral, los profesionales de la ciencia de datos deben combinar una base sólida en habilidades esenciales con el desarrollo de competencias especializadas que estén en crecimiento.

### 2. Skills requeridas para estos puestos de trabajo

**Python** y **SQL** son las habilidades más esenciales y demandadas, con Python liderando por su versatilidad y vasto ecosistema de bibliotecas especializadas, y **SQL** siendo indispensable para la gestión y consulta de bases de datos relacionales. Las habilidades en plataformas de nube como **AWS** y herramientas de visualización de datos como **Tableau** también son altamente valoradas, lo que evidencia la importancia de complementar las competencias de análisis con capacidades de manejo de infraestructuras escalables y presentación de datos.

### 3. Skills más demandadas para ser un científico de datos

En cuanto a la especialización, las skills obtienen una mayor demanda en cuanto se refiere a aquellas que permitan la creación de modelos de machine learning y herramientas que faciliten aplicaciones de métodos estadísticos avanzados a los datos.

### 4. Skills asociadas a un mayor salario

El mercado tecnológico actual premia la combinación de habilidades avanzadas en desarrollo y gestión de proyectos. Competencias en **Golang** y **OpenCV** son altamente valoradas por su aplicación en **IA** y sistemas escalables, mientras que la automatización de pruebas con **Selenium** es clave para mantener la calidad en entornos ágiles. La alta paga asociada a la protección de datos con **GDPR** refleja la importancia de la privacidad y cumplimiento legal. Además, las herramientas de colaboración de **Atlassian** destacan por su capacidad de coordinar equipos y optimizar la planificación y control de calidad, subrayando que la gestión eficaz de proyectos es tan vital como las habilidades técnicas.

### 5. Skills óptimas para aprender

Las habilidades en **Machine Learning e IA,** como **PyTorch** y **scikit-learn**, están bien remuneradas, reflejando la creciente implementación de modelos de aprendizaje profundo en la industria. Herramientas de Business Intelligence como **Looker** y **Power BI** también destacan, subrayando la importancia de la visualización de datos en la toma de decisiones empresariales. **AWS** y **Spark** son valoradas por su capacidad de manejar grandes volúmenes de datos en la nube. Por lo tanto, es óptimo aprender al menos una habilidad de cada par mencionado para satisfacer las demandas de los empleadores y a su vez recibir una buena remuneración. 

## Pensamientos finales

Después de haber analizado las skills necesarias para un científico de datos según el mercado laboral he llegado a la conclusión que se necesitan buenas bases de donde partir para el procesamiento de datos, esto se refleja en la alta demanda aunque baja remuneración de **Excel, Python y SQL** como bases indispensables y luego tomar un camino por la especialización en cuanto a gestión de datos en entornos colaborativos en la nube de **GCP o AWS**, dominio de **Spark** o **Pytorch**; skills que su baja demanda es inversamente proporcional a su remuneración económica por lo que parece. Estas demandas dependerán del modo en que opere la empresa empleadora, pero una vez conociendo una herramienta es más fácil adaptarse a otra. 