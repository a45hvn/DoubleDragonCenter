--------------------------------------------------------------------------------------------------------------------------------
-- 4. 출결 관리 및 조회
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
-- 4-1. 특정 과정 출결 조회
--------------------------------------------------------------------------------------------------------------------------------
-- 교사가 강의한 과정에 한해 선택하는 모든 교육생의 출결을 조회할 수 있어야 한다.

-- 교사가 강의한 과정?
-- 교사가 강의한 과정에 한해 선택하는 모든 교육생 출결 조회 프로시저
-- pnum = 3

create or replace procedure procAllAttendace(
    pnum number,
    presult out SYS_REFCURSOR
)
is
begin
    open presult for
select st.name as "교육생이름", to_char(ad.workOn, 'yyyy-mm-dd hh24:mm') as "출근시간"
        , to_char(ad.workOff, 'yyyy-mm-dd hh24:mm') as "퇴근시간", ad.state as "근태사항"
from tblAttendance ad -- 출결 테이블
    inner join tblRegiCourse rc -- 수강 신청 테이블
        on rc.regiCourse_seq = ad.regiCourse_seq
            inner join tblStudent st -- 교육생 테이블
                on st.student_seq = rc.student_seq
                    inner join tblOpenCourse oc -- 개설 과정 테이블
                        on oc.openCourse_seq = rc.openCourse_seq
                            inner join tblTeacherCourse tc -- 담당과정 테이블
                                on tc.openCourse_seq = oc.openCourse_seq
                                    inner join tblTeacher t -- 교사 테이블
                                        on t.teacher_seq = tc.teacher_seq
                                            inner join tblCourseList cl
                                                on cl.courseList_seq = oc.courseList_seq
                                                   where t.teacher_seq = 3
                                                          and ad.workOn >= st.regiDate and ad.workOn <= rc.finalDate
                                                             order by st.name, ad.workOn;
end;                                                    
                                                                                   
--------------------------------------------------------------------------------------------------------------------------------
-- 4-2. 전체 교육생 출결 기간 조회   
--------------------------------------------------------------------------------------------------------------------------------
-- 전체 학생 날짜 모두 조회 프로시저
create or replace procedure procAllStudent(
    pnum number,
    presult out sys_refcursor
)
is
begin
    open presult for
select st.student_seq as "교육생번호", st.name as "교육생이름", to_char(ad.workOn, 'yyyy-mm-dd hh24:mm') as "출근시간"
        , to_char(ad.workOff, 'yyyy-mm-dd hh24:mm') as "퇴근시간", ad.state as "근태사항"
from tblAttendance ad -- 출결 테이블
    inner join tblRegiCourse rc -- 수강 신청 테이블
        on rc.regiCourse_seq = ad.regiCourse_seq
            inner join tblStudent st -- 교육생 테이블
                on st.student_seq = rc.student_seq
                    inner join tblOpenCourse oc -- 개설 과정 테이블
                        on oc.openCourse_seq = rc.openCourse_seq
                            inner join tblTeacherCourse tc -- 담당과정 테이블
                                on tc.openCourse_seq = oc.openCourse_seq
                                    inner join tblTeacher t -- 교사 테이블
                                        on t.teacher_seq = tc.teacher_seq
                                            where ad.workOn >= oc.startDate and oc.endDate >= ad.workOn
                                                and t.teacher_seq = pnum
                                                    order by st.name, ad.workOn;
                                                    
end;
                                            
--------------------------------------------------------------------------------------------------------------------------------
-- 특정 인원 출결 조회 성공
--------------------------------------------------------------------------------------------------------------------------------

-- 특정 인원 번호로 출결 조회 프로시저 민희 474번
create or replace procedure procSnum(
    snum number,
    tnum number,
    presult out sys_refcursor
)
is
begin
    open presult for
select st.student_seq as "교육생번호", st.name as "교육생이름", to_char(ad.workOn, 'yyyy-mm-dd hh24:mm') as "출근시간"
        , to_char(ad.workOff, 'yyyy-mm-dd hh24:mm') as "퇴근시간", ad.state as "근태사항"
from tblAttendance ad -- 출결 테이블
    inner join tblRegiCourse rc -- 수강신청 테이블
        on rc.regiCourse_seq = ad.regiCourse_seq
            inner join tblStudent st -- 교육생 테이블
                on st.student_seq = rc.student_seq
                    inner join tblOpenCourse oc -- 개설 과정 테이블
                        on oc.openCourse_seq = rc.openCourse_seq
                            inner join tblTeacherCourse tc -- 담당 과정 테이블
                                on tc.openCourse_seq = oc.openCourse_seq
                                    inner join tblTeacher t -- 교사 테이블
                                        on t.teacher_seq = tc.teacher_seq
                                            where st.student_seq = snum and ad.workOn >= oc.startDate and oc.endDate >= ad.workOn
                                                    and t.teacher_seq = tnum
                                                    order by to_char(ad.workOn, 'yyyy-mm-dd hh24:mm');
end;                                                 
                                                    


--------------------------------------------------------------------------------------------------------------------------------
-- 특정 과정 인원 출결 조회
--------------------------------------------------------------------------------------------------------------------------------
-- 특정 과정 인원 출결 프로시저
create or replace procedure procSubSearch(
    pnum number,
    tnum number,
    presult out sys_refcursor
)
is
begin
    open presult for
select st.student_seq as "교육생번호", st.name as "교육생이름", to_char(ad.workOn, 'yyyy-mm-dd hh24:mm') as "출근시간"
        , to_char(ad.workOff, 'yyyy-mm-dd hh24:mm') as "퇴근시간", ad.state as "근태사항", cl.name as "과정명", oc.opencourse_seq as "과정개설 번호"
from tblAttendance ad -- 출결 테이블
    inner join tblRegiCourse rc -- 수강신청 테이블
        on rc.regiCourse_seq = ad.regiCourse_seq
            inner join tblStudent st -- 교육생 테이블
                on st.student_seq = rc.student_seq
                    inner join tblOpenCourse oc -- 개설 과정 테이블
                        on oc.openCourse_seq = rc.openCourse_seq
                            inner join tblTeacherCourse tc -- 담당 과정 테이블
                                on tc.openCourse_seq = oc.openCourse_seq
                                    inner join tblTeacher t -- 교사 테이블
                                        on t.teacher_seq = tc.teacher_seq
                                            inner join tblCourseList cl
                                                on cl.courseList_seq = oc.courseList_seq
                                                     where oc.openCourse_seq = pnum and ad.workOn >= oc.startDate and oc.endDate >= ad.workOn
                                                        and t.teacher_seq = tnum
                                                          order by to_char(ad.workOn, 'yyyy-mm-dd hh24:mm');
                                           
                                            -- where t.teacher_seq = "현재 로그인 된 교사의 번호"
                                                  -- and st.name = 선택하여 자바 변수에 저장한 학생 이름
                                                    -- and oc.openCourse_seq = "개설 과정 번호";
end;  

                                                                