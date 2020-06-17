--교육생 DML
--01. 학생은 학생 계정으로 로그인 해야한다	(400번 교육생 값 임의로 넣음)
*** 자바 변수에 값 저장
---------------------------------------------------------------------------------------------------------------------------
select *
from tblstudent
where name = '최민정'  				 --자바로 이름 입력받기
    and substr(ssn,8,7) = '2598859'; 		 --자바로 주민번호 뒤 7자리 받아오기 700117-2598859

---------------------------------------------------------------------------------------------------------------------------
2. 로그인 성공 시 교육생 개인 정보와 교육생이 수강한 과정명, 과정 기간(시작 년월일, 끝 년월일, 강의실이 타이틀로 출력된다.
***저장된 학생 번호 사용***
---------------------------------------------------------------------------------------------------------------------------
select s.name, s.ssn, s.tel, s.regidate, list.name as 과정명,  o.startDate, o.endDate, room.name   from tblStudent s    --학생 테이블
    inner join tblRegiCourse regi   --수강 신청 테이블
        on s.student_seq = regi.student_seq
            inner join tblOpenCourse o  -- 개설 과정 테이블
                on regi.opencourse_seq = o.openCourse_seq
                    inner join tblRoom room -- 강의실 테이블
                        on o.room_seq = room.room_seq
                                inner join tblCourseList list   -- 과정 목록 테이블
                                    on list.courselist_seq = o.courselist_seq
                                where s.student_seq = 
                                  (select student_seq
                                    from tblstudent
                                        where name = '강예현'   
                                            and substr(ssn,8,7) = '1847454'); -- 로그인한 학생의 학생번호



--02. 성적조회
select sj.subject_seq ,sj.name as 과목명, sc.score_seq as 시험번호, sc.regicourse_seq as 수강신청번호,
scp.percentsubjective as 필기배점, scp.percentobjective as 실기배점, scp.percentatt as 출결배점, sc.scoresubjective as 필기점수,
sc.scoreobjective as 실기점수, sc.scoreatt as 출결점수, sc.scoreresult as 결과, ss.enddate as 시험날짜, ex.question as 시험문제
    from tblscore sc 
        inner join tblscorepercent scp --배점
                on scp.subjectschedule_seq = sc.subjectschedule_seq
                    inner join tblsubjectschedule ss
                        on ss.subjectschedule_seq = sc.subjectschedule_seq
                        inner join tblsubject sj --과목
                            on sj.subject_seq = ss.subject_seq
                                inner join tblexam ex --시험문제
                                    on ex.subjectschedule_seq = ss.subjectschedule_seq
                                        where sc.regicourse_seq = 50 
--                                          where sc.regicourse_seq = '로그인시 가지는 학생번호';                                        
                                                and sj.subject_seq = 17;                                                                              
--                                                and sj.subject_seq = '목록에서 보고싶은 번호 입력';


--과목번호, 과목명, 과목기간, 교재명, 교사명,
select sj.subject_seq as 과목번호,sj.name as 과목명, ss.startdate || '~' || ss.enddate as 과목기간, b.name as 교재명 , t.name as 교사명
    
    from tblscore sc         
        inner join tblscorepercent scp --배점
                on scp.subjectschedule_seq = sc.subjectschedule_seq
                    inner join tblsubjectschedule ss
                        on ss.subjectschedule_seq = sc.subjectschedule_seq
                        inner join tblsubject sj --과목
                            on sj.subject_seq = ss.subject_seq
                                inner join tblbook b
                                    on b.book_seq = sj.book_seq
                                        inner join tblregicourse rc
                                            on rc.regicourse_seq = sc.regicourse_seq
                                                inner join tblopencourse oc
                                                    on oc.opencourse_seq = rc.opencourse_seq
                                                        inner join tblteachercourse tc
                                                            on tc.opencourse_seq = oc.opencourse_seq
                                                                inner join tblteacher t
                                                                    on t.teacher_seq = tc.teacher_seq
                                                                        where sc.regicourse_seq = 50
--                                                                        where sc.regicourse_seq = '로그인시 가지는 학생번호';



--03. 교육생 출결

--교육생 출근 입력
select * from tblAttendance;
insert into tblAttendance (attendance_seq, regiCourse_Seq, workon, workoff, state)
    values (attendance_seq.nextVal, '학생번호', to_date('출근날짜+시간','yyyy-mm-dd hh24:mi'), null, 
        case when to_date('출근날짜시간','yyyymmddhh24:mi') > to_date('출근날짜09:00','yyyymmddhh24:mi') then '지각'
            else '결석' end);

--교육생 퇴근 입력
update tblAttendacne set workoff = to_date('퇴근날짜+시간','yyyy-mm-dd hh24:mi'), 
    state = case when to_date('퇴근날짜+시간','yyyymmddhh24:mi') > to_date('날짜18:00','yyyymmddhh24:mi') then '정상출석'
        else '조퇴' end
            where workon=to_date('출근날짜+시간','yyyy-mm-dd hh24:mi') and regicourse_seq='학생번호';

--출결 전체 조회
select ad.workon as 출근시간, ad.workoff as 퇴근시간, ad.state as 출결상태
from tblStudent s inner join tblRegiCourse rc on s.student_seq = rc.student_seq
    inner join tblAttendance ad on rc.regicourse_seq = ad.regicourse_seq
where s.student_seq = '학생번호';
--where s.student_seq = 471;

--출결 기간별 조회(월,일)
select ad.workon as 출근시간, ad.workoff as 퇴근시간, ad.state as 출결상태
from tblStudent s inner join tblRegiCourse rc on s.student_seq = rc.student_seq
    inner join tblAttendance ad on rc.regicourse_seq = ad.regicourse_seq
where s.student_seq = '471' and to_char(ad.workOn, 'mmdd') = '월일';
--where s.student_seq = '471' and to_char(ad.workOn, 'mmdd') = '0127';

--04. 과목평가----------------------------
--procAddSubjectRating
--(과목 점수입력, 과목평가내용 입력, 개설과정번호 입력, 과목스케쥴번호입력)
--
--------------------------------------------------------
create or replace procedure procAddSubjectRating
(
    pratingScore number,
    pRatingContents varchar2,
    pregiCourse_seq number,
    psubjectSchedule_seq number
)
is
begin
    insert into tblsubjectrating values((select max(subjectRating_seq)+1 from tblsubjectrating),pratingscore,pratingcontents,pregicourse_seq,psubjectschedule_seq);
end;
--------------------------------------------------------

--------------과목평가 조회----------------------------
--procSearchRating
--(학생번호 입력)
--------------------------------------------------------
                            
create or replace procedure procSearchRating
(
    pstudent_seq number,
    vresult out sys_refcursor
)
is
begin
    open vresult for
   select sub.name,sr.ratingscore,sr.ratingcontents from tblSubjectRating sr
    inner join tblRegiCourse rc
        on sr.regiCourse_seq=rc.regiCourse_seq
            inner join tblStudent st
                on st.student_seq=rc.student_seq
                    inner join tblSubjectSchedule sch
                        on sch.subjectSchedule_seq=sr.subjectSchedule_seq
                            inner join tblSubject sub
                                on sub.subject_seq=sch.subject_seq
    where rc.regiCourse_seq=pstudent_seq;
end;

