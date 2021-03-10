<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
    	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- no_header.jsp -->
	<c:import url="/WEB-INF/view/common/no_header.jsp">
	</c:import> 
	
	
<!DOCTYPE html>
<html>
<head>

<style>

	input[type=text],label{
		display:block;
	}

	#taskDiv div div{
		display:inline-block;
		width:150px;
		height:70px;
		margin:10px;
	}

	#taskDiv div div input{
		 height:40px;
	}
</style>
<meta charset="EUC-KR">
<title>Insert title here</title>
<script>

	function serviceSetting(){
		
		console.log($('#services').css('display') == 'none');
		
		if($('#services').css('display') == 'none')
			$('#services').css('display','inline');
		else
			$('#services').css('display','none');
	}
	
	
	function addTasks(){
		
		let length = $('#taskDiv').children().length;
		
		$('#taskDiv').append('<div id=taskDiv'+length+'>');
		$('#taskDiv'+length).append('<div><label>작업 이름</label><input type=text name=taskName'+length+'>');
		$('#taskDiv'+length).append('<div><label>날짜</label><select name=period'+length+' id=period'+length+' onchange=periodChange(this) >');
		$('#taskDiv'+length).append('<div><label>시작 시간</label><input type=text name=startTime'+length+' value=22:00>');
		
		$('#period'+length).append('<option value=WEEKS>매주</option>');
		$('#period'+length).append('<option value=MINUTES>분</option>');
		$('#period'+length).append('<option value=HOURS>시간</option>');
		$('#period'+length).append('<option value=DAYS>일</option>');
		$('#period'+length).append('<option value=MONDAY>월요일</option>');
		$('#period'+length).append('<option value=TUESDAY>화요일</option>');
		$('#period'+length).append('<option value=WEDNESDAY>수요일</option>');
		$('#period'+length).append('<option value=THURSDAY>목요일</option>');
		$('#period'+length).append('<option value=FRIDAY>금요일</option>');
		$('#period'+length).append('<option value=SATURDAY>토요일</option>');
		$('#period'+length).append('<option value=SUNDAY>일요일</option>');
		
		$('#taskDiv'+length).append('<div id=group'+length+'><label>타입</label><select name=task_type'+length+' id=task_type'+length+' onchange=typeChange(this)>');
		
		$('#task_type'+length).append('<option value=BACKUP>백업</option>');
		$('#task_type'+length).append('<option value=MERGE>병합</option>');
		
		$('#group'+length).append('<label>반복 주기<span style=font-size:10px;>(1-200)</span></label><input type=text name=frequency'+length+' onkeyup="_onlyNumber(this)"> ');
		$('#group'+length).append('<br><br><label style=margin-left:10px;><input type=checkbox name=service value=data>&nbsp; 전체백업</label> ');
		$('#group'+length).append('<hr> ');
	}
	
	function removeTasks(){
		
		let length = $('#taskDiv').children().length;
		
		if(length <= 0)
			return;
		
		$('#taskDiv'+(length-1)).remove();
	}
	
	function periodChange(chk){
		
		let num = chk.id.substring(6);
		
		$('#group'+num).html('');
		
		$('#group'+num).append('<div class="btn-group btn-group-toggle" data-toggle="buttons">');
		
		
		
	}

</script>
</head>
<body>

<div class=container>
	<br>
	<form>
		<h5>이름</h5>
		<input type=text name=planName style=width:95%;>
		<br>
		
		<h5>설명</h5>
		<textarea name=description cols=58></textarea>
		<br><br>
		<a href="#" onclick="serviceSetting();"> > 서비스 </a> 
		<br>
		
		<div id=services class="collapse" style="display:none;">
			<input type=checkbox name=service value=data checked>&nbsp; Data <br>
			<input type=checkbox name=service value=index checked>&nbsp; Index <br>
			<input type=checkbox name=service value=views checked>&nbsp; Views <br>
			<input type=checkbox name=service value=search checked>&nbsp; Search <br>
			<input type=checkbox name=service value=eventing checked>&nbsp; Eventing <br>
			<input type=checkbox name=service value=analytics checked>&nbsp; Analytics <br>
		</div>
		<br>
		
		
		<h5  style="margin-bottom:-20px;"> 작업 </h5>
		<button type=button class="btn btn-light" style="float:right; margin-left:10px;" onclick="removeTasks();">-</button>
		<button type=button class="btn btn-light" style=float:right onclick="addTasks();">+</button>
		<br>
		<hr>
		
		<div id=taskDiv>
			
		</div>
		<br>
	</form>
</div>

</body>
</html>