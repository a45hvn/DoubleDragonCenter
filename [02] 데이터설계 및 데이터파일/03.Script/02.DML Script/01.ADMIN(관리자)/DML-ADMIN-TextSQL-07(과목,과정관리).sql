-------------------------------------------------------------------------------
--                             4.개설 과정 관리
-------------------------------------------------------------------------------
-- 과정 정보는 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실 정보를 입력한다.
-- 강의실 정보는 기초 정보 강의실명에서 선택적으로 추가할 수 있어야 한다.
--4.1 개설 과정 정보 출력시 개설 과정명, 개설 과정기간(시작 년월일, 끝 년월일), 강의실명, 개설 과목 등록 여부, 교육생 등록 인원(등록인원???)을 출력한다.
--4.2 특정 개설 과정 선택시 개설 과정에 등록된 개설 과목 정보(과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명) 및 등록된 교육생 정보(교육생 이름, 주민번호 뒷자리, 전화번호, 등록일, 수료 및 중도탈락)을 확인할 수 있어야 한다. 
	--4.2.1. 개설과정 입력->과목정보 출력
	--4.2.2. 개설과정 입력-> 교육생정보 출력
--4.3 특정 개설 과정이 수료한 경우 등록된 교육생 전체에 대해서 수료날짜를 지정할 수 있어야 한다. 단, 중도 탈락자는 제외한다
--4.4 개설 과정 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있어야 한다.
	--4.4.1 새로운 과정 만들기
	--4.4.2 새로운 개설과정 만들기
	--4.4.3 개설된 과정 지우기
	--4.4.4 개설된 과정 목록 지우기
-------------------------------------------------------------------------------

------------------------------------------------------------------------------

-----------------------4.1 개설과정정보출력 ---------------------------------
--개설 과정 정보 출력시 과정정보번호, 개설 과정번호, 개설 과정명,강의실명,교육생 등록 인원(등록인원???), 개설 과정기간(시작 년월일, 끝 년월일),기간,모든 과목 출력한다.
create or replace procedure procSearchOpencourse(
    presult out SYS_REFCURSOR
)
is
begin
open presult for
select oc.opencourse_seq as seq,cs_seq as 과정번호,cl.name,oc.room_seq as room,student, startdate, enddate,period /*,sub*/ from tblOpencourse oc --enddate가 올바르지 않지만 포기한다
    inner join ((select cs.courselist_seq cs_seq, listagg (s.name,', ' ) within group(order by cs.courselist_seq) as sub,sum(s.period) as period from tblCourseSubject cs
                    inner join tblsubject s
                        on cs.subject_seq=s.subject_seq
                            inner join tblBook b
                                on s.book_seq=b.book_seq
                                    group by cs.courselist_seq) y)
        on oc.courselist_seq=cs_seq
            inner join tblCourselist cl
                on cl.courselist_seq=oc.courselist_seq
                    inner join ((select rc.opencourse_seq,count(*) as student from tblregicourse rc group by rc.opencourse_seq)x)
                        on oc.opencourse_seq=x.opencourse_seq

where oc.opencourse_seq>0
order by seq;
end;
------------------------------------------------------------------------------

-------------------4.2.1. 개설과정 입력->과목정보 출력---------------------
--procGetOpenCourseInfo
--(개설과정번호 입력
--커서 반환)
------------------------------------------------------------------------------
create or replace procedure procGetOpenCourseInfo
(
    popenCourse_seq number,
    vresult out sys_refCursor
)
is
begin
    open vresult for
    select sch.subjectschedule_seq ,s.name ,sch.startdate ,sch.enddate ,개설과정번호 ,sd ,ed ,선생이름 from tblsubjectSchedule sch
        inner join tblsubject s
            on s.subject_seq=sch.subject_seq
                inner join tblBook b
                    on b.book_seq=s.book_seq--과목스케쥴번호, 과목 번호, 시작일, 종료일, 개설과정번호, 과목번호, 과목이름, 기간, 책번호, 책이름
                       inner join (select oc.opencourse_seq 개설과정번호,oc.courselist_seq as seq, t.teacher_seq,oc.startdate sd,oc.enddate ed ,t.name 선생이름 from tblOpencourse oc
                              inner join tblteacherCourse tc
                                on oc.opencourse_seq=tc.opencourse_seq
                                    inner join tblteacher t
                                        on tc.teacher_seq=t.teacher_seq -- 개설과정번호, 과정번호, 선생번호, 이름
                                       )
                                            on sch.opencourse_seq=개설과정번호
                       where 개설과정번호=popenCourse_seq
                        order by 개설과정번호, sch.startdate;
                             
end;
------------------------------------------------------------------------------

-------------------4.2.2. 과정명 입력해서 학생정보받기---------------------
--procgetStudentInfo
--(개설과정번호 입력,
--커서 반환)
------------------------------------------------------------------------------
create or replace procedure procgetStudentInfo(
    popencourse_seq number,
    vresult out sys_refCursor
)
is

begin
    open vresult for
    select s.name, s.ssn,s.tel,s.regidate,rc.opencourse_seq,cl.name,rc.state from tblRegiCourse rc
        inner join tblstudent s
            on rc.student_seq=s.student_seq
                inner join tblCourseList cl
                    on rc.opencourse_seq=cl.courseList_seq
             where rc.opencourse_seq=popencourse_seq
             order by rc.opencourse_seq;
             
end;
------------------------------------------------------------------------------
-------------------4.3. 과정명 입력해서 수료날짜 지정----------------------
--procAssignFinaldate
--(개설과정번호
--수료날(문자)입력)
------------------------------------------------------------------------------
create or replace procedure procAssignFinaldate(
    popenCourse_Seq number,
    pfinaldate varchar2
)
is
begin
    update tblRegicourse set finaldate=to_date(pfinaldate,'yyyymmdd') where openCourse_Seq=popenCourse_Seq and state='완료';
end;
------------------------------------------------------------------------------


-----------------------4.4.1 새로운 과정만들기-------------------------------
--procNewcourseListSubject
--(과정명입력,
--과목번호 6개 입력)
-------------------------------------------------------------------------------
create or replace procedure procNewcourseListSubject(
    pname varchar2,
    
    psub1 number,--과목 추가, 6개,기간을 더해서 종료일 계산... 근데 주말은???
    psub2 number,
    psub3 number,
    psub4 number,
    psub5 number,
    psub6 number
    
)
is
begin
    insert into tblCourselist values ((select max(COURSELIST_SEQ) from tblCourseList)+1,pname);
    insert into tblCourseSubject values ((select max(COURSESUBJECT_SEQ)from tblcoursesubject)+1,(select max(CourseList_seq)from tblcoursesubject)+1,psub1);
    insert into tblCourseSubject values ((select max(COURSESUBJECT_SEQ)from tblcoursesubject)+1,(select max(CourseList_seq)from tblcoursesubject),psub2);
    insert into tblCourseSubject values ((select max(COURSESUBJECT_SEQ)from tblcoursesubject)+1,(select max(CourseList_seq)from tblcoursesubject),psub3);
    insert into tblCourseSubject values ((select max(COURSESUBJECT_SEQ)from tblcoursesubject)+1,(select max(CourseList_seq)from tblcoursesubject),psub4);
    insert into tblCourseSubject values ((select max(COURSESUBJECT_SEQ)from tblcoursesubject)+1,(select max(CourseList_seq)from tblcoursesubject),psub5);
    insert into tblCourseSubject values ((select max(COURSESUBJECT_SEQ)from tblcoursesubject)+1,(select max(CourseList_seq)from tblcoursesubject),psub6);
    
end;
------------------------------------------------------------------------------------


--------------4.4.2새로운 개설과정 만들기-----------------------------------------
--procOpenCourse
--(과정번호 입력,
--개강일 입력,
--강의실 번호 입력)
------------------------------------------------------------------------------------
create or replace procedure procOpenCourse(
    pcourselist_seq number,
    popen varchar2,
    proom number
)
is
begin
    insert into tblOpenCourse values((select max(opencourse_seq) from tblopencourse)+1,
                                        pcourselist_seq,
                                        to_date(popen,'yyyymmdd'),
                                        (select openday from tblopenday
                                                    where openday_seq=
                                                    (select
                                                        openday_seq+(select period from vwsubjectperiod where subject_seq=pcourselist_seq)
                                                     from tblopenday
                                                        where openday=to_date(popen,'yyyymmdd'))),
                                        (case
                                            when proom in (1,2,3) then 30
                                            when proom in (4,5,6) then 26
                                        end),
                                        proom);
end;

------------------------------------------------------------------------------------

-----------------------4.4.3.개설된 과정 지우기-----------------------------------
--procDeleteopenCourse
--(개설과정번호 입력)
------------------------------------------------------------------------------------
create or replace procedure procDeleteopenCourse(
    popencourse_seq number
)
is
begin
    update tblopencourse set openCourse_seq=openCourse_seq*(-1) where openCourse_seq=popencourse_seq;
end;
------------------------------------------------------------------------------------


-----------------------4.4.4개설된 과정 목록 지우기-------------------------------
--procDeleteCourseList
--(과정목록번호 입력)
------------------------------------------------------------------------------------
create or replace procedure procDeleteCourseList(
    pcourseList_seq number
)
is
begin
    update tblcourselist set courseList_seq=courseList_seq*(-1) where courseList_seq=pcourseList_seq;
end;
------------------------------------------------------------------------------------