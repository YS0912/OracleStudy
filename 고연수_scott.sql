SELECT USER
FROM DUAL;
-- SCOTT

-- �� ������Ϻ��� ���ݱ��� �帥 �ð� (���� : ��)
--    ����ð� - �������
SELECT SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

-- �� ������Ϻ��� ���ݱ��� �帥 �ð� (���� : ��)
-- (���� �Ⱓ) * (�Ϸ縦 �����ϴ� ��ü ��)
SELECT (SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60)
FROM DUAL;

-- �� ���� ���
SELECT SYSDATE "����ð�"
     , TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS') "�������"
     , TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) "��"
     , MOD(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60), 24) "�ð�"
     , MOD(TRUNC(((SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60), 60) "��"
     , TRUNC( MOD(((SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60)), 60) ) "��"
FROM DUAL;
