-- �� ���ӵ� ����� Ȯ��
SELECT USER
FROM DUAL;
-- KOHYEONSOO


-- �� ���̺� ���� (���̺�� : TBL_ORAUSERTEST) / ���� ���� �׽�Ʈ
CREATE TABLE TBL_ORAUSERTEST
( NO    NUMBER(10)
, NAME  VARCHAR2(30)
);
-- �����߻�
-- �� ORA-00907: missing right parenthesis
-- ���� ������ �̸� ������ CREATE SESSION ���Ѹ� ���� ������
-- ���̺��� ������ �� �ִ� ������ ���� ���� ���� �����̴�.
-- �׷��Ƿ� �����ڷκ��� ���̺��� ������ �� �ִ� ���� �ο��� �ʿ�


-- �� SYS�κ��� CREATE TABLE ������ �ο����� ��
CREATE TABLE TBL_ORAUSERTEST
( NO    NUMBER(10)
, NAME  VARCHAR2(30)
);
-- ���� �߻�
-- �� ORA-00907: missing right parenthesis
-- ���̺��� ������ �� �ִ� ������ �ο����� ��Ȳ������
-- ���� �̸� ������ �⺻ ���̺����̽�(DEFAULT TABLESPACE)�� TBS_EDUA�̸�,
-- �� ������ ���� �Ҵ緮�� �ο����� ���� �����̴�.
-- �׷��Ƿ� �� ���̺����̽��� ����� ������ ���ٴ� �����޽����� ����Ŭ�� ����


-- �� ���̺����̽��� ���� �Ҵ緮�� �ο����� ��
CREATE TABLE TBL_ORAUSERTEST
( NO    NUMBER(10)
, NAME  VARCHAR2(30)
);
-- Table TBL_ORAUSERTEST��(��) �����Ǿ����ϴ�.

-- �� �ڽſ��� �ο��� �Ҵ緮 ��ȸ
SELECT *
FROM USER_TS_QUOTAS;
-- TBS_EDUA	65536	-1	8	-1	NO

-- �� ������ ���̺�(TBL_ORAUSERTEST)�� � ���̺����̽��� ����Ǿ� �ִ��� ��ȸ
SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES;
-- TBL_ORAUSERTEST	TBS_EDUA

























