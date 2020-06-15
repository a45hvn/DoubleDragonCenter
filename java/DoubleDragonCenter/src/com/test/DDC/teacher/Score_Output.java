package com.test.DDC.teacher;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Scanner;

import com.test.DDC.DBUtil;

import oracle.jdbc.OracleTypes;
import oracle.jdbc.oracore.OracleType;

public class Score_Output {
	
	private static Connection conn = null;
	private static Statement stat = null;
	private static ResultSet rs = null;
	CallableStatement cstmt = null;
	private static DBUtil util = new DBUtil();
	private static Scanner scan = new Scanner(System.in);
	
	ArrayList<String> subjectList = new ArrayList<String>();	//과목 ArrayList
	ArrayList<String> stuScoreList = new ArrayList<String>();	//학생 ArrayList
	
	
	public void printSubject() {
		
		boolean loop = true;
		
		while(loop) {
			
			System.out.println("================================================");
			System.out.println("\t\t[성적 입출력]");
			System.out.println("================================================");
			System.out.print("교사번호입력");
			int a=scan.nextInt();
			getSubList(a);
			System.out.println("[과목번호]\t[과정명]\t\t\t\t\t[강의실]\t\t[과정기간]\t\t\t[과목명]\t\t[과목기간]\t\t\t[교재명]\t\t\t[성적배점(필기/실기/출결)]\t\t[성적등록여부]");
			for(int i = 0; i<subjectList.size(); i++) {
				String[] array = subjectList.get(i).split("\t");
				System.out.printf("%5s\t%s\t%s ~ %s\t\t%s\t%s\t%s ~ %s\t\t%s\t\t%s/%s/%s\t%s\n"
							,array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7]
							,array[8],array[9],array[10],array[11]
							,array[12]);
			}//과목 출력	
			System.out.println("z. 뒤로가기");
			System.out.println("=================================================");
			System.out.print("-성적을 입력할 과목의 해당번호를 입력해주세요.");
			String b = scan.nextLine();
			for(int i = 0; i<subjectList.size(); i++) {
				String[] array = subjectList.get(i).split("\t");
				if(array[0] = b) {
					getStudentScore(b);
				}
			}
			
			System.out.println("[학생명][전화번호][수료여부][과목번호][과목명][시험번호][수강신청번호][필기점수][실기점수][출결점수][결과][시험날짜]");
			for(int i = 0; i<stuScoreList.size(); i++) {
				String[] array = stuScoreList.get(i).split("\t");
				System.out.printf("%5s\t%s\t%s\t%s\t\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n"
							,array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7]
							,array[8],array[9],array[10],array[11]
							);
			}//학생 점수 출력
			
			
			
			
			
		}
		
		
		
		
		
		
		
		
	}//printSubject
	
	private void getStudentScore(int sub_seq) {
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			stuScoreList.clear();
			String sql = "";
			sql = "{call procScoreSelectSub(?,?)}";			
			cstmt = conn.prepareCall(sql);
			
			cstmt.registerOutParameter(2, OracleTypes.CURSOR);
			cstmt.setInt(1, sub_seq);
			cstmt.executeUpdate();
			
			rs = (ResultSet)cstmt.getObject(2);
			
			while(rs.next()) {
				stuScoreList.add(rs.getString("학생명")+"\t"+rs.getString("전화번호")+"\t"+
						rs.getString("수료여부")+"\t"+rs.getString("과목번호")+"\t"
						+rs.getString("과목명")+"\t"+rs.getString("시험번호")+"\t"+rs.getString("수강신청번호")+"\t"
						+rs.getString("필기점수")+"\t"+rs.getString("실기점수")+"\t"+rs.getString("출결점수")+"\t"
						+rs.getString("결과")+"\t"+rs.getString("시험날짜"));
			}
			
			conn.close();
			rs.close();
			cstmt.close();
		} catch (Exception e) {
			System.out.println("오류 발생 - select ProcsubjectScore");
			e.printStackTrace();
		}
		
	}

	public void getSubList(int t_seq) {//교사번호 받아서 입력
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			subjectList.clear();
			String sql = "";
			sql = "{call procScoreSubject(?,?)}";			
			cstmt = conn.prepareCall(sql);
			
			cstmt.registerOutParameter(2, OracleTypes.CURSOR);
			cstmt.setInt(1, t_seq);
			cstmt.executeUpdate();
			
			rs = (ResultSet)cstmt.getObject(2);
			
			while(rs.next()) {
				subjectList.add(rs.getString("과목번호")+"\t"+rs.getString("과정명")+"\t"+rs.getString("강의실")
						+rs.getString("과정기간(시작)")+"\t"+rs.getString("과정기간(끝)")+"\t"+
						"\t"+rs.getString("과목명")+"\t"+
						rs.getString("과목기간(시작)")+"\t"+rs.getString("과목기간(끝)")+"\t"+
						rs.getString("교재명")+"\t"+rs.getString("실기배점")+"\t"+
						rs.getString("필기배점")+"\t"+rs.getString("출결배점")+"\t"+
						rs.getString("성적등록여부")+"\t");		
			}
			conn.close();
			rs.close();
			cstmt.close();
			
			
		} catch (Exception e) {
			System.out.println("오류 발생 - getSubList");
			e.printStackTrace();
		}
	}//getSubList
	
	
	
	
}//Score_Output
