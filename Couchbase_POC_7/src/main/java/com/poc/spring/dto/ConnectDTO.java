package com.poc.spring.dto;

public class ConnectDTO{	
	
	// Connection
	private String hostname;
	private String portNumber;
	private String username;
	private String password;
	private String bucketName;
	
//	private String scopeName;
//	private String collectionName;
	
	// Timeout
	private long kvTimeout;
	private long viewTimeout;
	private long queryTimeout;
	private long searchTimeout;
	private long analyticsTimeout;
	private long connectTimeout;
	private long disconnectTimeout;
	private long managementTimeout;
	
	// Io Config
	private boolean enableDnsSrv;
	private int numKvConnections;
	private int maxHttpConnections;
	private boolean enableTcpKeepAlives;
	private long tcpKeepAliveTime;
	private boolean mutationTokensEnabled;
	private String[] captureTraffic;
	private long idleHttpConnectionTimeout;
	private long configPollInterval;
	
	//Security Config
	private boolean enableTls;
	private boolean enableNativeTls;
	private String keyStorePath;
	private String keyStorePwd;
	
	//Compression Config
	private boolean enableCompression;
	private int compressionMinSize;
	private double compressionMinDouble;
	
	public boolean isEnableCompression() {
		return enableCompression;
	}
	public void setEnableCompression(boolean enableCompression) {
		this.enableCompression = enableCompression;
	}
	public int getCompressionMinSize() {
		return compressionMinSize;
	}
	public void setCompressionMinSize(int compressionMinSize) {
		this.compressionMinSize = compressionMinSize;
	}
	public double getCompressionMinDouble() {
		return compressionMinDouble;
	}
	public void setCompressionMinDouble(double compressionMinDouble) {
		this.compressionMinDouble = compressionMinDouble;
	}
	public boolean isEnableDnsSrv() {
		return enableDnsSrv;
	}
	public void setEnableDnsSrv(boolean enableDnsSrv) {
		this.enableDnsSrv = enableDnsSrv;
	}
	public String getHostname() {
		return hostname;
	}
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	public String getPortNumber() {
		return portNumber;
	}
	public void setPortNumber(String portNumber) {
		this.portNumber = portNumber;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getBucketName() {
		return bucketName;
	}
	public void setBucketName(String bucketName) {
		this.bucketName = bucketName;
	}
	public long getKvTimeout() {
		return kvTimeout;
	}
	public void setKvTimeout(long kvTimeout) {
		this.kvTimeout = kvTimeout;
	}
	public long getViewTimeout() {
		return viewTimeout;
	}
	public void setViewTimeout(long viewTimeout) {
		this.viewTimeout = viewTimeout;
	}
	public long getQueryTimeout() {
		return queryTimeout;
	}
	public void setQueryTimeout(long queryTimeout) {
		this.queryTimeout = queryTimeout;
	}
	public long getConnectTimeout() {
		return connectTimeout;
	}
	public void setConnectTimeout(long connectTimeout) {
		this.connectTimeout = connectTimeout;
	}
	public long getDisconnectTimeout() {
		return disconnectTimeout;
	}
	public void setDisconnectTimeout(long disconnectTimeout) {
		this.disconnectTimeout = disconnectTimeout;
	}
	public long getManagementTimeout() {
		return managementTimeout;
	}
	public void setManagementTimeout(long managementTimeout) {
		this.managementTimeout = managementTimeout;
	}
	public long getSearchTimeout() {
		return searchTimeout;
	}
	public void setSearchTimeout(long searchTimeout) {
		this.searchTimeout = searchTimeout;
	}
	public long getAnalyticsTimeout() {
		return analyticsTimeout;
	}
	public void setAnalyticsTimeout(long analyticsTimeout) {
		this.analyticsTimeout = analyticsTimeout;
	}
	public int getNumKvConnections() {
		return numKvConnections;
	}
	public void setNumKvConnections(int numKvConnections) {
		this.numKvConnections = numKvConnections;
	}
	public int getMaxHttpConnections() {
		return maxHttpConnections;
	}
	public void setMaxHttpConnections(int maxHttpConnections) {
		this.maxHttpConnections = maxHttpConnections;
	}
	public boolean isEnableTcpKeepAlives() {
		return enableTcpKeepAlives;
	}
	public void setEnableTcpKeepAlives(boolean enableTcpKeepAlives) {
		this.enableTcpKeepAlives = enableTcpKeepAlives;
	}
	public long getTcpKeepAliveTime() {
		return tcpKeepAliveTime;
	}
	public void setTcpKeepAliveTime(long tcpKeepAliveTime) {
		this.tcpKeepAliveTime = tcpKeepAliveTime;
	}
	public boolean isEnableTls() {
		return enableTls;
	}
	public void setEnableTls(boolean enableTls) {
		this.enableTls = enableTls;
	}
	public boolean isEnableNativeTls() {
		return enableNativeTls;
	}
	public void setEnableNativeTls(boolean enableNativeTls) {
		this.enableNativeTls = enableNativeTls;
	}
	public String getKeyStorePath() {
		return keyStorePath;
	}
	public void setKeyStorePath(String keyStorePath) {
		this.keyStorePath = keyStorePath;
	}
	public String getKeyStorePwd() {
		return keyStorePwd;
	}
	public void setKeyStorePwd(String keyStorePwd) {
		this.keyStorePwd = keyStorePwd;
	}
	public boolean isMutationTokensEnabled() {
		return mutationTokensEnabled;
	}
	public void setMutationTokensEnabled(boolean mutationTokensEnabled) {
		this.mutationTokensEnabled = mutationTokensEnabled;
	}
	public String[] getCaptureTraffic() {
		return captureTraffic;
	}
	public void setCaptureTraffic(String[] captureTraffic) {
		this.captureTraffic = captureTraffic;
	}
	public long getIdleHttpConnectionTimeout() {
		return idleHttpConnectionTimeout;
	}
	public void setIdleHttpConnectionTimeout(long idleHttpConnectionTimeout) {
		this.idleHttpConnectionTimeout = idleHttpConnectionTimeout;
	}
	public long getConfigPollInterval() {
		return configPollInterval;
	}
	public void setConfigPollInterval(long configPollInterval) {
		this.configPollInterval = configPollInterval;
	}
}