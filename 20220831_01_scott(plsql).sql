SELECT USER
FROM DUAL;
-- SCOTT


SET SERVEROUTPUT ON;


-- �� ������ ������ ���� �����ϰ� ����ϴ� ���� �ۼ�
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


-- �� CASE ��(���ǹ�)
--    CASE ~ WHEN ~ THEN ~ ELSE ~ END CASE;

-- 1. ���� �� ����
/*
      CASE ����
        WHEN ��1 THEN ���๮1;
        WHEN ��2 THEN ���๮2;
        ELSE ���๮N+1;
      END CASE;
*/

-- ����1 ����2 �Է��ϼ���
-- 1
-- �����Դϴ�.

-- ����1 ����2 �Է��ϼ���
-- 2
-- �����Դϴ�.

ACCEPT NUM PROMPT '����1 ����2 �Է��ϼ���';

DECLARE
    -- ����� �� �ֿ� ���� ����
    SEL     NUMBER := &NUM;
    RESULT  VARCHAR2(10) := '����';
BEGIN
    -- �׽�Ʈ
    -- DBMS_OUTPUT.PUT_LINE('SEL : ' || SEL);
    -- DBMS_OUTPUT.PUT_LINE('RESULT : ' || RESULT);
    
    /*
    CASE SEL
        WHEN 1
        THEN DBMS_OUTPUT.PUT_LINE('�����Դϴ�.');
        WHEN 2
        THEN DBMS_OUTPUT.PUT_LINE('�����Դϴ�.');
        ELSE
             DBMS_OUTPUT.PUT_LINE('Ȯ�κҰ�');
    END CASE;
    */
    
    CASE SEL
        WHEN 1
        THEN RESULT := '����';
        WHEN 2
        THEN RESULT := '����';
        ELSE
             RESULT := 'Ȯ�κҰ�';
    END CASE;
    
    DBMS_OUTPUT.PUT_LINE('ó�� ����� ' || RESULT || '�Դϴ�.');
    
END;


-- �� �ܺ� �Է� ó��
--    ACCEPT ����
--    ACCEPT ������ PROMPT '�޼���';
--    �ܺ� �����κ��� �Է¹��� �����͸� ���� ������ ������ ��
--    ��&�ܺκ����� ���·� �����ϰ� �ȴ�.


-- �� ���� �� ���� �ܺηκ���(����ڷκ���) �Է¹޾�
--    �̵��� ���� ����� ����ϴ� PL/SQL ������ �ۼ��Ѵ�.

ACCEPT NUM1 PROMPT 'ù ��° ������ �Է��ϼ���.';
ACCEPT NUM2 PROMPT '�� ��° ������ �Է��ϼ���.';

DECLARE
    NUM1    NUMBER := &NUM1;
    NUM2    NUMBER := &NUM2;
    RESULT  NUMBER := 0;
BEGIN
    -- �׽�Ʈ
    --DBMS_OUTPUT.PUT_LINE('NUM1 : ' || NUM1);
    --DBMS_OUTPUT.PUT_LINE('NUM2 : ' || NUM2);
    
    RESULT := NUM1 + NUM2;
    
    DBMS_OUTPUT.PUT_LINE('���� ����� ' || RESULT || '�Դϴ�.');
END;
-- ���� ����� 70�Դϴ�.


-- �� ����ڷκ��� �Է¹��� �ݾ��� ȭ�� ������ �����Ͽ� ����ϴ� ���α׷��� �ۼ��Ѵ�.
--    ��, ��ȯ �ݾ��� ���ǻ� 1õ�� �̸�, 10�� �̻� �����ϴٰ� �����Ѵ�.
/*
      ���� ��)
      ���ε� ���� �Է� ��ȭâ �� �ݾ� �Է� : 990
      
      �Է¹��� �ݾ� �Ѿ� : 990��
      ȭ����� : ����� 1, ��� 4, ���ʿ� 1, �ʿ� 4
*/

/* �� Ǯ�� ---------------------------------------------------------------------
ACCEPT MONEY PROMPT '�ݾ��� �Է����ּ���.';

DECLARE
    MONEY   NUMBER(3) := &MONEY;
    OBEK   NUMBER := 0;
    BEK     NUMBER := 0;
    OSIB    NUMBER := 0;
    SIB     NUMBER := 0;
BEGIN
    -- �׽�Ʈ
    -- DBMS_OUTPUT.PUT_LINE('�Է°� : ' || MONEY);
    
    OBEK := TRUNC(MONEY/500);
    BEK := MOD(MONEY, 500)/100;
    OSIB := MOD(MONEY-(500*OBEK), 100)/50;
    SIB := MOD(MONEY-(500*OBEK)-(100*BEK), 50)/10;
    
    DBMS_OUTPUT.PUT_LINE('ȭ����� :');
    DBMS_OUTPUT.PUT_LINE('����� ' || OBEK);
    DBMS_OUTPUT.PUT_LINE('���   ' || BEK);
    DBMS_OUTPUT.PUT_LINE('���ʿ� ' || OSIB);
    DBMS_OUTPUT.PUT_LINE('�ʿ�   ' || SIB);
END;
*/

-- ������ Ǯ�� -----------------------------------------------------------------

ACCEPT INPUT PROMPT '�ݾ� �Է�';

DECLARE
    -- �ֿ� ���� ����
    MONEY   NUMBER := &INPUT;       -- ������ ���� �Է°��� ��Ƶ� ����
    MONEY2  NUMBER := &INPUT;       -- ��� ����� ���� �Է°��� ��Ƶ� ����
    
    M500    NUMBER;                 -- 500��¥�� ������ ��Ƶ� ����
    M100    NUMBER;                 -- 100���ڸ� ������ ��Ƶ� ����
    M50     NUMBER;                 -- 50���ڸ� ������ ��Ƶ� ����
    M10     NUMBER;                 -- 10���ڸ� ������ ��Ƶ� ����
BEGIN
    -- ���� �� ó��
    -- MONEY�� 500������ ������ ���� ���ϰ� �������� ������. �� 500���� ����
    M500 := TRUNC(MONEY / 500);
    
    -- MONEY�� 500������ ������ ���� ������ �������� ���Ѵ�. �� 500���� ���� Ȯ���ϰ� ���� �ݾ�
    -- �� ����� �ٽ� MONEY�� ��Ƴ���.
    MONEY := MOD(MONEY, 500);
    
    -- MONEY�� 100������ ������ ���� ���ϰ� �������� ������. �� 100���� ����
    M100 := TRUNC(MONEY / 100);
    
    -- MONEY�� 100������ ������ ���� ������ �������� ���Ѵ�. �� 100���� ���� Ȯ���ϰ� ���� �ݾ�
    -- �� ����� �ٽ� MONEY�� ��Ƴ���.
    MONEY := MOD(MONEY, 100);
    
    -- MONEY�� 50������ ������ ���� ���ϰ� �������� ������. �� 50���� ����
    M50 := TRUNC(MONEY / 50);
    
    -- MONEY�� 50������ ������ ���� ������ �������� ���Ѵ�. �� 50���� ���� Ȯ���ϰ� ���� �ݾ�
    -- �� ����� �ٽ� MONEY�� ��Ƴ���.
    MONEY := MOD(MONEY, 50);
    
    -- MONEY�� 50������ ������ ���� ���ϰ� �������� ������. �� 10���� ����
    MONEY := TRUNC(MONEY / 10);
    
    -- ��� ���
    -- ���յ� ���(ȭ�� ������ ����)�� ���Ŀ� �°� ���� ����Ѵ�.
    DBMS_OUTPUT.PUT_LINE('�Է¹��� �ݾ� �Ѿ� : ' || MONEY2 || '��');
    DBMS_OUTPUT.PUT_LINE('ȭ����� : ����� ' || M500 || 
                         ', ��� ' || M100 || 
                         ', ���ʿ� ' || M50 || 
                         ', �ʿ�' || M10);
END;


-- �� �⺻ �ݺ���
--    LOOP ~ END LOOP;

-- 1. ���ǰ� ��� ���� ������ �ݺ��ϴ� ����.

-- 2. ���� �� ����
/*
      LOOP
          -- ���๮
          EXIT WHEN ����;         �� ������ ���� ��� �ݺ����� ����������.
      END LOOP;
*/


-- �� 1���� 10������ �� ���(LOOP �� Ȱ��)
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


-- �� WHILE �ݺ���
--    WHILE LOOP ~ END LOOP;

-- 1. ���� ������ TRUE�� ���� �Ϸ��� ������ �ݺ��ϱ� ����
--    WHILE LOOP ������ ����Ѵ�.
--    ������ �ݺ��� ���۵Ǵ� ������ üũ�ϰ� �Ǿ�
--    LOOP ���� ������ �� ���� ������� ���� ��쵵 �ִ�.
--    LOOP�� ������ �� ������ FALSE�̸� �ݺ� ������ Ż���ϰ� �ȴ�.

-- 2. ���� �� ����
/*
      WHILE ���� LOOP         �� ������ ���� ��� �ݺ� ����
      END LOOP;
*/

-- �� 1���� 10������ �� ���(WHILE LOOP �� Ȱ��)
DECLARE
    N   NUMBER;
BEGIN
    N := 1;
    
    WHILE N<=10 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;


-- �� FOR �ݺ���
--    FOR LOOP ~ END LOOP;

-- 1. �����ۼ������� 1�� �����Ͽ�
--    ������������ �� ������ �ݺ� �����Ѵ�.

-- 2. ���� �� ����
/*
      FOR ī���� IN ���ۼ� .. ������ LOOP
          -- ���๮;
      END LOOP;
*/

-- �� 1���� 10������ �� ���(FOR LOOP �� Ȱ��)
DECLARE
    N   NUMBER;
BEGIN
    FOR N IN 1 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;


-- �� ����ڷκ��� ������ ��(������)�� �Է¹޾�
--    �ش� �ܼ��� �������� ����ϴ� PL/SQL ������ �ۼ��Ѵ�.
/*
      ���� ��)
      ���ε� ���� �Է� ��ȭâ �� ���� �Է��ϼ��� : 2
      
      2 * 1 = 2
      2 * 2 = 4
        :
      2 * 9 = 18
*/

-- �� LOOP ��
ACCEPT INPUT PROMPT '���� �Է��ϼ���.';

DECLARE
    DAN NUMBER := &INPUT;        -- ��
    N   NUMBER;                 -- ���� ��
BEGIN
    N := 1;
    
    LOOP
        DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
        EXIT WHEN N>=9;
        
        N := N + 1;
    END LOOP;
END;

-- �� WHILE LOOP ��
ACCEPT INPUT PROMPT '���� �Է��ϼ���.';

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

-- �� FOR LOOP ��
ACCEPT INPUT PROMPT '���� �Է��ϼ���.';

DECLARE
    DAN NUMBER := &INPUT;
    N   NUMBER;
BEGIN
    FOR N IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
    END LOOP;
END;


-- �� ������ ��ü(2��~9��)�� ����ϴ� PL/SQL ������ �ۼ��Ѵ�.
--    ��, ���� �ݺ���(�ݺ����� ��ø) ������ Ȱ���Ѵ�.
/*
      ���� ��)
      ===[2��]===
      2 * 1 = 2
      2 * 2 = 4
          :
      ===[9��]===
      9 * 9 = 81
*/

DECLARE
    DAN NUMBER;
    N   NUMBER;
BEGIN
    -- �� LOOP ��
    /*
    DAN := 2;
    LOOP
        DBMS_OUTPUT.PUT_LINE('===[' || DAN || '��]===');
        
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
    
    -- �� WHILE LOOP ��
    /*
    DAN := 0;
    WHILE DAN<9 LOOP
        DAN := DAN + 1;
        DBMS_OUTPUT.PUT_LINE('===[' || DAN || '��]===');
        
        N := 1;
        WHILE N<=9 LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
            N := N + 1;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
    */
    
    -- �� FOR LOOP ��
    FOR DAN IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE('===[' || DAN || '��]===');
        
        FOR N IN 1 .. 9 LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;


