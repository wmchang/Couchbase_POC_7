package com.poc.spring.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.poc.spring.service.CouchbaseService;

@Controller
public class PageController {
	
	@Autowired
	CouchbaseService couchbaseService;
	
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
		model.addAttribute("bucketList", couchbaseService.getBucketList());
		return "/bucketManagePage";
	}
	
	@RequestMapping(value="/documents/documentPage") 
	public String documentPage(Model model,HttpServletRequest request) { 
		
		Object list = couchbaseService.getDocumentList(request);
		
		
		if(list == null) {
			return "/documents/documentPage";
		}
		else if(!list.toString().equals("NotExistsIndex") && !list.toString().equals("MemcachedBucketNotSupported")) {
			model.addAttribute("documentList", couchbaseService.getDocumentList(request));
		}
		
		model.addAttribute("bucketList", couchbaseService.getBucketList());
		
		String bucketName;
		if(request.getParameter("bucketName")==null || request.getParameter("bucketName") =="") {
			
			if(couchbaseService.bucket==null)
				return "/documents/documentPage";
			bucketName = couchbaseService.bucket.name();
		}
		else
			bucketName = request.getParameter("bucketName");
		
		model.addAttribute("bucketName",bucketName);
		
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
