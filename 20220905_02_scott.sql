SELECT USER
FROM DUAL;
-- SCOTT


-- ■■■ AFTER STATEMENT TRIGGER 상황 실습 ■■■ --
-- ▷DML 작업에 대한 이벤트 기록

-- 실습 테이블 생성(TBL_TEST1)
CREATE TABLE TBL_TEST1
( ID    NUMBER
, NAME  VARCHAR2(30)
, TEL   VARCHAR2(60)
, CONSTRAINT TEST1_ID_PK PRIMARY KEY(ID)
);
-- Table TBL_TEST1이(가) 생성되었습니다.

-- 실습 테이블 생성(TBL_EVENTLOG)
CREATE TABLE TBL_EVENTLOG
( MEMO  VARCHAR2(200)
, INJA  DATE DEFAULT SYSDATE
);
-- Table TBL_EVENTLOG이(가) 생성되었습니다.

-- 확인
SELECT *
FROM TBL_TEST1;
-- 조회결과 없음

SELECT *
FROM TBL_EVENTLOG;
-- 조회결과 없음

-- ▼ 생성한 TRIGGER 작동여부 확인
--    ▷ TBL_TEST1 테이블을 대상으로 INSERT, UPDATE, DELETE 수행
INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(1, '민찬우', '010-1111-1111');
-- 1 행 이(가) 삽입되었습니다.

UPDATE TBL_TEST1
SET NAME = '민달팽이'
WHERE ID = 1;
-- 1 행 이(가) 업데이트되었습니다.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(2, '최나윤', '010-2222-2222');
-- 1 행 이(가) 삽입되었습니다.

UPDATE TBL_TEST1
SET NAME = '최달팽이'
WHERE ID = 2;
-- 1 행 이(가) 업데이트되었습니다.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(3, '엄달팽이', '010-3333-3333');
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(4, '장달팽이', '010-4444-4444');
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(5, '조달팽이', '010-5555-5555');
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(6, '정달팽이', '010-6666-6666');
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(7, '박달팽이', '010-7777-7777');
-- 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_TEST1;

DELETE
FROM TBL_TEST1;
-- 7개 행 이(가) 삭제되었습니다.

-- 확인
SELECT *
FROM TBL_TEST1;
-- 조회결과 없음

COMMIT;
-- 커밋 완료.

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
-- Session이(가) 변경되었습니다.

SELECT *
FROM TBL_EVENTLOG;
/*
INSERT 쿼리가 실행되었습니다.	2022-09-05 10:08:16
UPDATE 쿼리가 실행되었습니다.	2022-09-05 10:09:51
INSERT 쿼리가 실행되었습니다.	2022-09-05 10:10:31
UPDATE 쿼리가 실행되었습니다.	2022-09-05 10:11:34
INSERT 쿼리가 실행되었습니다.	2022-09-05 10:12:09
INSERT 쿼리가 실행되었습니다.	2022-09-05 10:13:11
INSERT 쿼리가 실행되었습니다.	2022-09-05 10:13:14
INSERT 쿼리가 실행되었습니다.	2022-09-05 10:13:16
INSERT 쿼리가 실행되었습니다.	2022-09-05 10:13:36
DELETE 쿼리가 실행되었습니다.	2022-09-05 10:14:48
*/


--------------------------------------------------------------------------------

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(8, '김보경', '010-8888-8888');
-- 1 행 이(가) 삽입되었습니다.

UPDATE TBL_TEST1
SET NAME = '김달팽이'
WHERE ID = 8;
-- 1 행 이(가) 업데이트되었습니다.

DELETE
FROM TBL_TEST1
WHERE ID = 8;
-- 1 행 이(가) 삭제되었습니다.

-- 시간대 변경 (→ 오전 7시 40분)
-- ▷ 오라클 서버가 있는 컴퓨터의 시간을 바꿔야 트리거 작동
INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(9, '고연수', '010-9999-9999');


------------------ ■■■ BEFORE ROW TRIGGER 상황 실습 ■■■ ------------------

-- ▷ 참조 관계가 설정된 데이터(자식) 삭제를 먼저 수행하는 모델

-- 실습을 위한 테이블 생성(TBL_TEST2)
CREATE TABLE TBL_TEST2
( CODE  NUMBER
, NAME  VARCHAR2(40)
, CONSTRAINT TEST2_CODE_PK PRIMARY KEY(CODE)
);
-- Table TBL_TEST2이(가) 생성되었습니다.

-- 실습을 위한 테이블 생성(TBL_TEST3)
CREATE TABLE TBL_TEST3
( SID   NUMBER
, CODE  NUMBER
, SU    NUMBER
, CONSTRAINT TET3_SID_PK PRIMARY KEY(SID)
, CONSTRAINT TEST3_CODE_FK FOREIGN KEY(CODE)
             REFERENCES TBL_TEST2(CODE)
);
-- Table TBL_TEST3이(가) 생성되었습니다.


-- 실습 관련 데이터 입력
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(1, '텔레비전');
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(2, '냉장고');
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(3, '세탁기');
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(4, '건조기');
-- 1 행 이(가) 삽입되었습니다. * 4

SELECT *
FROM TBL_TEST2;
/*
1	텔레비전
2	냉장고
3	세탁기
4	건조기
*/

COMMIT;


-- 실습 관련 데이터 입력
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(1, 1, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(2, 2, 20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(3, 3, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(4, 4, 20);

INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(5, 1, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(6, 2, 20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(7, 3, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(8, 4, 20);

INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(9, 1, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(10, 2, 20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(11, 3, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(12, 4, 20);

INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(13, 1, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(14, 2, 20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(15, 3, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(16, 4, 20);

INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(17, 1, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(18, 2, 20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(19, 3, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(20, 4, 20);

COMMIT;
-- 커밋 완료.


SELECT *
FROM TBL_TEST2;
SELECT *
FROM TBL_TEST3;


-- TBL_TEST2(부모) 테이블의 데이터 삭제 시도
DELETE
FROM TBL_TEST2
WHERE CODE = 4;
-- 에러 발생 : ORA-02292: integrity constraint (SCOTT.TEST3_CODE_FK) violated - child record found

DELETE
FROM TBL_TEST2
WHERE CODE = 4;
-- 1 행 이(가) 삭제되었습니다.

DELETE
FROM TBL_TEST2
WHERE CODE = 3;
-- 1 행 이(가) 삭제되었습니다.

DELETE
FROM TBL_TEST2
WHERE CODE = 2;
-- 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_TEST3;
/*
1	1	30
5	1	30
9	1	30
13	1	30
17	1	30
*/

COMMIT;
-- 커밋 완료.


------------------ ■■■ AFTER ROW TRIGGER 상황 실습 ■■■ -------------------

-- ▷ 참조 테이블 관련 트랜잭션 처리

SELECT *
FROM TBL_상품;
SELECT *
FROM TBL_입고;

INSERT INTO TBL_입고(입고번호, 상품코드, 입고수량, 입고단가)
VALUES(7, 'C003', 70, 2000);
-- 1 행 이(가) 삽입되었습니다. (브라보콘)

SELECT *
FROM TBL_상품;
-- C003	브라보콘	1300	70


-- 패키지 활용 실습 ------------------------------------------------------------

-- 생성한 함수 호출 → 패키지명.함수명()
SELECT INSA_PACK.FN_GENDER('751212-1234567') "함수호출결과"
FROM DUAL;
-- 남자

SELECT INSA_PACK.FN_GENDER('751212-2234567') "함수호출결과"
FROM DUAL;
-- 여자
















