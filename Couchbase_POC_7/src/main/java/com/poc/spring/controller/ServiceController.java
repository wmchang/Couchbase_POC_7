package com.poc.spring.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.poc.spring.dto.CompactionDTO;
import com.poc.spring.dto.SettingDTO;
import com.poc.spring.dto.querySettingsDTO;
import com.poc.spring.service.CouchbaseService;
import com.poc.spring.util.ServiceUtils;

@Controller
public class ServiceController {
	
	@Autowired
	CouchbaseService couchbaseService;
	@Autowired
	ServiceUtils serviceUtil;	
	
	// Connect
	@RequestMapping(value="/conData", method=RequestMethod.POST) 
	@ResponseBody
	public String conData(HttpServletRequest request) throws Exception { 
		return couchbaseService.connectionData(request); 
	}
	
	// Node
	@RequestMapping(value="/dropNode", method=RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> dropNode(HttpServletRequest request) throws Exception { 
		return couchbaseService.dropNode(request); 
	}

	@RequestMapping(value="/addNode", method=RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> addNode(HttpServletRequest request) throws Exception { 
		return couchbaseService.addNode(request); 
	}
	
	@RequestMapping(value="/rebalancing", method=RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> rebalancing(HttpServletRequest request) throws Exception { 
		return couchbaseService.rebalancing(request); 
	}
	
	//Bucket
	@RequestMapping(value="/dropBucket", method=RequestMethod.POST) 
	@ResponseBody
	public String dropBucket(HttpServletRequest request) throws Exception { 
		return couchbaseService.dropBucket(request);
	}
	
	@RequestMapping(value="/createBucket", method=RequestMethod.POST) 
	@ResponseBody
	public String createBucket(HttpServletRequest request) throws Exception { 
		return couchbaseService.createBucket(request); 
	}
	
	@RequestMapping(value="/getScope", method=RequestMethod.POST) 
	@ResponseBody
	public Object getScope(HttpServletRequest request) throws Exception { 
		return couchbaseService.getScope(request);
	}
	
	@RequestMapping(value="/getCollection", method=RequestMethod.POST) 
	@ResponseBody
	public Object getCollection(HttpServletRequest request) throws Exception { 
		return couchbaseService.getCollection(request);
	}
	
	@RequestMapping(value="/getScopeCollection", method=RequestMethod.POST) 
	@ResponseBody
	public Object getScopeCollection(Map<String,Object> requestMap) throws Exception { 
		return couchbaseService.getScopeCollection(requestMap); 
	}
	
	@RequestMapping(value="/createScope", method=RequestMethod.POST) 
	@ResponseBody
	public Object createScope(HttpServletRequest request) throws Exception { 
		return couchbaseService.createScope(request); 
	}
	
	@RequestMapping(value="/createCollection", method=RequestMethod.POST) 
	@ResponseBody
	public Object createCollection(HttpServletRequest request) throws Exception { 
		return couchbaseService.createCollection(request); 
	}
	
	@RequestMapping(value="/dropScope", method=RequestMethod.POST) 
	@ResponseBody
	public Object dropScope(HttpServletRequest request) throws Exception { 
		return couchbaseService.dropScope(request); 
	}
	
	@RequestMapping(value="/dropCollection", method=RequestMethod.POST) 
	@ResponseBody
	public Object dropCollection(HttpServletRequest request) throws Exception { 
		return couchbaseService.dropCollection(request); 
	}
	
	// Create Primary Index
	@RequestMapping(value="/createPrimaryIndex", method=RequestMethod.POST) 
	@ResponseBody
	public String createPrimaryIndex(HttpServletRequest request) throws Exception { 
		return couchbaseService.createPrimaryIndex(request);
	}
	
	// Document
	@RequestMapping(value="/addDocument", method=RequestMethod.POST) 
	@ResponseBody
	public Object addDocument(HttpServletRequest request) throws Exception { 
		return couchbaseService.addDocument(request); 
	}
	
	@RequestMapping(value="/documentUpsert", method=RequestMethod.POST) 
	@ResponseBody
	public Object documentUpsert(HttpServletRequest request) throws Exception { 
		return couchbaseService.documentUpsert(request); 
	}
	
	@RequestMapping(value="/dropDocument", method=RequestMethod.POST) 
	@ResponseBody
	public Object dropDocument(HttpServletRequest request) throws Exception { 
		return couchbaseService.dropDocument(request); 
	}
	
	// Query
	@RequestMapping(value="/getQueryResult", method=RequestMethod.POST) 
	@ResponseBody
	public Object getQueryResult(HttpServletRequest request) throws Exception { 
		return couchbaseService.getQueryResult(request); 
	}
	
	// Making Random Data 
	@RequestMapping(value="/randomData", method=RequestMethod.POST) 
	@ResponseBody
	public Object randomData(HttpServletRequest request) throws Exception { 
		return couchbaseService.makeRandomData(request); 
	}
	
	// csv, json file upload
	@RequestMapping(value="/fileUpload", method=RequestMethod.POST) 
	@ResponseBody
	public Object fileUpload(MultipartHttpServletRequest mRequest) throws Exception { 
		return couchbaseService.uploadFile(mRequest); 
	}
	
	// settings
	@RequestMapping(value="/setSettings", method=RequestMethod.POST) 
	@ResponseBody
	public Object setSettings(SettingDTO settings) throws Exception {
		
		return couchbaseService.setSettings(settings);
	}
	
	@RequestMapping(value="/setCompactions", method=RequestMethod.POST) 
	@ResponseBody
	public Object setCompactions(CompactionDTO compactions) throws Exception {
		
		return couchbaseService.setCompactions(compactions);
	}
	
	@RequestMapping(value="/downSampleBucket", method=RequestMethod.POST) 
	@ResponseBody
	public Object downSampleBucket(HttpServletRequest request) throws Exception {
		
		return couchbaseService.downSampleBucket(request.getParameterValues("sampleBucket"));
	}
	
	@RequestMapping(value="/setquerySettings", method=RequestMethod.POST) 
	@ResponseBody
	public Object setquerySettings(querySettingsDTO querySettings) throws Exception {
		
		return couchbaseService.setQuerySettings(querySettings);
	}
	
	@RequestMapping(value="/analyticsQuery", method=RequestMethod.POST) 
	@ResponseBody
	public Object analyticsQuery(HttpServletRequest request) throws Exception {
		
		return couchbaseService.analyticsQuery(request);
	}
	
	@RequestMapping(value="/createEventFunction", method=RequestMethod.POST) 
	@ResponseBody
	public Object createEventFunction(HttpServletRequest request) throws Exception {
		
		return couchbaseService.createEventFunction(request);
	}
	
	@RequestMapping(value="/deployEventFunction", method=RequestMethod.POST) 
	@ResponseBody
	public Object deployEventFunction(HttpServletRequest request) throws Exception {
		
		return couchbaseService.deployEventFunction(request);
	}
	
	@RequestMapping(value="/undeployEventFunction", method=RequestMethod.POST) 
	@ResponseBody
	public Object undeployEventFunction(HttpServletRequest request) throws Exception {
		
		return couchbaseService.undeployEventFunction(request);
	}
	
	@RequestMapping(value="/updateEventFunction", method=RequestMethod.POST) 
	@ResponseBody
	public Object updateEventFunction(HttpServletRequest request) throws Exception {
		
		return couchbaseService.updateEventFunction(request);
	}
	
	@RequestMapping(value="/deletePlan", method=RequestMethod.POST) 
	@ResponseBody
	public Object deletePlan(HttpServletRequest request) throws Exception {
		
		return couchbaseService.deletePlan(request);
	}
	
	@RequestMapping(value="/addNewPlan", method=RequestMethod.POST) 
	@ResponseBody
	public Object addNewPlan(HttpServletRequest request) throws Exception {
		
		return couchbaseService.addNewPlan(request);
	}

	@RequestMapping(value="/addNewRepository", method=RequestMethod.POST) 
	@ResponseBody
	public Object addNewRepository(HttpServletRequest request) {
		
		
		return couchbaseService.addNewRepository(request);
	}
	
	@RequestMapping(value="/deleteRepository", method=RequestMethod.POST) 
	@ResponseBody
	public Object deleteRepository(HttpServletRequest request) {
		
		return couchbaseService.deleteRepository(request);
	}
	
	@RequestMapping(value="/archiveRepository", method=RequestMethod.POST) 
	@ResponseBody
	public Object archiveRepository(HttpServletRequest request) {
		
		return couchbaseService.archiveRepository(request);
	}
	
	@RequestMapping(value="/restoreExcute", method=RequestMethod.POST) 
	@ResponseBody
	public Object restoreExcute(HttpServletRequest request) {
		
		return couchbaseService.restoreExcute(request);
	}
}	
