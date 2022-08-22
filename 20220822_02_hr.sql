SELECT USER
FROM DUAL;
-- HR


-- �� �� �� �̻��� ���̺� ����(JOIN)

-- �� SQL 1992 CODE
/*
SELECT ���̺��1.�÷���, ���̺��2.�÷���, ���̺��3.�÷���
FROM ���̺��1, ���̺��2, ���̺��3
WHERE ���̺��1.�÷���1 = ���̺��2.�÷���1
  AND ���̺��2.�÷���2 = ���̺��3.�÷���2;
*/

-- �� SQL 1999 CODE
/*
SELECT ���̺��1.�÷���, ���̺��2.�÷���, ���̺��3.�÷���
FROM ���̺��1 JOIN ���̺��2
ON ���̺��1.�÷���1 = ���̺��2.�÷���1
        JOIN ���̺��3
        ON ���̺��2.�÷���2 = ���̺��3.�÷���2;
*/


-- HR���� ������ ���̺� �Ǵ� �� ��� ��ȸ
SELECT *
FROM TAB;
/*
COUNTRIES	        TABLE	
DEPARTMENTS	        TABLE	
EMPLOYEES	        TABLE	
EMP_DETAILS_VIEW	VIEW	
JOBS	            TABLE	
JOB_HISTORY	        TABLE	
LOCATIONS	        TABLE	
REGIONS	            TABLE	
*/


-- �� HR.JOBS, HR.EMPLOYEES, HR.DEPARTMENTS ���̺��� ������� �������� �����͸�
--    FIRST_NAME, LAST_NAME, JOB_TITLE, DEPARTMENT_NAME �׸����� ��ȸ�Ѵ�.
--           EMPLOYEES          JOBS      DEPARTMENTS

/* ������ �ؼ�

SELECT *
FROM DEPARTMENTS;
-- DEPARTMENTS_ID (�����÷�)
SELECT *
FROM DEPARTMENTS;
-- JOB_ID         (�����÷�)
SELECT *
FROM DEPARTMENTS;

*/

SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME
FROM HR.JOBS J RIGHT JOIN HR.EMPLOYEES E
ON J.JOB_ID = E.JOB_ID
        LEFT JOIN HR.DEPARTMENTS D
        ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;


-- �� EMPLOYEES, DEPARTMENTS, JOBS, LOCATIONS, COUNTRIES, REGIONS ���̺��� �������
--    �������� �����͸� ������ ���� ��ȸ�Ѵ�.
--    FIRST_NAME, LAST_NAME, JOB_TITLE, DEPARTMENT_NAME, CITY,  COUNTRY_NAME, REGION_NAME
--          EMPLOYEES           JOBS      DEPARTMENTS  LOCATIONS  COUNTRIES     REGIONS

DESC JOBS;
-- JOB_ID
DESC EMPLOYEES;
-- DEPARTMENT_ID
DESC DEPARTMENTS;
-- LOCATION_ID
DESC LOCATIONS;
-- COUNTRY_ID
DESC COUNTRIES;
-- REGION_ID
DESC REGIONS;

SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME, L.CITY, C.COUNTRY_NAME, R.REGION_NAME
FROM JOBS J JOIN EMPLOYEES E
ON J.JOB_ID = E.JOB_ID
        LEFT JOIN DEPARTMENTS D
        ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
                LEFT JOIN LOCATIONS L
                ON D.LOCATION_ID = L.LOCATION_ID
                        LEFT JOIN COUNTRIES C
                        ON L.COUNTRY_ID = C.COUNTRY_ID
                                LEFT JOIN REGIONS R
                                ON C.REGION_ID = R.REGION_ID;
























