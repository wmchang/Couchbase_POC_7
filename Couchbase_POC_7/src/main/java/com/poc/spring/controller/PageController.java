package com.poc.spring.controller;

import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.couchbase.client.core.error.ScopeNotFoundException;
import com.couchbase.client.java.manager.collection.CollectionSpec;
import com.poc.spring.service.CouchbaseService;
import com.poc.spring.util.ServiceUtils;

@Controller
public class PageController {
	
	@Autowired
	CouchbaseService couchbaseService;
	
	@Autowired
	ServiceUtils serviceUtil;
	
	private static String yetScopeName = null;
	private static String yetBucketName = null;
	
	@RequestMapping("/")
	public String index() { 
		return "index"; 
	} 
	
	@RequestMapping("/common/header")
	public String header() { 
		return "/common/header"; 
	} 
	
	@RequestMapping("/nodeManagePage")
	public String nodeManagePage(Model model) {
		model.addAttribute("nodeList", couchbaseService.getNodeList());
		return "/nodeManagePage";
	}
	
	@RequestMapping("/bucketManagePage")
	public String bucketManagePage(Model model) {
		model.addAttribute("bucketList", couchbaseService.getBucketListDetail());
		return "/bucketManagePage";
	}
	
	@RequestMapping(value="/documents/documentPage") 
	public String documentPage(Model model,HttpServletRequest request) { 
		
		Map<String,Object> requestMap = serviceUtil.getRequestToMap(request);
		
		String bucketName = null;
		String scopeName = null;
		String collectionName = null;
		
		try {
			if(!requestMap.keySet().contains("bucketName")) { // request에 파라미터가 존재하지않을 때 ( 처음 documentPage에 진입 )
				
				bucketName = couchbaseService.bucket.name();
				scopeName = "_default";
				collectionName = "_default";
				
				requestMap.put("bucketName", bucketName);
				requestMap.put("scopeName", scopeName);
				requestMap.put("collectionName", collectionName);
			}else {
				bucketName = (String) requestMap.get("bucketName");
				scopeName = (String)requestMap.get("scopeName");
				collectionName = (String)requestMap.get("collectionName");
			}
			
			if(!bucketName.equals(yetBucketName) && yetBucketName != null) { // BucketName이 변경되었을 때, Scope와 Collection 초기화
				scopeName = "_default";
				collectionName = "_default";
				
				requestMap.put("scopeName", scopeName);
				requestMap.put("collectionName", collectionName);
			}

			if(!scopeName.equals(yetScopeName) && yetScopeName != null) { // ScopeName이 변경되면, CollectionName이 자동으로 해당 Scope에 존재하는 CollectionName으로 변경
				
				if(scopeName.equals("_default")) {
					collectionName = "_default";
					requestMap.put("collectionName", collectionName);
				}else {
					
					Iterator<CollectionSpec> i = couchbaseService.cluster.bucket(bucketName).collections().getScope(scopeName).collections().iterator();
					collectionName = i.next().name();
					requestMap.put("collectionName", collectionName);
				}
			}
				
		}catch(NullPointerException e) { // bucket 과 연결되지 않았을 때
			return "/documents/documentPage";
		}
		catch(ScopeNotFoundException e) {
			scopeName = "_default";
			collectionName = "_default";
			
			requestMap.put("scopeName", scopeName);
			requestMap.put("collectionName", collectionName);
		}
		
		yetScopeName = scopeName;
		yetBucketName = bucketName;

		model.addAttribute("bucketName",bucketName);
		model.addAttribute("scopeName",scopeName);
		model.addAttribute("collectionName",collectionName);
		
		Object list = couchbaseService.getDocumentList(requestMap);
		
		if(list == null) {
			
			return "/documents/documentPage";
		}else
			model.addAttribute("documentList",list);

		model.addAttribute("bucketList", couchbaseService.getBucketList());
		
		Map<String, Object> resultMap = couchbaseService.getScopeCollection(requestMap);
		model.addAttribute("scopeList", resultMap.get("scopeList"));
		model.addAttribute("collectionList", resultMap.get("collectionList"));
		
		return "/documents/documentPage"; 
	}

	@RequestMapping(value="/documents/newDocument") 
	public String newDocument(Model model, HttpServletRequest request) { 
		
		model.addAttribute("bucketName", request.getParameter("bucketName"));
		return "/documents/newDocument"; 
	}
	
	@RequestMapping(value="/documents/documentDetails") 
	public String documentDetails(Model model, HttpServletRequest request) { 
		
		model.addAttribute("documentId", request.getParameter("documentId"));
		model.addAttribute("documentDetails", couchbaseService.getDocumentDetails(request.getParameter("documentId"),request.getParameter("bucketName")));
		
		String bucketName;
		if(request.getParameter("bucketName")==null || request.getParameter("bucketName") =="")
			bucketName = couchbaseService.bucket.name();
		else
			bucketName = request.getParameter("bucketName");
		model.addAttribute("bucketName",bucketName);
		
		return "/documents/documentDetails"; 
	}
	
	@RequestMapping(value="/queryExcutePage") 
	public String queryExcutePage() { 
		return "queryExcutePage"; 
	}
	
	@RequestMapping(value="/fts/ftsPage") 
	public String ftsPage(Model model) { 
		model.addAttribute("FTIList", couchbaseService.getFTIList());
		return "/fts/ftsPage"; 
	}
	
	@RequestMapping(value="/fts/searchResultPage") 
	public String searchResultPage(Model model,HttpServletRequest request) {
		
		model.addAttribute("bucketName",request.getParameter("bucketName"));
		model.addAttribute("documentList", couchbaseService.getFTSResult(request));
		return "/fts/searchResultPage"; 
	}
	
	@RequestMapping(value="/eventingPage") 
	public String eventingPage() { 
		return "eventingPage"; 
	}
	
	@RequestMapping(value="/analyticsPage") 
	public String analyticsPage() { 
		return "analyticsPage"; 
	}
	
	@RequestMapping("/randomDataPage")
	public String randomDataPage() {
		return "randomDataPage";
	}
	
	@RequestMapping("/CsvOrFileUpsertPage")
	public String CsvOrFileUpsertPage() {
		return "CsvOrFileUpsertPage";
	}
	
	@RequestMapping(value="/logPage") 
	public String logPage(Model model) { 
		
		model.addAttribute("logList", couchbaseService.getLogs());
		return "logPage"; 
	}
	@RequestMapping("/settings/setting")
	public String setting() {
		return "/settings/setting";
	}
	
	@RequestMapping(value="/settings/autoCompactionPage") 
	public String autoCompactionPage() { 
		return "/settings/autoCompactionPage"; 
	}
	
	@RequestMapping(value="/settings/querySettingPage") 
	public String querySettingPage() { 
		return "/settings/querySettingPage"; 
	}
	
	@RequestMapping(value="/settings/sampleBucketPage") 
	public String sampleBucketPage() { 
		return "/settings/sampleBucketPage"; 
	}
	
	@RequestMapping(value="/settings/emailAlertsPage") 
	public String emailAlertsPage() { 
		return "/settings/emailAlertsPage"; 
	}
}
