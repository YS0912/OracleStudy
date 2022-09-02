SELECT USER
FROM DUAL;
-- SCOTT


-- ����
/*
1. PRC_�԰�_UPDATE(�԰��ȣ, �԰����)    �� ��� ������Ʈ �ߴ� ��ó���� ����!
2. PRC_�԰�_DELETE(�԰��ȣ)
3. PRC_���_DELECT(����ȣ)
*/

-- 1. PRC_�԰�_UPDATE(�԰��ȣ, �԰����) --------------------------------------

CREATE OR REPLACE PROCEDURE PRC_�԰�_UPDATE
( V_�԰��ȣ    IN TBL_�԰�.�԰��ȣ%TYPE
, V_�԰����    IN TBL_�԰�.�԰����%TYPE
)
IS
    -- �� �������� �ʿ��� ���� ����
    V_��ǰ�ڵ�        TBL_�԰�.��ǰ�ڵ�%TYPE;
    V_�����԰����    TBL_�԰�.�԰����%TYPE;
    V_������        TBL_��ǰ.������%TYPE;
    
    -- �� ���� ���� �߰� ����
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    -- �� ������ ������ �� ��Ƴ��� (V_��ǰ�ڵ�, V_�����԰����)
    SELECT ��ǰ�ڵ�, �԰���� INTO V_��ǰ�ڵ�, V_�����԰����
    FROM TBL_�԰�
    WHERE �԰��ȣ = V_�԰��ȣ;
    
    -- �� ������ ������ �� ��Ƴ��� (V_������)
    SELECT ������ INTO V_������
    FROM TBL_��ǰ
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    -- �� (TBL_��ǰ.������ - V_�����԰���� + V_�԰������ ������ ��� ���� �߻�
    --     ----------------- V_������
    IF ( V_������ - V_�����԰���� + V_�԰���� < 0 )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- �� UPDATE ������ �� TBL_�԰�
    UPDATE TBL_�԰�
    SET �԰���� = V_�԰����
    WHERE �԰��ȣ = V_�԰��ȣ;
    
    -- �� UPDATE ������ �� TBL_��ǰ
    UPDATE TBL_��ǰ
    SET ������ = ������ - V_�����԰���� + V_�԰����
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    -- �� ���� ó��
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '��� ����');
        WHEN OTHERS
            THEN ROLLBACK;
    
    -- �� Ŀ��
    COMMIT;
    
END;
-- Procedure PRC_�԰�_UPDATE��(��) �����ϵǾ����ϴ�.


-- 2. PRC_�԰�_DELETE(�԰��ȣ) ------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_�԰�_DELETE
( V_�԰��ȣ    IN TBL_�԰�.�԰��ȣ%TYPE
)
IS
    -- �� ���������� �ʿ��� ���� ����
    V_��ǰ�ڵ�  TBL_�԰�.��ǰ�ڵ�%TYPE;
    V_�԰����  TBL_�԰�.�԰����%TYPE;
    V_������  TBL_��ǰ.������%TYPE;
    
    -- �� ���� ���� ����
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    -- �� ������ ������ �� ��� (V_������)
    SELECT ������ INTO V_������
    FROM TBL_��ǰ
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    -- �� TBL_��ǰ.�������� V_�԰�������� ���� ��� ���� �߻�
    --    ----------------- V_������
    IF (V_������ < V_�԰����)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- �� ������ ������ �� ��� (V_��ǰ�ڵ�, V_�԰����)
    SELECT ��ǰ�ڵ�, �԰���� INTO V_��ǰ�ڵ�, V_�԰����
    FROM TBL_�԰�
    WHERE �԰��ȣ = V_�԰��ȣ;
    
    -- �� DELETE ������ �� TBL_�԰�
    DELETE
    FROM TBL_�԰�
    WHERE �԰��ȣ = V_�԰��ȣ;
    
    -- �� UPDATE ������ �� TBL_��ǰ
    UPDATE TBL_��ǰ
    SET ������ = ������ - V_�԰����
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
-- Procedure PRC_�԰�_DELETE��(��) �����ϵǾ����ϴ�.


-- 3. PRC_���_DELETE(����ȣ) ------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_���_DELETE
( V_����ȣ   IN TBL_���.����ȣ%TYPE
)
IS
    -- �� ������ �ۼ� �� �ʿ��� ���� ����
    V_��ǰ�ڵ�  TBL_���.��ǰ�ڵ�%TYPE;
    V_������  TBL_���.������%TYPE;
BEGIN
    -- �� ������ �� ��Ƴ��� (V_��ǰ�ڵ�, V_������)
    SELECT ��ǰ�ڵ�, ������ INTO V_��ǰ�ڵ�, V_������
    FROM TBL_���
    WHERE ����ȣ = V_����ȣ;
    
    -- �� DELETE ������ �� TBL_���
    DELETE
    FROM TBL_���
    WHERE ����ȣ = V_����ȣ;
    
    -- �� UPDATE ������ �� TBL_��ǰ
    UPDATE TBL_��ǰ
    SET ������ = ������ + V_������
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    -- �� ���� ó��
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;
        
    -- �� Ŀ��
    COMMIT;
    
END;
-- Procedure PRC_���_DELETE��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------

