package com.poc.spring.dto;

import com.couchbase.client.java.manager.bucket.BucketType;

public class BucketSettingDTO {
	
	private String newBucketName;
	private BucketType newBucketType;
	private long bucketMemory;
	private int newBucketReplicas;
	private boolean flushEnable;
	private boolean indexReplicaEnable;
	
	public String getNewBucketName() {
		return newBucketName;
	}
	public void setNewBucketName(String newBucketName) {
		this.newBucketName = newBucketName;
	}
	public BucketType getNewBucketType() {
		return newBucketType;
	}
	public void setNewBucketType(BucketType newBucketType) {
		this.newBucketType = newBucketType;
	}
	public long getBucketMemory() {
		return bucketMemory;
	}
	public void setBucketMemory(long bucketMemory) {
		this.bucketMemory = bucketMemory;
	}
	public int getNewBucketReplicas() {
		return newBucketReplicas;
	}
	public void setNewBucketReplicas(int newBucketReplicas) {
		this.newBucketReplicas = newBucketReplicas;
	}
	public boolean isFlushEnable() {
		return flushEnable;
	}
	public void setFlushEnable(boolean flushEnable) {
		this.flushEnable = flushEnable;
	}
	public boolean isIndexReplicaEnable() {
		return indexReplicaEnable;
	}
	public void setIndexReplicaEnable(boolean indexReplicaEnable) {
		this.indexReplicaEnable = indexReplicaEnable;
	}
	
	

}
