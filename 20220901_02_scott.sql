SELECT USER
FROM DUAL;
-- SCOTT

-- 프로시저 관련 실습 진행 -----------------------------------------------------

-- 실습 테이블 생성
CREATE TABLE TBL_STUDENTS
( ID    VARCHAR2(10)
, NAME  VARCHAR2(40)
, TEL   VARCHAR2(30)
, ADDR  VARCHAR2(100)
);
-- Table TBL_STUDENTS이(가) 생성되었습니다.

-- 실습 테이블 생성
CREATE TABLE TBL_IDPW
( ID    VARCHAR2(10)
, PW    VARCHAR2(20)
, CONSTRAINT IDPW_ID_PK PRIMARY KEY(ID)
);
-- Table TBL_IDPW이(가) 생성되었습니다.


-- 두 테이블에 데이터 입력
INSERT INTO TBL_STUDENTS(ID, NAME, TEL, ADDR)
VALUES('superman', '최동현', '010-1111-1111', '제주도 서귀포시');
INSERT INTO TBL_IDPW(ID, PW)
VALUES('superman', 'java002$');
-- 1 행 이(가) 삽입되었습니다. * 2

-- 확인
SELECT *
FROM TBL_STUDENTS;
SELECT *
FROM TBL_IDPW;
-- superman	최동현	010-1111-1111	제주도 서귀포시
-- superman	java002$

COMMIT;
-- 커밋 완료.


-- 위의 업무를 수행하는 프로시저(INSERT 프로시저, 입력 프로시저)를 생성하게 되면
-- EXEC PRC_STUDENTS_INSERT('batman', 'java002$', '김태민', '010-2222-2222', '서울 마포구');
-- 이와 같은 구문 한 줄로 양쪽 테이블에 모두 제대로 입력할 수 있다.


-- ▶ 프로시저 생성구문은
--    20220901_01_scott(plsql).sql 파일 참조

-- ▼ 프로시저 호출을 통한 확인
EXEC PRC_STUDENTS_INSERT('batman', 'java002$', '김태민', '010-2222-2222', '서울 마포구');
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 프로시저 호출 이후 확인
SELECT *
FROM TBL_STUDENTS;
/*
superman	최동현	010-1111-1111	제주도 서귀포시
batman	    김태민	010-2222-2222	서울 마포구
*/
SELECT *
FROM TBL_IDPW;
/*
superman	java002$
batman	    java002$
*/


-- ▼ 실습 테이블 생성(TBL_SUNGJUK)
CREATE TABLE TBL_SUNGJUK
( HAKBUN    NUMBER
, NAME      VARCHAR2(40)
, KOR       NUMBER(3)
, ENG       NUMBER(3)
, MAT       NUMBER(3)
, CONSTRAINT SUNGJUK_HAKBUN_PK PRIMARY KEY(HAKBUN)
);
-- Table TBL_SUNGJUK이(가) 생성되었습니다.


-- ▼ 생성된 테이블에 컬럼 추가 (총점, 평균, 등급)                                ▶ 추가한 컬럼에 대한 항목은 프로시저 실습을 위한 것!
--    (총점 → TOT, 평균 → AVG, 등급 → GRADE)                                      실제 테이블 구조에 적합하지도, 바람직하지도 않은 내용이다. 
--                                                                                   (기존 컬럼을 연산해서 구할 수 있음)
ALTER TABLE TBL_SUNGJUK
ADD (TOT NUMBER(3), AVG NUMBER(4, 1), GRADE CHAR);
-- Table TBL_SUNGJUK이(가) 변경되었습니다.

-- 변경된 테이블 구조 확인
DESC TBL_SUNGJUK;
/*
이름     널?       유형           
------ -------- ------------ 
HAKBUN NOT NULL NUMBER       
NAME            VARCHAR2(40) 
KOR             NUMBER(3)    
ENG             NUMBER(3)    
MAT             NUMBER(3)    
TOT             NUMBER(3)    
AVG             NUMBER(4,1)  
GRADE           CHAR(1) 
*/


--------------------------------------------------------------------------------


-- ▶ 프로시저 생성구문은
--    20220901_01_scott(plsql).sql 파일 참조

SELECT *
FROM TBL_SUNGJUK;
-- 조회 결과 없음

-- ▼ 프로시저 호출을 통한 확인
EXEC PRC_SUNGJUK_INSERT(1, '엄소연', 90, 80, 70);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 프로시저 호출 후 확인
SELECT *
FROM TBL_SUNGJUK;


EXEC PRC_SUNGJUK_INSERT(2, '정미경', 80, 70, 60);
EXEC PRC_SUNGJUK_INSERT(3, '임시연', 82, 71, 60);
EXEC PRC_SUNGJUK_INSERT(4, '유동현', 54, 63, 72);
EXEC PRC_SUNGJUK_INSERT(5, '장현성', 44, 33, 22);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다. * 4


-- ▼ 프로시저 호출을 통한 확인
EXEC PRC_SUNGJUK_UPDATE(1, 50, 50, 50);
EXEC PRC_SUNGJUK_UPDATE(5, 100, 99, 98);

-- 프로시저 호출 후 확인
SELECT *
FROM TBL_SUNGJUK;
/*
1	엄소연	50	50	50	150	50	F
2	정미경	80	70	60	210	70	C
3	임시연	82	71	60	213	71	C
4	유동현	54	63	72	189	63	D
5	장현성	100	99	98	297	99	A
*/


--------------------------------------------------------------------------------

-- ▶ 프로시저 생성구문은
--    20220901_01_scott(plsql).sql 파일 참조

-- ▼ 프로시저 호출을 통한 확인
EXEC PRC_STUDENTS_UPDATE('batman', '1234', '010-9999-8888', '서울 종로구');
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.
-- ▷ 변경 X
EXEC PRC_STUDENTS_UPDATE('superman', 'java002$', '010-9876-5432', '강원도 횡성');
EXEC PRC_STUDENTS_UPDATE('batman', 'java002$', '010-9999-8888', '서울 종로구');
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.
-- ▷ 변경 ○

-- 프로시저 호출 후 확인
SELECT *
FROM TBL_STUDENTS;

SELECT EMPNO, ENAME, JOB, DEPTNO
FROM EMP
WHERE DEPTNO = 20
  AND 1 = 2;


-- ▶ 프로시저 생성구문은
--    20220901_01_scott(plsql).sql 파일 참조

-- ▼ 프로시저 호출을 통한 확인
EXEC PRC_INSA_INSERT('조현하', '970124-2234567', SYSDATE, '서울', '010-7202-6306', '개발부', '대리', 2000000, 2000000);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 프로시저 호출 후 확인
SELECT *
FROM TBL_INSA;


--------------------------------------------------------------------------------


-- 실습 테이블 생성(TBL_상품) ◁ 이해를 돕기 위한 한글명!
CREATE TABLE TBL_상품
( 상품코드       VARCHAR2(20)
, 상품명         VARCHAR2(100)
, 소비자가격     NUMBER
, 재고수량       NUMBER DEFAULT 0
, CONSTRAINT 상품_상품코드_PK PRIMARY KEY(상품코드)
);
-- Table TBL_상품이(가) 생성되었습니다.

-- 실습 테이블 생성(TBL_입고)
CREATE TABLE TBL_입고
( 입고번호  NUMBER
, 상품코드  VARCHAR2(20)
, 입고일자  DATE DEFAULT SYSDATE
, 입고수량  NUMBER
, 입고단가  NUMBER
, CONSTRAINT 입고_입고번호_PK PRIMARY KEY(입고번호)
, CONSTRAINT 입고_상품코드_FK FOREIGN KEY(상품코드)
             REFERENCES TBL_상품(상품코드)
);
-- Table TBL_입고이(가) 생성되었습니다.


-- TBL_상품 테이블에 상품 데이터 입력
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C001', '구구콘', 1500);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C002', '월드콘', 1500);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C003', '브라보콘', 1300);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C004', '누가콘', 1800);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C005', '슈퍼콘', 1900);
-- 1 행 이(가) 삽입되었습니다. * 5

INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H001', '스크류바', 1000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H002', '캔디바', 300);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H003', '쌍쌍바', 500);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H004', '돼지바', 600);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H005', '메로나', 500);
-- 1 행 이(가) 삽입되었습니다. * 5

INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E001', '찰떡아이스', 2500);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E002', '붕어싸만코', 2000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E003', '빵또아', 2300);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E004', '거북알', 2300);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E005', '쿠키오', 2400);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E006', '국화빵', 2000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E007', '투게더', 3000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E008', '엑설런트', 3000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E009', '셀렉션', 3000);
-- 1 행 이(가) 삽입되었습니다. * 9

-- 확인
SELECT *
FROM TBL_상품;

COMMIT;
-- 커밋 완료.



