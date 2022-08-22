SELECT USER
FROM DUAL;
-- SCOTT

--○ EMP 테이블을 대상으로
--   입사한 사원의 수가 가장 많았을 때의
--   입사년월과 인원수를 조회할 수 있도록 쿼리문을 구성한다,
/*
------------ ---------------
 입사년원       인원 수
------------ ---------------
 1981-02            2
 1981-09            2
 1987-07            2
 ------------ ---------------
*/
SELECT T1.입사년월, T1.인원수
FROM
(
    SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "입사년월"
         , COUNT(*) "인원수"
    FROM EMP
    GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM')
) T1
WHERE T1.인원수 = ( SELECT MAX(T2.인원수)
                    FROM
                    (
                        SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "입사년월"
                             , COUNT(*) "인원수"
                        FROM EMP
                        GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM')
                    ) T2
                   )
ORDER BY 1;
/*
1981-02	2
1981-09	2
1981-12	2
1987-07	2
*/


--------------------------------------------------------------------------------


--■■■ ROW_NUMBER ■■■--

SELECT ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
-- Session이(가) 변경되었습니다.

SELECT ROW_NUMBER() OVER(ORDER BY SAL DESC) "테스트"
     , ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP;
/*
1	KING	5000	    1981-11-17
2	FORD	3000	    1981-12-03
3	SCOTT	3000    	1987-07-13
4	JONES	2975	1981-04-02
5	BLAKE	2850    	1981-05-01
6	CLARK	2450	    1981-06-09
7	ALLEN	1600	    1981-02-20
8	TURNER	1500	    1981-09-08
9	MILLER	1300	    1982-01-23
10	WARD	1250	    1981-02-22
11	MARTIN	1250	    1981-09-28
12	ADAMS	1100	    1987-07-13
13	JAMES	 950	    1981-12-03
14	SMITH	 800	    1980-12-17
*/

SELECT ROW_NUMBER() OVER(ORDER BY ENAME) "테스트"
     , ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP;
/*
1	ADAMS	1100    	1987-07-13
2	ALLEN	1600    	1981-02-20
3	BLAKE	2850	    1981-05-01
4	CLARK	2450	    1981-06-09
5	FORD	3000	    1981-12-03
6	JAMES	 950    	1981-12-03
7	JONES	2975	1981-04-02
8	KING	5000	    1981-11-17
9	MARTIN	1250    	1981-09-28
10	MILLER	1300	    1982-01-23
11	SCOTT	3000	    1987-07-13
12	SMITH	 800    	1980-12-17
13	TURNER	1500    	1981-09-08
14	WARD	1250    	1981-02-22
*/

SELECT ROW_NUMBER() OVER(ORDER BY ENAME) "테스트"
     , ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP
WHERE DEPTNO = 20
ORDER BY ENAME;
/*
1	ADAMS	1100    	1987-07-13
2	FORD	3000	    1981-12-03
3	JONES	2975	1981-04-02
4	SCOTT	3000	    1987-07-13
5	SMITH	 800	    1980-12-17
*/

-- ▶ SELECT문 처리 순서에 따라 WHERE 조건문이 우선시 되기 때문에,
--    ROW_NUMBER()가 뒤죽박죽으로 섞이지 않는다.

-- ▶ 게시판의 게시물 번호를 SEQUENCE나 INDENTITY를 사용하게 되면 게시물을 삭제했을 경우,
--    삭제한 게시물의 자리에 다음 번호를 가진 게시물이 등록되는 상황이 발생하게 된다.
--    이는 보안성 측면이나 미관상 바람직하지 않은 상태일 수 있기 때문에
--    ROW_NUMBER()의 사용을 고려해 볼 수 있다.
--    관리의 목적으로 사용할 때에는 SEQUENCE나 IDENTITY를 사용하지만,
--    단순히 게시물을 목록화하여 사용자에게 리스트 형식으로 보여줄 때에는
--    사용하지 않는 것이 바람직할 수 있다.


-- ▼ SEQUENCE(시퀀스: 주문번호)
--    ▷ 사전적인 의미 : ① (일련의) 연속적인 사건들 ② (사건, 행동 등의) 순서

CREATE SEQUENCE SEQ_BOARD       -- 기본적인 시퀀스 생성 구문
START WITH 1                    -- 시작값
INCREMENT BY 1                  -- 증가값
NOMAXVALUE                      -- 최대값
NOCACHE;                        -- 캐시 사용 안 함(없음)
-- Sequence SEQ_BOARD이(가) 생성되었습니다.


-- 실습 테이블 생성
CREATE TABLE TBL_BOARD
( NO          NUMBER                  -- TBL_BOARD 테이블 생성 구문 → 게시판 테이블
, TITLE       VARCHAR2(50)            -- 게시물 번호
, CONTENTS    VARCHAR2(1000)          -- 게시물 제목
, NAME        VARCHAR2(20)            -- 게시물 내용
, PW          VARCHAR2(20)            -- 게시물 패스워드
, CREATED     DATE DEFAULT SYSDATE    -- 게시물 작성일
);
-- Table TBL_BOARD이(가) 생성되었습니다.

-- 데이터 입력
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '아~ 자고 싶다', '10분만 자고 올게요', '장현성', 'java002$', DEFAULT);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '아~ 웃겨', '현성군 완전 재미있어요', '엄소연', 'java002$', DEFAULT);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '보고 싶다', '원석이가 너무 보고 싶어요', '조영관', 'java002$', DEFAULT);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '배고파요', '아침인데 배고파요', '유동현', 'java002$', DEFAULT);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '너무 멀어요', '집에서 교육원까지 너무 멀어요', '김태민', 'java002$', DEFAULT);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '모자라요', '아직 잠이 모자라요', '장현성', 'java002$', DEFAULT);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '저두요', '저도 잠이 많이 모자라요', '유동현', 'java002$', DEFAULT);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '비온대요', '오늘 밤부터 비온대요', '박원석', 'java002$', DEFAULT);
-- 1 행 이(가) 삽입되었습니다.


-- 확인
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
-- Session이(가) 변경되었습니다.

SELECT *
FROM TBL_BOARD;
/*
1	아~ 자고 싶다	10분만 자고 올게요	            장현성	java002$	    2022-08-22 10:18:32
2	아~ 웃겨	    현성군 완전 재미있어요	        엄소연	java002$	    2022-08-22 10:18:44
3	보고 싶다	    원석이가 너무 보고 싶어요	    조영관	java002$	    2022-08-22 10:18:48
4	배고파요	    아침인데 배고파요	            유동현	java002$    	2022-08-22 10:19:36
5	너무 멀어요	    집에서 교육원까지 너무 멀어요	김태민	java002$	    2022-08-22 10:19:42
6	모자라요	    아직 잠이 모자라요	            장현성	java002$	    2022-08-22 10:19:47
7	저두요	        저도 잠이 많이 모자라요	        유동현	java002$	    2022-08-22 10:19:51
8	비온대요	    오늘 밤부터 비온대요	        박원석	java002$	    2022-08-22 10:20:11
*/

-- 게시물 삭제
DELETE
FROM TBL_BOARD
WHERE NO = 1;
-- 1 행 이(가) 삭제되었습니다.

DELETE
FROM TBL_BOARD
WHERE NO = 6;
-- 1 행 이(가) 삭제되었습니다.

DELETE
FROM TBL_BOARD
WHERE NO = 8;
-- 1 행 이(가) 삭제되었습니다.

-- 확인
SELECT *
FROM TBL_BOARD;
/*
2	아~ 웃겨	현성군 완전 재미있어요	        엄소연	java002$	    2022-08-22 10:18:44
3	보고 싶다	원석이가 너무 보고 싶어요	    조영관	java002$	    2022-08-22 10:18:48
4	배고파요	아침인데 배고파요	            유동현	java002$	    2022-08-22 10:19:36
5	너무 멀어요	집에서 교육원까지 너무 멀어요	김태민	java002$	    2022-08-22 10:19:42
7	저두요	    저도 잠이 많이 모자라요	        유동현	java002$	    2022-08-22 10:19:51
*/


-- 게시물 작성
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '집중합시다', '전 전혀 졸리지 않아요', '유동현', 'java002$', DEFAULT);
-- 1 행 이(가) 삽입되었습니다.

-- 게시물 삭제
DELETE
FROM TBL_BOARD
WHERE NO = 7;
-- 1 행 이(가) 삭제되었습니다.


-- 확인
SELECT *
FROM TBL_BOARD;
/*
2	아~ 웃겨	현성군 완전 재미있어요	        엄소연	java002$    	2022-08-22 10:18:44
3	보고 싶다	원석이가 너무 보고 싶어요	    조영관	java002$	    2022-08-22 10:18:48
4	배고파요	아침인데 배고파요	            유동현	java002$    	2022-08-22 10:19:36
5	너무 멀어요	집에서 교육원까지 너무 멀어요	김태민	java002$	    2022-08-22 10:19:42
9	집중합시다	전 전혀 졸리지 않아요	        유동현	java002$    	2022-08-22 10:35:25
*/


-- 커밋
COMMIT;
-- 커밋 완료.


-- ▼ 게시판의 게시물 리스트 조회
SELECT NO "글번호", TITLE "제목", NAME "작성자", CREATED "작성일"
FROM TBL_BOARD;
/*
2	아~ 웃겨	엄소연	2022-08-22 10:18:44
3	보고 싶다	조영관	2022-08-22 10:18:48
4	배고파요	유동현	2022-08-22 10:19:36
5	너무 멀어요	김태민	2022-08-22 10:19:42
9	집중합시다	유동현	2022-08-22 10:35:25
*/

SELECT ROW_NUMBER() OVER(ORDER BY CREATED) "글번호"
     , TITLE "제목", NAME "작성자", CREATED "작성일"
FROM TBL_BOARD;
/*
1	아~ 웃겨	엄소연	2022-08-22 10:18:44
2	보고 싶다	조영관	2022-08-22 10:18:48
3	배고파요	유동현	2022-08-22 10:19:36
4	너무 멀어요	김태민	2022-08-22 10:19:42
5	집중합시다	유동현	2022-08-22 10:35:25
*/

SELECT ROW_NUMBER() OVER(ORDER BY CREATED) "글번호"
     , TITLE "제목", NAME "작성자", CREATED "작성일"
FROM TBL_BOARD
ORDER BY 4 DESC;
/*
5	집중합시다	유동현	2022-08-22 10:35:25
4	너무 멀어요	김태민	2022-08-22 10:19:42
3	배고파요	유동현	2022-08-22 10:19:36
2	보고 싶다	조영관	2022-08-22 10:18:48
1	아~ 웃겨	엄소연	2022-08-22 10:18:44
*/


--------------------------------------------------------------------------------


--■■■ JOIN(조인) ■■■--

-- 1. SQL 1992 CODE

-- ▼ CROSS JOIN (사용빈도 ↓)
--    두 테이블을 결합한 모든 경우의 수 (수학에서 말하는 데카르트 곱 CATERSIAN PRODUCT)
SELECT *
FROM EMP, DEPT;


-- ▼ EQUI JOIN (사용빈도 ↑)
--    서로 정확하게 일치하는 것들끼리 연결하여 결합시키는 결합 방법
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;

SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;


-- ▼ NON EQUI JOIN
--    범위 안에 적합한 것들끼리 연결시키는 결합 방법
SELECT *
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;


-- ▼ EQUI JOIN 시 (+)를 활용한 결합 방법
SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO;
-- 총 14건의 데이터가 조회된 상황
-- 즉, 부서번호를 갖지 못한 사원들(5)은 모두 누락
-- 또한, 소속 사원을 갖지 못한 부서(1) 역시 누락

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO(+);
-- 총 19건의 데이터 조회
-- 부서번호를 갖지 못한 사원들 모두 조회
-- 소속 사원을 갖지 못한 부서(1) 누락     ----------------- (+)

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;
-- 총 15건의 데이터 조회
-- 부서번호를 갖지 못한 사원들(5) 누락    ----------------- (+)
-- 소속 사원을 갖지 못한 부서 조회

-- ▶ (+)가 없는 쪽 테이블의 데이터를 모두 메모리에 적재한 후                      → (기준)
--    (+)가 있는 쪽 테이블의 데이터를 하나하나 확인하여 결합시키는 형태로          → 추가(첨가)
--    JOIN이 이루어진다.

--    이와 같은 이유로
      /*
      SELECT *
      FROM TBL_EMP E, TBL_DEPT D
      WHERE E.DEPTNO(+) = D.DEPTNO(+);
      */
--    이런 형식의 JOIN은 존재하지 않는다.


-- 2. SQL 1999 CODE     → 『JOIN』 키워드 등장 : JOIN(결합)의 유형 명시
--                      → 『ON』 키워드 등장 : 결합 조건은 WHERE 대신 ON

-- ▼ CROSS JOIN
SELECT *
FROM EMP CROSS JOIN DEPT;


-- ▼ INNER JOIN (= EQUI JOIN)
SELECT *
FROM EMP INNER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO;

SELECT *
FROM EMP E INNER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
-- INNER JOIN에서 INNER는 생략 가능


-- ▼ OUTER JOIN (= EQUI JOIN(+))
SELECT *
FROM TBL_EMP E LEFT OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E RIGHT OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E FULL OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

-- OUTER JOIN에서 OUTER는 생략 가능
-- ▷ 방향으로 구분!


--------------------------------------------------------------------------------
SELECT *
FROM TBL_EMP E JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO
AND E.JOB = 'CLERK';
-- ▷ 이러한 방법으로 쿼리문을 구성해도 조회 결과를 얻는 데 문제는 없다.

SELECT *
FROM TBL_EMP E JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.JOB = 'CLERK';
-- ▶ 하지만 이와 같이 구성하여 조회하는 것을 권장한다.
--------------------------------------------------------------------------------


-- ▼ EMP 테이블과 DEPT 테이블을 대상으로
--    직종이 MANAGER와 CLERK인 사원들만
--    부서번호, 부서명, 사원명, 직종명, 급여 항목을 조회한다.
--    DEPTNO    DNAME   ENAME   JOB     SAL
--    E, D      D       E       E       E

/* ▷ 선생님 해설

SELECT DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;
-- 에러 발생 : ORA-00918: column ambiguously defined
-- ▶ 두 테이블 간 중복되는 컬럼에 대한 소속 테이블을 명시해줘야 한다.
--    이 경우, 부모 테이블의 컬럼을 참조할 수 있도록 처리해야 한다.
-- ▷ 부모 테이블은 어떤 것이 어떤 것을 참조하고 있느냐로 결정된다.
--    즉, 중복되는 컬럼을 기준으로 데이터가 적게 조회되는 쪽이 부모 테이블 (DEPT)

-- ▷ 오라클은 JOIN된 두 테이블에서 컬럼을 찾을 때,
--    이미 앞선 테이블에서 컬럼을 찾았다고 하더라도 멈추지 않고 계속 조회한다.
-- ▶ 두 테이블에 모두 포함되어 있는 중복된 컬럼이 아니더라도
--    컬럼의 소속 테이블을 명시해 줄 수 있도록 권장한다.

*/

SELECT D.DEPTNO "부서번호", D.DNAME "부서명", E.ENAME "사원명", E.JOB "직종명", E.SAL "급여"
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.JOB IN ('MANAGER', 'CLERK');
/*
10	ACCOUNTING	CLARK	MANAGER	    2450
10	ACCOUNTING	MILLER	CLERK	    1300
20	RESEARCH	ADAMS	CLERK	    1100
20	RESEARCH	JONES	MANAGER	    2975
20	RESEARCH	SMITH	CLERK	     800
30	SALES	    BLAKE	MANAGER	    2850
30	SALES	    JAMES	CLERK	     950
*/


--------------------------------------------------------------------------------


-- ▼ SELF JOIN (자기 조인)

-- EMP 테이블의 데이터를 다음과 같이 조회할 수 있도록 쿼리문을 구성한다.
-------------------------------------------------------------------
-- 사원번호  사원명  직종명  관리자번호  관리자명  관리자직종명
-------------------------------------------------------------------
-- 7369      SMITH   CLERK   7902        FORD       ANALYST

SELECT E1.EMPNO "사원번호", E1.ENAME "사원명", E1.JOB "직종명", E1.MGR "관리자번호", E2.ENAME "관리자명", E2.JOB "관리자직종명"
FROM EMP E1 LEFT JOIN EMP E2
ON E1.MGR = E2.EMPNO;























