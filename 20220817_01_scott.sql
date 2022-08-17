SELECT USER
FROM DUAL;
-- SCOTT


-- TBL_FILES 테이블을 조회하여
-- 다음과 같은 결과를 얻을 수 있도록 쿼리문을 구성한다.
/*
---------   ----------------------
 파일번호   파일명
---------   ----------------------
        1	SALES.DOC
        2	PANMAE.XXLS
        3	RESEARCH.PPT
        4	STUDY.HWP
        5	SQL.TXT
        6	FLOWER.PNG
        7	20220816_01_SCOTT.SQL
---------   ----------------------
*/

SELECT FILENO "파일번호"
     , FILENAME "경로포함파일명"
     , SUBSTR(FILENAME, 16, 9) "파일명"
FROM TBL_FILES
WHERE FILENO = 1;
/*
1	C:\AAA\BBB\CCC\SALES.DOC	SALES.DOC
*/
-- ▷ 이 경우 1번 행을 제외한 나머지 데이터가 문제

SELECT FILENO "파일번호"
     , REVERSE(FILENAME) "거꾸로된경로및파일명"
FROM TBL_FILES;
/*
                                                최초 『\』 등장위치     추출이 필요한 위치 
1	COD.SELAS\CCC\BBB\AAA\:C                            10                    1 ~ 9
2	SLXX.EAMNAP\AAA\:C                                  12                    1 ~11
3	TPP.HCRAESER\:D                                     13                    1 ~12
4	PWH.YDUTS\STNEMUCOD\:C                              10                    1 ~ 9
5	TXT.LQS\KROWEMOH\PMET\STNEMUCOD\:C                   8                    1 ~ 7
6	GNP.REWOLF\TSET\F\ERAHS\:C                          11                    1 ~10
7	LQS.TTOCS_10_61802202\ELCARO\YDUTS\:E               22                    1 ~21
*/

/* ▽
SELECT FILENO "파일번호"
     , REVERSE(FILENAME) "거꾸로된경로및파일명"
     , SUBSTR(대상문자열, 추출시작위치, 최초 『\』 등장위치-1) "거꾸로된 파일명"
FROM TBL_FILES;

-- 최초 『\』 등장위치
--  ▷ INSTR(REVERSE(FILENAME), '\', 1)
*/

SELECT FILENO "파일번호"
     , REVERSE(FILENAME) "거꾸로된경로및파일명"
     , SUBSTR(REVERSE(FILENAME), 1, INSTR(REVERSE(FILENAME), '\', 1)-1) "거꾸로된파일명"
FROM TBL_FILES;

SELECT FILENO "파일번호"
     , FILENAME "경로포함파일명"
     , REVERSE(FILENAME) "거꾸로된경로및파일명"
     , SUBSTR(REVERSE(FILENAME), 1, INSTR(REVERSE(FILENAME), '\', 1)-1) "거꾸로된파일명"
     , REVERSE(SUBSTR(REVERSE(FILENAME), 1, INSTR(REVERSE(FILENAME), '\', 1)-1)) "파일명"
FROM TBL_FILES;
/*
1	SALES.DOC
2	PANMAE.XXLS
3	RESEARCH.PPT
4	STUDY.HWP
5	SQL.TXT
6	FLOWER.PNG
7	20220816_01_SCOTT.SQL
*/

-- ▼ 다른 방법
SELECT FILENO "파일번호"
     , FILENAME "경로포함파일명"
     , INSTR(FILENAME, '\', -1) "마지막 위치"
     , SUBSTR(FILENAME, INSTR(FILENAME, '\', -1) +1) "파일명"
FROM TBL_FILES;


-- ▼ LPAD()
--    Byte를 확보하여 왼쪽부터 문자로 채우는 기능을 가진 함수
SELECT 'ORACLE' "COL1"
     , LPAD('ORACLE', 10, '*') "COL2"
FROM DUAL;
-- ① 10Byte 공간을 확보한다.                           (두 번째 파라미터)
-- ② 확보한 공간에 'ORACLE' 문자열을 담는다.           (첫 번째 파라미터)
-- ③ 남아있는 Byte 공간을 왼쪽부터 『*』로 채운다.     (세 번재 파라미터)
-- ④ 이렇게 구성된 최종 결과값을 반환한다.
-- ORACLE	****ORACLE

-- ▼ RPAD()
--    Byte를 확보하여 오른쪽부터 문자로 채우는 기능을 가진 함수
SELECT 'ORACLE' "COL1"
     , RPAD('ORACLE', 10, '*') "COL2"
FROM DUAL;
-- ① 10Byte 공간을 확보한다.                           (두 번째 파라미터)
-- ② 확보한 공간에 'ORACLE' 문자열을 담는다.           (첫 번째 파라미터)
-- ③ 남아있는 Byte 공간을 오른쪽부터 『*』로 채운다.   (세 번재 파라미터)
-- ④ 이렇게 구성된 최종 결과값을 반환한다.
-- ORACLE	ORACLE****


-- ▼ LTRIM()
--    첫 번째 파라미터 값에 해당하는 문자열을 대상으로
--    왼쪽부터 연속적으로 등장하는 두 번재 파라미터 값에서 지정한 글자와
--    같은 글자가 등장할 경우 이를 제거한 결과값을 반환한다.
--    단, 완성형으로 처리되지 않는다.
--    (왼쪽부터 자르는 손톱깎이)
SELECT 'ORAORAORAORACLEORACLE' "COL1"
     , LTRIM('ORAORAORAORACLEORACLE', 'ORA') "COL2"
     , LTRIM('AAAAAAAAAAAACLEORACLE', 'ORA') "COL3"
     , LTRIM('ORAORAoRAORACLEORACLE', 'ORA') "COL4"
     , LTRIM('ORAORA ORAORACLEORACLE', 'ORA') "COL5"
     , LTRIM('                ORACLE', ' ') "COL6"
     , LTRIM('                ORACLE') "COL6"
FROM DUAL;
/*
ORAORAORAORACLEORACLE
CLEORACLE
CLEORACLE
oRAORACLEORACLE
 ORAORACLEORACLE
ORACLE
ORACLE
*/

SELECT LTRIM('김신이김신이김신이김김김이이이신신신박이김신', '김신이') "COL1"
FROM DUAL;
-- 박이김신

-- ▼ RTRIM()
--    첫 번째 파라미터 값에 해당하는 문자열을 대상으로
--    오른쪽부터 연속적으로 등장하는 두 번재 파라미터 값에서 지정한 글자와
--    같은 글자가 등장할 경우 이를 제거한 결과값을 반환한다.
--    단, 완성형으로 처리되지 않는다.
--    (오른쪽부터 자르는 손톱깎이)


-- ▼ TRANSLATE()
--    1:1로 바꿔준다.
SELECT TRANSLATE( 'MY ORACLE SERVER'
                , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                , 'abcdefghijklmnopqrstuvwxyz') "COL1"
FROM DUAL;
-- my oracle server

SELECT TRANSLATE( '010-4050-5510'
                , '0123456789'
                , '공일이삼사오육칠팔구') "COL1"
FROM DUAL;
-- 공일공-사공오공-오오일공

-- ▼ REPLACE()
SELECT REPLACE('MY ORACLE SERVER ORAHOME', 'ORA', '오라') "COL1"
FROM DUAL;
-- MY 오라CLE SERVER 오라HOME


--------------------------------------------------------------------------------
-- 숫자타입 함수


-- ▼ ROUND()
--    반올림을 처리해주는 함수
--    두 번째 파라미터의 숫자 자리까지 표현한다.
SELECT 48.678 "COL1"
     , ROUND(48.678, 2) "COL2"      -- 48.68
     , ROUND(48.674, 2) "COL3"      -- 48.67
     , ROUND(48.674, 1) "COL4"      -- 48.7
     , ROUND(48.674, 0) "COL5"      -- 49
     , ROUND(48.674) "COL6"         -- 49
     , ROUND(48.674, -1) "COL7"     -- 50
     , ROUND(48.674, -2) "COL8"     -- 0
     , ROUND(48.674, -3) "COL9"     -- 0
FROM DUAL;

-- ▼ TRUNC()
--    절삭을 처리해주는 함수
--    두 번재 파라미터의 숫자 자리까지 표현한다.
SELECT 48.678 "COL1"
     , TRUNC(48.678, 2) "COL2"      -- 48.67
     , TRUNC(48.674, 2) "COL3"      -- 48.67
     , TRUNC(48.674, 1) "COL4"      -- 48.6
     , TRUNC(48.674, 0) "COL5"      -- 48
     , TRUNC(48.674) "COL6"         -- 48
     , TRUNC(48.674, -1) "COL7"     -- 40
     , TRUNC(48.674, -2) "COL8"     -- 0
     , TRUNC(48.674, -3) "COL9"     -- 0
FROM DUAL;


-- ▼ MOD()
--    나머지를 반환하는 함수 → JAVA의 『%』
SELECT MOD(5, 2) "COL1"
FROM DUAL;
-- ▷ 5를 2로 나눈 나머지 결과값 반환
-- 1


-- ▼ POWER()
--    제곱의 결과를 반환하는 함수
SELECT POWER(5, 3) "COL1"
FROM DUAL;
-- ▷ 5의 3승을 결과값으로 반환
-- 125


-- ▼ SQRT()
--    루트 결과값을 반환하는 함수
SELECT SQRT(2) "COL1"
FROM DUAL;
-- ▷ 루트 2에 대한 결과값 반환
-- 1.41421356237309504880168872420969807857


-- ▼ LOG()
--    로그 함수
--    (오라클은 상용로그만 지원하는 반면, MSSQL은 상용로그, 자연로그 모두 지원)
SELECT LOG(10, 100) "COL1"
     , LOG(10, 20) "COL2"
FROM DUAL;
-- 2	1.30102999566398119521373889472449302677


-- ▼ 삼각함수
SELECT SIN(1), COS(1), TAN(1)
FROM DUAL;
/*
0.8414709848078965066525023216302989996233
0.5403023058681397174009366074429766037354
1.55740772465490223050697480745836017308
*/
-- ▶ 각각 싸인, 코싸인, 탄젠트 결과값을 반환한다.

-- ▼ 삼각함수의 역함수(범위 : -1 ~ 1)
SELECT ASIN(0.5), ACOS(0.5), ATAN(0.5)
FROM DUAL;
/*
0.52359877559829887307710723054658381405
1.04719755119659774615421446109316762805
0.4636476090008061162142562314612144020295
*/
-- ▶ 각각 어싸인, 어코싸인, 어탄젠트 결과값을 반환한다.


-- ▼ SIGN() 부호
--    연산 결과값이 양수이면 1, 0이면 0, 음수이면 -1을 반환한다.
--    주로 매출이나 수지와 관련하여 적자 및 흑자의 개념을 나타낼 때 사용
SELECT SIGN(5-2) "COL1"
     , SIGN(5-5) "COL2"
     , SIGN(5-7) "COL3"
FROM DUAL;
-- 1	0	-1


-- ▼ ASCII() / CHR()
--    ASCII() : 매개변수로 넘겨받은 문자의 아스키코드 값을 반환한다.
--    CHR()   : 매개변수로 넘겨받은 아스키코드 값으로 해당 문자를 반환한다.
SELECT ASCII('A') "COL1"
     , CHR(65) "COL2"
FROM DUAL;
-- 65	A


--------------------------------------------------------------------------------
-- 날짜 관련 함수


-- 날짜 관련 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
-- Session이(가) 변경되었습니다.


-- ▼ 날짜 연산의 기본 단위 : 일수(DAY)★
SELECT SYSDATE "COL1"           -- 2022-08-17 11:14:23
     , SYSDATE + 1 "COL2"       -- 2022-08-18 11:14:23
     , SYSDATE -2 "COL3"        -- 2022-08-15 11:14:23
     , SYSDATE + 30 "COL4"      -- 2022-09-16 11:14:23
FROM DUAL;

-- ▼ 시간 단위 연산
SELECT SYSDATE "COL1"           -- 2022-08-17 11:15:54
     , SYSDATE + 1/24 "COL2"    -- 2022-08-17 12:15:54
     , SYSDATE + 2/24 "COL3"    -- 2022-08-17 13:15:54
FROM DUAL;


-- ▼ 현재 시간과 현재 시간 기준 1일 2시간 3분 4초 후를 조회한다.
/*
----------------- -----------------
현재 시간         연산 후 시간
----------------- -----------------
20-08-17 11:15:25 20-08-18 13:18:29
----------------- -----------------
*/
-- 방법①
SELECT SYSDATE "현재 시간"
     , SYSDATE + 1 + (2/24) + (3/(24*60)) + (4/(24*60*60)) "연산 후 시간"
FROM DUAL;
/*
2022-08-17 11:24:54
2022-08-18 13:27:58
*/

-- 방법②
SELECT SYSDATE "현재 시간"
     , SYSDATE + ((1*24*60*60) + (2*60*60) + (3*60) +4) / (24*60*60) "연산 후 시간"
FROM DUAL;
/*
2022-08-17 11:27:33
2022-08-18 13:30:37
*/


-- ▼ 날짜 - 날짜 : 일수!
SELECT TO_DATE('2023-01-16', 'YYYY-MM-DD') - TO_DATE('2022-06-27', 'YYYY-MM-DD') "COL1"
FROM DUAL;
-- 203


-- ▼ 데이터 타입의 변환
SELECT TO_DATE('2022-08-17', 'YYYY-MM-DD') "COL1"
FROM DUAL;
-- 2022-08-17 00:00:00

SELECT TO_DATE('2022-08-32', 'YYYY-MM-DD') "COL2"
FROM DUAL;
-- 에러 발생 : ORA-01847: day of month must be between 1 and last day of month

SELECT TO_DATE('2022-02-29', 'YYYY-MM-DD') "COL1"
FROM DUAL;
-- 에러 발생 : ORA-01839: date not valid for month specified

SELECT TO_DATE('2022-13-17', 'YYYY-MM-DD') "COL1"
FROM DUAL;
-- 에러 발생 : ORA-01843: not a valid month

-- ▶ TO_DATE() 함수를 통해 문자 타입을 날짜 타입으로 변환을 수행하는 과정에서
--    내부적으로 해당 날짜에 대한 유효성 검사가 이루어진다.


-- ▼ ADD_MONTHS()
--    월을 더하고 뺀다.
SELECT SYSDATE "COL1"                       -- 2022-08-17 11:37:38
     , ADD_MONTHS(SYSDATE, 2) "COL2"        -- 2022-10-17 11:37:38
     , ADD_MONTHS(SYSDATE, 3) "COL3"        -- 2022-11-17 11:37:38
     , ADD_MONTHS(SYSDATE, -2) "COL4"       -- 2022-06-17 11:37:38
     , ADD_MONTHS(SYSDATE, -3) "COL5"       -- 2022-06-17 11:37:38
FROM DUAL;

-- ▼ MONTHS_BETWEEN()
--    첫 번재 인자값에서 두 번째 인자값을 뺀 개월 수를 반환 → 단위 : 개월 수
SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('2002-05-31', 'YYYY-MM-DD')) "COL1"
FROM DUAL;
-- 242.564088261648745519713261648745519713
-- ▷ 시간이 계속 가고 있기 때문에 소수점 이하 숫자는 계속 바뀐다.
-- ▶ 결과값이 음수로 반환되었을 경우에는
--    첫 번재 인자값에 해당하는 날짜보다
--    두 번째 인자값에 해당하는 날짜가 『미래』라는 의미로 확인할 수 있다.


-- ▼ NEXT_DAY()
--    첫 번째 인자값 이후 가장 빠른 두 번째 인자값(요일)에 해당하는 날짜
SELECT NEXT_DAY(SYSDATE, '토') "COL1"        -- 2022-08-20 11:44:38
     , NEXT_DAY(SYSDATE, '월') "COL2"        -- 2022-08-22 11:44:38
FROM DUAL;

-- 추가 세션 설정 변경
ALTER SESSION SET NLS_DATE_LANGUAGE = 'ENGLISH';
-- Session이(가) 변경되었습니다.
-- ▷ 이 경우 상단 작성한 쿼리에 오류 발생 (ORA-01846: not a valid day of the week)

SELECT NEXT_DAY(SYSDATE, 'SAT') "COL1"        -- 2022-08-20 11:44:38
     , NEXT_DAY(SYSDATE, 'MON') "COL2"        -- 2022-08-22 11:44:38
FROM DUAL;
-- ▶ 영어로 두 번째 인자값을 넘겨줘야 한다.


-- 추가 세션 설정 변경
ALTER SESSION SET NLS_DATE_LANGUAGE = 'KOREAN';
-- Session이(가) 변경되었습니다.

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
-- Session이(가) 변경되었습니다.


-- ▼ LAST_DAY()
--    해당 날짜가 포함되어 있는 그 달의 마지막 날을 반환
SELECT LAST_DAY(SYSDATE) "COL1"
     , LAST_DAY(TO_DATE('2022-02-10', 'YYYY-MM-DD')) "COL2"
     , LAST_DAY(TO_DATE('2019-02-10', 'YYYY-MM-DD')) "COL3"
FROM DUAL;
-- 2022-08-31	2022-02-28	2019-02-28


-- ▼ 태민이가 다시 군대에 끌려간다.
--    복무 기간은 22개월로 한다.

-- 1. 전역 일자를 구한다.
SELECT ADD_MONTHS(SYSDATE, 22) "전역일"
FROM DUAL;
-- 2024-06-17

-- 2. 하루 꼬박꼬박 3끼 식사를 한다고 가정하면,
--    태민이가 몇 끼를 먹어야 집에 보내줄까...
SELECT (ADD_MONTHS(SYSDATE, 22) - SYSDATE) * 3 "끼니"
FROM DUAL;
-- 2010

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
-- Session이(가) 변경되었습니다.

-- ▼ 현재 날짜 및 시각으로부터
--    수료일(2023-01-16 18:00:00)까지 남은 기간을
--    다음과 같은 형태로 조회할 수 있도록 쿼리문을 구성한다.
/*
------------------ ------------------- ------ ------ ------ ------
현재시각           수료일              일     시간    분    초
------------------ ------------------- ------ ------ ------ ------
2022-08-17 12:36:20 2023-01-16 18:00:00  130    5       22    40
------------------ ------------------- ------ ------ ------ ------
*/
-- ▼ ① 내 첫 번째 풀이
SELECT SYSDATE "현재시각"
     , TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') "수료일"
     , TRUNC(TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE) "일"
     , TRUNC( ((TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE) - TRUNC(TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE)) *24) "시간"
     , TRUNC( ((TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE)*24 - TRUNC((TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE)*24) )*60 ) "분"
     , TRUNC( ( (TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE)*24*60 - TRUNC((TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE)*24*60 ) ) * 60 ) "초"
FROM DUAL;
/*
SELECT SYSDATE "현재시각"
     , TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') "수료일"
     , TRUNC(TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE) "일"
     , (일수 단위 날짜 차이 - 일수차이)*24 "시간"
     , (시간 단위 날짜 차이 - 시간차이)*60 "분"
     , (분 단위 날짜 차이 - 분차이)*60 "초"
FROM DUAL
*/

-- ▼ ② 선생님 힌트
-- 『1일 2시간 3분 4초』를 『초』로 환산하면...
SELECT (1*24*60*60) + (2*60*60) + (3*60) + 4
FROM DUAL;
-- 93784

-- 『93784초』를 다시 『일, 시간, 분, 초』로 환산하면...
SELECT TRUNC(TRUNC(TRUNC(93784/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC(93784/60)/60), 24) "시간"
     , MOD(TRUNC(93784/60), 60) "분"
     , MOD(93784, 60) "초"
FROM DUAL;

-- ▼ ③ 내 두 번째 풀이
SELECT SYSDATE "현재시각"
     , TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') "수료일"
     , TRUNC( ( ( ( TRUNC( (TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE)*24*60*60 ) / 60 ) / 60 ) / 24) ) "일"
     , TRUNC( MOD( ( TRUNC( (TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE)*24*60*60 ) / 60 ) / 60, 24 ) ) "시간"
     , TRUNC( MOD( TRUNC( (TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE)*24*60*60 ) / 60, 60) ) "분"
     , TRUNC( MOD( ( TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE )*24*60*60, 60 ) ) "초"
FROM DUAL;
/*
SELECT SYSDATE "현재시각"
     , TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') "수료일"
     , 몫( ( ( ( ( 초단위로 환산한 시간 차이 )를 분단위로 환산한 값 )을 시간 단위로 환산한 값 ) / 24 ) "일"
     , 나머지( ( ( 초단위로 환산한 시간 차이 )를 분단위로 환산한 값 )을 시간 단위로 환산한 값, 24 ) ) "시간"
     , 나머지( (초단위로 환산한 시간 차이)를 분단위로 환산한 값, 60 ) "분"
     , 나머지( 초단위로 환산한 시간 차이, 60 ) "초"
*/

-- ▼ ④ 선생님 풀이
-- 수료일까지 남은 기간 확인 (단위 : 일수)
-- 수료일자 - 현재일자
SELECT TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE
FROM DUAL;
-- 152.098784722222222222222222222222222222

-- 수료일까지 남은 기간 확인 (단위 : 초)
-- (남은 기간) * (하루를 구성하는 전체 초)
SELECT ( TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE ) * (24*60*60)
FROM DUAL;
-- 13141201.99999999999999999999999999999997
-- ▷ 상단의 쿼리문을 『93784』라고 생각하고 대입하면 된다.

SELECT TRUNC(TRUNC(TRUNC(( ( TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE ) * (24*60*60) )/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC(( ( TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE ) * (24*60*60) )/60)/60), 24) "시간"
     , MOD(TRUNC(( ( TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE ) * (24*60*60) )/60), 60) "분"
     , TRUNC( MOD(( ( TO_DATE('2023-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE ) * (24*60*60) ), 60) ) "초"
FROM DUAL;



-- ▼ 각자 태어난 날짜 및 시각으로부터 현재까지 얼마만큼의 시간을 살고 있는지...
--    다음과 같은 형태로 조회할 수 있도록 쿼리문을 구성한다.
/*
------------------ ------------------- ------ ------ ------ ------
현재시각           생년월일            일     시간    분    초
------------------ ------------------- ------ ------ ------ ------
2022-08-17 15:46:20 1994-09-25 11:40:00 130    5       22    40
------------------ ------------------- ------ ------ ------ ------
*/

-- ▶ 고연수_scott.sql 파일에 풀이 있음 (제출)


ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
-- Session이(가) 변경되었습니다.

-- 날짜 데이터를 대상으로 반올림, 절삭 등의 연산을 수행할 수 있다.

-- ▼ 날짜 반올림
SELECT SYSDATE "COL1"                       -- 2022-08-17
     , ROUND(SYSDATE, 'YEAR') "COL2"        -- 2023-01-01   : 연도까지 유효한 데이터 (상반기 / 하반기 기준)
     , ROUND(SYSDATE, 'MONTH') "COL3"       -- 2022-09-01   : 월까지 유효한 데이터(15일 기준)
     , ROUND(SYSDATE, 'DD') "COL4"          -- 2022-08-18   : 일까지 유효한 데이터(정오 기준)
     , ROUND(SYSDATE, 'DAY') "COL5"         -- 2022-08-21   : 일까지 유효한 데이터(수요일 정오 기준)
FROM DUAL;


-- ▼ 날짜 절삭
SELECT SYSDATE "COL1"                       -- 2022-08-17
     , TRUNC(SYSDATE, 'YEAR') "COL2"        -- 2023-01-01   : 연도까지 유효한 데이터
     , TRUNC(SYSDATE, 'MONTH') "COL3"       -- 2022-09-01   : 월까지 유효한 데이터
     , TRUNC(SYSDATE, 'DD') "COL4"          -- 2022-08-18   : 일까지 유효한 데이터
     , TRUNC(SYSDATE, 'DAY') "COL5"         -- 2022-08-21   : 그 전 주에 해당하는 일요일
FROM DUAL;


--------------------------------------------------------------------------------


--■■■ 변환 함수 ■■■--

-- TO_CHAR()    : 숫자나 날짜 데이터를 문자 타입으로 변환시켜주는 함수
-- TO_DATE()    : 문자 데이터를 날짜 타입으로 변환시켜주는 함수
-- TO_NUMBER()  : 문자 데이터를 숫자 타입으로 변환시켜주는 함수


-- ▼ 날짜형 → 문자형
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') "COL1"    -- 2022-08-17
     , TO_CHAR(SYSDATE, 'YYYY') "COL2"          -- 2022
     , TO_CHAR(SYSDATE, 'YEAR') "COL3"          -- TWENTY TWENTY-TWO
     , TO_CHAR(SYSDATE, 'MM') "COL4"            -- 08
     , TO_CHAR(SYSDATE, 'MONTH') "COL5"         -- 8월 
     , TO_CHAR(SYSDATE, 'MON') "COL6"           -- 8월 
     , TO_CHAR(SYSDATE, 'DD') "COL7"            -- 17
     , TO_CHAR(SYSDATE, 'MM-DD') "COL8"         -- 08-17
     , TO_CHAR(SYSDATE, 'DAY') "COL9"           -- 수요일
     , TO_CHAR(SYSDATE, 'DY') "COL10"           -- 수
     , TO_CHAR(SYSDATE, 'HH24') "COL11"         -- 17
     , TO_CHAR(SYSDATE, 'HH') "COL12"           -- 05
     , TO_CHAR(SYSDATE, 'HH AM') "COL13"        -- 05 오후
     , TO_CHAR(SYSDATE, 'HH PM') "COL14"        -- 05 오후
     , TO_CHAR(SYSDATE, 'MI') "COL15"           -- 11
     , TO_CHAR(SYSDATE, 'SS') "COL16"           -- 30
     , TO_CHAR(SYSDATE, 'SSSSS') "COL17"        -- 61890 : 오늘 하루동안 흘러온 초
     , TO_CHAR(SYSDATE, 'Q') "COL18"            -- 3     : 쿼터 (분기)
FROM DUAL;

-- ▶ 날짜나 통화 형식이 맞지 않을 경우, 설정값을 통해 세션을 설정할 수 있다.
ALTER SESSION SET NLS_LANGUAGE = 'KOREAN';
ALTER SESSION SET NLS_DATE_LANGUAGE = 'KOREAN';
ALTER SESSION SET NLS_CURRENCY = '\';               -- ￦
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';


-- ▼ 숫자형 → 문자형
SELECT 7 "COL1"
     , '7' "COL2"
     , TO_CHAR(7) "COL3"
FROM DUAL;
-- ▶ 숫자는 오른쪽 정렬, 문자는 왼쪽 정렬

SELECT TO_NUMBER('4') "COL1"
     , '4' "COL2"
     , 4 "COL3"
     , TO_NUMBER('04') "COL4"
FROM DUAL;
-- 4	4	4	4


-- ▼ 현재 날짜에서 현재 년도(2022)를 숫자 형태로 조회(반환)
SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) "RESULT"
FROM DUAL;
-- 2022


-- ▼ EXTRACT()
SELECT TO_CHAR(SYSDATE, 'YYYY') "COL1"      -- 2022 : 연도를 추출하여 문자 타입으로
     , TO_CHAR(SYSDATE, 'MM') "COL2"        -- 08   : 월을 추출하여 문자 타입으로
     , TO_CHAR(SYSDATE, 'DD') "COL3"        -- 17   : 일을 추출하여 문자 타입으로
     , EXTRACT(YEAR FROM SYSDATE) "COL4"    -- 2022 : 연도를 추출하여 숫자 타입으로
     , EXTRACT(MONTH FROM SYSDATE) "COL5"   -- 8    : 월을 추출하여 숫자 타입으로
     , EXTRACT(DAY FROM SYSDATE) "COL6"     -- 17   : 일을 추출하여 숫자 타입으로
FROM DUAL;
-- ▶ 년, 월, 일 이외의 다른 항목은 불가!


-- ▼ TO_CHAR() 활용 → 형식 맞춤 표기 결과값 반환
SELECT 60000 "COL1"
     , TO_CHAR(60000, '99,999') "COL2"
     , TO_CHAR(60000, '$99,999') "COL3"
     , TO_CHAR(60000, 'L99,999') "COL4"
     , LTRIM(TO_CHAR(60000, 'L99,999')) "COL5"
FROM DUAL;


ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
-- Session이(가) 변경되었습니다.


-- ▼ 현재 시간을 기준으로 1일 2시간 3분 4초 후를 조회한다.
SELECT SYSDATE "현재시간"
     , SYSDATE + 1 + (2/24) + (3/(24*60)) + (4/(24*60*60)) "1일 2시간 3분 4초 후"
FROM DUAL;
/*
2022-08-17 17:43:43
2022-08-18 19:46:47
*/

-- ▼ 현재 시간을 기준으로 1년 2개월 3일 4시간 5분 6초 후를 조회한다.
-- TO_YMINTERVAL() / TO_DSINTERVAL()
SELECT SYSDATE "현재시간"
     , SYSDATE + TO_YMINTERVAL('01-02') + TO_DSINTERVAL('003 04:05:06') "연산결과"
FROM DUAL;
/*
2022-08-17 17:47:42
2023-10-20 21:52:48
*/












