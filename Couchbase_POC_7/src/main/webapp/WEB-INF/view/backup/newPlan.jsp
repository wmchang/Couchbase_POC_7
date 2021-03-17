<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
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
		margin-right:10px;
	}

	#taskDiv div div input[type=text]{
		 height:40px;
	}
	
	#taskDiv span{
		display:block;
		width:100%;
	}
	
	.btn-primary{
		width:60px;
		margin:5px 10px 30px 10px;
	}
</style>
<meta charset="EUC-KR">
<title>Insert title here</title>
<script>

	function serviceSetting(){
		
		if($('#services').css('display') == 'none')
			$('#services').css('display','inline');
		else
			$('#services').css('display','none');
	}
	
	
	function buttonChange(chk){
		
		$('input[id='+chk.id+']').parent().css('background-color','#007bff');
		
		$(chk).parent().css('background-color','purple');
		
	}
			
	function addTasks(){
		
		let length = $('#taskDiv').children().length;
		
		$('#taskDiv').append('<div id=taskDiv'+length+'>');
		$('#taskDiv'+length).append('<div><label>작업 이름</label><input type=text name=taskName'+length+'>');
		$('#taskDiv'+length).append('<div><label>날짜</label><select name=period'+length+' id=period'+length+' onchange=periodChange(this) >');
		$('#taskDiv'+length).append('<div><label>시작 시간</label><input type=text name=startTime'+length+' value=22:00>');
		
		if(length == 0){
			$('#taskDiv'+length).css('margin-top','0px');	
		}
		
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
		
		$('#taskDiv'+length).append('<div id=group'+length+' class="btn-group btn-group-toggle" data-toggle="buttons">');
		
		$('#group'+length).append('<h6 style=margin-bottom:-12px;>전체 백업하는 날</h6><br>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="monday'+length+'" value="true" id="monday'+length+'" onchange=buttonChange(this)> 월</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="tuesday'+length+'" value="true" id="tuesday'+length+'" onchange=buttonChange(this)> 화</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="wednesday'+length+'" value="true" id="wednesday'+length+'" onchange=buttonChange(this)> 수</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="thursday'+length+'" value="true" id="thursday'+length+'" onchange=buttonChange(this)> 목</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="friday'+length+'" value="true" id="friday'+length+'" onchange=buttonChange(this)> 금</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="saturday'+length+'" value="true"  id="saturday'+length+'" onchange=buttonChange(this)> 토</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="sunday'+length+'" value="true"  id="sunday'+length+'" onchange=buttonChange(this)> 일</label><br><br>');
		
		$('#group'+length).append('<h6 style=margin-bottom:-12px;>일반 백업하는 날</h6><br>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="monday'+length+'" value="null"  id="monday'+length+'" onchange=buttonChange(this)> 월</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="tuesday'+length+'" value="null"  id="tuesday'+length+'" onchange=buttonChange(this)> 화</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="wednesday'+length+'" value="null"  id="wednesday'+length+'" onchange=buttonChange(this)> 수</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="thursday'+length+'" value="null"  id="thursday'+length+'" onchange=buttonChange(this)> 목</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="friday'+length+'" value="null"  id="friday'+length+'" onchange=buttonChange(this)> 금</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="saturday'+length+'" value="null"  id="saturday'+length+'" onchange=buttonChange(this)> 토</label>');
		$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="sunday'+length+'" value="null"  id="sunday'+length+'" onchange=buttonChange(this)> 일</label><br>');
		
		$('#taskDiv'+length).append('<hr>');
	}
	
	function removeTasks(){
		
		let length = $('#taskDiv').children().length;
		
		if(length <= 0)
			return;
		
		$('#taskDiv'+(length-1)).remove();
	}
	
	let yetVar = '';
	
	function periodChange(chk){
		
		let length = chk.id.substring(6);
		
		if(chk.value == 'WEEKS'){
			
			$('#group'+length).html('');
			$("#fullBack"+length).detach();
			
			$('#taskDiv'+length+' hr').remove();
			
			$('#group'+length).append('<h6 style=margin-bottom:-12px;>전체 백업하는 날</h6><br>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="monday'+length+'" value="true" id="monday'+length+'" onchange=buttonChange(this)> 월</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="tuesday'+length+'" value="true" id="tuesday'+length+'" onchange=buttonChange(this)> 화</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="wednesday'+length+'" value="true" id="wednesday'+length+'" onchange=buttonChange(this)> 수</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="thursday'+length+'" value="true" id="thursday'+length+'" onchange=buttonChange(this)> 목</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="friday'+length+'" value="true" id="friday'+length+'" onchange=buttonChange(this)> 금</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="saturday'+length+'" value="true"  id="saturday'+length+'" onchange=buttonChange(this)> 토</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="sunday'+length+'" value="true"  id="sunday'+length+'" onchange=buttonChange(this)> 일</label><br><br>');
			
			$('#group'+length).append('<h6 style=margin-bottom:-12px;>일반 백업하는 날</h6><br>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="monday'+length+'" value="null"  id="monday'+length+'" onchange=buttonChange(this)> 월</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="tuesday'+length+'" value="null"  id="tuesday'+length+'" onchange=buttonChange(this)> 화</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="wednesday'+length+'" value="null"  id="wednesday'+length+'" onchange=buttonChange(this)> 수</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="thursday'+length+'" value="null"  id="thursday'+length+'" onchange=buttonChange(this)> 목</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="friday'+length+'" value="null"  id="friday'+length+'" onchange=buttonChange(this)> 금</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="saturday'+length+'" value="null"  id="saturday'+length+'" onchange=buttonChange(this)> 토</label>');
			$('#group'+length).append('<label class="btn btn-primary"><input type="radio" name="sunday'+length+'" value="null"  id="sunday'+length+'" onchange=buttonChange(this)> 일</label><br>');
			
			$('#taskDiv'+length).append('<hr>');
		}
		else{
			if(yetVar !='WEEKS'){
				
				if($('#task_type'+length).children().length>1)
					return;
				
				$('#taskDiv'+length+' hr').remove();

				$('#group'+length).html('');
				
				$('#group'+length).append('<label>타입</label><select name=task_type'+length+' id=task_type'+length+' onchange=typeChange(this)>');
				
				$('#task_type'+length).append('<option value=BACKUP>백업</option>');
				$('#task_type'+length).append('<option value=MERGE>병합</option>');

				$('#group'+length).append('<label>반복 주기<span style=font-size:10px;>(1-200)</span></label><input type=text name=frequency'+length+' onkeyup="_onlyNumber(this)"> ');
				
				$('#group'+length).append('<div id=fullBack'+length+'>')

				$('#fullBack'+length).append('<label style=margin-left:10px; id=fullBack'+length+' ><input type=checkbox name=fullBackup'+length+' value=true>&nbsp; 전체백업</label>');
				
				$('#taskDiv'+length).append('<hr>');

			}
		}
	}
	
	function typeChange(chk){
		
		let length = chk.id.substring(9);
		
		if(chk.value == 'MERGE'){
			$("#fullBack"+length).detach();
			
			$('#taskDiv'+length+' hr').remove();
			
			$('#group'+length).append('<div id=fullBack'+length+'>')

			$('#fullBack'+length).append('<label>병합 오프셋 시작</label><input type=text name=offsetStart'+length+' onkeyup="_onlyNumber(this)">');
			$('#fullBack'+length).append('<label>병합 오프셋 끝</label><input type=text name=offsetEnd'+length+' onkeyup="_onlyNumber(this)">');

			$('#taskDiv'+length).append('<hr>');

		}
		else{
			$("#fullBack"+length).detach();
			
			$('#taskDiv'+length+' hr').remove();
			
			$('#group'+length).append('<div id=fullBack'+length+'>')
			
			$('#fullBack'+length).append('<label style=margin-left:10px; id=fullBack'+length+' ><input type=checkbox name=fullBackup'+length+' value=data>&nbsp; 전체백업</label> ');
			
			$('#taskDiv'+length).append('<hr>');

		}
	}
	
	
	function addPlan(){
		
		if(!inputCheck($('#planForm'))){
			alert('모든 항목을 채워주십시오.');
			return;
		}
		
		if($('#taskDiv').children().length <= 0){
			alert('작업을 1개 이상 설정해주십시오.')
			return;
		}
		
		let data = $('#planForm').serialize();
		
		data += '&taskLength='+$('#taskDiv').children().length;
		
		console.log(data);
		
		$.ajax({
			
			data:data,
			type:"post",
			url:"<%=request.getContextPath()%>/addNewPlan",
			error:function(xhr,status,error){
				
				
				alert(error);
			},
			success:function(data){
				alert(data);
				
				if(data.includes('완료')){
					opener.location.reload();
					window.close();
				}
			}
			
		});
	}

</script>
</head>
<body>

<div class=container>
	<br>
	<form id=planForm>
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
			<input type=checkbox name=service value=gsi checked>&nbsp; Index <br>
			<input type=checkbox name=service value=views checked>&nbsp; Views <br>
			<input type=checkbox name=service value=ft checked>&nbsp; Search <br>
			<input type=checkbox name=service value=eventing checked>&nbsp; Eventing <br>
			<input type=checkbox name=service value=cbas checked>&nbsp; Analytics <br>
		</div>
		<br>
		
		
		<h5  style="margin-bottom:-20px;"> 작업 </h5>
		<button type=button class="btn btn-light" style="float:right; margin-left:10px;" onclick="removeTasks();">-</button>
		<button type=button class="btn btn-light" style=float:right onclick="addTasks();">+</button>
		<br>
		<br>
		
		<div id=taskDiv>
		
		</div>
		
		<button type=button class="btn btn-primary" style=float:right onclick="addPlan();">추가</button>
		
		
		<br>
	</form>
</div>

</body>
</html>