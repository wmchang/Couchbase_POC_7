package com.poc.spring.service;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.couchbase.client.java.Bucket;
import com.couchbase.client.java.json.JsonObject;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectReader;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvParser;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;

public class CSVtoJSON {

	static Bucket bucket;
	static MultipartFile multipartFile;
	static String strFilePath;
	static String docID;
	static int threadCnt;
	static String strExtention;

	public static String strEnc_eucKR = "euc-kr";
	public static String strEnc_utf8 = "utf-8";
	

	public CSVtoJSON(Bucket bucket, MultipartFile multipartFile, String strFilePath, String docID, int threadCnt, String strExtention) {

		this.bucket = bucket;
		this.multipartFile = multipartFile;
		this.strFilePath = strFilePath;
		this.docID = docID;
		this.threadCnt = threadCnt;
		this.strExtention = strExtention;

	}

	public List<Object> CSVtoJSON() throws IOException {

		/** File Input **/
		FileInputStream fileInputStream = new FileInputStream(strFilePath);
		InputStreamReader is = new InputStreamReader(fileInputStream, strEnc_eucKR);
		
		try {

			CsvMapper csvMapper = new CsvMapper(); 			// csv 매핑
			CsvSchema csvSchema = CsvSchema.builder().setUseHeader(true).build();
			csvMapper.enable(CsvParser.Feature.IGNORE_TRAILING_UNMAPPABLE);

			MappingIterator<JsonObject> it = csvMapper.readerFor(Map.class).with(csvSchema).readValues(is);		//매핑된 것을 it 객체에 삽입

//			ExecutorService exeServicePool = Executors.newFixedThreadPool(threadCnt);		
			Runnable csvJsonThread = new CsvJsonThread(bucket, docID, it, strExtention);		//쓰레드

//			Callable<Integer> csvJsonThread = new CsvJsonThread<Integer>(bucket, docID, it, strExtention);

			for (int i = 0; i < threadCnt; i++) {		//쓰레드
//				Future<Integer> future = (Future<Integer>) exeServicePool.submit(csvJsonThread);
//				Integer resuslt = future.get();
				Thread thread = new Thread(csvJsonThread);
				thread.setName(":: CSV Thread Num :: "+i);
				thread.start();           


			}

		} catch (Exception e) {
			e.printStackTrace();
		} 

		return null;

	}
	public void jsonUpload() throws IOException {
		
		/** File Input **/
		FileInputStream fileInputStream = new FileInputStream(strFilePath);
		InputStreamReader is = new InputStreamReader(fileInputStream, strEnc_eucKR);
		
		try {
			
			ObjectMapper objMapper = new ObjectMapper();		//object 매핑
			ObjectReader objReader = objMapper.reader(Map.class);
			objMapper.configure(JsonParser.Feature.ALLOW_UNQUOTED_FIELD_NAMES, true);

			MappingIterator<JsonObject> it = objReader.readValues(is);		//매핑된 것을 it 객체에 삽입

			//ThreadPool 사용, newFixedThreadPool(threadCnt) : threadCnt개의 쓰레드를 가진 풀 생성
//			ExecutorService exeServicePool = Executors.newFixedThreadPool(threadCnt);		
			
			Runnable csvJsonThread = new CsvJsonThread(bucket, docID, it, strExtention);
//			CsvJsonThread<Integer> csvJsonThread = new CsvJsonThread<Integer>(bucket, docID, it, strExtention);
//			Callable<Integer> csvJsonThread = new CsvJsonThread<Integer>(bucket, docID, it, strExtention);
			
			
			for (int i = 0; i < threadCnt; i++) {
//				Future<Integer> future = (Future<Integer>) exeServicePool.submit(csvJsonThread);
//				Integer result = future.get();		//future.get() : Callable.call() 메소드 실행이 완료될 때까지 블록킹, 실행 완료 후 값 리턴
				Thread thread = new Thread(csvJsonThread);
				thread.setName(":: JSON Thread Num :: "+i);
				thread.start();     

			}
			
//			int sumLine = CsvJsonThread.sumLine;
//			System.out.println("::::::::"+sumLine);
			
//			exeServicePool.shutdown();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
