SELECT USER
FROM DUAL;
-- HR


/*
--■■■ 무결성(Integrity) ■■■--

1. 무결성에는 개체 무결성(Entity Integrity)
              참조 무결성(Reference Integrity)
              범위 무결성(Domain Integrity)이 있다.
              
2. 개체 무결성(Entity Integrity)                         ▷ 중복되는 값이 없도록 하는 것
   개체 무결성은 릴레이션에서 저장되는 튜플(tuple)의
   유일성을 보장하기 위한 제약조건이다.
   
3. 참조 무결성(Reference Integrity)                      ▷ 참조 하는 쪽에서 데이터를 받아올 때 문제가 없도록 하는 것 
   참조 무결성은 릴레이션 간의 데이터 일관성을
   보장하기 위한 제약조건이다.

4. 범위 무결성(Domain Integrity)                       ▷ 데이터가 포함되어야 하는 범위를 지키도록 하는 것 (ex. 나이)
   도메인 무결성은 허용 가능한 값의 범위를
   지정하기 위한 제약조건이다.

5. 제약조건의 종류

   ① PRIMARY KEY(PK:P) → 기본키, 고유키, 식별키, 식별자
      해당 컬럼의 값은 반드시 존재해야 하며, 유일해야 한다.
      (NOT NULL과 UNIQUE가 결합된 형태)
   
   ② FOREIGN KEY(FK:F:R) → 외래키, 외부키, 참조키
      해당 컬럼의 값은 참조되는 테이블의 컬럼 데이터들 중 하나와
      일치하거나 NULL을 가진다.
      
   ③ UNIQUE(UK:U)
      테이블 내에서 해당 컬럼의 값은 항상 유일해야 한다.
      
   ④ NOT NULL(NN:CK:C)
      해당 컬럼은 NULL을 포함할 수 없다.
      
   ⑤ CHECK(CK:C)
      해당 컬럼에 저장 가능한 데이터의 범위나 조건을 지정한다.
*/


--■■■ PRIMARY KEY ■■■--

-- 1. 테이블에 대한 기본 키를 생성한다.

-- 2. 테이블에서 각 행을 유일하게 식별하는 컬럼 또는 컬럼의 집합니다.
--    기본 키는 테이블 당 최대 하나만 존재한다.
--    그러나 반드시 하나의 컬럼으로만 구성되는 것은 아니다.
--    NULL일 수 없고, 이미 테이블에 존재하고 있는 데이터를
--    다시 입력할 수 없도록 처리한다. (유일성)
--    UNIQUE INDEX가 오라클 내부적으로 자동으로 생성된다.

-- 3. 형식 및 구조
--    ① 컬럼 레벨의 형식
--       컬럼명 데이터타입 [CONSTRAINT CONSTRAINT명] PRIMARY KEY[(컬럼명, ...)]

--    ② 테이블 레벨의 형식
--       컬럼명 데이터타입,
--       컬럼명 데이터타입,
--       CONSTRAINT CONSTRAINT명 PRIMARY KEY(컬럼명, ...)

-- 4. CONSTRAINT 추가 시 CONSTRAINT명을 생략하면
--    오라클 서버가 자동적으로 CONSTRAINT명을 부여한다.
--    일반적으로 CONSTRAINT명은 『테이블명_컬럼명_CONSTRAINT약자』
--    형식으로 기술한다.

-- ▼ PK 지정 실습 (① 컬럼 레벨의 형식) ---------------------------------------
-- 테이블 생성
CREATE TABLE TBL_TEST1
( COL1  NUMBER(5)       PRIMARY KEY
, COL2  VARCHAR2(30)
);
-- Table TBL_TEST1이(가) 생성되었습니다.

SELECT *
FROM TBL_TEST1;

DESC TBL_TEST1;
/*
이름   널?       유형           
---- -------- ------------ 
COL1 NOT NULL NUMBER(5)    
COL2          VARCHAR2(30) 
*/

-- 데이터 입력
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(1, 'TEST');
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(1, 'TEST');    -- 에러 발생 : ORA-00001: unique constraint (HR.SYS_C007060) violated
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(1, 'ABCD');    -- 에러 발생 : ORA-00001: unique constraint (HR.SYS_C007060) violated
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(2, 'ABCD');
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(3, NULL);
INSERT INTO TBL_TEST1(COL1) VALUES(4);
INSERT INTO TBL_TEST1(COL1) VALUES(4);                  -- 에러 발생 : ORA-00001: unique constraint (HR.SYS_C007060) violated
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(5, 'ABCD');
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(NULL, NULL);   -- 에러 발생 : ORA-01400: cannot insert NULL into ("HR"."TBL_TEST1"."COL1")

COMMIT;
-- 커밋 완료.

SELECT *
FROM TBL_TEST1;
/*
1	TEST
2	ABCD
3	(null)
4	(null)
5	ABCD
*/

DESC TBL_TEST1;
/*
이름   널?       유형           
---- -------- ------------ 
COL1 NOT NULL NUMBER(5)         ▷ PK 제약조건 확인 불가
COL2          VARCHAR2(30) 
*/

-- ▼ 제약조건 확인
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TBL_TEST1';
-- HR	SYS_C007060	P	TBL_TEST1					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	GENERATED NAME			22/08/24	HR	SYS_C007060	

SELECT *
FROM USER_CONS_COLUMNS
WHERE TABLE_NAME = 'TBL_TEST1';
-- HR	SYS_C007060	TBL_TEST1	COL1	1

-- ▼ USER_CONSTRAINTS와 USER_CONS_COLUMNS를 대상으로
--    제약조건이 설정된 소유주, 제약조건명, 테이블명, 제약조건종류, 컬럼명 항목을 조회한다.
SELECT CC.OWNER, CC.CONSTRAINT_NAME, CC.TABLE_NAME, C.CONSTRAINT_TYPE, CC.COLUMN_NAME
FROM USER_CONSTRAINTS C JOIN USER_CONS_COLUMNS CC
ON CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME;


-- ▼ PK 지정 실습 (② 컬럼 레벨의 형식) ---------------------------------------
-- 테이블 생성
CREATE TABLE TBL_TEST2
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, CONSTRAINT TEST2_COL1_PK PRIMARY KEY(COL1)
);
-- Table TBL_TEST2이(가) 생성되었습니다.

-- 데이터 입력
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(1, 'TEST');
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(1, 'TEST');        -- 에러 발생 : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(1, 'ABCD');        -- 에러 발생 : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(2, 'ABCD');
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(3, NULL);
INSERT INTO TBL_TEST2(COL1) VALUES(4);
INSERT INTO TBL_TEST2(COL1) VALUES(4);                      -- 에러 발생 : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(5, 'ABCD');
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(NULL, NULL);       -- 에러 발생 : ORA-01400: cannot insert NULL into ("HR"."TBL_TEST2"."COL1")
INSERT INTO TBL_TEST2(COL2) VALUES('KKKK');                 -- ORA-01400: cannot insert NULL into ("HR"."TBL_TEST2"."COL1")

COMMIT;
-- 커밋 완료.

SELECT *
FROM TBL_TEST2;
/*
1	TEST
2	ABCD
3	(null)
4	(null)
5	ABCD
*/

-- ▼ USER_CONSTRAINTS와 USER_CONS_COLUMNS를 대상으로
--    제약조건이 설정된 소유주, 제약조건명, 테이블명, 제약조건종류, 컬럼명 항목을 조회한다.
SELECT CC.OWNER, CC.CONSTRAINT_NAME, CC.TABLE_NAME, C.CONSTRAINT_TYPE, CC.COLUMN_NAME
FROM USER_CONSTRAINTS C, USER_CONS_COLUMNS CC
WHERE CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
  AND C.TABLE_NAME = 'TBL_TEST2';
-- HR	TEST2_COL1_PK	TBL_TEST2	P	COL1


-- ▼ PK 지정 실습 (③ 다중 컬럼 PK 지정) --------------------------------------
-- 테이블 생성
CREATE TABLE TBL_TEST3
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, CONSTRAINT TEST3_COL1_COL2_PK PRIMARY KEY(COL1,COL2)
);
-- Table TBL_TEST3이(가) 생성되었습니다.

-- 데이터 입력
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(1, 'TEST');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(1, 'TEST');        -- 에러 발생 : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(1, 'ABCD');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(2, 'ABCD');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(2, 'TEST');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(3, NULL);          -- 에러 발생 : ORA-01400: cannot insert NULL into ("HR"."TBL_TEST3"."COL2")

INSERT INTO TBL_TEST3(COL1) VALUES(4);
INSERT INTO TBL_TEST3(COL1) VALUES(4);                      -- 에러 발생 : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(5, 'ABCD');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(NULL, NULL);       -- 에러 발생 : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST3(COL2) VALUES('KKKK');                 -- 에러 발생 : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated

COMMIT;
-- 커밋 완료.

SELECT *
FROM TBL_TEST3;
/*
1	ABCD
1	TEST
2	ABCD
2	TEST
*/

-- ▼ USER_CONSTRAINTS와 USER_CONS_COLUMNS를 대상으로
--    제약조건이 설정된 소유주, 제약조건명, 테이블명, 제약조건종류, 컬럼명 항목을 조회한다.
SELECT CC.OWNER, CC.CONSTRAINT_NAME, CC.TABLE_NAME, C.CONSTRAINT_TYPE, CC.COLUMN_NAME
FROM USER_CONSTRAINTS C, USER_CONS_COLUMNS CC
WHERE CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
  AND C.TABLE_NAME = 'TBL_TEST3';
/*
HR	TEST3_COL1_COL2_PK	TBL_TEST3	P	COL1
HR	TEST3_COL1_COL2_PK	TBL_TEST3	P	COL2

▶ 조회 결과는 2개지만,
   CONSTRAINT_NAME이 동일하기 때문에 같은 제약조건이다.
*/


-- ▼ PK 지정 실습 (④ 테이블 생성 이후 제약조건 추가 설정) --------------------
-- 테이블 생성
CREATE TABLE TBL_TEST4
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
);
-- Table TBL_TEST4이(가) 생성되었습니다.

-- ▷ 이미 생성된(만들어져 있는) 테이블에
--    부여하려는 제약조건을 위반한 데이터가 포함되어 있을 경우
--    해당 테이블에 제약조건을 추가하는 것은 불가능하다.

-- 제약조건 추가
ALTER TABLE TBL_TEST4
ADD CONSTRAINT TEST4_COL1_PK PRIMARY KEY(COL1);
-- Table TBL_TEST4이(가) 변경되었습니다.

-- ▼ USER_CONSTRAINTS와 USER_CONS_COLUMNS를 대상으로
--    제약조건이 설정된 소유주, 제약조건명, 테이블명, 제약조건종류, 컬럼명 항목을 조회한다.
SELECT CC.OWNER, CC.CONSTRAINT_NAME, CC.TABLE_NAME, C.CONSTRAINT_TYPE, CC.COLUMN_NAME
FROM USER_CONSTRAINTS C, USER_CONS_COLUMNS CC
WHERE CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
  AND C.TABLE_NAME = 'TBL_TEST4';
-- HR	TEST4_COL1_PK	TBL_TEST4	P	COL1


-- ▼ 제약조건 확인 전용 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VIEW_CONSTCHECK
AS
SELECT UC.OWNER "OWNER"
     , UC.CONSTRAINT_NAME "CONSTRAINT_NAME"
     , UC.TABLE_NAME "TABLE_NAME"
     , UC.CONSTRAINT_TYPE "CONSTRAINT_TYPE"
     , UCC.COLUMN_NAME "COLUMN_NAME"
     , UC.SEARCH_CONDITION "SEARCH_CONDITION"
     , UC.DELETE_RULE "DELETE_RULE"
FROM USER_CONSTRAINTS UC JOIN USER_CONS_COLUMNS UCC
ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME;
-- View VIEW_CONSTCHECK이(가) 생성되었습니다.

-- 생성된 뷰(VIEW)를 통한 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST4';
-- HR	TEST4_COL1_PK	TBL_TEST4	P	COL1    (null)  (null)


--------------------------------------------------------------------------------


--■■■ UNIQUE(UK:U) ■■■--

-- 1. 테이블에서 지정한 컬럼의 데이터가 중복되지 않고 유일할 수 있도록 설정하는 제약조건
--    PRIMARY KEY와 유사한 제약조건이지만, NULL을 허용한다는 차이점이 있다.
--    내부적으로 PRIMARR KEY와 마찬가지로 UNIQUE INDEX가 자동 생성된다.
--    하나의 테이블 내에서 UNIQUE 제약조건은 여러 번 설정하는 것이 가능하다.
--    즉, 하나의 테이블에 UNIQUE 제약조건을 여러 개 만드는 것은 가능하다는 것이다.

-- 2. 형식 및 구조
--    ① 컬럼 레벨의 형식
--       컬럼명 데이터타입 [CONSTRAINT CONSTRAINT명] UNIQUE

--    ② 테이블 레벨의 형식
--       컬럼명 데이터타입,
--       컬럼명 데이터타입,
--       CONSTRAINT CONSTRAINT명 UNIQUE(컬럼명, ...)

-- ▼ UK 지정 실습(① 컬럼 레벨의 형식) ----------------------------------------
-- 테이블 생성
CREATE TABLE TBL_TEST5
( COL1 NUMBER(5)        PRIMARY KEY
, COL2 VARCHAR2(30)     UNIQUE
);
-- Table TBL_TEST5이(가) 생성되었습니다.

-- 제약조건 조회
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST5';
/*
HR	SYS_C007064	TBL_TEST5	P	COL1		
HR	SYS_C007065	TBL_TEST5	U	COL2		
*/

-- 데이터 입력
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(1, 'TEST5');
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(1, 'TEST5');       -- 에러 발생 : ORA-00001: unique constraint (HR.SYS_C007064) violated
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(2, 'ABCD');
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(3, 'ABCD');        -- 에러 발생 : ORA-00001: unique constraint (HR.SYS_C007065) violated
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(3, NULL);
INSERT INTO TBL_TEST5(COL1) VALUES(4);                      -- NULL은 데이터가 아니기 때문에 UNIQUE 제약조건에 걸리지 않는다.
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(5, 'ABCD');        -- 에러 발생 : ORA-00001: unique constraint (HR.SYS_C007065) violated

COMMIT;

SELECT *
FROM TBL_TEST5;
/*
1	TEST5
2	ABCD
3	(null)
4	(null)
*/

-- ▼ UK 지정 실습(② 테이블 레벨의 형식) --------------------------------------
-- 테이블 생성
CREATE TABLE TBL_TEST6
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, CONSTRAINT TEST6_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST6_COL2_UK UNIQUE(COL2)
);
-- Table TBL_TEST6이(가) 생성되었습니다.

SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST6';
/*
HR	TEST6_COL1_PK	TBL_TEST6	P	COL1		
HR	TEST6_COL2_UK	TBL_TEST6	U	COL2		
*/

-- ▼ UK 지정 실습(③ 테이블 생성 이후 제약조건 추가) --------------------------
-- 테이블 생성
CREATE TABLE TBL_TEST7
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
);
-- Table TBL_TEST7이(가) 생성되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST7';
-- 조회 결과 없음

-- 제약조건 추가
ALTER TABLE TBL_TEST7
ADD CONSTRAINT TEST7_COL1_PK PRIMARY KEY(COL1);
-- +
ALTER TABLE TBL_TEST7
ADD CONSTRAINT TEST7_COL2_UK PRIMARY KEY(COL2);
-- ↓
ALTER TABLE TBL_TEST7
ADD( CONSTRAINT TEST7_COL1_PK PRIMARY KEY(COL1)
   , CONSTRAINT TEST7_COL2_UK UNIQUE(COL2) );
-- Table TBL_TEST7이(가) 변경되었습니다.

-- 제약조건 추가 이후 다시 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST7';
/*
HR	TEST7_COL1_PK	TBL_TEST7	P	COL1		
HR	TEST7_COL2_UK	TBL_TEST7	U	COL2		
*/


--------------------------------------------------------------------------------


--■■■ CHECK(CK:C) ■■■--

-- 1. 컬럼에서 허용 가능한 데이터의 범위나 조건을 지정하기 위한 제약조건                 ▷ Ex. NUMBER(3) 형태의 데이터 범위를 0~100으로 한정 (성적)
--    컬럼에 입력되는 데이터를 검사하여 조건에 맞는 데이터만 입력될 수 있도록 한다.
--    또한, 컬럼에서 수정되는 데이터를 검사하여 조건에 맞는 데이터로 수정되는 것만
--    허용하는 기능을 수행하게 된다.

-- 2. 형식 및 구조
--    ① 컬럼 레벨의 형식
--       컬럼명 데이터타입 [CONSTRAINT CONSTRAINT명] CHECK(컬럼 조건)

--    ② 테이블 레벨의 형식
--       컬럼명 데이터타입,
--       컬럼명 데이터타입,
--       CONSTRAINT CONSTRAINT명 CHECK(컬럼 조건)

-- ▼ CK 지정 실습(① 컬럼 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST8
( COL1  NUMBER(5)       PRIMARY KEY
, COL2  VARCHAR2(30)
, COL3  NUMBER(3)       CHECK(COL3 BETWEEN 0 AND 100)
);
-- Table TBL_TEST8이(가) 생성되었습니다.

-- 데이터 입력
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(1, '조영관', 100);
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(1, '민찬우', 100);      -- 에러 발생 : ORA-00001: unique constraint (HR.SYS_C007071) violated
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(2, '민찬우', 101);      -- 에러 발생 : ORA-02290: check constraint (HR.SYS_C007070) violated
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(2, '민찬우', -1);       -- 에러 발생 : ORA-02290: check constraint (HR.SYS_C007070) violated
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(2, '민찬우', 80);

-- 확인
SELECT *
FROM TBL_TEST8;
/*
1	조영관	100
2	민찬우	80
*/

COMMIT;
-- 커밋 완료.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST8';
/*
HR	SYS_C007070	TBL_TEST8	C	COL3	COL3 BETWEEN 0 AND 100	
HR	SYS_C007071	TBL_TEST8	P	COL1		
*/

-- ▼ CK 지정실습(② 테이블 레벨의 형식) ---------------------------------------
-- 테이블 생성
CREATE TABLE TBL_TEST9
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, COL3  NUMBER(3)
, CONSTRAINT TEST9_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST9_COL3_CK CHECK(COL3 BETWEEN 0 AND 100)
);
-- Table TBL_TEST9이(가) 생성되었습니다.

-- 데이터 입력
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(1, '조영관', 100);
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(1, '민찬우', 100);      -- 에러 발생 : ORA-00001: unique constraint (HR.SYS_C007071) violated
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(2, '민찬우', 101);      -- 에러 발생 : ORA-02290: check constraint (HR.SYS_C007070) violated
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(2, '민찬우', -1);       -- 에러 발생 : ORA-02290: check constraint (HR.SYS_C007070) violated
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(2, '민찬우', 80);

-- 확인
SELECT *
FROM TBL_TEST9;

COMMIT;
-- 커밋 완료.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST9';
/*
HR	TEST9_COL3_CK	TBL_TEST9	C	COL3	COL3 BETWEEN 0 AND 100	
HR	TEST9_COL1_PK	TBL_TEST9	P	COL1		
*/

-- ▼ CK 지정 실습(③ 테이블 생성 이후 제약조건 추가) --------------------------
-- 테이블 추가
CREATE TABLE TBL_TEST10
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, COL3  NUMBER(3)
);
-- Table TBL_TEST10이(가) 생성되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST10';
-- 조회결과 없음

-- 제약조건 추가
ALTER TABLE TBL_TEST10
ADD ( CONSTRAINT TEST10_COL1_PK PRIMARY KEY(COL1)
    , CONSTRAINT TEST10_COL3_CK CHECK(COL3 BETWEEN 0 AND 100) );
-- Table TBL_TEST10이(가) 변경되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST10';
/*
HR	TEST10_COL1_PK	TBL_TEST10	P	COL1		
HR	TEST10_COL3_CK	TBL_TEST10	C	COL3	COL3 BETWEEN 0 AND 100	
*/


-- 테이블 생성
CREATE TABLE TBL_TESTMEMBER
( SID   NUMBER
, NAME  VARCHAR2(30)
, SSN   CHAR(14)            -- 입력 형태 → 'YYMMDD-NNNNNNN'
, TEL   VARCHAR2(40)
);
-- Table TBL_TESTMEMBER이(가) 생성되었습니다.

-- ▼ TBL_TESTMEMBER 테이블의 SSN 컬럼(주민등록번호 컬럼)에서
--    데이터 입력이나 수정 시, 성별이 유효한 데이터만 입력될 수 있도록
--    체크 제약조건을 추가할 수 있도록 한다.
--    (→ 주민번호 특정 자리에 입력 가능한 데이터를 1, 2, 3, 4만 가능하도록 처리)
--    또한, SID 컬럼에는 PRIMARY KEY 제약조건을 설정할 수 있도록 한다.
ALTER TABLE TBL_TESTMEMBER
ADD ( CONSTRAINT TESTMEMBER_SID_PK PRIMARY KEY(SID)
    , CONSTRAINT TESTMEMBER_SSN_CK CHECK(SUBSTR(SSN, 8, 1) BETWEEN 1 AND 4) );
-- Table TBL_TESTMEMBER이(가) 변경되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TESTMEMBER';
/*
HR	TESTMEMBER_SID_PK	TBL_TESTMEMBER	P	SID		
HR	TESTMEMBER_SSN_CK	TBL_TESTMEMBER	C	SSN	SUBSTR(SSN, 8, 1) BETWEEN 1 AND 4	
*/

-- 데이터 입력 테스트
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(1, '엄소연', '941124-2234567', '010-1111-1111');
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(2, '최동현', '950222-1234567', '010-2222-2222');
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(3, '유동현', '040601-3234567', '010-3333-3333');
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(4, '김유림', '050215-4234567', '010-4444-4444');

INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)                 -- 에러 발생 : ORA-02290: check constraint (HR.TESTMEMBER_SSN_CK) violated
VALUES(5, '박원석', '980301-5234567', '010-5555-5555');
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)                 -- 에러 발생 : ORA-02290: check constraint (HR.TESTMEMBER_SSN_CK) violated
VALUES(6, '한은영', '990729-6234567', '010-6666-6666');

-- 확인
SELECT *
FROM TBL_TESTMEMBER;
/*
1	엄소연	941124-2234567	010-1111-1111
2	최동현	950222-1234567	010-2222-2222
3	유동현	040601-3234567	010-3333-3333
4	김유림	050215-4234567	010-4444-4444
*/

COMMIT;
-- 커밋 완료.


--------------------------------------------------------------------------------


--■■■ FOREIGN KEY(FK:F:R) ■■■--

-- 1. 참조 키(R) 또는 외래 키(FK:F)는 두 테이블의 데이터 간 연결을 설정하고
--    강제 적용시키는데 사용되는 열이다.
--    한 테이블의 기본 키 값이 있는 열을
--    다른 테이블에 추가하면 테이블 간 연결을 설정할 수 있다.
--    이 때, 두 번째 테이블에 추가되는 열이 외래키가 된다.

-- 2. 부모 테이블(참조받는 컬럼이 포함된 테이블)이 먼저 생성된 후
--    자식 테이블(참조하는 컬럼이 포함된 테이블)이 생성되어야 한다.
--    이 때, 자식 테이블에 FOREIGN KEY 제약조건이 설정된다.

-- 3. 형식 및 구조
--    ① 컬럼 레벨의 형식
--       컬럼명 데이터타입 [CONSTRAINT CONSTRAINT명]
--                          REFERENCES 참조테이블명(참조컬럼명)
--                         [ON DELETE CASCADE | ON DELETE SET NULL] → 추가 옵션

--    ② 테이블 레벨의 형식
--       컬럼명 데이터타입,
--       컬럼명 데이터타입,
--       CONSTRAINT CONSTRAINT명 FOREIGN KEY(컬럼명)
--                  REFERENCES 참조테이블명(참조컬럼명)
--                  [ON DELETE CASCADE | ON DELETE SET NULL]    → 추가 옵션

-- ▷ FOREIGN KEY 제약조건을 설정하는 실습을 진행하기 위해서는
--    부모 테이블의 생성 작업을 먼저 수행해야 한다.
--    그리고 이 때, 부모 테이블에는 반드시 PK 또는 UK 제약조건이
--    설정된 컬럼이 존재해야 한다.

-- 부모 테이블 생성
CREATE TABLE TBL_JOBS
( JIKWI_ID      NUMBER
, JIKWI_NAME    VARCHAR2(30)
, CONSTRAINT JOBS_ID_PK PRIMARY KEY(JIKWI_ID)
);
-- Table TBL_JOBS이(가) 생성되었습니다.

-- 부모 테이블에 데이터 입력
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(1, '사원');
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(2, '대리');
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(3, '과장');
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(4, '부장');
-- 1 행 이(가) 삽입되었습니다. * 4

SELECT *
FROM TBL_JOBS;

COMMIT;
-- 커밋 완료.

-- ▼ FK 지정 실습(① 컬럼 레벨의 형식) ----------------------------------------
-- 테이블 생성
CREATE TABLE TBL_EMP1
( SID       NUMBER          PRIMARY KEY
, NAME      VARCHAR2(30)
, JIKWI_ID  NUMBER          REFERENCES TBL_JOBS(JIKWI_ID)
);
-- Table TBL_EMP1이(가) 생성되었습니다.
-- ▷ 길이를 지정하지 않으면 NUMBER는 최대값, CHAR는 1

-- 제약조건 확인
SELECT*
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
/*
HR	SYS_C007079	TBL_EMP1	P	SID		
HR	SYS_C007080	TBL_EMP1	R	JIKWI_ID		NO ACTION
*/

-- 데이터 입력
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(1, '정미경', 1);
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(2, '최나윤', 2);
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(3, '민찬우', 3);
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(4, '조영관', 4);

INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(5, '고연수', 5);      -- 에러 발생 : ORA-02291: integrity constraint (HR.SYS_C007080) violated - parent key not found
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(5, '고연수', 1);
INSERT INTO TBL_EMP1(SID, NAME) VALUES(6, '김태민');

SELECT *
FROM TBL_EMP1;
/*
1	정미경	1
2	최나윤	2
3	민찬우	3
4	조영관	4
5	고연수	1
6	김태민	
*/

COMMIT;
-- 커밋 완료.

-- ▼ FK 지정 실습(② 테이블 레벨의 형식) --------------------------------------
-- 테이블 생성
CREATE TABLE TBL_EMP2
( SID       NUMBER
, NAME      VARCHAR2(30)
, JIKWI_ID  NUMBER
, CONSTRAINT EMP2_SID_PK PRIMARY KEY(SID)
, CONSTRAINT EMP2_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
             REFERENCES TBL_JOBS(JIKWI_ID)
);
-- Table TBL_EMP2이(가) 생성되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP2';
/*
HR	EMP2_SID_PK	        TBL_EMP2	P	SID		
HR	EMP2_JIKWI_ID_FK	TBL_EMP2	R	JIKWI_ID		NO ACTION
*/

-- ▼ FK 지정 실습(③ 테이블 생성 이후 제약조건 추가) --------------------------
-- 테이블 생성
CREATE TABLE TBL_EMP3
( SID       NUMBER
, NAME      VARCHAR2(30)
, JIKWI_ID  NUMBER
);
-- Table TBL_EMP3이(가) 생성되었습니다.

-- 제약조건 추가
ALTER TABLE TBL_EMP3
ADD ( CONSTRAINT EMP3_SID_PK PRIMARY KEY(SID)
    , CONSTRAINT EMP3_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
                 REFERENCES TBL_JOBS(JIKWI_ID) );
-- Table TBL_EMP3이(가) 변경되었습니다.

-- 제약조건 제거
ALTER TABLE TBL_EMP3
DROP CONSTRAINT EMP3_JIKWI_ID_FK;
-- Table TBL_EMP3이(가) 변경되었습니다.

-- 제약조건 조회
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP3';
-- HR	EMP3_SID_PK	TBL_EMP3	P	SID		

-- 다시 제약조건 추가
ALTER TABLE TBL_EMP3
ADD CONSTRAINT EMP3_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
               REFERENCES TBL_JOBS(JIKWI_ID);
-- Table TBL_EMP3이(가) 변경되었습니다.

-- 다시 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP3';
/*
HR	EMP3_SID_PK	TBL_EMP3	P	SID		
HR	EMP3_JIKWI_ID_FK	TBL_EMP3	R	JIKWI_ID		NO ACTION
*/


-- 4. FOREIGN KEY 생성 시 주의사항
--    참조하고자 하는 부모 테이블을 먼저 생성해야 한다.
--    참조하고자 하는 컬럼이 PRIMARY KEY 또는 UNIQUE 제약조건이 설정되어 있어야 한다.
--    테이블 사이에 PRIMARY KEY와 FOREIGN KEY가 정의되어 있으면
--    PRIMARY KEY 제약조건이 설정된 데이터 삭제 시
--    FOREIGN KEY 컬럼에 그 값이 입력되어 있는 경우 삭제되지 않는다.
--    (즉, 자식 테이블에 참조하는 레코드가 존재할 경우
--    부모 테이블의 참조받는 해당 레코드는 삭제가 불가능하다.)

--    단, FK 설정 과정에서 『ON DELETE CASCADE』나 『ON DELETE SET NULL』 옵션을
--    사용하여 설정한 경우에는 삭제가 가능하다.
--    또한, 부모 테이블을 제거하기 위해서는 자식 테이블을 먼저 제거해야 한다.

-- 부모 테이블
SELECT *
FROM TBL_JOBS;
/*
1	사원
2	대리
3	과장
4	부장
*/

-- 자식 테이블
SELECT *
FROM TBL_EMP1;
/*
1	정미경	1
2	최나윤	2
3	민찬우	3
4	조영관	4
5	고연수	1
6	김태민	
*/

-- 부모 테이블 제거 시도
DROP TABLE TBL_JOBS;
-- 에러 발생 : ORA-02449: unique/primary keys in table referenced by foreign keys

-- 부모 테이블의 부장 직위 삭제 시도
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 4;
-- 에러 발생 : ORA-02292: integrity constraint (HR.SYS_C007080) violated - child record found

-- 조영관 부장의 직위를 사원으로 변경
UPDATE TBL_EMP1
SET JIKWI_ID = 1
WHERE SID = 4;
-- 1 행 이(가) 업데이트되었습니다.

SELECT *
FROM TBL_EMP1;
/*
1	정미경	1
2	최나윤	2
3	민찬우	3
4	조영관	1
5	고연수	1
6	김태민	
*/

COMMIT;
-- 커밋 완료.

-- ▷ 부모 테이블(TBL_JOBS)에 부장 데이터를 참조하고 있는
--    자식 테이블(TBL_EMP1)의 데이터가 존재하지 않는 상황!

-- 위와 같은 상황에서 부모 테이블(TBL_JOBS)의 부장 데이터 삭제
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 4;
-- 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_JOBS;
/*
1	사원
2	대리
3	과장
*/

COMMIT;
-- 커밋 완료.

-- 부모 테이블(TBL_JOBS)의 사원 데이터 삭제
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 1;
-- 에러 발생 : ORA-02292: integrity constraint (HR.SYS_C007080) violated - child record found

-- 부모 테이블의 데이터를 자유롭게? 삭제하기 위해서는
-- 『ON DELETE CASCADE』 옵션 지정이 필요하다.

-- ▼ TBL_EMP1 테이블(자식 테이블)에서 FK 제약조건을 제거한 후
--    CASCADE 옵션을 포함하여 다시 FK 제약조건을 설정한다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
/*
HR	SYS_C007079	TBL_EMP1	P	SID		
HR	SYS_C007080	TBL_EMP1	R	JIKWI_ID		NO ACTION   ◀◀◀◀
*/

-- 제약조건 제거
ALTER TABLE TBL_EMP1
DROP CONSTRAINT SYS_C007080;
-- Table TBL_EMP1이(가) 변경되었습니다.

-- 제약조건 제거 이후 다시 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
-- HR	SYS_C007079	TBL_EMP1	P	SID		

-- 『ON DELETE CASCADE』 옵션이 포함된 내용으로 제약조건 다시 지정
ALTER TABLE TBL_EMP1
ADD CONSTRAINT EMP1_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
               REFERENCES TBL_JOBS(JIKWI_ID)
               ON DELETE CASCADE;
-- Table TBL_EMP1이(가) 변경되었습니다.

-- 제약조건 생성 이후 다시 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
/*
HR	SYS_C007079	TBL_EMP1	P	SID		
HR	EMP1_JIKWI_ID_FK	TBL_EMP1	R	JIKWI_ID		CASCADE
*/

-- ▶ CASCADE 옵션을 지정한 후에는
--    참조받고 있는 부모 테이블의 데이터를
--    언제든지 자유롭게 삭제하는 것이 가능하다.
--    단, 부모 테이블의 데이터가 삭제될 경우
--    이를 참조하고 있었던 자식 테이블의 데이터도 모두 함께 삭제된다.

-- 부모 테이블
SELECT *
FROM TBL_JOBS;
/*
1	사원
2	대리
3	과장
*/

-- 자식 테이블
SELECT *
FROM TBL_EMP1;
/*
1	정미경	1
2	최나윤	2
3	민찬우	3
4	조영관	1
5	고연수	1
6	김태민	
*/

-- 부모 테이블(TBL_JOBS)에서 과장 데이터 삭제
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 3;
-- 1 행 이(가) 삭제되었습니다.

-- 자식 테이블(TBL_EMP1) 데이터 확인
SELECT *
FROM TBL_EMP1;
/*
1	정미경	1
2	최나윤	2
4	조영관	1
5	고연수	1
6	김태민	

▷ 민찬우 과장의 데이터가 삭제
*/ 

-- 부모 테이블(TBL_JOBS)에서 사원 데이터 삭제
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 1;
-- 1 행 이(가) 삭제되었습니다.

-- 자식 테이블(TBL_EMP1) 데이터 확인
SELECT *
FROM TBL_EMP1;
/*
2	최나윤	2
6	김태민	

▷ 사원 데이터가 삭제
*/ 


DROP TABLE TBL_EMP2;
-- Table TBL_EMP2이(가) 삭제되었습니다.

DROP TABLE TBL_EMP3;
-- Table TBL_EMP3이(가) 삭제되었습니다.

DROP TBL_JOBS;
-- 에러 발생 : ORA-00950: invalid DROP option

DROP TABLE TBL_EMP1;
-- Table TBL_EMP1이(가) 삭제되었습니다.

DROP TABLE TBL_JOBS;
-- Table TBL_JOBS이(가) 삭제되었습니다.







