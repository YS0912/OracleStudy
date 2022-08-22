SELECT USER
FROM DUAL;
-- SCOTT

--�� EMP ���̺��� �������
--   �Ի��� ����� ���� ���� ������ ����
--   �Ի����� �ο����� ��ȸ�� �� �ֵ��� �������� �����Ѵ�,
/*
------------ ---------------
 �Ի���       �ο� ��
------------ ---------------
 1981-02            2
 1981-09            2
 1987-07            2
 ------------ ---------------
*/
SELECT T1.�Ի���, T1.�ο���
FROM
(
    SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "�Ի���"
         , COUNT(*) "�ο���"
    FROM EMP
    GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM')
) T1
WHERE T1.�ο��� = ( SELECT MAX(T2.�ο���)
                    FROM
                    (
                        SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "�Ի���"
                             , COUNT(*) "�ο���"
                        FROM EMP
                        GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM')
                    ) T2
                   )
ORDER BY 1;
/*
1981-02	2
1981-09	2
1981-12	2
1987-07	2
*/


--------------------------------------------------------------------------------


--���� ROW_NUMBER ����--

SELECT ENAME "�����", SAL "�޿�", HIREDATE "�Ի���"
FROM EMP;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
-- Session��(��) ����Ǿ����ϴ�.

SELECT ROW_NUMBER() OVER(ORDER BY SAL DESC) "�׽�Ʈ"
     , ENAME "�����", SAL "�޿�", HIREDATE "�Ի���"
FROM EMP;
/*
1	KING	5000	    1981-11-17
2	FORD	3000	    1981-12-03
3	SCOTT	3000    	1987-07-13
4	JONES	2975	1981-04-02
5	BLAKE	2850    	1981-05-01
6	CLARK	2450	    1981-06-09
7	ALLEN	1600	    1981-02-20
8	TURNER	1500	    1981-09-08
9	MILLER	1300	    1982-01-23
10	WARD	1250	    1981-02-22
11	MARTIN	1250	    1981-09-28
12	ADAMS	1100	    1987-07-13
13	JAMES	 950	    1981-12-03
14	SMITH	 800	    1980-12-17
*/

SELECT ROW_NUMBER() OVER(ORDER BY ENAME) "�׽�Ʈ"
     , ENAME "�����", SAL "�޿�", HIREDATE "�Ի���"
FROM EMP;
/*
1	ADAMS	1100    	1987-07-13
2	ALLEN	1600    	1981-02-20
3	BLAKE	2850	    1981-05-01
4	CLARK	2450	    1981-06-09
5	FORD	3000	    1981-12-03
6	JAMES	 950    	1981-12-03
7	JONES	2975	1981-04-02
8	KING	5000	    1981-11-17
9	MARTIN	1250    	1981-09-28
10	MILLER	1300	    1982-01-23
11	SCOTT	3000	    1987-07-13
12	SMITH	 800    	1980-12-17
13	TURNER	1500    	1981-09-08
14	WARD	1250    	1981-02-22
*/

SELECT ROW_NUMBER() OVER(ORDER BY ENAME) "�׽�Ʈ"
     , ENAME "�����", SAL "�޿�", HIREDATE "�Ի���"
FROM EMP
WHERE DEPTNO = 20
ORDER BY ENAME;
/*
1	ADAMS	1100    	1987-07-13
2	FORD	3000	    1981-12-03
3	JONES	2975	1981-04-02
4	SCOTT	3000	    1987-07-13
5	SMITH	 800	    1980-12-17
*/

-- �� SELECT�� ó�� ������ ���� WHERE ���ǹ��� �켱�� �Ǳ� ������,
--    ROW_NUMBER()�� ���׹������� ������ �ʴ´�.

-- �� �Խ����� �Խù� ��ȣ�� SEQUENCE�� INDENTITY�� ����ϰ� �Ǹ� �Խù��� �������� ���,
--    ������ �Խù��� �ڸ��� ���� ��ȣ�� ���� �Խù��� ��ϵǴ� ��Ȳ�� �߻��ϰ� �ȴ�.
--    �̴� ���ȼ� �����̳� �̰��� �ٶ������� ���� ������ �� �ֱ� ������
--    ROW_NUMBER()�� ����� ����� �� �� �ִ�.
--    ������ �������� ����� ������ SEQUENCE�� IDENTITY�� ���������,
--    �ܼ��� �Խù��� ���ȭ�Ͽ� ����ڿ��� ����Ʈ �������� ������ ������
--    ������� �ʴ� ���� �ٶ����� �� �ִ�.


-- �� SEQUENCE(������: �ֹ���ȣ)
--    �� �������� �ǹ� : �� (�Ϸ���) �������� ��ǵ� �� (���, �ൿ ����) ����

CREATE SEQUENCE SEQ_BOARD       -- �⺻���� ������ ���� ����
START WITH 1                    -- ���۰�
INCREMENT BY 1                  -- ������
NOMAXVALUE                      -- �ִ밪
NOCACHE;                        -- ĳ�� ��� �� ��(����)
-- Sequence SEQ_BOARD��(��) �����Ǿ����ϴ�.


-- �ǽ� ���̺� ����
CREATE TABLE TBL_BOARD
( NO          NUMBER                  -- TBL_BOARD ���̺� ���� ���� �� �Խ��� ���̺�
, TITLE       VARCHAR2(50)            -- �Խù� ��ȣ
, CONTENTS    VARCHAR2(1000)          -- �Խù� ����
, NAME        VARCHAR2(20)            -- �Խù� ����
, PW          VARCHAR2(20)            -- �Խù� �н�����
, CREATED     DATE DEFAULT SYSDATE    -- �Խù� �ۼ���
);
-- Table TBL_BOARD��(��) �����Ǿ����ϴ�.

-- ������ �Է�
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '��~ �ڰ� �ʹ�', '10�и� �ڰ� �ðԿ�', '������', 'java002$', DEFAULT);
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '��~ ����', '������ ���� ����־��', '���ҿ�', 'java002$', DEFAULT);
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '���� �ʹ�', '�����̰� �ʹ� ���� �;��', '������', 'java002$', DEFAULT);
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '����Ŀ�', '��ħ�ε� ����Ŀ�', '������', 'java002$', DEFAULT);
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '�ʹ� �־��', '������ ���������� �ʹ� �־��', '���¹�', 'java002$', DEFAULT);
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '���ڶ��', '���� ���� ���ڶ��', '������', 'java002$', DEFAULT);
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '���ο�', '���� ���� ���� ���ڶ��', '������', 'java002$', DEFAULT);
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '��´��', '���� ����� ��´��', '�ڿ���', 'java002$', DEFAULT);
-- 1 �� ��(��) ���ԵǾ����ϴ�.


-- Ȯ��
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
-- Session��(��) ����Ǿ����ϴ�.

SELECT *
FROM TBL_BOARD;
/*
1	��~ �ڰ� �ʹ�	10�и� �ڰ� �ðԿ�	            ������	java002$	    2022-08-22 10:18:32
2	��~ ����	    ������ ���� ����־��	        ���ҿ�	java002$	    2022-08-22 10:18:44
3	���� �ʹ�	    �����̰� �ʹ� ���� �;��	    ������	java002$	    2022-08-22 10:18:48
4	����Ŀ�	    ��ħ�ε� ����Ŀ�	            ������	java002$    	2022-08-22 10:19:36
5	�ʹ� �־��	    ������ ���������� �ʹ� �־��	���¹�	java002$	    2022-08-22 10:19:42
6	���ڶ��	    ���� ���� ���ڶ��	            ������	java002$	    2022-08-22 10:19:47
7	���ο�	        ���� ���� ���� ���ڶ��	        ������	java002$	    2022-08-22 10:19:51
8	��´��	    ���� ����� ��´��	        �ڿ���	java002$	    2022-08-22 10:20:11
*/

-- �Խù� ����
DELETE
FROM TBL_BOARD
WHERE NO = 1;
-- 1 �� ��(��) �����Ǿ����ϴ�.

DELETE
FROM TBL_BOARD
WHERE NO = 6;
-- 1 �� ��(��) �����Ǿ����ϴ�.

DELETE
FROM TBL_BOARD
WHERE NO = 8;
-- 1 �� ��(��) �����Ǿ����ϴ�.

-- Ȯ��
SELECT *
FROM TBL_BOARD;
/*
2	��~ ����	������ ���� ����־��	        ���ҿ�	java002$	    2022-08-22 10:18:44
3	���� �ʹ�	�����̰� �ʹ� ���� �;��	    ������	java002$	    2022-08-22 10:18:48
4	����Ŀ�	��ħ�ε� ����Ŀ�	            ������	java002$	    2022-08-22 10:19:36
5	�ʹ� �־��	������ ���������� �ʹ� �־��	���¹�	java002$	    2022-08-22 10:19:42
7	���ο�	    ���� ���� ���� ���ڶ��	        ������	java002$	    2022-08-22 10:19:51
*/


-- �Խù� �ۼ�
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '�����սô�', '�� ���� ������ �ʾƿ�', '������', 'java002$', DEFAULT);
-- 1 �� ��(��) ���ԵǾ����ϴ�.

-- �Խù� ����
DELETE
FROM TBL_BOARD
WHERE NO = 7;
-- 1 �� ��(��) �����Ǿ����ϴ�.


-- Ȯ��
SELECT *
FROM TBL_BOARD;
/*
2	��~ ����	������ ���� ����־��	        ���ҿ�	java002$    	2022-08-22 10:18:44
3	���� �ʹ�	�����̰� �ʹ� ���� �;��	    ������	java002$	    2022-08-22 10:18:48
4	����Ŀ�	��ħ�ε� ����Ŀ�	            ������	java002$    	2022-08-22 10:19:36
5	�ʹ� �־��	������ ���������� �ʹ� �־��	���¹�	java002$	    2022-08-22 10:19:42
9	�����սô�	�� ���� ������ �ʾƿ�	        ������	java002$    	2022-08-22 10:35:25
*/


-- Ŀ��
COMMIT;
-- Ŀ�� �Ϸ�.


-- �� �Խ����� �Խù� ����Ʈ ��ȸ
SELECT NO "�۹�ȣ", TITLE "����", NAME "�ۼ���", CREATED "�ۼ���"
FROM TBL_BOARD;
/*
2	��~ ����	���ҿ�	2022-08-22 10:18:44
3	���� �ʹ�	������	2022-08-22 10:18:48
4	����Ŀ�	������	2022-08-22 10:19:36
5	�ʹ� �־��	���¹�	2022-08-22 10:19:42
9	�����սô�	������	2022-08-22 10:35:25
*/

SELECT ROW_NUMBER() OVER(ORDER BY CREATED) "�۹�ȣ"
     , TITLE "����", NAME "�ۼ���", CREATED "�ۼ���"
FROM TBL_BOARD;
/*
1	��~ ����	���ҿ�	2022-08-22 10:18:44
2	���� �ʹ�	������	2022-08-22 10:18:48
3	����Ŀ�	������	2022-08-22 10:19:36
4	�ʹ� �־��	���¹�	2022-08-22 10:19:42
5	�����սô�	������	2022-08-22 10:35:25
*/

SELECT ROW_NUMBER() OVER(ORDER BY CREATED) "�۹�ȣ"
     , TITLE "����", NAME "�ۼ���", CREATED "�ۼ���"
FROM TBL_BOARD
ORDER BY 4 DESC;
/*
5	�����սô�	������	2022-08-22 10:35:25
4	�ʹ� �־��	���¹�	2022-08-22 10:19:42
3	����Ŀ�	������	2022-08-22 10:19:36
2	���� �ʹ�	������	2022-08-22 10:18:48
1	��~ ����	���ҿ�	2022-08-22 10:18:44
*/


--------------------------------------------------------------------------------


--���� JOIN(����) ����--

-- 1. SQL 1992 CODE

-- �� CROSS JOIN (���� ��)
--    �� ���̺��� ������ ��� ����� �� (���п��� ���ϴ� ��ī��Ʈ �� CATERSIAN PRODUCT)
SELECT *
FROM EMP, DEPT;


-- �� EQUI JOIN (���� ��)
--    ���� ��Ȯ�ϰ� ��ġ�ϴ� �͵鳢�� �����Ͽ� ���ս�Ű�� ���� ���
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;

SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;


-- �� NON EQUI JOIN
--    ���� �ȿ� ������ �͵鳢�� �����Ű�� ���� ���
SELECT *
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;


-- �� EQUI JOIN �� (+)�� Ȱ���� ���� ���
SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO;
-- �� 14���� �����Ͱ� ��ȸ�� ��Ȳ
-- ��, �μ���ȣ�� ���� ���� �����(5)�� ��� ����
-- ����, �Ҽ� ����� ���� ���� �μ�(1) ���� ����

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO(+);
-- �� 19���� ������ ��ȸ
-- �μ���ȣ�� ���� ���� ����� ��� ��ȸ
-- �Ҽ� ����� ���� ���� �μ�(1) ����     ----------------- (+)

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;
-- �� 15���� ������ ��ȸ
-- �μ���ȣ�� ���� ���� �����(5) ����    ----------------- (+)
-- �Ҽ� ����� ���� ���� �μ� ��ȸ

-- �� (+)�� ���� �� ���̺��� �����͸� ��� �޸𸮿� ������ ��                      �� (����)
--    (+)�� �ִ� �� ���̺��� �����͸� �ϳ��ϳ� Ȯ���Ͽ� ���ս�Ű�� ���·�          �� �߰�(÷��)
--    JOIN�� �̷������.

--    �̿� ���� ������
      /*
      SELECT *
      FROM TBL_EMP E, TBL_DEPT D
      WHERE E.DEPTNO(+) = D.DEPTNO(+);
      */
--    �̷� ������ JOIN�� �������� �ʴ´�.


-- 2. SQL 1999 CODE     �� ��JOIN�� Ű���� ���� : JOIN(����)�� ���� ���
--                      �� ��ON�� Ű���� ���� : ���� ������ WHERE ��� ON

-- �� CROSS JOIN
SELECT *
FROM EMP CROSS JOIN DEPT;


-- �� INNER JOIN (= EQUI JOIN)
SELECT *
FROM EMP INNER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO;

SELECT *
FROM EMP E INNER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
-- INNER JOIN���� INNER�� ���� ����


-- �� OUTER JOIN (= EQUI JOIN(+))
SELECT *
FROM TBL_EMP E LEFT OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E RIGHT OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E FULL OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

-- OUTER JOIN���� OUTER�� ���� ����
-- �� �������� ����!


--------------------------------------------------------------------------------
SELECT *
FROM TBL_EMP E JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO
AND E.JOB = 'CLERK';
-- �� �̷��� ������� �������� �����ص� ��ȸ ����� ��� �� ������ ����.

SELECT *
FROM TBL_EMP E JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.JOB = 'CLERK';
-- �� ������ �̿� ���� �����Ͽ� ��ȸ�ϴ� ���� �����Ѵ�.
--------------------------------------------------------------------------------


-- �� EMP ���̺�� DEPT ���̺��� �������
--    ������ MANAGER�� CLERK�� ����鸸
--    �μ���ȣ, �μ���, �����, ������, �޿� �׸��� ��ȸ�Ѵ�.
--    DEPTNO    DNAME   ENAME   JOB     SAL
--    E, D      D       E       E       E

/* �� ������ �ؼ�

SELECT DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;
-- ���� �߻� : ORA-00918: column ambiguously defined
-- �� �� ���̺� �� �ߺ��Ǵ� �÷��� ���� �Ҽ� ���̺��� �������� �Ѵ�.
--    �� ���, �θ� ���̺��� �÷��� ������ �� �ֵ��� ó���ؾ� �Ѵ�.
-- �� �θ� ���̺��� � ���� � ���� �����ϰ� �ִ��ķ� �����ȴ�.
--    ��, �ߺ��Ǵ� �÷��� �������� �����Ͱ� ���� ��ȸ�Ǵ� ���� �θ� ���̺� (DEPT)

-- �� ����Ŭ�� JOIN�� �� ���̺��� �÷��� ã�� ��,
--    �̹� �ռ� ���̺��� �÷��� ã�Ҵٰ� �ϴ��� ������ �ʰ� ��� ��ȸ�Ѵ�.
-- �� �� ���̺� ��� ���ԵǾ� �ִ� �ߺ��� �÷��� �ƴϴ���
--    �÷��� �Ҽ� ���̺��� ����� �� �� �ֵ��� �����Ѵ�.

*/

SELECT D.DEPTNO "�μ���ȣ", D.DNAME "�μ���", E.ENAME "�����", E.JOB "������", E.SAL "�޿�"
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.JOB IN ('MANAGER', 'CLERK');
/*
10	ACCOUNTING	CLARK	MANAGER	    2450
10	ACCOUNTING	MILLER	CLERK	    1300
20	RESEARCH	ADAMS	CLERK	    1100
20	RESEARCH	JONES	MANAGER	    2975
20	RESEARCH	SMITH	CLERK	     800
30	SALES	    BLAKE	MANAGER	    2850
30	SALES	    JAMES	CLERK	     950
*/


--------------------------------------------------------------------------------


-- �� SELF JOIN (�ڱ� ����)

-- EMP ���̺��� �����͸� ������ ���� ��ȸ�� �� �ֵ��� �������� �����Ѵ�.
-------------------------------------------------------------------
-- �����ȣ  �����  ������  �����ڹ�ȣ  �����ڸ�  ������������
-------------------------------------------------------------------
-- 7369      SMITH   CLERK   7902        FORD       ANALYST

SELECT E1.EMPNO "�����ȣ", E1.ENAME "�����", E1.JOB "������", E1.MGR "�����ڹ�ȣ", E2.ENAME "�����ڸ�", E2.JOB "������������"
FROM EMP E1 LEFT JOIN EMP E2
ON E1.MGR = E2.EMPNO;























