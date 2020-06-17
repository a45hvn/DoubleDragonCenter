select * from tblTeacher;

----------------------------------------------------------------------------------------------------------------------
-- 교사 로그인
select name, pw from tblTeacher;

-- 교사 번호는 3번으로 이용
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- 1. 강의 스케줄
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- 1-1. 강의 스케줄 정보 출력
----------------------------------------------------------------------------------------------------------------------
set serveroutput on; 
select * from COUNTRIES;
create or replace procedure proctSchedule1( -- 강의 스케줄 1
    tnum number,
    presult out SYS_REFCURSOR
)
is
begin
    open presult for
    select oc.opencourse_seq as "과정번호", cl.name as "과정명", oc.startdate || '~' || oc.enddate as 과정기간, r.name as "강의실명"
from tblTeacher t -- 교사 테이블
    inner join tblTeacherCourse tc -- 담당과목 테이블
        on t.teacher_seq = tc.teacher_seq
            inner join tblOpenCourse oc -- 개설 과정 테이블
                on oc.openCourse_seq = tc.opencourse_seq
                    inner join tblCourseList cl -- 과정목록 테이블
                        on cl.courseList_seq = oc.courseList_seq
                            inner join tblRoom r -- 강의실 테이블
                                on r.room_seq = oc.room_seq
                                    where t.teacher_seq = tnum;
end;


create or replace procedure proctSchedule2( -- 강의 스케줄 2
    tnum number,
    cnum number,
    presult out SYS_REFCURSOR
)
is
begin
    open presult for
select ss.subjectSchedule_seq, sub.name as "과목명", ss.startDate || '~' || ss.endDate as 과목기간, b.name as "교재명", oc.countstudent as "교육생인원"
from tblSubject sub -- 과목 테이블
    inner join tblSubjectSchedule ss -- 과목 스케줄 조회 테이블
        on sub.subject_seq = ss.subject_seq
            inner join tblBook b -- 교재 테이블
                on b.book_seq = sub.book_seq
                    inner join tblOpenCourse oc -- 개설과정 테이블
                        on oc.opencourse_seq = ss.opencourse_seq
                            inner join tblTeacherCourse tc -- 담당과정 테이블
                                on tc.opencourse_seq = oc.opencourse_seq   
                                    inner join tblTeacher t -- 교사 테이블
                                        on t.teacher_seq = tc.teacher_seq
                                             where t.teacher_seq = tnum
                                                and oc.openCourse_seq = cnum;
end;        

commit;
----------------------------------------------------------------------------------------------------------------------
-- 1-2. 특정 과목을 과목 번호로 선택
----------------------------------------------------------------------------------------------------------------------
-- 교육생 정보(이름, 전화번호, 등록일, 수료 또는 중도탈락)을 확인
create or replace procedure procStudentInfo(
    pnum number,
    presult out sys_refcursor
)
is
begin
    open presult for
select 
st.name as "이름", st.tel as "전화번호", oc.startdate as "시작일", oc.endDate as "종료일", nvl(rc.finalState, '수료') as ,sub.subject_seq
from tblSubject sub -- 과목 테이블
    inner join tblSubjectSchedule ssd -- 과목 스케줄 조회 테이블
        on sub.subject_seq = ssd.subject_seq
            inner join tblOpenCourse oc -- 개설 과정 테이블
                on ssd.openCourse_seq = oc.openCourse_seq
                    inner join tblRegiCourse rc -- 수강 신청 테이블
                        on oc.openCourse_seq = rc.openCourse_seq
                            inner join tblStudent st -- 교육생 테이블
                                on rc.student_seq = st.student_seq
                                    where ssd.subject_seq = pnum
                                        order by st.regiDate asc;
end;       

declare
    vresult SYS_REFCURSOR;
    vname tblStudent.name%type;
    vtel tblStudent.tel%type;
    vregiDate tblStudent.regiDate%type;
    vfinalDate tblRegiCourse.finalDate%type;
    vsName tblSubject.name%type;
    vsubSeq tblSubjectSchedule.subjectSchedule_seq%type;
begin
    procStudentInfo(17, vresult);
    loop
    fetch vresult into vname, vtel, vregiDate, vfinalDate, vsName, vsubSeq;
    exit when vresult%notfound;
    
    dbms_output.put_line(vname || ' ' || vtel || ' ' || vregiDate || ' ' || vfinalDate || ' ' || vsName || ' ' || vsubSeq);
    end loop;
end;
                                        
----------------------------------------------------------------------------------------------------------------------
-- 1-2. 특정 과목을 과목 번호로 선택
----------------------------------------------------------------------------------------------------------------------
                        
create or replace procedure procStudent(
    pseq number,
    presult out sys_refcursor
)
is
begin
    open presult
        for select 
                distinct
                st.name as "이름", st.tel as "전화번호", st.regiDate as "등록일", rc.finalState as "수료/중도 탈락 여부"
                from tblSubject sub -- 과목 테이블
                    inner join tblSubjectSchedule ssd -- 과목 스케줄 조회 테이블
                        on sub.subject_seq = ssd.subject_seq
                          inner join tblOpenCourse oc -- 개설 과정 테이블
                               on ssd.openCourse_seq = oc.openCourse_seq
                                    inner join tblRegiCourse rc -- 수강 신청 테이블
                                        on oc.openCourse_seq = rc.openCourse_seq
                                            inner join tblStudent st -- 교육생 테이블
                                                on rc.student_seq = st.student_seq
                                                    where st.student_seq = pseq
                                                        order by st.regiDate asc;
end;

declare
    presult sys_refcursor;
    pname tblStudent.name%type;
    ptel tblStudent.tel%type;
    pregiDate tblStudent.regiDate%type;
    pfinalState tblRegiCourse.finalState%type;

begin
    procStudent(1, presult);
    loop
        fetch presult into pname, ptel, pregiDate, pfinalState;
        exit when presult%notfound;
        
        dbms_output.put_line(pname||' '|| ptel||' '||pregiDate||' '||pfinalState);
    end loop;
end;

-- drop procedure procStudent;
              
----------------------------------------------------------------------------------------------------------------------
-- 1-3. 강의 스케줄 (강의 중, 강의 예정, 강의 종료) (뷰만듬)
----------------------------------------------------------------------------------------------------------------------
-- 강사의 현재 강의 여부 프로시저
create or replace procedure procIng(
    pnum number,
    presult out sys_refcursor
)
is
begin
    open presult for
        select
        t.name as 교사명,
        cl.name as 과정명,
        oc.startdate || '~' || oc.enddate as 과정기간,
        case
             when startDate < sysdate and sysdate < endDate then '강의중'
                when startDate > sysdate then '강의중'
                when endDate < sysdate then '강의종료'
        end as "진행상태"
from tblOpenCourse oc
    inner join tblTeacherCourse tc
        on oc.openCourse_seq = tc.openCourse_seq
            inner join tblTeacher t
                on t.teacher_seq = tc.teacher_Seq
                    inner join tblcourselist cl
                        on cl.courselist_seq = oc.courselist_seq
                            where t.teacher_seq = pnum;
end;       

commit;



                                                            