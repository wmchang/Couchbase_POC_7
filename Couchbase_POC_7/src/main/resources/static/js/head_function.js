


	// radio 클릭 시 상태변화에 맞춰 같이 움직여야하는 값들 disable 화 시켜주는 메소드.
	// id 에 해당 radio랑 같은 id를 맞춰주면된다.
	function radioDisableChecking(chk){
		
		if(chk.value == 'false'){
			$("input#"+chk.id).attr("disabled", true);
			$("input[name="+chk.name+"]").removeAttr("disabled");
		}
		else{
			$("input#"+chk.id).removeAttr("disabled");
		}
	}
	
	// 넣어야하는 input text 항목들 빈 값 없나 체크해주는 메소드.
	function inputCheck(forms){
	
		let inputText = $("#"+forms.attr('id')+ " input");
		let textareaCheck = $("#"+forms.attr('id')+ " textarea");
		
		for(let i=0;i<inputText.length; i++){
			
			if(inputText[i].value == "" || inputText[i].value == null){
				
				if(inputText[i].disabled){
					continue;
				}
				return false;
			}
		}		
		
		for(let j=0;j<textareaCheck.length; j++){
			
			if($.trim(textareaCheck[j].value) =="" || $.trim(textareaCheck[j].value)==null){
				if(textareaCheck[j].disabled){
					continue;
				}
				return false;
			}
		}
		
		return true;
	}
	
	
	// 파라미터 값이 들어있으면 window.close()로 창 닫아주는 메소드
	function _checkClose(chk,val){
		if(chk.includes(val))
			window.close();
	}