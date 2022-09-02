SELECT USER
FROM DUAL;
-- SCOTT


-- 20220831_03_scott(plsql)에서 이어서 -----------------------------------------

-- ▼ TBL_INSA 테이블의 급여 계산 전용 함수를 정의한다.
--    급여는 『(기본급*12)+수당』 기반으로 연산을 수행한다.
--    함수명 : FN_PAY(기본급, 수당)

CREATE OR REPLACE FUNCTION FN_PAY( V_BASICPAY NUMBER, V_SUDANG NUMBER )
RETURN NUMBER
IS
    V_RESULT    NUMBER;
BEGIN
    V_RESULT := (NVL(V_BASICPAY, 0) * 12) + NVL(V_SUDANG, 0);                       -- ★CHECK★ NULL 값이 연산에 포함되면 NULL이 되니 주의!
    
    RETURN V_RESULT;
    
END;
-- Function FN_PAY이(가) 컴파일되었습니다.

-- 확인
SELECT NUM, NAME, BASICPAY, SUDANG
     , FN_PAY(BASICPAY, SUDANG) "급여"
FROM TBL_INSA;


-- ▼ TBL_INSA 테이블에서 입사일을 기준으로
--    현재까지 근무년수를 반환하는 함수를 정의한다.
--    단, 근무년수는 소수점 이하 한자리까지 계산한다.
--    함수명 : FN_WORKYEAR(입사일)

-- 내 풀이 ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION FN_WORKYEAR( V_IBSADATE DATE )
RETURN NUMBER
IS
    V_RESULT    NUMBER;
BEGIN
    V_RESULT := ROUND((SYSDATE - V_IBSADATE)/365, 1);
    
    RETURN V_RESULT;
    
END;
-- Function FN_WORKYEAR이(가) 컴파일되었습니다.

-- 선생님 풀이 -----------------------------------------------------------------

-- ①
CREATE OR REPLACE FUNCTION FN_WORKYEAR( V_IBSADATE DATE )
RETURN VARCHAR2
IS
    V_RESULT    VARCHAR2(20);
BEGIN
    V_RESULT := TRUNC(MONTHS_BETWEEN(SYSDATE, V_IBSADATE)/12) || '년' ||
                TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, V_IBSADATE), 12)) || '개월';
    
    RETURN V_RESULT;
END;
-- Function FN_WORKYEAR이(가) 컴파일되었습니다.

-- ②
CREATE OR REPLACE FUNCTION FN_WORKYEAR( V_IBSADATE DATE )
RETURN NUMBER
IS
    V_RESULT    NUMBER;
BEGIN
    V_RESULT := TRUNC(MONTHS_BETWEEN(SYSDATE, V_IBSADATE)/12, 1);
    
    RETURN V_RESULT;
END;

-- 확인
SELECT NUM, NAME, IBSADATE, FN_WORKYEAR(IBSADATE) "근무년수"
FROM TBL_INSA;

--------------------------------------------------------------------------------


-- ▼ 참고

-- 1. INSERT, UPDATE, DELETE, (MERGE)
--    ▷ DML(Data Manipulation Language)
--       COMMIT / ROLLBACK 이 필요

-- 2. CREATE, DROP, ALTER, (TRUNCATE)
--    ▷ DDL(Data Definition Language)
--       실행하면 자동으로 COMMIT

-- 3. GRANT, REVOKE
--    ▷ DCL(Data Control Language)
--       실행하면 자동으로 COMMIT

-- 4. COMMIT, ROLLBACK
--    ▷ TCL(Transaction Control Language)


--------------------------------------------------------------------------------


--■■■ PROCEDURE(프로시저) ■■■--

-- 1. PL/SQL에서 가장 대표적인 구조인 스토어드 프로시저는
--    개발자가 자주 장성해야 하는 업무의 흐름을
--    미리 작성하여 데이터베이스 내에 저장해 두었다가
--    필요할 때마다 호출하여 실행할 수 있도록 처리해 주는 구문이다.

-- 2. 형식 및 구조
/*
      CREATE [OR REPLACE] PROCEDURE 프로시저명
      [( 매개변수 IN 데이터타입
       , 매개변수 OUT 데이터타입
       , 매개변수 INOUT 데이터타입
      )]
      IS
          [-- 주요 변수 선언]
      BEGIN
          -- 실행 구문;
          ...
          [EXCEPTION]
            -- 예외 처리 구문;
      END;
*/
-- ▶ FUNCTION과 비교했을 때
--    『RETURN 반환자료형』 부분이 존재하지 않으며,
--    『RETURN』 문 자체도 존재하지 않으며,
--    프로시저 실행 시 넘겨주게 되는 매개변수는
--    IN, OUT, INOUT으로 구분된다.

-- 3. 실행(호출)
/*
      EXC[UTE] 프로시저명[(인수1, 인수2, ...)];
*/


-- 프로시저 관련 실습 진행을 위해 20220901_02_scott.sql 파일에
-- 테이블 생성 및 데이터 입력 수행

-- ▼ 프로시저 생성
--    프로시저 명: PRC_STUDENTS_INSERT(아이디, 패스워드, 이름, 전화, 주소)
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_INSERT
( V_ID      IN TBL_IDPW.ID%TYPE
, V_PW      IN TBL_IDPW.PW%TYPE
, V_NAME    IN TBL_STUDENTS.NAME%TYPE
, V_TEL     IN TBL_STUDENTS.TEL%TYPE
, V_ADDR    IN TBL_STUDENTS.ADDR%TYPE
)
IS
BEGIN
    INSERT INTO TBL_IDPW(ID, PW)
    VALUES(V_ID, V_PW);
    
    INSERT INTO TBL_STUDENTS(ID, NAME, TEL, ADDR)
    VALUES(V_ID, V_NAME, V_TEL, V_ADDR);
    
    COMMIT;
END;
-- Procedure PRC_STUDENTS_INSERT이(가) 컴파일되었습니다.


-- ▼ TBL_SUNGJUK 테이블에서 데이터 입력 시
--    특정 항목(학번, 이름, 국어점수, 영어점수, 수학점수)의 데이터만 입력하면 
--    내부적으로  총점, 평균, 등급 항목에 대한 처리가 함께 이루어질 수 있도록 하는
--    프로시저를 작성(생성)한다.
--    프로시저 명 : PRC_SUNGJUK_INSERT()
/*
      실행 예)
      EXEC PRC_SUNGJUK_INSERT(1, '엄소연', 90, 80, 70);
      
      → 프로시저 호출로 처리된 결과
         학번   이름    국어점수    영어점수    수학점수    총점  평균  등급
          1    엄소연      90          80          70        240   80     B
*/

CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_INSERT
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE 
, V_NAME    IN TBL_SUNGJUK.NAME%TYPE 
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE 
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE 
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE 
)
IS
    -- 선언부
    -- INSERT 쿼리문 수행을 하기 위해 필요한 변수
    V_TOT       TBL_SUNGJUK.TOT%TYPE;
    V_AVG       TBL_SUNGJUK.AVG%TYPE;
    V_GRADE     TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    -- 실행부
    -- INSERT 쿼리문을 수행하기 전에
    -- 선언부에서 선언한 주요 변수들에 값을 담아내야 한다.
    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := V_TOT / 3;
    
    -- V_GRADE := 상황에 따른 분기 필요
    IF (V_AVG >= 90)
        THEN V_GRADE := 'A';
    ELSIF (V_AVG >= 80)
        THEN V_GRADE := 'B';
    ELSIF (V_AVG >= 70)
        THEN V_GRADE := 'C';
    ELSIF (V_AVG >= 60)
        THEN V_GRADE := 'D';
    ELSE
        V_GRADE := 'F';
    END IF;
    
    -- INSERT 쿼리문 수행
    INSERT INTO TBL_SUNGJUK(HAKBUN, NAME, KOR, ENG, MAT, TOT, AVG, GRADE)
    VALUES(V_HAKBUN, V_NAME, V_KOR, V_ENG, V_MAT, V_TOT, V_AVG, V_GRADE);
    
    COMMIT;
    
END;
-- Procedure PRC_SUNGJUK_INSERT이(가) 컴파일되었습니다.


-- ▼ TBL_SUNGJUK 테이블에서 데이터 수정 시
--    특정 항목(학번, 이름, 국어점수, 영어점수, 수학점수)의 데이터만 입력하면 
--    내부적으로  총점, 평균, 등급 항목에 대한 처리가 함께 이루어질 수 있도록 하는
--    프로시저를 작성(생성)한다.
--    프로시저 명 : PRC_SUNGJUK_UPDATE()
/*
      실행 예)
      EXEC PRC_SUNGJUK_UPDATE(1, 50, 50, 50);

      → 프로시저 호출로 처리된 결과
         학번   이름    국어점수    영어점수    수학점수    총점  평균  등급
          1    엄소연      50          50          50        150   50     F
*/

--CREATE OR REPLACE PRC_SUNGJUK_UPDATE

CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_UPDATE
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
    -- 선언부
    -- UPDATE 쿼리문 수행을 위해 필요한 주요 변수 선언
    V_TOT       TBL_SUNGJUK.TOT%TYPE;
    V_AVG       TBL_SUNGJUK.AVG%TYPE;
    V_GRADE     TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    -- 실행부
    -- UPDATE 쿼리문 수행에 앞서 추가로 선언한 주요 변수들에 값 담아내기
    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := V_TOT / 3;
    
    IF (V_AVG >= 90)
        THEN V_GRADE := 'A';
    ELSIF (V_AVG >= 80)
        THEN V_GRADE := 'B';
    ELSIF (V_AVG >= 70)
        THEN V_GRADE := 'C';
    ELSIF (V_AVG >= 60)
        THEN V_GRADE := 'D';
    ELSE
        V_GRADE := 'F';
    END IF;
    
    UPDATE TBL_SUNGJUK
    SET KOR = V_KOR
      , ENG = V_ENG
      , MAT = V_MAT
      , TOT = V_TOT
      , AVG = V_AVG
      , GRADE = V_GRADE
    WHERE HAKBUN = V_HAKBUN;
    
    COMMIT;
    
END;
-- Procedure PRC_SUNGJUK_UPDATE이(가) 컴파일되었습니다.


-- ▼ TBL_STUDENTS 테이블에서 전화번호와 주소 데이터를 변경하는(수정하는)
--    프로시저를 작성한다.
--    단, ID와 PW가 일치하는 경우에만 수정을 진행할 수 있도록 처리한다.
--    프로시저 명 : PRC_STUDENTS_UPDATE()
/*
      실행 예)
      EXEC PRC_STUDENTS_UPDATE('superman', 'java002', '010-9876-5432', '강원도 횡성');
      ▷ 패스워드 불일치 : 데이터 수정 X
      
      EXEC PRC_STUDENTS_UPDATE('superman', 'java002$', '010-9876-5432', '강원도 횡성');
      ▷ 패스워드 일치 : 데이터 수정 ○
*/

CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID      TBL_STUDENTS.ID%TYPE
, V_PW      TBL_IDPW.PW%TYPE
, V_TEL     TBL_STUDENTS.TEL%TYPE
, V_ADDR    TBL_STUDENTS.ADDR%TYPE
)
IS
    -- V_TEMP  TBL_IDPW.PW%TYPE;
BEGIN
    -- V_TEMP := (SELECT PW                                                         ▷ 이 방법은 선생님 풀이 ② 확인!
    --            FROM TBL_IDPW
    --            WHERE ID = V_ID);
    
    -- UPDATE TBL_STUDENTS S JOIN TBL_IDPW I ON S.ID = I.ID                         ▷ 괄호로 묶으면 됨!!
    UPDATE TBL_STUDENTS
    SET TEL = V_TEL
      , ADDR = V_ADDR
    WHERE ID = V_ID
      AND V_PW = (SELECT PW
                  FROM TBL_IDPW
                  WHERE ID = V_ID);
                  
-- 선생님 풀이 -----------------------------------------------------------------
/* ①
BEGIN
    UPDATE (SELECT T1.ID, T1.PW, T2.TEL, T2.ADDR
            FROM TBL_IDPW T1 JOIN TBL_STUDENTS T2
            ON T1.ID = T2.ID) T
    SET T.TEL = V_TEL, T.ADDR = V_ADDR
    WHERE T.ID = V_ID
      AND T.PW = V_PW;
*/
    
/* ②
IS
    -- 필요한 변수 선언
    V_PW2   TBL_IDPW.PW%TYPE;
    V_FLAG  NUMBER := 0;
BEGIN
    -- 패스워드가 맞는지 확인
    -- (사용자가 입력한 V_PW가 기존 패스워드와 동일한지 확인)
    SELECT PW INTO V_PW2
    FROM TBL_IDPW
    WHERE ID = V_ID;
    
    -- 패스워드 일치 여부에 따른 분기
    IF (V_PW = V_PW2)
        THEN V_FLAG := 1;
    ELSE
        V_FLAG := 2;
    END IF;
    
    -- UPDATE 쿼리문 수행 → TBL_STUDENTS (분기 결과 반영)
    UPDATE TBL_STUDENTS
    SET TEL = V_TEL, ADDR = V_ADDR
    WHERE ID = V_ID
      AND V_FLAG = 1;
*/
    
    COMMIT;
    
END;
-- Procedure PRC_STUDENTS_UPDATE이(가) 컴파일되었습니다.


-- ▼ TBL_INSA 테이블을 대상으로 신규 데이터 입력 프로시저를 작성한다.
--    NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG 
--    으로 구성된 컬럼 중
--    NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG
--    의 데이터 입력 시
--    NUM 컬럼(사원번호)의 값은
--    기존 부여된 사원 번호의 마지막 번호 그 다음 번호를 자동으로 입력 처리할 수 있는
--    프로시저로 구성한다.
--    프로시저 명 : PRC_INSA_INSERT()
/*
      실행 예)
      EXEC PRC_INSA_INSERT('조현하', '970124-2234567', SYSDATE, '서울', '010-7202-6306'
                         , '개발부', '대리', 2000000, 2000000);
                         
      → 프로시저 호출로 처리된 결과
         1061 조현하 970124-2234567 2022-09-01 서울 010-7202-6306 개발부 대리 2000000 2000000
*/

CREATE OR REPLACE PROCEDURE PRC_INSA_INSERT
( V_NAME        IN TBL_INSA.NAME%TYPE
, V_SSN         IN TBL_INSA.SSN%TYPE
, V_IBSADATE    IN TBL_INSA.IBSADATE%TYPE
, V_CITY        IN TBL_INSA.CITY%TYPE
, V_TEL         IN TBL_INSA.TEL%TYPE
, V_BUSEO       IN TBL_INSA.BUSEO%TYPE
, V_JIKWI       IN TBL_INSA.JIKWI%TYPE
, V_BASICPAY    IN TBL_INSA.BASICPAY%TYPE
, V_SUDANG      IN TBL_INSA.SUDANG%TYPE
)
IS
    V_NUM   TBL_INSA.NUM%TYPE;
BEGIN
    -- NUM 계산
    SELECT NVL(MAX(NUM), 0) + 1 INTO V_NUM      -- 나 : COUNT(*) 사용
    FROM TBL_INSA;
    
    INSERT INTO TBL_INSA(NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG)
    VALUES(V_NUM, V_NAME, V_SSN, V_IBSADATE, V_CITY, V_TEL, V_BUSEO, V_JIKWI, V_BASICPAY, V_SUDANG);
    
    COMMIT;
    
END;
-- Procedure PRC_INSA_INSERT이(가) 컴파일되었습니다.

SELECT *
FROM TBL_INSA;

-- 보충 설명
SELECT 출고번호
FROM TBL_출고;
-- 조회 결과 없음
-- ▷ 따라서 NVL(출고번호, 0) 처리 후 MAX() 처리를 해도 원하는 값이 나오지 않는다.
--    NVL(MAX(출고번호), 0)로 처리하자!






















