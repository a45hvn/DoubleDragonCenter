package com.test.DDC.admin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

import com.test.DDC.DBUtil;

public class AdminExamScore {
	
	private static Connection conn = null;
	private static Statement stat = null;
	private static ResultSet rs = null;
	private static DBUtil util = new DBUtil();
	private static Scanner scan = new Scanner(System.in);
	
	public void printExamScore() {
		
		boolean loop = true;
		
		
		while (loop) { // 
			System.out.println("============================================================");
			System.out.println("		[과정별 시험/성적 관리]");
			System.out.println("============================================================");
			
			Connection conn = null;
			Statement stat = null;
			ResultSet rs = null;
			
			try {
				conn = util.open();
				stat = conn.createStatement();
				
				String sql = "SELECT oc.openCourse_seq as 과정번호, cl.name as 과정명, oc.startDate || '~' || oc.endDate as 과정기간, t.name as 교사명, r.Name as 강의실" + 
						"    FROM tblCourselist cl" + 
						"        INNER JOIN tblOpenCourse oc" + 
						"            ON cl.courselist_seq = oc.courselist_seq" + 
						"                INNER JOIN tblRoom r" + 
						"                    ON oc.room_seq = r.room_seq" + 
						"                        INNER JOIN tblTeacherCourse tc" + 
						"                            ON tc.openCourse_seq = oc.openCourse_seq" + 
						"                                INNER JOIN tblTeacher t" + 
						"                                    ON tc.teacher_seq = t.teacher_seq" +
						"                                        order by oc.opencourse_seq";
				
				rs = stat.executeQuery(sql);
				System.out.println("과정번호\t\t과정명\t\t\t\t\t  과정기간\t\t교사명\t강의실");
				while (rs.next()) { //과정번호, 과정명, 과정기간, 교사명, 강의실
					
					String result = rs.getString("과정번호") + "\t" + rs.getString("과정명") + "\t" + rs.getString("과정기간")
					+ "\t" + rs.getString("교사명") + "\t"+ rs.getString("강의실");
					
					
					System.out.println(result);
					
//					System.out.println("---------------------------------------------------------");
						
					
				}
				System.out.println("0\t 뒤로가기");
				System.out.print("입력 : ");
				String num = scan.nextLine();
				
				System.out.println();
				System.out.println();
				conn.close();
				stat.close();
				
				if (Integer.parseInt(num)<19 && Integer.parseInt(num)>0 ) {
					try {
						conn = util.open();
						stat = conn.createStatement();
						rs = null;
						
						String sql2 = String.format("SELECT  DISTINCT ss.subjectschedule_seq as 과목번호, s.name as 과목명, ss.startDate || '~' || ss.endDate as 과목기간," + 
								"    CASE\r\n" + 
								"            WHEN sc.scoresubjective is not null then 'O'" + 
								"            WHEN sc.scoresubjective is null then 'X'" + 
								"    END as 성적등록여부    ," + 
								"    CASE" + 
								"            WHEN e.question is not null then 'O'" + 
								"            WHEN e.question is null then 'X'" + 
								"    END as 시험등록여부" + 
								"        FROM tblOpenCourse oc" + 
								"            INNER JOIN tblsubjectschedule ss" + 
								"                ON oc.openCourse_seq = ss.openCourse_seq" + 
								"                    INNER JOIN tblSubject s" + 
								"                        ON ss.subject_seq = s.subject_seq" + 
								"                            INNER JOIN tblscore sc" + 
								"                                ON sc.subjectschedule_seq = ss.subjectschedule_seq" + 
								"                                    INNER JOIN tblexam e" + 
								"                                        on e.subjectschedule_seq = ss.subjectschedule_seq" + 
								"                                            WHERE oc.openCourse_seq = %s", num);
												
						rs = stat.executeQuery(sql2);
						System.out.println("과목번호\t과목명\t  과목기간\t성적등록여부\t시험등록여부");
						while (rs.next()) { //과목번호, 과목명, 과목기간, 성적등록여부, 시험등록여부
							
							String result = rs.getString("과목번호") + "\t" + rs.getString("과목명") + "\t" + rs.getString("과목기간")
							+ "\t" + rs.getString("성적등록여부") + "\t"+ rs.getString("시험등록여부");
							
							
							System.out.println(result);
							
//							System.out.println("---------------------------------------------------------");
								
							
						}
						rs.close();
						
						System.out.print("입력 : ");
						String num2 = scan.nextLine();
						System.out.println();						
						System.out.println();
						conn.close();
						stat.close();
						
						try {
							conn = util.open();
							stat = conn.createStatement();
							rs = null;
							
							String sql3 = String.format("SELECT s.name as 과목명, oc.startDate || '~' || oc.endDate as 과목기간, oc.room_seq as 강의실명, t.name as 교사명, b.name as 교재명, stu.name as 학생명, stu.ssn as 주민번호, sc.scoresubjective as 필기, sc.scoreobjective as 실기" + 
									"    FROM tblOpenCourse oc\r\n" + 
									"            INNER JOIN tblsubjectschedule ss" + 
									"                ON oc.openCourse_seq = ss.openCourse_seq" + 
									"                    INNER JOIN tblSubject s" + 
									"                        ON ss.subject_seq = s.subject_seq" + 
									"                            INNER JOIN tblscore sc" + 
									"                                ON sc.subjectschedule_seq = ss.subjectschedule_seq" + 
									"                                    INNER JOIN tblRegiCourse rc" + 
									"                                        ON sc.regiCourse_seq = rc.regiCourse_seq" + 
									"                                            INNER JOIN tblStudent stu\r\n" + 
									"                                                ON rc.student_seq = stu.student_seq" + 
									"                                                    INNER JOIN tblcourselist cl" + 
									"                                                        on cl.courselist_seq = oc.courselist_seq" + 
									"                                                            INNER JOIN tblteachercourse tc" + 
									"                                                                on tc.opencourse_seq = oc.opencourse_seq" + 
									"                                                                    INNER JOIN tblteacher t" + 
									"                                                                        on t.teacher_seq = tc.teacher_seq" + 
									"                                                                            INNER JOIN tblbook b" + 
									"                                                                                on b.book_seq = s.book_seq" + 
									"                                                                                     WHERE oc.openCourse_seq = '%s' and ss.subjectschedule_seq = '%s'", num,num2);
													
							rs = stat.executeQuery(sql3);
							System.out.println("과목명\t\t과목기간\t강의실명\t교사명\t\t교재명\t\t\t학생명\t주민번호\t필기\t실기");
							while (rs.next()) {//과목명, 과목기간, 강의실명, 교사명, 교재명, 학생명, 주민번호, 필기, 실기
								
								String result = rs.getString("과목명") + "\t" + rs.getString("과목기간") + "\t" + rs.getString("강의실명")
								+ "\t" + rs.getString("교사명") + "\t"+ rs.getString("교재명")+ "\t"+ rs.getString("학생명")+ "\t"+ rs.getString("주민번호")+ "\t"+ rs.getString("필기")+ "\t"+ rs.getString("실기");
								
								
								System.out.println(result);
//								System.out.println("---------------------------------------------------------");
								
								
							}
							rs.close();
							conn.close();
							stat.close();
						} catch (Exception e) {
							// TODO: handle exception
						}
						loop = false;
						
						System.out.println();
						System.out.print("계속하시려면 엔터를 눌러주세요");						
						String num3 = scan.nextLine();
					} catch (Exception e) {
						e.printStackTrace();
						// TODO: handle exception
					}
				} else if (Integer.parseInt(num) == 0) {
					loop = false;
				} else {
					System.out.println("올바른 번호를 입력해주세요");
					System.out.println();
					System.out.print("계속하시려면 엔터를 눌러주세요");						
					String num3 = scan.nextLine();
					loop = false;
				}
				
				
				
				conn.close();
				stat.close();
				
				loop = false;
			} catch (Exception e) {
				e.printStackTrace();
			}
				
				
		}//while
		
		
		
	}

}
