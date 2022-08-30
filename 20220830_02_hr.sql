SELECT USER
FROM DUAL;
-- HR


-- ▼ EMPLOYEES 테이블의 직원들 SALARY를 10% 인상한다.
--    단, 부서명이 'IT'인 직원들만 한정한다.
--    (변경에 대한 결과 확인후 ROLLBACK 수행한다.)
SELECT *
FROM EMPLOYEES
WHERE SUBSTR(JOB_ID, 1, 2) = 'IT';

-- 인상
UPDATE EMPLOYEES
SET SALARY = SALARY * 1.1
WHERE SUBSTR(JOB_ID, 1, 2) = 'IT';

/* 선생님 풀이 -----------------------------------------------------------------

SELECT FIRST_NAME, LAST_NAME, SALARY, SALARY * 1.1 "10% 인상급여", DEPARTMENT_ID
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


-- ▼ EMPLOYEES 테이블에서 JOB_TITLE이 Sales Manager인 사원들의
--    SALARY를 해당 직무(직종)의 최고급여(MAX_SALARY)로 수정한다.
--    단, 입사일이 2006년 이전(해당 년도 제외) 입사자에 한해 적용할 수 있도록 처리한다.
--    (변경에 대한 결과 확인 후 ROLLBACK 수행한다.)
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


-- ▼ EMPLOYEES 테이블에서 SALARY를
--    각 부서의 이름별로 다른 인상률을 적용하여 수정할 수 있도록 한다.
--    Finance → 10% 인상
--    Executive → 15% 인상
--    Accounting → 20% 인상
--    (변경에 대한 결과 확인 후 ROLLBACK)
SELECT *
FROM EMPLOYEES;
SELECT *
FROM DEPARTMENTS;

/* 내 풀이...
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

-- ① --------------------------------------------------------------------------

-- Finance의 부서 아이디
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Finance';
-- 100

-- Executive 부서 아이디
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Executive';
-- 90

-- Finance의 부서 아이디
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

-- ② 메모리를 덜 소모하는 방식 ------------------------------------------------

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


--■■■ DELETE ■■■--

-- 1. 테이블에서 기존 데이터를 삭제하는 구문

-- 2. 형식 및 구조
--    DELETE
--    FROM 테이블명
--    [WHERE 조건절]


-- ▼ EMPLOYEES 테이블에서 직원들의 데이터를 삭제한다.
--    단, 부서명이 'IT'인 경우로 한정한다.

--    실제로는 EMPLOYEES 테이블의 데이터가 (삭제하고자 하는 대상 데이터)
--    다른 레코드에 의해 참조당하고 있는 경우
--    삭제되지 않을 수도 있다는 사실을 염두해야 하며,
--    그에 대한 이유도 알아야 한다.
SELECT *
FROM EMPLOYEES;
SELECT *
FROM DEPARTMENTS;

DELETE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');
-- 에러 발생 : ORA-02292: integrity constraint (HR.DEPT_MGR_FK) violated - child record found


--------------------------------------------------------------------------------


--■■■ 뷰(VIEW) ■■■--

-- 1. 뷰(VIEW)란 이미 특정한 데이터베이스 내에 존재하는
--    하나 이상의 테이블에서 사용자가 얻기 원하는 데이터들만을
--    정확하고 편하게 가져오기 위하여 사전에 원하는 컬럼들만을 모아서
--    만들어놓은 가상의 테이블로 편의성 및 보안에 목적이 있다.

--    가상의 테이블이랑... 뷰가 실제로 존재하는 테이블(객체)이 아니라
--    하나 이상의 테이블에서 파생된 또 다른 정보를 볼 수 있는 방법이며
--    그 정보를 추출해내는 SQL 문장이라고 볼 수 있다.

-- 2. 형식 및 구조
--    CREATE [OR REPLACE] VIEW 뷰이름
--    [(ALIAS[, ALIAS, ...])]
--    AS
--    서브쿼리(SUBQUERY)
--    [WITH CHECK OPTION]
--    [WITH READ ONLY]


-- ▼ 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VIEW_EMPLOYEES
AS
SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY
     , C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
  AND D.LOCATION_ID = L.LOCATION_ID
  AND L.COUNTRY_ID = C.COUNTRY_ID
  AND C.REGION_ID = R.REGION_ID;
-- View VIEW_EMPLOYEES이(가) 생성되었습니다.

-- 조회
SELECT *
FROM VIEW_EMPLOYEES;

-- ▼ 뷰(VIEW)의 구조 조회
DESC VIEW_EMPLOYEES;
/*
이름              널?       유형           
--------------- -------- ------------ 
FIRST_NAME               VARCHAR2(20) 
LAST_NAME       NOT NULL VARCHAR2(25) 
DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
CITY            NOT NULL VARCHAR2(30) 
COUNTRY_NAME             VARCHAR2(40) 
REGION_NAME              VARCHAR2(25) 
*/


-- ▼ 뷰(VIEW) 소스 확인
SELECT *
FROM USER_VIEWS
WHERE VIEW_NAME = 'VIEW_EMPLOYEES';
/*
-- TEXT▷
"SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY
     , C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
  AND D.LOCATION_ID = L.LOCATION_ID
  AND L.COUNTRY_ID = C.COUNTRY_ID
  AND C.REGION_ID = R.REGION_ID"
*/


















