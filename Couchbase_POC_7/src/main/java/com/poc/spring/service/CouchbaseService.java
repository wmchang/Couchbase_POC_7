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
import com.couchbase.client.core.error.DocumentExistsException;
import com.couchbase.client.core.error.IndexExistsException;
import com.couchbase.client.core.error.IndexFailureException;
import com.couchbase.client.core.error.PlanningFailureException;
import com.couchbase.client.core.service.ServiceType;
import com.couchbase.client.java.Bucket;
import com.couchbase.client.java.Cluster;
import com.couchbase.client.java.ClusterOptions;
import com.couchbase.client.java.env.ClusterEnvironment;
import com.couchbase.client.java.env.ClusterEnvironment.Builder;
import com.couchbase.client.java.json.JsonObject;
import com.couchbase.client.java.kv.GetResult;
import com.couchbase.client.java.kv.MutationResult;
import com.couchbase.client.java.manager.bucket.BucketManager;
import com.couchbase.client.java.manager.bucket.BucketSettings;
import com.couchbase.client.java.manager.bucket.BucketType;
import com.couchbase.client.java.query.QueryResult;
import com.couchbase.client.java.search.SearchOptions;
import com.couchbase.client.java.search.SearchQuery;
import com.couchbase.client.java.search.queries.MatchQuery;
import com.couchbase.client.java.search.result.SearchResult;
import com.couchbase.client.java.search.result.SearchRow;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.poc.spring.dto.BucketSettingDTO;
import com.poc.spring.dto.ConnectDTO;
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
	
	
	// Bucket
	public List<Object> getBucketList(){
		// curl -u Administrator:password http://10.5.2.54:8091/pools/default/buckets
		
		if(dto == null)
			return null;
		else if(bucket == null)
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
		
		
		BucketManager manager = cluster.buckets();
		
		if(bucket.name().equals(request.getParameter("bucketName"))) {
			return "연결되어있는 버킷은 제거할 수 없습니다."; 
		}
		manager.dropBucket(request.getParameter("bucketName"));
		
		return "삭제되었습니다.";
	}
	
	// Document
	public Object getDocumentList(HttpServletRequest request){
		
		try {
			if(bucket == null)
				return null;
			 // select meta(t).id from `test` as t limit 30;
			
			String limit;
			if(request.getParameter("limit")==null)
				limit = "30";
			else
				limit = request.getParameter("limit");
			
			String bucketName;
			if(request.getParameter("bucketName")==null)
				bucketName = bucket.name();
			else
				bucketName = request.getParameter("bucketName");
			
			if(cluster.buckets().getBucket(bucketName).bucketType() == BucketType.MEMCACHED) {
				
				return "MemcachedBucketNotSupported";
			}
			
			 StringBuilder statement = new StringBuilder();
			 
			 if(limit.length() < 0)
				 limit = "30";
			 
			 statement.append("select *, meta(t).id from `");
			 statement.append(bucketName);
			 statement.append("` as t limit ");
			 statement.append(limit);
			 System.out.println(statement);
			 
			 List<Object> list = new ArrayList<Object>();
			 
			 QueryResult result = cluster.query(statement.toString());
			 
			 for(JsonObject row : result.rowsAsObject()) {
	
				 Map<Object, Object> resultMap = new HashMap<Object, Object>();
				 resultMap.put("id", row.getString("id"));
				 resultMap.put("content",  row.getObject("t") );
				 list.add(resultMap);
			 }
			 return list;
		}
		catch(PlanningFailureException e) {
			return "NotExistsIndex";
		}
	}

	public Object addDocument(HttpServletRequest request){

		String bucketName = request.getParameter("bucketName");
		String documentId = request.getParameter("documentId");
		String documentText = request.getParameter("documentText");
		
		if(bucketName == null)
			bucketName = bucket.name();
		
		JSONObject obj;
		try {
			obj = (JSONObject) parser.parse(documentText);
		
		String jsonStr = obj.toString();
		JsonObject content = JsonObject.fromJson(jsonStr);

			
		cluster.bucket(bucketName).defaultCollection().insert(documentId, content);
			
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
		
		JSONObject obj = (JSONObject) parser.parse(documentText);
		String jsonStr = obj.toString();
		
		JsonObject content = JsonObject.fromJson(jsonStr);
		
		String bucketName;
		if(request.getParameter("bucketName") == null)
			bucketName = bucket.name();
		else
			bucketName = request.getParameter("bucketName");
		
		cluster.bucket(bucketName).defaultCollection().upsert(documentId, content);
		
		return "문서 '"+documentId + "' 가 정상적으로 변경되었습니다.";
	}
	
	public Object getDocumentDetails(String documentId,String bucketName) {

		StringBuilder statement = new StringBuilder();
		String nowBucketName;

		// select * from `test` as t where meta(t).id ="docId";
		
		if(bucketName==null || bucketName=="")
			nowBucketName=bucket.name();
		else
			nowBucketName = bucketName;

		statement.append("select * from `");
		statement.append(nowBucketName);
		statement.append("` as t where meta(t).id =\"");
		statement.append(documentId + "\"");
		
		System.out.println(statement);
		
		GetResult result = cluster.bucket(bucketName).defaultCollection().get(documentId);
		
		String documentDetails = null;
		try {
			JSONObject a = (JSONObject) parser.parse(result.contentAsObject().toString());
			documentDetails = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(a);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return documentDetails;
	}
	
	public Object dropDocument(String bucketName,String documentId) {
		
		MutationResult result = cluster.bucket(bucketName).defaultCollection().remove(documentId);
		System.out.println(result.toString());
		 
		return "문서가 정상적으로 삭제되었습니다.";
	}
	
	// Query
	public Object getQueryResult(HttpServletRequest request) throws Exception {

		try {
			String queryInput = request.getParameter("queryInput");
			System.out.println(queryInput);
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
			
			QueryResult result = cluster.query(queryInput);
			
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
		
		String indexName = request.getParameter("indexName");
		String searchText = request.getParameter("searchText");
		
		MatchQuery query = SearchQuery.match(searchText);
		
		SearchResult result = cluster.searchQuery(indexName, query, SearchOptions.searchOptions().limit(100));
		List<Object> list = new ArrayList<Object>();
		
		for(SearchRow row : result.rows()) {
			list.add(row.id());
		}
		
		return list;
	}
	
	// Making Random Data
	public Object makeRandomData(HttpServletRequest request) throws Exception {

		int docSize = Integer.parseInt(request.getParameter("docSize"));
		int docIdSize = Integer.parseInt(request.getParameter("docIdSize"));
		int docCount = Integer.parseInt(request.getParameter("docCount"));
		int threadCount = Integer.parseInt(request.getParameter("threadCount"));
		
		if(bucket == null)
			return "먼저 Bucket을 연결해주십시오.";
		
		Runnable couchTr = new CouchbaseThread(docSize, docCount, docIdSize, bucket);
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
	}
	
	public Map<String, Object> uploadFile(MultipartHttpServletRequest mRequest) throws Exception {
		
		
		String strLocalPath = "C:/upload/"; 			// 로컬 업로드 경로
		File file = new File(strLocalPath);				// 로컬 경로 파일
		String strFilePath = "";						// 파일 경로 + 파일명
		String docID = mRequest.getParameter("docId");	// docID
		
		 StringBuilder statement = new StringBuilder();
		 
		 // select count(*) from `test`as t where meta(t).id like "test__%";
		 
		 statement.append("select count(*) from `");
		 statement.append(bucket.name());
		 statement.append("` as t where meta(t).id like \"");
		 statement.append(docID+"__%\"");
		 
		 QueryResult result = cluster.query(statement.toString());
		 
		 
		 
		 List<JsonObject> list = result.rowsAsObject();
		 
		 JsonObject content =list.get(0);
		 int num = Integer.parseInt(content.get("$1").toString());
		 
		 docID = docID+"_"+(num+1);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if (!file.isDirectory()) { 			// 파일 디렉토리 확인 및 디렉토리 생성
			file.mkdir();
		}
		
		MultipartFile multipartFile = mRequest.getFile("fileName"); 	// fileName Request
		String strOriginFileName = multipartFile.getOriginalFilename(); // Original FileName
		strFilePath = strLocalPath + strOriginFileName; 				// File Path

		System.out.println(strFilePath);
		
		int intSubstrDot = strOriginFileName.lastIndexOf("."); 					// 파일 확장자
		String strExtention = strOriginFileName.substring(intSubstrDot + 1); 	// 파일 확장자
		
		String strThreadCount = mRequest.getParameter("threadCount");
		int threadCnt = 0;
		if(!"".equals(strThreadCount)) {
			threadCnt = Integer.parseInt(strThreadCount);	 // thread Count
		}

		if(!multipartFile.isEmpty()) {			//파일이 선택됐을 경우
			
			if(!new File(strFilePath).exists()) {
				multipartFile.transferTo(new File(strFilePath));		//FilePath에 파일 생성
			}
			resultMap.put("suc","OK");
			
			if(StringUtils.isNotBlank(docID) && threadCnt>0) {			//문서 아이디가 공백이 아니며, 쓰레드 개수가 0 이상일 때
				if (strExtention.equals("csv")) {					//파일 확장자가 csv일 경우
					
					CSVtoJSON csvToJson = new CSVtoJSON(bucket, multipartFile, strFilePath, docID, threadCnt, strExtention);
					csvToJson.CSVtoJSON();
					resultMap.put("mapFlag", "3");
					resultMap.put("csvInsert", "csv 파일 \"" + strOriginFileName + "\"가 insert 되었습니다.");
			
				} else if (strExtention.equals("json")) {			//파일 확장자가 json일 경우
					
//					Object obj =  parser.parse(new FileReader(strFilePath));
//			        JSONObject jsonObject =  (JSONObject) obj;
//			        String jsonStr = jsonObject.toString();
//					JsonObject content = JsonObject.fromJson(jsonStr);
//					JsonDocument doc = JsonDocument.create(docID, content); 
//					bucket.insert(doc);
					CSVtoJSON csvToJson = new CSVtoJSON(bucket, multipartFile, strFilePath, docID, threadCnt, strExtention);
					csvToJson.jsonUpload();
					resultMap.put("mapFlag","4");
					resultMap.put("jsonInsert","json 파일 \""+strOriginFileName+"\"이 insert 되었습니다.");
					
				} else {										//파일 확장자가 csv, json이 아닌 다른 것일 경우
					System.out.println(strOriginFileName);
					resultMap.put("mapFlag","2");
					resultMap.put("ExtentionsCheck","확장자가 csv 및 json인 파일을 선택해주세요.");
				}
			}
			else {
				resultMap.put("mapFlag","1");
				resultMap.put("idThreadCheck","문서 아이디와 쓰레드 개수에 빈칸 없이 입력해주세요.");
				System.out.println("docID or threadCnt is Null");
			}
		}else {
			resultMap.put("fileCheck","파일을 선택해주세요");
			System.out.println("File is not Selected");
		}

		return resultMap;
	}

	public List<Object> getLogs() {
		
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
		
		List<Object> logList = serviceUtil.logMaker(command, logs);
		
		return logList;
	}

	
	
}
