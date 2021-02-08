package com.poc.spring.service;

import org.apache.commons.lang3.RandomStringUtils;

import com.couchbase.client.java.Bucket;

public class CouchbaseThread implements Runnable{
	  int docSize;
    int docCount;
    int docIdSize;
    Bucket bucket;
    
  public CouchbaseThread(int docSize,int docCount, int docIdSize, Bucket bucket) {
  	this.docSize = docSize;
  	this.docCount = docCount;
  	this.docIdSize = docIdSize;
  	this.bucket = bucket;
  	
  }
  
  public synchronized void run() {
      try {
      	while (docCount > 0) {
      		
      		if(docCount == 1) {
      			System.out.println("완료");
      		}
      		--docCount;
  			bucket.defaultCollection().upsert(RandomStringUtils.randomAlphanumeric(docIdSize), "{\"a\":\"" + RandomStringUtils.randomAlphanumeric(docSize) + "\"}");
  			
      	}
      }catch(Exception e) {

      }
  }
}