---------------------------------------------------------------------------------------------------------------------------
1. 학생은 학생 계정으로 로그인 해야한다	(400번 교육생 값 임의로 넣음)
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


---------------------------------------------------------------------------------------------------------------------------
3. 성적 정보는 과목별로 목록 형태로 출력.
   과목 번호, 과목명, 과목 기간(시작, 끝), 교재명, 교사명, 과목별 배점 정보(출결, 필기, 실기 배점), 과목별 성적 정보(출결, 필기, 실기점수)
   , 과목별 시험날짜, 시험 문제
   성적이 등록되지 않은 과목의 경우, 과목 정보는 출력되고 점수는 null값으로 출력되도록 한다.
---------------------------------------------------------------------------------------------------------------------------
select  s.name as 학생명, score.score_seq,
        schedule.subject_seq as 과목번호, sublist.name as 과목명, schedule.startdate||'~'||schedule.enddate as 과목기간,
        book.name as 교재명, teacher.name as 교사명, spercent.percentSubjective as  "객관식 배점", spercent.percentObjective"주관식 배점"
        , spercent.percentAtt as "출석배점",
        nvl(score.scoresubjective, null) as "객관식 점수", nvl(score.scoreobjective,null) as "주관식 점수", nvl(score.scoreatt,null)as "출석점수" -- 값이 null일 경우 null 출력
        ,spercent.examdate,exam.question as "시험문제"from tblStudent s      --학생 테이블
    inner join tblRegiCourse regi   --수강 신청 테이블 (regi)
        on s.student_seq = regi.student_seq
            inner join tblOpenCourse o -- 개설 과정 테이블(o)
                on regi.opencourse_seq = o.opencourse_seq
                    inner join tblTeacherCourse tcourse -- 담당과정 테이블(tcourse)
                        on o.opencourse_seq = tcourse.opencourse_seq
                            inner join tblTeacher teacher       --교사 테이블(teacher)
                                on teacher.teacher_seq = tcourse.teacher_seq
                                    inner join tblCourseList list      --과정 목록 테이블(list)
                                        on list.courselist_seq = o.courselist_seq
                                            inner join tblCourseSubject subject -- 과정별 과목 테이블(subject)
                                                on list.courseList_seq = subject.courselist_seq
                                                    inner join tblSubject sublist   -- 과목 테이블(sublist)
                                                        on  subject.subject_seq = sublist.subject_seq
                                                            inner join tblbook book -- 교재 테이블(book)
                                                                on sublist.book_seq = book.book_seq
                                                                    inner join tblsubjectschedule schedule  --과목 스케쥴 테이블(schedule)
                                                                        on o.opencourse_seq = schedule.opencourse_seq
                                                                            inner join tblScorePercent spercent --배점 입출력(spercent)
                                                                                on schedule.subjectschedule_seq = spercent.subjectschedule_seq
                                                                                    inner join tblExam exam -- 시험테이블(exam)
                                                                                        on schedule.subjectschedule_seq = exam.subjectschedule_seq
                                                                                            inner join tblScore score   --점수 테이블(score)
                                                                                                 on regi.regicourse_seq = score.regicourse_seq


where s.student_seq =          (select openCourse_seq from tblstudent s2
                                    inner join tblRegiCourse regi2
                                        on s2.student_seq = regi2.student_seq
                                            where name = '강예현'
                                                and  substr(ssn,8,7) = '1847454')and schedule.subject_seq = 8   --'학생번호가 들어있는 개설강의 번호'
                                                            order by sublist.name;




---------------------------------------------------------------------------------------------------------------------------
1. 학생 번호로 수강신청 번호 구하기
---------------------------------------------------------------------------------------------------------------------------
select * from tblstudent s
	inner join tblregicourse regi
		on s.student_seq = regi.student_seq
			where s.seq = 1;			--1번 학생의 수강번호 구하기


---------------------------------------------------------------------------------------------------------------------------
2. 학생, 수강신청, 점수 페이지 inner join Table
---------------------------------------------------------------------------------------------------------------------------
select * from tblstudent s
    inner join tblregicourse regi
        on s.student_seq = regi.student_seq
            inner join tblScore score
                on regi.regicourse_seq = score.regicourse_seq 
                    where s.student_seq = 1;

---------------------------------------------------------------------------------------------------------------------------
3. 개설과정, 담당과정, 교사, 가능과목 inner join Table
---------------------------------------------------------------------------------------------------------------------------
select distinct ocourse.courselist_seq from tblopencourse ocourse
    inner join tblteachercourse tcourse
        on ocourse.opencourse_seq = tcourse.opencourse_seq
            inner join tblTeacher t
                on tcourse.teacher_seq = t.teacher_seq
                    inner join tblavlsubject able
                        on t.teacher_seq = able.teacher_seq
                           
                           --학생 번호가 1인 학생이 소속된 개설 과정 번호 --> 학생번호는 자바에서 받아옴
                            where ocourse.opencourse_seq=(select regi.opencourse_seq from tblstudent s
                                               inner join tblregicourse regi
                                                  on s.student_seq = regi.student_seq
                                                        where s.student_seq = 1);

---------------------------------------------------------------------------------------------------------------------------
4. 가능과목, 과목, 과정별 과목, 과정목록, 교재 inner join Table
---------------------------------------------------------------------------------------------------------------------------
***** 학생번호가 1인 학싱이 등록한 과정의 과정목록번호, 과정명, 과정별 과목 번호, 과목번호..

select DISTINCT list.courselist_seq as 과정목록번호, list.name as 과정명, csubject.coursesubject_seq as 과정별과목번호, sub.name as 과목번호,sub.subject_seq from tblavlsubject avl
    inner join tblsubject sub
        on sub.subject_seq = avl.subject_seq
            inner join tblbook book
                on sub.book_seq = book.book_seq
                    inner join tblcoursesubject csubject
                        on csubject.subject_seq = sub.subject_seq
                            inner join tblcourselist list
                                on list.courselist_seq = csubject.courselist_seq

				 --과정번호가 학생번호 1인 학생이 소속된 번호인 과정목록
                                   where list.courselist_seq = (select distinct ocourse.courselist_seq from tblopencourse ocourse
                                      inner join tblteachercourse tcourse
                                        on ocourse.opencourse_seq = tcourse.opencourse_seq
                                            inner join tblTeacher t
                                              on tcourse.teacher_seq = t.teacher_seq
                                                  inner join tblavlsubject able
                                                      on t.teacher_seq = able.teacher_seq
				
							where ocourse.opencourse_seq=(select regi.opencourse_seq from tblstudent s
                                               inner join tblregicourse regi
                                                  on s.student_seq = regi.student_seq
                                                        where s.student_seq = 1));

---------------------------------------------------------------------------------------------------------------------------
5. 과목스케쥴, 배점입출력, 시험, 성적 inner join Table
---------------------------------------------------------------------------------------------------------------------------
select * from tblsubjectschedule schedule
    inner join tblscorepercent spercent
        on schedule.subjectschedule_seq = spercent.subjectschedule_seq
            inner join tblExam exam
                on schedule.subjectschedule_seq = exam.subjectschedule_seq
                    inner join tblScore score
                        on schedule.subjectschedule_seq = score.subjectschedule_seq
                            where schedule.opencourse_seq = 1;  --자바에서 입력받기(다른 테이블에서 openCourse_seq값 얻어오기)





































































