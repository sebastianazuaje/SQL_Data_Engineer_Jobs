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
        job_title_short = 'Data Scientist' AND
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