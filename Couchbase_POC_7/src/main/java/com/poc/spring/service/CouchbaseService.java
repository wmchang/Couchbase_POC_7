package com.poc.spring.service;

import java.io.File;
import java.nio.file.Paths;
import java.security.KeyStore;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.couchbase.client.core.env.CertificateAuthenticator;
import com.couchbase.client.core.env.CompressionConfig;
import com.couchbase.client.core.env.IoConfig;
import com.couchbase.client.core.env.SecurityConfig;
import com.couchbase.client.core.env.TimeoutConfig;
import com.couchbase.client.core.error.BucketExistsException;
import com.couchbase.client.core.error.BucketNotFoundException;
import com.couchbase.client.core.error.DatasetNotFoundException;
import com.couchbase.client.core.error.DocumentExistsException;
import com.couchbase.client.core.error.IndexExistsException;
import com.couchbase.client.core.error.IndexFailureException;
import com.couchbase.client.core.error.PlanningFailureException;
import com.couchbase.client.core.service.ServiceType;
import com.couchbase.client.java.Bucket;
import com.couchbase.client.java.Cluster;
import com.couchbase.client.java.ClusterOptions;
import com.couchbase.client.java.analytics.AnalyticsResult;
import com.couchbase.client.java.env.ClusterEnvironment;
import com.couchbase.client.java.env.ClusterEnvironment.Builder;
import com.couchbase.client.java.json.JsonObject;
import com.couchbase.client.java.kv.GetResult;
import com.couchbase.client.java.manager.bucket.BucketManager;
import com.couchbase.client.java.manager.bucket.BucketSettings;
import com.couchbase.client.java.manager.bucket.BucketType;
import com.couchbase.client.java.manager.collection.CollectionSpec;
import com.couchbase.client.java.manager.collection.ScopeSpec;
import com.couchbase.client.java.query.QueryResult;
import com.couchbase.client.java.search.SearchOptions;
import com.couchbase.client.java.search.SearchQuery;
import com.couchbase.client.java.search.queries.MatchQuery;
import com.couchbase.client.java.search.result.SearchResult;
import com.couchbase.client.java.search.result.SearchRow;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.poc.spring.dto.BucketSettingDTO;
import com.poc.spring.dto.CompactionDTO;
import com.poc.spring.dto.ConnectDTO;
import com.poc.spring.dto.SettingDTO;
import com.poc.spring.dto.querySettingsDTO;
import com.poc.spring.util.ServiceUtils;

@Service
public class CouchbaseService {
	
	@Autowired
	ServiceUtils serviceUtil;
	
	public Cluster cluster;
	public Bucket bucket=null;
	ConnectDTO dto;
	ClusterEnvironment env;
	List<String> hostList = new ArrayList<String>();
	JSONParser parser = new JSONParser();
	ObjectMapper mapper = new ObjectMapper();
	
	public String connectionData(HttpServletRequest request) throws Exception {
		
		Map<String,Object> map = serviceUtil.getRequestToMap(request);

		try {

			ServiceType[] serviceType = null;
			String captureValues[] = request.getParameterValues("captureTraffic");
			if(captureValues != null) {
				
				if(captureValues.length==1) {
					map.put("captureTraffic", captureValues);
				}
				serviceType = new ServiceType[captureValues.length];
				for(int i=0;i<captureValues.length;i++) {
					switch(captureValues[i]) {
						case "kv":
							serviceType[i]= ServiceType.KV;
							break;
						case "query":
							serviceType[i]= ServiceType.QUERY;
							break;
						case "search":
							serviceType[i]= ServiceType.SEARCH;
							break;
						case "view":
							serviceType[i]= ServiceType.VIEWS;
							break;
						case "analytics":
							serviceType[i]= ServiceType.ANALYTICS;
							break;
						case "manager":
							serviceType[i]= ServiceType.MANAGER;
							break;
					}
				}
			}

			dto = mapper.convertValue(map, ConnectDTO.class);

			Builder envBuilder = ClusterEnvironment.builder()
					.timeoutConfig(
							TimeoutConfig
								.kvTimeout(Duration.ofMillis(dto.getKvTimeout()))
								.viewTimeout(Duration.ofMillis(dto.getViewTimeout()))
								.queryTimeout(Duration.ofMillis(dto.getQueryTimeout()))
								.searchTimeout(Duration.ofMillis(dto.getSearchTimeout()))
								.analyticsTimeout(Duration.ofMillis(dto.getAnalyticsTimeout()))
								.connectTimeout(Duration.ofMillis(dto.getConnectTimeout()))
								.disconnectTimeout(Duration.ofMillis(dto.getDisconnectTimeout()))
								.managementTimeout(Duration.ofMillis(dto.getManagementTimeout()))
							)
					.ioConfig(
							IoConfig
								.enableDnsSrv(dto.isEnableDnsSrv())
								.numKvConnections(dto.getNumKvConnections())
								.maxHttpConnections(dto.getMaxHttpConnections())
								.idleHttpConnectionTimeout(Duration.ofMillis(dto.getIdleHttpConnectionTimeout()))
								.enableTcpKeepAlives(dto.isEnableTcpKeepAlives())
								.tcpKeepAliveTime(Duration.ofMillis(dto.getTcpKeepAliveTime()))
								.enableMutationTokens(dto.isMutationTokensEnabled())
								.configPollInterval(Duration.ofMillis(dto.getConfigPollInterval()))
								.captureTraffic(serviceType)
							)
					.compressionConfig(
							CompressionConfig
								.enable(dto.isEnableCompression())
								.minSize(dto.getCompressionMinSize())
								.minRatio(dto.getCompressionMinDouble())
							);
			
			if(dto.isEnableTls()) {
				envBuilder.securityConfig(
						SecurityConfig
						.enableTls(dto.isEnableTls())
						.enableNativeTls(dto.isEnableNativeTls())
						.trustCertificate(Paths.get(dto.getKeyStorePath()))
					);
			}
			env = envBuilder.build();
			
			CertificateAuthenticator auth = null;
			if(dto.isEnableTls()) {
				auth = CertificateAuthenticator.fromKeyStore(KeyStore.getInstance(dto.getKeyStorePath()), dto.getKeyStorePwd());
				cluster = Cluster.connect(dto.getHostname(), ClusterOptions.clusterOptions(auth).environment(env));
			}else {
				cluster = Cluster.connect(dto.getHostname(), ClusterOptions.clusterOptions(dto.getUsername(), dto.getPassword()).environment(env));
			}
			cluster.buckets().getBucket(dto.getBucketName());
			bucket = cluster.bucket(dto.getBucketName());
			}
			catch(BucketNotFoundException e) {
				return "버킷이 존재하지 않습니다. 클러스터만 연결됩니다.";
			}
			catch(Exception e) {
				e.printStackTrace();
				return "값이 잘못되었습니다.";
			}
			return "연결되었습니다.";
	}
	
	// Node
	public List<Object> getNodeList(){
		// curl -u Administrator:password http://10.5.2.54:8091/pools/default/buckets
		
		if(dto == null)
			return null;
		
		StringBuilder command = new StringBuilder();
		command.append("curl -u ");
		command.append(dto.getUsername());
		command.append(":");
		command.append(dto.getPassword());
		command.append(" http://");
		command.append(dto.getHostname());
		command.append(":");
		command.append(dto.getPortNumber());
		command.append("/pools/default");
		System.out.println(command);
		
		List<Object> list = new ArrayList<Object>();
		Map<String,Object> map = serviceUtil.curlExcute(command.toString());
		
		hostList.clear();
		Object obj = null;
		
		try {
			obj = parser.parse(map.get("result").toString().replaceAll(",\"allocstall\":18446744073709552000", ""));
			JSONObject json = (JSONObject) obj;
			JSONArray array = (JSONArray) json.get("nodes");
			
			for(int i=0;i<array.size();i++) {
				JSONObject node = (JSONObject) array.get(i);
				JSONArray serviceJsonList = (JSONArray)node.get("services");
				List<Object> serviceList = serviceUtil.serviceCheck(serviceJsonList);
				JSONObject systemStats = (JSONObject)node.get("systemStats");
				
				Map<String,Object> nodeMap = new HashMap<String,Object>();
				
				String hostName = (String) node.get("hostname");
				hostList.add(hostName.substring(0,hostName.indexOf(":")));
				
				nodeMap.put("hostname", node.get("hostname"));
				nodeMap.put("service", serviceList);
				nodeMap.put("cpu", serviceUtil.doubleFormat(systemStats.get("cpu_utilization_rate")));
				nodeMap.put("swap", serviceUtil.byteToMb(systemStats.get("swap_total")));
				nodeMap.put("ram_total", serviceUtil.byteToMb(systemStats.get("mem_total")));
				nodeMap.put("ram_free", serviceUtil.byteToMb(systemStats.get("mem_free")));
				
				list.add(nodeMap);
			
			}
			
			return list;
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		
		return null;
	}
	
	public Map<String, Object> addNode(HttpServletRequest request){
		// curl -v -X POST -u Admin:tf4220 http://localhost:8091/controller/addNode -d hostname=http://192.168.0.17
		// -d user=Administrator -d password=dpsxndpa1! -d services=kv, n1ql, index
		
		if(dto == null)
			return null;
		
		String[] checkedService = request.getParameterValues("service");
		
		StringBuilder command = new StringBuilder();
		command.append("curl -v -X POST -u ");
		command.append(dto.getUsername());
		command.append(":");
		command.append(dto.getPassword());
		command.append(" http://");
		command.append(dto.getHostname());
		command.append(":");
		command.append(dto.getPortNumber());
		command.append("/controller/addNode");
		command.append(" -d hostname=");
		command.append(request.getParameter("hostName"));
		command.append(" -d user=");
		command.append(dto.getUsername());
		command.append(" -d password=");
		command.append(dto.getPassword());
		command.append(" -d services=");
		for(int i=0;i<checkedService.length;i++) {
			command.append(checkedService[i]);
			if(checkedService.length-1 != i) {
				command.append(", ");
			}
		}
		System.out.println(command);
		
		Map<String, Object> resultMap = serviceUtil.curlExcute(command.toString());
		
		return resultMap;
		
	}
	
	public Map<String, Object> dropNode(HttpServletRequest request){
		// curl -u Admin:tf4220 http://localhost:8091/controller/ejectNode -d otpNode=ns_1@192.168.0.17 
		// 장애발생or보류or리밸런싱 안한 노드에만 사용가능함.
		
		// curl -u Admin:tf4220 http://localhost:8091/controller/rebalance -d ejectedNodes=ns_1%40192.168.0.17
		// 						-d knownNodes=ns_1%40192.168.0.27%2Cns_1%40192.168.0.17
		// rebalance 과정을 거치면서 안전하게 제거함.
		
		if(dto == null)
			return null;
		
		StringBuilder command = new StringBuilder();
		command.append("curl -u ");
		command.append(dto.getUsername());
		command.append(":");
		command.append(dto.getPassword());
		command.append(" http://");
		command.append(dto.getHostname());
		command.append(":");
		command.append(dto.getPortNumber());
		
		if(request.getParameter("activeCheck").equals("active")) {
			
			command.append("/controller/rebalance");
			command.append(" -d knownNodes=ns_1%40");
			command.append(hostList.get(0));
			
			for(int i=1;i<hostList.size();i++) {
				command.append("%2Cns_1%40");
				command.append(hostList.get(i));
			}
			
			command.append(" -d ejectedNodes=ns_1%40");
			command.append(request.getParameter("dropHostName"));
			
			
		}else {
			// 장애발생or보류or리밸런싱 안한 노드 삭제
			
			command.append("/controller/ejectNode");
			command.append(" -d otpNode=ns_1@");
			command.append(request.getParameter("dropHostName"));
		}
		System.out.println(command);
		Map<String, Object> resultMap = serviceUtil.curlExcute(command.toString());
		return resultMap;
	}
	
	public Map<String, Object> rebalancing(HttpServletRequest request){
		// curl -v -X POST -u [admin]:[password] http://[localhost]:8091/controller/rebalance
		// -d 'knownNodes=ns_1%4010.143.190.101%2Cns_1%4010.143.190.102%2Cns_1%4010.143.190.103'
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		if(dto == null) {
			resultMap.put("result", "환경 설정 및 서버 연결을 해주십시오.");
			return resultMap;
		} else if(hostList.size() <= 1) {
			resultMap.put("result", "서버가 한 개 뿐입니다.");
			return resultMap;
		}
		
		StringBuilder command = new StringBuilder();
		command.append("curl -v -X POST -u ");
		command.append(dto.getUsername());
		command.append(":");
		command.append(dto.getPassword());
		command.append(" http://");
		command.append(dto.getHostname());
		command.append(":");
		command.append(dto.getPortNumber());
		command.append("/controller/rebalance -d knownNodes=ns_1%40");
		command.append(hostList.get(0));
		
		for(int i=1;i<hostList.size();i++) {
			command.append("%2Cns_1%40");
			command.append(hostList.get(i));
		}
		
		System.out.println(command);
		
		resultMap = serviceUtil.curlExcute(command.toString());
		
		
		return resultMap;
	}
	
	public List<Object> getBucketListDetail(){
		// curl -u Administrator:password http://10.5.2.54:8091/pools/default/buckets
		
		if(dto == null)
			return null;
		
		StringBuilder command = new StringBuilder();
		command.append("curl -u ");
		command.append(dto.getUsername());
		command.append(":");
		command.append(dto.getPassword());
		command.append(" http://");
		command.append(dto.getHostname());
		command.append(":");
		command.append(dto.getPortNumber());
		command.append("/pools/default/buckets");
		
		Map<String,Object> map = serviceUtil.curlExcute(command.toString());
		List<Object> list = new ArrayList<Object>();
		
		Object obj = null;
		try {
			obj = parser.parse(map.get("result").toString().replaceAll(",\"allocstall\":18446744073709552000", ""));
			JSONArray array = (JSONArray) obj;
			
			for(int i=0;i<array.size();i++) {
				JSONObject jsonObj = (JSONObject)array.get(i);
				Object bufferObj = jsonObj.get("basicStats");
				JSONObject statObj = (JSONObject)bufferObj;
				bufferObj = jsonObj.get("quota");
				JSONObject quotaObj = (JSONObject)bufferObj;
				
				Map<String,Object> bucketMap = new HashMap<String,Object>();
				
				bucketMap.put("name", jsonObj.get("name"));
				bucketMap.put("bucketType", jsonObj.get("bucketType").equals("membase") ? "couchbase" : jsonObj.get("bucketType"));
				bucketMap.put("itemCount", statObj.get("itemCount"));
				bucketMap.put("memUsed", serviceUtil.byteToMb(statObj.get("memUsed")));
				bucketMap.put("diskUsed", serviceUtil.byteToMb(statObj.get("diskUsed")));
				bucketMap.put("quotaPercentUsed", serviceUtil.doubleFormat(statObj.get("quotaPercentUsed")));
				bucketMap.put("ram", serviceUtil.byteToMb(quotaObj.get("ram")));
				
				list.add(bucketMap);
			}
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	// Bucket
	public List<String> getBucketList(){
		// curl -u Administrator:admin123 http://10.5.2.54:8091/pools/default/buckets
		
		if(dto == null)
			return null;
		
		Map<String,BucketSettings> map = cluster.buckets().getAllBuckets();
		List<String> bucketList = new ArrayList<String>();
		
		
		Iterator<String> i= map.keySet().iterator();
		while(i.hasNext()) {
			bucketList.add(i.next());
			
		}
		
		return bucketList;
	}

	public String createBucket(HttpServletRequest request) {
		
		try {
			HashMap<String,Object> map = serviceUtil.getRequestToMap(request);
			BucketManager manager = cluster.buckets();
			BucketSettingDTO bucketSet;
			
			bucketSet = mapper.convertValue(map, BucketSettingDTO.class);
			
			BucketSettings settings = BucketSettings.create(bucketSet.getNewBucketName())
												.bucketType(bucketSet.getNewBucketType())
												.ramQuotaMB(bucketSet.getBucketMemory());
			
			if(!(bucketSet.getNewBucketType() == BucketType.MEMCACHED)) {
				settings.numReplicas(bucketSet.getNewBucketReplicas())
						.flushEnabled(bucketSet.isFlushEnable());
				if(map.get("newBucketType").equals("couchbase")) {
					settings.replicaIndexes(bucketSet.isIndexReplicaEnable());
				}
			}
												
			manager.createBucket(settings);
		}
		catch(BucketExistsException e) {
			return "이미 존재하는 이름의 버킷입니다.";
		}

		return "버킷이 생성되었습니다.";
	}
	
	public String dropBucket(HttpServletRequest request) {
		
		try {
		
			BucketManager manager = cluster.buckets();
			
			if(bucket.name().equals(request.getParameter("bucketName"))) {
				return "연결되어있는 버킷은 제거할 수 없습니다."; 
			}
			manager.dropBucket(request.getParameter("bucketName"));
	
			cluster.disconnect();
			cluster = Cluster.connect(dto.getHostname(), ClusterOptions.clusterOptions(dto.getUsername(), dto.getPassword()).environment(env));
			bucket = cluster.bucket(dto.getBucketName());		
		}
		catch(Exception e) {
			e.printStackTrace();
			return "오류";
		}
		
		return "삭제되었습니다.";
	}
	
	public Object getAllScope(HttpServletRequest request) {
		
		if(dto == null)
			return null;
		
		String bucketName = request.getParameter("bucketName");
		
		Map<String,Object> map = new HashMap<String,Object>();
		Iterator<ScopeSpec> scopeI = cluster.bucket(bucketName).collections().getAllScopes().iterator();
		
		while(scopeI.hasNext()) {
			List<String> list = new ArrayList<String>();

			ScopeSpec scope = scopeI.next();
			Iterator<CollectionSpec> colI = scope.collections().iterator();
			
			while(colI.hasNext()) {
				CollectionSpec col = colI.next();
				list.add(col.name());
			}
			map.put(scope.name(), list);
		}
		
		return map;
	}
	
	public Object getScope(HttpServletRequest request) {
		
		String bucketName = request.getParameter("bucketName");
		
		Iterator<ScopeSpec> i = cluster.bucket(bucketName).collections().getAllScopes().iterator();
		List<String> scopeList = new ArrayList<String>();
		
		while(i.hasNext()) {
			
			scopeList.add(i.next().name());
		}
		
		return scopeList;
	}
	
	public Object getCollection(HttpServletRequest request) {
		
		String bucketName = request.getParameter("bucketName");
		String scopeName = request.getParameter("scopeName");
		
		Iterator<CollectionSpec> i = cluster.bucket(bucketName).collections().getScope(scopeName).collections().iterator();
		List<String> collectionList = new ArrayList<String>();
		
		while(i.hasNext()) {
			
			collectionList.add(i.next().name());
		}
		
		return collectionList;
	}
	
	public Map<String, Object> getScopeCollection(Map<String,Object> requestMap) {
		
		if(dto == null)
			return null;
		
		String bucketName = (String) requestMap.get("bucketName");
		if(bucketName==null)
			bucketName = bucket.name();
		
		String scopeName = (String) requestMap.get("scopeName");
		if(scopeName == null)
			scopeName ="_default";
	
		
		List<String> scopeList = new ArrayList<String>();
		List<String> collectionList = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String,Object>();
		Iterator<ScopeSpec> scopeI = cluster.bucket(bucketName).collections().getAllScopes().iterator();
		
		while(scopeI.hasNext()) {
			
			ScopeSpec scope = scopeI.next();
			scopeList.add(scope.name());

			Iterator<CollectionSpec> colI = scope.collections().iterator();
			while(colI.hasNext()) {
				CollectionSpec col = colI.next();
				
				if(col.scopeName().equals(scopeName)) {
					collectionList.add(col.name());
				}
			}
		}
		
		map.put("scopeList", scopeList);
		map.put("collectionList", collectionList);
		
		
		return map;
	}
	
	public Object createScope(HttpServletRequest request) {
		
		String bucketName = request.getParameter("bucketName");
		String scopeName = request.getParameter("scopeName");
		
		StringBuilder statement = new StringBuilder();

		statement.append("Create Scope `");
		statement.append(bucketName);
		statement.append("`.");
		statement.append(scopeName);
		System.out.println(statement.toString());
		
		cluster.query(statement.toString());
		
		return scopeName+" Scope가 생성되었습니다.";
	}
	
	public Object createCollection(HttpServletRequest request) {
		
		String bucketName = request.getParameter("bucketName");
		String scopeName = request.getParameter("scopeName");
		String collectionName = request.getParameter("collectionName");
		
		StringBuilder statement = new StringBuilder();

		statement.append("Create Collection `");
		statement.append(bucketName);
		statement.append("`.");
		statement.append(scopeName);
		statement.append(".");
		statement.append(collectionName);
		System.out.println(statement.toString());
		
		cluster.query(statement.toString());
		

		return collectionName+" Collection이 생성되었습니다.";
	}
	
	public Object dropScope(HttpServletRequest request) {
		
		String bucketName = request.getParameter("bucketName");
		String scopeName = request.getParameter("scopeName");
		
		StringBuilder statement = new StringBuilder();
		
		statement.append("Drop Scope `");
		statement.append(bucketName);
		statement.append("`.");
		statement.append(scopeName);
		System.out.println(statement.toString());
		
		cluster.query(statement.toString());
		
		
		return scopeName+" Scope가 삭제되었습니다.";
	}
	
	public Object dropCollection(HttpServletRequest request) {
		
		String bucketName = request.getParameter("bucketName");
		String scopeName = request.getParameter("scopeName");
		String collectionName = request.getParameter("collectionName");
		
		StringBuilder statement = new StringBuilder();
		
		statement.append("Drop Collection `");
		statement.append(bucketName);
		statement.append("`.");
		statement.append(scopeName);
		statement.append(".");
		statement.append(collectionName);
		System.out.println(statement.toString());
		
		cluster.query(statement.toString());
		
		
		return collectionName+" Collection이 삭제되었습니다.";
	}
	
	// Document
	public Object getDocumentList(Map<String,Object> requestMap){
		
			if(cluster == null)
				return null;
			 // select meta(t).id from `test` as t limit 30;

			String limit;
			if(requestMap.get("limit")==null)
				limit = "30";
			else
				limit = (String) requestMap.get("limit");
			
			String bucketName = (String) requestMap.get("bucketName");
			String scopeName = (String) requestMap.get("scopeName");
			String collectionName = (String) requestMap.get("collectionName");
			
			try {
				
			 StringBuilder statement = new StringBuilder();
			 
			 if(limit.length() < 0)
				 limit = "30";
			 
			 statement.append("select *, meta(t).id from `");
			 statement.append(bucketName);
			 statement.append("`.");
			 statement.append(scopeName);
			 statement.append(".");
			 statement.append(collectionName);
			 statement.append(" as t limit ");
			 statement.append(limit);
			 System.out.println(statement);
			 
			 QueryResult result = cluster.query(statement.toString());
			 
			 List<Object> list = new ArrayList<Object>();
			 
			 for(JsonObject row : result.rowsAsObject()) {
				 
				 Map<Object, Object> resultMap = new HashMap<Object, Object>();
				 resultMap.put("id", row.getString("id"));
				 resultMap.put("content",  row.getObject("t") );
				 
				 list.add(resultMap);
			 }
			 
			 if(list.size() == 0) {
				 Map<Object, Object> resultMap = new HashMap<Object, Object>();

				 resultMap.put("id","emptyDocumentList");
				 resultMap.put("content",  "문서가 존재하지 않습니다." );
				 list.add(resultMap);
			 }
			 
			 return list;
		}
		catch(PlanningFailureException e) {
			 List<Object> list = new ArrayList<Object>();
			 Map<Object, Object> resultMap = new HashMap<Object, Object>();
			 
			 resultMap.put("id","emptyDocumentList");
			 
			 if(e.toString().contains("No index available on keyspace")) 
				 resultMap.put("content",  "인덱스가 존재하지 않습니다. 인덱스를 생성해주세요.\r\n"
				 		+ "추천: Create Primary Index "+bucketName+"_"+collectionName+" on `"+bucketName+"`."+scopeName+"."+collectionName );
			 else
				 resultMap.put("content",  "문서가 존재하지 않습니다." );
			 
			 list.add(resultMap);
			 
			return list;
		}
		catch(IndexFailureException e) {
			 List<Object> list = new ArrayList<Object>();
			 Map<Object, Object> resultMap = new HashMap<Object, Object>();

			 resultMap.put("id","emptyDocumentList");
			 
			 if(e.toString().contains("not supported memcached")) 
				 resultMap.put("content", "Memcached Bucket은 조회가 불가능합니다." );
			 else 
				 resultMap.put("content",  "문서가 존재하지 않습니다." );

			 
			 list.add(resultMap);
			 
			return list;
		}
		catch(Exception e) {
			
			e.printStackTrace();
			
			return null;
		}
		
			
	}


	public Object addDocument(HttpServletRequest request){

		String bucketName = request.getParameter("bucketName");
		String documentId = request.getParameter("documentId");
		String documentText = request.getParameter("documentText");
		String scopeName = request.getParameter("scopeName");
		String collectionName = request.getParameter("collectionName");
		
		if(bucketName == null)
			bucketName = bucket.name();
		
		JSONObject obj;
		try {
			obj = (JSONObject) parser.parse(documentText);
		
		String jsonStr = obj.toString();
		JsonObject content = JsonObject.fromJson(jsonStr);
			
		cluster.bucket(bucketName).scope(scopeName).collection(collectionName).insert(documentId, content);
			
		}catch(DocumentExistsException e) {
			return "동일한 ID 의 Document가 존재합니다.";
		}catch (ParseException e) {
			return "JSON 형식이 잘못되었습니다.";
		}
		
		return "문서가 생성되었습니다.";
	}


	public Object documentUpsert(HttpServletRequest request) throws Exception{
		
		String documentId = request.getParameter("documentId");
		String documentText = request.getParameter("documentText");
		String scopeName = request.getParameter("scopeName");
		String collectionName = request.getParameter("collectionName");
		
		
		JSONObject obj = (JSONObject) parser.parse(documentText);
		String jsonStr = obj.toString();
		
		JsonObject content = JsonObject.fromJson(jsonStr);
		
		String bucketName;
		if(request.getParameter("bucketName") == null)
			bucketName = bucket.name();
		else
			bucketName = request.getParameter("bucketName");
		
		cluster.bucket(bucketName).scope(scopeName).collection(collectionName).upsert(documentId, content);
			
		return "문서 '"+documentId + "' 가 정상적으로 변경되었습니다.";
	}
	

	public Object getDocumentDetails(HttpServletRequest request) {

		String bucketName = request.getParameter("bucketName");
		String documentId = request.getParameter("documentId");
		String scopeName = request.getParameter("scopeName");
		String collectionName = request.getParameter("collectionName");
		
		String documentDetails = null;
		GetResult result = null;

		try {
			
			if(scopeName==null) {
				String statement = "select * from `" + bucketName + "` t where meta().id = \'"+documentId+"'";
				QueryResult queryResult = cluster.query(statement);
				
				JsonObject json = (JsonObject) queryResult.rowsAsObject().get(0).get("t");
				
				System.out.println(json);
				/// jsonObject >>> JSONObject
				
				documentDetails = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(json);
				
			}else {
				result = cluster.bucket(bucketName).scope(scopeName).collection(collectionName).get(documentId);
				JSONObject json = (JSONObject) parser.parse(result.contentAsObject().toString());
				
				documentDetails = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(json);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println(documentDetails);
		
		return documentDetails;
	}
	
 
	public Object dropDocument(HttpServletRequest request) {
		
		String bucketName = request.getParameter("bucketName");
		String documentId = request.getParameter("documentId");
		String scopeName = request.getParameter("scopeName");
		String collectionName = request.getParameter("collectionName");
		
		try {
			cluster.bucket(bucketName).scope(scopeName).collection(collectionName).remove(documentId);
		}
		catch(Exception e) {
			e.printStackTrace();
			return "비정상적인 실행입니다.";
		}
		return "문서가 정상적으로 삭제되었습니다.";
	}
	
	// Query

	public Object getQueryResult(HttpServletRequest request) throws Exception {

		try {
			String queryInput = request.getParameter("queryInput");
			System.out.println(queryInput);
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
			
			QueryResult result = cluster.query(queryInput);
			
			if(result.rowsAsObject().toString().length()<0)
				resultMap.put("allRows", "실행이 완료되었습니다.");
			else
				resultMap.put("allRows", result.rowsAsObject().toString());
			
			return resultMap;
		}
		catch(PlanningFailureException e) {
			
			return e.toString();
		}
		catch(IndexFailureException e) {
			
			return e.toString();
		}
	}

	// FTS 
	public Object getFTIList() {
		
		if(dto == null)
			return null;
		
		StringBuilder command = new StringBuilder();
		command.append("curl -u ");
		command.append(dto.getUsername());
		command.append(":");
		command.append(dto.getPassword());
		command.append(" http://");
		command.append(dto.getHostname());
		command.append(":8094/api/index");
		System.out.println(command);
		
		List<Object> list = new ArrayList<Object>();
		
		
		JSONObject json;
		try {
			json = (JSONObject) parser.parse((String) serviceUtil.curlExcute(command.toString()).get("result"));
			JSONObject ftiJson = (JSONObject)((JSONObject)json.get("indexDefs")).get("indexDefs");
			
			Iterator i = ftiJson.keySet().iterator();
			
			while(i.hasNext()) {
				JSONObject fti = (JSONObject) ftiJson.get(i.next());
				
				Map<Object, Object> map = new HashMap<Object, Object>();
				map.put("name", fti.get("name"));
				map.put("bucket", fti.get("sourceName"));
				
				list.add(map);
				
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return list;
	}

	public Object getFTSResult(HttpServletRequest request) {
		List<Object> list = new ArrayList<Object>();

		try {
			String indexName = request.getParameter("indexName");
			String searchText = request.getParameter("searchText");
			
			MatchQuery query = SearchQuery.match(searchText);
			
			SearchResult result = cluster.searchQuery(indexName, query, SearchOptions.searchOptions().limit(10000));
			
			for(SearchRow row : result.rows()) {
				list.add(row.id());
			}
		}catch(IllegalArgumentException e) {
			list.add("잘못된 접근입니다,");
		}
		
		return list;
	}
	
	// Making Random Data
	
	public Object makeRandomData(HttpServletRequest request) throws Exception {
		
		HashMap<String,Object> map = serviceUtil.getRequestToMap(request);
		
		int threadCount = Integer.parseInt((String)map.get("threadCount"));
		
		if(cluster == null)
			return "서버를 연결해주십시오.";
		
		Runnable couchTr = new CouchbaseThread(map,cluster.bucket((String)map.get("bucketName")));
		for (int i = 0; i < threadCount; i++) {
		  
			Thread t1 = new Thread(couchTr);
			t1.start(); 
		}
		
		return "잠시 후 문서들이 생성됩니다.";
	}
	
	// Create Primary Index
	
	public String createPrimaryIndex(HttpServletRequest request) {
		
		String bucketName = request.getParameter("bucketName");
		
		System.out.println(serviceUtil.getRequestToMap(request).toString());
		
		if(bucketName == null || bucketName =="") {
			
			if(bucket == null)
				return "Bucket을 연결해주세요.";
			bucketName = bucket.name();
		}
		
		if(cluster.buckets().getBucket(bucketName).bucketType() == BucketType.EPHEMERAL) {
			return "Ephemeral Bucket은 MOI 인덱스만 사용가능합니다.\nIndex Storage Mode를 Memory-Optimized로 변경해주십시오.";
		}
		 
		 StringBuilder statement = new StringBuilder();
		 
		 statement.append("create Primary Index ");
		 statement.append(bucketName);
		 statement.append("_primary_index on `");
		 statement.append(bucketName);
		 statement.append("`");
		 
		 System.out.println(statement);
		 try {
			 QueryResult result = cluster.query(statement.toString());
			 return "Primary Index가 생성되었습니다.";
		 }
		 catch(IndexExistsException e) {
			 
			 return "IndexExistsException";
		 }
		 catch(IndexFailureException e) {
			 
			 return "IndexFailureException";
		 }
	}
	
	// Upload File
	
	public Object uploadFile(MultipartHttpServletRequest mRequest) throws Exception {
		
		if(bucket == null)
			return "Bucket을 연결해주세요.";
		
		String createLocalPath = "C:/upload/"; 			// 로컬 업로드 경로
		File newFile = new File(createLocalPath);
		String importFilePath = "";						// 파일 경로 + 파일명
		String docID = mRequest.getParameter("docId");	// docID
		String cbPath = mRequest.getParameter("cbPath");
		String bucketName = mRequest.getParameter("bucketName");
		String scopeName = mRequest.getParameter("scopeName");
		String collectionName = mRequest.getParameter("collectionName");
		String columnOfExcel = mRequest.getParameter("columnOfExcel");
		String fileExtension = mRequest.getParameter("fileExtension");
		
		if(columnOfExcel == null)
			columnOfExcel = "false";
		
		if (!newFile.isDirectory()) { 			// 파일 디렉토리 확인 및 디렉토리 생성
			newFile.mkdir();
		}
		
		StringBuilder statement = new StringBuilder();
		 
		// select count(*) from `test`as t where meta(t).id like "test__%";
		statement.append("select count(*) from `");
		statement.append(bucket.name());
		statement.append("` as t where meta(t).id like \"");
		statement.append(docID+"__%\"");
		System.out.println(statement);
		QueryResult result = cluster.query(statement.toString());
		 
		List<JsonObject> list = result.rowsAsObject();
		JsonObject content =list.get(0);
		int num = Integer.parseInt(content.get("$1").toString());
		
		if(num != 0)
			docID = docID+"_"+(num+1);
		
		
		MultipartFile file = mRequest.getFile("fileName"); 	// fileName Request
		String originalName = file.getOriginalFilename(); // Original FileName
		importFilePath = createLocalPath + originalName; 				// File Path
		
		if(!new File(importFilePath).exists()) {
			file.transferTo(new File(importFilePath));		//FilePath에 파일 생성
		}
		
		if(StringUtils.isNotBlank(docID)) {			//문서 아이디가 공백이 아니며, 쓰레드 개수가 0 이상일 때
			if (fileExtension.equals("csv")) {					//파일 확장자가 csv일 경우
				
				StringBuilder csvCommand = new StringBuilder();
				
				csvCommand.append(cbPath);
				csvCommand.append("/cbimport csv -c couchbase://");
				csvCommand.append(dto.getHostname());
				csvCommand.append(" -u ");
				csvCommand.append(dto.getUsername());
				csvCommand.append(" -p ");
				csvCommand.append(dto.getPassword());
				csvCommand.append(" -b ");
				csvCommand.append(bucketName);
				csvCommand.append(" --scope-collection-exp ");
				csvCommand.append(scopeName);
				csvCommand.append(".");
				csvCommand.append(collectionName);
				csvCommand.append(" -d file://");
				csvCommand.append(importFilePath);
				csvCommand.append(" -g ");
				if(columnOfExcel.equals("true")) {
					csvCommand.append("%");
					csvCommand.append(docID);
					csvCommand.append("%");
				}else
					csvCommand.append(docID);
				csvCommand.append(" -t 2 ");
				System.out.println(csvCommand);
				
				String curlResult = serviceUtil.curlExcute(csvCommand.toString()).get("result").toString();
				
				return curlResult.substring(curlResult.indexOf("successfully"));
				
			} else if (fileExtension.equals("json")) {			//파일 확장자가 json일 경우
				
				StringBuilder jsonCommand = new StringBuilder();
				
				jsonCommand.append(cbPath);
				jsonCommand.append("/cbimport json -c couchbase://");
				jsonCommand.append(dto.getHostname());
				jsonCommand.append(" -u ");
				jsonCommand.append(dto.getUsername());
				jsonCommand.append(" -p ");
				jsonCommand.append(dto.getPassword());
				jsonCommand.append(" -b ");
				jsonCommand.append(bucketName);
				jsonCommand.append(" --scope-collection-exp ");
				jsonCommand.append(scopeName);
				jsonCommand.append(".");
				jsonCommand.append(collectionName);
				jsonCommand.append(" -d file://");
				jsonCommand.append(importFilePath);
				jsonCommand.append(" -f lines -g ");
				if(columnOfExcel.equals("true")) {
					jsonCommand.append("%");
					jsonCommand.append(docID);
					jsonCommand.append("%");
				}else
					jsonCommand.append(docID);
				jsonCommand.append(" -t 2 ");
				System.out.println(jsonCommand);
				
				String curlResult = serviceUtil.curlExcute(jsonCommand.toString()).get("result").toString();
				
				return curlResult.substring(curlResult.indexOf("successfully"));
				
			} else if (fileExtension.equals("jsonList")){
				
				StringBuilder jsonCommand = new StringBuilder();
				
				jsonCommand.append(cbPath);
				jsonCommand.append("/cbimport json -c couchbase://");
				jsonCommand.append(dto.getHostname());
				jsonCommand.append(" -u ");
				jsonCommand.append(dto.getUsername());
				jsonCommand.append(" -p ");
				jsonCommand.append(dto.getPassword());
				jsonCommand.append(" -b ");
				jsonCommand.append(bucketName);
				jsonCommand.append(" --scope-collection-exp ");
				jsonCommand.append(scopeName);
				jsonCommand.append(".");
				jsonCommand.append(collectionName);
				jsonCommand.append(" -d file://");
				jsonCommand.append(importFilePath);
				jsonCommand.append(" -f list -g ");
				if(columnOfExcel.equals("true")) {
					jsonCommand.append("%");
					jsonCommand.append(docID);
					jsonCommand.append("%");
				}else
					jsonCommand.append(docID);
				jsonCommand.append(" -t 2 ");
				System.out.println(jsonCommand);
				
				String curlResult = serviceUtil.curlExcute(jsonCommand.toString()).get("result").toString();
				
				return curlResult.substring(curlResult.indexOf("successfully"));
				
			}
			else {
				return "확장자가 잘못되었습니다.";
			}
		}
		return "?";
	}

	// Log
	
	public List<Map<String,Object>> getLogs() {
		
		// curl -v -X GET -u Administrator:admin123 http://localhost:8091/sasl_logs/[logs-name]
		
		if(dto == null)
			return null;
		
		StringBuilder command = new StringBuilder();
		command.append("curl -X GET -u ");
		command.append(dto.getUsername());
		command.append(":");
		command.append(dto.getPassword());
		command.append(" http://");
		command.append(dto.getHostname());
		command.append(":");
		command.append(dto.getPortNumber());
		command.append("/sasl_logs/");
		
		String[] logs = { "views" ,
						"query"
						
						};
//      너무 느리고 쓸모없는 정보라 주석처리		
//		List<Map<String,Object>> logList = serviceUtil.logMaker(command, logs);
		
//		return logList;
		return null;
	}

	// Settings
	
	public Object setSettings(SettingDTO settingDTO){
		
		// https://docs.couchbase.com/server/6.5/manage/manage-settings/general-settings.html#configure-general-settings-with-the-rest-api
		
		if(dto == null)
			return "서버를 연결시켜주십시오.";
		try {
			System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(settingDTO));
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		StringBuilder baseCommand = new StringBuilder();
		baseCommand.append("curl -v -X POST -u ");
		baseCommand.append(dto.getUsername());
		baseCommand.append(":");
		baseCommand.append(dto.getPassword());
		baseCommand.append(" http://");
		baseCommand.append(dto.getHostname());
		baseCommand.append(":");
		baseCommand.append(dto.getPortNumber());
		
		StringBuilder clusterCommand = new StringBuilder();
		clusterCommand.append(baseCommand);
		clusterCommand.append("/pools/default -d clusterName=");
		clusterCommand.append(settingDTO.getClusterName());
		clusterCommand.append(" -d memoryQuota=");
		clusterCommand.append(settingDTO.getDataServiceQuota());
		clusterCommand.append(" -d indexMemoryQuota=");
		clusterCommand.append(settingDTO.getIndexServiceQuota());
		clusterCommand.append(" -d ftsMemoryQuota=");
		clusterCommand.append(settingDTO.getSearchServiceQuota());
		clusterCommand.append(" -d cbasMemoryQuota=");
		clusterCommand.append(settingDTO.getAnalyticsServiceQuota());
		clusterCommand.append(" -d eventingMemoryQuota=");
		clusterCommand.append(settingDTO.getEventingServiceQuota());
		System.out.println(clusterCommand);
		
		StringBuilder noticeCommand = new StringBuilder();
		noticeCommand.append(baseCommand);
		noticeCommand.append("/settings/stats -d sendStats=");
		noticeCommand.append(settingDTO.isNoticeUpdate());
		System.out.println(noticeCommand);
		
		StringBuilder rebalanceCommand = new StringBuilder();
		rebalanceCommand.append(baseCommand);
		rebalanceCommand.append("/settings/retryRebalance -d enabled=");
		rebalanceCommand.append(settingDTO.isRetryRebalance_Enable());
		rebalanceCommand.append(" -d afterTimePeriod=");
		rebalanceCommand.append(settingDTO.getRetryRebalance_afterTimePeriod());
		rebalanceCommand.append(" -d maxAttempts=");
		rebalanceCommand.append(settingDTO.getRetryRebalance_maxAttempts());
		System.out.println(rebalanceCommand);
		
		StringBuilder nodeCommand = new StringBuilder();
		nodeCommand.append(baseCommand);
		nodeCommand.append("/settings/autoFailover -d enabled=");
		nodeCommand.append(settingDTO.isAutoFailoverCheck());
		nodeCommand.append(" -d timeout=");
		nodeCommand.append(settingDTO.getFailoverSecondTime());
		nodeCommand.append(" -d failoverOnDataDiskIssues[enabled]=");
		nodeCommand.append(settingDTO.isAutoFailoverDataError());
		nodeCommand.append(" -d failoverOnDataDiskIssues[timePeriod]=");
		nodeCommand.append(settingDTO.getAutoFailoverDataErrorSecondTime());
		nodeCommand.append(" -d failoverServerGroup=");
		nodeCommand.append(settingDTO.isAutoFailoverServerGroup());
		nodeCommand.append(" -d maxCount=");
		nodeCommand.append(settingDTO.getXDCRMaximumProcesses());
		nodeCommand.append(" -d canAbortRebalance=");
		nodeCommand.append(settingDTO.isAutoFailoverStopRebalance());
		System.out.println(nodeCommand);
		
		try {
			serviceUtil.curlExcute(clusterCommand.toString());
			serviceUtil.curlExcute(noticeCommand.toString());
			serviceUtil.curlExcute(rebalanceCommand.toString());
			serviceUtil.curlExcute(nodeCommand.toString());
		}
		catch(Exception e) {
			e.printStackTrace();
			return "값이 잘못되었습니다.";
		}
		return "정상적으로 실행되었습니다.";
		
	}

	public Object setCompactions(CompactionDTO compactions){
		
		if(dto == null)
			return "먼저 서버를 연결해주십시오.";
		try {
			System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(compactions));
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		StringBuilder baseCommand = new StringBuilder();
		baseCommand.append("curl -i -X POST -u ");
		baseCommand.append(dto.getUsername());
		baseCommand.append(":");
		baseCommand.append(dto.getPassword());
		baseCommand.append(" http://");
		baseCommand.append(dto.getHostname());
		baseCommand.append(":");
		baseCommand.append(dto.getPortNumber());
		
		StringBuilder compactionCommand = new StringBuilder();
		compactionCommand.append(baseCommand);
		compactionCommand.append("/controller/setAutoCompaction");
		if(compactions.isFragmentationCheckDatabasePer()) {
			compactionCommand.append(" -d databaseFragmentationThreshold[percentage]=");
			compactionCommand.append(compactions.getFragmentationPercentDatabase());
		}
		if(compactions.isFragmentationCheckDatabaseMB()) {
			compactionCommand.append(" -d databaseFragmentationThreshold[size]=");
			int mb = Integer.parseInt(compactions.getFragmentationMBDatabase());
			compactionCommand.append(mb*1024*1024);
		}
		if(compactions.isFragmentationCheckViewPer()) {
			compactionCommand.append(" -d viewFragmentationThreshold[percentage]=");
			compactionCommand.append(compactions.getFragmentationPercentView());
		}
		if(compactions.isFragmentationCheckViewMB()){
			compactionCommand.append(" -d viewFragmentationThreshold[size]=");
			int mb = Integer.parseInt(compactions.getFragmentationMBView());
			compactionCommand.append(mb*1024*1024);
		}
		if(compactions.isTimeIntervalCheck()) {
			compactionCommand.append(" -d allowedTimePeriod[fromHour]=");
			compactionCommand.append(compactions.getCompactionFromHour());
			compactionCommand.append(" -d allowedTimePeriod[fromMinute]=");
			compactionCommand.append(compactions.getCompactionFromMinute());
			compactionCommand.append(" -d allowedTimePeriod[toHour]=");
			compactionCommand.append(compactions.getCompactionToHour());
			compactionCommand.append(" -d allowedTimePeriod[toMinute]=");
			compactionCommand.append(compactions.getCompactionToMinute());
		}
		
		compactionCommand.append(" -d allowedTimePeriod[abortOutside]=");
		compactionCommand.append(compactions.isAbortCompaction());
		compactionCommand.append(" -d parallelDBAndViewCompaction=");
		compactionCommand.append(compactions.isCompactParallel());
		compactionCommand.append(" -d purgeInteval=");
		compactionCommand.append(compactions.getPurgeInterval());
		System.out.println(compactionCommand);
		
		Map<String,Object> resultMap;
		try {
			resultMap = serviceUtil.curlExcute(compactionCommand.toString());
		}
		catch(Exception e) {
			e.printStackTrace();
			return "오류입니다";
		}
		
		if(resultMap.get("result").toString().contains("HTTP/1.1 200 OK")) {
			return "설정이 완료되었습니다.";
		}
		
		return resultMap.get("result");
	}
	
	
	public Object downSampleBucket(String sampleBucketLists[]) {
		
		if(dto== null)
			return "서버 연결을 해주십시오.";
		
		List<String> sampleBucketList = new ArrayList<String>();
		
		for(int i=0;i<sampleBucketLists.length;i++) {
			try {
				cluster.buckets().getBucket(sampleBucketLists[i]);
			}
			catch(BucketNotFoundException e) {
				sampleBucketList.add("\\\""+sampleBucketLists[i]+"\\\"");
			}
		}
		
		StringBuilder bucketCommand;
		if(sampleBucketList.size() ==0)
			return "버킷이 이미 존재합니다.";
		else {
			bucketCommand = new StringBuilder();
			bucketCommand.append("curl -u ");
			bucketCommand.append(dto.getUsername());
			bucketCommand.append(":");
			bucketCommand.append(dto.getPassword());
			bucketCommand.append(" http://");
			bucketCommand.append(dto.getHostname());
			bucketCommand.append(":");
			bucketCommand.append(dto.getPortNumber());
			bucketCommand.append("/sampleBuckets/install -d [");
			bucketCommand.append(sampleBucketList.get(0));
			if(sampleBucketList.size()>1) {
				bucketCommand.append(",");
				bucketCommand.append(sampleBucketList.get(1));
				if(sampleBucketList.size()>2) {
					bucketCommand.append(",");
					bucketCommand.append(sampleBucketList.get(2));
					bucketCommand.append("]");
				}else
					bucketCommand.append("]");
			}
			else 
				bucketCommand.append("]");
		}
		System.out.println(bucketCommand);
		
		String result = serviceUtil.curlExcute(bucketCommand.toString()).get("result").toString();
		
		if(result.contains("정상적으로 완료")) {
			result = "잠시 후 지정된 Bucket이 생성됩니다.";
		}
		
		
		return result;
	}

	// querySetting = whiteList error 
	public Object setQuerySettings(querySettingsDTO querySettings) {
		
		if(dto == null)
			return "서버 연결을 먼저 해주십시오.";
		
		try {
			System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(querySettings));
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		StringBuilder querySetCommand = new StringBuilder();
		querySetCommand.append("curl -v -u ");
		querySetCommand.append(dto.getUsername());
		querySetCommand.append(":");
		querySetCommand.append(dto.getHostname());
		querySetCommand.append(" http://");
		querySetCommand.append(dto.getHostname());
		querySetCommand.append(":");
		querySetCommand.append(dto.getPortNumber());
		querySetCommand.append("/settings/querySettings -d queryTmpSpaceDir=\"");
		querySetCommand.append(querySettings.getQueryTmpSpaceDir());
		querySetCommand.append("\" -d queryTmpSpaceSize=");
		querySetCommand.append(querySettings.getQueryTmpSpaceSize());
		querySetCommand.append(" -d queryPipelineBatch=");
		querySetCommand.append(querySettings.getQueryPipelineBatch());
		querySetCommand.append(" -d queryPipelineCap=");
		querySetCommand.append(querySettings.getQueryPipelineCap());
		querySetCommand.append(" -d queryScanCap=");
		querySetCommand.append(querySettings.getQueryScanCap());
		querySetCommand.append(" -d queryTimeout=");
		querySetCommand.append(querySettings.getQueryTimeout());
		querySetCommand.append(" -d queryPreparedLimit=");
		querySetCommand.append(querySettings.getQueryPreparedLimit());
		querySetCommand.append(" -d queryCompletedLimit=");
		querySetCommand.append(querySettings.getQueryPreparedLimit());
		querySetCommand.append(" -d queryCompletedThreshold=");
		querySetCommand.append(querySettings.getQueryCompletedThreshold());
		querySetCommand.append(" -d queryLogLevel=");
		querySetCommand.append(querySettings.getQueryLogLevel());
		querySetCommand.append(" -d queryMaxParallelism=");
		querySetCommand.append(querySettings.getQueryMaxParallelism());
		querySetCommand.append(" -d queryN1QLFeatCtrl=");
		querySetCommand.append(querySettings.getQueryN1QLFeatCtrl());
		System.out.println(querySetCommand);
		
		String result1 = serviceUtil.curlExcute(querySetCommand.toString()).get("result").toString();
		System.out.println(result1);
		if(result1.contains("queryTmpSpaceDir")) {
			result1 = "설정이 완료되었습니다";
		}
		
		
		
		// curl -v -X POST -u Admin:tf4220 http://localhost:8091/settings/querySettings/curlWhitelist -d {"all_access": false, "allowed_urls": ["https://company1.com"], disallowed_urls": ["https://company2.com"]}
//		StringBuilder whiteListCommand = new StringBuilder();
//		whiteListCommand.append("curl -v -u ");
//		whiteListCommand.append(dto.getUsername());
//		whiteListCommand.append(":");
//		whiteListCommand.append(dto.getPassword());
//		whiteListCommand.append(" http://");
//		whiteListCommand.append(dto.getHostname());
//		whiteListCommand.append(":");
//		whiteListCommand.append(dto.getPortNumber());
//		whiteListCommand.append("/settings/querySettings/curlWhitelist -d {\r\"all_access\":");
//		whiteListCommand.append(querySettings.isCurlAccessCheck());
//		
//		if(querySettings.isCurlAccessCheck()==false) {
//			whiteListCommand.append(",\r\"allowed_urls\": [");
//			whiteListCommand.append(querySettings.getAllowedURL());
//			whiteListCommand.append("],\r\"disallowed_urls\": [");
//			whiteListCommand.append(querySettings.getDisallowedURL());
//			whiteListCommand.append("]}");
//			
//		}else
//			whiteListCommand.append("}");
//		
//		System.out.println(whiteListCommand);
//		
//		String result = serviceUtil.curlExcute(whiteListCommand.toString()).get("result").toString();
//		
//		System.out.println(result);

		
		
		return "설정이 완료되었습니다.";
	}
	
	// Analytics
	public Object analyticsQuery(HttpServletRequest request) {
		
		
		if(cluster == null) {
			return "서버와 연결해주십시오.";
		}
		
		Map<String,Object> resultMap= new HashMap<String,Object>();
		String statement = request.getParameter("queryInput");
		
		try {
			AnalyticsResult result = cluster.analyticsQuery(statement);
			resultMap.put("allRows", result.rowsAsObject().toString());
				
		}
		catch(DatasetNotFoundException e) {
			return "dataSet이 존재하지 않습니다.";
		}
		catch(Exception e) {
			e.printStackTrace();
			return e.toString();
		}
		
		return resultMap;
	}

	// Eventing
	public Object getEventFunctionList() {
		
		if(dto == null)
			return "서버를 연결해주세요.";
		
		StringBuilder command = new StringBuilder();
		
		command.append("curl -X GET http://");
		command.append(dto.getUsername());
		command.append(":");
		command.append(dto.getPassword());
		command.append("@");
		command.append(dto.getHostname());
		command.append(":8096/api/v1/functions");
		
		String result = (String) serviceUtil.curlExcute(command.toString()).get("result");
		
		try {
			JSONArray jsonArray = (JSONArray) parser.parse(result);
			List<Object> list = new ArrayList<Object>();
			
			for(int i=0; i<jsonArray.size();i++) {
				JSONObject json = (JSONObject)jsonArray.get(i);
				Map<String,Object> resultMap = new HashMap<String,Object>();

				resultMap.put("functionName", (String)json.get("appname")); // functionName
				resultMap.put("functionCode", (String)json.get("appCode")); // functionName
				resultMap.put("bucketInfo", (JSONObject) json.get("depcfg")); // functionName
				resultMap.put("settings", (JSONObject) json.get("settings")); // functionName
				
				list.add(resultMap);
			}
			
			return list;
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return "ERROR";
	}
	
	@SuppressWarnings("unchecked")
	public Object createEventFunction(HttpServletRequest request) {
		
		Map<String,Object> map = serviceUtil.getRequestToMap(request);
		
		System.out.println((String)map.get("description"));
		
		// curl http://Administrator:admin123@localhost:8096/api/v1/functions/testFunction
		
		StringBuffer getSampleStatment = new StringBuffer();
		getSampleStatment.append("curl http://");
		getSampleStatment.append(dto.getUsername());
		getSampleStatment.append(":");
		getSampleStatment.append(dto.getPassword());
		getSampleStatment.append("@");
		getSampleStatment.append(dto.getHostname());
		getSampleStatment.append(":8096/api/v1/functions/testFunction");
		System.out.println(getSampleStatment);
		
		String result = serviceUtil.curlExcute(getSampleStatment.toString()).get("result").toString();
		
		try {
			JSONObject json = (JSONObject) parser.parse(result);
			
			JSONObject depcfg = (JSONObject)json.get("depcfg");
			
			// binding 한 Buckets List
			JSONArray buckets = (JSONArray)depcfg.get("buckets");
			
			depcfg.put("source_bucket", (String)map.get("srcBucket"));
			depcfg.put("source_scope", (String)map.get("srcBucketScope"));
			depcfg.put("source_collection", (String)map.get("srcBucketScopeCollection") );
			depcfg.put("metadata_bucket", (String)map.get("metaBucket"));
			depcfg.put("metadata_scope", (String)map.get("metaBucketScope"));
			depcfg.put("metadata_collection", (String)map.get("metaBucketScopeCollection") );
			
			json.put("appname", (String)map.get("functionName"));
			json.put("description", (String)map.get("description"));
			json.put("log_level", (String)map.get("logLevel"));
			json.put("default_stream_boundary", (String)map.get("feedBoundary"));
			json.put("dcp_stream_boundary", (String)map.get("feedBoundary"));
			
			
			
			System.out.println(json);
			
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		
		return null;
	}
}

