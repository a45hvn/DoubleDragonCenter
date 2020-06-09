-- 1. 관리자 ? 7. 지원관리 및 조회 - a. 지원내역 - a. 일괄 조회 및 수정
-- 번호 학생명 교사명 과정명 연락처 출석률 지원일시 상담요청 내용(출석률이면 정상만 취급하는지? 조퇴나 이런건 빼고? 아직 안정함, 출석률 빼는걸 권장)
SELECT rownum, stu.name as studentName, t.name as teacherName, cl.name as courselistName, stu.tel as studentTel,  Ass.asdate as callasDate, Ass.asService as callasService
    FROM tblAs ass
        INNER JOIN tblRegiCourse rc
            ON ass.regiCourse_seq = rc.regiCourse_seq
                INNER JOIN tblOpenCourse oc
                    ON rc.openCourse_seq = oc.openCourse_seq
                        INNER JOIN tblCourselist cl
                            ON oc.courselist_seq = cl.courselist_seq
                                INNER JOIN tblTeacherCourse tc
                                    ON oc.openCourse_seq = tc.openCourse_seq
                                        INNER JOIN tblTeacher t
                                            ON tc.teacher_seq = t.teacher_seq
                                                INNER JOIN tblStudent stu
                                                    ON rc.student_seq = stu.student_seq;
select * from tblsubjectrating;
select *from tblattendance;
-- 지원요청 번호 저장(배열)
SELECT as_seq FROM tblas;

-- 수정하기와 삭제하기는 해당 요청날짜가 현재시간 이전은 불가능
SELECT asDate FROM tblas WHERE as_seq = '배열[입력한번호 -1]'; -- 요청날짜
SELECT sysdate FROM dual; -- 현재 날짜

-- 수정하기
UPDATE tblas SET asDate = '입력한 요청날짜', asService = '입력한 요청내용'
    WHERE as_seq = '배열[입력한번호-1]';

-- 삭제하기
DELETE FROM tblas WHERE as_seq = '배열[입력한번호-1]';



-- 1. 관리자 ? 7. 지원 관리 및 조회 - a. 지원내역 - b. 교사별 조회 및 수정 (53번)
-- a. 개설과정기간번호(PK) 배열에 저장
SELECT openCourse_seq FROM tblOpenCourse;

-- b. 출력구문
SELECT rownum, cl.name as courselistName, oc.startDate || '~' || oc.endDate as coureseDuration, t.name as teacherName, r.Name as className
    FROM tblCourselist cl
        INNER JOIN tblOpenCourse oc
            ON cl.courselist_seq = oc.openCourse_seq
                INNER JOIN tblRoom r
                    ON oc.room_seq = r.room_seq
                        INNER JOIN tblTeacherCourse tc
                            ON oc.openCourse_seq = tc.openCourse_seq
                                INNER JOIN tblTeacher t
                                    ON tc.teacher_seq = t.teacher_seq;

select * from tblcourselist;

-- 1. 관리자 ? 7. 지원관리 및 조회 - a. 지원내역 - b. 교사별 조회 및 수정 ? 1.선택(개설과정번호PK가 넘어옴)
-- 교사이름
SELECT t.name as teacherName
    FROM tblTeacher t
        INNER JOIN tblTeacherCourse tc
            ON t.teacher_seq = tc.teacher_seq
                INNER JOIN tblOpenCourse oc
                    ON tc.openCourse_seq = oc.openCourse_seq
                        WHERE oc.openCourse_seq = '개설과정번호PK가 저장된 배열[입력한번호-1]';

-- 과정명
SELECT cl.name as courselistName
    FROM tblCourselist cl
        INNER JOIN tblOpenCourse oc
            ON cl.courselist_seq = oc.courselist_seq
                WHERE oc.openCourse_seq = '개설과정번호PK가 저장된 배열[입력한번호-1]';

-- 번호, 학생명, 연락처,  지원일, 지원내용
SELECT rownum, stu.name as studentName, stu.tel as studentTel, ass.asDate as callasDate, ass.asservice as callasservice, ass.aslist as callaslist
    FROM tblStudent stu
        INNER JOIN tblRegiCourse rc
            ON stu.student_seq = rc.student_seq
                INNER JOIN tblAS ass
                    ON rc.regiCourse_seq = ass.regiCourse_seq
                        INNER JOIN tblOpenCourse oc
                            ON oc.openCourse_seq = rc.openCourse_seq
--WHERE oc.openCourse_seq = '13';
                                WHERE oc.openCourse_seq = '개설과정번호PK가 저장된 배열[입력한번호-1]';

-- 지원번호(PK) 배열에 저장
SELECT ass.as_seq as asNumber
    FROM tblStudent stu
        INNER JOIN tblRegiCourse rc
            ON stu.student_seq = rc.student_seq
                INNER JOIN tblAs ass
                    ON rc.regiCourse_seq = ass.regiCourse_seq
                        INNER JOIN tblOpenCourse oc
                            ON oc.openCourse_seq = rc.openCourse_seq
--WHERE oc.openCourse_seq = '1';
                                WHERE oc.openCourse_seq = '개설과정번호PK가 저장된 배열[입력한번호-1]';

-- 수정하기
UPDATE tblas SET asDate = '입력한 요청날짜', asservice = '입력한 요청내용'
    WHERE as_seq = '지원번호(PK) 배열[선택한번호-1]';

-- 삭제하기
DELETE FROM tblas
    WHERE as_seq = '지원번호(PK) 배열[선택한번호-1]';


-- 1. 관리자 ? 7. 지원 관리 및 조회 - a. 지원 내역 ? c. 학생별 조회 및 수정 - 검색
-- 학생명 입력받음
-- 학생명 주민번호뒷자리 전화번호 등록일 지원(요청)횟수 지원횟수랑 학생번호 빼기
SELECT rownum, stu.name as studentName, stu.ssn as studentPw, stu.tel as studentTel, ass.asDate as callasDate
    FROM tblStudent stu
        INNER JOIN tblRegiCourse rc
            ON stu.student_seq = rc.student_seq
                INNER JOIN tblAs ass
                    ON rc.regiCourse_seq = ass.regiCourse_seq
                        WHERE stu.name = '입력한 이름명';
                        
select * from tblas;                        

-- 지원번호(PK) 배열에 저장하기
SELECT ass.as_seq as asNumber
    FROM tblStudent stu
        INNER JOIN tblRegiCourse rc
            ON stu.student_seq = rc.student_seq
                INNER JOIN tblAs ass
                    ON rc.regiCourse_seq = ass.regiCourse_seq
                        WHERE stu.name = '입력한 이름명';


-- 1. 관리자 ? 7. 지원 관리 및 조회 - a. 지원 내역 ? c. 학생별 조회 및 수정 ? 검색 ? 조회 및 수정
-- 입력한 학생명 출력
-- 과정명
SELECT cl.name as courselistName
    FROM tblCourselist cl
        INNER JOIN tblOpenCourse oc
            ON cl.courselist_seq = oc.courselist_seq
                INNER JOIN tblRegiCourse rc
                    ON oc.openCourse_seq = rc.openCourse_seq
                        INNER JOIN tblAs ass
                            ON rc.regiCourse_seq = ass.regiCourse_seq
                                WHERE ass.consult_seq = '배열[입력받은번호-1]';

-- 내용 출력, 출석률이랑 학번 빼기
SELECT rownum, stu.name as studentName, stu.tel as studentTel,  ass.asDate as callasDate, ass.asservice as callasservice
    FROM tblAs ass
        INNER JOIN tblRegiCourse rc
            ON ass.regiCourse_seq = rc.regiCourse_seq
                INNER JOIN tblOpenCourse oc
                    ON rc.openCourse_seq = oc.openCourse_seq
                        INNER JOIN tblCourselist cl
                            ON oc.courselist_seq = cl.courselist_seq
                                INNER JOIN tblStudent stu
                                    ON stu.student_seq = rc.student_seq
                                        WHERE ass.as_seq = '배열[입력받은번호-1]';

-- 수정하기(요청번호는 삭제하기, 이미 앞에서 받아왔음)
UPDATE tblAs SET asDate = '입력받은 요청날짜', asservice = '입력받은 요청내용'
    WHERE as_seq = '배열[입력받은번호-1]';

-- 삭제하기(요청번호는 삭제하기, 이미 앞에서 받아옴
DELETE FROM tblAs
    WHERE as_seq = '배열[입력받은번호-1]';
    
    
_