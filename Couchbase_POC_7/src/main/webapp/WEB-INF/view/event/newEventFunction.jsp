<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>

<script>
	
	function bucketChange(chk){
		
		if(chk.value=='-Select Bucket-')
			return;
		

		$.ajax({
			
			type:"post",
			url:"<%=request.getContextPath()%>/getScope?bucketName="+chk.value,
			error: function (xhr,status,error){
				alert(error);
			},
			success: function (data){
				
				let nowSelectScope = $('#'+chk.id+'Scope');
				let nowSelectCollection = $('#'+chk.id+'ScopeCollection');
				nowSelectScope.empty();
				nowSelectCollection.empty();
				
		        $.each(data,function(index, item){
		        	nowSelectScope.append('<option value='+item+'>'+item+'</option>');
		        });
		        
		        document.getElementById(chk.id+'Scope').onchange();
		        
			}
		});
	}
	
	function scopeChange(chk){
		
		let bucketNameId = chk.id.replace('Scope','');
		let bucketName = $('#'+bucketNameId).val();
		
		$.ajax({
			type:"post",
			url:"<%=request.getContextPath()%>/getCollection?bucketName="+bucketName+"&scopeName="+chk.value,
			error: function (xhr,status,error){
				alert(error);
			},
			success: function (data){
				
				let nowSelect = $('#'+chk.id+'Collection');
				nowSelect.empty();
				
		        $.each(data,function(index, item){
		        	nowSelect.append('<option value='+item+'>'+item+'</option>');
		        });
			}
		});
	}
	
	function viewSetting(){
		
		
		if($('#settings').css('display') == 'none')
			$('#settings').css('display','inline');
		else
			$('#settings').css('display','none');
	}
	
	
	function createEventFunction(){
		
		let data = $('#eventForm').serialize();
		
		$.ajax({
			
			data:data,
			url:"<%=request.getContextPath()%>/createEventFunction",
			type:"post",
			error : function (xhr, status, error){
				alert(error);
			},
			success : function (data){
				alert(data);
			}
		});
		
	}

</script>
</head>
<body>

	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- no_header.jsp -->
	<c:import url="/WEB-INF/view/common/no_header.jsp">
	</c:import> 
	
	<div class=container>
		<br>
		<form id=eventForm>
			<h5> Source Bucket <span style=font-size:10px;>bucket.Scope.Collection</span></h5> 
			
			<select name=srcBucket onchange="bucketChange(this)" id=srcBucket>
				<option value='-Select Bucket-'>-Select Bucket-</option>
				<c:forEach items="${bucketList }" var="list">
					<option value=${list }>${list }</option>
				</c:forEach>
			</select>
			.
			<select name=srcBucketScope onchange="scopeChange(this)" id=srcBucketScope>
			</select>
			.
			<select name=srcBucketScopeCollection id=srcBucketScopeCollection>
			</select>
			<br><br>
			
			<h5> MetaData Bucket <span style=font-size:10px;>bucket.Scope.Collection</span></h5> 
			
			<select name=metaBucket onchange="bucketChange(this)" id=metaBucket>
				<option value='-Select Bucket-'>-Select Bucket-</option>
				<c:forEach items="${bucketList }" var="list">
					<option value=${list }>${list }</option>
				</c:forEach>
			</select>
			.
			<select name=metaBucketScope onchange="scopeChange(this)" id=metaBucketScope>
			</select>
			.
			<select name=metaBucketScopeCollection id=metaBucketScopeCollection>
			</select>
			<br><br>
			
			<h5> Function 이름</h5>
			<input type=text name=functionName style=width:95%;>
			<br>
			
			<h5> 설명</h5> 
			<textarea name=description cols=65></textarea>
			<br><br>
			
			<a href="#" onclick="viewSetting();"> > Settings</a> 
			
			<br>
			<div id=settings class="collapse" style="display:none; margin-left:25%;">
				<div>
					<h6>System Log Level</h6>
					<select name=logLevel id=logLevel>
						<option value=info selected>Info</option>
						<option value=error>Error</option>
						<option value=warning>Warning</option>
						<option value=debug>Debug</option>
						<option value=trace>Trace</option>
					</select>
					<br><br>
					
					<h6>Default Feed Boundary</h6>
					<select name=feedBoundary id=feedBoundary>
						<option value=Everything selected>Everything</option>
						<option value=fromNow>From Now</option>
					</select>
					<br><br>
					
					<h6>N1QL Consistency</h6>
					<select name=n1qlConsistency id=n1qlConsistency>
						<option value=none selected>None</option>
						<option value=request>Request</option>
					</select>
					<br><br>
					
					<h6>Workers</h6>
					<input type=text name=workers onKeyup="_onlyNumber(this);">
					<br>
					
					<h6>언어 호환성</h6>
					<select name=languageCompatibility id=languageCompatibility>
						<option value=6.0.0>6.0.0</option>
						<option value=6.5.0 selected>6.5.0</option>
					</select>
				
					<h6>Default Feed Boundary</h6>
					<select name=feedBoundary id=feedBoundary>
						<option value=Everything selected>Everything</option>
						<option value=fromNow>From Now</option>
					</select>
				
					<h6>Default Feed Boundary</h6>
					<select name=feedBoundary id=feedBoundary>
						<option value=Everything selected>Everything</option>
						<option value=fromNow>From Now</option>
					</select>
					
				</div>
			</div>
			<br>
			
			<h5> 바인딩 </h5>
			
		</form>
		
		<button class="btn btn-primary" style=float:right; onclick="createEventFunction();">Add Function</button>
	</div>

</body>
</html>