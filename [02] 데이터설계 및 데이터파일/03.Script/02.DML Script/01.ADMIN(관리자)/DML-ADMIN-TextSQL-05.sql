-- 1. 관리자 ? 4. 성적 조회

-- 1. 관리자 - 4. 성적 조회 - a. 과정별 성적 조회
-- a. 개설과정 보여줌(개설과정 PK를 넘김)
-- DTO_ViewOpenCourse
SELECT oc.openCourse_seq as openCourse_seq, rownum, cl.name as courselistName, oc.startDate || '~' || oc.endDate as courseDuration, t.name as teacherName, r.Name as className
    FROM tblCourselist cl
        INNER JOIN tblOpenCourse oc
            ON cl.courselist_seq = oc.openCourse_seq
                INNER JOIN tblRoom r
                    ON oc.room_seq = r.room_seq
                        INNER JOIN tblTeacherCourse tc
                            ON tc.openCourse_seq = oc.openCourse_seq
                                INNER JOIN tblTeacher t
                                    ON tc.teacher_seq = t.teacher_seq;
                                    

-- b. 개설과정 안의 개설과목을 보여줌,개설과목번호(PK)를 넘겨줌 , 성적등록여부를 어떻게 할지?(grade가 들어가는 순간 250개로 나옴)
-- DTO_ViewOpenSubject
SELECT ss.subjectschedule_seq as openSubject_seq, rownum, s.name as subjectName, ss.startDate || '~' || ss.endDate as subjectDuration
--    CASE
--            WHEN s.score is not null then 'O'
--            WHEN g.score is null then 'X'
--    END
        FROM tblOpenCourse oc
            INNER JOIN tblsubjectschedule ss
                ON oc.openCourse_seq = ss.openCourse_seq
                    INNER JOIN tblSubject s
                        ON ss.subject_seq = s.subject_seq
--                            INNER JOIN tblGrade g
--                                ON g.openSubjectMgmt_seq = osm.openSubjectMgmt_seq
--                                    WHERE oc.openCourse_seq = '받아온개설과정번호';
                                    WHERE oc.openCourse_seq = 1;
                                    
                                    
                                    
-- ***************************************************************
-- b. 개설과정 안의 개설과목을 보여줌,개설과목번호(PK)를 넘겨줌 , 성적등록여부를 어떻게 할지?(grade가 들어가는 순간 250개로 나옴)
-- DTO_ViewOpenSubject
SELECT  DISTINCT ss.subjectschedule_seq as openSubject_seq, s.name as subjectName, ss.startDate || '~' || ss.endDate as subjectDuration,
    CASE
            WHEN sc.scoresubjective is not null then 'O'
            WHEN sc.scoresubjective is null then 'X'
    END as 성적등록여부    ,
    CASE
            WHEN e.question is not null then 'O'
            WHEN e.question is null then 'X'
    END as 시험등록여부
        FROM tblOpenCourse oc
            INNER JOIN tblsubjectschedule ss
                ON oc.openCourse_seq = ss.openCourse_seq
                    INNER JOIN tblSubject s
                        ON ss.subject_seq = s.subject_seq
                            INNER JOIN tblscore sc
                                ON sc.subjectschedule_seq = ss.subjectschedule_seq
                                    INNER JOIN tblexam e
                                        on e.subjectschedule_seq = ss.subjectschedule_seq
--                                    WHERE oc.openCourse_seq = '받아온개설과정번호';
                                    WHERE oc.openCourse_seq = 12;
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
-- c. 과목에 해당하는 학생들의 성적보여주기
-- DTO_StudentGradesSubject
SELECT s.name as 과목명, oc.startDate || '~' || oc.endDate as courseDuration, oc.room_seq as 강의실명, t.name as 교사명, b.name as 교재명, stu.name as studentName, stu.ssn as 주민번호, sc.scoresubjective as 필기, sc.scoreobjective as 실기 
    FROM tblOpenCourse oc
            INNER JOIN tblsubjectschedule ss
                ON oc.openCourse_seq = ss.openCourse_seq
                    INNER JOIN tblSubject s
                        ON ss.subject_seq = s.subject_seq
                            INNER JOIN tblscore sc
                                ON sc.subjectschedule_seq = ss.subjectschedule_seq
                                    INNER JOIN tblRegiCourse rc
                                        ON sc.regiCourse_seq = rc.regiCourse_seq
                                            INNER JOIN tblStudent stu
                                                ON rc.student_seq = stu.student_seq
                                                    INNER JOIN tblcourselist cl
                                                        on cl.courselist_seq = oc.courselist_seq
                                                            INNER JOIN tblteachercourse tc
                                                                on tc.opencourse_seq = oc.opencourse_seq
                                                                    INNER JOIN tblteacher t
                                                                        on t.teacher_seq = tc.teacher_seq
                                                                            INNER JOIN tblbook b
                                                                                on b.book_seq = s.book_seq
                                                                            
--                                                    WHERE oc.openCourse_seq = '받아온개설과정번호' and osm.openSubjectMgmt_seq = '받아온개설과목번호';
                                                    WHERE oc.openCourse_seq = '13' and ss.subjectschedule_seq = '77';

-- 1. 관리자 - 4. 성적 조회 - b. 학생별 성적 조회(해당 번호 찝찝, 학생명으로 하자니 수강을2개이상하면 번호가 겹치고, 수강번호로 하자니 건너뛰는 번호가 나옴,
-- 자바에서 번호 보여주고 해당 학생번호를 배열에 넣어서 보여줘도됨)
-- 학생별 수강과정 목록을 보여주기
-- DTO_StudentsTakingCourses
SELECT rownum, s.name as studentName, s.ssn as studentssn, cl.name as courselistName, oc.startDate || '~' || oc.endDate as courseDuration, r.Name as className
    FROM tblStudent s
        INNER JOIN tblRegiCourse rc
            ON s.student_seq = rc.student_seq
                INNER JOIN tblOpenCourse oc
                    ON rc.openCourse_seq = oc.openCourse_seq
                        INNER JOIN tblCourseList cl
                            ON oc.courselist_seq = cl.courselist_seq
                                INNER JOIN tblRoom r
                                    ON oc.room_seq = r.room_seq
--                                        WHERE s.name = '입력한학생명';
                                        WHERE s.name = '강예현';
                                        
select * from tblstudent;                                        

-- 1. 관리자 - 4. 성적 조회 - b. 학생별 성적 조회 - 학생
-- a. ■ 학생이름
SELECT name
    FROM tblStudent
        WHERE student_seq = '받아온 학생번호';

-- b. 과목명 과목기간 점수 출력
-- DTO_StudentCourseGrades
SELECT sj.name as subjectName, t.name as 교사명, ss.startDate || '~' || ss.endDate as subjectDuration, sc.scoresubjective as 필기, sc.scoreobjective as 실기 
    FROM tblStudent stu
        INNER JOIN tblRegiCourse rc
            ON stu.student_seq = rc.student_seq
                INNER JOIN tblScore sc
                    ON rc.regiCourse_seq = sc.regiCourse_seq
                        INNER JOIN tblsubjectschedule ss
                            ON sc.subjectschedule_seq = ss.subjectschedule_seq
                                INNER JOIN tblSubject sj
                                    ON ss.subject_seq = sj.subject_seq
                                     INNER JOIN tblOpenCourse oc
                                         ON rc.openCourse_seq = oc.openCourse_seq
                                            INNER JOIN tblteachercourse tc
                                                 on tc.opencourse_seq = oc.opencourse_seq
                                                     INNER JOIN tblteacher t
                                                          on t.teacher_seq = tc.teacher_seq                                                       
                                                              WHERE stu.student_seq = '받아온학생번호';
--                                        WHERE stu.student_seq = '1';

select * from tblscore;
delete from tblscore;