package com.poc.spring.dto;

public class querySettingsDTO {
	
	private boolean curlAccessCheck;
	private String allowedURL;
	private String disallowedURL;
	private String queryTmpSpaceDir;
	private String queryTmpSpaceSize;
	private String queryPipelineBatch;
	private String queryPipelineCap;
	private String queryScanCap;
	private String queryTimeout;
	private String queryPreparedLimit;
	private String queryCompletedLimit;
	private String queryCompletedThreshold;
	private String queryLogLevel;
	private String queryMaxParallelism;
	private String queryN1QLFeatCtrl;
	
	public void setCurlAccessCheck(boolean curlAccessCheck) {
		this.curlAccessCheck = curlAccessCheck;
	}
	public boolean isCurlAccessCheck() {
		return curlAccessCheck;
	}
	public String getAllowedURL() {
		return allowedURL;
	}
	public void setAllowedURL(String allowedURL) {
		this.allowedURL = allowedURL;
	}
	public String getDisallowedURL() {
		return disallowedURL;
	}
	public void setDisallowedURL(String disallowedURL) {
		this.disallowedURL = disallowedURL;
	}
	public String getQueryTmpSpaceDir() {
		return queryTmpSpaceDir;
	}
	public void setQueryTmpSpaceDir(String queryTmpSpaceDir) {
		this.queryTmpSpaceDir = queryTmpSpaceDir;
	}
	public String getQueryTmpSpaceSize() {
		return queryTmpSpaceSize;
	}
	public void setQueryTmpSpaceSize(String queryTmpSpaceSize) {
		this.queryTmpSpaceSize = queryTmpSpaceSize;
	}
	public String getQueryPipelineBatch() {
		return queryPipelineBatch;
	}
	public void setQueryPipelineBatch(String queryPipelineBatch) {
		this.queryPipelineBatch = queryPipelineBatch;
	}
	public String getQueryPipelineCap() {
		return queryPipelineCap;
	}
	public void setQueryPipelineCap(String queryPipelineCap) {
		this.queryPipelineCap = queryPipelineCap;
	}
	public String getQueryScanCap() {
		return queryScanCap;
	}
	public void setQueryScanCap(String queryScanCap) {
		this.queryScanCap = queryScanCap;
	}
	public String getQueryTimeout() {
		return queryTimeout;
	}
	public void setQueryTimeout(String queryTimeout) {
		this.queryTimeout = queryTimeout;
	}
	public String getQueryPreparedLimit() {
		return queryPreparedLimit;
	}
	public void setQueryPreparedLimit(String queryPreparedLimit) {
		this.queryPreparedLimit = queryPreparedLimit;
	}
	public String getQueryCompletedLimit() {
		return queryCompletedLimit;
	}
	public void setQueryCompletedLimit(String queryCompletedLimit) {
		this.queryCompletedLimit = queryCompletedLimit;
	}
	public String getQueryCompletedThreshold() {
		return queryCompletedThreshold;
	}
	public void setQueryCompletedThreshold(String queryCompletedThreshold) {
		this.queryCompletedThreshold = queryCompletedThreshold;
	}
	public String getQueryLogLevel() {
		return queryLogLevel;
	}
	public void setQueryLogLevel(String queryLogLevel) {
		this.queryLogLevel = queryLogLevel;
	}
	public String getQueryMaxParallelism() {
		return queryMaxParallelism;
	}
	public void setQueryMaxParallelism(String queryMaxParallelism) {
		this.queryMaxParallelism = queryMaxParallelism;
	}
	public String getQueryN1QLFeatCtrl() {
		return queryN1QLFeatCtrl;
	}
	public void setQueryN1QLFeatCtrl(String queryN1QLFeatCtrl) {
		this.queryN1QLFeatCtrl = queryN1QLFeatCtrl;
	}
}
