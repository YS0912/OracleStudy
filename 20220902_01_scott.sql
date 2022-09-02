SELECT USER
FROM DUAL;
-- SCOTT


-- �� �ǽ� ���̺� ����(TBL_��ǰ) �� ���ظ� ���� ���� �ѱ۸�!
CREATE TABLE TBL_��ǰ
( ��ǰ�ڵ�       VARCHAR2(20)
, ��ǰ��         VARCHAR2(100)
, �Һ��ڰ���     NUMBER
, ������       NUMBER DEFAULT 0
, CONSTRAINT ��ǰ_��ǰ�ڵ�_PK PRIMARY KEY(��ǰ�ڵ�)
);
-- Table TBL_��ǰ��(��) �����Ǿ����ϴ�.

-- �ǽ� ���̺� ����(TBL_�԰�)
CREATE TABLE TBL_�԰�
( �԰��ȣ  NUMBER
, ��ǰ�ڵ�  VARCHAR2(20)
, �԰�����  DATE DEFAULT SYSDATE
, �԰����  NUMBER
, �԰�ܰ�  NUMBER
, CONSTRAINT �԰�_�԰��ȣ_PK PRIMARY KEY(�԰��ȣ)
, CONSTRAINT �԰�_��ǰ�ڵ�_FK FOREIGN KEY(��ǰ�ڵ�)
             REFERENCES TBL_��ǰ(��ǰ�ڵ�)
);
-- Table TBL_�԰���(��) �����Ǿ����ϴ�.


-- TBL_��ǰ ���̺� ��ǰ ������ �Է�
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('C001', '������', 1500);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('C002', '������', 1500);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('C003', '�����', 1300);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('C004', '������', 1800);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('C005', '������', 1900);
-- 1 �� ��(��) ���ԵǾ����ϴ�. * 5

INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('H001', '��ũ����', 1000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('H002', 'ĵ���', 300);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('H003', '�ֹֽ�', 500);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('H004', '������', 600);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('H005', '�޷γ�', 500);
-- 1 �� ��(��) ���ԵǾ����ϴ�. * 5

INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('E001', '�������̽�', 2500);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('E002', '�ؾ�θ���', 2000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('E003', '���Ǿ�', 2300);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('E004', '�źϾ�', 2300);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('E005', '��Ű��', 2400);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('E006', '��ȭ��', 2000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('E007', '���Դ�', 3000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('E008', '������Ʈ', 3000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�, ��ǰ��, �Һ��ڰ���) VALUES('E009', '������', 3000);
-- 1 �� ��(��) ���ԵǾ����ϴ�. * 9

-- Ȯ��
SELECT *
FROM TBL_��ǰ;

COMMIT;
-- Ŀ�� �Ϸ�.


SELECT *
FROM TAB;


-- �� ���ν��� ������ 20220902_02_scott(plsql) Ȯ�� ----------------------------

-- ���ν��� ȣ���� ���� ���� �۵����� Ȯ��
EXEC PRC_�԰�_INSERT('C001', 30, 1200);               -- ������ 30�� �԰�
EXEC PRC_�԰�_INSERT('C002', 30, 1200);               -- ������ 30�� �԰�

EXEC PRC_�԰�_INSERT('H001', 50, 800);                -- ��ũ���� 50�� �԰�
EXEC PRC_�԰�_INSERT('H002', 50, 200);                -- ĵ��� 50�� �԰�
EXEC PRC_�԰�_INSERT('H001', 50, 800);                -- ��ũ���� 50�� �԰�
EXEC PRC_�԰�_INSERT('H002', 50, 200);                -- ĵ��� 50�� �԰�

SELECT *
FROM TBL_��ǰ;
SELECT *
FROM TBL_�԰�;
/*
1	C001	2022-09-02	30	1200
2	C002	2022-09-02	30	1200
3	H001	2022-09-02	50	800
4	H002	2022-09-02	50	200
5	H001	2022-09-02	50	800
6	H002	2022-09-02	50	200
*/


--------------------------------------------------------------------------------


--���� ���ν��� �������� ���� ó�� ����--

-- �ǽ� ���̺� ����(TBL_MEMEBER)
CREATE TABLE TBL_MEMBER
( NUM   NUMBER
, NAME  VARCHAR2(30)
, TEL   VARCHAR2(60)
, CITY  VARCHAR2(60)
, CONSTRAINT MEMBER_NUM_PK PRIMARY KEY(NUM)
);
-- Table TBL_MEMBER��(��) �����Ǿ����ϴ�.


-- �� ���ν��� ������ 20220902_02_scott(plsql) Ȯ�� ----------------------------

-- ���ν��� ȣ���� ���� Ȯ��
EXEC PRC_MEMBER_INSERT('�ӽÿ�', '010-1111-1111', '����');
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
-- �� ������ �Է� ��

EXEC PRC_MEMBER_INSERT('�躸��', '010-2222-2222', '�λ�');
-- ���� �߻� : ORA-20001: ����, ���, ������ �Է��� �����մϴ�.
-- �� ������ �Է� X

SELECT *
FROM TBL_MEMBER;
-- 1	�ӽÿ�	010-1111-1111	����


--------------------------------------------------------------------------------

-- �� �ǽ� ���̺� ����(TBL_���)
CREATE TABLE TBL_���
( ����ȣ  NUMBER
, ��ǰ�ڵ�  VARCHAR2(20)
, �������  DATE DEFAULT SYSDATE
, ������  NUMBER
, ���ܰ�  NUMBER
);
-- Table TBL_�����(��) �����Ǿ����ϴ�.

-- ����ȣ PK ����
ALTER TABLE TBL_���
ADD CONSTRAINTS ���_����ȣ_PK PRIMARY KEY(����ȣ);
-- Table TBL_�����(��) ����Ǿ����ϴ�.

-- ��ǰ�ڵ� FK ����
ALTER TABLE TBL_���
ADD CONSTRAINTS ���_��ǰ�ڵ�_FK FOREIGN KEY(��ǰ�ڵ�)
                REFERENCES TBL_��ǰ(��ǰ�ڵ�);
-- Table TBL_�����(��) ����Ǿ����ϴ�.


-- �� ���ν��� ������ 20220902_02_scott(plsql) Ȯ�� ----------------------------

SELECT *
FROM TBL_��ǰ;
SELECT *
FROM TBL_���;
-- ��ȸ ��� ����

-- ���ν��� ȣ���� ���� ���� �۵����� Ȯ��
EXEC PRC_���_INSERT('H001', 50, 1000);
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

-- ���ν��� ȣ�� �� ���̺� Ȯ��
SELECT *
FROM TBL_��ǰ;
-- H001	��ũ����	1000	50
SELECT *
FROM TBL_���;
-- 1	H001	2022-09-02	50	1000

EXEC PRC_���_INSERT('H001', 80, 1000);
-- ���� �߻� : ORA-20002: ��� ����

SELECT *
FROM TBL_��ǰ;
SELECT *
FROM TBL_���;
-- ��ȭ ����


-- �� ���ν��� ������ 20220902_02_scott(plsql) Ȯ�� ----------------------------

-- ���ν��� ȣ���� ���� ���� �۵����� Ȯ��
EXEC PRC_���_UPDATE(1, 110);
-- ORA-20001: ������

SELECT *
FROM TBL_��ǰ;
SELECT *
FROM TBL_���;
-- ���� ���� ����

EXEC PRC_���_UPDATE(1, 100);
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM TBL_��ǰ;
-- H001	��ũ����	1000	0
SELECT *
FROM TBL_���;
-- 1	H001	2022-09-02	100	1000


--------------------------------------------------------------------------------



