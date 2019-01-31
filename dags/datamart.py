from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.hooks.postgres_hook import PostgresHook
from datetime import datetime, timedelta
import os

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2019, 1, 31),
    'email': ['mbreault@embersilk.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
}

def process(**kwargs):
    conn_id = kwargs.get('conn_id')
    pg_hook = PostgresHook(conn_id)
    path = os.environ['AIRFLOW_HOME'] + '/scripts/rollup.sql'
    print(path)
    fd = open(path, 'r')
    sql = fd.read()
    fd.close()
    pg_hook.run(sql)

dag = DAG('datamart', default_args=default_args, schedule_interval=timedelta(days=1))

t1 = PythonOperator(
    task_id='process',
    op_kwargs = {'conn_id':'rds_default'},
    python_callable=process,
    dag=dag)
