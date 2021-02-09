package com.poc.spring.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.poc.spring.service.CouchbaseService;

@Controller
public class ServiceController {
	
	@Autowired
	CouchbaseService couchbaseService;
	
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
		return couchbaseService.dropDocument(request.getParameter("bucketName"), request.getParameter("documentId")); 
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
	public Map<String, Object> fileUpload(MultipartHttpServletRequest mRequest) throws Exception { 
		return couchbaseService.uploadFile(mRequest); 
	}
	

}	