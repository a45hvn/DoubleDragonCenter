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