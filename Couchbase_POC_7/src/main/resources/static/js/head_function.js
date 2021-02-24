


let _top = (window.screen.height/2)-(300/2);
let _left = (window.screen.width/2)-(300/2); 


	// radio 클릭 시 상태변화에 맞춰 같이 움직여야하는 값들 disable 화 시켜주는 메소드.
	// id에 해당 radio랑 같은 id를 맞춰주면 된다.
	function radioDisableChecking(chk){
		
		if(chk.value == 'false'){
			$("input#"+chk.id).attr("disabled", true);
			$("input[name="+chk.name+"]").removeAttr("disabled");
		}
		else{
			$("input#"+chk.id).removeAttr("disabled");
		}
	}
	
	// checkbox 클릭 시 체크되면 disabled풀고 체크가 풀리면 disabled 시켜주는 메소드.
	// id에 해당 checkbox와 같은 id를 맞춰주면 된다.
	function checkboxDisableChecking(chk){
		
		if(!chk.checked){
			$("input#"+chk.id).attr("disabled", true);
			$("input[name="+chk.name+"]").removeAttr("disabled");
		}else{
			$("input#"+chk.id).removeAttr("disabled");
		}
	}
	
	// 넣어야하는 input항목,textarea 빈 값 없나 체크해주는 메소드.
	// form을 매개변수로 주면된다.
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
	
	
	// input text에 숫자만 넣어야할 때 사용하는 메소드.
	// this를 매개변수로 주면된다.
	function _onlyNumber(chk){
		chk.value=chk.value.replace(/[^0-9]/g,'');
	}
	
	
	// form 데이터를 Object화 시켜주는 메소드. (key:value)
	function getFormData($form){
	    var unindexed_array = $form.serializeArray();
	    var indexed_array = {};

	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });

	    return indexed_array;
	}
	
	// Object를 비교해 다른 값, 혹은 사라진 key=value&로 추출해내는 메소드
	// return 값 = key=value&key2=value2&
	function _compare(newData, existsData){
		
		let arrays = Object.keys(existsData);
		
		let str = '';
		
		for(let i=0;i<arrays.length;i++){
			
			let key = arrays[i];
			
			// 기존 key에 해당하는 value가 달라진 경우, 기존 Key가 사라진 경우
 			if(newData[key] != existsData[key]){
				
				str +=key+'='+newData[key]+'&';
			}
		}
		
		return str;
	}
	
