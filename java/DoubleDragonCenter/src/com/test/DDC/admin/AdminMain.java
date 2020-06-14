package com.test.DDC.admin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Scanner;

import com.test.DDC.DBUtil;


public class AdminMain {
	
	private static Scanner scan = new Scanner(System.in);
//	private String id;
//	private String pw;
//	private DBUtil util;
	
	public static void main(String[] args) {
		
		adminLogin();
		
	}
	
	//로그인
	public static void adminLogin() {
	

		String id;
		String pw;
		DBUtil util = new DBUtil();
		
		System.out.println("============================================================");
		System.out.println("			[관리자 로그인]");
		System.out.println("============================================================");
		
		System.out.print("id : ");
		id = scan.nextLine();
		System.out.print("pw : ");
		pw = scan.nextLine();
		
		//로그인 유효성 검사
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		ArrayList<String> idList = new ArrayList<String>(10); //교사명 담을 list
		ArrayList<String> pwdList = new ArrayList<String>(10); //주민번호 뒷자리 담을 list
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			String sql = "select id,pwd from tblAdmin";
			
			rs = stat.executeQuery(sql);
			
			while (rs.next()) { // 교사 테이블 이름(아이디):주민번호(비밀번호) 가져오기
				
				String result = rs.getString("id") + "\t" + rs.getString("pwd");
				
				idList.add(rs.getString("id"));
				pwdList.add(rs.getString("pwd"));
				
//				System.out.println(result);
			}
			
			for(int i=0; i<idList.size(); i++) {
				if(idList.get(i).equals(id)){ //id 있을 경우
					if(pwdList.get(i).equals(pw)) {//pw 있을 경우
						//로그인 성공
						System.out.println("============================================================");
						System.out.printf("관리자로 로그인 되었습니다.\n");
						
						//메뉴 출력
						menu();
						break;
						
					}else {
						System.out.println("============================================================");
						System.out.println("비밀번호가 옳지 않습니다.");
						break;
					}
					
					
				}else {
					System.out.println("============================================================");
					System.out.println("없는 id입니다.");
					break;
				}
				
			}
			
		

			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	private static void menu() {
		//메인 메뉴
		System.out.println("============================================================");
		System.out.println("				[관리자]");
		System.out.println("============================================================");
		System.out.println("1. 교사 계정 관리");
		System.out.println("2. 개설 과정 및 개설 과목 관리");
		System.out.println("3. 교육생 관리");
		System.out.println("4. 기자재 관리");
		System.out.println("5. 시험 관리 및 성적 조회");
		System.out.println("6. 출결 관리 및 출결 조회");
		System.out.println("7. 과목 평가 조회");
		System.out.println("8. 취업자 조회 및 관리");
		System.out.println();
		System.out.println("0. 로그아웃");
		System.out.println("============================================================");
		
		System.out.print("입력 : ");
		String num = scan.nextLine();
		
		
		switch (num) {

		case "1":
			//교사계정관리
			AdminTeacher at = new AdminTeacher();
			at.printTeacher();
			
			break;
		case "2":
			//개설 과정 및 개설 과목 관리

			break;
		case "3":
			//교육생 관리

			break;
		case "4":
			//기자재 관리

			break;
		case "5":
			//시험 관리 및 성적 조회

			break;
		case "6":
			//출결 관리 및 출결 조회

			break;
		case "7":
			//과목 평가 조회

			break;
		case "8":
			//취업자 조회 및 관리

			break;
		case "0":
			//로그아웃
			
			return;

		}
		
		
	}
	
	
	
}
