-- 게시판 종류 조회
SELECT * FROM BOARD_TYPE ORDER BY 1;

-- 로그인 SQL
SELECT MEMBER_NO, MEMBER_EMAIL, MEMBER_NICKNAME, MEMBER_TEL, MEMBER_ADDRESS, PROFILE_IMG, AUTHORITY, 
		TO_CHAR(ENROLL_DATE, 'YYYY"년" MM"월" DD"일" HH24"시" MI"분" SS"초"') AS ENROLL_DATE
FROM "MEMBER"
WHERE MEMBER_DEL_FL = 'N'
AND MEMBER_EMAIL = 'user01@kh.or.kr'
AND MEMBER_PW = 'pass01!';

-- 회원 정보 수정
UPDATE "MEMBER" SET
MEMBER_NICKNAME = '변경된 닉네임',
MEMBER_TEL = '01012345678',
MEMBER_ADDRESS = '12345,,서울,,어딘가'
WHERE MEMBER_NO = 5; -- 로그인한 회원의 번호

SELECT * FROM "MEMBER";
ROLLBACK;

-- bycrpt 암호화 적용 시 로그인 SQL
SELECT MEMBER_NO, MEMBER_EMAIL, MEMBER_PW, MEMBER_NICKNAME, MEMBER_TEL, MEMBER_ADDRESS, PROFILE_IMG, AUTHORITY, 
		TO_CHAR(ENROLL_DATE, 'YYYY"년" MM"월" DD"일" HH24"시" MI"분" SS"초"') AS ENROLL_DATE
FROM "MEMBER"
WHERE MEMBER_DEL_FL = 'N'

SELECT * FROM "MEMBER";

DELETE FROM "MEMBER"
WHERE MEMBER_NO = 7;
COMMIT;

UPDATE "MEMBER" SET
MEMBER_DEL_FL = 'N'
WHERE MEMBER_NO = 1;
COMMIT;

COMMIT;

-- 탈퇴하지 않은 회원 주 ㅇ이메일이 같은 사람의 수 조회
-- 0 : 중복 x / 1 : 중복 o

SELECT COUNT(*) FROM "MEMBER"
WHERE MEMBER_EMAIL = 'user01@kh.or.kr'
AND MEMBER_DEL_FL = 'N';


-- 닉네임 중복 검사
SELECT COUNT(*) FROM "MEMBER"
WHERE MEMBER_NICKNAME = '오랑우탄'
AND MEMBER_DEL_FL = 'N';

SELECT MEMBER_NO, MEMBER_EMAIL, MEMBER_NICKNAME, 
		MEMBER_ADDRESS, TO_CHAR(ENROLL_DATE, 'YYYY"년" MM"월" DD"일"') ENROLL_DATE, MEMBER_DEL_FL
FROM "MEMBER"
WHERE MEMBER_EMAIL = 'user01@kh.or.kr'
AND ROWNUM = 1;

SELECT MEMBER_NO, MEMBER_EMAIL, MEMBER_DEL_FL
FROM "MEMBER"
ORDER BY MEMBER_NO;

SELECT * FROM "MEMBER";

SELECT * FROM BOARD;

-- COMMENT 테이블 PARENT_NO 컬럼 NULL 허용
ALTER TABLE "COMMENT"
MODIFY PARENT_NO NULL;

-- BOARD 테이블 샘플 데이터 삽입 (PL/SQL)
BEGIN
	FOR I IN 1..2000 LOOP
		INSERT INTO BOARD
		VALUES(SEQ_BOARD_NO.NEXTVAL,
			SEQ_BOARD_NO.CURRVAL || '번째 게시글',
			SEQ_BOARD_NO.CURRVAL || '번째 게시글입니다.<br>안녕하세요',
			DEFAULT, DEFAULT, DEFAULT, DEFAULT, 2,
			CEIL(DBMS_RANDOM.VALUE(0,4)) );
	END LOOP;
END;
/

COMMIT;

SELECT COUNT(*) FROM "BOARD"
WHERE BOARD_CODE = 1;

SELECT * FROM "BOARD"
WHERE BOARD_CODE = 1
ORDER BY 1 DESC;

-- COMMENT 테이블 샘플 데이터 삽입(PL/SQL)
BEGIN
   FOR I IN 1..2000 LOOP
      INSERT INTO "COMMENT" 
      VALUES(SEQ_COMMENT_NO.NEXTVAL, 
            SEQ_COMMENT_NO.CURRVAL || '번째 댓글',
            DEFAULT, DEFAULT,
             CEIL(DBMS_RANDOM.VALUE(0,2000)),
             2, NULL);
   END LOOP;
END;
/
 
COMMIT;

SELECT * FROM BOARD_IMG;

SELECT * FROM "BOARD"
WHERE BOARD_CODE = 1
ORDER BY 1 DESC;
-- 1999, 1997, 1996, 1989

INSERT INTO BOARD_IMG
VALUES(SEQ_IMG_NO.NEXTVAL, '/resources/images/board/',
	'20221116105843_00001.gif', '1.gif', 0, 1999);

INSERT INTO BOARD_IMG
VALUES(SEQ_IMG_NO.NEXTVAL, '/resources/images/board/',
	'20221116105843_00002.gif', '2.gif', 0, 1997);

INSERT INTO BOARD_IMG
VALUES(SEQ_IMG_NO.NEXTVAL, '/resources/images/board/',
	'20221116105843_00003.gif', '3.gif', 0, 1996);

INSERT INTO BOARD_IMG
VALUES(SEQ_IMG_NO.NEXTVAL, '/resources/images/board/',
	'20221116105843_00004.gif', '4.gif', 0, 1989);
	
COMMIT;

-- BOARD_LIKE 테이블 샘플데이터 삽입
SELECT * FROM BOARD_LIKE;

INSERT INTO BOARD_LIKE VALUES(1999, 2);

INSERT INTO BOARD_LIKE VALUES(1997, 2);

COMMIT;

-- 특정 게시글 목록 조회
-- 게시글 번호, 제목, 작성자 닉네임, 조회수, 작성일 + 댓글수, 좋아요 수, 썸네일

SELECT BOARD_NO, BOARD_TITLE, MEMBER_NICKNAME, READ_COUNT, 
CASE  
      WHEN SYSDATE - B_CREATE_DATE < 1/24/60
      THEN FLOOR( (SYSDATE - B_CREATE_DATE) * 24 * 60 * 60 ) || '초 전'
      WHEN SYSDATE - B_CREATE_DATE < 1/24
      THEN FLOOR( (SYSDATE - B_CREATE_DATE) * 24 * 60) || '분 전'
      WHEN SYSDATE - B_CREATE_DATE < 1
      THEN FLOOR( (SYSDATE - B_CREATE_DATE) * 24) || '시간 전'
      ELSE TO_CHAR(B_CREATE_DATE, 'YYYY-MM-DD')
   END B_CREATE_DATE,
	(SELECT COUNT(*) FROM "COMMENT" C
	WHERE C.BOARD_NO = B.BOARD_NO) COMMENT_COUNT,
	(SELECT COUNT(*) FROM BOARD_LIKE L
	WHERE L.BOARD_NO = B.BOARD_NO) LIKE_COUNT,
	(SELECT IMG_PATH || IMG_RENAME FROM BOARD_IMG I
	WHERE IMG_ORDER = 0
	AND I.BOARD_NO = B.BOARD_NO) THUMBNAIL
FROM BOARD B
JOIN MEMBER USING(MEMBER_NO)
WHERE BOARD_CODE = 1
AND BOARD_DEL_FL = 'N'
ORDER BY BOARD_NO DESC;

SELECT COUNT(*) FROM "COMMENT"
WHERE BOARD_NO = 1998;

-- 댓글 수
SELECT COUNT(*) FROM "COMMENT"
WHERE BOARD_NO = 1999;

-- 좋아요 수
SELECT COUNT(*) FROM BOARD_LIKE L
WHERE BOARD_NO = 1999;

-- 섬네일 이미지 조회
SELECT IMG_PATH || IMG_RENAME FROM BOARD_IMG I
WHERE IMG_ORDER = 0
AND I.BOARD_NO = 1999;


-- 게시글 수 조회(삭제 제외)
SELECT COUNT(*)
FROM BOARD
WHERE BOARD_CODE = 1
AND BOARD_DEL_FL = 'N';

-- 특정 게시글 상세 조회
SELECT BOARD_NO, BOARD_TITLE, BOARD_CONTENT, READ_COUNT, 
	TO_CHAR(B_CREATE_DATE, 'YYYY"년" MM"월" DD"일" HH24:MI:SS') B_CREATE_DATE,
	TO_CHAR(B_UPDATE_DATE, 'YYYY"년" MM"월" DD"일" HH24:MI:SS') B_UPDATE_DATE,
	MEMBER_NO, MEMBER_NICKNAME, PROFILE_IMG
FROM BOARD
JOIN MEMBER USING(MEMBER_NO)
WHERE BOARD_NO = 1999
AND BOARD_DEL_FL = 'N';

-- 특정 게시글 이미지 모두 조회
SELECT * FROM BOARD_IMG
WHERE BOARD_NO = 1999
ORDER BY IMG_ORDER;

INSERT INTO BOARD_IMG
VALUES(SEQ_IMG_NO.NEXTVAL, '/resources/images/board/',
'20221116105843_00002.gif', '2.gif', 1 , 1999);

INSERT INTO BOARD_IMG
VALUES(SEQ_IMG_NO.NEXTVAL, '/resources/images/board/',
'20221116105843_00003.gif', '3.gif', 2 , 1999);

INSERT INTO BOARD_IMG
VALUES(SEQ_IMG_NO.NEXTVAL, '/resources/images/board/',
'20221116105843_00004.gif', '4.gif', 3 , 1999);

COMMIT;

-- 특정 게시글 댓글 모두 조회 (어려움) (대칭형 쿼리)
SELECT COMMENT_NO, COMMENT_CONTENT,
	TO_CHAR(C_CREATE_DATE, 'YYYY"년" MM"월" DD"일" HH24"시" MI"분" SS"초"') C_CREATE_DATE,
	BOARD_NO, MEMBER_NO, MEMBER_NICKNAME, PROFILE_IMG,
	PARENT_NO, COMMENT_DEL_FL
FROM "COMMENT"
JOIN MEMBER USING(MEMBER_NO)
WHERE BOARD_NO = 1999
AND COMMENT_DEL_FL = 'N';

SELECT * FROM MEMBER;

INSERT INTO "COMMENT" VALUES(SEQ_COMMENT_NO.NEXTVAL, '부모 댓글1', DEFAULT, DEFAULT, 1999, 2, null);
INSERT INTO "COMMENT" VALUES(SEQ_COMMENT_NO.NEXTVAL, '부모 댓글2', DEFAULT, DEFAULT, 1999, 4, null);
INSERT INTO "COMMENT" VALUES(SEQ_COMMENT_NO.NEXTVAL, '대댓글1', DEFAULT, DEFAULT, 1999, 5, 2020);
INSERT INTO "COMMENT" VALUES(SEQ_COMMENT_NO.NEXTVAL, '대댓글2', DEFAULT, DEFAULT, 1999, 6, 2020);
INSERT INTO "COMMENT" VALUES(SEQ_COMMENT_NO.NEXTVAL, '대댓글3', DEFAULT, DEFAULT, 1999, 7, 2020);

INSERT INTO "COMMENT" VALUES(SEQ_COMMENT_NO.NEXTVAL, '대댓글4', DEFAULT, DEFAULT, 1999, 4, 2021);
INSERT INTO "COMMENT" VALUES(SEQ_COMMENT_NO.NEXTVAL, '대댓글5', DEFAULT, DEFAULT, 1999, 8, 2021);
COMMIT;

/* 계층형 쿼리(START WITH, CONNECT BY, ORDER SIBLINGS BY)

- 상위 타입과 하위 타입간의 관계를 계층식으로 표현할 수 있게하는 질의어(SELECT)

- START WITH : 상위 타입(최상위 부모)으로 사용될 행을 지정 (서브쿼리로 지정 가능)

- CONNECT BY 
  -> 상위 타입과 하위 타입 사이의 관계를 규정
  -> PRIOR(이전의) 연산자와 같이 사용하여
     현재 행 이전에 상위 타입 또는 하위 타입이 있을지 규정

   1) 부모 -> 자식 계층 구조
     CONNECT BY PRIOR 자식 컬럼 = 부모 컬럼

   2) 자식 -> 부모 계층 구조
     CONNECT BY PRIOR 부모 컬럼 = 자식 컬럼

- ORDER SIBLINGS BY : 계층 구조 정렬


** 계층형 쿼리가 적용 SELECT 해석 순서 **

5 : SELECT
1 : FROM (+JOIN)
4 : WHERE
2 : START WITH
3 : CONNECT BY
6 : ORDER SIBLINGS BY

- WHERE절이 계층형 쿼리보다 해석 순서가 늦기 때문에
먼저 조건을 반영하고 싶은 경우 FROM절 서브쿼리(인라인뷰)를 이용

*/

SELECT LEVEL, C.* FROM
(SELECT COMMENT_NO, COMMENT_CONTENT,
	TO_CHAR(C_CREATE_DATE, 'YYYY"년" MM"월" DD"일" HH24"시" MI"분" SS"초"') C_CREATE_DATE,
	BOARD_NO, MEMBER_NO, MEMBER_NICKNAME, PROFILE_IMG,
	PARENT_NO, COMMENT_DEL_FL
FROM "COMMENT"
JOIN MEMBER USING(MEMBER_NO)
WHERE BOARD_NO = 1999
AND COMMENT_DEL_FL = 'N') C
START WITH PARENT_NO IS NULL -- PARENT_NO가 NULL일 경우 최상위 부모
CONNECT BY PRIOR COMMENT_NO = PARENT_NO -- 부모 -> 자식 계층 구조
ORDER SIBLINGS BY COMMENT_NO;


DELETE FROM "COMMENT";

SELECT READ_COUNT
FROM BOARD
WHERE BOARD_NO = 1999;

-- 조회 수 증가

UPDATE BOARD SET
READ_COUNT = READ_COUNT + 1
WHERE BOARD_NO = 1999;

-- 게시글 상세조회 (좋아요 수 추가)

SELECT BOARD_NO, BOARD_TITLE, BOARD_CONTENT, READ_COUNT, 
	TO_CHAR(B_CREATE_DATE, 'YYYY"년" MM"월" DD"일" HH24:MI:SS') B_CREATE_DATE,
	TO_CHAR(B_UPDATE_DATE, 'YYYY"년" MM"월" DD"일" HH24:MI:SS') B_UPDATE_DATE,
	MEMBER_NO, MEMBER_NICKNAME, PROFILE_IMG,
	(SELECT COUNT(*) FROM BOARD_LIKE L
	WHERE L.BOARD_NO = B.BOARD_NO) LIKE_COUNT
FROM BOARD B
JOIN MEMBER USING(MEMBER_NO)
WHERE BOARD_NO = 1999
AND BOARD_DEL_FL = 'N';


SELECT * FROM BOARD_LIKE;

INSERT INTO BOARD_LIKE
VALUES(1999, 4);

ROLLBACK;

DELETE FROM BOARD_LIKE
WHERE BOARD_NO = 1999
AND MEMBER_NO = 4;

SELECT * FROM BOARD
WHERE BOARD_DEL_FL = 'Y';

UPDATE BOARD SET
BOARD_DEL_FL = 'Y'
WHERE BOARD_NO = 1


-- 게시글 삽입
INSERT INTO BOARD
VALUES(SEQ_BOARD_NO.NEXTVAL,
		#{boardTitle}, #{boardContent},
		DEFAULT, DEFAULT, DEFAULT, DEFAULT,
		#{memberNo}, #{boardCode});
		
-- 게시글 첨부 이미지 샆입(여러 행 동시 삽입)
INSERT INTO BOARD_IMG
VALUES(SEQ_IMG_NO.NEXTVAL, '/resources/images/board/',
'20221116105843_00004.gif', '4.gif', 3 , 1000);
	
-- INSERT ALL : 한번에 여러 행 삽입 ( 단, 시퀀스 사용 불가 )	
	
-- 서브쿼리를 이용한 INSERT + UNION ALL

INSERT INTO BOARD_IMG
SELECT SEQ_IMG_NO.NEXTVAL IMG_NO, A.* FROM
(SELECT 
	'경로' IMG_PATH,
	'변경된 파일' IMG_RENAME,
	'원본 파일명' IMG_ORIGINAL,
	1 IMG_OREDER,
	1000 BOARD_NO
FROM DUAL
UNION ALL
SELECT 
	'경로2' IMG_PATH,
	'변경된 파일2' IMG_RENAME,
	'원본 파일명2' IMG_ORIGINAL,
	2 IMG_OREDER,
	1000 BOARD_NO
FROM DUAL) A

SELECT * FROM BOARD_IMG;

SELECT * FROM BOARD
WHERE BOARD_NO = 1998;
	
ROLLBACK;

SELECT * FROM BOARD_IMG
WHERE BOARD_NO = 2007;
	
-- 이미지 삭제
DELETE FROM BOARD_IMG
WHERE BOARD_NO = 2007
AND IMG_ORDER= IN(1, 2, 3, 4);
	
	
-- 게시글 수정(제목, 내용)

UPDATE BOARD SET
BOARD_TITLE = #{boardTitle},
BOARD_CONTENT = #{boardContent}
WHERE BOARD_NO = #{boardNo}

UPDATE BOARD SET
BOARD_DEL_FL = 'N'
WHERE BOARD_NO = 2006;

COMMIT;


-- 검색 조건이 일치하는 게시글 수 조회
SELECT COUNT(*)
FROM BOARD
JOIN MEMBER USING(MEMBER_NO)
WHERE BOARD_CODE = 1
AND BOARD_DEL_FL = 'N'
-- 제목 검색
--AND BOARD_TITLE LIKE '%10%'
-- 내용 검색
--AND BOARD_CONTENT LIKE '%11%'
-- 제목 + 내용 검색	
--AND (BOARD_TITLE LIKE '%10%' OR BOARD_CONTENT LIKE '%11%')
-- 작성자 닉네임
AND MEMBER_NICKNAME LIKE '%팔계%' 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	