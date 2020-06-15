package com.test.DDC.student;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Scanner;

import com.test.DDC.DBUtil;


public class StudentMain {
	
	private static Scanner scan = new Scanner(System.in);
//	private String id;
//	private String pw;
//	private DBUtil util;
	
	public static void main(String[] args) {
		
		//StudentLogin();
		menu();
		//stAttendanceMenu();
		//stScore();
	}
	
	//로그인
	public static void StudentLogin() {
	

		String id;
		String pw;
		DBUtil util = new DBUtil();
		
		System.out.println("============================================================");
		System.out.println("학생");
		System.out.println("============================================================");
		
		System.out.print("id : ");
		id = scan.nextLine();
		System.out.print("pw : ");
		pw = scan.nextLine();
		
		//로그인 유효성 검사
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		ArrayList<String> idList = new ArrayList<String>(570); //교육생명 담을 list
		ArrayList<String> pwdList = new ArrayList<String>(570); //주민번호 뒷자리 담을 list
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			String sql = "select name, substr(ssn,8) as ssn from tblStudent";
			
			rs = stat.executeQuery(sql);
			
			while (rs.next()) { //이름(아이디):주민번호(비밀번호) 가져오기
				
				String result = rs.getString("name") + "\t" + rs.getString("ssn");
				
				idList.add(rs.getString("name"));
				pwdList.add(rs.getString("ssn"));
				
				System.out.println(result);
			}
			
			for(int i=0; i<idList.size(); i++) {
				if(idList.get(i).equals(id)){ //id 있을 경우
					if(pwdList.get(i).equals(pw)) {//pw 있을 경우
						//로그인 성공
						System.out.println("============================================================");
						System.out.println("로그인 되었습니다.");
						
						//메뉴 출력
						menu();
						
					}else {
						System.out.println("============================================================");
						System.out.println("비밀번호가 옳지 않습니다.");
					}
					
					
				}else {
					System.out.println("============================================================");
					System.out.println("없는 id입니다.");
				}
				
			}
			
		

			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	

	private static void menu() {
		
		DBUtil util = new DBUtil();
		
		System.out.println("============================================================");
		System.out.println("학생");
		System.out.println("============================================================");
		
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			String sql = "select st.name as 학생명, st.ssn, st.tel, to_char(st.regidate, 'yyyy-mm-dd') as 등록일, cl.name as 과정명, to_char(oc.startDate, 'yyyy-mm-dd') as 시작일, to_char(oc.endDate, 'yyyy-mm-dd') as 종료일, r.name as 강의실" + 
					"    from tblregicourse rc" + 
					"        inner join tblStudent st" + 
					"            on rc.student_seq = st.student_seq" + 
					"                inner join tblopencourse oc" + 
					"                    on oc.openCourse_seq = rc.opencourse_seq" + 
					"                        inner join tblCourseList cl" + 
					"                            on cl.courselist_seq = oc.courselist_seq" + 
					"                                inner join tblRoom r" + 
					"                                    on r.room_seq = oc.room_seq" + 
					"                                        where rc.student_seq = 363";
			
			rs = stat.executeQuery(sql);
			
			//System.out.println(rs);
			
			while (rs.next()) { // 학생명, 주민번호, 전화번호, 등록일, 과정명, 시작일, 종료일, 강의실명
				
				String result = rs.getString("학생명") + "\t" + rs.getString("ssn") + "\t" + rs.getString("tel")
						+ "\t" + rs.getString("등록일") + "\t";
				
				String result2 =  rs.getString("과정명") + "\t" + rs.getString("시작일")
				+ "\t" + rs.getString("종료일") + "\t" + rs.getString("강의실");
				System.out.println("이름\t\t주민등록번호\t전화번호\t\t등록일");
				System.out.println(result);
				System.out.println("---------------------------------------------------------");
				System.out.println("과정명\t\t\t\t\t\t과정시작일\t\t과정종료일\t\t강의실명");
				System.out.println(result2);
			}
			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
			
		
		//메인 메뉴
		System.out.println("============================================================");
		System.out.println("학생");
		System.out.println("============================================================");
		System.out.println("1. 과정 및 과목 조회");
		System.out.println("2. 출결 조회");
		System.out.println("3. 성적 조회");
		System.out.println("4. 보충 학습 조회");
		System.out.println("5. 과목 평가");
		System.out.println();
		System.out.println("0. 뒤로가기");
		System.out.println("============================================================");
		
		System.out.print("입력 : ");
		String num = scan.nextLine();
		
		
		switch (num) {

		case "1":
			//과정 및 과목 조회
			stCourse();
			break;
			
		case "2":
			//근태 관리
			stAttendanceMenu();
			break;
			
		case "3":
			//성적 조회
			stScore();
			break;
			
		case "4":
			//보충학습
			stSup();
			break;
			
		case "5":
			//과목평가
			stRatingMenu();
			break;

		case "0":
			return;

		}

	}

	
	
	private static void stSup() { //보충 학습
		
		
		
	}

	private static void stRatingMenu() { //과목 평가 메뉴
		
		System.out.println("============================================================");
		System.out.println("3. 학생 - 5. 과목 평가");
		System.out.println("============================================================");
		System.out.println("1. 과목 평가 하기");
		System.out.println("2. 과목 평가 조회");
		System.out.println();
		System.out.println("0. 뒤로가기");
		System.out.println("============================================================");
		
		System.out.print("입력 : ");
		String num = scan.nextLine();
		
		
		switch (num) {

		case "1":
			//과목 평가 하기
			stWrRating();
			break;
			
		case "2":
			//과목 평가 조회
			stRating();
			break;
			
		case "0":
			return;

		}
		
		
	}

	private static void stWrRating() { //과목 평가 하기
		
		
		
	}

	private static void stRating() { //과목 평가 조회
		
		DBUtil util = new DBUtil();
		
		System.out.println("============================================================");
		System.out.println("3. 학생 - 5. 과목 평가 조회");
		System.out.println("============================================================");
		
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			String sql = "select sub.name, sr.ratingscore, sr.ratingcontents" + 
					" from tblSubjectRating sr" + 
					"    inner join tblRegiCourse rc" + 
					"        on sr.regiCourse_seq=rc.regiCourse_seq" + 
					"            inner join tblStudent st" + 
					"                on st.student_seq=rc.student_seq" + 
					"                    inner join tblSubjectSchedule sch" + 
					"                        on sch.subjectSchedule_seq=sr.subjectSchedule_seq" + 
					"                            inner join tblSubject sub" + 
					"                                on sub.subject_seq=sch.subject_seq" + 
					" where rc.regiCourse_seq=363";
			
			
			rs = stat.executeQuery(sql);
			
			
			while (rs.next()) { // 과목명, 평점, 평가내용
				
				String result = rs.getString("name") + "\t\t" + rs.getString("ratingscore") + "\t\t" + rs.getString("ratingcontents");
				
				System.out.println("과목명\t\t\t평점\t\t평가내용");
				System.out.println(result);
			}
			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	
	private static void stScore() { //성적 조회
		
		DBUtil util = new DBUtil();
		
		System.out.println("============================================================");
		System.out.println("3. 학생 - 3. 성적 조회");
		System.out.println("============================================================");
		
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			String sql = "select sj.subject_seq ,sj.name as 과목명, sc.score_seq as 시험번호, sc.regicourse_seq as 수강신청번호," + 
					" scp.percentsubjective as 필기배점, scp.percentobjective as 실기배점, scp.percentatt as 출결배점, sc.scoresubjective as 필기점수," + 
					" sc.scoreobjective as 실기점수, sc.scoreatt as 출결점수, sc.scoreresult as 결과, to_char(ss.enddate, 'yyyy-mm-dd') as 시험날짜, ex.question as 시험문제" + 
					"    from tblscore sc" + 
					"        inner join tblscorepercent scp" + 
					"                on scp.subjectschedule_seq = sc.subjectschedule_seq" + 
					"                    inner join tblsubjectschedule ss" + 
					"                        on ss.subjectschedule_seq = sc.subjectschedule_seq" + 
					"                        inner join tblsubject sj" + 
					"                            on sj.subject_seq = ss.subject_seq" + 
					"                                inner join tblexam ex" + 
					"                                    on ex.subjectschedule_seq = ss.subjectschedule_seq" + 
					"                                        where sc.regicourse_seq = 9"; //결과값이 없음...........
			
					
			
			rs = stat.executeQuery(sql);
			
			
			while (rs.next()) { // 
				
				String result = rs.getString("subject_seq") + "\t\t" + rs.getString("과목명") + "\t" + rs.getString("시험번호") + "\t\t"
					+ rs.getString("수강신청번호") + "\t\t" + rs.getString("필기배점") + "\t\t" + rs.getString("실기배점") + "\t\t"
					+ rs.getString("출결배점") + "\t\t" + rs.getString("필기점수") + "\t" + rs.getString("실기점수")
					+ "\t" + rs.getString("출결점수") + "\t" + rs.getString("결과") + "\t" + rs.getString("시험날짜") + "\t"
					+ rs.getString("시험문제") ;
				
				System.out.println("과목번호\t\t과목명\t\t시험번호\t학생번호\t필기배점\t실기배점\t출결배점\t필기\t실기\t출결\t결과\t시험날짜\t\t시험문제");
				System.out.println(result);
			}
			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	private static void stAttendanceMenu() { //출결 메뉴
		
		System.out.println("============================================================");
		System.out.println("3. 학생 - 2. 출결 조회");
		System.out.println("============================================================");
		System.out.println("1. 근태 관리");
		System.out.println("2. 전체 출결 조회");
		System.out.println("3. 월별 출결 조회");
		System.out.println("4. 일별 출결 조회");
		System.out.println();
		System.out.println("0. 뒤로가기");
		System.out.println("============================================================");
		
		System.out.print("입력 : ");
		String num = scan.nextLine();
		
		
		switch (num) {

		case "1":
			//근태 관리
			stAd();
			break;
		case "2":
			//전체 출결 조회
			allStAd();
			break;
		case "3":
			//월별 출결 조회
			monthStAd();
			break;
		case "4":
			//일별 출결 조회
			datetStAd();
			break;
		case "0":
			return;

		}
		
		
	}

	private static void datetStAd() { //일별 출결 조회 
		
		DBUtil util = new DBUtil();
		
		System.out.println("============================================================");
		System.out.println("3. 학생 - 2. 출결 조회 - 4. 일별 출결 조회");
		System.out.println("============================================================");
		
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			System.out.print("입력(ex.0120) : ");
			String date = scan.nextLine();
			
			String sql = "select s.student_seq as 학생번호, ad.workon as 입실시간, ad.workoff as 퇴실시간, ad.state as 출결상태" + 
					" from tblStudent s inner join tblRegiCourse rc on s.student_seq = rc.student_seq" + 
					" inner join tblAttendance ad on rc.regicourse_seq = ad.regicourse_seq" + 
					" where s.student_seq = 363 and to_char(ad.workOn, 'mmdd') = '" + date + "'" + 
					" order by workon";
					
			
			rs = stat.executeQuery(sql);
			
			
			while (rs.next()) { // 학생번호, 입실시간, 퇴실시간, 출결상태
				
				String result = rs.getString("학생번호") + "\t\t" + rs.getString("입실시간") + "\t\t" + rs.getString("퇴실시간") + "\t\t" + rs.getString("출결상태");
				
				System.out.println("학생번호\t입실시간\t\t\t\t퇴실시간\t\t\t\t출결상태");
				System.out.println("---------------------------------------------------------");
				System.out.println(result);
			}
			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	private static void monthStAd() { //월별 출결 조회
		
		DBUtil util = new DBUtil();
		
		System.out.println("============================================================");
		System.out.println("3. 학생 - 2. 출결 조회 - 3. 월별 출결 조회");
		System.out.println("============================================================");
		
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			System.out.print("입력(01~12) : ");
			String month = scan.nextLine();
			
			String sql = "select s.student_seq as 학생번호, ad.workon as 입실시간, ad.workoff as 퇴실시간, ad.state as 출결상태" + 
					" from tblStudent s inner join tblRegiCourse rc on s.student_seq = rc.student_seq" + 
					" inner join tblAttendance ad on rc.regicourse_seq = ad.regicourse_seq" + 
					" where s.student_seq = 363 and to_char(ad.workOn, 'mm') = '" + month + "'" + 
					" order by workon";
			
			
			rs = stat.executeQuery(sql);
			
			
			while (rs.next()) { // 학생번호, 입실시간, 퇴실시간, 출결상태
				
				String result = rs.getString("학생번호") + "\t\t" + rs.getString("입실시간") + "\t\t" + rs.getString("퇴실시간") + "\t\t" + rs.getString("출결상태");
				
				System.out.println("학생번호\t입실시간\t\t\t\t퇴실시간\t\t\t\t출결상태");
				System.out.println("---------------------------------------------------------");
				System.out.println(result);
			}
			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	private static void allStAd() { //전체 출결 조회
		
		DBUtil util = new DBUtil();
		
		System.out.println("============================================================");
		System.out.println("3. 학생 - 2. 출결 조회 - 2. 전체 출결 조회");
		System.out.println("============================================================");
		
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			String sql = "select s.student_seq as 학생번호, ad.workon as 입실시간, ad.workoff as 퇴실시간, ad.state as 출결상태" + 
					" from tblStudent s inner join tblRegiCourse rc on s.student_seq = rc.student_seq" + 
					" inner join tblAttendance ad on rc.regicourse_seq = ad.regicourse_seq" + 
					" where s.student_seq = 363" + 
					" order by workon";
					
			
			rs = stat.executeQuery(sql);
			
			
			while (rs.next()) { // 학생번호, 입실시간, 퇴실시간, 출결상태
				String result = rs.getString("학생번호") + "\t\t" + rs.getString("입실시간") + "\t\t" + rs.getString("퇴실시간") + "\t\t" + rs.getString("출결상태");
				
				System.out.println("학생번호\t입실시간\t\t\t\t퇴실시간\t\t\t\t출결상태");
				System.out.println("---------------------------------------------------------");
				System.out.println(result);
			}
			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	
	private static void stAd() { //근태 관리
		
		System.out.println("============================================================");
		System.out.println("3. 학생 - 2. 출결 조회 - 1. 근태 관리");
		System.out.println("============================================================");
		System.out.println("1. 입실하기");
		System.out.println("2. 퇴실하기");
		System.out.println();
		System.out.println("0. 뒤로가기");
		System.out.println("============================================================");
		
		System.out.print("입력 : ");
		String num = scan.nextLine();
		
		
		switch (num) {

		case "1":
			//입실
			adOn();
			break;
		case "2":
			//퇴실
			adOff();
			break;
		
		case "0":
			return;

		}
		
	}

	private static void adOff() { //퇴실 ----조건 고치기
		
		DBUtil util = new DBUtil();
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		Calendar cal = Calendar.getInstance();		

		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		int day = cal.get(Calendar.DAY_OF_MONTH);
		int hour = cal.get(Calendar.HOUR_OF_DAY);
		int min = cal.get(Calendar.MINUTE);
		int sec = cal.get(Calendar.SECOND);
		
		SimpleDateFormat ibsil = new SimpleDateFormat("yyyyMMddHHmm");
		SimpleDateFormat ibsil2 = new SimpleDateFormat("yyyyMMdd");
		String todayibsil = ibsil.format(cal.getTime());
		String todayibsil2 = ibsil2.format(cal.getTime());
		System.out.println(todayibsil);
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			
//			String sql = "insert into tblAttendance (attendance_seq, regiCourse_Seq, workon, workoff, state)" + 
//					"    values (attendance_seq.nextVal, '363', to_date('" + todayibsil +"','yyyy-mm-dd hh24:mi'), null, " + 
//					"        case when to_date('"+ todayibsil +"','yyyymmddhh24:mi') > to_date('" + todayibsil2 +"09:00','yyyymmddhh24:mi') then '지각'" + 
//					"            else '결석' end)";
			
			
			String sql = "update tblAttendance set workoff = to_date('" + todayibsil + "','yyyy-mm-dd hh24:mi'), " + 
					"    state = case when to_date('" + todayibsil + "','yyyymmddhh24:mi') > to_date('" + todayibsil2 + "18:00','yyyymmddhh24:mi')  then '정상출석'" + 
					"        else '조퇴' end" + 
					"            where workon=to_date('" + todayibsil2 +"','yyyy-mm-dd') and regicourse_seq='364'";
//			and workon < to_date('" + todayibsil2 +"09:00','yyyymmddhh24:mi')
			
			
			int result = stat.executeUpdate(sql);
			
			if(result > 0) {
				System.out.println("퇴실 완료");
			} else {
				System.out.println("퇴실 실패");
			}
			

			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	private static void adOn() { //입실
		
		DBUtil util = new DBUtil();
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		Calendar cal = Calendar.getInstance();		

		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		int day = cal.get(Calendar.DAY_OF_MONTH);
		int hour = cal.get(Calendar.HOUR_OF_DAY);
		int min = cal.get(Calendar.MINUTE);
		int sec = cal.get(Calendar.SECOND);
		
		SimpleDateFormat ibsil = new SimpleDateFormat("yyyyMMddHHmm");
		SimpleDateFormat ibsil2 = new SimpleDateFormat("yyyyMMdd");
		String todayibsil = ibsil.format(cal.getTime());
		String todayibsil2 = ibsil2.format(cal.getTime());
		System.out.println(todayibsil);
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			
			String sql = "insert into tblAttendance (attendance_seq, regiCourse_Seq, workon, workoff, state)" + 
					"    values (attendance_seq.nextVal, '364', to_date('" + todayibsil +"','yyyy-mm-dd hh24:mi'), null, " + 
					"        case when to_date('"+ todayibsil +"','yyyymmddhh24:mi') > to_date('" + todayibsil2 +"09:00','yyyymmddhh24:mi') then '지각'" + 
					"            else '결석' end)";
			
			
			int result = stat.executeUpdate(sql);
			
			if(result > 0) {
				System.out.println("입실 완료");
			} else {
				System.out.println("입실 실패");
			}
			

			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
	}

	private static void stCourse() { //과정 및 과목 조회
		
		DBUtil util = new DBUtil();
		
		System.out.println("============================================================");
		System.out.println("3. 학생 - 1. 과정 및 과목 조회");
		System.out.println("============================================================");
		
		
		Connection conn = null;
		Statement stat = null;
		ResultSet clRs = null;
		ResultSet sRs = null; //과목
		
		try {
			conn = util.open();
			stat = conn.createStatement();
			
			//과정명
			String clSql = "select cl.name as 과정명" + 
					"    from tblRegiCourse rc" + 
					"        inner join tblOpenCourse oc" + 
					"            on rc.opencourse_seq = oc.opencourse_seq" + 
					"                inner join tblCourseList cl" + 
					"                    on oc.courselist_seq = cl.courselist_seq" + 
					"                        inner join tblStudent st" + 
					"                            on st.student_seq = rc.student_seq" + 
					"                                where rc.student_seq = 363";
			
			clRs = stat.executeQuery(clSql);
			
			//System.out.println(clRs);
			
			while (clRs.next()) { //과정명
				
				String result = clRs.getString("과정명") ;

				
				System.out.print("과정 : " + result + "\n");
				System.out.println("---------------------------------------------------------");
			}
			
			
			
			//과목
			String sSql = "select distinct rc.student_seq, s.subject_seq, s.name as 과목명, to_char(ss.startDate, 'yyyy-mm-dd') as 시작일, to_char(ss.endDate, 'yyyy-mm-dd') as 종료일, b.name as 교재명" + 
					"    from tblregicourse rc" + 
					"        inner join tblOpenCourse oc" + 
					"            on rc.openCourse_seq = oc.opencourse_seq" + 
					"                inner join tblSubjectSchedule ss" + 
					"                    on oc.openCourse_seq = ss.opencourse_seq" + 
					"                        inner join tblSubject s" + 
					"                            on ss.subject_seq = s.subject_seq" + 
					"                                inner join tblBook b" + 
					"                                    on b.book_seq = s.book_seq" + 
					"                                        inner join tblavlsubject avs" + 
					"                                            on s.subject_seq = avs.subject_seq" + 
					"                                                    where rc.student_seq = 363" + 
					"                                                        order by subject_seq";
			
			sRs = stat.executeQuery(sSql);
			
			//System.out.println(sRs);
			
			System.out.println("학생번호\t과목번호\t\t과목명\t\t과목기간\t\t\t\t\t\t\t교재명");
			System.out.println("---------------------------------------------------------");
			
			while (sRs.next()) { // 학생번호, 과목번호, 과목명, 과목기간, 교재명
				
				String result = sRs.getString("student_seq") + "\t\t" +  sRs.getString("subject_seq") + "\t\t\t" + sRs.getString("과목명") + "\t"
							+ sRs.getString("시작일") +  " ~ " + sRs.getString("종료일") + "\t" + sRs.getString("교재명");

				System.out.println(result);
			}
			
			
			stat.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
