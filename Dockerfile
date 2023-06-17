FROM python:latest
# supervisord setup                       
RUN apt-get update && apt-get install -y supervisor                       
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Airflow setup
ARG AIRFLOW_RDS_DEFAULT                       
ENV AIRFLOW_HOME=/app/airflow
ENV AIRFLOW_GPL_UNIDECODE yes

RUN pip install wheel
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install psycopg2-binary
RUN pip install apache-airflow[celery]

COPY dags /app/airflow/dags 
COPY scripts /app/airflow/scripts 

EXPOSE 8080
CMD ["/usr/bin/supervisord"]