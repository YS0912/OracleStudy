SELECT USER
FROM DUAL;
-- HR


--■■■ 정규화(Normalization) ■■■--

-- ▼ 정규화란?
--    데이터베이스 서버의 메모리 낭비를 막기 위해
--    어떤 하나의 테이블을 식별자를 가지는 여러 개의 테이블로 나누는 과정을 말한다.

-- ▽ 현성이가 옥장판을 판매한다.
--    고객리스트 → 거래처 직원 명단이 적혀 있는 수첩의 정보를
--                  데이터베이스화 하려고 한다.

-- 테이블명 : 거래처직원

/*
각 10Byte
------------------------------------------------------------------------------
거래처회사명 회사주소     회사전화     거래처직원명 직급  이메일   휴대폰
------------------------------------------------------------------------------
    LG       서울여의도   02-345-6789    정미경     부장  jmk@na.. 010-1...   
    LG       서울여의도   02-345-6789    정영준     과장  jyj@da.. 010-7...
    LG       서울여의도   02-345-6789    조영관     대리  cyk@da.. 010-3...
    LG       서울여의도   02-345-6789    고연수     부장  kys@na.. 010-1...
    SK       서울소공동   02-987-6543    최나윤     부장  cny@da.. 010-9...
    LG       부산동래구   051-221-2211   민찬우     대리  mcw@go.. 010-1...
    SK       서울소공동   02-987-6543    유동현     과장  ydh@da.. 010-8...
                                            
                                        :
------------------------------------------------------------------------------

가정) 서울 여의도 LG(본사)라는 회사에 근무하는 거래처 직원 명단이
      총 100만 명이라고 가정한다.
      (한 행(레코드)은 70 Byte)
      
      어느 날 『서울여의도』에 위치한 LG 본사가 『경기분당』으로
      사옥을 이전하게 되었다.
      회사주소는 『경기분당』으로 바뀌고, 회사전화는 『031-111-2222』로 바뀌게 되었다.
      
      따라서 100만 명의 회사주소와 회사전화를 변경해야 한다.
      이때 수행해야 할 쿼리문 ▶ UPDATE
      
      UPDATE 거래처직원
      SET 회사주소 = '경기분당', 회사전화 = '031-111-2222'
      WHERE 거래처회사명 = 'LG'
        AND 회사주소 = '서울여의도';
        
      100만 개 행을 하드디스크상에서 읽어다가 메모리에 로드시켜 주어야 한다.
      즉, 100만 * 70Byte를 모두
      하드디스크상에서 읽어다가 메모리에 로드시켜 주어야 한다는 뜻
      ▷ 이는 테이블의 설계가 잘못되었으므로
         DB 서버는 조만간 메모리 고갈로 인해 DOWN될 것이다.
      ▶ 정규화 과정을 수행해야 한다.
*/


-- ▼ 제 1 정규화
--    어떤 하나의 테이블에 방복되는 컬럼 값들이 존재한다면
--    값들이 반복되어 나오는 컬럼을 분리하여
--    새로운 테이블을 만들어 준다.

/*

-- 테이블명 : 회사 (부모)
------------------------------------------------
회사ID    거래처회사명 회사주소     회사전화   
------------------------------------------------
  10           LG      서울여의도   02-345-6789 
  20           SK      서울소공동   02-987-6543  
  30           LG      부산동래구   051-221-2211
------------------------------------------------

-- 테이블명 : 직원 (자식)
-------------------------------------------------
거래처직원명 직급  이메일   휴대폰     회사ID
-------------------------------------------------
  정미경     부장  jmk@na.. 010-1...     10
  정영준     과장  jyj@da.. 010-7...     10
  조영관     대리  cyk@da.. 010-3...     10
  고연수     부장  kys@na.. 010-1...     10
  최나윤     부장  cny@da.. 010-9...     20
  민찬우     대리  mcw@go.. 010-1...     30
  유동현     과장  ydh@da.. 010-8...     20
                                            
                       :
-------------------------------------------------

*/

-- ▶ 제 1 정규화를 수행하는 과정에서 분리된 테이블은
--    반드시 부모 테이블과 자식 테이블의 관계를 갖게 된다.

--    부모 테이블 ▷ 참조받는 컬럼 : PRIMARY KEY
--    자식 테이블 ▷ 참조하는 컬럼 : FOREIGN KEY

--    참조 받는 컬럼(PRIMARY KEY)이 갖는 특징
--    ▷ 반드시 고유한 값(데이터)만 들어와야 한다.
--       중복된 값(데이터)이 있어서는 안 된다.
--    ▷ 비어있으면(NULL이 있어서는) 안 된다.
--       즉, NOT NULL이어야 한다.

--    제 1 정규화를 수행하는 과정에서
--    부모 테이블의 PRIMARY KEY는 항상 자식 테이블의 FOREIGN KEY로 전이된다.


-- ▽ 테이블이 분리(분할)되기 이전 상태로 조회
/*
SELECT A.거래처회사명, A.회사주소, A.회사전화
     , B.거래처직원명, B.직급, B.이메일, B.휴대폰
FROM 회사 A, 직원 B
WHERE A.회사ID = B.회사ID;
*/

-- ▽ 처음과 같은 상황의 변경 사항이 생겼을 경우, 1개 행만 바꿔주면 된다.
--    (1 * 40Byte)
/*
UPDATE 회사
SET 회사주소 = '경기분당', 회사전화 = '031-111-2222'
WHERE 회사ID = 10;

-- ▶ 정규화 이전에는 100만 건을 처리해야 할 업무에서
--    1건만 처리하면 되는 업무로 바뀐 상황이기 때문에
--    DB 서버는 메모리 고갈이 일어나지 않고 아주 빠르게 처리될 것이다.
*/


/*
▽ 거래처회사명, 회사전화
SELECT 거래처회사명, 회사전화     |     SELECT 거래처 회사명, 회사전화
FROM 회사;                        |     FROM 거래처직원;
                                  |
3 * 40Byte                        |     200만 * 70Byte

▽ 거래처직원명, 직급
SELECT 거래처직원명, 직급         |     SELECT 거래처직원명, 직급
FROM 직원;                        |     FROM 거래처직원;
                                  |
200만 * 50Byte                    |     200만 * 70Byte

▽ 거래처회사명, 거래처직원명            |    SELECT 거래처회사명, 거래처직원명
SELECT A.거래처회사명, B.거래처직원명    |    FROM 거래처직원;
FROM 회사 A JOIN 직원 B                  |
ON A.회사ID = B.회사ID;                  |
                                         |      
(3*40Byte) + (200만*50Byte)              |    200만 * 70Byte
*/



-- 테이블명 : 주문
/*
-----------------------------------------------------------------------------
  고객ID              제품코드                주문일자             주문수량
-----------------------------------------------------------------------------
  KIK1174(김인교)     P-KKBK(꿀꽈배기)        2022-04-30 13:50:23     10
  KYL8835(김유림)     P-KKBC(꼬북칩)          2022-04-30 14:23:11     20
  MCW3235(민찬우)     P-KKDS(쿠쿠다스)        2022-05-11 16:14:37     12
  CHH5834(조현하)     P-SWKK(새우깡)          2022-05-12 10:32:48     12
                                       :
                                       :
-----------------------------------------------------------------------------

-- ▷ 하나의 테이블에 존재하는 PRIMARY KEY의 최대 갯수는 1개이다.
--    하지만, PRIMARY KEY를 이루는(구성하는) 컬럼의 갯수는 복수(여러개)인 것이 가능하다.
--    컬럼 1개로만 구성된 PRIMARY KEY를 SINGLE PRIMARY KEY라고 부른다.
--    (단일 프라이머리 키)
--    두 개 이상의 컬럼으로 구성된 PRIMARY KEY를 COMPOSITE PRIMARY KEY라고 부른다.
--    (복합 프라이머리 키)

-- ▷ 상단 테이블에서 『고객ID + 제품코드 + 주문일자』를 묶어
--    COMPOSITE PRIMARY KEY로 지정 가능
*/

-- ▼ 제 2 정규화
--    제 1 정규화를 마친 결과물에서 PRIMARY KEY가 SINGLE COLUMN이라면
--    제 2 정규화는 수행하지 않는다.
--    하지만 PRIMARY KEY가 COMPOSITE COLUMN이라면
--    반드시!! 제 2 정규화를 수행해야 한다.

--    식별자가 아닌 컬럼은 식별자 전체 컬럼에 대해 의존적이어야 하는데
--    식별자 전체 컬럼이 아닌 일부 식별자 컬럼에 대해서만 의존적이라면
--    이를 분리하여 새로운 테이블을 생성해준다.
--    이 과정을 제 2 정규화라 한다.

/*
-- 테이블명 : 과목 (부모)
-------------------------------------------------------------------------
과목번호 과목명    교수번호 교수자명 강의실코드 강의실설명
++++++++           ++++++++
-------------------------------------------------------------------------
 J0101   자바기초     21    슈바이처    A301     전산실습관 3층 40석 규모
 J0102   자바중급     22    테슬라      T502     전자공학관 5층 60석 규모
 03090   오라클중급   22    테슬라      A201     전산실습관 2층 30석 규모
 03010   오라클심화   10    장영실      T502     전자공학관 5층 60석 규모
 J3342   JSP응용      20    맥스웰      K101     인문과학관 1층 90석 규모
                                    :
-------------------------------------------------------------------------
▷ 과목명은 과목번호에만, 교수자명은 교수번호에만 의존적이기 때문에
   분리해서 새로운 테이블을 만들어 주어야 한다. (제 2 정규화)

-- 테이블명 : 점수 (자식)
---------------------------------------------
과목번호  교수번호 학번               점수
---------------------------------------------
  03090      22     2209130(김태민)    92
  03090      22     2209142(정영준)    80
  03090      22     2209151(최나윤)    96
                    :
---------------------------------------------
*/


-- ▼ 제 3 정규화
--    식별자가 아닌 컬럼이 식별자가 아닌 컬럼에 의존적인 상황이라면
--    이를 분리하여 새로운 테이블을 생성해 주어야 한다.
--    이 과정을 제 3 정규형이라 한다.
--    (Ex. 상단 테이블에서 강의실코드와 강의실설명이 이에 해당)
--                         ++++++++++


-- ▼ 관계(Relation)의 종류

--    ① 1 : many 관계
--       제 1 정규화를 적용하여 수행을 마친 결과물에서 나타나는 바람직한 관계
--       관계형 데이터베이스를 활용하는 과정에서 추구해야 하는 관계

--    ② 1 : 1 관계
--       논리적, 물리적으로 존재할 수 있는 관계이긴 하지만
--       관계형 데이터베이스 설계 과정에서 가급적이면 피해야 할 관계

--    ③ many : many 관계
--       논리적인 모델링에서는 존재할 수 있지만,
--       실제 물리적인 모델링에서는 존대할 수 없는 관계

        /*
        -- 테이블명 : 고객                      -- 테이블명 : 제품
        -----------------------------------     -----------------------------------------------
        고객번호 고객명 이메일    전화번호      제품번호 제품명   제품단가 제품설명 ...
        ++++++++                                ++++++++
        -----------------------------------     -----------------------------------------------
        1001     고연수 abc@tes... 010-1...      pswk    새우깡    500      새우가 들어있는..
        1002     김인교 bcd@tes... 010-2...      pkjk    감자깡    600      감자가 들어있는..
        1003     김태민 cde@tes... 010-3...      pkkm    고구마깡  700      고구마가 들어있는..
        1004     정영준 def@tes... 010-4...      pjkc    자갈치    400      자갈이 들어있는..
                        :                                              :
        -----------------------------------     -----------------------------------------------
        ▷ 위와 같은 상황에서는 아무것도 만들 수가 없다 (PRIMARY KEY는 한 번만 등장할 수 있다)
        
                        -- 테이블명 : 주문접수(판매)
                        -------------------------------------------------
                        주문번호 고객번호 제품번호 주문일자     주문수량
                        -------------------------------------------------
                           27      1001     pswk    2022-06-...    10
                           28      1001     pkjk    2022-06-...    30
                           29      1001     pjkc    2022-06-...    20
                           30      1002     pswk    2022-06-...    20
                           31      1002     pswk    2022-07-...    50
                                                :
                        -------------------------------------------------
                        ▷ 이 테이블이 있어야 상단의 두 테이블 JOIN 가능
                        ▶ 이러한 과정을 제 4 정규화라고 한다.
        */

-- ▼ 제 4 정규화
--    위에서 확인한 내용과 같이 『many : many』 관계를
--    『1 : many』 관계로 깨뜨리는 과정이 바로 제 4 정규화 수행 과정이다.
--    (파생 테이블을 생성하여 다대다 관계를 일대다 관계로 깨뜨리는 역할 수행)


-- ▼ 역정규화(비정규화)

-- ⓐ → 역정규화를 수행하지 않는 것이 바람직

-- 테이블명 : 부서                 -- 테이블명 : 사원
----------------------------       ------------------------------------------ + ---------
-- 부서번호 부서명 주소            사원번호 사원명 직급 급여 입사일 부서번호     부서명
----------------------------       ------------------------------------------ + ---------
--    10개 레코드(행)                         1,000,000개 레코드(행)
----------------------------       ------------------------------------------ + ---------

-- 조회 결과물 ▽
----------------------------
-- 부서명 사원명 직급 급여
----------------------------

-- 『부서』 테이블과 『사원』테이블을 JOIN 했을 때의 크기
--  ▷ (10 * 30Byte) + (1,000,000 * 60Byte) = 60,000,300 Byte

-- 『사원』 테이블을 역정규화 한 후 이 테이블만 읽어올 때의 크기
-- (즉, 부서 테이블의 부서명 컬럼을 사원 테이블에 추가한 경우)
--  ▷ 1,000,000 * 70Byte = 70,000,000 Byte


-- ⓑ → 역정규화를 수행하는 것이 바람직

-- 테이블명 : 부서                 -- 테이블명 : 사원
----------------------------       ------------------------------------------ + ---------
-- 부서번호 부서명 주소            사원번호 사원명 직급 급여 입사일 부서번호     부서명
----------------------------       ------------------------------------------ + ---------
--   500,000개 레코드(행)                     1,000,000개 레코드(행)
----------------------------       ------------------------------------------ + ---------

-- 조회 결과물 ▽
----------------------------
-- 부서명 사원명 직급 급여
----------------------------

-- 『부서』 테이블과 『사원』테이블을 JOIN 했을 때의 크기
--  ▷ (500,000 * 30Byte) + (1,000,000 * 60Byte) = 75,000,000 Byte

-- 『사원』 테이블을 역정규화 한 후 이 테이블만 읽어올 때의 크기
-- (즉, 부서 테이블의 부서명 컬럼을 사원 테이블에 추가한 경우)
--  ▷ 1,000,000 * 70Byte = 70,000,000 Byte


--------------------------------------------------------------------------------


-- ▼ 참고(용어정리)
/*
1. 관계(relationship, relation)
   - 모든 엔트리(entry)는 단일값을 가진다.
   - 각 열(column)은 유일한 이름을 가지며 순서는 무의미하다.
   - 테이블의 모든 행(row==튜플==tuple)은 동일하지 않으며 순서는 무의미하다.

2. 속성(attribute)
   - 테이블의 열(column)을 나타낸다.
   - 자료의 이름을 가진 최소 논리적 단위 : 객체의 성질, 상태 기술
   - 일반 파일(file)의 항목(아이템==item==필드==field)에 해당한다.
   - 엔티티(entity)의 특성과 상태를 기술
   - 속성(attribute)의 이름은 모두 달라야 한다.
   
3. 튜플(tuple)
   - 테이블의 행(row==엔티티==entity)
   - 연관된 몇 개의 속성으로 구성
   - 개념 정보 단위
   - 일반 파일(file)의 레코드(record)에 해당한다.
   - 튜플 변수(tuple variable)
        : 튜플(tuple)을 가리키는 변수, 모든 튜플 집합을 도메인으로 하는 변수

4. 도메인(domain) (범위)
   - 각 속성(attribute)이 가질 수 있도록 허용된 값들의 집합
   - 속성 명과 도메인 명이 반드시 동일할 필요는 없음
   - 모든 릴레이션에서 모든 속성들의 도메인은 원자적(atomic)이어야 함
   - 원자적 도메인
        : 도메인의 원소가 더 이상 나누어질 수 없는 단일체일 때를 나타냄
        
5. 릴레이션(relation)
   - 파일 시스템에서 파일과 같은 개념
   - 중복된 튜플(tuple==entity==엔티티)을 포함하지 않는다. → 모두 상이함(튜플의 유일성)
   - 릴레이션 = 튜플(엔티티==entity)의 집합. 따라서 튜플의 순서는 무의미하다.
   - 속성(attribute)간에는 순서가 없다.
*/


--------------------------------------------------------------------------------






















