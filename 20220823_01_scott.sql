SELECT USER
FROM DUAL;
-- SCOTT


-- 선생님 풀이
-- ▼ 지금까지 주문 받은 데이터를 통해
--    제품별 총 주문량을 조회할 수 있는 쿼리문을 구성한다.
SELECT T.JECODE "제품코드", SUM(T.JUSU) "주문수량"
FROM
(
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JECODE, JUSU
    FROM TBL_JUMUN
) T
GROUP BY T.JECODE;
/*
꼬북칩	30
꼬깔콘	20
치토스	20
맛동산	70
새우깡	10
웨하스	20
에이스	40
포카칩	20
스윙칩	20
오감자	30
사또밥	20
빼빼로	110
오레오	30
감자깡	40
홈런볼	40
다이제	10
죠리퐁	10
포스틱	40
*/


-- ▼ INTERSCET / MINUS (교집합과 차집합)

-- TBL_JUMUNBACKUP 테이블과 TBL_JUMUN 테이블에서
-- 제품코드와 주문수량의 값이 똑같은 행만 추출하고자 한다.
SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
INTERSECT
SELECT JECODE, JUSU
FROM TBL_JUMUN;
/*
감자깡	20
맛동산	30
홈런볼	10
*/
-- ▷ 차집합 영역을 출력

SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
MINUS
SELECT JECODE, JUSU
FROM TBL_JUMUN;
/*
꼬깔콘	20
꼬북칩	20
다이제	10
빼빼로	10
사또밥	20
새우깡	10
스윙칩	20
오감자	20
오레오	10
죠리퐁	10
치토스	20
포스틱	10
포스틱	20
포카칩	20
*/
-- ▷ 차집합을 제외한 영역을 출력


-- ▼ TBL_JUMUNBACKUP 테이블과 TBL_JUMUN 테이블을 대상으로
--    제품코드와 주문량의 값이 똑같은 행의 정보를
--    주문번호, 제품코드, 주문량, 주문일자 항목으로 조회한다.

-- 영준님 풀이
SELECT T1.JUNO "주문번호", T2.JECODE "제품코드", T2.JUSU "주문량", T1.JUDAY "주문일자"
FROM
(
    SELECT *
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT *
    FROM TBL_JUMUN
) T1
RIGHT JOIN
(
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
    INTERSECT
    SELECT JECODE, JUSU
    FROM TBL_JUMUN
) T2
ON T1.JECODE = T2.JECODE
WHERE T1.JUSU = T2.JUSU;

-- 나는 SELECT문 안에 SELECT문 넣으려고 하다가 실패...
-- ▷ 이렇게 처리하면 단일행이 출력되어야 하는 곳에서 다중행이 출력되어
--    오라클이 출력하지 못하는 듯 함
--    에러 발생 : ORA-01427: single-row subquery returns more than one row

-- 선생님 풀이 -----------------------------------------------------------------

-- 방법①
-- 영준님 풀이와 동일

-- 방법②
/*
SELECT T.*
FROM
(
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUN
) T
WHERE T.JECODE IN ('감자깡', '맛동산', '홈런볼')
  AND T.JUSU IN (20, 30, 10);
-- ▷ 제품명과 주문수량이 매칭되지 않아 맛동산10도 함께 출력되는 문제 발생
*/

SELECT T.*
FROM
(
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUN
) T
WHERE CONCAT(T.JECODE, T.JUSU) IN ('감자깡20', '맛동산30', '홈런볼10');

--                                 ▽▽▽

SELECT T.*
FROM
(
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUN
) T
WHERE CONCAT(T.JECODE, T.JUSU) IN (SELECT CONCAT(JECODE, JUSU)
                                   FROM TBL_JUMUNBACKUP
                                   INTERSECT
                                   SELECT CONCAT(JECODE, JUSU)
                                   FROM TBL_JUMUN);


--------------------------------------------------------------------------------


-- ▼ JOIN + (NATURAL JOIN)

SELECT D.DEPTNO, D.DNAME, E.ENAME, E.SAL
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
/*
10	ACCOUNTING	CLARK	2450
10	ACCOUNTING	KING	5000
10	ACCOUNTING	MILLER	1300
20	RESEARCH	JONES	2975
20	RESEARCH	FORD	3000
20	RESEARCH	ADAMS	1100
20	RESEARCH	SMITH	 800
20	RESEARCH	SCOTT	3000
30	SALES	    WARD	1250
30	SALES	    TURNER	1500
30	SALES	    ALLEN	1600
30	SALES	    JAMES	 950
30	SALES	    BLAKE	2850
30	SALES	    MARTIN	1250
*/

SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP E JOIN DEPT D;
-- 에러 발생 : ORA-00905: missing keyword

SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP E NATURAL JOIN DEPT D;
/*
10	ACCOUNTING	CLARK	2450
10	ACCOUNTING	KING	5000
10	ACCOUNTING	MILLER	1300
20	RESEARCH	JONES	2975
20	RESEARCH	FORD	3000
20	RESEARCH	ADAMS	1100
20	RESEARCH	SMITH	 800
20	RESEARCH	SCOTT	3000
30	SALES	    WARD	1250
30	SALES	    TURNER	1500
30	SALES	    ALLEN	1600
30	SALES	    JAMES	 950
30	SALES	    BLAKE	2850
30	SALES	    MARTIN	1250
*/
-- ▶ 오라클이 둘 사이의 연결고리, 참조 테이블 등 필요한 요소를 모두 골라준다.
--    (리소스 소모가 크다)


SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP E JOIN DEPT D
USING(DEPTNO);
/*
10	ACCOUNTING	CLARK	2450
10	ACCOUNTING	KING	5000
10	ACCOUNTING	MILLER	1300
20	RESEARCH	JONES	2975
20	RESEARCH	FORD	3000
20	RESEARCH	ADAMS	1100
20	RESEARCH	SMITH	 800
20	RESEARCH	SCOTT	3000
30	SALES	    WARD	1250
30	SALES	    TURNER	1500
30	SALES	    ALLEN	1600
30	SALES	    JAMES	 950
30	SALES	    BLAKE	2850
30	SALES	    MARTIN	1250
*/


--------------------------------------------------------------------------------


-- ▼ TBL_EMP 테이블에서 급여가 가장 많은 사원의
--    사원번호, 사원명, 직종명, 급여 항목을 조회하는 쿼리문을 작성한다.
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여"
FROM TBL_EMP
WHERE SAL IN (SELECT MAX(SAL)
              FROM TBL_EMP);
-- 7839	KING	PRESIDENT	5000

-- 『=ANY』
SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL >=ANY (800, 1600, 1250, 2975, 1250, 2850, 2450, 3000, 5000, 1500, 1100, 950, 3000, 1300, 1500, 2000, 1700, 2500, 1000);
-- ▷ 조건이 없는 것과 다름 없음!

-- ▼ 『=ALL』
SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL >=ALL (800, 1600, 1250, 2975, 1250, 2850, 2450, 3000, 5000, 1500, 1100, 950, 3000, 1300, 1500, 2000, 1700, 2500, 1000);

SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL >=ALL (SELECT SAL
                 FROM TBL_EMP);
-- ▶ 모든 급여보다 크거나 같아야 하기 때문에 가장 큰 값 하나만 나온다.


-- ▼ TBL_EMP 테이블에서 20번 부서에 근무하는 사원들 중
--    급여가 가장 많은 사원의
--    사원번호, 사원명, 직종명, 급여 항목을 조회하는 쿼리문을 구성한다.
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM TBL_EMP
WHERE DEPTNO = 20
  AND SAL >= ALL (SELECT SAL
                  FROM TBL_EMP
                  WHERE DEPTNO = 20);
/*
7902	    FORD	ANALYST	3000	20
7788	SCOTT	ANALYST	3000	20
*/


-- ▼ TBL_EMP 테이블에서 수당(커미션, COMM)이 가장 많은 사원의
--    사원번호, 사원명, 부서번호, 직종명, 커미션 항목을 조회한다.
SELECT EMPNO, ENAME, DEPTNO, JOB, NVL(COMM, 0)
FROM TBL_EMP
WHERE COMM >=ALL (SELECT NVL(COMM, 0)
                  FROM TBL_EMP);

SELECT EMPNO, ENAME, DEPTNO, JOB, NVL(COMM, 0)
FROM TBL_EMP
WHERE COMM >=ALL (SELECT MAX(COMM)
                  FROM TBL_EMP);
-- ▷ MAX() 함수는 NULL 값을 제외하고 연산하기 때문에 NVL 필요 X

SELECT EMPNO, ENAME, DEPTNO, JOB, NVL(COMM, 0)
FROM TBL_EMP
WHERE COMM >=ALL (SELECT COMM
                  FROM TBL_EMP
                  WHERE COMM IS NOT NULL);


-- ▼ DISTINCT()
--    중복 행(레코드)을 제거하는 함수

-- ▼ TBL_EMP 테이블에서 관리자로 등록된 사원의
--    사원번호, 사원명, 직종명을 조회한다.
SELECT EMPNO, ENAME, JOB
FROM TBL_EMP
WHERE EMPNO IN (SELECT MGR
                FROM TBL_EMP);

-- 중복값 제거 (리소스 소모 ↓)
SELECT EMPNO, ENAME, JOB
FROM TBL_EMP
WHERE EMPNO IN (SELECT DISTINCT(MGR)
                FROM TBL_EMP);
/*
7902	    FORD	ANALYST
7698	BLAKE	MANAGER
7839	KING	PRESIDENT
7566	JONES	MANAGER
7788	SCOTT	ANALYST
7782	CLARK	MANAGER
*/


--------------------------------------------------------------------------------


-- ▼ TBL_SAWON 테이블 백업(데이터 위주) → 각 테이블 간의 관계나 제약조건 등은 제외
CREATE TABLE TBL_SAWONBACKUP
AS
SELECT *
FROM TBL_SAWON;
-- Table TBL_SAWONBACKUP이(가) 생성되었습니다.
-- ▷ TBL_SAWON 테이블의 데이터들만 백업을 수행
--    즉, 다른 이름의 테이블 형태로 저장해 둔 상황


-- ▼ 데이터 수정 (WHERE - SET 순으로 작성)
/*
UPDATE TBL_SAWON
SET SANAME = '똘똘이'
WHERE SANO = 1005;
*/

-- ▼ 잘못 바꾼 데이터(이름) 수정
/*
UPDATE TBL_SAWON
SET SANAME = (SELECT SANO, SANAME
              FROM TBL_SAWONBACKUP
              WHERE SANO = TBL_SAWON.SANO)
WHERE SANAME = '똘똘이';
*/












