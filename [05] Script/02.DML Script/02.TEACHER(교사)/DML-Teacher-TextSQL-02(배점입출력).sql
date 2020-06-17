----------------------------------------------------------------------------------------------------------------------                               
-- 2. 배점 입출력
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- 2-1. 과목 목록 출력
----------------------------------------------------------------------------------------------------------------------
-- 과목번호, 과정명, 과정기간, 강의실, 과목명, 과목기간, 교재명, 출결, 필기, 실기 배점
commit;
-- 과목 목록 출력 프로시저
create or replace procedure procScoringOut(
    tnum number,
    presult out SYS_REFCURSOR
)
is
begin
    open presult for
    select distinct s.name as 교육생명, cl.name as 과정명, oc.startDate || '~' || oc.endDate as 과정기간, r.name as 강의실
        , sub.subject_seq as 과목번호, sub.name as 과목명, ssd.startDate || '~' || ssd.endDate as 과목기간, b.name as 교재명
        , case 
        when sp.percentObjective is not null then sp.percentObjective || '%'
        when sp.percentObjective is null then null
    end as 실기배점, 
    case
        when sp.percentSubjective is not null then sp.percentSubjective || '%'
        when sp.percentSubjective is null then null
    end as 필기배점,  
    case
        when sp.percentAtt is not null then sp.percentAtt || '%'
        when sp.percentAtt is null then null
    end
    as 출결배점
from tblSubject sub -- 과목 테이블
    inner join tblBook b -- 교재 테이블
        on b.book_seq = sub.book_seq
            inner join tblSubjectSchedule ssd -- 과목 스케줄 조회 테이블
                on ssd.subject_seq = sub.subject_seq
                    inner join tblOpenCourse oc -- 개설 과정 테이블
                        on oc.openCourse_seq = ssd.openCourse_seq
                            left outer join tblScorePercent sp -- 배점 입출력 테이블
                                on sp.subjectSchedule_seq = ssd.subjectSchedule_seq
                                    inner join tblRoom r -- 강의실 테이블
                                        on r.room_seq = oc.room_seq
                                            inner join tblRegiCourse rc -- 수강 신청 테이블
                                                on rc.openCourse_seq = oc.openCourse_seq
                                                    inner join tblStudent s
                                                        on s.Student_seq = rc.Student_seq
                                                            inner join tblCourseList cl -- 과정 목록 테이블
                                                                on cl.courseList_seq = oc.courseList_seq
                                                                    inner join tblteachercourse tc
                                                                        on tc.openCourse_seq = oc.openCourse_seq
                                                                            inner join tblteacher t
                                                                                on t.teacher_seq = tc.teacher_seq
                                                                                    where t.teacher_seq = tnum and oc.startDate > '2020/01/01'
                                                                                        order by ssd.startDate || '~' || ssd.endDate asc;
end;                                                                                
                                           
----------------------------------------------------------------------------------------------------------------------
-- 2-2. 특정 과목을 과목 번호로 선택
----------------------------------------------------------------------------------------------------------------------
-- 특정 과목을 과목 번호로 선택 프로시저
create or replace procedure procScoringSelectSub(
    pnum number,
    tnum number,
    presult out SYS_REFCURSOR
)
is
begin
    open presult for
    select distinct s.name 과목명, sub.subject_seq as 과목번호, cl.name as 과정명, oc.startDate || '~' || oc.endDate as 과정기간, r.name as 강의실
        , ssd.startDate || '~' || ssd.endDate as 과정기간, b.name as 교재명
        , case 
        when sp.percentSubjective is not null then sp.percentSubjective || '%'
        when sp.percentSubjective is null then null
    end as 실기배점, 
    case
        when sp.percentObjective is not null then sp.percentObjective || '%'
        when sp.percentObjective is null then null
    end as 필기배점,  
    case
        when sp.percentAtt is not null then sp.percentAtt || '%'
        when sp.percentAtt is null then null
    end
    as 출결배점
from tblSubject sub -- 과목 테이블
    inner join tblBook b -- 교재 테이블
        on b.book_seq = sub.book_seq
            inner join tblSubjectSchedule ssd -- 과목 스케줄 조회 테이블
                on ssd.subject_seq = sub.subject_seq
                    inner join tblOpenCourse oc -- 개설 과정 테이블
                        on oc.openCourse_seq = ssd.openCourse_seq
                            left outer join tblScorePercent sp -- 배점 입출력 테이블
                                on sp.subjectSchedule_seq = ssd.subjectSchedule_seq
                                    inner join tblRoom r -- 강의실 테이블
                                        on r.room_seq = oc.room_seq
                                            inner join tblRegiCourse rc -- 수강 신청 테이블
                                                on rc.openCourse_seq = oc.openCourse_seq
                                                    inner join tblStudent s
                                                        on s.Student_seq = rc.Student_seq
                                                            inner join tblCourseList cl -- 과정 목록 테이블
                                                                on cl.courseList_seq = oc.courseList_seq
                                                                    inner join tblteachercourse tc
                                                                        on tc.openCourse_seq = oc.openCourse_seq
                                                                            inner join tblteacher t
                                                                                on t.teacher_seq = tc.teacher_seq
                                                                                        where ssd.subject_seq= pnum
                                                                                            and t.teacher_seq = tnum;
end;                                                                                    