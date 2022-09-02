SELECT USER
FROM DUAL;
-- SCOTT


-- �� TBL_�԰� ���̺� ���԰��̺�Ʈ �߻� ��,
--    ���� ���̺� ����Ǿ�� �ϴ� ����

-- �� INSERT �� TBL_�԰�
-- �� UPDATE �� TBL_��ǰ

-- �� TBL_��ǰ, TBL_�԰� ���̺��� ������� 
--    TBL_�԰� ���̺� ������ �Է� �� (��, �԰� �̺�Ʈ �߻� ��)
--    TBL_�԰� ���̺��� ������ �Է� �� �ƴ϶�
--    TBL_��ǰ ���̺��� �������� �Բ� ������ �� �ִ� ����� ���� ���ν����� �ۼ��Ѵ�.
--    ��, �� �������� �԰��ȣ�� �ڵ� ���� ó���Ѵ�. (������ ��� X)
--    TBL_�԰� ���̺� ���� �÷� (����)
--    : �԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�
--    ���ν��� �� : PRC_�԰�_INSERT(��ǰ�ڵ�, �԰����, �԰�ܰ�)

CREATE OR REPLACE PROCEDURE PRC_�԰�_INSERT
( V_��ǰ�ڵ�    IN TBL_�԰�.��ǰ�ڵ�%TYPE
, V_�԰����    IN TBL_�԰�.�԰����%TYPE
, V_�԰�ܰ�    IN TBL_�԰�.�԰�ܰ�%TYPE
)
IS
    -- �Ʒ��� �������� �����ϱ� ���� �ʿ��� ���� �߰� ����
    V_�԰��ȣ  TBL_�԰�.�԰��ȣ%TYPE;
BEGIN
    -- V_�԰��ȣ ���� (������ �� ��Ƴ���)
    SELECT NVL(MAX(�԰��ȣ), 0) INTO V_�԰��ȣ
    FROM TBL_�԰�;
    
    -- INSERT ������ ����
    INSERT INTO TBL_�԰�(�԰��ȣ, ��ǰ�ڵ�, �԰����, �԰�ܰ�)
    VALUES((V_�԰��ȣ+1), V_��ǰ�ڵ�, V_�԰����, V_�԰�ܰ�);
    
    -- UPDATE ������ ����
    UPDATE TBL_��ǰ
    SET ������ = ������ + V_�԰����
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    -- ����ó�� : ���� �߻� �� �ǵ�����.
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;
    
    COMMIT;
    
END;
-- Procedure PRC_�԰�_INSERT��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------


--���� ���ν��� �������� ���� ó�� ����--

-- �� TBL_MEMBER ���̺� �����͸� �Է��ϴ� ���ν����� �ۼ�
--    ��, �� ���ν����� ���� �����͸� �Է��� ���
--    CITY(����) �׸� '����', '���', '����'�� �Է��� �����ϵ��� �����Ѵ�.
--    �� ���� ���� �ٸ� ������ ���ν��� ȣ���� ���� �Է��ϰ��� �ϴ� ���
--    (��, �Է��� �õ��ϴ� ���)
--    ���ܿ� ���� ó���� �Ϸ��� �Ѵ�.
--    ���ν��� �� : PRC_MEMBER_INSERT()
/*
      ���� ��)
      EXEC PRC_MEMBER_INSERT('�ӽÿ�', '010-1111-1111', '����');
      -- ������ �Է� ��
      
      EXEC PRC_MEMBER_INSERT('�躸��', '010-2222-2222', '�λ�');
      -- ������ �Է� X
*/

CREATE OR REPLACE PROCEDURE PRC_MEMBER_INSERT
( V_NAME    IN TBL_MEMBER.NAME%TYPE
, V_TEL     IN TBL_MEMBER.TEL%TYPE
, V_CITY    IN TBL_MEMBER.CITY%TYPE
)
IS
    -- ���� ������ ������ ������ ���� �ʿ��� ���� �߰� ����
    V_NUM   TBL_MEMBER.NUM%TYPE;
    
    -- ����� ���� ���ܿ� ���� ���� ����!��
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    -- ���ν����� ���� �Է� ó���� ���������� �����ؾ� �� ����������
    -- �ƴ����� ���θ� ���� ���� Ȯ���� �� �ֵ��� �ڵ� ����
    IF (V_CITY NOT IN ('����', '���', '����'))
        -- THEN ���ܸ� �߻���Ű�ڴ�.
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- INSET �������� �����ϱ⿡ �ռ� ������ ������ �� ��Ƴ���
    SELECT NVL(MAX(NUM), 0) INTO V_NUM
    FROM TBL_MEMBER;
    
    -- ������ ���� �� INSERT
    INSERT INTO TBL_MEMBER(NUM, NAME, TEL, CITY)
    VALUES((V_NUM+1), V_NAME, V_TEL, V_CITY);
    
    -- ���� ó��
    EXCEPTION
    WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20001, '����, ���, ������ �Է��� �����մϴ�.');     -- ����Ŭ ��ü ���� ������ 20000������ ����!
    WHEN OTHERS
        THEN ROLLBACK;
END;
-- Procedure PRC_MEMBER_INSERT��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------


-- �� TBL_��� ���̺� ������ �Է� �� (��, ��� �̺�Ʈ �߻� ��)
--    TBL_��ǰ ���̺��� ��� ������ �����Ǵ� ���ν����� �ۼ��Ѵ�.
--    ��, ����ȣ�� �԰��ȣ�� ���������� �ڵ� ���� ó���Ѵ�.
--    ���� ��� ������ ��� �������� ���� ���,
--    ��� �׼� ó�� ��ü�� ����� �� �ֵ��� ó���Ѵ�. (��� �̷������ �ʵ���)
--    ���ν��� �� : PRC_���_INSERT()
/*
      ���� ��)
      EXEC PRC_���_INSERT('H001', 50, 1000);
*/

CREATE OR REPLACE PROCEDURE PRC_���_INSERT
( V_��ǰ�ڵ�    IN TBL_���.��ǰ�ڵ�%TYPE
, V_������    IN TBL_���.������%TYPE
, V_���ܰ�    IN TBL_���.���ܰ�%TYPE
)
IS
    -- ������ ������ ���� �߰� ���� ����
    V_����ȣ      TBL_���.����ȣ%TYPE;
    V_������      TBL_��ǰ.������%TYPE;
    
    -- ����� ���� ���� ����
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    -- �˻縦 ���� ������ �� ��Ƴ���(V_������)
    -- ����ľ��� ���� ������
    SELECT ������ INTO V_������
    FROM TBL_��ǰ
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    -- ��� ���� ���� ������ (���������� �������� ������ ���� �߻�)
    -- ��TBL_��ǰ.���������� �������δ� ȣ�� �Ұ� 
    IF ( V_������ > V_������ )
        -- ���� �߻�
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- ������ ������ �� ��Ƴ���(V_����ȣ)
    SELECT NVL(MAX(����ȣ), 0) INTO V_����ȣ
    FROM TBL_���;
    
    -- ������ ���� �� INSERT(TBL_���)
    INSERT INTO TBL_���(����ȣ, ��ǰ�ڵ�, ������, ���ܰ�)
    VALUES((V_����ȣ+1), V_��ǰ�ڵ�, V_������, V_���ܰ�);
    
    -- ������ ���� �� UPDATE(TBL_��ǰ)
    UPDATE TBL_��ǰ
    SET ������ = ������ - V_������
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    -- ���� ó��
    EXCEPTION
    WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20002, '��� ����');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;
        
    COMMIT;
    
END;
-- Procedure PRC_���_INSERT��(��) �����ϵǾ����ϴ�.

SELECT *
FROM TBL_���;


--------------------------------------------------------------------------------


-- �� TBL_��� ���̺��� ��� ������ ����(����)�ϴ� ���ν����� �ۼ��Ѵ�.
--    ���ν��� �� : PRC_���_UPDATE()
/*
      ���� ��)
      EXEC PRC_���_UPDATE(����ȣ, ������ ����);
*/

CREATE OR REPLACE PROCEDURE PRC_���_UPDATE
( V_����ȣ    IN TBL_���.����ȣ%TYPE
, V_�������    IN TBL_���.������%TYPE
)
IS
    -- ����� �������� ó���ϱ� ���� ���� ����
    V_��ǰ�ڵ�  TBL_��ǰ.��ǰ�ڵ�%TYPE;
    V_������  TBL_���.������%TYPE;
    V_������  TBL_��ǰ.������%TYPE;
    
    -- ����� ���� ���� ����
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    -- ������ ������ �� ��� (V_��ǰ�ڵ�)
    SELECT ��ǰ�ڵ� INTO V_��ǰ�ڵ�
    FROM TBL_���
    WHERE ����ȣ = V_����ȣ;
    
    -- ������ ������ �� ��� (V_������)
    SELECT ������ INTO V_������
    FROM TBL_���
    WHERE ����ȣ = V_����ȣ;
    
    -- ������ ������ �� ��� (V_������)
    SELECT ������ INTO V_������
    FROM TBL_��ǰ
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    -- ���� ���� Ȯ�� (������ ������ ����� ���� ���)
    IF ( V_������� > V_������ + V_������ )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- UPDATE (TBL_���)
    UPDATE TBL_���
    SET ������ = V_�������
    WHERE ����ȣ = V_����ȣ;
    
    -- UPDATE (TBL_��ǰ)
    UPDATE TBL_��ǰ
    SET ������ = V_������ + V_������ - V_�������
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    -- ����ó��
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '������');
        WHEN OTHERS
            THEN ROLLBACK;
    
    COMMIT;
END;
-- Procedure PRC_���_UPDATE��(��) �����ϵǾ����ϴ�.

/* ������ Ǯ�� -----------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_���_UPDATE
(
  -- �� �Ű����� ����
  V_����ȣ	IN TBL_���.����ȣ%TYPE
, V_������	IN TBL_���.������%TYPE
)
IS
	-- �� �ʿ��� ���� �߰� ����
	V_��ǰ�ڵ�		TBL_��ǰ.��ǰ�ڵ�%TYPE;
	V_����������		TBL_���.������%TYPE;
	V_������		TBL_��ǰ.������%TYPE;

	-- �� ���ܺ��� �߰� ����
	USER_DEFINE_ERROR		EXCEPTION;
BEGIN
	-- ������ ������ �� ��Ƴ���
	-- �� ��ǰ�ڵ�� ���������� �ľ�
	SELECT ��ǰ�ڵ�, ������ INTO V_��ǰ�ڵ�, V_����������
	FROM TBL_���
	WHERE ����ȣ = V_����ȣ;

	-- �� ������ �ľ�
	SELET ������ INTO V_������
	FROM TBL_��ǰ
	WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;

	-- �� ��� ���� ���� ���� �Ǵ� �ʿ�
	--	  ���� ������ ������ �� ������ ������ Ȯ��
	IF (V_������ + V_���������� < V_������)
		THEN RAISE USER_DEFINE_ERROR;
	END IF;

	-- �� ����� ������ üũ (UPDATE �� TBL_���)
	UPDATE TBL_���
	SET ������ = V_������
	WHERE ����ȣ = V_����ȣ;

	-- �� UPDATE �� TBL_��ǰ
	UPDATE TBL_��ǰ
	SET ������ = ������ + V_���������� - V_������
	WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
	
	-- �� ���� ó��
	EXCEPTION
		WHEN USER_DEFINE_ERROR
			THEN RAISE_APPLICATION_ERROR(-20002, '��� ����');
		WHEN OTHERS
			THEN ROLLBACK;
	
	-- �� Ŀ��
	COMMIT;
	
END;

*/


--------------------------------------------------------------------------------


--���� CURSOR(Ŀ��) ����--

-- 1. ����Ŭ������ �ϳ��� ���ڵ尡 �ƴ� ���� ���ڵ�� ������
--    �۾� �������� SQL ���� �����ϰ� �� �������� �߻��� �����͸�
--    �����ϱ� ���� Ŀ��(CURSOR)�� ����ϸ�,
--    Ŀ������ �Ͻ����� Ŀ���� ������� Ŀ���� �ִ�.

-- 2. �Ͻ��� Ŀ���� ��� SQL ���� �����ϸ�
--    SQL �� ���� �� ���� �ϳ��� ��(ROW)�� ����ϰ� �ȴ�.
--    �׷��� SQL ���� ������ �����(RESULT SET)��
--    ���� ��(ROW)���� ������ ���
--    Ŀ��(CURSOR)�� ��������� �����ؾ� ���� ��(ROW)�� �ٷ� �� �ִ�.


-- �� Ŀ�� �̿� �� ��Ȳ(���� �� ���� ��) ---------------------------------------
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
-- ȫ�浿--011-2356-4528


-- �� Ŀ�� �̿� �� ��Ȳ(���� �� ���� �� - �ݺ��� Ȱ��) -------------------------

/*
DECLARE
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
BEGIN
    SELECT NAME, TEL INTO V_NAME, V_TEL
    FROM TBL_INSA;
    
    DBMS_OUTPUT.PUT_LINE(V_NAME || '--' || V_TEL);
END;
-- ���� �߻� : ORA-01422: exact fetch returns more than requested number of rows
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
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.


-- �� Ŀ�� �̿� �� ��Ȳ(���� �� ���� �� - �ݺ��� Ȱ��) -------------------------

DECLARE
    -- �����
    -- �ֿ� ���� ����
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    
    -- Ŀ�� �̿��� ���� Ŀ������ ����(�� Ŀ�� ����)
    CURSOR  CUR_INSA_SELECT
    IS
    SELECT NAME, TEL
    FROM TBL_INSA;
    
BEGIN
    -- Ŀ�� ����
    OPEN CUR_INSA_SELECT;
    
    -- Ŀ�� ���� �� ����� ������ �����͵� ó��
    LOOP
        -- ��� ���� �޾� ó���ϴ� ���� �� ��FETCH��
        FETCH CUR_INSA_SELECT INTO V_NAME, V_TEL;
        
        -- Ŀ������ �� �̻� �����Ͱ� ����� ������ �ʴ� ����
        -- ��, Ŀ�� ���ο��� �� �̻� �����͸� ã�� �� ���� ����
        -- �� �ݺ��� ����������
        EXIT WHEN CUR_INSA_SELECT%NOTFOUND;
        
        -- ���
        DBMS_OUTPUT.PUT_LINE(V_NAME || '--' || V_TEL);
        
    END LOOP;
    
    -- Ŀ�� Ŭ����
    CLOSE CUR_INSA_SELECT;
    
END;
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.










