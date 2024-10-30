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

