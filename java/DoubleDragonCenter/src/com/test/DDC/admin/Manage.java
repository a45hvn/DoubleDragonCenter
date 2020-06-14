package com.test.DDC.admin;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;

import com.test.DDC.DBUtil;

import oracle.jdbc.OracleTypes;

public class Manage {
	
	
	/**
	 * 과정 이름을 정하고 과목을 구성합니다.
	 * @param name 과정이름
	 * @param sub1 1과목
	 * @param sub2 2과목
	 * @param sub3 3과목
	 * @param sub4 4과목
	 * @param sub5 5과목
	 * @param sub6 6과목
	 */
	public boolean procNewcourseListSubject(String name,int sub1,int sub2,int sub3,int sub4,int sub5,int sub6) {
		// TODO Auto-generated method stub
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();

		try {
			String sql = String.format("{call procNewcourseListSubject(?,?,?,?,?,?,?)}");
			conn = util.open();
			stat = conn.prepareCall(sql);
			
			stat.setString(1, name);
			stat.setInt(2, sub1);
			stat.setInt(3, sub2);
			stat.setInt(4, sub3);
			stat.setInt(5, sub4);
			stat.setInt(6, sub5);
			stat.setInt(7, sub6);
			stat.executeQuery();
			System.out.println("과정에 과목설정 완료");

			stat.close();
			conn.close();
			return true;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return false;
		}
	}
	/**
	 * 새로운 과정을 개설합니다.
	 * @param courselist_seq 과정목록 번호
	 * @param open	강의개설일
	 * @param room	강의실배정
	 */
	public boolean procOpenCourse(int courselist_seq,String open,int room) {
		// TODO Auto-generated method stub
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();

		try {
			String sql = String.format("{call procOpenCourse(?,?,?)}");
			conn = util.open();
			stat = conn.prepareCall(sql);
			stat.setInt(1,courselist_seq);
			stat.setString(2, open);
			stat.setInt(3,room);
			stat.executeQuery();
			
			System.out.println("개설과정 추가 완료");

			stat.close();
			conn.close();
			return true;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return false;
		}
	}//procOpenCourse
	
	/**
	 * 개설된 과정정보를 가져옵니다.
	 *  (0)PK
	 *	(1)개설과정번호
	 *	(2)과정명
	 *	(3)강의실
	 *	(4)수강생
	 *	(5)시작일
	 *	(6)종료일
	 *	(7)기간
	 */
	public ArrayList<String[]> procSearchOpencourse() {
		// TODO Auto-generated method stub
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();
		ArrayList<String[]> row=new ArrayList<String[]>(); 
		try {
			String sql = String.format("{call procSearchOpencourse(?)}");
			
			conn = util.open();
			stat = conn.prepareCall(sql);
			stat.registerOutParameter(1, OracleTypes.CURSOR);
			stat.executeQuery();
			rs=(ResultSet)stat.getObject(1);
			while(rs.next()) {
				String str=String.format("%s-%s-%s-%s-%s-%s-%s-%s"
						,rs.getString(1)//PK
						,rs.getString(2)//개설과정번호
						,rs.getString(3)//과정명
						,rs.getString(4)//강의실
						,rs.getString(5)//수강생
						,rs.getString(6).substring(0,10).replace("-", "")//시작일
						,rs.getString(7).substring(0,10).replace("-", "")//종료일
						,rs.getString(8));//기간
				String[] a=str.split("-");
				row.add(a);
				
			}
			
			stat.close();
			conn.close();
			return row;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return null;
	}//procSearchOpencourse
	/**
	 * 과정번호를 입력하면 과정정보를 가져옵니다.
	 * @param 과정번호
	 * @return 과정정보
	 *  (0)PK
	 *	(1)개설과정번호
	 *	(2)과정명
	 *	(3)강의실
	 *	(4)수강생
	 *	(5)시작일
	 *	(6)종료일
	 *	(7)기간
	 */
	public String[] procSearchOpencourse(int num) {
		// TODO Auto-generated method stub
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();
		ArrayList<String[]> row=new ArrayList<String[]>(); 
		try {
			String sql = String.format("{call procSearchOpencourse(?)}");
			
			conn = util.open();
			stat = conn.prepareCall(sql);
			stat.registerOutParameter(1, OracleTypes.CURSOR);
			stat.executeQuery();
			rs=(ResultSet)stat.getObject(1);
			while(rs.next()) {
				String str=String.format("%s-%s-%s-%s-%s-%s-%s-%s"
						,rs.getString(1)//PK
						,rs.getString(2)//개설과정번호
						,rs.getString(3)//과정명
						,rs.getString(4)//강의실
						,rs.getString(5)//수강생
						,rs.getString(6).substring(0,10).replace("-", "")//시작일
						,rs.getString(7).substring(0,10).replace("-", "")//종료일
						,rs.getString(8));//기간
				String[] a=str.split("-");
				row.add(a);
				
			}
			
			stat.close();
			conn.close();
			return row.get(num-1);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return null;
	}//procSearchOpencourse
	/**
	 * 입력한 과정번호에 수료일을 지정합니다(주말지정불가)
	 * @param opencourseNum 개설과정번호
	 * @param finishdate	수료일입력
	 */
	public void procAssignFinaldate(int opencourseNum,String finishdate) {
		// TODO Auto-generated method stub
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();
		
		Calendar c=Calendar.getInstance();
		c.set(Integer.parseInt(finishdate.substring(0, 4)),Integer.parseInt(finishdate.substring(4, 6))-1,Integer.parseInt(finishdate.substring(6, 8)));
	
		if(c.get(Calendar.DAY_OF_WEEK)==1||c.get(Calendar.DAY_OF_WEEK)==7) {
			System.out.println("주말은 수료일로 지정할 수 없습니다.");
		}else {
		try {
			String sql = String.format("{call procAssignFinaldate(?,?)}");

			conn = util.open();
			//conn.setAutoCommit(false);
			stat = conn.prepareCall(sql);
			
			stat.setInt(1,opencourseNum);
			stat.setString(2, finishdate);
			stat.executeQuery();
			
			System.out.println("수료날짜 지정 완료");
			stat.close();
			conn.close();
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("수료날짜 지정 실패");
			e.printStackTrace();
			
		}
		}
	}//procAssignFinaldate
	/**
	 * 개설된 과정의 과목정보를 가져옵니다.
	 * @param opencourseNum 개설과정 번호입력
	 *  (0)과목번호
	 *	(1)과정번호
	 *	(2)과목명
	 *	(3)시작일
	 *	(4)종료일
	 *	(5)과정시작일
	 *	(6)과정종료일
	 *	(7)강사명
	 */
	public ArrayList<String> procGetOpenCourseInfo(int opencourseNum) {
		// TODO Auto-generated method stub
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();
		ArrayList<String> row=new ArrayList<String>();
		try {
			String sql = String.format("{call procGetOpenCourseInfo(?,?)}");

			conn = util.open();
			stat = conn.prepareCall(sql);
			stat.setInt(1, opencourseNum);
			stat.registerOutParameter(2, OracleTypes.CURSOR);
			stat.executeQuery();
			rs=(ResultSet)stat.getObject(2);
			
			while(rs.next()) {
				String str=String.format("%s-%s-%s-%s-%s-%s-%s-%s"
						,rs.getString(1)//과목번호
						,rs.getString(5)//과정번호
						,rs.getString(2)//과목명
						,rs.getString(3).substring(0, 10).replace("-", "")//시작일
						,rs.getString(4).substring(0, 10).replace("-", "")//종료일
						,rs.getString(6).substring(0, 10).replace("-", "")//과정시작일
						,rs.getString(7).substring(0, 10).replace("-", "")//과정종료일
						,rs.getString(8));//강사명
				
				row.add(str);
			}
			
			stat.close();
			conn.close();
			return row;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return null;
	}//procGetOpenCourseInfo
	/**
	 * 개설된 과정에 등록한 학생정보를 가져옵니다.
	 * @param opencourseNum 개설과정번호 입력
	 *  (0)이름
	 *	(1)주민번호
	 *	(2)전화번호
	 *	(3)등록일
	 *	(4)과정번호
	 *	(5)과정명
	 *	(6)상태
	 */
	public ArrayList<String[]> procgetStudentInfo(int opencourseNum) {
		// TODO Auto-generated method stub
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();
		ArrayList<String[]> row=new ArrayList<String[]>();
		try {
			String sql="{call procgetStudentInfo(?,?)}";
			conn=util.open();
			stat=conn.prepareCall(sql);
			stat.setInt(1, opencourseNum);
			stat.registerOutParameter(2, OracleTypes.CURSOR);
			stat.executeQuery();
			
			rs=(ResultSet)stat.getObject(2);
			while(rs.next()) {
				String str=String.format("%s-%s-%s-%s-%s-%s-%s"
						,rs.getString(1)//이름
						,rs.getString(2).replace("-", "")//주민번호
						,rs.getString(3).replace("-", "")//전화번호
						,rs.getString(4).substring(0, 10).replace("-", "")//등록일
						,rs.getString(5)//개설과정번호
						,rs.getString(6)//과정명
						,rs.getString(7));//상태
				String[] temp=str.split("-");
				row.add(temp);
			}
			
			stat.close();
			conn.close();
			return row;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return null;
	}//procgetStudentInfo
	
	public boolean procDeleteopenCourse(int popencourse_seq) {//개설된 과정 지우기
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();

		try {
			String sql = "{call procDeleteopenCourse(?) }";
			
			conn = util.open();
			stat = conn.prepareCall(sql);
			stat.setInt(1, popencourse_seq);

			stat.executeQuery();

			stat.close();
			conn.close();
			return true;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return false;
		}
	}//procDeleteopenCourse
	
	public boolean procDeleteCourseList(int pcourseList_seq) {//과정 지우기
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();

		try {
			String sql = "{call procDeleteCourseList(?) }";
			conn = util.open();
			stat = conn.prepareCall(sql);
			stat.setInt(1, pcourseList_seq);
			stat.executeQuery();

			stat.close();
			conn.close();
			return true;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return false;
		}
	}//procDeleteCourseList
	
	public ArrayList<String[]> procSubject() {
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();
		ArrayList<String[]> row=new ArrayList<String[]>();

		try {
			String sql = "{call procSubject(?) }";
			conn = util.open();
			stat = conn.prepareCall(sql);
			stat.registerOutParameter(1, OracleTypes.CURSOR);
			stat.executeQuery();
			rs=(ResultSet)stat.getObject(1);
			while(rs.next()) {
				String str=String.format("%s-%s-%s"
						,rs.getString("번호")
						,rs.getString("이름")
						,rs.getString("기간"));
				String[] temp= {rs.getString("번호")
						,rs.getString("이름")
						,rs.getString("기간")};
				
				
				row.add(temp);
				}
			stat.close();
			conn.close();
			return row;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return null;
		}
	}//procSubject
	
	public void  procemployee() {
		Connection conn = null;
		CallableStatement stat = null;
		ResultSet rs = null;
		DBUtil util = new DBUtil();

		try {
			String sql = "{call procemployee(?) }";
			conn = util.open();
			stat = conn.prepareCall(sql);
			stat.registerOutParameter(1, OracleTypes.CURSOR);
			stat.executeQuery();
			
			rs=(ResultSet)stat.getObject(1);
			
			while(rs.next()) {
				
			}

			
			
			stat.close();
			conn.close();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}//procemployee
}
