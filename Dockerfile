FROM python:3.6.3
# supervisord setup                       
RUN apt-get update && apt-get install -y supervisor                       
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Airflow setup
ARG AIRFLOW_RDS_DEFAULT                       
ENV AIRFLOW_HOME=/app/airflow
ENV AIRFLOW_GPL_UNIDECODE yes

RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install psycopg2-binary
RUN pip install apache-airflow[crypto,postgres]

COPY dags /app/airflow/dags 
COPY scripts /app/airflow/scripts 

RUN airflow initdb
RUN airflow connections --add --conn_id rds_default --conn_uri ${AIRFLOW_RDS_DEFAULT}
EXPOSE 8080
CMD ["/usr/bin/supervisord"]