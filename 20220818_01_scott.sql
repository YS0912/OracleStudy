SELECT USER
FROM DUAL;
-- SCOTT


-- ▼ CASE 구문(조건문, 분기문)
/*
CASE
WHEN
THEN
ELSE
END
*/

SELECT CASE 5+2 WHEN 4 THEN '5+2=4' ELSE '5+2는 몰라요' END
FROM DUAL;
-- 5+2는 몰라요

SELECT CASE 5+2 WHEN 7 THEN '5+2=7' ELSE '5+2는 몰라요' END
FROM DUAL;
-- 5+2=7


SELECT CASE 1+1 WHEN 2 THEN '1+1=2'
                WHEN 3 THEN '1+1=3'
                WHEN 4 THEN '1+1=4'
                ELSE '몰라'
       END
FROM DUAL;
-- 1+1=2

SELECT CASE 1+1 WHEN 2 THEN '1+1=2'
                WHEN 3 THEN '1+1=3'
                WHEN 2 THEN '1+1=4'
                ELSE '몰라'
       END
FROM DUAL;
-- 1+1=2
-- ▶ 첫 번째 WHEN을 수행한 후 CASE 문 종료


SELECT CASE WHEN 5+2=4 THEN '5+2=4'
            WHEN 6-3=2 THEN '6-3=2'
            WHEN 2*1=2 THEN '2*1=2'
            WHEN 6/3=2 THEN '6/3=2'
            ELSE '몰라'
       END
FROM DUAL;
-- 2*1=2

SELECT CASE WHEN 5+2=7 THEN '5+2=7'
            WHEN 6-3=3 THEN '6-3=3'
            WHEN 2*1=2 THEN '2*1=2'
            WHEN 6/3=2 THEN '6/3=2'
            ELSE '몰라'
       END
FROM DUAL;
-- 5+2=7


-- ▼ DECODE()
SELECT DECODE(5-2, 1, '5-2=1', 2, '5-2=2', 3, '5-2=3', '5-2는 몰라요')
FROM DUAL;
-- 5-2=3


-- ▼ CASE WHEN THEN ELSE END (조건문, 분기문) 활용

SELECT CASE WHEN 5<2 THEN '5<2'
            WHEN 5>2 THEN '5>2'
            ELSE '5와 2는 비교 불가'
       END "결과 확인"
FROM DUAL;
-- 5>2


SELECT CASE WHEN 5<2 OR 3>1 AND 2=2 THEN '소연만세'
            WHEN 5>2 OR 2=3 THEN '시연만세'
            ELSE '원석만세'
       END "결과확인"
FROM DUAL;
-- 소연만세

SELECT CASE WHEN 3<1 AND 5<2 OR 3>1 AND 2=2 THEN '보경만세'
            WHEN 5<2 OR 2=3 THEN '은영만세'
            ELSE '현하만세'
       END "결과확인"
FROM DUAL;
-- 보경만세

SELECT CASE WHEN 3<1 AND (5<2 OR 3>1) AND 2=2 THEN '보경만세'
            WHEN 5<2 OR 2=3 THEN '은영만세'
            ELSE '현하만세'
       END "결과확인"
FROM DUAL;
-- 현하만세


ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
-- Session이(가) 변경되었습니다.

SELECT *
FROM TBL_SAWON;
/*
1001	고연수	    9409252234567	2005-01-03	3000
1002	김보경	    9809022234567	1999-11-23	2000
1003	정미경	    9810092234567	2006-08-10	4000
1004	김인교	    9307131234567	1998-05-13	2000
1005	이정재	    7008161234567	1998-05-13	1000
1006	아이유	    9309302234567	1999-10-10	3000
1007	이하이	    0302064234567	2010-10-23	4000
1008	인순이	    6807102234567	1998-03-20	1500
1009	선동렬	    6710261234567	1998-03-20	1300
1010	선우용녀	6511022234567	1998-12-20	2600
1011	선우선	    0506174234567	2011-10-10	1300
1012	남궁민	    0102033234567	2010-10-10	2400
1013	남진	    0210303234567	2011-10-10	2800
1014	반보영	    9903142234567	2012-11-11	5200
1015	한은영	    9907292234567	2012-11-11	5200
1016	이이경	    0605063234567	2015-01-20	1500
*/


-- ▼ TBL_SAWON 테이블을 활용하여 다음과 같은 항목을 조회할 수 있도록 쿼리문을 구성한다.
--    『사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일
--    , 정년퇴직일, 근무일수, 남은일수, 급여, 보너스』
--    단, 현재나이는 기본 한국나이 계산법에 따라 연산을 수행한다.
--    또한, 정년퇴직일은 해당 직원의 나이가 60세가 되는 해의 입사 월일로 연산을 수행한다.
--    그리고 보너스는 1000일 이상 2000일 미만 근무한 사원은 원래 급여 기준 30% 지급,
--    2000일 이상 근무한 사원은 원래 급여 기준 50%를 지급할 수 있도록 처리한다.

-- EX) 1001 고연수 9409252234567 여성 29 2005-01-03 2053-01-03 xxxxx xxxxxxx 3000 900

-- ▽ 내 풀이
SELECT SANO "사원번호"
     , SANAME "사원명"
     , JUBUN "주민번호"
     , CASE SUBSTR(JUBUN, 7, 1) WHEN '2' THEN '여자'
                                WHEN '4' THEN '여자'
                                WHEN '1' THEN '남자'
                                WHEN '3' THEN '남자'
                                ELSE '판별불가'
       END "성별"
     , CASE SUBSTR(JUBUN, 7, 1) WHEN '1' THEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 19), 'YYYY-MM-DD')) +1
                                WHEN '2' THEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 19), 'YYYY-MM-DD')) +1
                                WHEN '3' THEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 20), 'YYYY-MM-DD')) +1
                                WHEN '4' THEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 20), 'YYYY-MM-DD')) +1
       END "현재나이"
     , HIREDATE "입사일"
     , CASE SUBSTR(JUBUN, 7, 1) WHEN '1' THEN EXTRACT( YEAR FROM (TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 19), 'YYYY-MM-DD') + TO_YMINTERVAL('59-00')) ) || TO_CHAR(HIREDATE, '-MM-DD')
                                WHEN '2' THEN EXTRACT( YEAR FROM (TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 19), 'YYYY-MM-DD') + TO_YMINTERVAL('59-00')) ) || TO_CHAR(HIREDATE, '-MM-DD')
                                WHEN '3' THEN EXTRACT( YEAR FROM (TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 20), 'YYYY-MM-DD') + TO_YMINTERVAL('59-00')) ) || TO_CHAR(HIREDATE, '-MM-DD')
                                WHEN '4' THEN EXTRACT( YEAR FROM (TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 20), 'YYYY-MM-DD') + TO_YMINTERVAL('59-00')) ) || TO_CHAR(HIREDATE, '-MM-DD')
       END "정년퇴직일"
     , TRUNC(SYSDATE - HIREDATE) "근무일수"
     , CASE SUBSTR(JUBUN, 7, 1) WHEN '1' THEN TRUNC(TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 19), 'YYYY-MM-DD') + TO_YMINTERVAL('59-00') - SYSDATE)
                                WHEN '2' THEN TRUNC(TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 19), 'YYYY-MM-DD') + TO_YMINTERVAL('59-00') - SYSDATE)
                                WHEN '3' THEN TRUNC(TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 20), 'YYYY-MM-DD') + TO_YMINTERVAL('59-00') - SYSDATE)
                                WHEN '4' THEN TRUNC(TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 20), 'YYYY-MM-DD') + TO_YMINTERVAL('59-00') - SYSDATE)
       END "남은일수"
     , SAL "급여"
     , CASE WHEN TRUNC(SYSDATE - HIREDATE)>=1000 AND TRUNC(SYSDATE - HIREDATE)<2000 THEN SAL*0.3
            WHEN TRUNC(SYSDATE - HIREDATE)>=2000 THEN SAL*0.5
       END "보너스"
FROM TBL_SAWON;

-- 생년 날짜화
SELECT CASE SUBSTR(JUBUN, 7, 1) WHEN '1' THEN TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 19), 'YYYY-MM-DD')
                                WHEN '2' THEN TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 19), 'YYYY-MM-DD')
                                WHEN '3' THEN TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 20), 'YYYY-MM-DD')
                                WHEN '4' THEN TO_DATE( LPAD(SUBSTR(JUBUN, 1, 6), 8, 20), 'YYYY-MM-DD')
       END
FROM TBL_SAWON;


-- ▽ 선생님 풀이
-- 사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일, 정년퇴직일, 근무일수, 남은일수, 급여, 보너스

-- ① 사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일, 급여 먼저 처리
SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
     -- 성별
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '남성'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '여성'
            ELSE '성별확인불가'
       END "성별"
     -- 현재나이 = 현재년도 - 태어난년도 + 1 (1900년대 / 2000년대)
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
            WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
            -- ELSE '나이확인불가' (▷ 데이터 타입 통합 필요)
            ELSE -1
       END "현재나이"
     -- 입사일
     , HIREDATE "입사일"
     , SAL "급여"
FROM TBL_SAWON;

-- ② 테스트(서브쿼리)
SELECT EMPNO, ENAME, SAL, COMM, SAL*12+NVL(COMM, 0) "연봉", 연봉*2 "두배연봉"
FROM EMP;
-- 에러 발생 : ORA-00904: "연봉": invalid identifier

SELECT EMPNO, ENAME, SAL, COMM, 연봉
FROM
(
    SELECT EMPNO, ENAME, SAL, COMM, SAL*12+NVL(COMM, 0) "연봉"
    FROM EMP
);

SELECT 연봉*2 "두배연봉"
FROM
(
    SELECT EMPNO, ENAME, SAL, COMM, SAL*12+NVL(COMM, 0) "연봉"
    FROM EMP
);

-- ③ 테스트(VIEW 생성)
CREATE VIEW VIEW_EMP
AS
SELECT EMPNO, ENAME, SAL, COMM, SAL*12+NVL(COMM, 0) "연봉"
FROM EMP;
-- 첫 실행 에러 발생 : ORA-01031: insufficient privileges (→ 권한 부족)
-- 권한 부여 후 실행 : View VIEW_EMP이(가) 생성되었습니다.

SELECT *
FROM VIEW_EMP;

-- ④ ①에서 생성한 구문을 활용하여 최종 쿼리문 작성
-- 사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일, 정년퇴직일, 근무일수, 남은일수, 급여, 보너스

SELECT T.사원번호, T.사원명, T.주민번호, T.성별, T.현재나이, T.입사일
     -- 정년 퇴직일
     -- 정년퇴직년도 → 해당 직원의 나이가 한국나이로 60세가 되는 해
     -- ▷ 현재 나이가 57세인 경우,  3년 후   →  2025
     --    현재 나이가 28세인 경우, 32년 후   →  2054
     -- ▷ ADD_MONTHS(SYSDATE, 남은년수*12)
     --                        --------
     --                      60 - 현재나이
     --    ADD_MONTHS(SYSDATE, (60 - 현재나이) * 12)    → 특정날짜
     -- ▷ TO_CHAR('특정날짜', 'YYYY')                  → 정년퇴직 년도만 추출
     --    TO_CHAR('입사일', 'MM-DD')                   → 입사 월일만 추출
     -- ▶ TO_CHAR('특정날짜', 'YYYY') || '-' || TO_CHAR('입사일', 'MM-DD')
     --    TO_CHAR('특정날짜', 'YYYY') || '-' || TO_CHAR('입사일', 'MM-DD')
     --    TO_CHAR(ADD_MONTHS(SYSDATE, (60 - 현재나이) * 12), 'YYYY') || '-' || TO_CHAR('입사일', 'MM-DD')
     , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) * 12), 'YYYY')
       || '-' || TO_CHAR(T.입사일, 'MM-DD') "정년퇴직일"
     -- 근무일수
     -- 근무일수 = 현재일 - 입사일
     , TRUNC(SYSDATE - T.입사일) "근무일수"
     -- 남은일수
     -- 남은일수 = 정년퇴직일 - 현재일
     -- TO_DATE(정년퇴직문자열, 'YYYY-MM-DD') - SYSDATE "남은일수"
     , TRUNC(TO_DATE((TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) * 12), 'YYYY')
       || '-' || TO_CHAR(T.입사일, 'MM-DD')), 'YYYY-MM-DD') - SYSDATE) "남은일수"
     -- 급여
     , T.급여
     -- 보너스
     -- 근무일수가 1000일 이상 2000일 미만 → 급여의 30% 지급
     -- 근무일수가 2000일 이상             → 급여의 50% 지급
     -- 나머지                             → 0
     ---------------------------------------------------------
     -- 근무일수가 2000일 이상             → 급여 * 0.5
     -- 근무일수가 1000일 이상             → 급여 * 0.3
     -- 나머지                             → 0
     , CASE WHEN TRUNC(SYSDATE - T.입사일) >= 2000 THEN T.급여*0.5
            WHEN TRUNC(SYSDATE - T.입사일) >= 1000 THEN T.급여*0.3
            ELSE 0
       END "보너스"
FROM
(
    SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
         -- 성별
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '남성'
                WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '여성'
                ELSE '성별확인불가'
           END "성별"
         -- 현재나이 = 현재년도 - 태어난년도 + 1 (1900년대 / 2000년대)
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
                WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
                -- ELSE '나이확인불가' (▷ 데이터 타입 통합 필요)
                ELSE -1
           END "현재나이"
         -- 입사일
         , HIREDATE "입사일"
         , SAL "급여" 
    FROM TBL_SAWON
) T;
/*
1001	고연수	    9409252234567	여성	29	2005-01-03	2053-01-03	6436	11095	3000 	1500
1002	김보경	    9809022234567	여성	25	1999-11-23	2057-11-23	8304    	12880	2000 	1000
1003	정미경	    9810092234567	여성	25	2006-08-10	2057-08-10	5852	12775	4000	    2000
1004	김인교	    9307131234567	남성	30	1998-05-13	2052-05-13	8863	10860	2000	    1000
1005	이정재	    7008161234567	남성	53	1998-05-13	2029-05-13	8863	 2459	1000	     500
1006	아이유	    9309302234567	여성	30	1999-10-10	2052-10-10	8348	11010	3000	    1500
1007	이하이	    0302064234567	여성	20	2010-10-23	2062-10-23	4317	14675	4000	    2000
1008	인순이	    6807102234567	여성	55	1998-03-20	2027-03-20	8917	 1674	1500	     750
1009	선동렬	    6710261234567	남성	56	1998-03-20	2026-03-20	8917	 1309	1300	     650
1010	선우용녀	6511022234567	여성	58	1998-12-20	2024-12-20	8642	  854	2600	    1300
1011	선우선	    0506174234567	여성	18	2011-10-10	2064-10-10	3965	15393	1300	     650
1012	남궁민	    0102033234567	남성	22	2010-10-10	2060-10-10	4330    	13932	2400 	1200
1013	남진	    0210303234567	남성	21	2011-10-10	2061-10-10	3965	14297	2800	    1400
1014	반보영	    9903142234567	여성	24	2012-11-11	2058-11-11	3567	13233	5200	    2600
1015	한은영	    9907292234567	여성	24	2012-11-11	2058-11-11	3567	13233	5200	    2600
1016	이이경	    0605063234567	남성	17	2015-01-20	2065-01-20	2767	15495	1500	     750
*/


-- 위에서 처리한 내용을 기반으로 특정 근무일수의 사원을 확인해야 한다거나,
-- 특정 보너스 금액을 받는 사원을 확인해야 할 경우가 발생할 수 있다.
-- (즉, 추가적인 조회 조건이 발생하거나, 업무가 파생되는 경우)
-- 이럴 때는 해당 쿼리문을 다시 구성해야 하는 번거로움을 줄일 수 있도록
-- 뷰(VIEW)를 만들어 저장해 둘 수 있다. ▼

CREATE OR REPLACE VIEW VIEW_SAWON
AS
SELECT T.사원번호, T.사원명, T.주민번호, T.성별, T.현재나이, T.입사일
     , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) * 12), 'YYYY')
       || '-' || TO_CHAR(T.입사일, 'MM-DD') "정년퇴직일"
     , TRUNC(SYSDATE - T.입사일) "근무일수"
     , TRUNC(TO_DATE((TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) * 12), 'YYYY')
       || '-' || TO_CHAR(T.입사일, 'MM-DD')), 'YYYY-MM-DD') - SYSDATE) "남은일수"
     , T.급여
     , CASE WHEN TRUNC(SYSDATE - T.입사일) >= 2000 THEN T.급여*0.5
            WHEN TRUNC(SYSDATE - T.입사일) >= 1000 THEN T.급여*0.3
            ELSE 0
       END "보너스"
FROM
(
    SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '남성'
                WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '여성'
                ELSE '성별확인불가'
           END "성별"
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
                WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
                ELSE -1
           END "현재나이"
         , HIREDATE "입사일"
         , SAL "급여"
    FROM TBL_SAWON
) T;
-- View VIEW_SAWON이(가) 생성되었습니다.

SELECT *
FROM VIEW_SAWON;
/*
1001	고연수	    9409252234567	여성	29	2005-01-03	2053-01-03	6436	11095	3000 	1500
1002	김보경	    9809022234567	여성	25	1999-11-23	2057-11-23	8304    	12880	2000 	1000
1003	정미경	    9810092234567	여성	25	2006-08-10	2057-08-10	5852	12775	4000	    2000
1004	김인교	    9307131234567	남성	30	1998-05-13	2052-05-13	8863	10860	2000	    1000
1005	이정재	    7008161234567	남성	53	1998-05-13	2029-05-13	8863	 2459	1000	     500
1006	아이유	    9309302234567	여성	30	1999-10-10	2052-10-10	8348	11010	3000	    1500
1007	이하이	    0302064234567	여성	20	2010-10-23	2062-10-23	4317	14675	4000	    2000
1008	인순이	    6807102234567	여성	55	1998-03-20	2027-03-20	8917	 1674	1500	     750
1009	선동렬	    6710261234567	남성	56	1998-03-20	2026-03-20	8917	 1309	1300	     650
1010	선우용녀	6511022234567	여성	58	1998-12-20	2024-12-20	8642	  854	2600	    1300
1011	선우선	    0506174234567	여성	18	2011-10-10	2064-10-10	3965	15393	1300	     650
1012	남궁민	    0102033234567	남성	22	2010-10-10	2060-10-10	4330    	13932	2400 	1200
1013	남진	    0210303234567	남성	21	2011-10-10	2061-10-10	3965	14297	2800	    1400
1014	반보영	    9903142234567	여성	24	2012-11-11	2058-11-11	3567	13233	5200	    2600
1015	한은영	    9907292234567	여성	24	2012-11-11	2058-11-11	3567	13233	5200	    2600
1016	이이경	    0605063234567	남성	17	2015-01-20	2065-01-20	2767	15495	1500	     750
*/

SELECT *
FROM VIEW_SAWON
WHERE 근무일수 >= 5000;
/*
1001	고연수	    9409252234567	여성	29	2005-01-03	2053-01-03	6436	11095	3000    	1500
1002	김보경	    9809022234567	여성	25	1999-11-23	2057-11-23	8304	    12880	2000	    1000
1003	정미경	    9810092234567	여성	25	2006-08-10	2057-08-10	5852	12775	4000	    2000
1004	김인교	    9307131234567	남성	30	1998-05-13	2052-05-13	8863	10860	2000	    1000
1005	이정재	    7008161234567	남성	53	1998-05-13	2029-05-13	8863	 2459	1000	    500
1006	아이유	    9309302234567	여성	30	1999-10-10	2052-10-10	8348	11010	3000    	1500
1008	인순이	    6807102234567	여성	55	1998-03-20	2027-03-20	8917	 1674	1500    	750
1009	선동렬	    6710261234567	남성	56	1998-03-20	2026-03-20	8917	 1309	1300    	650
1010	선우용녀	6511022234567	여성	58	1998-12-20	2024-12-20	8642	  854	2600    	1300
*/

SELECT *
FROM VIEW_SAWON
WHERE 보너스>=2000;
/*
1003	정미경	9810092234567	여성	25	2006-08-10	2057-08-10	5852	12775	4000	    2000
1007	이하이	0302064234567	여성	20	2010-10-23	2062-10-23	4317	14675	4000	    2000
1014	반보영	9903142234567	여성	24	2012-11-11	2058-11-11	3567	13233	5200	    2600
1015	한은영	9907292234567	여성	24	2012-11-11	2058-11-11	3567	13233	5200	    2600
*/


-- ▼ 서브쿼리를 활용하여
--    TBL_SAWON 테이블을 다음과 같이 조회할 수 있도록 한다.
      /*
      ----------------------------------------------
          사원명 성별  현재나이    급여  나이보너스
      ----------------------------------------------
      */
--    단, 나이보너스는 현재 나이가 40세 이상이면 급여의 70%
--    30세 이상 40세 미만이면 급여의 50%
--    20세 이상 30세 미만이면 급여의 30%로 한다.

--    또한 이렇게 완성된 조회 구문을 통해
--    VIEW_SAWON2라는 이름의 뷰(VIEW)를 생성할 수 있도록 한다.

-- ① 조회 쿼리 작성
SELECT T.*
     , CASE WHEN T.현재나이 >= 40 THEN T.급여*0.7
            WHEN T.현재나이 >= 30 THEN T.급여*0.5
            WHEN T.현재나이 >= 20 THEN T.급여*0.3
            ELSE 0
       END "나이보너스"
FROM
(
    SELECT SANAME "사원명"
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '남자'
                WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '여자'
                ELSE '성별확인불가'
           END "성별"
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
                WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
                ELSE -1
           END "현재나이"
         , SAL "급여"
    FROM TBL_SAWON
) T;

-- ② VIEW_SAWON2 생성
CREATE OR REPLACE VIEW VIEW_SAWON2
AS
SELECT T.사원명, T.성별, T.현재나이, T.급여
     , CASE WHEN T.현재나이 >= 40 THEN T.급여*0.7
            WHEN T.현재나이 >= 30 THEN T.급여*0.5
            WHEN T.현재나이 >= 20 THEN T.급여*0.3
            ELSE 0
       END "나이보너스"
FROM
(
    SELECT SANAME "사원명"
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN (1, 3) THEN '남자'
                WHEN SUBSTR(JUBUN, 7, 1) IN (2, 4) THEN '여자'
                ELSE '성별판정불가'
           END "성별"
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN (1, 2) THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
                WHEN SUBSTR(JUBUN, 7, 1) IN (3, 4) THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
                ELSE -1
           END "현재나이"
         , SAL "급여"
    FROM TBL_SAWON
) T;
-- View VIEW_SAWON2이(가) 생성되었습니다.

-- 생성한 뷰(VIEW) 조회
SELECT *
FROM VIEW_SAWON2;
/*
고연수	    여자	29	3000	     900
김보경	    여자	25	2000	     600
정미경	    여자	25	4000	    1200
김인교	    남자	30	2000	    1000
이정재	    남자	53	1000	     700
아이유	    여자	30	3000    	1500
이하이	    여자	20	4000	    1200
인순이	    여자	55	1500	    1050
선동렬	    남자	56	1300	     910
선우용녀	여자	58	2600    	1820
선우선	    여자	18	1300    	   0
남궁민	    남자	22	2400    	 720
남진	    남자	21	2800	     840
반보영	    여자	24	5200	    1560
한은영	    여자	24	5200    	1560
이이경	    남자	17	1500	       0
*/


--------------------------------------------------------------------------------


-- ▼ RANK()
--    등수(순위)를 반환하는 함수
SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , RANK() OVER(ORDER BY SAL DESC) "전체급여순위"
FROM EMP;
/*
7839	KING	10	5000	    1
7902	    FORD	20	3000	    2
7788	SCOTT	20	3000	    2
7566	JONES	20	2975	4
7698	BLAKE	30	2850	    5
7782	CLARK	10	2450	    6
7499	ALLEN	30	1600	    7
7844	TURNER	30	1500    	8
7934	MILLER	10	1300    	9
7521	WARD	30	1250	    10
7654	MARTIN	30	1250	    10
7876	ADAMS	20	1100	    12
7900	    JAMES	30	 950	    13
7369	SMITH	20	 800	    14
*/

SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "부서별급여순위"
     , RANK() OVER(ORDER BY SAL DESC) "전체급여순위"
FROM EMP;

SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "부서별급여순위"
     , RANK() OVER(ORDER BY SAL DESC) "전체급여순위"
FROM EMP
ORDER BY DEPTNO;
/*
7839	KING	10	5000	    1	 1
7782	CLARK	10	2450    	2	 6
7934	MILLER	10	1300    	3	 9
7902    	FORD	20	3000	    1	 2
7788	SCOTT	20	3000	    1	 2
7566	JONES	20	2975	3	 4
7876	ADAMS	20	1100    	4	12
7369	SMITH	20	 800    	5	14
7698	BLAKE	30	2850    	1	 5
7499	ALLEN	30	1600    	2	 7
7844	TURNER	30	1500	    3	 8
7654	MARTIN	30	1250    	4	10
7521	WARD	30	1250    	4	10
7900	    JAMES	30	 950    	6	13
*/


-- ▼ DENSE_RANK()
--    서열을 반환하는 함수
SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "부서별급여서열"
     , DENSE_RANK() OVER(ORDER BY SAL DESC) "전체급여서열"
FROM EMP
ORDER BY 3, 4 DESC;
/*
7839	KING	10	5000	    1	 1
7782	CLARK	10	2450	    2	 5
7934	MILLER	10	1300	    3	 8
7902	    FORD	20	3000	    1	 2
7788	SCOTT	20	3000	    1	 2
7566	JONES	20	2975	2	 3
7876	ADAMS	20	1100    	3	10
7369	SMITH	20	 800    	4	12
7698	BLAKE	30	2850	    1	 4
7499	ALLEN	30	1600	    2	 6
7844	TURNER	30	1500	    3	 7
7654	MARTIN	30	1250    	4	 9
7521	WARD	30	1250	    4	 9
7900	    JAMES	30	 950	    5	11
*/


-- ▼ EMP 테이블의 사원 데이터를
--    사원명, 부서번호, 연봉, 부서내연봉순위, 전체연봉순위 항목으로 조회한다.
SELECT T.*
     , RANK() OVER(PARTITION BY T.부서번호 ORDER BY T.연봉 DESC) "부서내연봉순위"
     , RANK() OVER(ORDER BY T.연봉 DESC) "전체연봉순위"
FROM
(
    SELECT ENAME "사원명", DEPTNO "부서번호"
         , SAL*12 + NVL(COMM, 0) "연봉"
    FROM EMP
) T;
/*
KING	10	60000	1	 1
FORD	20	36000	1	 2
SCOTT	20	36000	1	 2
JONES	20	35700	3	 4
BLAKE	30	34200	1	 5
CLARK	10	29400	2	 6
ALLEN	30	19500	2	 7
TURNER	30	18000	3	 8
MARTIN	30	16400	4	 9
MILLER	10	15600	3	10
WARD	30	15500	5	11
ADAMS	20	13200	4	12
JAMES	30	11400	6	13
SMITH	20	 9600	5	14
*/


-- ▼ EMP 테이블에서 전체 연봉 순위(등수)가 1등부터 5등까지만
--    사원명, 부서번호, 연봉, 전체연봉순위 항목으로 조회한다.
SELECT T.*
FROM
(
    SELECT ENAME "사원명", DEPTNO "부서번호", SAL*12 + NVL(COMM, 0) "연봉"
         , RANK() OVER(ORDER BY (SAL*12 + NVL(COMM, 0)) DESC) "전체연봉순위"
    FROM EMP
) T
WHERE T.전체연봉순위 <= 5;
-- 서브 쿼리를 사용하지 않았을 경우 에러 발생 : ORA-30483: window functions ar not allowed here

-- ▶ 위 내용은 RANK() OVER() 함수를 WHERE 조건절에서 사용한 경우이며,
--    이 함수는 WHERE 조건절에서 사용할 수 없기 때문에 발생하는 에러이다.
--    이 경우, 우리는 INLINE VIEW를 활용해서 풀이해야 한다.


-- ▼ EMP 테이블에서 각 부서별로 연봉 등수가 1등부터 2등까지만 조회한다.
--    사원명, 부서번호, 연봉, 부서내연봉등수, 전체연봉등수
--    항목을 조회할 수 있도록 한다.
SELECT T2.*
FROM
(
    SELECT T.*
         , RANK() OVER(PARTITION BY T.부서번호 ORDER BY T.연봉 DESC) "부서내연봉등수"
         , RANK() OVER(ORDER BY T.연봉 DESC) "전체연봉등수"
    FROM
    (
        SELECT ENAME "사원명", DEPTNO "부서번호", SAL*12 + NVL(COMM, 0) "연봉"
        FROM EMP
    ) T
) T2
WHERE T2.부서내연봉등수 <= 2;


-- ▼ 정정
-- TRIM() 함수 존재!
SELECT TRIM('     TEST     ') "RESULT"
FROM DUAL;
-- TEST

-- LN() 자연 로그 함수 존재!
SELECT LN(95) "RESULT"
FROM DUAL;
-- 4.55387689160054083460978676511404117675


--------------------------------------------------------------------------------


--■■■ 그룹 함수 ■■■--

-- SUM() 합, AVG() 평균, COUNT() 카운트, MAX() 최대값, MIN() 최소값,
-- VARIENCE() 분산, STDDEV() 표준편차

-- 그룹 함수의 가장 큰 특징
-- 처리해야 할 데이터들 중 NULL이 존재한다면(포함되어 있다면)
-- 이 NULL은 제외한 상태로 연산을 수행한다는 것이다.
-- 즉, NULL은 연산의 대상에서 제외된다.

-- ▼ SUM() 합
--    EMP 테이블을 대상으로 전체 사원들의 급여 총합을 조회한다.
SELECT SAL
FROM EMP;
/*
 800
1600
1250
2975
1250
2850
2450
3000
5000
1500
1100
 950
3000
1300
*/

SELECT SUM(SAL)         -- ▷ 800 + 1600 +1250 + ... + 1300
FROM EMP;
-- 29025


SELECT COMM
FROM EMP;
/*
(null)
300
500
(null)
1400
(null)
(null)
(null)
(null)
0
(null)
(null)
(null)
(null)
*/

SELECT SUM(COMM)        -- NULL + 300 + 500 + ... + NULL (X)
FROM EMP;
-- 2200


-- ▼ COUNT()
--    행(레코드)의 갯수 조회 → 데이터가 몇 건인지 확인할 때 쓰는 함수
SELECT COUNT(ENAME)
FROM EMP;
-- 14

SELECT COUNT(COMM)
FROM EMP;
-- 4 (NULL이 포함되지 않는다.)

-- 일반적인 방법: 특정 컬럼을 명시하지 않고 데이터가 한 컬럼에라도 들어있다면 조회
SELECT COUNT(*)
FROM EMP;
-- 14


-- ▼ AVG()
--    평균 반환
SELECT AVG(SAL) "COL1"
     , SUM(SAL) / COUNT(SAL) "COL2"
FROM EMP;
/*
2073.214285714285714285714285714285714286
2073.214285714285714285714285714285714286
*/

SELECT AVG(COMM) "COL1"
     , SUM(COMM) / COUNT(COMM) "COL2"
FROM EMP;
-- 550	550     (?)

SELECT 2200 / 14 "RESULT"
FROM DUAL;
-- 157.142857142857142857142857142857142857

-- ▶ 데이터가 NULL인 컬럼의 레코드는 연산 대상에서 제외되기 때문에
--    주의하여 연산 처리해야 한다.


-- ▼ VARIANCE() / STDDEV()
--    표준편차의 제곱이 분산, 분산의 제곱근이 표준편차
SELECT VARIANCE(SAL), STDDEV(SAL)
FROM EMP;
/*
1398313.87362637362637362637362637362637
1182.503223516271699458653359613061928508
*/

SELECT POWER(STDDEV(SAL), 2) "COL1"
     , VARIANCE(SAL) "COL2"
FROM EMP;
/*
1398313.87362637362637362637362637362637
1398313.87362637362637362637362637362637
*/

SELECT SQRT(VARIANCE(SAL)) "COL1"
     , STDDEV(SAL) "COL2"
FROM EMP;
/*
1182.503223516271699458653359613061928508
1182.503223516271699458653359613061928508
*/


-- ▼ MAX() / MIN()
--    최대값 / 최소값 반환
SELECT MAX(SAL) "COL1"
     , MIN(SAL) "COL2"
FROM EMP;
-- 5000	800


-- 부서별 급여 합을 보고 싶어!!
SELECT DEPTNO, SUM(SAL)
FROM EMP;
-- 에러발생 : ORA-00937: not a single-group group function

-- ▼

SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY DEPTNO
ORDER BY 1;
/*
10	 8750
20	10875
30	 9400
*/

-- ▶ 
SELECT DEPTNO, SAL
FROM EMP
ORDER BY 1;
/*
10	2450    ┐
10	5000    │
10	1300    ┘
20	2975    ┐
20	3000    │
20	1100    │
20	 800    │
20	3000    ┘
30	1250    ┐
30	1500    │
30	1600    │
30	 950    │
30	2850    │
30	1250    ┘
*/


-- 기존 테이블 제거
DROP TABLE TBL_EMP;
-- Table TBL_EMP이(가) 삭제되었습니다.

-- 실습 테이블 다시 생성
CREATE TABLE TBL_EMP
AS
SELECT *
FROM EMP;
-- Table TBL_EMP이(가) 생성되었습니다.

-- 실습 데이터 추가 입력
INSERT INTO TBL_EMP VALUES
(8001, '김태민', 'CLERK', 7566, SYSDATE, 1500, 10, NULL);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP VALUES
(8002, '조현하', 'CLERK', 7566, SYSDATE, 2000, 10, NULL);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP VALUES
(8003, '김보경', 'SALESMAN', 7698, SYSDATE, 1700, NULL, NULL);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP VALUES
(8004, '유동현', 'SALESMAN', 7698, SYSDATE, 2500, NULL, NULL);
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP VALUES
(8005, '장현성', 'SALESMAN', 7698, SYSDATE, 1000, NULL, NULL);
-- 1 행 이(가) 삽입되었습니다.

-- 확인
SELECT *
FROM TBL_EMP;
/*
7369	SMITH	CLERK	    7902	    1980-12-17	 800	    	    20
7499	ALLEN	SALESMAN	7698	1981-02-20	1600	     300	    30
7521	WARD	SALESMAN	7698	1981-02-22	1250     500	    30
7566	JONES	MANAGER	    7839	1981-04-02	2975		    20
7654	MARTIN	SALESMAN	7698	1981-09-28	1250	    1400	    30
7698	BLAKE	MANAGER	    7839	1981-05-01	2850	    	    30
7782	CLARK	MANAGER	    7839	1981-06-09	2450	    	    10
7788	SCOTT	ANALYST	    7566	1987-07-13	3000	    	    20
7839	KING	PRESIDENT   		1981-11-17	5000	    	    10
7844	TURNER	SALESMAN	7698	1981-09-08	1500	       0	    30
7876	ADAMS	CLERK	    7788	1987-07-13	1100		        20
7900    	JAMES	CLERK	    7698	1981-12-03	 950		        30
7902    	FORD	ANALYST	    7566	1981-12-03	3000		        20
7934	MILLER	CLERK	    7782	1982-01-23	1300		        10
8001    	김태민	CLERK	    7566	2022-08-18	1500	            10	
8002	    조현하	CLERK	    7566	2022-08-18	2000	            10	
8003	    김보경	SALESMAN	7698	2022-08-18	1700		
8004	    유동현	SALESMAN	7698	2022-08-18	2500		
8005	    장현성	SALESMAN	7698	2022-08-18	1000		
*/

-- 커밋
COMMIT;
-- 커밋 완료.


SELECT DEPTNO, SAL, COMM
FROM TBL_EMP
ORDER BY COMM DESC;
/*
20	 800	
	1700	
	1000	
10	1300	
20	2975	
30	2850	
10	2450	
20	3000	
10	5000	
	2500	
20	1100	
30	 950	
20	3000	
30	1250	    1400
30	1250	     500
30	1600	     300
	1500	     10
	2000	     10
30	1500	      0
*/
-- ▶ 오라클에서는 NULL을 가장 큰 값으로 간주
--    (ORACLE 9i까지는 NULL을 가장 작은 값으로 간주했었다.)
--    MSSQL은 NULL을 가장 작은 값으로 간주한다.


-- ▼ TBL_EMP 테이블을 대상으로 부서별 급여합 조회
--    부서번호, 급여합 항목 조회
SELECT DEPTNO "부서번호", SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;
/*
10	 8750
20	10875
30	 9400
	 8700       -- 부서번호가 NULL인 사원들의 급여합
*/


SELECT DEPTNO "부서번호", SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
/*
10	 8750
20	10875
30	 9400
	 8700       -- 부서번호가 NULL인 사원들의 급여합
	37725       -- 모든 부서 직원들의 급여합
*/

-- ▼ NULL로 나타나는 부서번호에 값을 부여하자!

-- ① EMP 테이블에서
SELECT NVL(DEPTNO, '모든부서') "부서번호"
     , SUM(SAL) "급여합"
FROM EMP
GROUP BY ROLLUP(DEPTNO);
-- 에러 발생 : ORA-01722: invalid number (DEPTNO는 숫자타입)

SELECT NVL(TO_CHAR(DEPTNO), '모든부서') "부서번호"
     , SUM(SAL) "급여합"
FROM EMP
GROUP BY ROLLUP(DEPTNO);

-- ② EBL_EMP 테이블에서
SELECT NVL(TO_CHAR(DEPTNO), '모든부서') "부서번호"
     , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
/*
10	         8750
20	        10875
30	         9400
모든부서	 8700
모든부서	37725
*/
-- ▶ NULL 값이 두 개이기 때문에 문제 발생!






