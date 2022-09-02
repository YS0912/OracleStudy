SELECT USER
FROM DUAL;
-- SCOTT


-- 20220831_03_scott(plsql)���� �̾ -----------------------------------------

-- �� TBL_INSA ���̺��� �޿� ��� ���� �Լ��� �����Ѵ�.
--    �޿��� ��(�⺻��*12)+���硻 ������� ������ �����Ѵ�.
--    �Լ��� : FN_PAY(�⺻��, ����)

CREATE OR REPLACE FUNCTION FN_PAY( V_BASICPAY NUMBER, V_SUDANG NUMBER )
RETURN NUMBER
IS
    V_RESULT    NUMBER;
BEGIN
    V_RESULT := (NVL(V_BASICPAY, 0) * 12) + NVL(V_SUDANG, 0);                       -- ��CHECK�� NULL ���� ���꿡 ���ԵǸ� NULL�� �Ǵ� ����!
    
    RETURN V_RESULT;
    
END;
-- Function FN_PAY��(��) �����ϵǾ����ϴ�.

-- Ȯ��
SELECT NUM, NAME, BASICPAY, SUDANG
     , FN_PAY(BASICPAY, SUDANG) "�޿�"
FROM TBL_INSA;


-- �� TBL_INSA ���̺��� �Ի����� ��������
--    ������� �ٹ������ ��ȯ�ϴ� �Լ��� �����Ѵ�.
--    ��, �ٹ������ �Ҽ��� ���� ���ڸ����� ����Ѵ�.
--    �Լ��� : FN_WORKYEAR(�Ի���)

-- �� Ǯ�� ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION FN_WORKYEAR( V_IBSADATE DATE )
RETURN NUMBER
IS
    V_RESULT    NUMBER;
BEGIN
    V_RESULT := ROUND((SYSDATE - V_IBSADATE)/365, 1);
    
    RETURN V_RESULT;
    
END;
-- Function FN_WORKYEAR��(��) �����ϵǾ����ϴ�.

-- ������ Ǯ�� -----------------------------------------------------------------

-- ��
CREATE OR REPLACE FUNCTION FN_WORKYEAR( V_IBSADATE DATE )
RETURN VARCHAR2
IS
    V_RESULT    VARCHAR2(20);
BEGIN
    V_RESULT := TRUNC(MONTHS_BETWEEN(SYSDATE, V_IBSADATE)/12) || '��' ||
                TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, V_IBSADATE), 12)) || '����';
    
    RETURN V_RESULT;
END;
-- Function FN_WORKYEAR��(��) �����ϵǾ����ϴ�.

-- ��
CREATE OR REPLACE FUNCTION FN_WORKYEAR( V_IBSADATE DATE )
RETURN NUMBER
IS
    V_RESULT    NUMBER;
BEGIN
    V_RESULT := TRUNC(MONTHS_BETWEEN(SYSDATE, V_IBSADATE)/12, 1);
    
    RETURN V_RESULT;
END;

-- Ȯ��
SELECT NUM, NAME, IBSADATE, FN_WORKYEAR(IBSADATE) "�ٹ����"
FROM TBL_INSA;

--------------------------------------------------------------------------------


-- �� ����

-- 1. INSERT, UPDATE, DELETE, (MERGE)
--    �� DML(Data Manipulation Language)
--       COMMIT / ROLLBACK �� �ʿ�

-- 2. CREATE, DROP, ALTER, (TRUNCATE)
--    �� DDL(Data Definition Language)
--       �����ϸ� �ڵ����� COMMIT

-- 3. GRANT, REVOKE
--    �� DCL(Data Control Language)
--       �����ϸ� �ڵ����� COMMIT

-- 4. COMMIT, ROLLBACK
--    �� TCL(Transaction Control Language)


--------------------------------------------------------------------------------


--���� PROCEDURE(���ν���) ����--

-- 1. PL/SQL���� ���� ��ǥ���� ������ ������ ���ν�����
--    �����ڰ� ���� �强�ؾ� �ϴ� ������ �帧��
--    �̸� �ۼ��Ͽ� �����ͺ��̽� ���� ������ �ξ��ٰ�
--    �ʿ��� ������ ȣ���Ͽ� ������ �� �ֵ��� ó���� �ִ� �����̴�.

-- 2. ���� �� ����
/*
      CREATE [OR REPLACE] PROCEDURE ���ν�����
      [( �Ű����� IN ������Ÿ��
       , �Ű����� OUT ������Ÿ��
       , �Ű����� INOUT ������Ÿ��
      )]
      IS
          [-- �ֿ� ���� ����]
      BEGIN
          -- ���� ����;
          ...
          [EXCEPTION]
            -- ���� ó�� ����;
      END;
*/
-- �� FUNCTION�� ������ ��
--    ��RETURN ��ȯ�ڷ����� �κ��� �������� ������,
--    ��RETURN�� �� ��ü�� �������� ������,
--    ���ν��� ���� �� �Ѱ��ְ� �Ǵ� �Ű�������
--    IN, OUT, INOUT���� ���еȴ�.

-- 3. ����(ȣ��)
/*
      EXC[UTE] ���ν�����[(�μ�1, �μ�2, ...)];
*/


-- ���ν��� ���� �ǽ� ������ ���� 20220901_02_scott.sql ���Ͽ�
-- ���̺� ���� �� ������ �Է� ����

-- �� ���ν��� ����
--    ���ν��� ��: PRC_STUDENTS_INSERT(���̵�, �н�����, �̸�, ��ȭ, �ּ�)
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
-- Procedure PRC_STUDENTS_INSERT��(��) �����ϵǾ����ϴ�.


-- �� TBL_SUNGJUK ���̺��� ������ �Է� ��
--    Ư�� �׸�(�й�, �̸�, ��������, ��������, ��������)�� �����͸� �Է��ϸ� 
--    ����������  ����, ���, ��� �׸� ���� ó���� �Բ� �̷���� �� �ֵ��� �ϴ�
--    ���ν����� �ۼ�(����)�Ѵ�.
--    ���ν��� �� : PRC_SUNGJUK_INSERT()
/*
      ���� ��)
      EXEC PRC_SUNGJUK_INSERT(1, '���ҿ�', 90, 80, 70);
      
      �� ���ν��� ȣ��� ó���� ���
         �й�   �̸�    ��������    ��������    ��������    ����  ���  ���
          1    ���ҿ�      90          80          70        240   80     B
*/

CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_INSERT
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE 
, V_NAME    IN TBL_SUNGJUK.NAME%TYPE 
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE 
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE 
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE 
)
IS
    -- �����
    -- INSERT ������ ������ �ϱ� ���� �ʿ��� ����
    V_TOT       TBL_SUNGJUK.TOT%TYPE;
    V_AVG       TBL_SUNGJUK.AVG%TYPE;
    V_GRADE     TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    -- �����
    -- INSERT �������� �����ϱ� ����
    -- ����ο��� ������ �ֿ� �����鿡 ���� ��Ƴ��� �Ѵ�.
    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := V_TOT / 3;
    
    -- V_GRADE := ��Ȳ�� ���� �б� �ʿ�
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
    
    -- INSERT ������ ����
    INSERT INTO TBL_SUNGJUK(HAKBUN, NAME, KOR, ENG, MAT, TOT, AVG, GRADE)
    VALUES(V_HAKBUN, V_NAME, V_KOR, V_ENG, V_MAT, V_TOT, V_AVG, V_GRADE);
    
    COMMIT;
    
END;
-- Procedure PRC_SUNGJUK_INSERT��(��) �����ϵǾ����ϴ�.


-- �� TBL_SUNGJUK ���̺��� ������ ���� ��
--    Ư�� �׸�(�й�, �̸�, ��������, ��������, ��������)�� �����͸� �Է��ϸ� 
--    ����������  ����, ���, ��� �׸� ���� ó���� �Բ� �̷���� �� �ֵ��� �ϴ�
--    ���ν����� �ۼ�(����)�Ѵ�.
--    ���ν��� �� : PRC_SUNGJUK_UPDATE()
/*
      ���� ��)
      EXEC PRC_SUNGJUK_UPDATE(1, 50, 50, 50);

      �� ���ν��� ȣ��� ó���� ���
         �й�   �̸�    ��������    ��������    ��������    ����  ���  ���
          1    ���ҿ�      50          50          50        150   50     F
*/

--CREATE OR REPLACE PRC_SUNGJUK_UPDATE

CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_UPDATE
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
    -- �����
    -- UPDATE ������ ������ ���� �ʿ��� �ֿ� ���� ����
    V_TOT       TBL_SUNGJUK.TOT%TYPE;
    V_AVG       TBL_SUNGJUK.AVG%TYPE;
    V_GRADE     TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    -- �����
    -- UPDATE ������ ���࿡ �ռ� �߰��� ������ �ֿ� �����鿡 �� ��Ƴ���
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
-- Procedure PRC_SUNGJUK_UPDATE��(��) �����ϵǾ����ϴ�.


-- �� TBL_STUDENTS ���̺��� ��ȭ��ȣ�� �ּ� �����͸� �����ϴ�(�����ϴ�)
--    ���ν����� �ۼ��Ѵ�.
--    ��, ID�� PW�� ��ġ�ϴ� ��쿡�� ������ ������ �� �ֵ��� ó���Ѵ�.
--    ���ν��� �� : PRC_STUDENTS_UPDATE()
/*
      ���� ��)
      EXEC PRC_STUDENTS_UPDATE('superman', 'java002', '010-9876-5432', '������ Ⱦ��');
      �� �н����� ����ġ : ������ ���� X
      
      EXEC PRC_STUDENTS_UPDATE('superman', 'java002$', '010-9876-5432', '������ Ⱦ��');
      �� �н����� ��ġ : ������ ���� ��
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
    -- V_TEMP := (SELECT PW                                                         �� �� ����� ������ Ǯ�� �� Ȯ��!
    --            FROM TBL_IDPW
    --            WHERE ID = V_ID);
    
    -- UPDATE TBL_STUDENTS S JOIN TBL_IDPW I ON S.ID = I.ID                         �� ��ȣ�� ������ ��!!
    UPDATE TBL_STUDENTS
    SET TEL = V_TEL
      , ADDR = V_ADDR
    WHERE ID = V_ID
      AND V_PW = (SELECT PW
                  FROM TBL_IDPW
                  WHERE ID = V_ID);
                  
-- ������ Ǯ�� -----------------------------------------------------------------
/* ��
BEGIN
    UPDATE (SELECT T1.ID, T1.PW, T2.TEL, T2.ADDR
            FROM TBL_IDPW T1 JOIN TBL_STUDENTS T2
            ON T1.ID = T2.ID) T
    SET T.TEL = V_TEL, T.ADDR = V_ADDR
    WHERE T.ID = V_ID
      AND T.PW = V_PW;
*/
    
/* ��
IS
    -- �ʿ��� ���� ����
    V_PW2   TBL_IDPW.PW%TYPE;
    V_FLAG  NUMBER := 0;
BEGIN
    -- �н����尡 �´��� Ȯ��
    -- (����ڰ� �Է��� V_PW�� ���� �н������ �������� Ȯ��)
    SELECT PW INTO V_PW2
    FROM TBL_IDPW
    WHERE ID = V_ID;
    
    -- �н����� ��ġ ���ο� ���� �б�
    IF (V_PW = V_PW2)
        THEN V_FLAG := 1;
    ELSE
        V_FLAG := 2;
    END IF;
    
    -- UPDATE ������ ���� �� TBL_STUDENTS (�б� ��� �ݿ�)
    UPDATE TBL_STUDENTS
    SET TEL = V_TEL, ADDR = V_ADDR
    WHERE ID = V_ID
      AND V_FLAG = 1;
*/
    
    COMMIT;
    
END;
-- Procedure PRC_STUDENTS_UPDATE��(��) �����ϵǾ����ϴ�.


-- �� TBL_INSA ���̺��� ������� �ű� ������ �Է� ���ν����� �ۼ��Ѵ�.
--    NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG 
--    ���� ������ �÷� ��
--    NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG
--    �� ������ �Է� ��
--    NUM �÷�(�����ȣ)�� ����
--    ���� �ο��� ��� ��ȣ�� ������ ��ȣ �� ���� ��ȣ�� �ڵ����� �Է� ó���� �� �ִ�
--    ���ν����� �����Ѵ�.
--    ���ν��� �� : PRC_INSA_INSERT()
/*
      ���� ��)
      EXEC PRC_INSA_INSERT('������', '970124-2234567', SYSDATE, '����', '010-7202-6306'
                         , '���ߺ�', '�븮', 2000000, 2000000);
                         
      �� ���ν��� ȣ��� ó���� ���
         1061 ������ 970124-2234567 2022-09-01 ���� 010-7202-6306 ���ߺ� �븮 2000000 2000000
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
    -- NUM ���
    SELECT NVL(MAX(NUM), 0) + 1 INTO V_NUM      -- �� : COUNT(*) ���
    FROM TBL_INSA;
    
    INSERT INTO TBL_INSA(NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG)
    VALUES(V_NUM, V_NAME, V_SSN, V_IBSADATE, V_CITY, V_TEL, V_BUSEO, V_JIKWI, V_BASICPAY, V_SUDANG);
    
    COMMIT;
    
END;
-- Procedure PRC_INSA_INSERT��(��) �����ϵǾ����ϴ�.

SELECT *
FROM TBL_INSA;

-- ���� ����
SELECT ����ȣ
FROM TBL_���;
-- ��ȸ ��� ����
-- �� ���� NVL(����ȣ, 0) ó�� �� MAX() ó���� �ص� ���ϴ� ���� ������ �ʴ´�.
--    NVL(MAX(����ȣ), 0)�� ó������!






















