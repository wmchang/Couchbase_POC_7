package com.poc.spring.service;

import java.util.HashMap;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import com.couchbase.client.java.Bucket;
import com.couchbase.client.java.json.JsonObject;

public class CouchbaseThread implements Runnable{
	int docSize;
    int docCount;
    int docIdSize;
    String scopeName;
    String collectionName;
    Bucket bucket;
    
    @Autowired
    CouchbaseService couchbaseService;
    
  public CouchbaseThread(HashMap<String,Object> map, Bucket bucket) {
	
  	this.docSize = Integer.parseInt((String)map.get("docSize"));
  	this.docCount = Integer.parseInt((String)map.get("docCount"));
  	this.docIdSize = Integer.parseInt((String)map.get("docIdSize"));
  	this.bucket = bucket;
  	this.scopeName = (String)map.get("scopeName");
  	this.collectionName = (String)map.get("collectionName");
  	
  }
  
  public synchronized void run() {
      try {
      	while (docCount > 0) {
      		
      		if(docCount == 1) {
      			System.out.println("완료");
      		}
      		--docCount;
      		bucket.scope(scopeName).collection(collectionName)
      				.upsert(RandomStringUtils.randomAlphanumeric(docIdSize), JsonObject.create().put("temp", RandomStringUtils.randomAlphanumeric(docSize)));
  			
      	}
      }catch(Exception e) {
    	  e.printStackTrace();
    	  System.out.println("오류");
      }
  }
}