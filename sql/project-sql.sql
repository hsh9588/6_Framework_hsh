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











