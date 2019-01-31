docker build . -t mbreault-airflow --build-arg AIRFLOW_RDS_DEFAULT=$AIRFLOW_RDS_DEFAULT

docker run -p 8080:8080 --rm --name airflow_container  mbreault-airflow
