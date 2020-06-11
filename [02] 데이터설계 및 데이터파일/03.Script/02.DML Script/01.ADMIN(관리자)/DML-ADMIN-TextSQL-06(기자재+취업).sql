-- 관리자 + 기자재관리 + 취업

SELECT ti.item_seq as 기자재번호, ti.name as 기자재명, ti.itemqty as 기자재수량, ti.room_seq as 강의실
    FROM tblItem ti
        INNER JOIN tblroom tr
            ON tr.room_seq = ti.room_seq
                INNER JOIN tblCourselist cl
                    ON cl.Courselist_seq = ti.Courselist_seq                        
                        WHERE ti.room_seq = "입력받은 강의실 번호";
                        --WHERE ti.room_seq = 1;
                        
SELECT ti.item_seq as 기자재번호, ti.name as 기자재명, ti.itemqty as 기자재수량, cl.name as 과정명
    FROM tblItem ti
        INNER JOIN tblroom tr
            ON tr.room_seq = ti.room_seq
                INNER JOIN tblCourselist cl
                    ON cl.Courselist_seq = ti.Courselist_seq                        
                        WHERE cl.courselist_seq = "입력받은 과정번호";      
                        --WHERE cl.courselist_seq = 1;         
                        
INSERT INTO tblItem
    VALUES(Item_seq.nextval, '입력한 기자재명', '입력한 기자재수', '강의실번호', '과정번호');                        
    

select * from tblscore;
select * from tblsupplement;



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

