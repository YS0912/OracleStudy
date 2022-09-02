SELECT USER
FROM DUAL;
-- SCOTT


-- 과제
/*
1. PRC_입고_UPDATE(입고번호, 입고수량)    ▷ 출고 업데이트 했던 것처럼만 하자!
2. PRC_입고_DELETE(입고번호)
3. PRC_출고_DELECT(출고번호)
*/

-- 1. PRC_입고_UPDATE(입고번호, 입고수량) --------------------------------------

CREATE OR REPLACE PROCEDURE PRC_입고_UPDATE
( V_입고번호    IN TBL_입고.입고번호%TYPE
, V_입고수량    IN TBL_입고.입고수량%TYPE
)
IS
    -- ③ 쿼리문에 필요한 변수 선언
    V_상품코드        TBL_입고.상품코드%TYPE;
    V_기존입고수량    TBL_입고.입고수량%TYPE;
    V_재고수량        TBL_상품.재고수량%TYPE;
    
    -- ⑦ 예외 변수 추가 선언
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    -- ④ 선언한 변수에 값 담아내기 (V_상품코드, V_기존입고수량)
    SELECT 상품코드, 입고수량 INTO V_상품코드, V_기존입고수량
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    -- ⑥ 선언한 변수에 값 담아내기 (V_재고수량)
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    -- ⑤ (TBL_상품.재고수량 - V_기존입고수량 + V_입고수량이 음수일 경우 예외 발생
    --     ----------------- V_재고수량
    IF ( V_재고수량 - V_기존입고수량 + V_입고수량 < 0 )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- ① UPDATE 쿼리문 → TBL_입고
    UPDATE TBL_입고
    SET 입고수량 = V_입고수량
    WHERE 입고번호 = V_입고번호;
    
    -- ② UPDATE 쿼리문 → TBL_상품
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_기존입고수량 + V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    -- ⑧ 예외 처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '재고 부족');
        WHEN OTHERS
            THEN ROLLBACK;
    
    -- ⑨ 커밋
    COMMIT;
    
END;
-- Procedure PRC_입고_UPDATE이(가) 컴파일되었습니다.


-- 2. PRC_입고_DELETE(입고번호) ------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_입고_DELETE
( V_입고번호    IN TBL_입고.입고번호%TYPE
)
IS
    -- ③ 쿼리문에서 필요한 변수 선언
    V_상품코드  TBL_입고.상품코드%TYPE;
    V_입고수량  TBL_입고.입고수량%TYPE;
    V_재고수량  TBL_상품.재고수량%TYPE;
    
    -- ⑥ 예외 변수 선언
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    -- ⑦ 선언한 변수에 값 담기 (V_재고수량)
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    -- ⑤ TBL_상품.재고수량이 V_입고수량보다 작을 경우 예외 발생
    --    ----------------- V_재고수량
    IF (V_재고수량 < V_입고수량)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- ④ 선언한 변수에 값 담기 (V_상품코드, V_입고수량)
    SELECT 상품코드, 입고수량 INTO V_상품코드, V_입고수량
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    -- ① DELETE 쿼리문 → TBL_입고
    DELETE
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    -- ② UPDATE 쿼리문 → TBL_상품
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    -- ⑨ 예외 처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '재고 부족');
        WHEN OTHERS
            THEN ROLLBACK;
    
    -- ⑧ 커밋
    COMMIT;
    
END;
-- Procedure PRC_입고_DELETE이(가) 컴파일되었습니다.


-- 3. PRC_출고_DELETE(출고번호) ------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_출고_DELETE
( V_출고번호   IN TBL_출고.출고번호%TYPE
)
IS
    -- ③ 쿼리문 작성 시 필요한 변수 선언
    V_상품코드  TBL_출고.상품코드%TYPE;
    V_출고수량  TBL_출고.출고수량%TYPE;
BEGIN
    -- ④ 변수에 값 담아내기 (V_상품코드, V_출고수량)
    SELECT 상품코드, 출고수량 INTO V_상품코드, V_출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    -- ① DELETE 쿼리문 → TBL_출고
    DELETE
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    -- ② UPDATE 쿼리문 → TBL_상품
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    -- ⑤ 예외 처리
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;
        
    -- ⑥ 커밋
    COMMIT;
    
END;
-- Procedure PRC_출고_DELETE이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------

