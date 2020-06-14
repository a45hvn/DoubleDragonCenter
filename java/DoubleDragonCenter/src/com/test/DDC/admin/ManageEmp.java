package com.test.DDC.admin;

import java.util.ArrayList;
import java.util.Scanner;

public class ManageEmp {
	static Manage m = new Manage();
	public void exe() {
		//getAllEmployee();// 모든 취업자 검색
		//getEmpByname();//이름으로 검색
		//getEmpByCourse();//과정번호로 검색
		setEmp();
		
	}//exe
	private void setEmp() {
		// TODO Auto-generated method stub
		//학생 정보와 회사 정보를 보여줘야하지 않나?
		Scanner scan=new Scanner(System.in);
		System.out.println("===========================================================");
		System.out.println("1. 관리자 -8.취업자 조회 및 관리 기능 - 등록하기");
		System.out.println("===========================================================");
		//수강신청번호를 입력하기 전에 이름을 검색하면 동명이인 찾아주기?
		System.out.print("1. 수강신청번호를 입력하세요 : ");
		int pregicourse_seq=scan.nextInt();
		//회사번호 입력하기 전에 회사이름을 검색하면 분점검색해주기?
		System.out.print("2. 회사번호를 입력하세요 : ");
		int pcompany=scan.nextInt();
		System.out.print("3. 취업날짜를 입력하세요 : (yyyymmdd) ");
		scan.skip("\r\n");
		String pday=scan.nextLine();

		
		m.procsetemp(pregicourse_seq, pcompany, pday);
	}
	private void getEmpByCourse() {
		// TODO Auto-generated method stub
		System.out.println("===========================================================");
		System.out.println("1. 관리자 -8.취업자 조회 및 관리 기능(과정번호로 검색)");
		System.out.println("===========================================================");
		String header=String.format("[%s] [%s] [%s] [%s] [%s]   [%s]      [%s]","번호","수강신청번호","학생이름","회사번호","회사이름","연봉","취업일");
		
		Scanner scan=new Scanner(System.in);
		ArrayList<String[]> row= new ArrayList<String[]>();
		System.out.print("검색할 과정 번호를 입력하세요 : ");
		int opencourse_seq=scan.nextInt();
		row=m.procempbycourse(opencourse_seq);
		int i=0;
		
		
		System.out.println(header);
		while(i<row.size()) {
		
			String temp=String.format(" %3d      %3s       %s     %s    %6s    %,d만원      %s"
											,i+1
											,row.get(i)[0]
											,row.get(i)[2]
											,row.get(i)[3]
											,row.get(i)[4]
											,Integer.parseInt(row.get(i)[5])/10000
											,row.get(i)[6]
													);
			
			if((i+1)%30==0) {
				System.out.println("-----------------------------------------------------------");
				System.out.printf("\t\t\t%d 쪽/%d쪽 \n",(i/30)+1,(row.size()+1)/30);
				System.out.println("1. 다음 페이지");
				System.out.println("2. 이전 페이지");
				System.out.println("3. 이전 메뉴로");//구현해야됨
				System.out.println("-----------------------------------------------------------");
				System.out.print("번호 입력 : ");
				int page=scan.nextInt();//1이면 다음 5개,아니면 이전 5개
				if(i<30&&page==2) {
					System.out.println("이전 페이지가 없습니다.");
					System.out.println("-----------------------------------------------------------");
				}
				if(page==2) {
					i=i-60;
				}
			}else {
				System.out.println(temp);
			}
			i++;
		}//while
	}
	private void getEmpByname() {
		// TODO Auto-generated method stub
		System.out.println("===========================================================");
		System.out.println("1. 관리자 -8.취업자 조회 및 관리 기능(이름으로 검색)");
		System.out.println("===========================================================");
		String header=String.format("[%s] [%s] [%s] [%s] [%s]   [%s]      [%s]","번호","수강신청번호","학생이름","회사번호","회사이름","연봉","취업일");
		
		Scanner scan=new Scanner(System.in);
		ArrayList<String[]> row= new ArrayList<String[]>();
		System.out.print("검색할 이름을 입력하세요 : ");
		String pname =scan.nextLine();
		row=m.procempbyname(pname);
		int i=0;
		
		
		System.out.println(header);
		while(i<row.size()) {
		
			String temp=String.format(" %3d      %3s       %s     %s    %6s    %,d만원      %s"
											,i+1
											,row.get(i)[0]
											,row.get(i)[2]
											,row.get(i)[3]
											,row.get(i)[4]
											,Integer.parseInt(row.get(i)[5])/10000
											,row.get(i)[6]
													);
			System.out.println(temp);
			if((i+1)%30==0) {
				System.out.printf("\t\t\t%d 쪽/%d쪽 \n",(i/30)+1,(row.size()+1)/30);
				System.out.println("1. 다음 페이지");
				System.out.println("2. 이전 페이지");
				System.out.println("3. 이전 메뉴로");//구현해야됨
				System.out.print("번호 입력 : ");
				int page=scan.nextInt();//1이면 다음 5개,2면 이전 5개
				if(page==2) {
					i=i-60;
				}
			}
			i++;
		}//while
	}
	private void getAllEmployee() {
		System.out.println("===========================================================");
		System.out.println("1. 관리자 -8.취업자 조회 및 관리 기능");
		System.out.println("===========================================================");
		String header=String.format("[%s] [%s] [%s] [%s] [%s]   [%s]      [%s]","번호","수강신청번호","학생이름","회사번호","회사이름","연봉","취업일");
		System.out.println(header);
		ArrayList<String[]> row= new ArrayList<String[]>();
		row=m.procemployee();
		int i=0;
		Scanner scan=new Scanner(System.in);
		//
		while(i<row.size()) {
		
			String temp=String.format(" %3d      %3s       %s     %s    %6s    %,d만원      %s"
											,i+1
											,row.get(i)[0]
											,row.get(i)[2]
											,row.get(i)[3]
											,row.get(i)[4]
											,Integer.parseInt(row.get(i)[5])/10000
											,row.get(i)[6]
													);
			System.out.println(temp);
			
			if((i+1)%30==0) {
				System.out.printf("\t\t\t%d 쪽/%d쪽 \n",(i/31)+1,((row.size()+1)/30)+1);
				System.out.println("1. 다음 페이지");
				System.out.println("2. 이전 페이지");
				System.out.println("3. 이전 메뉴로");//구현해야됨
				System.out.print("번호 입력 : ");
				int page=scan.nextInt();//1이면 다음 5개,2면 이전 5개
				if(i<31&&page==2) {
					System.out.println("이전 페이지가 없습니다.");
					System.out.println("다음 페이지를 검색합니다.");
					i++;
					continue;
				}
				if(page==2) {
					i=i-60;
				}
			}
			
			
			i++;
		}//while
	}
}//ManageEmp
