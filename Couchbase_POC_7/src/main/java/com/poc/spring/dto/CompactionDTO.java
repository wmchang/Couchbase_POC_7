package com.poc.spring.dto;

public class CompactionDTO {
	
	private boolean fragmentationCheckDatabasePer;
	private String fragmentationPercentDatabase;
	private boolean fragmentationCheckDatabaseMB;
	private String fragmentationMBDatabase;
	private boolean fragmentationCheckViewPer;
	private String fragmentationPercentView;
	private boolean fragmentationCheckViewMB;
	private String fragmentationMBView;
	
	private boolean timeIntervalCheck;
	private String compactionFromHour;
	private String compactionFromMinute;
	private String compactionToHour;
	private String compactionToMinute;
	private boolean abortCompaction;
	private boolean compactParallel;
	private String purgeInterval;
	
	public boolean isFragmentationCheckDatabasePer() {
		return fragmentationCheckDatabasePer;
	}
	public void setFragmentationCheckDatabasePer(boolean fragmentationCheckDatabasePer) {
		this.fragmentationCheckDatabasePer = fragmentationCheckDatabasePer;
	}
	public String getFragmentationPercentDatabase() {
		return fragmentationPercentDatabase;
	}
	public void setFragmentationPercentDatabase(String fragmentationPercentDatabase) {
		this.fragmentationPercentDatabase = fragmentationPercentDatabase;
	}
	public boolean isFragmentationCheckDatabaseMB() {
		return fragmentationCheckDatabaseMB;
	}
	public void setFragmentationCheckDatabaseMB(boolean fragmentationCheckDatabaseMB) {
		this.fragmentationCheckDatabaseMB = fragmentationCheckDatabaseMB;
	}
	public String getFragmentationMBDatabase() {
		return fragmentationMBDatabase;
	}
	public void setFragmentationMBDatabase(String fragmentationMBDatabase) {
		this.fragmentationMBDatabase = fragmentationMBDatabase;
	}
	public boolean isFragmentationCheckViewPer() {
		return fragmentationCheckViewPer;
	}
	public void setFragmentationCheckViewPer(boolean fragmentationCheckViewPer) {
		this.fragmentationCheckViewPer = fragmentationCheckViewPer;
	}
	public String getFragmentationPercentView() {
		return fragmentationPercentView;
	}
	public void setFragmentationPercentView(String fragmentationPercentView) {
		this.fragmentationPercentView = fragmentationPercentView;
	}
	public boolean isFragmentationCheckViewMB() {
		return fragmentationCheckViewMB;
	}
	public void setFragmentationCheckViewMB(boolean fragmentationCheckViewMB) {
		this.fragmentationCheckViewMB = fragmentationCheckViewMB;
	}
	public String getFragmentationMBView() {
		return fragmentationMBView;
	}
	public void setFragmentationMBView(String fragmentationMBView) {
		this.fragmentationMBView = fragmentationMBView;
	}
	public boolean isTimeIntervalCheck() {
		return timeIntervalCheck;
	}
	public void setTimeIntervalCheck(boolean timeIntervalCheck) {
		this.timeIntervalCheck = timeIntervalCheck;
	}
	public String getCompactionFromHour() {
		return compactionFromHour;
	}
	public void setCompactionFromHour(String compactionFromHour) {
		this.compactionFromHour = compactionFromHour;
	}
	public String getCompactionFromMinute() {
		return compactionFromMinute;
	}
	public void setCompactionFromMinute(String compactionFromMinute) {
		this.compactionFromMinute = compactionFromMinute;
	}
	public String getCompactionToHour() {
		return compactionToHour;
	}
	public void setCompactionToHour(String compactionToHour) {
		this.compactionToHour = compactionToHour;
	}
	public String getCompactionToMinute() {
		return compactionToMinute;
	}
	public void setCompactionToMinute(String compactionToMinute) {
		this.compactionToMinute = compactionToMinute;
	}
	public boolean isAbortCompaction() {
		return abortCompaction;
	}
	public void setAbortCompaction(boolean abortCompaction) {
		this.abortCompaction = abortCompaction;
	}
	public boolean isCompactParallel() {
		return compactParallel;
	}
	public void setCompactParallel(boolean compactParallel) {
		this.compactParallel = compactParallel;
	}
	public String getPurgeInterval() {
		return purgeInterval;
	}
	public void setPurgeInterval(String purgeInterval) {
		this.purgeInterval = purgeInterval;
	}
}
