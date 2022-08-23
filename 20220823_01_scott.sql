SELECT USER
FROM DUAL;
-- SCOTT


-- ������ Ǯ��
-- �� ���ݱ��� �ֹ� ���� �����͸� ����
--    ��ǰ�� �� �ֹ����� ��ȸ�� �� �ִ� �������� �����Ѵ�.
SELECT T.JECODE "��ǰ�ڵ�", SUM(T.JUSU) "�ֹ�����"
FROM
(
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JECODE, JUSU
    FROM TBL_JUMUN
) T
GROUP BY T.JECODE;
/*
����Ĩ	30
������	20
ġ�佺	20
������	70
�����	10
���Ͻ�	20
���̽�	40
��īĨ	20
����Ĩ	20
������	30
��ǹ�	20
������	110
������	30
���ڱ�	40
Ȩ����	40
������	10
�Ҹ���	10
����ƽ	40
*/


-- �� INTERSCET / MINUS (�����հ� ������)

-- TBL_JUMUNBACKUP ���̺�� TBL_JUMUN ���̺���
-- ��ǰ�ڵ�� �ֹ������� ���� �Ȱ��� �ุ �����ϰ��� �Ѵ�.
SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
INTERSECT
SELECT JECODE, JUSU
FROM TBL_JUMUN;
/*
���ڱ�	20
������	30
Ȩ����	10
*/
-- �� ������ ������ ���

SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
MINUS
SELECT JECODE, JUSU
FROM TBL_JUMUN;
/*
������	20
����Ĩ	20
������	10
������	10
��ǹ�	20
�����	10
����Ĩ	20
������	20
������	10
�Ҹ���	10
ġ�佺	20
����ƽ	10
����ƽ	20
��īĨ	20
*/
-- �� �������� ������ ������ ���


-- �� TBL_JUMUNBACKUP ���̺�� TBL_JUMUN ���̺��� �������
--    ��ǰ�ڵ�� �ֹ����� ���� �Ȱ��� ���� ������
--    �ֹ���ȣ, ��ǰ�ڵ�, �ֹ���, �ֹ����� �׸����� ��ȸ�Ѵ�.

-- ���ش� Ǯ��
SELECT T1.JUNO "�ֹ���ȣ", T2.JECODE "��ǰ�ڵ�", T2.JUSU "�ֹ���", T1.JUDAY "�ֹ�����"
FROM
(
    SELECT *
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT *
    FROM TBL_JUMUN
) T1
RIGHT JOIN
(
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
    INTERSECT
    SELECT JECODE, JUSU
    FROM TBL_JUMUN
) T2
ON T1.JECODE = T2.JECODE
WHERE T1.JUSU = T2.JUSU;

-- ���� SELECT�� �ȿ� SELECT�� �������� �ϴٰ� ����...
-- �� �̷��� ó���ϸ� �������� ��µǾ�� �ϴ� ������ �������� ��µǾ�
--    ����Ŭ�� ������� ���ϴ� �� ��
--    ���� �߻� : ORA-01427: single-row subquery returns more than one row

-- ������ Ǯ�� -----------------------------------------------------------------

-- �����
-- ���ش� Ǯ�̿� ����

-- �����
/*
SELECT T.*
FROM
(
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUN
) T
WHERE T.JECODE IN ('���ڱ�', '������', 'Ȩ����')
  AND T.JUSU IN (20, 30, 10);
-- �� ��ǰ��� �ֹ������� ��Ī���� �ʾ� ������10�� �Բ� ��µǴ� ���� �߻�
*/

SELECT T.*
FROM
(
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUN
) T
WHERE CONCAT(T.JECODE, T.JUSU) IN ('���ڱ�20', '������30', 'Ȩ����10');

--                                 ����

SELECT T.*
FROM
(
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUN
) T
WHERE CONCAT(T.JECODE, T.JUSU) IN (SELECT CONCAT(JECODE, JUSU)
                                   FROM TBL_JUMUNBACKUP
                                   INTERSECT
                                   SELECT CONCAT(JECODE, JUSU)
                                   FROM TBL_JUMUN);


--------------------------------------------------------------------------------


-- �� JOIN + (NATURAL JOIN)

SELECT D.DEPTNO, D.DNAME, E.ENAME, E.SAL
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
/*
10	ACCOUNTING	CLARK	2450
10	ACCOUNTING	KING	5000
10	ACCOUNTING	MILLER	1300
20	RESEARCH	JONES	2975
20	RESEARCH	FORD	3000
20	RESEARCH	ADAMS	1100
20	RESEARCH	SMITH	 800
20	RESEARCH	SCOTT	3000
30	SALES	    WARD	1250
30	SALES	    TURNER	1500
30	SALES	    ALLEN	1600
30	SALES	    JAMES	 950
30	SALES	    BLAKE	2850
30	SALES	    MARTIN	1250
*/

SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP E JOIN DEPT D;
-- ���� �߻� : ORA-00905: missing keyword

SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP E NATURAL JOIN DEPT D;
/*
10	ACCOUNTING	CLARK	2450
10	ACCOUNTING	KING	5000
10	ACCOUNTING	MILLER	1300
20	RESEARCH	JONES	2975
20	RESEARCH	FORD	3000
20	RESEARCH	ADAMS	1100
20	RESEARCH	SMITH	 800
20	RESEARCH	SCOTT	3000
30	SALES	    WARD	1250
30	SALES	    TURNER	1500
30	SALES	    ALLEN	1600
30	SALES	    JAMES	 950
30	SALES	    BLAKE	2850
30	SALES	    MARTIN	1250
*/
-- �� ����Ŭ�� �� ������ �����, ���� ���̺� �� �ʿ��� ��Ҹ� ��� ����ش�.
--    (���ҽ� �Ҹ� ũ��)


SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP E JOIN DEPT D
USING(DEPTNO);
/*
10	ACCOUNTING	CLARK	2450
10	ACCOUNTING	KING	5000
10	ACCOUNTING	MILLER	1300
20	RESEARCH	JONES	2975
20	RESEARCH	FORD	3000
20	RESEARCH	ADAMS	1100
20	RESEARCH	SMITH	 800
20	RESEARCH	SCOTT	3000
30	SALES	    WARD	1250
30	SALES	    TURNER	1500
30	SALES	    ALLEN	1600
30	SALES	    JAMES	 950
30	SALES	    BLAKE	2850
30	SALES	    MARTIN	1250
*/


--------------------------------------------------------------------------------


-- �� TBL_EMP ���̺��� �޿��� ���� ���� �����
--    �����ȣ, �����, ������, �޿� �׸��� ��ȸ�ϴ� �������� �ۼ��Ѵ�.
SELECT EMPNO "�����ȣ", ENAME "�����", JOB "������", SAL "�޿�"
FROM TBL_EMP
WHERE SAL IN (SELECT MAX(SAL)
              FROM TBL_EMP);
-- 7839	KING	PRESIDENT	5000

-- ��=ANY��
SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL >=ANY (800, 1600, 1250, 2975, 1250, 2850, 2450, 3000, 5000, 1500, 1100, 950, 3000, 1300, 1500, 2000, 1700, 2500, 1000);
-- �� ������ ���� �Ͱ� �ٸ� ����!

-- �� ��=ALL��
SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL >=ALL (800, 1600, 1250, 2975, 1250, 2850, 2450, 3000, 5000, 1500, 1100, 950, 3000, 1300, 1500, 2000, 1700, 2500, 1000);

SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL >=ALL (SELECT SAL
                 FROM TBL_EMP);
-- �� ��� �޿����� ũ�ų� ���ƾ� �ϱ� ������ ���� ū �� �ϳ��� ���´�.


-- �� TBL_EMP ���̺��� 20�� �μ��� �ٹ��ϴ� ����� ��
--    �޿��� ���� ���� �����
--    �����ȣ, �����, ������, �޿� �׸��� ��ȸ�ϴ� �������� �����Ѵ�.
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM TBL_EMP
WHERE DEPTNO = 20
  AND SAL >= ALL (SELECT SAL
                  FROM TBL_EMP
                  WHERE DEPTNO = 20);
/*
7902	    FORD	ANALYST	3000	20
7788	SCOTT	ANALYST	3000	20
*/


-- �� TBL_EMP ���̺��� ����(Ŀ�̼�, COMM)�� ���� ���� �����
--    �����ȣ, �����, �μ���ȣ, ������, Ŀ�̼� �׸��� ��ȸ�Ѵ�.
SELECT EMPNO, ENAME, DEPTNO, JOB, NVL(COMM, 0)
FROM TBL_EMP
WHERE COMM >=ALL (SELECT NVL(COMM, 0)
                  FROM TBL_EMP);

SELECT EMPNO, ENAME, DEPTNO, JOB, NVL(COMM, 0)
FROM TBL_EMP
WHERE COMM >=ALL (SELECT MAX(COMM)
                  FROM TBL_EMP);
-- �� MAX() �Լ��� NULL ���� �����ϰ� �����ϱ� ������ NVL �ʿ� X

SELECT EMPNO, ENAME, DEPTNO, JOB, NVL(COMM, 0)
FROM TBL_EMP
WHERE COMM >=ALL (SELECT COMM
                  FROM TBL_EMP
                  WHERE COMM IS NOT NULL);


-- �� DISTINCT()
--    �ߺ� ��(���ڵ�)�� �����ϴ� �Լ�

-- �� TBL_EMP ���̺��� �����ڷ� ��ϵ� �����
--    �����ȣ, �����, �������� ��ȸ�Ѵ�.
SELECT EMPNO, ENAME, JOB
FROM TBL_EMP
WHERE EMPNO IN (SELECT MGR
                FROM TBL_EMP);

-- �ߺ��� ���� (���ҽ� �Ҹ� ��)
SELECT EMPNO, ENAME, JOB
FROM TBL_EMP
WHERE EMPNO IN (SELECT DISTINCT(MGR)
                FROM TBL_EMP);
/*
7902	    FORD	ANALYST
7698	BLAKE	MANAGER
7839	KING	PRESIDENT
7566	JONES	MANAGER
7788	SCOTT	ANALYST
7782	CLARK	MANAGER
*/


--------------------------------------------------------------------------------


-- �� TBL_SAWON ���̺� ���(������ ����) �� �� ���̺� ���� ���質 �������� ���� ����
CREATE TABLE TBL_SAWONBACKUP
AS
SELECT *
FROM TBL_SAWON;
-- Table TBL_SAWONBACKUP��(��) �����Ǿ����ϴ�.
-- �� TBL_SAWON ���̺��� �����͵鸸 ����� ����
--    ��, �ٸ� �̸��� ���̺� ���·� ������ �� ��Ȳ


-- �� ������ ���� (WHERE - SET ������ �ۼ�)
/*
UPDATE TBL_SAWON
SET SANAME = '�ʶ���'
WHERE SANO = 1005;
*/

-- �� �߸� �ٲ� ������(�̸�) ����
/*
UPDATE TBL_SAWON
SET SANAME = (SELECT SANO, SANAME
              FROM TBL_SAWONBACKUP
              WHERE SANO = TBL_SAWON.SANO)
WHERE SANAME = '�ʶ���';
*/












