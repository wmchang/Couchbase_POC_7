<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/static/css/index.css">
<!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css"> -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"><!-- 합쳐지고 최소화된 최신 자바스크립트 -->

</head>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="<%= request.getContextPath()%>/static/js/head_function.js"></script>

<body>

	<div id="header">
		<a> <img src="<%= request.getContextPath()%>/static/image/cb_logo_bug_white_2.svg"
			alt="Couchbase Server" class="logobug">
		</a>
	</div>
	<div id=header-tab>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/"> 서버 연결 설정 </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/nodeManagePage"> 노드 </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/bucketManagePage"> 버킷 </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/documents/documentPage"> 문서 </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/queryExcutePage"> 쿼리 </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/fts/ftsPage" > FTS </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/eventingPage" > 이벤트 </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/analyticsPage" > 분석 </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/randomDataPage"> 랜덤 데이터 </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/CsvOrFileUpsertPage"> 파일 업로드 </a>
		</div>
		<div class="menu">
			<a href="<%= request.getContextPath()%>/logPage"> 로그 </a>
		</div>
		<div class="menu">
			<div class=dropdown>
				<a href="<%= request.getContextPath()%>/settings/setting"> 환경 설정 </a>
				<div class="dropdown-content">
				    <a href="<%= request.getContextPath()%>/settings/setting">일반 설정</a>
				    <a href="<%= request.getContextPath()%>/settings/autoCompactionPage">자동 압축</a>
				    <a href="<%= request.getContextPath()%>/settings/emailAlertsPage">이메일 알림</a>
				    <a href="<%= request.getContextPath()%>/settings/sampleBucketPage">샘플 버킷</a>
				    <a href="<%= request.getContextPath()%>/settings/querySettingPage">쿼리 세팅</a>
				</div>
			</div>
		</div>
	</div>
<!-- RandBot 	
<script SameSite="None; Secure" src="https://static.landbot.io/landbot-widget/landbot-widget-1.0.0.js"></script>
<script>
  var myLandbot = new LandbotLivechat({
    index: 'https://chats.landbot.io/v2/H-732845-Q0420772Y6TURE5U/index.html',
  });
</script>

 -->
 </body>
</html>