SELECT USER
FROM DUAL;
-- SCOTT


-- ▼ TBL_입고 테이블에 『입고』이벤트 발생 시,
--    관련 테이블에 수행되어야 하는 내용

-- ① INSERT → TBL_입고
-- ② UPDATE → TBL_상품

-- ▼ TBL_상품, TBL_입고 테이블을 대상으로 
--    TBL_입고 테이블에 데이터 입력 시 (즉, 입고 이벤트 발생 시)
--    TBL_입고 테이블의 데이터 입력 뿐 아니라
--    TBL_상품 테이블의 재고수량이 함께 변동될 수 있는 기능을 가진 프로시저를 작성한다.
--    단, 이 과정에서 입고번호는 자동 증가 처리한다. (시퀀스 사용 X)
--    TBL_입고 테이블 구성 컬럼 (구조)
--    : 입고번호, 상품코드, 입고일자, 입고수량, 입고단가
--    프로시저 명 : PRC_입고_INSERT(상품코드, 입고수량, 입고단가)

CREATE OR REPLACE PROCEDURE PRC_입고_INSERT
( V_상품코드    IN TBL_입고.상품코드%TYPE
, V_입고수량    IN TBL_입고.입고수량%TYPE
, V_입고단가    IN TBL_입고.입고단가%TYPE
)
IS
    -- 아래의 쿼리문을 수행하기 위해 필요한 변수 추가 선언
    V_입고번호  TBL_입고.입고번호%TYPE;
BEGIN
    -- V_입고번호 연산 (변수에 값 담아내기)
    SELECT NVL(MAX(입고번호), 0) INTO V_입고번호
    FROM TBL_입고;
    
    -- INSERT 쿼리문 수행
    INSERT INTO TBL_입고(입고번호, 상품코드, 입고수량, 입고단가)
    VALUES((V_입고번호+1), V_상품코드, V_입고수량, V_입고단가);
    
    -- UPDATE 쿼리문 수행
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 예외처리 : 문제 발생 시 되돌린다.
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;
    
    COMMIT;
    
END;
-- Procedure PRC_입고_INSERT이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------


--■■■ 프로시저 내에서의 예외 처리 ■■■--

-- ▼ TBL_MEMBER 테이블에 데이터를 입력하는 프로시저를 작성
--    단, 이 프로시저를 통해 데이터를 입력할 경우
--    CITY(지역) 항목 '서울', '경기', '대전'만 입력이 가능하도록 구성한다.
--    이 지역 외의 다른 지역을 프로시저 호출을 통해 입력하고자 하는 경우
--    (즉, 입력을 시도하는 경우)
--    예외에 대한 처리를 하려고 한다.
--    프로시저 명 : PRC_MEMBER_INSERT()
/*
      실행 예)
      EXEC PRC_MEMBER_INSERT('임시연', '010-1111-1111', '서울');
      -- 데이터 입력 ○
      
      EXEC PRC_MEMBER_INSERT('김보경', '010-2222-2222', '부산');
      -- 데이터 입력 X
*/

CREATE OR REPLACE PROCEDURE PRC_MEMBER_INSERT
( V_NAME    IN TBL_MEMBER.NAME%TYPE
, V_TEL     IN TBL_MEMBER.TEL%TYPE
, V_CITY    IN TBL_MEMBER.CITY%TYPE
)
IS
    -- 실행 영역의 쿼리문 수행을 위해 필요한 변수 추가 선언
    V_NUM   TBL_MEMBER.NUM%TYPE;
    
    -- 사용자 정의 예외에 대한 변수 선언!★
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    -- 프로시저를 통해 입력 처리를 정상적으로 진행해야 할 데이터인지
    -- 아닌지의 여부를 가장 먼저 확인할 수 있도록 코드 구성
    IF (V_CITY NOT IN ('서울', '경기', '대전'))
        -- THEN 예외를 발생시키겠다.
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- INSET 쿼리문을 수행하기에 앞서 선언한 변수에 값 담아내기
    SELECT NVL(MAX(NUM), 0) INTO V_NUM
    FROM TBL_MEMBER;
    
    -- 쿼리문 구성 → INSERT
    INSERT INTO TBL_MEMBER(NUM, NAME, TEL, CITY)
    VALUES((V_NUM+1), V_NAME, V_TEL, V_CITY);
    
    -- 예외 처리
    EXCEPTION
    WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20001, '서울, 경기, 대전만 입력이 가능합니다.');     -- 오라클 자체 지정 오류가 20000번까지 있음!
    WHEN OTHERS
        THEN ROLLBACK;
END;
-- Procedure PRC_MEMBER_INSERT이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------


-- ▼ TBL_출고 테이블에 데이터 입력 시 (즉, 출고 이벤트 발생 시)
--    TBL_상품 테이블의 재고 수량이 변동되는 프로시저를 작성한다.
--    단, 출고번호는 입고번호와 마찬가지로 자동 증가 처리한다.
--    또한 출고 수량이 재고 수량보다 많은 경우,
--    출고 액션 처리 자체를 취소할 수 있도록 처리한다. (출고가 이루어지지 않도록)
--    프로시저 명 : PRC_출고_INSERT()
/*
      실행 예)
      EXEC PRC_출고_INSERT('H001', 50, 1000);
*/

CREATE OR REPLACE PROCEDURE PRC_출고_INSERT
( V_상품코드    IN TBL_출고.상품코드%TYPE
, V_출고수량    IN TBL_출고.출고수량%TYPE
, V_출고단가    IN TBL_출고.출고단가%TYPE
)
IS
    -- 쿼리문 수행을 위한 추가 변수 선언
    V_출고번호      TBL_출고.출고번호%TYPE;
    V_재고수량      TBL_상품.재고수량%TYPE;
    
    -- 사용자 정의 예외 선언
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    -- 검사를 위한 변수에 값 담아내기(V_재고수량)
    -- 재고파악을 위한 쿼리문
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    -- 출고 여부 결정 쿼리문 (재고수량보다 출고수량이 많으면 예외 발생)
    -- 『TBL_상품.재고수량』의 형식으로는 호출 불가 
    IF ( V_출고수량 > V_재고수량 )
        -- 예외 발생
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- 선언한 변수에 값 담아내기(V_출고번호)
    SELECT NVL(MAX(출고번호), 0) INTO V_출고번호
    FROM TBL_출고;
    
    -- 쿼리문 구성 → INSERT(TBL_출고)
    INSERT INTO TBL_출고(출고번호, 상품코드, 출고수량, 출고단가)
    VALUES((V_출고번호+1), V_상품코드, V_출고수량, V_출고단가);
    
    -- 쿼리문 구성 → UPDATE(TBL_상품)
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 예외 처리
    EXCEPTION
    WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20002, '재고 부족');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;
        
    COMMIT;
    
END;
-- Procedure PRC_출고_INSERT이(가) 컴파일되었습니다.

SELECT *
FROM TBL_출고;


--------------------------------------------------------------------------------


-- ▼ TBL_출고 테이블에서 출고 수량을 수정(변경)하는 프로시저를 작성한다.
--    프로시저 명 : PRC_출고_UPDATE()
/*
      실행 예)
      EXEC PRC_출고_UPDATE(출고번호, 변경할 수량);
*/

CREATE OR REPLACE PROCEDURE PRC_출고_UPDATE
( V_출고번호    IN TBL_출고.출고번호%TYPE
, V_변경수량    IN TBL_출고.출고수량%TYPE
)
IS
    -- 실행부 쿼리문을 처리하기 위한 변수 선언
    V_상품코드  TBL_상품.상품코드%TYPE;
    V_출고수량  TBL_출고.출고수량%TYPE;
    V_재고수량  TBL_상품.재고수량%TYPE;
    
    -- 사용자 정의 예외 선언
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    -- 선언한 변수에 값 담기 (V_상품코드)
    SELECT 상품코드 INTO V_상품코드
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    -- 선언한 변수에 값 담기 (V_출고수량)
    SELECT 출고수량 INTO V_출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    -- 선언한 변수에 값 담기 (V_재고수량)
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    -- 수정 여부 확인 (변경할 수량이 재고보다 많을 경우)
    IF ( V_변경수량 > V_재고수량 + V_출고수량 )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- UPDATE (TBL_출고)
    UPDATE TBL_출고
    SET 출고수량 = V_변경수량
    WHERE 출고번호 = V_출고번호;
    
    -- UPDATE (TBL_상품)
    UPDATE TBL_상품
    SET 재고수량 = V_재고수량 + V_출고수량 - V_변경수량
    WHERE 상품코드 = V_상품코드;
    
    -- 예외처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '재고부족');
        WHEN OTHERS
            THEN ROLLBACK;
    
    COMMIT;
END;
-- Procedure PRC_출고_UPDATE이(가) 컴파일되었습니다.

/* 선생님 풀이 -----------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_출고_UPDATE
(
  -- ① 매개변수 선언
  V_출고번호	IN TBL_출고.출고번호%TYPE
, V_출고수량	IN TBL_출고.출고수량%TYPE
)
IS
	-- ③ 필요한 변수 추가 선언
	V_상품코드		TBL_상품.상품코드%TYPE;
	V_이전출고수량		TBL_출고.출고수량%TYPE;
	V_재고수량		TBL_상품.재고수량%TYPE;

	-- ⑦ 예외변수 추가 선언
	USER_DEFINE_ERROR		EXCEPTION;
BEGIN
	-- 선언한 변수에 값 담아내기
	-- ④ 상품코드와 이전출고수량 파악
	SELECT 상품코드, 출고수량 INTO V_상품코드, V_이전출고수량
	FROM TBL_출고
	WHERE 출고번호 = V_출고번호;

	-- ⑤ 재고수량 파악
	SELET 재고수량 INTO V_재고수량
	FROM TBL_상품
	WHERE 상품코드 = V_상품코드;

	-- ⑥ 출고 정상 수행 여부 판단 필요
	--	  변경 이전의 출고수량 및 현재의 재고수량 확인
	IF (V_재고수량 + V_이전출고수량 < V_출고수량)
		THEN RAISE USER_DEFINE_ERROR;
	END IF;

	-- ② 수행될 쿼리문 체크 (UPDATE → TBL_출고)
	UPDATE TBL_출고
	SET 출고수량 = V_출고수량
	WHERE 출고번호 = V_출고번호;

	-- ⑧ UPDATE → TBL_상품
	UPDATE TBL_상품
	SET 재고수량 = 재고수량 + V_이전출고수량 - V_출고수량
	WHERE 상품코드 = V_상품코드;
	
	-- ⑩ 예외 처리
	EXCEPTION
		WHEN USER_DEFINE_ERROR
			THEN RAISE_APPLICATION_ERROR(-20002, '재고 부족');
		WHEN OTHERS
			THEN ROLLBACK;
	
	-- ⑨ 커밋
	COMMIT;
	
END;

*/


--------------------------------------------------------------------------------


--■■■ CURSOR(커서) ■■■--

-- 1. 오라클에서는 하나의 레코드가 아닌 여러 레코드로 구성된
--    작업 영역에서 SQL 문을 실행하고 그 과정에서 발생한 데이터를
--    저장하기 위해 커서(CURSOR)를 사용하며,
--    커서에는 암시적인 커서와 명시적인 커서가 있다.

-- 2. 암시적 커서는 모든 SQL 문에 존재하며
--    SQL 문 실행 후 오직 하나의 행(ROW)만 출력하게 된다.
--    그러나 SQL 문을 실행한 결과물(RESULT SET)이
--    여러 행(ROW)으로 구성된 경우
--    커서(CURSOR)를 명시적으로 선언해야 여러 행(ROW)을 다룰 수 있다.


-- ▼ 커서 이용 전 상황(단일 행 접근 시) ---------------------------------------
SET SERVEROUTPUT ON;

DECLARE
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
BEGIN
    SELECT NAME, TEL INTO V_NAME, V_TEL
    FROM TBL_INSA
    WHERE NUM = 1001;
    
    DBMS_OUTPUT.PUT_LINE(V_NAME || '--' || V_TEL);
END;
-- 홍길동--011-2356-4528


-- ▼ 커서 이용 전 상황(다중 행 접근 시 - 반복문 활용) -------------------------

/*
DECLARE
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
BEGIN
    SELECT NAME, TEL INTO V_NAME, V_TEL
    FROM TBL_INSA;
    
    DBMS_OUTPUT.PUT_LINE(V_NAME || '--' || V_TEL);
END;
-- 에러 발생 : ORA-01422: exact fetch returns more than requested number of rows
*/

DECLARE
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    V_NUM   TBL_INSA.NUM%TYPE := 1001;
BEGIN
    LOOP
        SELECT NAME, TEL INTO V_NAME, V_TEL
        FROM TBL_INSA
        WHERE NUM = V_NUM;
        
        DBMS_OUTPUT.PUT_LINE(V_NAME || '--' || V_TEL);
        V_NUM := V_NUM + 1;
        
        EXIT WHEN V_NUM >= 1062;
        
    END LOOP;
    
END;
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.


-- ▼ 커서 이용 전 상황(다중 행 접근 시 - 반복문 활용) -------------------------

DECLARE
    -- 선언부
    -- 주요 변수 선언
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    
    -- 커서 이용을 위한 커서변수 선언(▷ 커서 정의)
    CURSOR  CUR_INSA_SELECT
    IS
    SELECT NAME, TEL
    FROM TBL_INSA;
    
BEGIN
    -- 커서 오픈
    OPEN CUR_INSA_SELECT;
    
    -- 커서 오픈 시 쏟아져 나오는 데이터들 처리
    LOOP
        -- 모든 행을 받아 처리하는 행위 → 『FETCH』
        FETCH CUR_INSA_SELECT INTO V_NAME, V_TEL;
        
        -- 커서에서 더 이상 데이터가 쏟아져 나오지 않는 상태
        -- 즉, 커서 내부에서 더 이상 데이터를 찾을 수 없는 상태
        -- ▷ 반복문 빠져나가기
        EXIT WHEN CUR_INSA_SELECT%NOTFOUND;
        
        -- 출력
        DBMS_OUTPUT.PUT_LINE(V_NAME || '--' || V_TEL);
        
    END LOOP;
    
    -- 커서 클로즈
    CLOSE CUR_INSA_SELECT;
    
END;
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.










