SELECT USER
FROM DUAL;
-- HR


/*
--���� ���Ἲ(Integrity) ����--

1. ���Ἲ���� ��ü ���Ἲ(Entity Integrity)
              ���� ���Ἲ(Reference Integrity)
              ���� ���Ἲ(Domain Integrity)�� �ִ�.
              
2. ��ü ���Ἲ(Entity Integrity)                         �� �ߺ��Ǵ� ���� ������ �ϴ� ��
   ��ü ���Ἲ�� �����̼ǿ��� ����Ǵ� Ʃ��(tuple)��
   ���ϼ��� �����ϱ� ���� ���������̴�.
   
3. ���� ���Ἲ(Reference Integrity)                      �� ���� �ϴ� �ʿ��� �����͸� �޾ƿ� �� ������ ������ �ϴ� �� 
   ���� ���Ἲ�� �����̼� ���� ������ �ϰ�����
   �����ϱ� ���� ���������̴�.

4. ���� ���Ἲ(Domain Integrity)                       �� �����Ͱ� ���ԵǾ�� �ϴ� ������ ��Ű���� �ϴ� �� (ex. ����)
   ������ ���Ἲ�� ��� ������ ���� ������
   �����ϱ� ���� ���������̴�.

5. ���������� ����

   �� PRIMARY KEY(PK:P) �� �⺻Ű, ����Ű, �ĺ�Ű, �ĺ���
      �ش� �÷��� ���� �ݵ�� �����ؾ� �ϸ�, �����ؾ� �Ѵ�.
      (NOT NULL�� UNIQUE�� ���յ� ����)
   
   �� FOREIGN KEY(FK:F:R) �� �ܷ�Ű, �ܺ�Ű, ����Ű
      �ش� �÷��� ���� �����Ǵ� ���̺��� �÷� �����͵� �� �ϳ���
      ��ġ�ϰų� NULL�� ������.
      
   �� UNIQUE(UK:U)
      ���̺� ������ �ش� �÷��� ���� �׻� �����ؾ� �Ѵ�.
      
   �� NOT NULL(NN:CK:C)
      �ش� �÷��� NULL�� ������ �� ����.
      
   �� CHECK(CK:C)
      �ش� �÷��� ���� ������ �������� ������ ������ �����Ѵ�.
*/


--���� PRIMARY KEY ����--

-- 1. ���̺� ���� �⺻ Ű�� �����Ѵ�.

-- 2. ���̺��� �� ���� �����ϰ� �ĺ��ϴ� �÷� �Ǵ� �÷��� ���մϴ�.
--    �⺻ Ű�� ���̺� �� �ִ� �ϳ��� �����Ѵ�.
--    �׷��� �ݵ�� �ϳ��� �÷����θ� �����Ǵ� ���� �ƴϴ�.
--    NULL�� �� ����, �̹� ���̺� �����ϰ� �ִ� �����͸�
--    �ٽ� �Է��� �� ������ ó���Ѵ�. (���ϼ�)
--    UNIQUE INDEX�� ����Ŭ ���������� �ڵ����� �����ȴ�.

-- 3. ���� �� ����
--    �� �÷� ������ ����
--       �÷��� ������Ÿ�� [CONSTRAINT CONSTRAINT��] PRIMARY KEY[(�÷���, ...)]

--    �� ���̺� ������ ����
--       �÷��� ������Ÿ��,
--       �÷��� ������Ÿ��,
--       CONSTRAINT CONSTRAINT�� PRIMARY KEY(�÷���, ...)

-- 4. CONSTRAINT �߰� �� CONSTRAINT���� �����ϸ�
--    ����Ŭ ������ �ڵ������� CONSTRAINT���� �ο��Ѵ�.
--    �Ϲ������� CONSTRAINT���� �����̺��_�÷���_CONSTRAINT���ڡ�
--    �������� ����Ѵ�.

-- �� PK ���� �ǽ� (�� �÷� ������ ����) ---------------------------------------
-- ���̺� ����
CREATE TABLE TBL_TEST1
( COL1  NUMBER(5)       PRIMARY KEY
, COL2  VARCHAR2(30)
);
-- Table TBL_TEST1��(��) �����Ǿ����ϴ�.

SELECT *
FROM TBL_TEST1;

DESC TBL_TEST1;
/*
�̸�   ��?       ����           
---- -------- ------------ 
COL1 NOT NULL NUMBER(5)    
COL2          VARCHAR2(30) 
*/

-- ������ �Է�
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(1, 'TEST');
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(1, 'TEST');    -- ���� �߻� : ORA-00001: unique constraint (HR.SYS_C007060) violated
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(1, 'ABCD');    -- ���� �߻� : ORA-00001: unique constraint (HR.SYS_C007060) violated
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(2, 'ABCD');
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(3, NULL);
INSERT INTO TBL_TEST1(COL1) VALUES(4);
INSERT INTO TBL_TEST1(COL1) VALUES(4);                  -- ���� �߻� : ORA-00001: unique constraint (HR.SYS_C007060) violated
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(5, 'ABCD');
INSERT INTO TBL_TEST1(COL1, COL2) VALUES(NULL, NULL);   -- ���� �߻� : ORA-01400: cannot insert NULL into ("HR"."TBL_TEST1"."COL1")

COMMIT;
-- Ŀ�� �Ϸ�.

SELECT *
FROM TBL_TEST1;
/*
1	TEST
2	ABCD
3	(null)
4	(null)
5	ABCD
*/

DESC TBL_TEST1;
/*
�̸�   ��?       ����           
---- -------- ------------ 
COL1 NOT NULL NUMBER(5)         �� PK �������� Ȯ�� �Ұ�
COL2          VARCHAR2(30) 
*/

-- �� �������� Ȯ��
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TBL_TEST1';
-- HR	SYS_C007060	P	TBL_TEST1					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	GENERATED NAME			22/08/24	HR	SYS_C007060	

SELECT *
FROM USER_CONS_COLUMNS
WHERE TABLE_NAME = 'TBL_TEST1';
-- HR	SYS_C007060	TBL_TEST1	COL1	1

-- �� USER_CONSTRAINTS�� USER_CONS_COLUMNS�� �������
--    ���������� ������ ������, �������Ǹ�, ���̺��, ������������, �÷��� �׸��� ��ȸ�Ѵ�.
SELECT CC.OWNER, CC.CONSTRAINT_NAME, CC.TABLE_NAME, C.CONSTRAINT_TYPE, CC.COLUMN_NAME
FROM USER_CONSTRAINTS C JOIN USER_CONS_COLUMNS CC
ON CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME;


-- �� PK ���� �ǽ� (�� �÷� ������ ����) ---------------------------------------
-- ���̺� ����
CREATE TABLE TBL_TEST2
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, CONSTRAINT TEST2_COL1_PK PRIMARY KEY(COL1)
);
-- Table TBL_TEST2��(��) �����Ǿ����ϴ�.

-- ������ �Է�
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(1, 'TEST');
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(1, 'TEST');        -- ���� �߻� : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(1, 'ABCD');        -- ���� �߻� : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(2, 'ABCD');
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(3, NULL);
INSERT INTO TBL_TEST2(COL1) VALUES(4);
INSERT INTO TBL_TEST2(COL1) VALUES(4);                      -- ���� �߻� : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(5, 'ABCD');
INSERT INTO TBL_TEST2(COL1, COL2) VALUES(NULL, NULL);       -- ���� �߻� : ORA-01400: cannot insert NULL into ("HR"."TBL_TEST2"."COL1")
INSERT INTO TBL_TEST2(COL2) VALUES('KKKK');                 -- ORA-01400: cannot insert NULL into ("HR"."TBL_TEST2"."COL1")

COMMIT;
-- Ŀ�� �Ϸ�.

SELECT *
FROM TBL_TEST2;
/*
1	TEST
2	ABCD
3	(null)
4	(null)
5	ABCD
*/

-- �� USER_CONSTRAINTS�� USER_CONS_COLUMNS�� �������
--    ���������� ������ ������, �������Ǹ�, ���̺��, ������������, �÷��� �׸��� ��ȸ�Ѵ�.
SELECT CC.OWNER, CC.CONSTRAINT_NAME, CC.TABLE_NAME, C.CONSTRAINT_TYPE, CC.COLUMN_NAME
FROM USER_CONSTRAINTS C, USER_CONS_COLUMNS CC
WHERE CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
  AND C.TABLE_NAME = 'TBL_TEST2';
-- HR	TEST2_COL1_PK	TBL_TEST2	P	COL1


-- �� PK ���� �ǽ� (�� ���� �÷� PK ����) --------------------------------------
-- ���̺� ����
CREATE TABLE TBL_TEST3
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, CONSTRAINT TEST3_COL1_COL2_PK PRIMARY KEY(COL1,COL2)
);
-- Table TBL_TEST3��(��) �����Ǿ����ϴ�.

-- ������ �Է�
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(1, 'TEST');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(1, 'TEST');        -- ���� �߻� : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(1, 'ABCD');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(2, 'ABCD');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(2, 'TEST');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(3, NULL);          -- ���� �߻� : ORA-01400: cannot insert NULL into ("HR"."TBL_TEST3"."COL2")

INSERT INTO TBL_TEST3(COL1) VALUES(4);
INSERT INTO TBL_TEST3(COL1) VALUES(4);                      -- ���� �߻� : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(5, 'ABCD');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(NULL, NULL);       -- ���� �߻� : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated
INSERT INTO TBL_TEST3(COL2) VALUES('KKKK');                 -- ���� �߻� : ORA-00001: unique constraint (HR.TEST2_COL1_PK) violated

COMMIT;
-- Ŀ�� �Ϸ�.

SELECT *
FROM TBL_TEST3;
/*
1	ABCD
1	TEST
2	ABCD
2	TEST
*/

-- �� USER_CONSTRAINTS�� USER_CONS_COLUMNS�� �������
--    ���������� ������ ������, �������Ǹ�, ���̺��, ������������, �÷��� �׸��� ��ȸ�Ѵ�.
SELECT CC.OWNER, CC.CONSTRAINT_NAME, CC.TABLE_NAME, C.CONSTRAINT_TYPE, CC.COLUMN_NAME
FROM USER_CONSTRAINTS C, USER_CONS_COLUMNS CC
WHERE CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
  AND C.TABLE_NAME = 'TBL_TEST3';
/*
HR	TEST3_COL1_COL2_PK	TBL_TEST3	P	COL1
HR	TEST3_COL1_COL2_PK	TBL_TEST3	P	COL2

�� ��ȸ ����� 2������,
   CONSTRAINT_NAME�� �����ϱ� ������ ���� ���������̴�.
*/


-- �� PK ���� �ǽ� (�� ���̺� ���� ���� �������� �߰� ����) --------------------
-- ���̺� ����
CREATE TABLE TBL_TEST4
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
);
-- Table TBL_TEST4��(��) �����Ǿ����ϴ�.

-- �� �̹� ������(������� �ִ�) ���̺�
--    �ο��Ϸ��� ���������� ������ �����Ͱ� ���ԵǾ� ���� ���
--    �ش� ���̺� ���������� �߰��ϴ� ���� �Ұ����ϴ�.

-- �������� �߰�
ALTER TABLE TBL_TEST4
ADD CONSTRAINT TEST4_COL1_PK PRIMARY KEY(COL1);
-- Table TBL_TEST4��(��) ����Ǿ����ϴ�.

-- �� USER_CONSTRAINTS�� USER_CONS_COLUMNS�� �������
--    ���������� ������ ������, �������Ǹ�, ���̺��, ������������, �÷��� �׸��� ��ȸ�Ѵ�.
SELECT CC.OWNER, CC.CONSTRAINT_NAME, CC.TABLE_NAME, C.CONSTRAINT_TYPE, CC.COLUMN_NAME
FROM USER_CONSTRAINTS C, USER_CONS_COLUMNS CC
WHERE CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
  AND C.TABLE_NAME = 'TBL_TEST4';
-- HR	TEST4_COL1_PK	TBL_TEST4	P	COL1


-- �� �������� Ȯ�� ���� ��(VIEW) ����
CREATE OR REPLACE VIEW VIEW_CONSTCHECK
AS
SELECT UC.OWNER "OWNER"
     , UC.CONSTRAINT_NAME "CONSTRAINT_NAME"
     , UC.TABLE_NAME "TABLE_NAME"
     , UC.CONSTRAINT_TYPE "CONSTRAINT_TYPE"
     , UCC.COLUMN_NAME "COLUMN_NAME"
     , UC.SEARCH_CONDITION "SEARCH_CONDITION"
     , UC.DELETE_RULE "DELETE_RULE"
FROM USER_CONSTRAINTS UC JOIN USER_CONS_COLUMNS UCC
ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME;
-- View VIEW_CONSTCHECK��(��) �����Ǿ����ϴ�.

-- ������ ��(VIEW)�� ���� �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST4';
-- HR	TEST4_COL1_PK	TBL_TEST4	P	COL1    (null)  (null)


--------------------------------------------------------------------------------


--���� UNIQUE(UK:U) ����--

-- 1. ���̺��� ������ �÷��� �����Ͱ� �ߺ����� �ʰ� ������ �� �ֵ��� �����ϴ� ��������
--    PRIMARY KEY�� ������ ��������������, NULL�� ����Ѵٴ� �������� �ִ�.
--    ���������� PRIMARR KEY�� ���������� UNIQUE INDEX�� �ڵ� �����ȴ�.
--    �ϳ��� ���̺� ������ UNIQUE ���������� ���� �� �����ϴ� ���� �����ϴ�.
--    ��, �ϳ��� ���̺� UNIQUE ���������� ���� �� ����� ���� �����ϴٴ� ���̴�.

-- 2. ���� �� ����
--    �� �÷� ������ ����
--       �÷��� ������Ÿ�� [CONSTRAINT CONSTRAINT��] UNIQUE

--    �� ���̺� ������ ����
--       �÷��� ������Ÿ��,
--       �÷��� ������Ÿ��,
--       CONSTRAINT CONSTRAINT�� UNIQUE(�÷���, ...)

-- �� UK ���� �ǽ�(�� �÷� ������ ����) ----------------------------------------
-- ���̺� ����
CREATE TABLE TBL_TEST5
( COL1 NUMBER(5)        PRIMARY KEY
, COL2 VARCHAR2(30)     UNIQUE
);
-- Table TBL_TEST5��(��) �����Ǿ����ϴ�.

-- �������� ��ȸ
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST5';
/*
HR	SYS_C007064	TBL_TEST5	P	COL1		
HR	SYS_C007065	TBL_TEST5	U	COL2		
*/

-- ������ �Է�
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(1, 'TEST5');
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(1, 'TEST5');       -- ���� �߻� : ORA-00001: unique constraint (HR.SYS_C007064) violated
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(2, 'ABCD');
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(3, 'ABCD');        -- ���� �߻� : ORA-00001: unique constraint (HR.SYS_C007065) violated
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(3, NULL);
INSERT INTO TBL_TEST5(COL1) VALUES(4);                      -- NULL�� �����Ͱ� �ƴϱ� ������ UNIQUE �������ǿ� �ɸ��� �ʴ´�.
INSERT INTO TBL_TEST5(COL1, COL2) VALUES(5, 'ABCD');        -- ���� �߻� : ORA-00001: unique constraint (HR.SYS_C007065) violated

COMMIT;

SELECT *
FROM TBL_TEST5;
/*
1	TEST5
2	ABCD
3	(null)
4	(null)
*/

-- �� UK ���� �ǽ�(�� ���̺� ������ ����) --------------------------------------
-- ���̺� ����
CREATE TABLE TBL_TEST6
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, CONSTRAINT TEST6_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST6_COL2_UK UNIQUE(COL2)
);
-- Table TBL_TEST6��(��) �����Ǿ����ϴ�.

SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST6';
/*
HR	TEST6_COL1_PK	TBL_TEST6	P	COL1		
HR	TEST6_COL2_UK	TBL_TEST6	U	COL2		
*/

-- �� UK ���� �ǽ�(�� ���̺� ���� ���� �������� �߰�) --------------------------
-- ���̺� ����
CREATE TABLE TBL_TEST7
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
);
-- Table TBL_TEST7��(��) �����Ǿ����ϴ�.

-- �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST7';
-- ��ȸ ��� ����

-- �������� �߰�
ALTER TABLE TBL_TEST7
ADD CONSTRAINT TEST7_COL1_PK PRIMARY KEY(COL1);
-- +
ALTER TABLE TBL_TEST7
ADD CONSTRAINT TEST7_COL2_UK PRIMARY KEY(COL2);
-- ��
ALTER TABLE TBL_TEST7
ADD( CONSTRAINT TEST7_COL1_PK PRIMARY KEY(COL1)
   , CONSTRAINT TEST7_COL2_UK UNIQUE(COL2) );
-- Table TBL_TEST7��(��) ����Ǿ����ϴ�.

-- �������� �߰� ���� �ٽ� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST7';
/*
HR	TEST7_COL1_PK	TBL_TEST7	P	COL1		
HR	TEST7_COL2_UK	TBL_TEST7	U	COL2		
*/


--------------------------------------------------------------------------------


--���� CHECK(CK:C) ����--

-- 1. �÷����� ��� ������ �������� ������ ������ �����ϱ� ���� ��������                 �� Ex. NUMBER(3) ������ ������ ������ 0~100���� ���� (����)
--    �÷��� �ԷµǴ� �����͸� �˻��Ͽ� ���ǿ� �´� �����͸� �Էµ� �� �ֵ��� �Ѵ�.
--    ����, �÷����� �����Ǵ� �����͸� �˻��Ͽ� ���ǿ� �´� �����ͷ� �����Ǵ� �͸�
--    ����ϴ� ����� �����ϰ� �ȴ�.

-- 2. ���� �� ����
--    �� �÷� ������ ����
--       �÷��� ������Ÿ�� [CONSTRAINT CONSTRAINT��] CHECK(�÷� ����)

--    �� ���̺� ������ ����
--       �÷��� ������Ÿ��,
--       �÷��� ������Ÿ��,
--       CONSTRAINT CONSTRAINT�� CHECK(�÷� ����)

-- �� CK ���� �ǽ�(�� �÷� ������ ����)
-- ���̺� ����
CREATE TABLE TBL_TEST8
( COL1  NUMBER(5)       PRIMARY KEY
, COL2  VARCHAR2(30)
, COL3  NUMBER(3)       CHECK(COL3 BETWEEN 0 AND 100)
);
-- Table TBL_TEST8��(��) �����Ǿ����ϴ�.

-- ������ �Է�
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(1, '������', 100);
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(1, '������', 100);      -- ���� �߻� : ORA-00001: unique constraint (HR.SYS_C007071) violated
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(2, '������', 101);      -- ���� �߻� : ORA-02290: check constraint (HR.SYS_C007070) violated
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(2, '������', -1);       -- ���� �߻� : ORA-02290: check constraint (HR.SYS_C007070) violated
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(2, '������', 80);

-- Ȯ��
SELECT *
FROM TBL_TEST8;
/*
1	������	100
2	������	80
*/

COMMIT;
-- Ŀ�� �Ϸ�.

-- �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST8';
/*
HR	SYS_C007070	TBL_TEST8	C	COL3	COL3 BETWEEN 0 AND 100	
HR	SYS_C007071	TBL_TEST8	P	COL1		
*/

-- �� CK �����ǽ�(�� ���̺� ������ ����) ---------------------------------------
-- ���̺� ����
CREATE TABLE TBL_TEST9
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, COL3  NUMBER(3)
, CONSTRAINT TEST9_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST9_COL3_CK CHECK(COL3 BETWEEN 0 AND 100)
);
-- Table TBL_TEST9��(��) �����Ǿ����ϴ�.

-- ������ �Է�
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(1, '������', 100);
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(1, '������', 100);      -- ���� �߻� : ORA-00001: unique constraint (HR.SYS_C007071) violated
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(2, '������', 101);      -- ���� �߻� : ORA-02290: check constraint (HR.SYS_C007070) violated
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(2, '������', -1);       -- ���� �߻� : ORA-02290: check constraint (HR.SYS_C007070) violated
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(2, '������', 80);

-- Ȯ��
SELECT *
FROM TBL_TEST9;

COMMIT;
-- Ŀ�� �Ϸ�.

-- �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST9';
/*
HR	TEST9_COL3_CK	TBL_TEST9	C	COL3	COL3 BETWEEN 0 AND 100	
HR	TEST9_COL1_PK	TBL_TEST9	P	COL1		
*/

-- �� CK ���� �ǽ�(�� ���̺� ���� ���� �������� �߰�) --------------------------
-- ���̺� �߰�
CREATE TABLE TBL_TEST10
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, COL3  NUMBER(3)
);
-- Table TBL_TEST10��(��) �����Ǿ����ϴ�.

-- �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST10';
-- ��ȸ��� ����

-- �������� �߰�
ALTER TABLE TBL_TEST10
ADD ( CONSTRAINT TEST10_COL1_PK PRIMARY KEY(COL1)
    , CONSTRAINT TEST10_COL3_CK CHECK(COL3 BETWEEN 0 AND 100) );
-- Table TBL_TEST10��(��) ����Ǿ����ϴ�.

-- �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST10';
/*
HR	TEST10_COL1_PK	TBL_TEST10	P	COL1		
HR	TEST10_COL3_CK	TBL_TEST10	C	COL3	COL3 BETWEEN 0 AND 100	
*/


-- ���̺� ����
CREATE TABLE TBL_TESTMEMBER
( SID   NUMBER
, NAME  VARCHAR2(30)
, SSN   CHAR(14)            -- �Է� ���� �� 'YYMMDD-NNNNNNN'
, TEL   VARCHAR2(40)
);
-- Table TBL_TESTMEMBER��(��) �����Ǿ����ϴ�.

-- �� TBL_TESTMEMBER ���̺��� SSN �÷�(�ֹε�Ϲ�ȣ �÷�)����
--    ������ �Է��̳� ���� ��, ������ ��ȿ�� �����͸� �Էµ� �� �ֵ���
--    üũ ���������� �߰��� �� �ֵ��� �Ѵ�.
--    (�� �ֹι�ȣ Ư�� �ڸ��� �Է� ������ �����͸� 1, 2, 3, 4�� �����ϵ��� ó��)
--    ����, SID �÷����� PRIMARY KEY ���������� ������ �� �ֵ��� �Ѵ�.
ALTER TABLE TBL_TESTMEMBER
ADD ( CONSTRAINT TESTMEMBER_SID_PK PRIMARY KEY(SID)
    , CONSTRAINT TESTMEMBER_SSN_CK CHECK(SUBSTR(SSN, 8, 1) BETWEEN 1 AND 4) );
-- Table TBL_TESTMEMBER��(��) ����Ǿ����ϴ�.

-- �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TESTMEMBER';
/*
HR	TESTMEMBER_SID_PK	TBL_TESTMEMBER	P	SID		
HR	TESTMEMBER_SSN_CK	TBL_TESTMEMBER	C	SSN	SUBSTR(SSN, 8, 1) BETWEEN 1 AND 4	
*/

-- ������ �Է� �׽�Ʈ
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(1, '���ҿ�', '941124-2234567', '010-1111-1111');
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(2, '�ֵ���', '950222-1234567', '010-2222-2222');
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(3, '������', '040601-3234567', '010-3333-3333');
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(4, '������', '050215-4234567', '010-4444-4444');

INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)                 -- ���� �߻� : ORA-02290: check constraint (HR.TESTMEMBER_SSN_CK) violated
VALUES(5, '�ڿ���', '980301-5234567', '010-5555-5555');
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)                 -- ���� �߻� : ORA-02290: check constraint (HR.TESTMEMBER_SSN_CK) violated
VALUES(6, '������', '990729-6234567', '010-6666-6666');

-- Ȯ��
SELECT *
FROM TBL_TESTMEMBER;
/*
1	���ҿ�	941124-2234567	010-1111-1111
2	�ֵ���	950222-1234567	010-2222-2222
3	������	040601-3234567	010-3333-3333
4	������	050215-4234567	010-4444-4444
*/

COMMIT;
-- Ŀ�� �Ϸ�.


--------------------------------------------------------------------------------


--���� FOREIGN KEY(FK:F:R) ����--

-- 1. ���� Ű(R) �Ǵ� �ܷ� Ű(FK:F)�� �� ���̺��� ������ �� ������ �����ϰ�
--    ���� �����Ű�µ� ���Ǵ� ���̴�.
--    �� ���̺��� �⺻ Ű ���� �ִ� ����
--    �ٸ� ���̺� �߰��ϸ� ���̺� �� ������ ������ �� �ִ�.
--    �� ��, �� ��° ���̺� �߰��Ǵ� ���� �ܷ�Ű�� �ȴ�.

-- 2. �θ� ���̺�(�����޴� �÷��� ���Ե� ���̺�)�� ���� ������ ��
--    �ڽ� ���̺�(�����ϴ� �÷��� ���Ե� ���̺�)�� �����Ǿ�� �Ѵ�.
--    �� ��, �ڽ� ���̺� FOREIGN KEY ���������� �����ȴ�.

-- 3. ���� �� ����
--    �� �÷� ������ ����
--       �÷��� ������Ÿ�� [CONSTRAINT CONSTRAINT��]
--                          REFERENCES �������̺��(�����÷���)
--                         [ON DELETE CASCADE | ON DELETE SET NULL] �� �߰� �ɼ�

--    �� ���̺� ������ ����
--       �÷��� ������Ÿ��,
--       �÷��� ������Ÿ��,
--       CONSTRAINT CONSTRAINT�� FOREIGN KEY(�÷���)
--                  REFERENCES �������̺��(�����÷���)
--                  [ON DELETE CASCADE | ON DELETE SET NULL]    �� �߰� �ɼ�

-- �� FOREIGN KEY ���������� �����ϴ� �ǽ��� �����ϱ� ���ؼ���
--    �θ� ���̺��� ���� �۾��� ���� �����ؾ� �Ѵ�.
--    �׸��� �� ��, �θ� ���̺��� �ݵ�� PK �Ǵ� UK ����������
--    ������ �÷��� �����ؾ� �Ѵ�.

-- �θ� ���̺� ����
CREATE TABLE TBL_JOBS
( JIKWI_ID      NUMBER
, JIKWI_NAME    VARCHAR2(30)
, CONSTRAINT JOBS_ID_PK PRIMARY KEY(JIKWI_ID)
);
-- Table TBL_JOBS��(��) �����Ǿ����ϴ�.

-- �θ� ���̺� ������ �Է�
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(1, '���');
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(2, '�븮');
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(3, '����');
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(4, '����');
-- 1 �� ��(��) ���ԵǾ����ϴ�. * 4

SELECT *
FROM TBL_JOBS;

COMMIT;
-- Ŀ�� �Ϸ�.

-- �� FK ���� �ǽ�(�� �÷� ������ ����) ----------------------------------------
-- ���̺� ����
CREATE TABLE TBL_EMP1
( SID       NUMBER          PRIMARY KEY
, NAME      VARCHAR2(30)
, JIKWI_ID  NUMBER          REFERENCES TBL_JOBS(JIKWI_ID)
);
-- Table TBL_EMP1��(��) �����Ǿ����ϴ�.
-- �� ���̸� �������� ������ NUMBER�� �ִ밪, CHAR�� 1

-- �������� Ȯ��
SELECT*
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
/*
HR	SYS_C007079	TBL_EMP1	P	SID		
HR	SYS_C007080	TBL_EMP1	R	JIKWI_ID		NO ACTION
*/

-- ������ �Է�
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(1, '���̰�', 1);
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(2, '�ֳ���', 2);
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(3, '������', 3);
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(4, '������', 4);

INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(5, '����', 5);      -- ���� �߻� : ORA-02291: integrity constraint (HR.SYS_C007080) violated - parent key not found
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(5, '����', 1);
INSERT INTO TBL_EMP1(SID, NAME) VALUES(6, '���¹�');

SELECT *
FROM TBL_EMP1;
/*
1	���̰�	1
2	�ֳ���	2
3	������	3
4	������	4
5	����	1
6	���¹�	
*/

COMMIT;
-- Ŀ�� �Ϸ�.

-- �� FK ���� �ǽ�(�� ���̺� ������ ����) --------------------------------------
-- ���̺� ����
CREATE TABLE TBL_EMP2
( SID       NUMBER
, NAME      VARCHAR2(30)
, JIKWI_ID  NUMBER
, CONSTRAINT EMP2_SID_PK PRIMARY KEY(SID)
, CONSTRAINT EMP2_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
             REFERENCES TBL_JOBS(JIKWI_ID)
);
-- Table TBL_EMP2��(��) �����Ǿ����ϴ�.

-- �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP2';
/*
HR	EMP2_SID_PK	        TBL_EMP2	P	SID		
HR	EMP2_JIKWI_ID_FK	TBL_EMP2	R	JIKWI_ID		NO ACTION
*/

-- �� FK ���� �ǽ�(�� ���̺� ���� ���� �������� �߰�) --------------------------
-- ���̺� ����
CREATE TABLE TBL_EMP3
( SID       NUMBER
, NAME      VARCHAR2(30)
, JIKWI_ID  NUMBER
);
-- Table TBL_EMP3��(��) �����Ǿ����ϴ�.

-- �������� �߰�
ALTER TABLE TBL_EMP3
ADD ( CONSTRAINT EMP3_SID_PK PRIMARY KEY(SID)
    , CONSTRAINT EMP3_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
                 REFERENCES TBL_JOBS(JIKWI_ID) );
-- Table TBL_EMP3��(��) ����Ǿ����ϴ�.

-- �������� ����
ALTER TABLE TBL_EMP3
DROP CONSTRAINT EMP3_JIKWI_ID_FK;
-- Table TBL_EMP3��(��) ����Ǿ����ϴ�.

-- �������� ��ȸ
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP3';
-- HR	EMP3_SID_PK	TBL_EMP3	P	SID		

-- �ٽ� �������� �߰�
ALTER TABLE TBL_EMP3
ADD CONSTRAINT EMP3_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
               REFERENCES TBL_JOBS(JIKWI_ID);
-- Table TBL_EMP3��(��) ����Ǿ����ϴ�.

-- �ٽ� �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP3';
/*
HR	EMP3_SID_PK	TBL_EMP3	P	SID		
HR	EMP3_JIKWI_ID_FK	TBL_EMP3	R	JIKWI_ID		NO ACTION
*/


-- 4. FOREIGN KEY ���� �� ���ǻ���
--    �����ϰ��� �ϴ� �θ� ���̺��� ���� �����ؾ� �Ѵ�.
--    �����ϰ��� �ϴ� �÷��� PRIMARY KEY �Ǵ� UNIQUE ���������� �����Ǿ� �־�� �Ѵ�.
--    ���̺� ���̿� PRIMARY KEY�� FOREIGN KEY�� ���ǵǾ� ������
--    PRIMARY KEY ���������� ������ ������ ���� ��
--    FOREIGN KEY �÷��� �� ���� �ԷµǾ� �ִ� ��� �������� �ʴ´�.
--    (��, �ڽ� ���̺� �����ϴ� ���ڵ尡 ������ ���
--    �θ� ���̺��� �����޴� �ش� ���ڵ�� ������ �Ұ����ϴ�.)

--    ��, FK ���� �������� ��ON DELETE CASCADE���� ��ON DELETE SET NULL�� �ɼ���
--    ����Ͽ� ������ ��쿡�� ������ �����ϴ�.
--    ����, �θ� ���̺��� �����ϱ� ���ؼ��� �ڽ� ���̺��� ���� �����ؾ� �Ѵ�.

-- �θ� ���̺�
SELECT *
FROM TBL_JOBS;
/*
1	���
2	�븮
3	����
4	����
*/

-- �ڽ� ���̺�
SELECT *
FROM TBL_EMP1;
/*
1	���̰�	1
2	�ֳ���	2
3	������	3
4	������	4
5	����	1
6	���¹�	
*/

-- �θ� ���̺� ���� �õ�
DROP TABLE TBL_JOBS;
-- ���� �߻� : ORA-02449: unique/primary keys in table referenced by foreign keys

-- �θ� ���̺��� ���� ���� ���� �õ�
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 4;
-- ���� �߻� : ORA-02292: integrity constraint (HR.SYS_C007080) violated - child record found

-- ������ ������ ������ ������� ����
UPDATE TBL_EMP1
SET JIKWI_ID = 1
WHERE SID = 4;
-- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.

SELECT *
FROM TBL_EMP1;
/*
1	���̰�	1
2	�ֳ���	2
3	������	3
4	������	1
5	����	1
6	���¹�	
*/

COMMIT;
-- Ŀ�� �Ϸ�.

-- �� �θ� ���̺�(TBL_JOBS)�� ���� �����͸� �����ϰ� �ִ�
--    �ڽ� ���̺�(TBL_EMP1)�� �����Ͱ� �������� �ʴ� ��Ȳ!

-- ���� ���� ��Ȳ���� �θ� ���̺�(TBL_JOBS)�� ���� ������ ����
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 4;
-- 1 �� ��(��) �����Ǿ����ϴ�.

SELECT *
FROM TBL_JOBS;
/*
1	���
2	�븮
3	����
*/

COMMIT;
-- Ŀ�� �Ϸ�.

-- �θ� ���̺�(TBL_JOBS)�� ��� ������ ����
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 1;
-- ���� �߻� : ORA-02292: integrity constraint (HR.SYS_C007080) violated - child record found

-- �θ� ���̺��� �����͸� �����Ӱ�? �����ϱ� ���ؼ���
-- ��ON DELETE CASCADE�� �ɼ� ������ �ʿ��ϴ�.

-- �� TBL_EMP1 ���̺�(�ڽ� ���̺�)���� FK ���������� ������ ��
--    CASCADE �ɼ��� �����Ͽ� �ٽ� FK ���������� �����Ѵ�.

-- �������� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
/*
HR	SYS_C007079	TBL_EMP1	P	SID		
HR	SYS_C007080	TBL_EMP1	R	JIKWI_ID		NO ACTION   ��������
*/

-- �������� ����
ALTER TABLE TBL_EMP1
DROP CONSTRAINT SYS_C007080;
-- Table TBL_EMP1��(��) ����Ǿ����ϴ�.

-- �������� ���� ���� �ٽ� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
-- HR	SYS_C007079	TBL_EMP1	P	SID		

-- ��ON DELETE CASCADE�� �ɼ��� ���Ե� �������� �������� �ٽ� ����
ALTER TABLE TBL_EMP1
ADD CONSTRAINT EMP1_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
               REFERENCES TBL_JOBS(JIKWI_ID)
               ON DELETE CASCADE;
-- Table TBL_EMP1��(��) ����Ǿ����ϴ�.

-- �������� ���� ���� �ٽ� Ȯ��
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
/*
HR	SYS_C007079	TBL_EMP1	P	SID		
HR	EMP1_JIKWI_ID_FK	TBL_EMP1	R	JIKWI_ID		CASCADE
*/

-- �� CASCADE �ɼ��� ������ �Ŀ���
--    �����ް� �ִ� �θ� ���̺��� �����͸�
--    �������� �����Ӱ� �����ϴ� ���� �����ϴ�.
--    ��, �θ� ���̺��� �����Ͱ� ������ ���
--    �̸� �����ϰ� �־��� �ڽ� ���̺��� �����͵� ��� �Բ� �����ȴ�.

-- �θ� ���̺�
SELECT *
FROM TBL_JOBS;
/*
1	���
2	�븮
3	����
*/

-- �ڽ� ���̺�
SELECT *
FROM TBL_EMP1;
/*
1	���̰�	1
2	�ֳ���	2
3	������	3
4	������	1
5	����	1
6	���¹�	
*/

-- �θ� ���̺�(TBL_JOBS)���� ���� ������ ����
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 3;
-- 1 �� ��(��) �����Ǿ����ϴ�.

-- �ڽ� ���̺�(TBL_EMP1) ������ Ȯ��
SELECT *
FROM TBL_EMP1;
/*
1	���̰�	1
2	�ֳ���	2
4	������	1
5	����	1
6	���¹�	

�� ������ ������ �����Ͱ� ����
*/ 

-- �θ� ���̺�(TBL_JOBS)���� ��� ������ ����
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 1;
-- 1 �� ��(��) �����Ǿ����ϴ�.

-- �ڽ� ���̺�(TBL_EMP1) ������ Ȯ��
SELECT *
FROM TBL_EMP1;
/*
2	�ֳ���	2
6	���¹�	

�� ��� �����Ͱ� ����
*/ 


DROP TABLE TBL_EMP2;
-- Table TBL_EMP2��(��) �����Ǿ����ϴ�.

DROP TABLE TBL_EMP3;
-- Table TBL_EMP3��(��) �����Ǿ����ϴ�.

DROP TBL_JOBS;
-- ���� �߻� : ORA-00950: invalid DROP option

DROP TABLE TBL_EMP1;
-- Table TBL_EMP1��(��) �����Ǿ����ϴ�.

DROP TABLE TBL_JOBS;
-- Table TBL_JOBS��(��) �����Ǿ����ϴ�.







