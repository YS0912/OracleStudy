SELECT USER
FROM DUAL;
-- SCOTT

-- ① 생년월일부터 지금까지 흐른 시간 (단위 : 일)
--    현재시각 - 생년월일
SELECT SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

-- ② 생년월일부터 지금까지 흐른 시간 (단위 : 초)
-- (남은 기간) * (하루를 구성하는 전체 초)
SELECT (SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60)
FROM DUAL;

-- ③ 최종 결과
SELECT SYSDATE "현재시각"
     , TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS') "생년월일"
     , TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60), 24) "시간"
     , MOD(TRUNC(((SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60), 60) "분"
     , TRUNC( MOD(((SYSDATE - TO_DATE('1994-09-25 11:40:00', 'YYYY-MM-DD HH24:MI:SS')) * (24*60*60)), 60) ) "초"
FROM DUAL;
