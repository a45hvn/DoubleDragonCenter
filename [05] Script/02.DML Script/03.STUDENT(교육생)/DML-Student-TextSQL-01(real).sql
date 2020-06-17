--교육생 명 : ID , 주민등록번호(뒷자리) : 패스워드
select name, substr(ssn,8) as ssn from tblStudent where student_seq > 0;


--학생명, 주민번호, 전화번호, 등록일, 과정명, 시작일, 종료일, 강의실명(로그인 후 헤더에 출력)
select st.name as 학생명, st.ssn, st.tel, to_char(st.regidate, 'yyyy-mm-dd') as 등록일, cl.name as 과정명, 
    to_char(oc.startDate, 'yyyy-mm-dd') as 시작일, to_char(oc.endDate, 'yyyy-mm-dd') as 종료일, r.name as 강의실
    from tblRegicourse rc --수강신청
        inner join tblStudent st --학생
            on rc.student_seq = st.student_seq 
                inner join tblopencourse oc --개설과정
                    on oc.openCourse_seq = rc.opencourse_seq
                        inner join tblCourseList cl --과정목록
                            on cl.courselist_seq = oc.courselist_seq
                                inner join tblRoom r --강의실
                                    on r.room_seq = oc.room_seq
                                        where rc.student_seq = 363;


1. 과정 및 과목 조회 - 과정명 출력
select cl.name as 과정명
    from tblRegiCourse rc --수강신청
        inner join tblOpenCourse oc --개설과정
            on rc.opencourse_seq = oc.opencourse_seq
                inner join tblCourseList cl --과정목록
                    on oc.courselist_seq = cl.courselist_seq
                        inner join tblStudent st --학생
                            on st.student_seq = rc.student_seq
                                where rc.student_seq = 363;

1. 과정 및 과목 조회 - 학생번호, 과목번호, 과목명, 과목기간, 교재명
select distinct rc.student_seq, s.subject_seq, s.name as 과목명, to_char(ss.startDate, 'yyyy-mm-dd') as 시작일, 
    to_char(ss.endDate, 'yyyy-mm-dd') as 종료일, b.name as 교재명
    from tblregicourse rc --수강신청
        inner join tblOpenCourse oc --개설과정
            on rc.openCourse_seq = oc.opencourse_seq
                inner join tblSubjectSchedule ss --과목스케줄
                    on oc.openCourse_seq = ss.opencourse_seq
                        inner join tblSubject s --과목
                            on ss.subject_seq = s.subject_seq 
                                inner join tblBook b --교재
                                    on b.book_seq = s.book_seq
                                        inner join tblavlsubject avs --가능과목
                                            on s.subject_seq = avs.subject_seq
                                                where rc.student_seq = 363
                                                    order by subject_seq;


2. 출결조회 - 1. 근태관리 - 1. 입실(todayibsil은 현재날짜)
insert into tblAttendance (attendance_seq, regiCourse_Seq, workon, workoff, state)
	values (attendance_seq.nextVal, '559', to_date('" + todayibsil + "','yyyy-mm-dd hh24:mi'), null,
	case
		when to_date('" + todayibsil + "','yyyy-mm-dd hh24:mi') < to_date('" + todayibsil2 + " 09:00','yyyy-mm-dd hh24:mi') then '입실'
		when to_date('" + todayibsil + "','yyyy-mm-dd hh24:mi') > to_date('" + todayibsil2 + " 09:00','yyyy-mm-dd hh24:mi') then '지각' 
		else '결석'
	end)


2. 출결조회 - 1. 근태관리 - 2. 퇴실(todayibsil은 현재날짜)
update tblAttendance
set" + 
workoff = to_date('" + todayibsil + "','yyyy-mm-dd hh24:mi')  ,
state =
	case  
		when state = '입실' and to_date('" + todayibsil + "','yyyy-mm-dd hh24:mi') > to_date('" + todayibsil2 + " 18:00','yyyy-mm-dd hh24:mi') then '정상출석'
		when state = '지각' and to_date('" + todayibsil + "','yyyy-mm-dd hh24:mi') > to_date('" + todayibsil2 + " 18:00','yyyy-mm-dd hh24:mi') then '지각'
		when to_date('" + todayibsil + "','yyyy-mm-dd hh24:mi') < to_date('" + todayibsil2 + " 18:00','yyyy-mm-dd hh24:mi') then '조퇴'
		else '결석'
	end
		where to_char(workOn, 'yyyy-mm-dd') = '" + todayibsil2 + "' and regicourse_seq = 363;


2. 출결조회 - 2. 전체출결조회
select s.student_seq as 학생번호, ad.workon as 입실시간, ad.workoff as 퇴실시간, ad.state as 출결상태 
    from tblStudent s --학생
        inner join tblRegiCourse rc --수강신청
            on s.student_seq = rc.student_seq 
                inner join tblAttendance ad --출결
                    on rc.regicourse_seq = ad.regicourse_seq 
                        where s.student_seq = 363
                            order by workon;


2. 출결조회 - 3. 월별출결조회(month는 입력 받은 월)
select s.student_seq as 학생번호, ad.workon as 입실시간, ad.workoff as 퇴실시간, ad.state as 출결상태
    from tblStudent s --학생
        inner join tblRegiCourse rc --수강신청
            on s.student_seq = rc.student_seq 
                inner join tblAttendance ad --출결
                    on rc.regicourse_seq = ad.regicourse_seq
                        where s.student_seq = 363 and to_char(ad.workOn, 'mm') = '" + month + "'" + 
                            order by workon;


2. 출결조회 - 4. 일별출결조회(date는 입력받은 월일)
select s.student_seq as 학생번호, ad.workon as 입실시간, ad.workoff as 퇴실시간, ad.state as 출결상태
    from tblStudent s --학생
        inner join tblRegiCourse rc --수강신청
            on s.student_seq = rc.student_seq
                inner join tblAttendance ad --출결
                    on rc.regicourse_seq = ad.regicourse_seq
                        where s.student_seq = 363 and to_char(ad.workOn, 'mmdd') = '" + date + "'" + 
                            order by workon;


3. 성적조회(과목번호, 과목명, 시험번호, 수강신청번호, 필기배점, 실기배점, 출결배점, 필기점수, 실기점수, 출결점수, 결과, 시험날짜, 시험문제)
select sj.subject_seq ,sj.name as 과목명, sc.score_seq as 시험번호, sc.regicourse_seq as 수강신청번호, 
    scp.percentsubjective as 필기배점, scp.percentobjective as 실기배점, scp.percentatt as 출결배점, sc.scoresubjective as 필기점수, 
    sc.scoreobjective as 실기점수, sc.scoreatt as 출결점수, sc.scoreresult as 결과, to_char(ss.enddate, 'yyyy-mm-dd') as 시험날짜, ex.question as 시험문제
        from tblscore sc --성적
            inner join tblscorepercent scp --배점입출력
                on scp.subjectschedule_seq = sc.subjectschedule_seq
                    inner join tblsubjectschedule ss --과목스케줄
                        on ss.subjectschedule_seq = sc.subjectschedule_seq
                            inner join tblsubject sj --과목
                                on sj.subject_seq = ss.subject_seq
                                    inner join tblexam ex --시험
                                        on ex.subjectschedule_seq = ss.subjectschedule_seq
                                            where sc.regicourse_seq = 363
                                                order by sc.score_seq;


4. 보충학습 조회(날짜, 과목명, 필기점수, 실기점수)
select to_char(sm.suppleDate, 'yyyy-mm-dd') as 날짜, s.name as 과목명, sc.scoreObjective as 필기점수, sc.scoreSubjective as 실기점수
    from tblSupplement sm --보충학습
        inner join tblScore sc --성적
            on sm.score_seq = sc.score_seq
                inner join tblSubjectSchedule ss --과목스케줄
                    on ss.subjectschedule_seq = sc.subjectschedule_seq
                        inner join tblSubject s --과목
                            on s.subject_seq = ss.subject_seq
                                where ss.openCourse_seq = 13;


5. 과목 평가 - 1. 과목 평가 하기
-- 과목스케줄번호, 학생번호, 과목명 출력
select ss.subjectSchedule_seq as 과목스케줄번호, rc.student_seq as 학생번호, s.name as 과목명
    from tblSubjectSchedule ss --과목스케줄
        inner join tblOpenCourse oc --개설과정
            on ss.opencourse_seq = oc.opencourse_seq
                inner join tblSubject s --과목
                    on s.subject_seq = ss.subject_seq
                        inner join tblRegiCourse rc --수강신청
                            on rc.openCourse_seq = oc.openCourse_seq
                                inner join tblStudent st --학생
                                    on st.student_seq = rc.student_seq
                                        where rc.student_seq = 363;

-- 과목 평가(평점, 평가내용, 과목스케줄번호는 입력 받음)
insert into tblSubjectRating (subjectRating_seq, ratingScore, ratingContents, regicourse_seq, subjectschedule_seq)
    values (subjectRating_seq.nextVal," + rScore + ", '" + rContents + "' , 363 , " + ssSeq + ");


5. 과목 평가 - 2. 과목 평가 조회(과목명, 평점, 평가내용)
select sub.name, sr.ratingscore, sr.ratingcontents
    from tblSubjectRating sr --과목평가
        inner join tblRegiCourse rc --수강신청
            on sr.regiCourse_seq=rc.regiCourse_seq
                inner join tblStudent st --학생
                    on st.student_seq=rc.student_seq
                        inner join tblSubjectSchedule sch --과목스케줄
                            on sch.subjectSchedule_seq=sr.subjectSchedule_seq
                                inner join tblSubject sub --과목
                                    on sub.subject_seq=sch.subject_seq
                                        where rc.regiCourse_seq=363;