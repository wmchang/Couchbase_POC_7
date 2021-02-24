<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>

	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- no_header.jsp -->
	<c:import url="/WEB-INF/view/common/no_header.jsp">
	</c:import> 

<script>
	
	let bindingBucketArray = new Array();
	let bindingUrlArray = new Array();
	let existingForm;
	const existingFunctionName = '${functions.appname }';


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
				
				let scope = '';
				let num = chk.id.substring(6);

				if(chk.id == 'srcBucket')
					scope = '${functions.depcfg.source_scope}';
				else if(chk.id == 'metaBucket')
					scope =	'${functions.depcfg.metadata_scope}';
				else if(bindingBucketArray[num] != null){
					scope = bindingBucketArray[num].get('scope_name');
				}
					
					
		        $.each(data,function(index, item){
		        	
		        	if(scope == item){
			        	nowSelectScope.append('<option value='+item+' selected >'+item+'</option>');
		        	}
		        	else
		        		nowSelectScope.append('<option value='+item+' >'+item+'</option>');
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
				
				let collection = '';
				let num = chk.id.substring(6,7);

				if(chk.id == 'srcBucketScope')
					collection = '${functions.depcfg.source_collection}';
				else if(chk.id == 'metaBucketScope')
					collection = '${functions.depcfg.metadata_collection}';
				else if(bindingBucketArray[num] != null){
					collection = bindingBucketArray[num].get('collection_name');
				}
					
		        $.each(data,function(index, item){
		        	if(item == collection)
		        		nowSelect.append('<option value='+item+' selected >'+item+'</option>');
		        	else{
		        		nowSelect.append('<option value='+item+'>'+item+'</option>');
		        	}
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
	
	function addBinding(chk){
		
		let length = $('#bindingDiv').children().length;
		
		$('#bindingDiv').append('<div style=margin-bottom:20px; id=bindingTypeDiv'+length+'><select name=bindingType'+length+' id=bindingType'+length+' onchange=bindChange(this) >');
		$('#bindingDiv').append('</select></div>');
		$('#bindingType'+length).append('<option value="bindingType">bindingType </option>');
		
		if(chk == 'bucket'){
			$('#bindingType'+length).append('<option value="bucket alias" selected>bucket alias </option>');
			$('#bindingType'+length).append('<option value="URL alias">URL alias </option>');
		}
		else if(chk == 'url'){
			$('#bindingType'+length).append('<option value="bucket alias">bucket alias </option>');
			$('#bindingType'+length).append('<option value="URL alias" selected>URL alias </option>');
		}else{
			$('#bindingType'+length).append('<option value="bucket alias">bucket alias </option>');
			$('#bindingType'+length).append('<option value="URL alias">URL alias </option>');
		}
	}
	
	function removeBinding(){
		
		let length = $('#bindingDiv').children().length;
		
		if(length <= 0)
			return;
		
		$('#bindingTypeDiv'+(length-1)).remove();
	}
	
	function bindChange(chk){
		
		let num = chk.id.substring(11);
		
		let bindDiv = $('#bindingTypeDiv'+num);
		let bindType = chk.value;
		
		if(chk.value== 'binding type'){
			return;
		}

		// 처음 select 박스가 변경되었을 때 
		if(bindDiv.children().length <= 1){
			
			$("#bindingType"+num+" option[value='bindingType']").prop('disabled',true);
			bindDiv.append('&nbsp; <input type=text name=alias'+num+' id=alias'+num+' placeholder="alias name" >');			
		}
		
		if(chk.value=='bucket alias'){
			
			if($('#url'+num).length){
				$('#url'+num).remove();
				$('#bindDiv'+num).remove();
			}
			
			if(($('#bucket'+num).length)){
				return;
			}
			
			bindDiv.append('<div id=bindDiv'+num+'></div>');
			let bindDiv2 = $('#bindDiv'+num); 
			
			bindDiv2.append('<h5> Bucket <span style=font-size:10px;>bucket.Scope.Collection</span></h5>')
			bindDiv2.append('<select name=bucket'+num+' id=bucket'+num+' onchange="bucketChange(this)" > </select>');

			$('#bucket'+num).append('<option value="-Select Bucket-">-Select Bucket-</option>');
			
 			<c:forEach items="${bucketList }" var="list">
				$('#bucket'+num).append('<option value=${list }>${list }</option>');
			</c:forEach> 
			
			bindDiv2.append('.<select name=bucket'+num+'Scope id=bucket'+num+'Scope onchange="scopeChange(this)" > </select>');
			bindDiv2.append('.<select name=bucket'+num+'ScopeCollection id=bucket'+num+'ScopeCollection>');
			
			bindDiv2.append('<h5> Access </h5>');
			bindDiv2.append('<select name=access'+num+' id=access'+num+'></select>');
			$('#access'+num).append('<option value=r> read only </option>');
			$('#access'+num).append('<option value=rw> read and write </option>')
			bindDiv2.append('<hr>');
		}
		
		if(chk.value=='URL alias'){
			
			$('#bindDiv'+num).remove();
			
			bindDiv.append('<input type=text name=url'+num+' id=url'+num+' placeholder="URL Address" style=margin-left:5px; />');			
			
			bindDiv.append('<div id=bindDiv'+num+'></div>');
			let bindDiv2 = $('#bindDiv'+num); 
			
			bindDiv2.append('<input type=checkbox name=allowCookies'+num+' id=allowCookies'+num+' value="true" /> &nbsp; 쿠키 허용');
			bindDiv2.append('&nbsp; <input type=checkbox name=validateSSLCertificate'+num+' id=validateSSLCertificate'+num+' value="true" /> &nbsp; SSL 유효성 검사');
			bindDiv2.append('<br><select name=authType'+num+' id=authType'+num+' style=margin-top:10px; onchange=authChange(this) ></select>');
			$('#authType'+num).append('<option value=no-auth>no auth</option>');
			$('#authType'+num).append('<option value=basic>basic</option>');
			$('#authType'+num).append('<option value=bearer>bearer</option>');
			$('#authType'+num).append('<option value=digest>digest</option>');
			
			$('#authType'+num).change();
			
			// allow cookies 넘어가는거 확인
			
		}
	}
	
	
	
	function authChange(chk){
		
		let num = chk.id.substring(8);
		
		if($('#span'+num).length)
			$('#span'+num).remove();
		
		$('#bindDiv'+num).append('<span id=span'+num+'></span>');

		if(chk.value=='basic' || chk.value=='digest'){
			$('#span'+num).append(' &nbsp; <input type=text name=username'+num+' id=username'+num+' placeholder=username..>');
			$('#span'+num).append(' &nbsp; <input type=password name=password'+num+' id=password'+num+' placeholder=password..>');
		}
		else if(chk.value=='bearer'){
			$('#span'+num).append(' &nbsp; <input type=password name=bearerKey'+num+' placeholder="bearer key..">');
		}
		
		$('#span'+num).append('<hr>');

	}
	
	function setBinding(num,type){
		if(type == 'bucket'){
			$('#alias'+num).val(bindingBucketArray[num].get('alias'));	
			$('#bucket'+num).val(bindingBucketArray[num].get('bucket_name'));	
			$('#bucket'+num).change();
			$('#bucket'+num+'Scope').val(bindingBucketArray[num].get('scope_name'));	
			$('#bucket'+num+'ScopeCollection').val(bindingBucketArray[num].get('collection_name'));	
			$('#access'+num).val(bindingBucketArray[num].get('access'));
			
		}
		else if(type == 'alias'){
			
			let num2 = num- bindingBucketArray.length;
			
			$('#alias'+num).val(bindingUrlArray[num2].get('alias'));	
			$('#url'+num).val(bindingUrlArray[num2].get('hostname'));	
			
			if(bindingUrlArray[num2].get('allow_cookies')=='true')
				$('#allowCookies'+num).attr("checked", true);
			if(bindingUrlArray[num2].get('validate_ssl_certificate')=='true')
				$('#validateSSLCertificate'+num).attr("checked", true);
			
			$('#authType'+num).val(bindingUrlArray[num2].get('auth_type'));	
			$('#authType'+num).change();

			$('#username'+num).val(bindingUrlArray[num2].get('username'));	
			$('#password'+num).val(bindingUrlArray[num2].get('password'));	
			$('#bearer_key'+num).val(bindingUrlArray[num2].get('bearer_key'));	

		}
	}
	
	// 로딩 완료 후 
	$(document).ready(function(){
		$('#srcBucket').change();
		$('#metaBucket').change();
		
		let bucketBindingLength  = parseInt('${functions.depcfg.buckets.size()}');
		let urlBindingLength	 = parseInt('${functions.depcfg.curl.size()}');
		
		
		<c:forEach items="${functions.depcfg.buckets}" var="list">
		
			var map = new Map();
			map.set('alias',"${list.alias}");
			map.set('bucket_name',"${list.bucket_name}");
			map.set('scope_name',"${list.scope_name}");
			map.set('collection_name',"${list.collection_name}");
			map.set('access',"${list.access}");
			
			bindingBucketArray.push(map);
		</c:forEach>
		
		<c:forEach items="${functions.depcfg.curl}" var="list">
			var map = new Map();
			map.set('alias',"${list.value}");
			map.set('hostname',"${list.hostname}");
			map.set('auth_type',"${list.auth_type}");
			map.set('username',"${list.username}");
			map.set('password',"${list.password}");
			map.set('bearer_key',"${list.bearer_key}");
			map.set('allow_cookies',"${list.allow_cookies}");
			map.set('validate_ssl_certificate',"${list.validate_ssl_certificate}");
			
			bindingUrlArray.push(map);
		</c:forEach>
		
		for(let i=0;i<bucketBindingLength;i++){
			
			addBinding('bucket');
			$('#bindingType'+i).change();
			setBinding(i,'bucket');
		}
		for(let i=0;i<urlBindingLength;i++){
			
			addBinding('url');
			$('#bindingType'+(i+bucketBindingLength)).change();
			setBinding((i+bucketBindingLength),'alias');
		}
		
		
		
		setTimeout(function() {
			existingForm = getFormData($('#eventForm'));
		}, 500);
		
	});
	
	function updateEventFunction(){
		
		
 		if(!inputCheck($('#eventForm'))){
			alert('모든 항목을 입력해주세요.');
			return;
		} 
		 
		let data = $('#eventForm').serialize();

		data += "&aliasLength=" + $('#bindingDiv').children().length;
		
		if(($('#srcBucket').val() == $('#metaBucket').val()) &&
				($('#srcBucketScope').val() == $('#metaBucketScope').val()) && 
					($('#srcBucketScopeCollection').val() == $('#metaBucketScopeCollection').val())){
			
			alert('Source와 MetaData의 Keyspace는 같은 공간일 수 없습니다.');
			return;
		}
		
		if($('#workers').val() > 64){
			alert('worker의 수는 64 이하여야 합니다.');
			return;
		}
		
		if($('#scriptTimeout').val() > 60){
			alert('스크립트 timeout이 너무 큽니다. Mutation의 속도가 느려질 수 있습니다.');
			return;
		}
		
		if($('#timerContextSize').val() < 20 || $('#timerContextSize').val() > 20971520){
			alert('timer Context의 크기는 20byte이상, 20MB 이하여야 합니다.');
			return;
		}
		
		
		for(let i=0;i<$('#bindingDiv').children().length;i++){
			
			if($('#bindingType'+i).val() == 'URL alias'){
				let url = $('#url'+i).val();
				
				let url2 = url.substring(0,6);
				
				if(!url2.includes('http')){
					alert('url은 http://혹은 https://로 시작해야합니다.');
					return;
				}
			}
		}
		
		let nowForm = getFormData($('#eventForm'));
		let returnValue = _compare(nowForm, existingForm);
		
		returnValue += 'existingFunctionName=' + existingFunctionName;
		returnValue += "&aliasLength=" + $('#bindingDiv').children().length;

		
		console.log(returnValue);
		
  	 	$.ajax({
			
			data:returnValue,
			url:"<%=request.getContextPath()%>/updateEventFunction",
			type:"post",
			error : function (xhr, status, error){
				alert(error);
			},
			success : function (data){
				if(data.includes('Stored function')){
					alert('Function을 수정했습니다.');
					window.close();
					opener.location.reload();
				}
				else
					alert(data);
			}
		});  
  		
	}
	


</script>
</head>
<body>

	<div class=container>
		<br>
		<form id=eventForm>
			<h5> Source Bucket <span style=font-size:10px;>bucket.Scope.Collection</span></h5> 
			
			<select name=srcBucket onchange="bucketChange(this)" id=srcBucket>
				<option value='-Select Bucket-'>-Select Bucket-</option>
				<c:forEach items="${bucketList }" var="list">
					<option value=${list } <c:if test="${functions.depcfg.source_bucket eq list }"> selected </c:if> >${list }</option>
				</c:forEach>
			</select>
			.
			<select name=srcBucketScope onchange="scopeChange(this)" id=srcBucketScope>
				<%-- <option value="${functions.depcfg.source_scope }">${functions.depcfg.source_scope }</option> --%>
			</select>
			.
			<select name=srcBucketScopeCollection id=srcBucketScopeCollection>
				<%-- <option value="${functions.depcfg.source_collection }">${functions.depcfg.source_collection }</option> --%>
			</select>
			<br><br>
			
			<h5> MetaData Bucket <span style=font-size:10px;>bucket.Scope.Collection</span></h5> 
			
			<select name=metaBucket onchange="bucketChange(this)" id=metaBucket>
				<option value='-Select Bucket-'>-Select Bucket-</option>
				<c:forEach items="${bucketList }" var="list">
					<option value=${list } <c:if test="${functions.depcfg.metadata_bucket eq list }"> selected </c:if> >${list }</option>
				</c:forEach>
			</select>
			.
			<select name=metaBucketScope onchange="scopeChange(this)" id=metaBucketScope>
			</select>
			.
			<select name=metaBucketScopeCollection id=metaBucketScopeCollection >
			</select>
			<br><br>
			
			<h5> Function 이름</h5>
			<input type=text name=functionName id=functionName value=${functions.appname } style=width:95%;>
			<br>
			
			<h5> 설명</h5> 
			<textarea name=description cols=65>${functions.settings.description }</textarea>
			<br><br>
			
			<a href="#" onclick="viewSetting();"> > Settings</a> 
			
			<br>
			<div id=settings class="collapse" style="display:none; margin-left:25%;">
				<div>
					<h6>System Log Level</h6>
					<select name=logLevel id=logLevel>
						<option value=INFO <c:if test="${functions.settings.log_level eq 'INFO' }"> selected </c:if> >Info</option>
						<option value=ERROR <c:if test="${functions.settings.log_level eq 'ERROR' }"> selected </c:if> > Error</option>
						<option value=WARNING <c:if test="${functions.settings.log_level eq 'WARNING' }"> selected </c:if> >Warning</option>
						<option value=DEBUG <c:if test="${functions.settings.log_level eq 'DEBUG' }"> selected </c:if> >Debug</option>
						<option value=TRACE <c:if test="${functions.settings.log_level eq 'TRACE' }"> selected </c:if> >Trace</option>
					</select>
					<br><br>
					
					<h6>Default Feed Boundary</h6>
					<select name=feedBoundary id=feedBoundary>
						<option value=everything <c:if test="${functions.settings.default_stream_boundary eq 'everything' }"> selected </c:if> >Everything</option>
						<option value=from_now <c:if test="${functions.settings.default_stream_boundary eq 'from_now' }"> selected </c:if> >From Now</option>
					</select>
					<br><br>
					
					<h6>N1QL Consistency</h6>
					<select name=n1qlConsistency id=n1qlConsistency>
						<option value=none <c:if test="${functions.settings.n1ql_consistency eq 'none' }"> selected </c:if> >None</option>
						<option value=request <c:if test="${functions.settings.n1ql_consistency eq 'request' }"> selected </c:if> >Request</option>
					</select>
					<br><br>
					
					<h6>Workers</h6>
					<input type=text name=workers id=workers onKeyup="_onlyNumber(this);" value="${functions.settings.worker_count }" >
					<br>
					
					<h6>언어 호환성</h6>
					<select name=languageCompatibility id=languageCompatibility>
						<option value=6.0.0 <c:if test="${functions.settings.language_compatibility eq '6.0.0' }"> selected </c:if> >6.0.0</option>
						<option value=6.5.0 <c:if test="${functions.settings.language_compatibility eq '6.5.0' }"> selected </c:if> >6.5.0</option>
					</select>
					<br><br>
				
					<h6>Script TimeOut <span style=text-size:12px;>(Seconds)</span></h6>
					<input type=text name=executionTimeout id=scriptTimeout onKeyup="_onlyNumber(this);" value="${functions.settings.execution_timeout }" >
					<br>
				
					<h6>Timer Context Max Size <span style=text-size:12px;>(bytes)</span></h6>
					<input type=text name=timerContextSize id=timerContextSize onKeyup="_onlyNumber(this);" value="${functions.settings.timer_context_size }" > 
					<br>
				
				</div>
			</div>
			<br>
			
			<h5 style="margin-bottom:-20px;"> 바인딩 </h5>
				<button type=button class="btn btn-light" style="float:right; margin-left:10px;" onclick="removeBinding();">-</button>
				<button type=button class="btn btn-light" style=float:right onclick="addBinding();">+</button>
				<br>
			<hr>
			
			<div id=bindingDiv>
				
			</div>
			
		</form>
			
		<button type=button class="btn btn-primary" style=float:right; onclick="updateEventFunction();">Save</button>
	</div>

</body>
</html>