/*
문서명 : DDL...?
작성자 : 1조(강경원, 유민정, 윤대웅, 이예지, 전혜원, 최재성)
작성일자 : 2019.06.02
프로젝트명 : ?????
프로그램명 : 쌍용교육센터
프로그램 설명 : 쌍용 교육센터 시스템을 구현하기 위한 프로그램이다.
*/

/*
-- INDEX
01. 관리자(tblAdmin)
02. 교사(tblTeacher)
03. 가능과목(tblAvlSubject) 
04. 담당과정(tblTeacherCourse)
05. 개설과정(tblOpenCourse)
06. 과정목록(기초정보관리)(tblCourseList)
07. 과정별 과목(tblCourseSubject)
08. 과목(tblSubject)
09. 교재 (tblBook)
10. 강의실(tblRoom)
11. 기자재 품목(tblItem)
12. 수강신청(tblRegiCourse)
13. 출결(tblAttendance)
14. 교육생(tblStudent)
15. 과목스케줄조회(tblSubjectSchedule)
16. 배점입출력(tblScorePercent)
17. 시험(tblExam)
18. 성적(tblScore)
19. 보충학습(tblSupplement)
20. 과목평가(tblSubjectRating)
21. 교육생 면접(tblInterview)
22. 지원활동(tblAS)
23. 취업자(tblEmployment)
24. 업체(tblCompany)
*/

---------------------------------------------------------------------------------------------------
--01. 관리자(tblAdmin)
---------------------------------------------------------------------------------------------------
CREATE TABLE tblAdmin   -- 관리자
(
	admin_seq number primary key,                           -- 관리자 번호(PK)
	name varchar2(30) not null                              -- 관리자 이름
);

create sequence admin_seq;
--DROP TABLE tblAdmin;
--DROP SEQUENCE amdin_seq;

select * from tblAdmin;


---------------------------------------------------------------------------------------------------
--02. 교사(tblTeacher)
---------------------------------------------------------------------------------------------------
CREATE TABLE  tblTeacher -- 교사
(
	teacher_seq number primary key,                         -- 교사 번호(PK)
	name varchar2(30) not null,                             -- 이름
	ssn varchar2(14) not null,                              -- 주민번호
	tel varchar2(13) not null                               -- 전화번호
);

create sequence teacher_seq;        
--DROP TABLE tblTeacher;              
--DROP SEQUENCE teacher_seq;          

select * from tblTeacher;

---------------------------------------------------------------------------------------------------
-- 03. 강의가능과목 (tblAvlSubject)
---------------------------------------------------------------------------------------------------
create table tblAvlSubject -- 강의 가능 과목
(
	avlSubject_seq number primary key,            --가능 과목 번호(PK)
	teacher_seq number not null references tblTeacher(teacher_seq),   --교사번호(FK)
	subject_seq number not null references tblSubject(subject_seq)      --과목번호(FK)
);

create sequence avlSubject_seq;

--DROP table tblAvlSubject;
--DROP sequence avlSubject_seq;

select * from tblAvlSubject;

---------------------------------------------------------------------------------------------------
--04. 담당과정(tblTeacherCourse)
---------------------------------------------------------------------------------------------------
CREATE TABLE tblTeacherCourse -- 교사 담당과정
(
	teacherCourse_seq number primary key,                               -- 담당과정 번호(PK)
	teacher_seq not null references tblTeacher(teacher_seq),            -- 교사번호(FK)
	openCourse_seq not null references tblOpenCourse(openCourse_seq)    --개설과정번호(FK)
);

create sequence teacherCourse_seq;
--DROP TABLE tblTeacherCourse;
--DROP SEQUENCE teacherCourse_seq;

select * from tblTeacherCourse;

---------------------------------------------------------------------------------------------------
--05. 개설과정(tblOpenCourse)
---------------------------------------------------------------------------------------------------
CREATE TABLE tblOpenCourse -- 개설과정
(
	openCourse_seq number primary key,              -- 개설과정 번호(PK)
	courseList_seq number not null references tblCourseList(courseList_seq),   -- 과정 번호(FK)
	startDate date not null,                            -- 과정 기간(시작)
	endDate date not null,                              -- 과정 기간(끝)
	countStudent number not null,                       -- 교육생 인원
	room_seq not null references tblRoom(room_seq)      -- 강의실 번호(FK)
);

create sequence openCourse_seq;
--DROP TABLE tblOpenCourse;
--DROP SEQUENCE openCourse_seq;

select * from tblOpenCourse;

---------------------------------------------------------------------------------------------------
--06. 과정목록(기초정보관리)(tblCourseList)
---------------------------------------------------------------------------------------------------
CREATE TABLE tblCourseList -- 과정목록(기초정보관리)
(
	courseList_seq number primary key,              -- 과정 번호(PK)
	name varchar2(120) not null,                     -- 과정명
	period number not null                          -- 과정 기간
);

create sequence courseList_seq;
--DROP TABLE tblCourseList;
--DROP SEQUENCE courseList_seq;


select * from tblCourseList;

---------------------------------------------------------------------------------------------------
--07. 과정별 과목(tblCourseSubject)
---------------------------------------------------------------------------------------------------
CREATE TABLE tblCourseSubject -- 과정별 과목
(
	courseSubject_seq number primary key,                               -- 과정별 과목 번호(PK)
	courseList_seq not null references tblCourseList(courseList_seq),   -- 과정 번호(FK)
	subject_seq not null references tblSubject(subject_seq)             -- 과목 번호(FK)
);

create sequence courseSubject_seq;
--DROP TABLE tblCourseSubject;
--DROP SEQUENCE courseSubject_seq;

select * from tblCourseSubject;  

---------------------------------------------------------------------------------------------------
--08. 과목(tblSubject)
---------------------------------------------------------------------------------------------------
create table tblsubject -- 과목
(
	subject_seq number primary key,               --과목번호(PK)
	name varchar2(60) not null,               --과목명
	period number not null,                  --과목기간
	book_seq number not null references tblBook(book_seq)      --교재번호(FK)
);

create sequence subject_seq;

--DROP table tblSubject;
--DROP sequence subject_seq;

select * from tblSubject;

---------------------------------------------------------------------------------------------------
-- 09. 교재 (tblBook)
---------------------------------------------------------------------------------------------------
create table tblBook -- 교재
(
	book_seq number primary key,               --교재번호(PK)
	name varchar2(60) not null,               --교재명
	publisher varchar2(30) not null               --출판사
);

create sequence book_seq;

--DROP table tblBook;
--DROP sequence book_seq;

select * from tblBook;

---------------------------------------------------------------------------------------------------
--10. 강의실(tblRoom)
---------------------------------------------------------------------------------------------------
CREATE TABLE tblRoom -- 강의실
(
	room_seq number primary key, -- 강의실 번호(PK)
	name varchar2(12) not null, -- 강의실 명
	count number not null -- 강의실 정원
);

create sequence room_seq;                           
--DROP TABLE tblRoom;                                 
--DROP SEQUENCE room_seq;                             

select * from tblRoom;

---------------------------------------------------------------------------------------------------
--11. 기자재 품목(tblItem)
---------------------------------------------------------------------------------------------------
CREATE TABLE tblItem -- 기자재 품목
(
	item_seq number primary key, -- 품목 번호(PK)
	name varchar2(20) not null, -- 기자재 이름
	itemqty number not null, -- 수량
	room_seq number not null references tblRoom(room_seq), -- 강의실 번호(FK)
	courseList_seq number not null references tblcourseList(courseList_seq) -- 과정번호(FK)
);

create sequence item_seq;                           
--DROP TABLE tblItem;                                 
--DROP SEQUENCE item_seq;                             

select * from tblItem;




---------------------------------------------------------------------------------------------------
-- 12. 수강신청(tblRegiCourse)
---------------------------------------------------------------------------------------------------

create table tblRegiCourse -- 수강신청
(
	regiCourse_seq number primary key, -- 수강신청 번호
	student_seq number references tblStudent(student_seq) not null, --교육생 번호(FK)
	openCourse_seq number references tblOpenCourse(openCourse_seq) not null, -- 개설과정 번호(FK)
	finalState varchar2(15), -- 수료/중도탈락 여부
	finalDate date, -- 수료/중도탈락 날짜
	state varchar2(15) not null, -- 상태(수강신청, 대기, 완료, 취소)
	asState varchar2(15) not null -- 취업 여부
);

create sequence regiCourse_seq;

--DROP table tblRegiCourse;
--DROP sequence regiCourse_seq;

select * from tblRegiCourse;

---------------------------------------------------------------------------------------------------
-- 13. 출결(tblAttendance)
---------------------------------------------------------------------------------------------------

create table tblAttendance -- 출결
(
	attendance_seq number primary key, -- 출결 번호
	regiCourse_seq number references tblRegiCourse(regiCourse_seq) not null, --수강신청 번호(FK)
--	attendDate date not null, -- 날짜
	workOn date, -- 출근시각
	workOff date, -- 퇴근시각
	state varchar2(15) not null -- 근태사항
);

create sequence attendance_seq;

--DROP table tblAttendance;
--DROP sequence attendance_seq;

select * from tblAttendance;



---------------------------------------------------------------------------------------------------
-- 14. 교육생(tblStudent)
---------------------------------------------------------------------------------------------------


create table tblStudent -- 교육생
(
	student_seq number primary key, -- 교육생 번호
	name varchar2(30) not null, -- 교육생 이름
	ssn varchar2(14) not null, -- 교육생 주민번호
	tel varchar2(13) not null, -- 교육생 전화번호
	regiDate date not null -- 등록일
);

create sequence student_seq;

--DROP table tblStudent;
--DROP sequence student_seq;

select * from tblStudent;

---------------------------------------------------------------------------------------------------
--15. 과목스케줄조회(tblSubjectSchedule)
---------------------------------------------------------------------------------------------------
create table tblSubjectSchedule -- 과목 스케줄 조회
(
	subjectSchedule_seq number primary key,            --과목스케줄번호(PK)
	subject_seq number not null references tblSubject(subject_seq),      --과목번호(FK)
	startDate date not null,                  --과목기간(시작)
	endDate date not null,                  --과목기간(끝)
	openCourse_seq number not null references tblOpenCourse(openCourse_seq)--개설과정번호(FK)
);

create sequence subjectSchedule_seq;

--DROP table tblSubjectSchedule;
--DROP sequence subjectSchedule_seq;

select * from tblSubjectSchedule;

---------------------------------------------------------------------------------------------------
--16. 배점입출력(tblScorePercent) 
---------------------------------------------------------------------------------------------------
create table tblScorePercent -- 배점입출력
(
	scorePercent_seq number primary key,            --배점번호(PK)
	percentSubjective number,               --필기배점
	percentObjective number,               --실기배점
	percentAtt number,                  --출결배점
	examDate date not null,                  --시험날짜
	subjectSchedule_seq number not null references tblSubjectSchedule(subjectSchedule_seq) --과목스케줄번호
);

create sequence scorePercent_seq;

--DROP table tblScorePercent;
--DROP sequence scorePercent_seq;

select * from tblScorePercent;

---------------------------------------------------------------------------------------------------
--17.  시험(tblExam) 
---------------------------------------------------------------------------------------------------
create table tblExam -- 시험
(
	exam_seq number primary key,               --시험번호(PK)
	question_seq number,                  --문제번호
	type varchar2(15),                  -- 문제 유형
	question varchar2(600),                  --문제
	subjectSchedule_seq number not null references tblSubjectSchedule(subjectschedule_seq)--과목스케줄번호(FK)
);

create sequence exam_seq;

--DROP table tblExam;
--DROP sequence exam_seq;

select * from tblExam;


---------------------------------------------------------------------------------------------------
-- 18. 성적(tblScore) ************************ 과락여부 scoreResult
---------------------------------------------------------------------------------------------------

create table tblScore -- 성적
(
	score_seq number primary key, -- 성적 번호
	scoreSubjective number, -- 실기 점수
	scoreObjective number, -- 필기 점수
	scoreAtt number, -- 출결 점수
	scoreResult varchar2(15), -- 과락 여부 
	regiCourse_seq number references tblRegiCourse(regiCourse_seq) not null, -- 수강신청 번호(FK)
	subjectschedule_seq number references tblSubjectschedule(subjectschedule_seq) not null -- 과목스케줄 번호(FK)
);

create sequence score_seq;

--DROP table tblScore;
--DROP sequence score_seq;

select * from tblScore;

---------------------------------------------------------------------------------------------------
-- 19. 보충 학습(tblSupplement)
---------------------------------------------------------------------------------------------------

create table tblSupplement
(
	supplement_seq number primary key, -- 보충 학습 번호
	suppleDate date not null, -- 보충 학습 날짜
	score_seq number references tblScore(score_seq) not null -- 성적 번호
);

create sequence supplement_seq;

--DROP table tblSupplement;
--DROP sequence supplement_seq;

select * from tblSupplement;

---------------------------------------------------------------------------------------------------
-- 20. 과목 평가(tblSubjectRating)
---------------------------------------------------------------------------------------------------

create table tblSubjectRating
(
	subjectRating_seq number primary key, -- 과목 평가 번호
    ratingDate date not null, -- 평가 날짜
	ratingScore number not null, -- 평점
	ratingContents varchar2(100), -- 평가 내용
	regiCourse_seq number references tblRegiCourse(regiCourse_seq) not null, --수강신청 번호(FK)
	subjectschedule_seq number references tblSubjectschedule(subjectschedule_seq) not null -- 과목스케줄 번호(FK)
);


create sequence subjectRating_seq;

--DROP table tblSubjectRating;
--DROP sequence subjectRating_seq;

select * from tblSubjectRating;

---------------------------------------------------------------------------------------------------
-- 21. 교육생 면접(tblInterview)
---------------------------------------------------------------------------------------------------

create table tblInterview -- 교육생 면접
(
	interview_seq number primary key, -- 면접 번호
	interviewDate date not null, -- 면접 날짜
	interviewResult varchar2(15) not null, -- 합격 여부
	regiCourse_seq number references tblRegiCourse(regiCourse_seq) not null --수강신청 번호(FK)
);

create sequence interview_seq;

--DROP table tblInterview;
--DROP sequence interview_seq;

select * from tblInterview;

---------------------------------------------------------------------------------------------------
-- 22. 지원활동(tblAS)
---------------------------------------------------------------------------------------------------

create table tblAS -- 지원활동
(
	as_seq number primary key, -- 지원활동 번호
	asDate date, -- 지원활동 날짜
	asService varchar2(15), -- 지원활동
	asList varchar2(500), -- 지원활동 내역
	regiCourse_seq number references tblRegiCourse(regiCourse_seq) not null -- 수강신청 번호(FK)

);

create sequence as_seq;

--DROP table tblAS;
--DROP sequence as_seq;

select * from tblAS;

---------------------------------------------------------------------------------------------------
-- 23. 취업자(tblEmployment)
---------------------------------------------------------------------------------------------------

create table tblEmployment
(
	employment_seq number primary key, -- 취업자 번호
	employmentDate date not null, -- 취업 날짜
	company_seq number references tblCompany(company_seq) not null, -- 업체 번호
	regiCourse_seq number references tblRegiCourse(regiCourse_seq) not null -- 수강신청 번호
);

create sequence employment_seq;

--DROP table tblEmployment;
--DROP sequence employment_seq;

select * from tblEmployment;

---------------------------------------------------------------------------------------------------
-- 24. 업체(tblCompany)
---------------------------------------------------------------------------------------------------

create table tblCompany
(
	company_seq number primary key, -- 업체 번호
	name varchar2(30) not null, -- 업체 이름
	salary number, --연봉
	address varchar2(100) not null, -- 업체 주소
	tel varchar2(13) not null -- 업체 전화번호
);

create sequence company_seq;

--DROP table tblCompany;
--DROP sequence company_seq;

select * from tblCompany;

commit;


