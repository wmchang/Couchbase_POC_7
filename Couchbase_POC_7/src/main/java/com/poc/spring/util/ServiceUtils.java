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
	
	public String byteToMb(Object object) {
		DecimalFormat df = new DecimalFormat("##0.0");
		
		String result;
		
		if(object == null) {
			result = "0.0";
			return result;
		}
		
		result = df.format(((long)object)*10/1024/1024*0.1);
		
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
	        if(values.length <= 1 )
	        	value = values[0];
	        map.put(key, value);  
	    }
	    
	    return map;
	}
	
	// Object(DTO) 끼리 변한 값을 출력함.
	public static <T> Object getDiffrence(T target1, T target2, Class<T> targetClass) {

		List<String> list = new ArrayList<String>();
		try {
			for (PropertyDescriptor pd : Introspector.getBeanInfo(targetClass, Object.class).getPropertyDescriptors()) {
				Object value1 = pd.getReadMethod().invoke(target1);
				Object value2 = pd.getReadMethod().invoke(target2);

				if (value1 != null && value2 != null) {
					if (!value1.equals(value2)) {
						
						list.add(pd.getName());

					}
				}

			}
			return list;
		} catch (IntrospectionException | InvocationTargetException | IllegalAccessException e) {
			throw new RuntimeException(e);
		}
	}
//	
//	public List<String> getJsonDiffrence(JSONObject json1, JSONObject json2) {
//		
//		List<String> list = new ArrayList<String>();
//		
//		List<String> keyList1 = new ArrayList<String>();
//		List<String> keyList2 = new ArrayList<String>();
//		
//		try {
//			Iterator<String> i = json1.keySet().iterator();
//			
//			while(i.hasNext()) {
//				String key = i.next();
//				
//				keyList1.add(key);
//			}
//			Iterator<String> i2 = json2.keySet().iterator();
//			
//			while(i2.hasNext()) {
//				String key = i2.next();
//				
//				keyList2.add(key);
//			}
//			
//			System.out.println(keyList1.toString());
//			System.out.println(keyList2.toString());
//			
//			for(String key : keyList1) {
//				try {
//					String value1 = (String) json1.get(key);
//					String value2 = (String) json2.get(key);
//					
//					
//					
//					if(!value1.equals(value2)) {
//						list.add(key);
//					}
//				}
//				catch(NullPointerException e) {
//					continue;
//				}
//				
//			}
//			
//			return list;
//		}catch(Exception e) {
//			e.printStackTrace();
//		}
//		
//		return null;
//	}
}
