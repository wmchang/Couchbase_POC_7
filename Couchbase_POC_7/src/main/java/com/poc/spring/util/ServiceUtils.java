package com.poc.spring.util;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.nio.charset.StandardCharsets;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.json.simple.JSONArray;
import org.springframework.stereotype.Service;

@Service
public class ServiceUtils {
	
	// curl command 실행하는 메소드. 결과값을 Map의 key "result"로 반환함
	public Map<String,Object> curlExcute(String command) {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		ProcessBuilder processBuilder = new ProcessBuilder(command.split(" "));
		try {
			Process process = processBuilder.start();
			String result = IOUtils.toString(process.getInputStream(),StandardCharsets.UTF_8.name());
			
			if(result.trim().isEmpty() || result == null || result.equals("[]")) {
				resultMap.put("result", "실행이 정상적으로 완료되었습니다.");
				process.destroy();
				return resultMap;
			}
			
			resultMap.put("result", result);
			process.destroy();
			
		}catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "서버쪽 에러입니다.");
			
			return resultMap;
		}
		
		return resultMap;
	}
	
	// CMD를 실행하는 메소드. 결과값을 Map의 key "result"로 반환함
	public String cmdExecute(String command) {
		
        String line = null;

		
	    ProcessBuilder processBuilder = new ProcessBuilder();
	    processBuilder.command("cmd.exe", "/c", command);
	    try {
			Process process = processBuilder.start();
            BufferedReader reader =
                    new BufferedReader(new InputStreamReader(process.getInputStream()));

            while ((line = reader.readLine()) != null) {
            	
            	return line;
            }
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    return line;
	}
	
	public String byteToMBKB(Object object) {
		DecimalFormat df = new DecimalFormat("##0.0");
		
		String result = null;
		
		if(object == null) {
			result = "0.0";
			return result;
		}
		
		long num = (long)object;
		String str = Long.toString(num);
		
		result = df.format(num*10/0.1);
		
		if(str.length() >= 3) // KB
			result = df.format(num*10/1024*0.1)+"KB";
		
		if(str.length() >= 7) // MB
			result = df.format(num*10/1024/1024*0.1)+"MB";
		
		if(str.length() >= 10) // MB
			result = df.format(num*10/1024/1024/1024*0.1)+"GB";
			
		
		return result;
	}
	
	public String byteTo(Object object) {
		DecimalFormat df = new DecimalFormat("##0.0");
		
		String result = null;
		
		if(object == null) {
			result = "0.0";
			return result;
		}
		
		long num = (long)object;
		String str = Long.toString(num);
		
		result = df.format(num*10/0.1);
		
		if(str.length() >= 3) // KB
			result = df.format(num*10/1024*0.1);
		
		if(str.length() >= 7) // MB
			result = df.format(num*10/1024/1024*0.1);
		
		if(str.length() >= 10) // MB
			result = df.format(num*10/1024/1024/1024*0.1);
		
		
		return result;
	}
	
	public String doubleFormat(Object object) {
		DecimalFormat df = new DecimalFormat("##0.0");
		
		String result;
		
		if(object == null) {
			result = "0.0";
			return result;
		}
		
		result =  df.format(object);
		
		return result;
	}
	
	public List<Object> serviceCheck(JSONArray serviceJsonList){
		
		List<Object> serviceList = new ArrayList<Object>();
		
		for (int j = 0; j < serviceJsonList.size(); j++) {
			switch((String) serviceJsonList.get(j)) {
				case "fts":
					serviceList.add("Search"); break;
				case "kv":
					serviceList.add("Data"); break;
				case "n1ql":
					serviceList.add("Query"); break;
				case "cbas":
					serviceList.add("Analytics"); break;
				case "eventing":
					serviceList.add("Eventing"); break;
				case "index":
					serviceList.add("Index"); break;
			}
		}
		
		return serviceList;
	}
	
	public List<Map<String,Object>> logMaker(StringBuilder command, String ...name){
		
		String names[] = name;
		List<Map<String,Object>> logList = new ArrayList<Map<String,Object>>();
		Map<String,Object> logMap = new HashMap<String,Object>();
		
		for(String logName : names) {
			String cmd = command.substring(0, command.lastIndexOf("/"))+"/"+logName;
			System.out.println(cmd);
			Map<String, Object> resultMap = curlExcute(cmd);
			
			Object obj = resultMap.get("result");
			
			logMap.put(logName,obj);
		}
		
		logList.add(logMap);
		return logList;
	}
	
	
	// 전달된 모든 Request를 HashMap 형태로 변환 
	public HashMap<String,Object> getRequestToMap(HttpServletRequest request) {
	    HashMap<String, Object> map = new HashMap<String, Object>();
	    
	    Enumeration<String> enumber = request.getParameterNames();
	    
	    while (enumber.hasMoreElements()) {
	        String key = enumber.nextElement().toString();
	        String[] values = request.getParameterValues(key);
	        String value=null;
	        if(values.length <= 1 ) {
	        	value = values[0];
	        	map.put(key, value);  
	        }
	        else
		        map.put(key, values);  
	        
	    }
	    
	    return map;
	}
}
