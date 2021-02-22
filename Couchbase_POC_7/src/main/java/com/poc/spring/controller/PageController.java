package com.poc.spring.controller;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
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
	
	@RequestMapping("/bucket/bucketManagePage")
	public String bucketManagePage(Model model) {
		model.addAttribute("bucketList", couchbaseService.getBucketListDetail());
		return "/bucket/bucketManagePage";
	}
	
	@RequestMapping("/bucket/scopePage")
	public String scopePage(Model model,HttpServletRequest request) {
		model.addAttribute("bucketName", request.getParameter("bucketName"));
		model.addAttribute("scopeList", couchbaseService.getAllScope(request));
		return "/bucket/scopePage";
	}
	
	@RequestMapping("/bucket/addScopePage")
	public String addScopePage(Model model,HttpServletRequest request) {
		model.addAttribute("bucketName", request.getParameter("bucketName"));
		return "/bucket/addScopePage";
	}
	
	@RequestMapping("/bucket/addCollectionPage")
	public String addCollectionPage(Model model,HttpServletRequest request) {
		model.addAttribute("bucketName", request.getParameter("bucketName"));
		model.addAttribute("scopeName", request.getParameter("scopeName"));
		return "/bucket/addCollectionPage";
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
				
			}else {
				bucketName = (String) requestMap.get("bucketName");
				scopeName = (String)requestMap.get("scopeName");
				collectionName = (String)requestMap.get("collectionName");
			}
			
			
			Iterator<CollectionSpec> i = couchbaseService.cluster.bucket(bucketName).collections().getScope(scopeName).collections().iterator();
			List<String> collectionList = new ArrayList<String>();
			
			while(i.hasNext()){
				collectionList.add(i.next().name());
			}
			
			if(!collectionList.contains(collectionName)) {
				
				if(collectionList.contains("_default")) 
					collectionName = "_default";
				else
					collectionName = collectionList.get(0);
			}
						
		}catch(NullPointerException e) { // bucket 과 연결되지 않았을 때
			return "/documents/documentPage";
		}
		catch(ScopeNotFoundException e) {
			scopeName = "_default";
			collectionName = "_default";
		}
		catch(IndexOutOfBoundsException e) {
			scopeName = "_default";
			collectionName = "_default";
		}

		model.addAttribute("bucketName",bucketName);
		model.addAttribute("scopeName",scopeName);
		model.addAttribute("collectionName",collectionName);
		
		requestMap.put("bucketName", bucketName);
		requestMap.put("scopeName", scopeName);
		requestMap.put("collectionName", collectionName);
		
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
		model.addAttribute("scopeName", request.getParameter("scopeName"));
		model.addAttribute("collectionName", request.getParameter("collectionName"));
		return "/documents/newDocument"; 
	}
	
	@RequestMapping(value="/documents/documentDetails") 
	public String documentDetails(Model model, HttpServletRequest request) { 
		
		model.addAttribute("documentId", request.getParameter("documentId"));
		model.addAttribute("scopeName", request.getParameter("scopeName"));
		model.addAttribute("collectionName", request.getParameter("collectionName"));
		model.addAttribute("documentDetails", couchbaseService.getDocumentDetails(request));
		
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
	
	@RequestMapping(value="/event/eventingPage") 
	public String eventingPage(Model model) { 
		
		Object obj = couchbaseService.getEventFunctionList();
		
		if(obj.getClass().getName().contains("String"))
			model.addAttribute("message",obj);
		else
			model.addAttribute("functionList",obj);
		
		return "/event/eventingPage"; 
	}
	
	@RequestMapping(value="/event/newEventFunction") 
	public String newEventFunction(Model model) { 
		
		model.addAttribute("bucketList", couchbaseService.getBucketList());

		return "/event/newEventFunction"; 
	}
	
	@RequestMapping(value="/analyticsPage") 
	public String analyticsPage() { 
		return "analyticsPage"; 
	}
	
	@RequestMapping("/randomDataPage")
	public String randomDataPage(HttpServletRequest request, Model model) {
		
		Map<String,Object> requestMap = serviceUtil.getRequestToMap(request);
		
		String bucketName = null;
		String scopeName = null;
		String collectionName = null;
		
		try {
			if(!requestMap.keySet().contains("bucketName")) { // request에 파라미터가 존재하지않을 때 ( 처음 documentPage에 진입 )
				
				bucketName = couchbaseService.bucket.name();
				scopeName = "_default";
				collectionName = "_default";
				
			}else {
				bucketName = (String) requestMap.get("bucketName");
				scopeName = (String)requestMap.get("scopeName");
				collectionName = (String)requestMap.get("collectionName");
			}
			
			
			Iterator<CollectionSpec> i = couchbaseService.cluster.bucket(bucketName).collections().getScope(scopeName).collections().iterator();
			List<String> collectionList = new ArrayList<String>();
			
			while(i.hasNext()){
				collectionList.add(i.next().name());
			}
			
			if(!collectionList.contains(collectionName)) {
				
				if(collectionList.contains("_default")) 
					collectionName = "_default";
				else
					collectionName = collectionList.get(0);
			}
						
		}catch(NullPointerException e) { // bucket 과 연결되지 않았을 때
			return "/randomDataPage";
		}
		catch(ScopeNotFoundException e) {
			scopeName = "_default";
			collectionName = "_default";
		}
		catch(IndexOutOfBoundsException e) {
			scopeName = "_default";
			collectionName = "_default";
		}

		model.addAttribute("bucketName",bucketName);
		model.addAttribute("scopeName",scopeName);
		model.addAttribute("collectionName",collectionName);
		
		requestMap.put("bucketName", bucketName);
		requestMap.put("scopeName", scopeName);
		requestMap.put("collectionName", collectionName);
		
		model.addAttribute("bucketList", couchbaseService.getBucketList());
		
		Map<String, Object> resultMap = couchbaseService.getScopeCollection(requestMap);
		model.addAttribute("scopeList", resultMap.get("scopeList"));
		model.addAttribute("collectionList", resultMap.get("collectionList"));
		
		return "/randomDataPage";
	}
	
	@RequestMapping("/fileImportPage")
	public String fileImportPage(HttpServletRequest request, Model model) {
		
		Map<String,Object> requestMap = serviceUtil.getRequestToMap(request);
		
		String bucketName = null;
		String scopeName = null;
		String collectionName = null;
		
		try {
			if(!requestMap.keySet().contains("bucketName")) { // request에 파라미터가 존재하지않을 때 ( 처음 documentPage에 진입 )
				
				bucketName = couchbaseService.bucket.name();
				scopeName = "_default";
				collectionName = "_default";
				
			}else {
				bucketName = (String) requestMap.get("bucketName");
				scopeName = (String)requestMap.get("scopeName");
				collectionName = (String)requestMap.get("collectionName");
			}
			
			
			Iterator<CollectionSpec> i = couchbaseService.cluster.bucket(bucketName).collections().getScope(scopeName).collections().iterator();
			List<String> collectionList = new ArrayList<String>();
			
			while(i.hasNext()){
				collectionList.add(i.next().name());
			}
			
			if(!collectionList.contains(collectionName)) {
				
				if(collectionList.contains("_default")) 
					collectionName = "_default";
				else
					collectionName = collectionList.get(0);
			}
						
		}catch(NullPointerException e) { // bucket 과 연결되지 않았을 때
			return "/fileImportPage";
		}
		catch(ScopeNotFoundException e) {
			scopeName = "_default";
			collectionName = "_default";
		}
		catch(IndexOutOfBoundsException e) {
			scopeName = "_default";
			collectionName = "_default";
		}

		model.addAttribute("bucketName",bucketName);
		model.addAttribute("scopeName",scopeName);
		model.addAttribute("collectionName",collectionName);
		
		requestMap.put("bucketName", bucketName);
		requestMap.put("scopeName", scopeName);
		requestMap.put("collectionName", collectionName);
		
		model.addAttribute("bucketList", couchbaseService.getBucketList());
		
		Map<String, Object> resultMap = couchbaseService.getScopeCollection(requestMap);
		model.addAttribute("scopeList", resultMap.get("scopeList"));
		model.addAttribute("collectionList", resultMap.get("collectionList"));
		
		return "/fileImportPage";
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
