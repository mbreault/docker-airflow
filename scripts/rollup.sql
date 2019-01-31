-- log execution
INSERT INTO executions(execution_datetime) SELECT NOW();

-- aggregate executions by date
INSERT INTO execution_summary(execution_date,count_of_executions)
SELECT CAST(execution_datetime AS DATE) as execution_date,COUNT(0) as count_of_executions 
FROM executions group by execution_date
ON CONFLICT (execution_date) DO UPDATE SET count_of_executions = excluded.count_of_executions;