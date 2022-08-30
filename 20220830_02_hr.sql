SELECT USER
FROM DUAL;
-- HR


-- �� EMPLOYEES ���̺��� ������ SALARY�� 10% �λ��Ѵ�.
--    ��, �μ����� 'IT'�� �����鸸 �����Ѵ�.
--    (���濡 ���� ��� Ȯ���� ROLLBACK �����Ѵ�.)
SELECT *
FROM EMPLOYEES
WHERE SUBSTR(JOB_ID, 1, 2) = 'IT';

-- �λ�
UPDATE EMPLOYEES
SET SALARY = SALARY * 1.1
WHERE SUBSTR(JOB_ID, 1, 2) = 'IT';

/* ������ Ǯ�� -----------------------------------------------------------------

SELECT FIRST_NAME, LAST_NAME, SALARY, SALARY * 1.1 "10% �λ�޿�", DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');

Alexander	Hunold	    9000	9900	60
Bruce	    Ernst	    6000	6600	60
David	    Austin	    4800	5280	60
Valli	    Pataballa	4800	5280	60
Diana	    Lorentz	    4200	4620	60


UPDATE EMPLOYEES
SET SALARY = SALARY * 1.1
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');

*/

ROLLBACK;


-- �� EMPLOYEES ���̺��� JOB_TITLE�� Sales Manager�� �������
--    SALARY�� �ش� ����(����)�� �ְ�޿�(MAX_SALARY)�� �����Ѵ�.
--    ��, �Ի����� 2006�� ����(�ش� �⵵ ����) �Ի��ڿ� ���� ������ �� �ֵ��� ó���Ѵ�.
--    (���濡 ���� ��� Ȯ�� �� ROLLBACK �����Ѵ�.)
SELECT *
FROM EMPLOYEES;
SELECT *
FROM JOBS;

SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID
                FROM JOBS
                WHERE JOB_TITLE = 'Sales Manager');

UPDATE EMPLOYEES
SET SALARY = (SELECT MAX_SALARY
              FROM JOBS
              WHERE JOB_TITLE = 'Sales Manager')
WHERE JOB_ID = (SELECT JOB_ID
                FROM JOBS
                WHERE JOB_TITLE = 'Sales Manager')
  AND TO_NUMBER(TO_CHAR(HIRE_DATE, 'YYYY')) < 2006;

ROLLBACK;


-- �� EMPLOYEES ���̺��� SALARY��
--    �� �μ��� �̸����� �ٸ� �λ���� �����Ͽ� ������ �� �ֵ��� �Ѵ�.
--    Finance �� 10% �λ�
--    Executive �� 15% �λ�
--    Accounting �� 20% �λ�
--    (���濡 ���� ��� Ȯ�� �� ROLLBACK)
SELECT *
FROM EMPLOYEES;
SELECT *
FROM DEPARTMENTS;

/* �� Ǯ��...
SELECT CASE T.DEPARTMENT_NAME  WHEN 'Finance'      THEN SALARY  * 1.1
                               WHEN 'Executive'    THEN SALARY  * 1.15
                               WHEN 'Accounting'   THEN SALARY  * 1.2
                               ELSE SALARY
       END "SALARY"
FROM
(
SELECT *
FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
) T;
*/

-- �� --------------------------------------------------------------------------

-- Finance�� �μ� ���̵�
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Finance';
-- 100

-- Executive �μ� ���̵�
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Executive';
-- 90

-- Finance�� �μ� ���̵�
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Accounting';
-- 110


UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID  WHEN (SELECT DEPARTMENT_ID
                                       FROM DEPARTMENTS
                                       WHERE DEPARTMENT_NAME = 'Finance')
                                 THEN SALARY  * 1.1
                                 WHEN (SELECT DEPARTMENT_ID
                                       FROM DEPARTMENTS
                                       WHERE DEPARTMENT_NAME = 'Executive')
                                 THEN SALARY  * 1.15
                                 WHEN (SELECT DEPARTMENT_ID
                                       FROM DEPARTMENTS
                                       WHERE DEPARTMENT_NAME = 'Accounting')
                                 THEN SALARY  * 1.2
                                 ELSE SALARY
             END;

-- �� �޸𸮸� �� �Ҹ��ϴ� ��� ------------------------------------------------

UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID  WHEN (SELECT DEPARTMENT_ID
                                       FROM DEPARTMENTS
                                       WHERE DEPARTMENT_NAME = 'Finance')
                                 THEN SALARY  * 1.1
                                 WHEN (SELECT DEPARTMENT_ID
                                       FROM DEPARTMENTS
                                       WHERE DEPARTMENT_NAME = 'Executive')
                                 THEN SALARY  * 1.15
                                 WHEN (SELECT DEPARTMENT_ID
                                       FROM DEPARTMENTS
                                       WHERE DEPARTMENT_NAME = 'Accounting')
                                 THEN SALARY  * 1.2
                                 ELSE SALARY
             END
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME IN ('Finance', 'Executive', 'Accounting');

ROLLBACK;



--------------------------------------------------------------------------------


--���� DELETE ����--

-- 1. ���̺��� ���� �����͸� �����ϴ� ����

-- 2. ���� �� ����
--    DELETE
--    FROM ���̺��
--    [WHERE ������]


-- �� EMPLOYEES ���̺��� �������� �����͸� �����Ѵ�.
--    ��, �μ����� 'IT'�� ���� �����Ѵ�.

--    �����δ� EMPLOYEES ���̺��� �����Ͱ� (�����ϰ��� �ϴ� ��� ������)
--    �ٸ� ���ڵ忡 ���� �������ϰ� �ִ� ���
--    �������� ���� ���� �ִٴ� ����� �����ؾ� �ϸ�,
--    �׿� ���� ������ �˾ƾ� �Ѵ�.
SELECT *
FROM EMPLOYEES;
SELECT *
FROM DEPARTMENTS;

DELETE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');
-- ���� �߻� : ORA-02292: integrity constraint (HR.DEPT_MGR_FK) violated - child record found


--------------------------------------------------------------------------------


--���� ��(VIEW) ����--

-- 1. ��(VIEW)�� �̹� Ư���� �����ͺ��̽� ���� �����ϴ�
--    �ϳ� �̻��� ���̺��� ����ڰ� ��� ���ϴ� �����͵鸸��
--    ��Ȯ�ϰ� ���ϰ� �������� ���Ͽ� ������ ���ϴ� �÷��鸸�� ��Ƽ�
--    �������� ������ ���̺�� ���Ǽ� �� ���ȿ� ������ �ִ�.

--    ������ ���̺��̶�... �䰡 ������ �����ϴ� ���̺�(��ü)�� �ƴ϶�
--    �ϳ� �̻��� ���̺��� �Ļ��� �� �ٸ� ������ �� �� �ִ� ����̸�
--    �� ������ �����س��� SQL �����̶�� �� �� �ִ�.

-- 2. ���� �� ����
--    CREATE [OR REPLACE] VIEW ���̸�
--    [(ALIAS[, ALIAS, ...])]
--    AS
--    ��������(SUBQUERY)
--    [WITH CHECK OPTION]
--    [WITH READ ONLY]


-- �� ��(VIEW) ����
CREATE OR REPLACE VIEW VIEW_EMPLOYEES
AS
SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY
     , C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
  AND D.LOCATION_ID = L.LOCATION_ID
  AND L.COUNTRY_ID = C.COUNTRY_ID
  AND C.REGION_ID = R.REGION_ID;
-- View VIEW_EMPLOYEES��(��) �����Ǿ����ϴ�.

-- ��ȸ
SELECT *
FROM VIEW_EMPLOYEES;

-- �� ��(VIEW)�� ���� ��ȸ
DESC VIEW_EMPLOYEES;
/*
�̸�              ��?       ����           
--------------- -------- ------------ 
FIRST_NAME               VARCHAR2(20) 
LAST_NAME       NOT NULL VARCHAR2(25) 
DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
CITY            NOT NULL VARCHAR2(30) 
COUNTRY_NAME             VARCHAR2(40) 
REGION_NAME              VARCHAR2(25) 
*/


-- �� ��(VIEW) �ҽ� Ȯ��
SELECT *
FROM USER_VIEWS
WHERE VIEW_NAME = 'VIEW_EMPLOYEES';
/*
-- TEXT��
"SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY
     , C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
  AND D.LOCATION_ID = L.LOCATION_ID
  AND L.COUNTRY_ID = C.COUNTRY_ID
  AND C.REGION_ID = R.REGION_ID"
*/


















