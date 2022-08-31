SELECT USER
FROM DUAL;
-- SCOTT


SET SERVEROUTPUT ON;


-- ▼ 변수에 임의의 값을 대입하고 출력하는 구문 작성
DECLARE
    GRADE CHAR;
BEGIN
    GRADE := 'A';
    
    IF GRADE = 'A'
        THEN DBMS_OUTPUT.PUT_LINE('EXCELLENT');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL');
    END IF;
END;

DECLARE
    GRADE CHAR;
BEGIN
    GRADE := 'B';
    
    IF GRADE = 'A'
        THEN DBMS_OUTPUT.PUT_LINE('EXCELLENT');
    ELSIF GRADE = 'B'
        THEN DBMS_OUTPUT.PUT_LINE('GOOD');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL');
    END IF;
END;


-- ▼ CASE 문(조건문)
--    CASE ~ WHEN ~ THEN ~ ELSE ~ END CASE;

-- 1. 형식 및 구조
/*
      CASE 변수
        WHEN 값1 THEN 실행문1;
        WHEN 값2 THEN 실행문2;
        ELSE 실행문N+1;
      END CASE;
*/

-- 남자1 여자2 입력하세요
-- 1
-- 남자입니다.

-- 남자1 여자2 입력하세요
-- 2
-- 여자입니다.

ACCEPT NUM PROMPT '남자1 여자2 입력하세요';

DECLARE
    -- 선언부 ▷ 주요 변수 선언
    SEL     NUMBER := &NUM;
    RESULT  VARCHAR2(10) := '남자';
BEGIN
    -- 테스트
    -- DBMS_OUTPUT.PUT_LINE('SEL : ' || SEL);
    -- DBMS_OUTPUT.PUT_LINE('RESULT : ' || RESULT);
    
    /*
    CASE SEL
        WHEN 1
        THEN DBMS_OUTPUT.PUT_LINE('남자입니다.');
        WHEN 2
        THEN DBMS_OUTPUT.PUT_LINE('여자입니다.');
        ELSE
             DBMS_OUTPUT.PUT_LINE('확인불가');
    END CASE;
    */
    
    CASE SEL
        WHEN 1
        THEN RESULT := '남자';
        WHEN 2
        THEN RESULT := '여자';
        ELSE
             RESULT := '확인불가';
    END CASE;
    
    DBMS_OUTPUT.PUT_LINE('처리 결과는 ' || RESULT || '입니다.');
    
END;


-- ▶ 외부 입력 처리
--    ACCEPT 구문
--    ACCEPT 변수명 PROMPT '메세지';
--    외부 변수로부터 입력받은 데이터를 내부 변수에 전달할 때
--    『&외부변수명』 형태로 접근하게 된다.


-- ▼ 정수 두 개를 외부로부터(사용자로부터) 입력받아
--    이들의 덧셈 결과를 출력하는 PL/SQL 구문을 작성한다.

ACCEPT NUM1 PROMPT '첫 번째 정수를 입력하세요.';
ACCEPT NUM2 PROMPT '두 번째 정수를 입력하세요.';

DECLARE
    NUM1    NUMBER := &NUM1;
    NUM2    NUMBER := &NUM2;
    RESULT  NUMBER := 0;
BEGIN
    -- 테스트
    --DBMS_OUTPUT.PUT_LINE('NUM1 : ' || NUM1);
    --DBMS_OUTPUT.PUT_LINE('NUM2 : ' || NUM2);
    
    RESULT := NUM1 + NUM2;
    
    DBMS_OUTPUT.PUT_LINE('덧셈 결과는 ' || RESULT || '입니다.');
END;
-- 덧셈 결과는 70입니다.


-- ▼ 사용자로부터 입력받은 금액을 화폐 단위로 구분하여 출력하는 프로그램을 작성한다.
--    단, 반환 금액은 변의상 1천원 미만, 10원 이상만 가능하다고 가정한다.
/*
      실행 예)
      바인딩 변수 입력 대화창 → 금액 입력 : 990
      
      입력받은 금액 총액 : 990원
      화폐단위 : 오백원 1, 백원 4, 오십원 1, 십원 4
*/

/* 내 풀이 ---------------------------------------------------------------------
ACCEPT MONEY PROMPT '금액을 입력해주세요.';

DECLARE
    MONEY   NUMBER(3) := &MONEY;
    OBEK   NUMBER := 0;
    BEK     NUMBER := 0;
    OSIB    NUMBER := 0;
    SIB     NUMBER := 0;
BEGIN
    -- 테스트
    -- DBMS_OUTPUT.PUT_LINE('입력값 : ' || MONEY);
    
    OBEK := TRUNC(MONEY/500);
    BEK := MOD(MONEY, 500)/100;
    OSIB := MOD(MONEY-(500*OBEK), 100)/50;
    SIB := MOD(MONEY-(500*OBEK)-(100*BEK), 50)/10;
    
    DBMS_OUTPUT.PUT_LINE('화폐단위 :');
    DBMS_OUTPUT.PUT_LINE('오백원 ' || OBEK);
    DBMS_OUTPUT.PUT_LINE('백원   ' || BEK);
    DBMS_OUTPUT.PUT_LINE('오십원 ' || OSIB);
    DBMS_OUTPUT.PUT_LINE('십원   ' || SIB);
END;
*/

-- 선생님 풀이 -----------------------------------------------------------------

ACCEPT INPUT PROMPT '금액 입력';

DECLARE
    -- 주요 변수 선언
    MONEY   NUMBER := &INPUT;       -- 연산을 위해 입력값을 담아둘 변수
    MONEY2  NUMBER := &INPUT;       -- 결과 출력을 위해 입력값을 담아둘 변수
    
    M500    NUMBER;                 -- 500원짜리 갯수를 담아둘 변수
    M100    NUMBER;                 -- 100원자리 갯수를 담아둘 변수
    M50     NUMBER;                 -- 50원자리 갯수를 담아둘 변수
    M10     NUMBER;                 -- 10원자리 갯수를 담아둘 변수
BEGIN
    -- 연산 및 처리
    -- MONEY를 500원으로 나눠서 몫을 취하고 나머지는 버린다. → 500원의 갯수
    M500 := TRUNC(MONEY / 500);
    
    -- MONEY를 500원으로 나눠서 몫은 버리고 나머지를 취한다. → 500원의 갯수 확인하고 남은 금액
    -- 이 결과를 다시 MONEY에 담아낸다.
    MONEY := MOD(MONEY, 500);
    
    -- MONEY를 100원으로 나눠서 몫을 취하고 나머지는 버린다. → 100원의 갯수
    M100 := TRUNC(MONEY / 100);
    
    -- MONEY를 100원으로 나눠서 몫은 버리고 나머지를 취한다. → 100원의 갯수 확인하고 남은 금액
    -- 이 결과를 다시 MONEY에 담아낸다.
    MONEY := MOD(MONEY, 100);
    
    -- MONEY를 50원으로 나눠서 몫을 취하고 나머지는 버린다. → 50원의 갯수
    M50 := TRUNC(MONEY / 50);
    
    -- MONEY를 50원으로 나눠서 몫은 버리고 나머지를 취한다. → 50원의 갯수 확인하고 남은 금액
    -- 이 결과를 다시 MONEY에 담아낸다.
    MONEY := MOD(MONEY, 50);
    
    -- MONEY를 50원으로 나눠서 몫을 취하고 나머지는 버린다. → 10원의 갯수
    MONEY := TRUNC(MONEY / 10);
    
    -- 결과 출력
    -- 취합된 결과(화폐 단위별 갯수)를 형식에 맞게 최종 출력한다.
    DBMS_OUTPUT.PUT_LINE('입력받은 금액 총액 : ' || MONEY2 || '원');
    DBMS_OUTPUT.PUT_LINE('화폐단위 : 오백원 ' || M500 || 
                         ', 백원 ' || M100 || 
                         ', 오십원 ' || M50 || 
                         ', 십원' || M10);
END;


-- ▼ 기본 반복문
--    LOOP ~ END LOOP;

-- 1. 조건과 상관 없이 무조건 반복하는 구문.

-- 2. 형식 및 구조
/*
      LOOP
          -- 실행문
          EXIT WHEN 조건;         → 조건이 참인 경우 반복문을 빠져나간다.
      END LOOP;
*/


-- ▼ 1부터 10까지의 수 출력(LOOP 문 활용)
DECLARE
    NUM NUMBER;
BEGIN
    NUM := 1;
    
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        EXIT WHEN NUM >= 10;
        
        NUM := NUM + 1;
    END LOOP;
END;


-- ▼ WHILE 반복문
--    WHILE LOOP ~ END LOOP;

-- 1. 제어 조건이 TRUE인 동안 일련의 문장을 반복하기 위해
--    WHILE LOOP 구문을 사용한다.
--    조건은 반복이 시작되는 시점에 체크하게 되어
--    LOOP 내의 문장이 한 번도 수행되지 않을 경우도 있다.
--    LOOP를 시작할 때 조건이 FALSE이면 반복 문장을 탈출하게 된다.

-- 2. 형식 및 구조
/*
      WHILE 조건 LOOP         → 조건이 참인 경우 반복 수행
      END LOOP;
*/

-- ▼ 1부터 10까지의 수 출력(WHILE LOOP 문 활용)
DECLARE
    N   NUMBER;
BEGIN
    N := 1;
    
    WHILE N<=10 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;


-- ▼ FOR 반복문
--    FOR LOOP ~ END LOOP;

-- 1. 『시작수』에서 1씩 증가하여
--    『끝냄수』가 될 때까지 반복 수행한다.

-- 2. 형식 및 구조
/*
      FOR 카운터 IN 시작수 .. 끝냄수 LOOP
          -- 실행문;
      END LOOP;
*/

-- ▼ 1부터 10까지의 수 출력(FOR LOOP 문 활용)
DECLARE
    N   NUMBER;
BEGIN
    FOR N IN 1 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;


-- ▼ 사용자로부터 임이의 단(구구단)을 입력받아
--    해당 단수의 구구단을 출력하는 PL/SQL 구문을 작성한다.
/*
      실행 예)
      바인딩 변수 입력 대화창 → 단을 입력하세요 : 2
      
      2 * 1 = 2
      2 * 2 = 4
        :
      2 * 9 = 18
*/

-- ① LOOP 문
ACCEPT INPUT PROMPT '단을 입력하세요.';

DECLARE
    DAN NUMBER := &INPUT;        -- 단
    N   NUMBER;                 -- 곱할 수
BEGIN
    N := 1;
    
    LOOP
        DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
        EXIT WHEN N>=9;
        
        N := N + 1;
    END LOOP;
END;

-- ② WHILE LOOP 문
ACCEPT INPUT PROMPT '단을 입력하세요.';

DECLARE
    DAN NUMBER := &INPUT;
    N   NUMBER;
BEGIN
    N := 0;
    WHILE N<9 LOOP
        N := N+1;
        DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
    END LOOP;
END;

-- ③ FOR LOOP 문
ACCEPT INPUT PROMPT '단을 입력하세요.';

DECLARE
    DAN NUMBER := &INPUT;
    N   NUMBER;
BEGIN
    FOR N IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
    END LOOP;
END;


-- ▼ 구구단 전체(2단~9단)를 출력하는 PL/SQL 구문을 작성한다.
--    단, 이중 반복문(반복문의 중첩) 구문을 활용한다.
/*
      실행 예)
      ===[2단]===
      2 * 1 = 2
      2 * 2 = 4
          :
      ===[9단]===
      9 * 9 = 81
*/

DECLARE
    DAN NUMBER;
    N   NUMBER;
BEGIN
    -- ① LOOP 문
    /*
    DAN := 2;
    LOOP
        DBMS_OUTPUT.PUT_LINE('===[' || DAN || '단]===');
        
        N := 1;
        LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
            EXIT WHEN N >= 9;
            N := N +1;
        END LOOP;
        
        EXIT WHEN DAN >= 9;
        DAN := DAN + 1;
        
        DBMS_OUTPUT.PUT_LINE(' ');
        
    END LOOP;
    */
    
    -- ② WHILE LOOP 문
    /*
    DAN := 0;
    WHILE DAN<9 LOOP
        DAN := DAN + 1;
        DBMS_OUTPUT.PUT_LINE('===[' || DAN || '단]===');
        
        N := 1;
        WHILE N<=9 LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
            N := N + 1;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
    */
    
    -- ③ FOR LOOP 문
    FOR DAN IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE('===[' || DAN || '단]===');
        
        FOR N IN 1 .. 9 LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;


