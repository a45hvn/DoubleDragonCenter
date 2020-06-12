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
		
		
		System.out.println("============================================================");
		System.out.println("				[교사 계정 관리]");
		System.out.println("============================================================");
		teacherAccount("00"); //교사 리스트 저장
		System.out.println("[교사번호]\t[교사명]\t[주민번호 뒷자리]\t[전화번호]");
		for(int i=0; i<teacherList.size(); i++) {
			String[] array = teacherList.get(i).split("\t");
			System.out.printf("%s\t%s");
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
		
		switch(input) {
		
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
			//상세보기
			
			break;
		case "a":
		case "b":
		case "c":
			//계정 조작하기
			
			break;
		case "0":
			//뒤로가기
			return;
		}
		
		
	}
	
	
	private void teacherAccount(String input) {
		//교사 계정 관리
		
		try {

			conn = util.open();
			stat = conn.createStatement();
			
			String sql = null;
			
			switch(input) {
			
			case "00": //교사 리스트 저장
				sql = "select teacher_seq as seq, name, substr(ssn,8) as ssn, tel from tblTeacher";
				rs = stat.executeQuery(sql);
				
				while(rs.next()) {
					teacherList.add(rs.getString("seq") + "\t" + rs.getString("name") + "\t" + rs.getString("ssn") + "\t" + rs.getString("tel"));
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
