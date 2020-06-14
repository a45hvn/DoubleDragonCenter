package com.test.DDC.admin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Scanner;

import com.test.DDC.DBUtil;

public class AdminTeacher {
	
	private static Connection conn = null;
	private static Statement stat = null;
	private static ResultSet rs = null;
	private static DBUtil util = new DBUtil();
	private static Scanner scan = new Scanner(System.in);
	
	private static ArrayList<String> teacherList = new ArrayList<String>(10); //교사 목록 저장할 list
	
	public void printTeacher() {
		
		boolean loop = true;
		int result = 0;

		while (loop) {
			System.out.println("============================================================");
			System.out.println("		[교사 계정 관리]");
			System.out.println("============================================================");
			teacherAccount("00"); // 교사 리스트 저장
			System.out.println("[교사번호]\t[교사명]\t[주민번호 뒷자리]\t[전화번호]");
			for (int i = 0; i < teacherList.size(); i++) {
				String[] array = teacherList.get(i).split("\t");
				System.out.printf("%8s\t%4s\t\t%13s\t%s\t\n",array[0],array[1],array[2],array[3]);
			}
			System.out.println("============================================================");
			System.out.println("- 상세보기를 원하시면 해당 교사 번호를 입력해주세요.");
			System.out.println();
			System.out.println("a. 교사 정보 등록");
			System.out.println("b. 교사 정보 수정");
			System.out.println("c. 교사 정보 삭제");
			System.out.println();
			System.out.println("0. 뒤로가기");
			System.out.println("============================================================");
			System.out.print("입력 : ");
			String input = scan.nextLine();

			switch (input) {

			case "1":
			case "2":
			case "3":
			case "4":
			case "5":
			case "6":
			case "7":
			case "8":
			case "9":
			case "10":
				// 상세보기 (맡은 과정, 과목, 강의 가능 과목)
				
				break;
			case "a":
				// 교사 계정 등록
				teacherAccount(input);
				break;
			case "b":
				// 교사 계정 수정
				teacherModify();
				break;
			case "c":
				//교사 계정 삭제
				teacherDelete();
				break;
			case "0":
				// 뒤로가기
				loop=false;
				return;
			}
		} // while

	}
	
	private void teacherDelete() {
		// 교사 정보 삭제
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();

		try {

			conn = util.open();
			stat = conn.createStatement();

			int flag = 0;
			
			
			System.out.println("============================================================");
			System.out.println("		[교사 정보 삭제]");
			System.out.println("============================================================");
			System.out.println("삭제할 교사 번호 : ");
			System.out.print("입력 : ");
			String num = scan.nextLine();
			
			for(String s:teacherList) {
				//num이 교사리스트 번호 안에 있는 번호인지 유효성 검사
				if(s.contains(num)) { 
					flag = 1;
				}
			}
			
			if (flag == 1) {// 유효번호 있을 경우

				String sql = String.format("SELECT teacher_seq as seq,name, substr(ssn,8) as ssn, tel, (SELECT  LISTAGG(s.name, ',') WITHIN GROUP (ORDER BY s.name) as tAvlSubject as avlSubject" + 
						"    FROM tblTeacher t " + 
						"        INNER JOIN tblAvlSubject a " + 
						"            ON t.teacher_seq = a.teacher_seq " + 
						"                    INNER JOIN tblSubject s" + 
						"                        ON a.subject_seq = s.subject_seq" + 
						"                                where t.teacher_Seq = %s)" + 
						"        FROM tblTeacher\n" + 
						"         where teacher_seq = %s", num,num);
				
				rs = stat.executeQuery(sql);
				
				System.out.println("[교사번호]\t[교사명]\t[전화번호]\t[강의가능과목]");
				String reslut = rs.getString("seq") + "\t" + rs.getString("ssn") + "\t" + rs.getString("tel") + "\t" + rs.getString("avlSubject");
				System.out.println(reslut);
				System.out.println("------------------------------------------------------------");
				System.out.println("정말로 삭제하시겠습니까? (y/n)");
				System.out.print("입력 : ");
				String input = scan.nextLine();
				
				if(input.equals("y")) {
					sql = String.format("update tblTeacher set teacher_seq = -teacher_seq where teacher_seq = %s", num);
					stat.executeUpdate(sql);
					System.out.println("------------------------------------------------------------");
					System.out.println("수정이 완료되었습니다.");

					stat.close();
					conn.close();

					return;

				} else {
					System.out.println("------------------------------------------------------------");
					System.out.println("삭제가취소 되었습니다. 이전 화면으로 돌아갑니다.");

					stat.close();
					conn.close();
					return;
				}

			} else {
				System.out.println("------------------------------------------------------------");
				System.out.println("없는 교사 번호입니다. 이전 화면으로 돌아갑니다.");
				return;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}

	private void teacherModify() {
		//교사 정보 수정
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();

		try {
			conn = util.open();
			stat = conn.createStatement();

			int flag = 0;
			
			System.out.println("============================================================");
			System.out.println("		[교사 정보 수정]");
			System.out.println("============================================================");
			System.out.println("수정할 교사 번호 : ");
			String num = scan.nextLine();
			
			for(String s:teacherList) {
				//num이 교사리스트 번호 안에 있는 번호인지 유효성 검사
				if(s.contains(num)) { 
					flag = 1;
				}
			}
			
			if (flag == 1) { // 유효번호 있을 경우
				System.out.println("------------------------------------------------------------");
				System.out.println("수정할 필드를 선택하세요.");
				System.out.println("1. 이름");
				System.out.println("2. 주민번호");
				System.out.println("3. 전화번호");
				System.out.println("4. 등록일");
				System.out.println("5. 수료여부");
				System.out.println("------------------------------------------------------------");
				System.out.print("입력 : ");
				String input = scan.nextLine();
				System.out.println("------------------------------------------------------------");
				System.out.print("수정할 값을 입력하세요.");
				
				if(input.equals("2")) {
					System.out.println("주민번호는 '-'를 붙여서 입력해주세요.");
				}else if(input.equals("3")) {
					System.out.println("전화번호는 '-'를 붙여서 입력해주세요.");
				}else if(input.equals("4")) {
					System.out.println("등록일은 YYYY-MM-DD 형식으로 기입해주세요.");
				}else {
					System.out.println("수료여부는 수료/탈락 두가지 형식중 하나만 입력하세요.");
				}
				
				System.out.println();
				System.out.print("입력 : ");
				String modify = scan.nextLine();
				
				//수정할 값 유효성 검사
				if(input.equals("2") && !modify.contains("-") && modify.length() != 14) {
					System.out.println("주민번호 기입이 올바르지 않습니다.");
					return;
				}else if(input.equals("3") && !modify.contains("-")) {
					System.out.println("전화번호 기입이 올바르지 않습니다.");
					return;
				} else if (input.equals("4") && !modify.contains("-") && modify.length() != 10) {
					System.out.println("등록일 형식이 올바르지 않습니다.");
					return;
				} else {
					String sql = null;
					switch (input) {
					case "1":
						sql = String.format("update tblTeacher set name='%s' where teacher_seq = '%s'", modify, num);
						stat.executeUpdate(sql);
						break;
					case "2":
						sql = String.format("update tblTeacher set ssn='%s' where teacher_seq = '%s'", modify, num);
						stat.executeUpdate(sql);
						break;
					case "3":
						sql = String.format("update tblTeacher set tel='%s' where teacher_seq = '%s'", modify, num);
						stat.executeUpdate(sql);
						break;
					case "4":
						sql = String.format(
								"update tblTeacher set regiDate=to_date('%s','yyyy-mm-dd') where teacher_seq = '%s'",
								modify, num);
						stat.executeUpdate(sql);
						break;
					}
				}
				
				System.out.println("------------------------------------------------------------");
				System.out.println("수정이 완료되었습니다.");
				
				stat.close();
				conn.close();

			} else {
				System.out.println("------------------------------------------------------------");
				System.out.println("없는 교사 번호입니다. 이전 화면으로 돌아갑니다.");
				return;
			}	

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}//teacherModify()
	
	
	private void teacherAccount(String input) {
		//교사 계정 관리 + 등록
		
		try {

			conn = util.open();
			stat = conn.createStatement();
			
			String sql = null;
			
			teacherList.clear();
			sql = "select teacher_seq as seq, name, substr(ssn,8) as ssn, tel from tblTeacher where teacher_seq > 0";
			rs = stat.executeQuery(sql);
			
			while(rs.next()) {
				teacherList.add(rs.getString("seq") + "\t" + rs.getString("name") + "\t" + rs.getString("ssn") + "\t" + rs.getString("tel"));
			}

			switch(input) {

			case "a": //교사 계정 등록
				System.out.println("============================================================");
				System.out.println("			[교사 정보 등록]");
				System.out.println("============================================================");
				System.out.print("교사이름 : ");
				String name = scan.nextLine();
				System.out.print("주민번호 : ");
				String ssn = scan.nextLine();
				System.out.print("전화번호 : ");
				String tel = scan.nextLine();
				System.out.println("------------------------------------------------------------");
				System.out.println("이대로 등록하시겠습니까? (y/n) : ");
				String answer = scan.nextLine();
				
				if(answer.equals("y")) {
					sql = String.format("insert into tblTeacher values (teacher_seq.nextVal,'%s','%s','%s')", name,ssn,tel);
					stat.executeUpdate(sql);					
				}else {
					return;
				}
				break;
			}

			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}//teacherAccount()
	
}
