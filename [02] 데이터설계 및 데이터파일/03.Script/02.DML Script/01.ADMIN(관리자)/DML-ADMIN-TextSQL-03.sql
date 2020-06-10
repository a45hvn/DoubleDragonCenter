-- 1. 관리자 - 3. 학생 관리 - a. 학생 정보 전체보기
-- a. 학생명, 주민번호, 전화번호, 등록일, 수강신청횟수
-- DTO_Student
SELECT name, ssn, tel, regiDate,
    (SELECT COUNT(*) 
        FROM tblStudent s
            INNER JOIN tblRegiCourse rc
                ON s.student_seq = rc.student_seq
                    WHERE s.student_seq = '자바에서for문으로 변수돌림') as numberCourseRequests
                        FROM tblStudent;

-- 자바에서 for문 변수 범위
-- DTO_Student
SELECT COUNT(*) as numberStudent FROM tblStudent;

-- 1. 관리자 ? 3. 학생 관리 - b. 학생 정보 등록 (학생명, 주민번호, 전화번호, 등록일)
-- DTO_Student
INSERT INTO tblStudent
    VALUES(student_seq.nextval, '입력한 학생명', '입력한 주민번호', '입력한 전화번호', sysdate);

-- 학생명과 주민번호가 동시에 해당 학생 테이블에 만족하는게 있으면 등록안됨
-- DTO_Student
SELECT name, ssn FROM tblStudent;

select * from tblattendance;

-- 1. 관리자 ? 3. 학생 관리 - c. 학생 정보 검색 및 수정 (선택한 해당 학생 PK번호 저장해서 다음으로 넘겨줌)
-- a. 이름 검색
-- 수강신청
-- DTO_Student
SELECT student_seq FROM tblStudent WHERE name = '입력학생명'; -- 변수에 저장

-- DTO_Student
SELECT rownum, s.name as studentName, s.ssn as studentssn, s.tel as studentTel, s.regidate as studentRegidate, 
    (SELECT COUNT(*) 
        FROM tblStudent s
            INNER JOIN tblRegiCourse rc
                ON s.student_seq = rc.student_seq
                    WHERE s.student_seq = '위에서 변수에 저장한것을 하나씩 대입') as numberCourseRequests
                        FROM tblStudent  s
                            WHERE name = '입력학생명';

-- b. 주민번호 검색
-- DTO_Student
SELECT student_seq FROM tblStudent WHERE name = '입력주민번호'; -- 변수에 저장

-- DTO_Student
SELECT student_seq, name, ssn, tel, regidate,
    (SELECT COUNT(*) 
        FROM tblStudent s
            INNER JOIN tblRegiCourse rc
                ON s.student_seq = rc.student_seq
                    WHERE s.student_seq = '위에서 변수에 저장한것을 하나씩 대입') as numberCourseRequests
                        FROM tblStudent 
                            WHERE ssn = '입력주민번호';

-- c. 전화번호 검색
-- 수강신청
-- DTO_Student
SELECT student_seq FROM tblStudent WHERE name = '입력전화번호'; -- 변수에 저장

-- DTO_Student
SELECT student_seq, name, ssn, tel, regidate,
    (SELECT COUNT(*) 
        FROM tblStudent s
            INNER JOIN tblRegiCourse rc
                ON s.student_seq = rc.student_seq
                    WHERE s.student_seq = '위에서 변수에 저장한것을 하나씩 대입') as numberCourseRequests
                        FROM tblStudent 
                            WHERE tel = '입력전화번호';

-- d. 등록일 검색
-- 수강신청
-- DTO_Student
SELECT student_seq FROM tblStudent WHERE name = '입력등록일'; -- 변수에 저장

-- DTO_Student
SELECT student_seq, name, ssn, tel, regidate,
    (SELECT COUNT(*) 
        FROM tblStudent s
            INNER JOIN tblRegiCourse rc
                ON s.student_seq = rc.student_seq
                    WHERE s.student_seq = '위에서 변수에 저장한것을 하나씩 대입') as numberCourseRequests
                        FROM tblStudent 
                        WHERE regidate = '입력등록일';

select * from tblregicourse;



-- a. 수정하기(수정하기 위해 입력한 학생명과 주민번호 둘다 일치하는 사람이 있으면 수정불가)
-- DTO_Student
SELECT name, ssn FROM tblStudent; -- 배열이나 리스트에 넣고 하나씩 비교

-- 조건에 만족하면
-- DTO_Student
UPDATE tblStudent 
    SET name = '입력한이름', ssn = '입력한 주민번호', tel = '입력한전화번호'
        WHERE student_seq = '받아온번호값';


--  1. 관리자 ? 3. 학생 관리 - c. 학생 정보 검색 및 수정 ? (검색후) ? 삭제 선택시
-- b. 삭제하기
-- DTO_Student
DELETE FROM tblStudent WHERE student_seq = '받아온번호값';



----------------------------------------------------------
-- 1. 관리자 ? 5. 출결 관리 및 출결조회 - a. 학생별 조회 및 수정
SELECT rownum, s.name as studentName, s.ssn as studentssn, cl.name as courselistName, oc.startDate || '~' || oc.endDate as courseDuration, r.Name as className
    FROM tblStudent s
        INNER JOIN tblRegiCourse rc
            ON s.student_seq = rc.student_seq
                INNER JOIN tblOpenCourse oc
                    ON rc.openCourse_seq = oc.openCourse_seq
                        INNER JOIN tblCourselist cl
                            ON oc.courselist_seq = cl.courselist_seq
                                INNER JOIN tblRoom r
                                    ON oc.room_seq = r.room_seq
                                        WHERE s.name = '학생명 입력 : ';
--                                        WHERE s.name = '강예현';
                                        
select * from tblstudent;                                        

-- 학생번호 변수에 저장 학생 번호 조회
SELECT s.student_seq as studentNumber
    FROM tblStudent s
        INNER JOIN tblRegiCourse rc
            ON s.student_seq = rc.student_seq
                INNER JOIN tblOpenCourse oc
                    ON rc.openCourse_seq = oc.openCourse_seq
                        INNER JOIN tblCourselist cl
                            ON oc.courselist_seq = cl.courselist_seq
                                INNER JOIN tblRoom r
                                    ON oc.room_seq = r.room_seq
                                        WHERE s.name = '입력받은 학생명';
--                                        WHERE s.name = '강예현';                                        


-- 1. 관리자 ? 5. 출결 관리 및 출결조회 - a. 학생별 조회 ? 학생 선택시(앞에서 학생번호와 조회기간 시작일, 종료일을 받아옴)
-- 기간 : 입력받은 시작일 ~ 입력받은 종료일
-- 이름
SELECT name
    FROM tblStudent
        WHERE student_seq = '받아온 학생번호';

select * from tblattendance;
-- 날짜, 출근시간, 퇴근시간, 근태상황
SELECT am.workOn as attendanceDay, to_char(am.workOn, 'hh24:mi') as commuteTime, to_char(am.workOff, 'hh24:mi') as quittingTime, am.state as attendanceSituation
    FROM tblAttendance am
        INNER JOIN tblRegiCourse rc
            ON am.regiCourse_seq = rc.regiCourse_seq
                WHERE rc.student_seq = '받아온 학생번호' AND workOn BETWEEN to_date('받아온 시작일','yyyy-mm-dd') AND to_date('받아온 종료일','yyyy-mm-dd');

--입력받은 학생 번호의 수강신청 번호(자바 변수에 저장)
SELECT rc.regiCourse_seq as enrollmentNumbers
    FROM tblStudent s
        INNER JOIN tblRegiCourse rc
            ON s.student_seq = rc.student_seq
                INNER JOIN tblOpenCourse oc
                    ON oc.openCourse_seq = rc.openCourse_seq
                        WHERE s.student_seq = '입력받은 학생 번호' 
                            AND oc.openCourse_seq = '입력받은 개설과정번호';

-- 수정하기
UPDATE tblattendance 
    SET state = '고칠내용'
        WHERE to_char(ad.workon, 'YYYY-MM-DD') = '입력받은 조회날짜' and regicourse_seq = '수강 신청번호';
        
        




select * from tblteachercourse;
-- 1. 관리자 ? 5. 출결 관리 및 출결조회 - b. 과정별 조회
-- a. 과정번호 과정명 과정기간 교사명 강의실(개설과정번호,조회기간 입력받아 넘겨줌)
select rownum, cl.name as courselistName, oc.startdate || ' ~ ' || oc.enddate as courseDuration, t.name as teacherName, r.name as className 
    from tblopencourse oc
        inner join tblteachercourse tc
            on tc.opencourse_seq = oc.opencourse_seq
                inner join tblteacher t
                    on t.teacher_seq = tc.teacher_seq
                        inner join tblcourselist cl
                            on cl.courselist_seq = oc.courselist_seq
                                inner join tblroom r
                                    on r.room_seq = oc.room_seq;
select * from tblcourselist;

--과정번호 입력을 위해 저장할 개설과정번호(자바에 저장)
select oc.courselist_seq as openingCourseNumber
    from tblopencourse oc
        inner join tblteachercourse tc
            on tc.opencourse_seq = oc.opencourse_seq
                inner join tblteacher t
                    on t.teacher_seq = tc.teacher_seq
                        inner join tblcourselist cl
                            on cl.courselist_seq = oc.courselist_seq
                                inner join tblroom r
                                    on r.room_seq = oc.room_seq;

--입력받을 날짜(자바 변수에 저장해야함)


--입력받은 날짜에 대한 출결 정보
--학번 학생명 출근시간 퇴근시간 근태상황(수정에서 학생이름은 겹칠 수 있기때문에 학생번호로 바꿔야됨)
--*********************************테이블 수정후 다시진행 *****************************************
select  rownum, s.name as studentName, to_char(ad.workon, 'hh24:mm') as commuteTime, to_char(ad.workoff, 'hh24:mm') as quittingTime, ad.state as attendanceSituation
    from tblstudent s
        inner join tblregicourse rc
            on s.student_seq = rc.student_seq
                inner join tblopencourse oc
                    on oc.opencourse_seq = rc.opencourse_seq
                        inner join tblattendance ad
                            on ad.regicourse_seq = rc.regicourse_seq
                                where oc.opencourse_seq = 13
                                      and to_char(ad.workon, 'YYYY-MM-DD') = '입력받은 조회날짜';
--                                    and to_char(ad.workon, 'YYYY-MM-DD') = '2020-01-06';
--                                where oc.opencourse_seq = '입력받은 개설과정번호'
--                                    and ad.workOn = to_date('입력받은 조회날짜''yyyy-mm-dd');

select * from tblopencourse;

select * from tblstudent;

select * from tblattendance order by attendance_seq;
 

--입력받은 학생번호(자바 변수에 저장)
select s.student_seq as stdentNumber
    from tblstudent s
        inner join tblregicourse rc
            on s.student_seq = rc.student_seq
                inner join tblopencourse oc
                    on oc.opencourse_seq = rc.opencourse_seq
                        inner join tblattendance ad
                            on ad.regicourse_seq = rc.regicourse_seq
                                where oc.opencourse_seq = '입력받은 개설과정번호'
                                    and to_char(ad.workon, 'YYYY-MM-DD') = '입력받은 조회날짜';
                                    

--입력받은 학생 번호의 수강신청 번호(자바 변수에 저장)
SELECT rc.regiCourse_seq as enrollmentNumbers
    FROM tblStudent s
        INNER JOIN tblRegiCourse rc
            ON s.student_seq = rc.student_seq
                INNER JOIN tblOpenCourse oc
                    ON oc.openCourse_seq = rc.openCourse_seq
                        WHERE s.student_seq = '입력받은 학생 번호' 
                            AND oc.openCourse_seq = '입력받은 개설과정번호';
                            
                            

                            
