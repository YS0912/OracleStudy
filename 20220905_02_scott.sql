SELECT USER
FROM DUAL;
-- SCOTT


-- ���� AFTER STATEMENT TRIGGER ��Ȳ �ǽ� ���� --
-- ��DML �۾��� ���� �̺�Ʈ ���

-- �ǽ� ���̺� ����(TBL_TEST1)
CREATE TABLE TBL_TEST1
( ID    NUMBER
, NAME  VARCHAR2(30)
, TEL   VARCHAR2(60)
, CONSTRAINT TEST1_ID_PK PRIMARY KEY(ID)
);
-- Table TBL_TEST1��(��) �����Ǿ����ϴ�.

-- �ǽ� ���̺� ����(TBL_EVENTLOG)
CREATE TABLE TBL_EVENTLOG
( MEMO  VARCHAR2(200)
, INJA  DATE DEFAULT SYSDATE
);
-- Table TBL_EVENTLOG��(��) �����Ǿ����ϴ�.

-- Ȯ��
SELECT *
FROM TBL_TEST1;
-- ��ȸ��� ����

SELECT *
FROM TBL_EVENTLOG;
-- ��ȸ��� ����

-- �� ������ TRIGGER �۵����� Ȯ��
--    �� TBL_TEST1 ���̺��� ������� INSERT, UPDATE, DELETE ����
INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(1, '������', '010-1111-1111');
-- 1 �� ��(��) ���ԵǾ����ϴ�.

UPDATE TBL_TEST1
SET NAME = '�δ�����'
WHERE ID = 1;
-- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(2, '�ֳ���', '010-2222-2222');
-- 1 �� ��(��) ���ԵǾ����ϴ�.

UPDATE TBL_TEST1
SET NAME = '�ִ�����'
WHERE ID = 2;
-- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(3, '��������', '010-3333-3333');
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(4, '�������', '010-4444-4444');
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(5, '��������', '010-5555-5555');
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(6, '��������', '010-6666-6666');
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(7, '�ڴ�����', '010-7777-7777');
-- 1 �� ��(��) ���ԵǾ����ϴ�.

SELECT *
FROM TBL_TEST1;

DELETE
FROM TBL_TEST1;
-- 7�� �� ��(��) �����Ǿ����ϴ�.

-- Ȯ��
SELECT *
FROM TBL_TEST1;
-- ��ȸ��� ����

COMMIT;
-- Ŀ�� �Ϸ�.

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
-- Session��(��) ����Ǿ����ϴ�.

SELECT *
FROM TBL_EVENTLOG;
/*
INSERT ������ ����Ǿ����ϴ�.	2022-09-05 10:08:16
UPDATE ������ ����Ǿ����ϴ�.	2022-09-05 10:09:51
INSERT ������ ����Ǿ����ϴ�.	2022-09-05 10:10:31
UPDATE ������ ����Ǿ����ϴ�.	2022-09-05 10:11:34
INSERT ������ ����Ǿ����ϴ�.	2022-09-05 10:12:09
INSERT ������ ����Ǿ����ϴ�.	2022-09-05 10:13:11
INSERT ������ ����Ǿ����ϴ�.	2022-09-05 10:13:14
INSERT ������ ����Ǿ����ϴ�.	2022-09-05 10:13:16
INSERT ������ ����Ǿ����ϴ�.	2022-09-05 10:13:36
DELETE ������ ����Ǿ����ϴ�.	2022-09-05 10:14:48
*/


--------------------------------------------------------------------------------

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(8, '�躸��', '010-8888-8888');
-- 1 �� ��(��) ���ԵǾ����ϴ�.

UPDATE TBL_TEST1
SET NAME = '�������'
WHERE ID = 8;
-- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.

DELETE
FROM TBL_TEST1
WHERE ID = 8;
-- 1 �� ��(��) �����Ǿ����ϴ�.

-- �ð��� ���� (�� ���� 7�� 40��)
-- �� ����Ŭ ������ �ִ� ��ǻ���� �ð��� �ٲ�� Ʈ���� �۵�
INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(9, '����', '010-9999-9999');


------------------ ���� BEFORE ROW TRIGGER ��Ȳ �ǽ� ���� ------------------

-- �� ���� ���谡 ������ ������(�ڽ�) ������ ���� �����ϴ� ��

-- �ǽ��� ���� ���̺� ����(TBL_TEST2)
CREATE TABLE TBL_TEST2
( CODE  NUMBER
, NAME  VARCHAR2(40)
, CONSTRAINT TEST2_CODE_PK PRIMARY KEY(CODE)
);
-- Table TBL_TEST2��(��) �����Ǿ����ϴ�.

-- �ǽ��� ���� ���̺� ����(TBL_TEST3)
CREATE TABLE TBL_TEST3
( SID   NUMBER
, CODE  NUMBER
, SU    NUMBER
, CONSTRAINT TET3_SID_PK PRIMARY KEY(SID)
, CONSTRAINT TEST3_CODE_FK FOREIGN KEY(CODE)
             REFERENCES TBL_TEST2(CODE)
);
-- Table TBL_TEST3��(��) �����Ǿ����ϴ�.


-- �ǽ� ���� ������ �Է�
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(1, '�ڷ�����');
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(2, '�����');
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(3, '��Ź��');
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(4, '������');
-- 1 �� ��(��) ���ԵǾ����ϴ�. * 4

SELECT *
FROM TBL_TEST2;
/*
1	�ڷ�����
2	�����
3	��Ź��
4	������
*/

COMMIT;


-- �ǽ� ���� ������ �Է�
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
-- Ŀ�� �Ϸ�.


SELECT *
FROM TBL_TEST2;
SELECT *
FROM TBL_TEST3;


-- TBL_TEST2(�θ�) ���̺��� ������ ���� �õ�
DELETE
FROM TBL_TEST2
WHERE CODE = 4;
-- ���� �߻� : ORA-02292: integrity constraint (SCOTT.TEST3_CODE_FK) violated - child record found

DELETE
FROM TBL_TEST2
WHERE CODE = 4;
-- 1 �� ��(��) �����Ǿ����ϴ�.

DELETE
FROM TBL_TEST2
WHERE CODE = 3;
-- 1 �� ��(��) �����Ǿ����ϴ�.

DELETE
FROM TBL_TEST2
WHERE CODE = 2;
-- 1 �� ��(��) �����Ǿ����ϴ�.

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
-- Ŀ�� �Ϸ�.


------------------ ���� AFTER ROW TRIGGER ��Ȳ �ǽ� ���� -------------------

-- �� ���� ���̺� ���� Ʈ����� ó��

SELECT *
FROM TBL_��ǰ;
SELECT *
FROM TBL_�԰�;

INSERT INTO TBL_�԰�(�԰��ȣ, ��ǰ�ڵ�, �԰����, �԰�ܰ�)
VALUES(7, 'C003', 70, 2000);
-- 1 �� ��(��) ���ԵǾ����ϴ�. (�����)

SELECT *
FROM TBL_��ǰ;
-- C003	�����	1300	70


-- ��Ű�� Ȱ�� �ǽ� ------------------------------------------------------------

-- ������ �Լ� ȣ�� �� ��Ű����.�Լ���()
SELECT INSA_PACK.FN_GENDER('751212-1234567') "�Լ�ȣ����"
FROM DUAL;
-- ����

SELECT INSA_PACK.FN_GENDER('751212-2234567') "�Լ�ȣ����"
FROM DUAL;
-- ����
















