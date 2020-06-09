--관리자 DML

--관리자는 교사 계정 관리 및 개설 과정, 개설 과목에 사용하게될 기초 정보를 등록 및 관리할 수 있어야 한다.
--기초 정보에는 과정명, 과목명, 강의실명(정원 포함), 교재명(출판사명 포함) 등이 포함된다.

--1. 교사 계정 관리(id:이름, pw:주민번호뒷자리)
select * from tblTeacher;
--1-1. 교사 정보는 교사 이름, 주민번호 뒷자리, 전화번호, 강의 가능 과목을 기본으로 등록하고, 주민번호 뒷자리는 교사 본인이 로그인시 패스워드로 사용되도록 한다.
insert into tblTeacher values (teacher_seq.nextVal,'이름','주민번호','전화번호');
--1-2. 교사의 강의 가능 과목은 기초 정보 과목명을 이용해서 선택적으로 추가할 수 있어야 한다.
select * from tblSubject; --기초 정보 과목명
create or replace procedure procAddAvlSubject(
    pteacherNum number,
    psubjectName varchar2
)
is
    vsubjectNum tblsubject.subject_seq%type;
begin
    select subject_seq into vsubjectNum from tblSubject where name = psubjectName;
    insert into tblAvlSubject values(avlSubject_seq.nextVal,pteacherNum,vsubjectNum);
end;

begin
    procAddAvlSubjet(교사번호,'과목이름');
end;

--1-3.a 교사 정보 출력시 교사 전체 명단의 교사명, 주민번호 뒷자리, 전화번호, 강의 가능 과목을 출력하고, 
SELECT teacher_seq,name, substr(ssn,8), tel,(SELECT LISTAGG(s.name, ',') WITHIN GROUP (ORDER BY s.name) as tAvlSubject
    FROM tblTeacher t
        INNER JOIN tblAvlSubject a
            ON t.teacher_seq = a.teacher_seq 
                    INNER JOIN tblSubject s
                        ON a.subject_seq = s.subject_seq
                                where t.teacher_Seq = 1)
        FROM tblTeacher;

--1-3.b 특정 교사를 선택한 경우 배정된 개설 과목명, 개설 과목기간(시작 년월일, 끝 년월일), 과정명, 개설 과정기간(시작 년월일, 끝 년월일), 
--교재명, 강의실, 강의진행여부(강의 예정, 강의중, 강의종료)를 확인할 수 있어야 한다.
--강의진행여부는 날짜를 기준으로 확인한다.
--과정명
select rownum, cll.name, oc.startDate, oc.endDate, oc.countStudent, oc.room_seq
    from tblTeacher t inner join tblTeacherCourse tc on t.teacher_seq = tc.teacher_seq
        inner join tblOpenCourse oc on tc.opencourse_seq = oc.opencourse_seq
            inner join tblCourseList cll on oc.courselist_seq = cll.courselist_seq
                where t.teacher_seq = '교사번호';
--where t.teacher_seq = '1';

--과목명
select s.name as subjectName, ss.startdate, ss.enddate, b.name
    from tblTeacher t inner join tblTeacherCourse tc on t.teacher_seq = tc.teacher_seq
        inner join tblOpenCourse oc on tc.opencourse_seq = oc.opencourse_seq
            inner join tblCourseList cll on oc.courselist_seq = cll.courselist_seq
                inner join tblCourseSubject cs on cll.courselist_seq = cs.courselist_seq
                    inner join tblSubject s on cs.subject_seq = s.subject_seq
                        inner join tblbook b on s.book_seq = b.book_seq
                            inner join tblSubjectSchedule ss on s.subject_seq = ss.subject_seq
                                where t.teacher_seq = '교사번호' and cll.courselist_seq = '선택한 과정번호' and oc.opencourse_seq= '개설과정번호'
                                --where t.teacher_seq = '1' and cll.courselist_seq = '1' and oc.opencourse_seq= '11'
                                     and oc.enddate>=ss.enddate and oc.startdate<=ss.startdate;

--1-4.교사 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있어야 한다.
--교사 정보 출력
select * from tblTeacher where teacher_seq = '입력받은 번호' ;
--교사 정보 수정
update tblTeacher set name='값',ssn='값',tel='값' where teacher_seq = '수정할 번호';
--교사 정보 삭제
delete from tblTeacher where teacher_seq = '삭제할 교사번호';
--교사 정보 입력
insert into tblTeacher (teacher_seq,name,ssn,tel) values (teacher_seq.nextVal, '이름','주민번호','전화');

--2. 과목 평가
--개설과정별 과목 보여주기
select cll.name as 과정명, s.name as 과목명
from tblOpenCourse oc inner join tblCourseList cll on oc.courselist_seq = cll.courselist_seq
    inner join tblCourseSubject cs on cll.courselist_seq = cs.courselist_seq
        inner join tblSubject s on cs.subject_seq = s.subject_seq
            where oc.opencourse_seq = '개설과정번호';
--            where oc.opencourse_seq = 13;

--2-1 과목평가 조회 + 평균 점수
select s.name,round(avg(sr.retingScore),1) as 평균
    from tblSubjectRating sr inner join tblsubjectschedule ss on sr.subjectschedule_seq = ss.subjectschedule_seq
        inner join tblSubject s on ss.subject_seq = s.subject_seq
--            where s.name = '과목명'
--            where s.name = 'Back-end 개발'
                group by s.name;

select avg(retingScore) from tblSubjectRating;
select * from tblSubjectRating;



select * from tblSubjectSchedule;
--2-2 과정평가 조회 + 평균 점수

create or replace view viewCourseRating
as
select cll.name, round(avg(sr.retingScore),1) as 평균
    from tblSubjectRating sr inner join tblsubjectschedule ss on sr.subjectschedule_seq = ss.subjectschedule_seq
        inner join tblOpenCourse oc on ss.opencourse_seq = oc.opencourse_seq
            inner join tblCourseList cll on oc.courselist_seq = cll.courselist_seq
                group by cll.name;

select *
from tblOpenCourse oc inner join tblCourseList cll on oc.courselist_seq = cll.courselist_seq;

select * from tblCourseList;

--3. 보충학습
--3-1. 보충학습 조회
select * from tblsupplement;

select sp.suppledate, sc.scoreresult,s.name
from tblSupplement sp inner join tblScore sc on sp.score_seq=sc.score_seq
inner join tblRegiCourse rc on sc.regicourse_seq = rc.regiCourse_seq
inner join tblStudent s on rc.student_seq = s.student_seq
where sc.scoreresult = '과락';

--3.2 특정 교육생 성적 출력시 보충학습 여부
select sp.suppledate, sc.scoreresult,s.name
from tblSupplement sp inner join tblScore sc on sp.score_seq=sc.score_seq
inner join tblRegiCourse rc on sc.regicourse_seq = rc.regiCourse_seq
inner join tblStudent s on rc.student_seq = s.student_seq
where s.student_seq = '교육생번호' and sc.scoreresult = '과락';
--where s.student_seq = 21 and sc.scoreresult = '과락';

--3.2 특정 개설과정 선택시 보충학습한 학생들 조회
select sp.suppledate, sc.scoreresult,s.name
from tblSupplement sp inner join tblScore sc on sp.score_seq=sc.score_seq
inner join tblRegiCourse rc on sc.regicourse_seq = rc.regiCourse_seq
inner join tblStudent s on rc.student_seq = s.student_seq
where sc.scoreresult = '과락' and rc.opencourse_seq = '개설과정번호';
--where sc.scoreresult = '과락' and rc.opencourse_seq = 1;


