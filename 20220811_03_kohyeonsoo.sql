-- ▼ 접속된 사용자 확인
SELECT USER
FROM DUAL;
-- KOHYEONSOO


-- ▼ 테이블 생성 (테이블명 : TBL_ORAUSERTEST) / 오라 유저 테스트
CREATE TABLE TBL_ORAUSERTEST
( NO    NUMBER(10)
, NAME  VARCHAR2(30)
);
-- 에러발생
-- ▷ ORA-00907: missing right parenthesis
-- 현재 각자의 이름 계정은 CREATE SESSION 권한만 갖고 있으며
-- 테이블을 생성할 수 있는 권한은 갖고 있지 않은 상태이다.
-- 그러므로 관리자로부터 테이블을 생성할 수 있는 권한 부여가 필요


-- ▼ SYS로부터 CREATE TABLE 권한을 부여받은 후
CREATE TABLE TBL_ORAUSERTEST
( NO    NUMBER(10)
, NAME  VARCHAR2(30)
);
-- 에러 발생
-- ▷ ORA-00907: missing right parenthesis
-- 테이블을 생성할 수 있는 권한을 부여받은 상황이지만
-- 본인 이름 계정의 기본 테이블스페이스(DEFAULT TABLESPACE)는 TBS_EDUA이며,
-- 이 공간에 대한 할당량을 부여받지 못한 상태이다.
-- 그러므로 이 테이블스페이스를 사용할 권한이 없다는 에러메시지를 오라클이 전달


-- ▼ 테이블스페이스에 대한 할당량을 부여받은 후
CREATE TABLE TBL_ORAUSERTEST
( NO    NUMBER(10)
, NAME  VARCHAR2(30)
);
-- Table TBL_ORAUSERTEST이(가) 생성되었습니다.

-- ▼ 자신에게 부여된 할당량 조회
SELECT *
FROM USER_TS_QUOTAS;
-- TBS_EDUA	65536	-1	8	-1	NO

-- ▼ 생성된 테이블(TBL_ORAUSERTEST)이 어떤 테이블스페이스에 저장되어 있는지 조회
SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES;
-- TBL_ORAUSERTEST	TBS_EDUA

























