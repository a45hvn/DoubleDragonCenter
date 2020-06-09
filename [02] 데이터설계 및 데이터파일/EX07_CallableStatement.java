package com.test.jdbc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import oracle.jdbc.OracleTypes;

public class EX07_CallableStatement {
	
	public static void main(String[] args) {
		
		//Ex07_CallableStatement.java
		//1. Statement : 정적 쿼리
		//2. PreparedStatement : 동적 쿼리(매개변수)
		//3. CallableStatement : 프로시저 전용
		
		//m1();
		//m2();
		//m3();
		//m4();
		m5();
	}

	private static void m5() {
		Connection conn = null;
		CallableStatement stat = null;
		DBUtil util = new DBUtil();
		ResultSet rs = null;
		
		try {
		
			String sql = "{ call procM5(?) } ";
			
			conn = util.open();
			stat = conn.prepareCall(sql);
						
			stat.registerOutParameter(1, OracleTypes.CURSOR);
			
			stat.executeQuery();
			
			rs = (ResultSet)stat.getObject(1);
			
			while (rs.next()) {
				System.out.printf("%s - %s - %s - %s\n"
								, rs.getString("name")
								, rs.getString("age")
								, rs.getString("tel")
								, rs.getString("address"));
			}
			
			rs.close();
			stat.close();
			conn.close();
			
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	private static void m4() {
		Connection conn = null;
		CallableStatement stat = null;
		DBUtil util = new DBUtil();
		ResultSet rs = null;
		
		try {
			
			String sql = "{ call procM4(?,?) } ";
			
			conn = util.open();
			stat = conn.prepareCall(sql);
			
			stat.setString(1, "기획부");
			stat.registerOutParameter(2, OracleTypes.CURSOR);
			
			stat.executeQuery();			
			
			rs = (ResultSet)stat.getObject(2); // cursor == resultset
			
			while (rs.next()) {
				System.out.println(rs.getString("name"));
				System.out.println(rs.getString("jikwi"));
			}
			
			rs.close();
			stat.close();
			conn.close();
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}

	private static void m3() {
		Connection conn = null;
		CallableStatement stat = null;
		DBUtil util = new DBUtil();
		
		try {
			
			String name = "유재석";
			String sql = "{ call procM3(?,?,?) }";
			
			conn = util.open();
			stat = conn.prepareCall(sql);
			
			stat.setString(1, name);
			stat.registerOutParameter(2, OracleTypes.VARCHAR);
			stat.registerOutParameter(3, OracleTypes.NUMBER);
			
			stat.executeQuery();
			
			System.out.println(stat.getString(2));
			System.out.println(stat.getString(3));
			
			stat.close();
			conn.close();
						
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}

	private static void m2() {
		Connection conn = null;
		CallableStatement stat = null;
		DBUtil util = new DBUtil();
		
		try {
			
			String sql = "{ call procM2(?,?,?,?) }";
			
			conn = util.open();
			stat = conn.prepareCall(sql);
			
			//****
			stat.setString(1, "1001"); //in parameter
			stat.registerOutParameter(2, OracleTypes.VARCHAR); //out
			stat.registerOutParameter(3, OracleTypes.VARCHAR);
			stat.registerOutParameter(4, OracleTypes.VARCHAR);
			
			stat.executeQuery(); //select
			
			System.out.println(stat.getString(2));
			System.out.println(stat.getString(3));
			System.out.println(stat.getString(4));
			
			stat.close();
			conn.close();
			
			System.out.println("완료");
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}

	private static void m1() {
		
		//PreparedStatement(Text) = CallableStatment(Procedure)
		
		//매개변수가 있는 프로시저 호출하기
		Connection conn = null;
		CallableStatement stat = null;
		DBUtil util = new DBUtil();
		
		try {
			
			conn = util.open();
			
			String sql = "{ call procM1(?,?,?,?) }";
			
			stat = conn.prepareCall(sql);
			
			stat.setString(1, "호호호");
			//stat.setString(2, "20");
			stat.setInt(2, 20);
			stat.setString(3, "010-9999-9999");
			stat.setString(4, "서울시 강동구 천호동");
			
			stat.executeUpdate();
			
			stat.close();
			conn.close();
			
			System.out.println("완료");
			
		} catch (Exception e) {
			
		}
				
		
	}

}
