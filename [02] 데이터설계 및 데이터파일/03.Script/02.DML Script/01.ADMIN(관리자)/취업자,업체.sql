--취업자정보(이름, 취업날짜, 회사명, 연봉) 출력
select s.name as 이름, e.employmentDate as 취업날짜, c.name as 회사명, c.salary as 연봉
from tblStudent s
    inner join tblRegiCourse rc
        on s.student_seq = rc.student_seq
            inner join tblemployment e
                on rc.regicourse_seq = e.regicourse_seq
                    inner join tblcompany c
                        on e.company_seq = c.company_seq;
                        
                        
--취업자 등록
insert into tblEmployment values (employment_seq.nextVal, to_date('취업날짜', 'yyyy-mm-dd'), 업체번호, 수강신청번호);

--취업자 수정
update tblEmployment set 컬럼명 = 값 where 조건;

--취업자 삭제
delete from tblEmployment where 조건;


--업체정보 출력
select * from tblCompany;

--업체 등록
insert into tblCompany values (company_seq.nextVal, '회사명', 연봉, '주소', '전화번호');

--업체 수정
update tblCompany set 컬럼명 = 값 where 조건;

--업체 삭제
delete from tblCompany where 조건;