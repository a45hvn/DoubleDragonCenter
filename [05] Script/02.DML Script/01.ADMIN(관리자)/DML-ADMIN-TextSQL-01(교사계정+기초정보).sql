--관리자는 교사 계정 관리 및 개설 과정, 개설 과목에 사용하게될 기초 정보를 등록 및 관리할 수 있어야 한다.

select *
from tblTeacher;

--교사 계정(tblTeacher)
--1. 교사 계정 검색
select * from tblTeacher;
--2. 교사 계정 등록
insert into tblTeacher (teacher_seq, name, ssn, tel) values (teacher_seq.nextVal, 이름, 주민번호, 전화번호);
--3. 교사 계정 수정
update tblTeacher set 수정하려는 컬럼명 = 값 where 조건(위치);
--4. 교사 계정 삭제
delete from tblTeacher where 조건(위치);



--개설 과정(tblOpenCourse)
--1. 개설 과정 검색
select * from tblOpenCourse;
--2. 개설 과정 등록
insert into tblOpenCourse (openCourse_seq, courseList_seq, startDate, endDate, countStudent, room_seq)
    values (openCourse_seq.nextVal, 과정번호, 과정기간(시작), 과정기간(끝), 교육생 인원, 강의실 번호);
--3. 개설 과정 수정
update tblOpenCourse set 수정하려는 컬럼명 = 값 where 조건(위치);
--4. 개설 과정 삭제
delete from tblOpenCourse where 조건(위치);



--기초 정보(tblCourseList)
--과정명(tblCourseList), 과목명(tblSubject), 강의실명(정원 포함)(tblRoom), 교재명(출판사명 포함)(tblBook)
--기초 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있어야 한다.
--1. 기초 정보 입력
insert into tblCourseList name values 과정명;
insert into tblSubject name values 과목명;
insert into tblRoom (name, count) values (강의실명, 정원);
insert into tblBook (name, publisher) values (교재명, 출판사명);

--2. 기초 정보 출력
select name from tblCourseList;
select name from tblSubject;
select name, count from tblRoom;
select name, publisher from tblBook;

--3. 기초 정보 수정
update tblCourseList set name = 과정명 where 조건;
update tblSubject set name = 과목명 where 조건;
update tblRoom set name = 강의실명 and count = 정원 where 조건;
update tblBook set name = 교재명 and publisher = 출판사명 where 조건;

--4. 기초 정보 삭제
delete from tblCourseList where 조건;
delete from tblSubject where 조건;
delete from tblRoom where 조건;
delete from tblBook where 조건;





--개설 과목 관리

--특정 개설 과정 선택시 개설 과목 정보 출력-개설과정 번호, 과정명, 과목번호,과목명,과목기간(시작),(끝)
select oc.openCourse_seq as 개설과정번호, cl.name as 과정명, s.subject_seq as 과목번호, s.name as 과목명, ss.startDate as 과목시작, ss.endDate as 과목끝
    from tblOpenCourse oc -- 개설과정
        inner join tblSubjectSchedule ss -- 과목스케줄조회
            on oc.openCourse_seq = ss.openCourse_seq
                inner join tblSubject s -- 과목
                    on s.subject_seq = ss.subject_seq
                        inner join tblCourseList cl -- 과정목록
                            on cl.courseList_seq = oc.courseList_seq
where oc.openCourse_seq = 개설과정번호;
--where oc.openCourse_seq = 1;


--개설 과목 신규 등록을 할 수 있도록 한다.
insert into tblSubject (subject_seq, name, period, book_seq) values (subject_seq.nextVal, 과목명, 과목기간, 교재번호);


--개설 과목 정보 입력시 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명을 입력할 수 있어야 한다.
insert into tblSubject (subject_seq, name, period, book_seq) values (subject_seq.nextVal, 과목명, 과목기간, 교재번호);
insert into tblBook (book_seq, name, publisher) values (book_seq.nextVal, 교재명, 출판사);
insert into tblTeacher (teacher_seq, name, ssn, tel) values (teacher_seq.nextVal, 교사명, 주민번호, 전화번호);


--교재명은 기초 정보 교재명에서 선택적으로 추가할 수 있어야 한다.
insert into tblBook (book_seq, name, publisher) values (book_seq.nextVal, 교재명, 출판사);

--교사명은 교사 명단에서 선택적으로 추가할 수 있어야 한다.
insert into tblTeacher (teacher_seq, name, ssn, tel) values (teacher_seq.nextVal, 교사명, 주민번호, 전화번호);

--교사 명단은 현재 과목과 강의 가능 과목이 일치하는 교사 명단만 보여야 한다.
select distinct t.name
    from tblSubjectSchedule ss --과목스케줄조회
        inner join tblSubject s -- 과목
            on sc.subject_seq = s.subject_seq
                inner join tblAvlSubject avlS -- 가능과목
                    on avlS.subject_seq = s.subject_seq
                        inner join tblTeacher t --교사
                            on avlS.teacher_seq = t.teacher_seq
                                inner join tblOpenCourse oc -- 개설과정
                                    on oc.opencourse_seq = sc.opencourse_seq
where ss.subject_seq = 13  -- 현재 진행 중인 과정
and ss.subject_seq = avls.subject_seq; --강의스케줄 상의 과목번호(진행과정의 과목) = 강의 가능 과목의 과목번호


--개설 과목 출력시 개설 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일), 강의실)와 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명을 출력한다.
select cl.name as 과정명, oc.startDate as 과정시작, oc.endDate as 과정끝, r.name as 강의실명
    , s.name as 과목명, ss.startDate as 과목시작, ss.endDate as 과목끝, b.name as 교재명,t.name as 교사명
    from tblSubjectSchedule ss -- 과목스케줄조회
        inner join tblOpenCourse oc -- 개설과정
            on sc.openCourse_seq = oc.openCourse_seq
                inner join tblTeacherCourse tc -- 담당과정
                    on tc.openCourse_seq = oc.openCourse_seq
                        inner join tblTeacher t -- 교사
                            on t.teacher_seq = tc.teacher_seq
                                inner join tblRoom r -- 강의실
                                    on r.room_seq = oc.room_seq
                                        inner join tblCourseList cl --과정목록
                                            on cl.courseList_seq = oc.courseList_seq
                                                inner join tblSubject s --과목
                                                    on sc.subject_seq = s.subject_seq
                                                        inner join tblBook b --교재
                                                            on b.book_seq = s.book_seq;
           
                                                            

--개설 과목 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있어야 한다.
--과목스케줄조회 tblSubjectSchedule(subjectSchedule_seq, subject_seq, startDate, endDate, openCourse_seq)
--1. 개설 과목 입력
insert into tblsubjectSchedule (subjectSchedule_seq, subject_seq, startDate, endDate, openCourse_seq)
    values (subjectSchedule_seq.nextVal, 과목번호, to_date('과목시작일', 'yyyy-mm-dd'), to_date('과목끝', 'yyyy-mm-dd'), 개설과정번호);

--2. 개설 과목 출력
select subject_seq as 과목번호, startDate as 과목시작, endDate as 과목끝, openCourse_seq as 개설과정번호
from tblSubjectSchedule;

--3. 개설 과목 수정
update tblSubjectSchedule set 컬럼명 = 바꿀값 where 조건;

--4. 개설 과목 삭제
delete from tblSubjectSchedule where 조건;




<추가사항>
--교육생 면접(tblInterView) >예지
--1. 입력
insert into tblInterView (interview_seq, interviewDate, interviewResult, regiCourse_seq)
    values (interview_seq.nextVal, to_date('년-월-일', 'yyyy-mm-dd'),'합격' 혹은 '불합격', 수강신청 번호);
    
--2. 출력
select 컬럼명 from tblInterView;

--3. 수정
update tblInterView set 컬럼명 = 바꿀 값 where 조건;

--4. 삭제
delete from tblInterView where 조건;
																		