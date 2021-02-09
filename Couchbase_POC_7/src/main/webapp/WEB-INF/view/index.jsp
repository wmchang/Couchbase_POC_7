<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"><!-- �������� �ּ�ȭ�� �ֽ� �ڹٽ�ũ��Ʈ -->

<script>
	function connectionData() {
		
		var check = inputCheck($("#conDataForm"));
		if(check == false){
			alert('��� �׸��� �Է����ּ���.');
			return;
		}
		
		var data = $("#conDataForm").serializeArray();
		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/conData",
			data : data,
			error : function(xhr, status, error) {
				console.log(error);
				alert('�Է��� �߸��Ǿ����ϴ�.');
			},
			success : function(data) {
				alert(data);
			}
		});
	
	}
	
	function testButton(){
		
		document.querySelector('#hostname').value='localhost';
		document.querySelector('#portNumber').value='8091';
		document.querySelector('#username').value='Administrator';
		document.querySelector("#password").value='admin123';
		document.querySelector('#bucketName').value='test';
		connectionData();
	}
</script>
</head>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
<div class="container-fluid">
	<form id="conDataForm" name="conDataForm" >
    <div class="row">
        <div class="col-lg-2 borderDiv mx-auto"><br>
        	<h4> &nbsp; ���� </h4><br>
			<div>
				# ȣ��Ʈ �̸�<br> <input type="text" name="hostname" id="hostname" />
			</div>
			
			<div>
				# ��Ʈ��ȣ<br> <input type="text" name="portNumber" id="portNumber" />
			</div>

			<div>
				# ���� �̸�<br> <input type="text" name="username" id ="username" />
			</div>

			<div>
				# �н�����<br> <input type="password" name="password" id ="password" />
			</div>

			<div>
				# ��Ŷ �̸�<br> <input type="text" name="bucketName" id ="bucketName" />
			</div>
			<button style=margin-top:5px; class="btn btn-primary float-right" type=button onclick="testButton();">�׽�Ʈ</button>
        </div>
        
        <div class="col-lg-2 borderDiv mx-auto"><br>
        	<h4> &nbsp; Timeout ���� </h4><br>
			<div>
				# Key-Value TimeOut <br>
				<input type="text" name="kvTimeout" size="10" value=2500
					onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# View TimeOut <br>
				<input type="text" name="viewTimeout" size="10" value=75000
					onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# Query TimeOut <br>
				<input type="text" name="queryTimeout" size="10" value=75000
					onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# Search TimeOut <br>
				<input type="text" name="searchTimeout" size="10" value=75000
					onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# Analytics TimeOut <br>
				<input type="text" name="analyticsTimeout" size="10" value=75000
					onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# Connect TimeOut <br>
				<input type="text" name="connectTimeout" size="10" value=5000
					onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# Disconnect TimeOut <br>
				<input type="text" name="disconnectTimeout" size="10" value=25000
					onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# Connect TimeOut <br>
				<input type="text" name="managementTimeout" size="10" value=75000
					onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
        </div>
        <div class="col-lg-3 borderDiv mx-auto"><br>
        	<h4> &nbsp; I/O ���� </h4><br>
        	<div>
				# DNS SRV ���<br>
				<input type="radio" name="enableDnsSrv" value="true" checked />
				<label for=true>True</label>
				
				<input type="radio" name="enableDnsSrv" value="false"  /> 
				<label for=true>False</label>
			</div>
        	<div>
				# Mutation Tokens ���<br> <!-- ��� �� ������ �䱸���װ� ��� N1QL ������� ���>> ������� ���. -->
				<input type="radio" name="mutationTokensEnabled" value="true" checked />
				<label for=true>True</label>
				
				<input type="radio" name="mutationTokensEnabled" value="false"  />
				<label for=true>False</label>
			</div>
        	<div>
				# TCP ���� ����<br> <!-- ��� �� ������ �䱸���װ� ��� N1QL ������� ���>> ������� ���. -->
				<input type="radio" name="enableTcpKeepAlives" id=tcpGroup value="true" checked onclick="radioDisableChecking(this)" />
				<label for=true>True</label>
				
				<input type="radio" name="enableTcpKeepAlives" id=tcpGroup value="false"  onclick="radioDisableChecking(this)" />
				<label for=true>False</label>
			</div>
			<div>
				# TCP ���� �ð�<br>
				<input type="text" name="tcpKeepAliveTime"  id=tcpGroup 
					value=60000 onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# KV Connection ��<br>
				<input type="text" name="numKvConnections" 
					value=1 onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# HTTP Connection ��<br>
				<input type="text" name="maxHttpConnections" 
					value=12 onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# HTTP Connection ���� �ð�<br>
				<input type="text" name="idleHttpConnectionTimeout" 
					value=30000 onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# Config ���� �ð� ����<br>
				<input type="text" name="configPollInterval" 
					value=2500 onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			<div>
				# �ش� ���� Ʈ���� ĸó <br>
				<input type="checkbox" name="captureTraffic" value="kv"> Data
				<input type="checkbox" name="captureTraffic" value="query"> Query
				<input type="checkbox" name="captureTraffic" value="search"> Search<br>
				<input type="checkbox" name="captureTraffic" value="view"> View
				<input type="checkbox" name="captureTraffic" value="analytics"> Analytics
				<input type="checkbox" name="captureTraffic" value="manager"> Server
			</div>
        </div>
        
        <div class="col-lg-3 borderDiv mx-auto"><br>
			<h4> &nbsp; Security ���� </h4><br>
			<div>
				# TLS ��ȣȭ <br> <!-- ��� �� ������ �䱸���װ� ��� N1QL ������� ���>> ������� ���. -->
				<input type="radio" name="enableTls" value="true" id=tlsGroup onclick="radioDisableChecking(this)" />
				<label for=true>True</label>
				
				<input type="radio" name="enableTls" value="false" id=tlsGroup onclick="radioDisableChecking(this)" checked />
				<label for=true>False</label>
			</div>
			<div>
				# TLS ������ ��� <br>
				<input type="text" name="keyStorePath" disabled id=tlsGroup>
			</div>
			<div>
				# TLS ������ ��й�ȣ <Br>
				<input type="text" name="keyStorePwd" disabled id=tlsGroup>
			</div>
			<div>
				# TLS Provider ���� <br> <!-- ��� �� ������ �䱸���װ� ��� N1QL ������� ���>> ������� ���. -->
				<input type="radio" name="enableNativeTls" value="true" checked />
				<label for=true>True</label>
				
				<input type="radio" name="enableNativeTls" value="false"  />
				<label for=true>False</label>
			</div>
			
			<br><br>
			
			<h4> &nbsp; ���� ���� </h4><br>
				
			<div>
				# ���� ���� �� �ڵ����� <br>
				
				<input type="radio" name="enableCompression" value="true" checked  id=compressionGroup onclick="radioDisableChecking(this)"/>
				<label>True</label>
				
				<input type="radio" name="enableCompression" value="false" id=compressionGroup onclick="radioDisableChecking(this)"/> 
				<label>False</label>
			</div>
			
			<div>
				# �����ų ���� �ּ� ������(byte)<br>
				<input type="text" name="compressionMinSize"   id=compressionGroup
					value=32 onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
			</div>
			
			<div>
				# ���� ����<br>
				<input type="text" name="compressionMinDouble"  id=compressionGroup
					value=0.83 />
			</div>
			
			<div style="align-items:bottom; text-align:right;">
				<button type="button" class="btn btn-primary" onclick="connectionData();">����</button>
			</div>
        </div>
        </div>
    </form>
</div>

</body>
</html>