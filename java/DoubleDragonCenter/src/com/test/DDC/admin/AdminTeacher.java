package com.test.DDC.admin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.test.DDC.DBUtil;

public class AdminTeacher {
	
	private static Connection conn = null;
	private static Statement stat = null;
	private static ResultSet rs = null;
	private static DBUtil util = new DBUtil();
	
	public void printTeacher() {
		
		System.out.println("============================================================");
		System.out.println("			[교사 계정 관리]");
		System.out.println("============================================================");
		
	}
	
	private void teacherAccount() {
		//교사 계정 관리
		
		try {

			conn = util.open();
			stat = conn.createStatement();

			String sql = String.format("select * from tblTeacher");

			

			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}//teacherAccount()
	
}
