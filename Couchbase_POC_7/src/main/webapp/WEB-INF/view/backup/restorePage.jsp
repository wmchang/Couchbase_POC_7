<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- no_header.jsp -->
	<c:import url="/WEB-INF/view/common/no_header.jsp">
	</c:import> 
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<style>
	input[type=text],input[type=password], select{
		width:60%;
	}
	h5 {
		margin-top:15px;
	}
	img{
	
		width:15px;
		height:15px;
	}
</style>
<script>
	function serviceSetting(){
		
		if($('#services').css('display') == 'none')
			$('#services').css('display','inline');
		else
			$('#services').css('display','none');
	}
	function advancedSetting(){
		
		if($('#advanced').css('display') == 'none')
			$('#advanced').css('display','inline');
		else
			$('#advanced').css('display','none');
	}
	
	function restoreExcute(){
		
		let data = $('#restoreForm').serialize();
		
		$.ajax({
			
			data: data,
			type: "post",
			url:"<%=request.getContextPath()%>/restoreExcute",
			error: function(xhr, status, error){
				
				alert(error);
			},
			success: function(data) {
				
				alert(data);
				/* alert(data);
				
				if(data.includes('정상')){
					window.close();
					opener.location.reload();
				} */
			}
		});
	}
	
</script>
</head>
<body>

<div class=container>
	<form id=restoreForm>
	
		<input type=hidden name=state value="${state }">
		<input type=hidden name=repositoryName value="${repositoryName }">
		
		<div id=taskDiv>
		<br>
			<h4> &nbsp; 복구 </h4>
			
			<h5> Cluster</h5>
			<input type=text name=target placeholder="http:localhost">
			
			<h5> Username </h5>
			<input type=text name=username value="${username }">
			
			<h5> Password </h5>
			<input type=password name=password value="${password }">
			
			<h5> Start</h5>
			<select name=startPoint>
				<c:forEach items="${pointList }" var="list">
					<option value="${list }"> ${list } </option>
				</c:forEach>
			</select>
			
			<h5> End</h5>
			<select name=endPoint>
				<c:forEach items="${pointList }" var="list">
					<option value="${list }"> ${list } </option>
				</c:forEach>
			</select>
			<br><br>
			
			<a href="#" onclick="serviceSetting();"> > 서비스 </a> 
			<br>
				
			<div id=services class="collapse" style="display:none;">
				<input type=checkbox name=disable_data value=false checked>&nbsp; Data <br>
				<input type=checkbox name=disable_gsi_indexes value=false checked>&nbsp; Index <br>
				<input type=checkbox name=disable_views value=false checked>&nbsp; Views <br>
				<input type=checkbox name=disable_ft value=false checked>&nbsp; Search <br>
				<input type=checkbox name=disable_eventing value=false checked>&nbsp; Eventing <br>
				<input type=checkbox name=disable_analytics value=false checked>&nbsp; Analytics <br>
			</div>
			<br>
			
			<a href="#" onclick="advancedSetting();"> > 추가 옵션 </a> 
			<br>
			
			<div id=advanced class="collapse" style="display:none;">
						
				<h5> Filter Keys </h5>
				<input type=text name=filterKeys  placeholder="RE2 정규표현식">
				<img src="<%= request.getContextPath()%>/static/image/descriptionIcon.png" 
				 title="정규식과 일치하는 Key를 가진 문서만 복구됩니다."  >
						
				<h5> Filter Values </h5>
				<input type=text name=filterValues  placeholder="RE2 정규표현식">
				<img src="<%= request.getContextPath()%>/static/image/descriptionIcon.png" 
				 title="정규식과 일치하는 Value를 가진 문서만 복구됩니다."  >
						
				<h5> Map Data </h5>
				<input type=text name=map_data  placeholder="새로운 버킷 매핑(bucket1=new1)">
				<img src="<%= request.getContextPath()%>/static/image/descriptionIcon.png"
				 title="원래의 버킷으로 복원할지, 다른 버킷으로 복원할지 지정합니다. 비어있다면 원래 버킷에 복원됩니다."  >
						
				<h5> Include Data </h5>
				<input type=text name=include_data  placeholder="include values(bucket1, bucket2)">
				<img src="<%= request.getContextPath()%>/static/image/descriptionIcon.png"
				 title="데이터를 복원할 버킷의 하위 집합을 나타냅니다. (bucket-name.scope-name.collection-name)의 형식으로 특정 collection만 복원할 수 있습니다."  >
						
				<h5> Exclude Data </h5>
				<input type=text name=exclude_data  placeholder="exclude values(bucket1, bucket2)">
				<img src="<%= request.getContextPath()%>/static/image/descriptionIcon.png"
				 title="데이터를 복원할 버킷의 하위 집합을 나타냅니다.(bucket-name.scope-name.collection-name)의 형식으로 특정 collection만 제외하고 복원할 수 있습니다."  >
				 
				 <br><br>
				 <input type=checkbox name=forceUpdates value=true >&nbsp; Force Updates <img src="<%= request.getContextPath()%>/static/image/descriptionIcon.png"
				 title="현재 값이 최신일때, 복원될 데이터로 덮어쓰도록하려면 체크합니다."  ><br>
				 
				 <input type=checkbox name=auto_remove_collections value=true >&nbsp; Auto-remove Collections <br>
				 
				 <input type=checkbox name=auto_create_buckets value=true >&nbsp; Auto-create Buckets <br>
				 
			</div>
			
			<hr>
			<button type=button class="btn btn-primary" style=float:right onclick="restoreExcute();">추가</button>
			
			
		</div>
	
	</form>
</div>



</body>
</html>