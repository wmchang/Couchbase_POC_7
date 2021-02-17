<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
		<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Couchbase</title>
</head>
<script>
	// document.getElementById("logData").value
	function logChange(name){
		let logName = name.value;
		
		console.log(logName);
		
		if(logName == 'views'){
			$('#viewLog').attr('style', "display:none;");
			$('#queryLog').attr('style', "display:inline;");
		}
		else if(logName == 'query'){
			$('#viewLog').attr('style', "display:inline;");
			$('#queryLog').attr('style', "display:none;");
		}
	}
	
</script>


<body>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	
	<div class=container>
		<div class=row>
			<div class="mx-auto col-lg-7" ><br>
				<h4> &nbsp; 로그 종류 </h4> <br>
					<div>
						<input type="radio" name="sdkJobType" value="views" onclick="logChange(this)" checked/>
						<label>views</label>
						
						<input type="radio" name="sdkJobType" value="query" onclick="logChange(this)" />
						<label>Query</label>
					</div><br>

<%-- 너무 느리고 쓸모없는 정보라 주석처리
 
					<textarea cols="100" rows="30" readonly id=viewLog>
						${logList[0].views }
					</textarea>
					<textarea cols="100" rows="30" readonly id=queryLog style=display:none;>
						${logList[0].query }
					</textarea>

 --%>

			</div>
		</div>
	</div>
			
</body>
</html>