<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Couchbase</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>

</head>
<script>

	function downloadSampleBucket() {

		var check = boxCheck();
		if (check == false) {
			alert('원하는 버킷을 체크해주십시오.');
			return;
		}

		var data = jQuery("#sampleBucketForm").serializeArray();

		$.ajax({
		    contentType : "application/x-www-form-urlencoded; charset=utf-8",
			type : "post",
			url : "<%= request.getContextPath()%>/downSampleBucket",
			data : data,
			error : function(xhr, status, error) {
				alert(data);
			},
			success : function(data) {
				alert(data);
			}
		});
	}

	function boxCheck() {
		if($('input:checkbox[name=sampleBucket]:checked').length==0)
			return false;
		return true;
	}
	
</script>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
<form id="sampleBucketForm" name="sampleBucketForm" style=display:flex;>
	<div class=container>
		<div class=row>
			<div class="mx-auto col-lg-5" ><br>
				<h4> &nbsp; 샘플 버킷서비스</h4><br>
				<div>
					<h5>- 테스트를 위해 data, view, index가 포함된 샘플 버킷을 다운로드 받을 수 있습니다.  </h5>
					<div>
						<input type="checkbox" name="sampleBucket" value="beer-sample" />
						&nbsp; beer-sample
					</div>
					<div>
						<input type="checkbox" name="sampleBucket" value="travel-sample" />
						&nbsp; travel-sample
					</div>
					<div>
						<input type="checkbox" name="sampleBucket" value="gamesim-sample"/>
						&nbsp; gamesim-sample
					</div>
				</div>
				<div align="right">
					<button type="button" class="btn btn-primary float-right" onclick="downloadSampleBucket();">다운로드</button>
				</div>
			
			</div>
			
		</div>
	</div>
</form>

</body>
</html>