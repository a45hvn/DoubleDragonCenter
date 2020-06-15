----------------------------------------------------------------------------------------------------------------------
-- 3. 성적 입출력
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- 3-1. 과목 목록 출력***************************** (더미가 이상해요)
----------------------------------------------------------------------------------------------------------------------
-- 과목 목록 출력 프로시저
create or replace procedure procScoreSubject(
    pnum number,
    presult out SYS_REFCURSOR
)
is
begin
    open presult for
    select distinct s.subject_seq as 과목번호, cl.name as 과정명, oc.startDate as "과정기간(시작)", oc.endDate as "과정기간(끝)", r.name as 강의실, s.name as 과목명, ss.startDate as "과목기간(시작)"
    , ss.endDate as "과목기간(끝)", b.name as 교재명, 
    case 
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
    as 출결배점,
    case
        when scoreSubjective is null and scoreObjective is null and scoreAtt is null then '성적등록안됨'
        else '성적등록됨'
    end as 성적등록여부
from tblTeacher t
    inner join tblTeacherCourse tc
        on t.teacher_seq = tc.teacher_seq
            inner join tblOpenCourse oc
                on oc.opencourse_seq = tc.opencourse_seq  
                    inner join tblRoom r
                        on r.room_seq = oc.room_seq
                            inner join tblCourseList cl
                                on cl.courselist_seq = oc.courselist_seq
                                    inner join tblSubjectSchedule ss
                                        on ss.opencourse_seq = oc.opencourse_seq
                                            inner join tblSubject s
                                                on s.subject_seq = ss.subject_seq
                                                    inner join tblBook b
                                                        on b.book_seq = s.book_seq
                                                            inner join tblScorePercent sp
                                                                on sp.subjectschedule_seq = ss.subjectschedule_seq
                                                                    inner join tblScore sc
                                                                        on sc.subjectschedule_seq = ss.subjectschedule_seq
                                                                             where t.teacher_seq = 3
                                                                                and oc.startDate > '20/01/01';
end;  

commit;


select * from tblAttendance where state = '조퇴';

select state as 결석일수, 
case
--    when state = '조퇴' + state = '조퇴' = 2 or state = '조퇴' + state= '지각' = 2 or state = '지각' +  state = '지각' then 1
    when state = '조퇴'  or state = '지각' then 1
end
--case
--    when state = '지각' then 1
--end

from tblAttendance where state = '조퇴' or state = '지각';

select count(*)/3 from (select state as 결석일수, 
case
--    when state = '조퇴' + state = '조퇴' = 2 or state = '조퇴' + state= '지각' = 2 or state = '지각' +  state = '지각' then 1
    when state = '조퇴'  or state = '지각' then 1
end
--case
--    when state = '지각' then 1
--end

from tblAttendance where state = '조퇴' or state = '지각') ;

select * from tblStudent
    inner join tblRegiCourse rc;
----------------------------------------------------------------------------------------------------------------------
-- 3-2. 특정 과목을 과목으로 선택
----------------------------------------------------------------------------------------------------------------------
-- 교육생 정보(이름, 전화번호, 수료 또는 중도 탈락) 및 성적이 출결, 필기, 실기 점수로 구분되어서 출력

-- 특정 과목을 과목으로 선택 후 출력 프로시저
create or replace procedure procScoreSelectSub(
    pnum number,
    presult out SYS_REFCURSOR
)
is
begin
    open presult for
select s.name as 학생명, s.tel as 전화번호, rc.state as 수료여부, sj.subject_seq ,sj.name as 과목명, sc.score_seq as 시험번호, sc.regicourse_seq as 수강신청번호,
 sc.scoresubjective as 필기점수,
sc.scoreobjective as 실기점수, sc.scoreatt as 출결점수, sc.scoreresult as 결과, ss.enddate as 시험날짜
    from tblscore sc 
        inner join tblscorepercent scp --배점
                on scp.subjectschedule_seq = sc.subjectschedule_seq
                    inner join tblsubjectschedule ss
                        on ss.subjectschedule_seq = sc.subjectschedule_seq
                        inner join tblOpenCourse oc -- 개설 과정 테이블
                            on ss.openCourse_seq = oc.openCourse_seq
                                inner join tblsubject sj --과목
                                    on sj.subject_seq = ss.subject_seq                                       
                                           inner join tblregicourse rc
                                                 on rc.regicourse_seq = sc.regicourse_seq
                                                    inner join tblstudent s
                                                        on s.student_seq = rc.student_seq
                                                            where ss.subject_seq = 13;
end;                                                            
