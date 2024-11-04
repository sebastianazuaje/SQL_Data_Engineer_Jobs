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
    conteo_demanda DESC,
    promedio_paga DESC  
LIMIT 25
