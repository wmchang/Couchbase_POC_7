package com.poc.spring.controller;

import org.json.simple.parser.ParseException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.couchbase.client.core.error.CouchbaseException;
import com.couchbase.client.core.error.ParsingFailureException;

@RestControllerAdvice
public class CouchExceptionHandler {
	
	@ExceptionHandler(CouchbaseException.class)
	public Object CouchbaseCatch(CouchbaseException e) {
		
		if(e.toString().contains("RAM quota specified is too large")) {
			return "[ERROR]: 클러스터에 할당된 RAM 크기보다 지정한 RAM 크기가 더 큽니다.";
		}
		else if( e.toString().contains("RAM quota cannot be less than 100 MB")){
			
			return "[ERROR]: RAM의 크기는 최소 100MB이어야 합니다.";
		}
		
		e.printStackTrace();
		
		return e.getLocalizedMessage();
	}
	
	@ExceptionHandler(NullPointerException.class)
	public Object NullPointerCatch(NullPointerException e) {
		
		if(e.toString().contains("because \"this.cluster\" is null")) {
			return "[ERROR]: 먼저 서버를 연결해주십시오."; 
		}
		
		e.printStackTrace();
		return e.getLocalizedMessage();
	}
	
	@ExceptionHandler(ParsingFailureException.class)
	public Object ParsingCatch(ParsingFailureException e) {
		if(e.toString().contains("Input was not a statement")) {
			return "[ERROR]: Statement가 잘못되었습니다."; 
		}
		else if(e.toString().contains("syntax error")) {
			return "[ERROR]: Statement가 잘못되었습니다."; 
		}
		
		e.printStackTrace();
		return "[ERROR]: JSON 파싱에 실패했습니다.";
	}
	
	@ExceptionHandler(ParseException.class)
	public Object ParsingCatch(ParseException e) {
		
		System.out.println(e.getLocalizedMessage());
		
		return "[ERROR]: JSON 파싱에 실패했습니다.";
	}
}
