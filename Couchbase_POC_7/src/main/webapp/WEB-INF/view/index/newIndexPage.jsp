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
	h5{
		margin-top:15px;
	}

</style>
<script>
	
	function addTarget(){
		
		if($("input:checkbox[id='primary']").is(":checked")){
			alert('Primary Index는 타겟을 지정할 수 없습니다.');
			return;
		}
		
		$('#targetDiv').append('<div style=margin-bottom:5px> &nbsp; 타겟(컬럼): <input type=text name="targets"></div>');
		
	}
	
	function removeTarget(){
		
		let length = $('#targetDiv').children().length;
		$('#targetDiv').children()[length-1].remove();
		
	}
	
	function addIndex(){
		
 		if(!inputCheck($('#indexForm'))){
			alert('모든 항목을 입력해주세요.');
			return;
		} 
 		
 		let data = $('#indexForm').serialize();

 		if($('#targetDiv').children().length == 0 && !data.includes('primary')){
 			
 			alert('Primary Index가 아니라면 인덱스 타겟이 존재해야합니다.');
 			return;
 		}
 		
 		if($('#bucket').val() == '-Select Bucket-'){
 			alert('대상 Bucket을 선택해야합니다.');
 			return;
 		}
 		
 		waitToast();
 		
		$.ajax({
			
			data:data,
			url:"<%=request.getContextPath()%>/createNewIndex",
			type:"post",
			error : function (xhr, status, error){
				alert(error);
			},
			success : function (data){
				
				waitToast('exit');
				if(data.length == 0){
					alert('생성이 완료되었습니다.');
					window.close();
					opener.location.reload();
				}
				else
					alert(data);
			}
		}); 
	}
	
	function selectPrimary(chk){
		
		if($(chk).is(":checked")){
			$('#indexName').val('#primary');
			
			$('#targetDiv').empty();
			
		}
		else
			$('#indexName').val('');
		
		
	}


</script>
</head>
<body>

<div class=container>
	<br>
	<form id=indexForm>
		<div id=taskDiv>
		
			<h4> &nbsp; Index 생성 </h4>
			<br>
			
			<h5> Index 이름 </h5>
			<input type=text name=indexName style=width:180px; id=indexName>
			<br>
			
			<h5> Bucket <span style=font-size:11px;>bucket.Scope.Collection</span></h5> 
			
			<select name=bucket onchange="bucketChange(this)" id=bucket>
				<option value='-Select Bucket-'>-Select Bucket-</option>
				<c:forEach items="${bucketList }" var="list">
					<option value=${list }>${list }</option>
				</c:forEach>
			</select>
			.
			<select name=bucketScope onchange="scopeChange(this)" id=bucketScope>
			</select>
			.
			<select name=bucketScopeCollection id=bucketScopeCollection>
			</select>
			<br><br>
			
			<input type=checkbox name=primary id=primary value=true onchange="selectPrimary(this)"> &nbsp; Primary Index
			
			
			<h5 style="margin-bottom:-20px;"> 타겟 </h5>
			<button type=button class="btn btn-light" style="float:right; margin-left:10px;" onclick="removeTarget();">-</button>
			<button type=button class="btn btn-light" style=float:right onclick="addTarget();">+</button>
			<br>
			<hr>
			
			<div id=targetDiv>

			</div>
			
			<button type=button class="btn btn-primary" style=float:right; onclick="addIndex();">Add Index</button>
			
		</div>
	</form>
</div>

<div id=toast></div>

</body>
</html>