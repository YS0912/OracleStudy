SELECT USER
FROM DUAL;


-- 과제
/*
1. PRC_입고_UPDATE(입고번호, 입고수량)    ▷ 출고 업데이트 했던 것처럼만 하자!
2. PRC_입고_DELETE(입고번호)
3. PRC_출고_DELETE(출고번호)
*/
-- ▷ 프로시저 생성은 20220902_02_scott(plsql) 확인

-- 1. PRC_입고_UPDATE(입고번호, 입고수량) --------------------------------------

-- 기존 데이터 조회
SELECT *
FROM TBL_상품;
-- H001	스크류바	1000	0
SELECT *
FROM TBL_입고;
-- 3	H001	2022-09-02	50	800

-- 프로시저 호출을 통한 정상 작동여부 확인
EXEC PRC_입고_UPDATE(3, 60);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_입고_UPDATE(3, 40);
-- ORA-20001: 재고 부족

-- 작동 후 확인
SELECT *
FROM TBL_상품;
-- H001	스크류바	1000	10
SELECT *
FROM TBL_입고;
-- 3	H001	2022-09-02	60	800


-- 2. PRC_입고_DELETE(입고번호) ------------------------------------------------

-- 기존 데이터 확인
SELECT *
FROM TBL_상품;
-- C001	구구콘	1500	30
SELECT *
FROM TBL_입고;
-- 구구콘 입고 1회(기존데이터)만 조회

-- TEST용 데이터를 TBL_입고에 입력
EXEC PRC_입고_INSERT('C001', 30, 1200);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 확인
SELECT *
FROM TBL_상품;
-- C001	구구콘	1500	60
SELECT *
FROM TBL_입고;
-- 7	C001	2022-09-02	30	1200

-- 프로시저 호출을 통한 정상 작동여부 확인
EXEC PRC_입고_DELETE(7);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 작동 후 확인
SELECT *
FROM TBL_상품;
-- C001	구구콘	1500	30
SELECT *
FROM TBL_입고;
-- 입고번호 7 조회 결과 없음


-- 3. PRC_출고_DELETE(출고번호) ------------------------------------------------

-- TEST용 데이터를 TBL_출고에 입력
EXEC PRC_출고_INSERT('H002', 30, 1000);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 확인
SELECT *
FROM TBL_출고;
-- 2	H002	2022-09-02	30	1000
SELECT *
FROM TBL_상품;
-- H002	캔디바	300	70

-- 프로시저 호출을 통한 정상 작동여부 확인
EXEC PRC_출고_DELETE(2);

-- 작동 후 확인
SELECT *
FROM TBL_상품;
-- H002	캔디바	300	100
SELECT *
FROM TBL_출고;
-- 출고번호 2 조회 결과 없음


