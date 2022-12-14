<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<head>
<meta charset="UTF-8">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">


<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<style type="text/css">
	#joinWindow-backgroud{
		position:fixed;
		z-index: 1000;
		top: 0;
		left: 0;
		width:100%;
		height:100%;
		background-color:rgba(88,88,88,0.8);
	}
	#joinWindow-joinWindowShow{
		position:fixed;
		z-index: 1010;
		top: 5%;
		left: 30%;
		width:40%;
		height:90%;
		background-color: white;
		border-radius: 20px;
	}
	
	.ui-state-default{
		background-color: #e4ceeb !important;
	}
	.ui-state-active{
		background-color: #8851db !important;
		border: 0 !important;
	}
	.ui-datepicker-header{
		background-color: #fcf2ff !important;
	}
	.ui-datepicker-calendar thead{
		font-size: 16pt !important;
	}
	.ui-datepicker{
		border: 1px solid #ecd8f2 !important;
		margin: auto;
	}
	
	.ui-icon-circle-triangle-w{
		visibility: hidden; 
	}
	.ui-icon-circle-triangle-e{
		visibility: hidden; 
	}
	.ui-datepicker-next{
		margin-top: 1%;
		background-image: url("../resources/img/monthIcon.png");
		background-repeat: no-repeat; 
		background-position: center center;
		background-size : cover;
	}
	.ui-datepicker-prev{
		margin-top: 1%;
		background-image: url("../resources/img/monthIcon.png");
		background-repeat: no-repeat; 
		background-position: center center;
		background-size : cover;
		transform:rotate(180deg);
	}

	.ui-datepicker-next:hover{
		background-image: url("../resources/img/monthIcon.png");
		background-repeat: no-repeat; 
		background-position: center center;
		background-size : cover;
		background-color: inherit;
		border: 1px solid #e2cfe8;
	}
	.ui-datepicker-prev:hover{
		background-image: url("../resources/img/monthIcon.png");
		background-repeat: no-repeat; 
		background-position: center center;
		background-size : cover;
		background-color: inherit;
		border: 1px solid #e2cfe8;
	}
	.ui-datepicker-next.ui-state-disabled{
		background-image: url("../resources/img/monthIcon.png");
		background-repeat: no-repeat; 
		background-position: center center;
		background-size : cover;
		background-color: inherit;
		border: 1px solid #e2cfe8;
	}
	.ui-datepicker-prev.ui-state-disabled{
		background-image: url("../resources/img/monthIcon.png");
		background-repeat: no-repeat; 
		background-position: center center;
		background-size : cover;
		background-color: inherit;
		border: 1px solid #e2cfe8;
	}
	.collapseDiv1{
		width: 100%;
		height: 10em;
		overflow: hidden;
		transition: height 0.5s;
	}
	.collapseDiv2{
		width: 100%;
		height: 9em;
		overflow: hidden;
		transition: height 0.5s;
	}
	.collapseUp{
		height: 0;
	}
	#couponDiv1:hover *{
		text-decoration: underline;
	}
	
</style>

<script type="text/javascript">

var disabledDays;

var payment_freepJoin_date=0;
var coupon_no=0;
var payment_method=0;

//Ajax??? ?????? ????????? ????????? ????????? ???????????? disabledDays??? ?????????
function getReservationDates() {
	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function(){
		if(xhr.readyState  == 4 && xhr.status == 200){
			var jsonObj = JSON.parse(xhr.responseText);
						
			disabledDays=jsonObj.reservationDates; //disabledDays=["2022-8-3","2022-8-8"];
		}
	};	
	xhr.open("get","./getReservationDates?freep_no="+${fp_FreepVo.freep_no});
	xhr.send();
}


function joinWindowOpen() {
	if(payment_freepJoin_date==null) payment_freepJoin_date=0;
	
	document.body.style.overflow = "hidden";
	joinStep1();
	document.getElementById("joinWindow-backgroud").style.visibility="visible";
	document.getElementById("joinWindow-joinWindowShow").style.visibility="visible";
}

function joinWindowClose() {
	payment_freepJoin_date=0;
	coupon_no=0;
	payment_method=0;
	
	document.getElementById("joinNextBtn").innerText = '??????';
	
	//?????? ?????? ????????? ????????? - ?????? ????????????
	document.getElementById("icon-step1").style.display="none";
	document.getElementById("icon-step1-fill").style.display="none";
	document.getElementById("icon-step2").style.display="none";
	document.getElementById("icon-step2-fill").style.display="none";
	document.getElementById("icon-step3").style.display="none";
	document.getElementById("icon-step3-fill").style.display="none";
		
	document.body.style.overflow = "visible";
	document.getElementById("joinWindow-backgroud").style.visibility="hidden";
	document.getElementById("joinWindow-joinWindowShow").style.visibility="hidden";
}

function applyCoupon(couponDiv1) {
	coupon_no = couponDiv1.firstChild.innerText;
	var couponInfoSpan0 = document.getElementById('couponInfoSpan0');
	couponInfoSpan0.innerHTML='';
	
	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function(){
		if(xhr.readyState  == 4 && xhr.status == 200){
			var jsonObj = JSON.parse(xhr.responseText);
			
			couponInfoSpan0.innerText=jsonObj.fp_MemberCouponVo.coupon_expiration;
		
			var couponPriceSpan2 = document.createElement('span');
			couponPriceSpan2.innerText='-'+jsonObj.couponPriceStringFormat+"???";
			couponPriceSpan2.style.marginLeft='5%';
			couponInfoSpan0.appendChild(couponPriceSpan2);
			
			var couponSelectCancelBtn = document.createElement('button');
			couponSelectCancelBtn.style.marginLeft='1%';
			couponSelectCancelBtn.style.border=0;
			couponSelectCancelBtn.style.fontSize='11pt';
			couponSelectCancelBtn.style.fontWeight='normal';
			couponSelectCancelBtn.style.color='#615d63';
			couponSelectCancelBtn.style.backgroundColor='#faedf0';
			couponSelectCancelBtn.innerText='????????????';
			couponSelectCancelBtn.setAttribute('onclick','couponSelectCancel()');
			
			couponInfoSpan0.appendChild(couponSelectCancelBtn);
			
			
			var showPaymentCouponInfoSpan = document.getElementById('showPaymentCouponInfoSpan');
			showPaymentCouponInfoSpan.innerText = jsonObj.fp_MemberCouponVo.coupon_expiration;
			
			var showPaymentCouponPriceSpan = document.getElementById('showPaymentCouponPriceSpan');
			showPaymentCouponPriceSpan.innerText = "-"+jsonObj.couponPriceStringFormat+"???";

			var showPaymentResultPriceSpan = document.getElementById('showPaymentResultPriceSpan');
			showPaymentResultPriceSpan.innerText = 
				(${fp_FreepVo.freep_price}-jsonObj.fp_MemberCouponVo.sale_price).toLocaleString('ko-KR')+"???";
				
		}
	};	
	xhr.open("get","./getOneCoupon?coupon_no="+couponDiv1.firstChild.innerText);
	xhr.send();
	
	document.getElementById('collapseDiv2').classList.toggle('collapseUp');
	document.getElementById('couponHeaderIcon').classList.toggle('bi-caret-up');
	
}

function selectCouponExist() {
	
	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function(){
		if(xhr.readyState  == 4 && xhr.status == 200){
			var jsonObj = JSON.parse(xhr.responseText);
			
			var showPaymentCouponInfoSpan = document.getElementById('showPaymentCouponInfoSpan');
			showPaymentCouponInfoSpan.innerText = jsonObj.fp_MemberCouponVo.coupon_expiration;
			
			var showPaymentCouponPriceSpan = document.getElementById('showPaymentCouponPriceSpan');
			showPaymentCouponPriceSpan.innerText = "-"+jsonObj.couponPriceStringFormat+"???";

			var showPaymentResultPriceSpan = document.getElementById('showPaymentResultPriceSpan');
			showPaymentResultPriceSpan.innerText = 
				(${fp_FreepVo.freep_price}-jsonObj.fp_MemberCouponVo.sale_price).toLocaleString('ko-KR')+"???";
		}
	};	
	xhr.open("get","./getOneCoupon?coupon_no="+coupon_no);
	xhr.send();
}


function couponSelectCancel() {
	coupon_no=0;
	var couponInfoSpan0 = document.getElementById('couponInfoSpan0');
	couponInfoSpan0.innerHTML='';
	
	var couponInfoSpan1 = document.createElement('span');
	couponInfoSpan1.innerText = '???????????? ?????? '
	couponInfoSpan0.appendChild(couponInfoSpan1);
	
	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function(){
		if(xhr.readyState  == 4 && xhr.status == 200){
			var jsonObj = JSON.parse(xhr.responseText);
			
			var couponListSize = jsonObj.couponListSize;
			var couponInfoSpan2 = document.createElement('span');
			couponInfoSpan2.innerText = couponListSize+'???';
			couponInfoSpan2.style.color='#8719b3';
			couponInfoSpan0.appendChild(couponInfoSpan2);
		}
	};
	xhr.open("get","./getCouponList");
	xhr.send();
	
	
	var showPaymentCouponInfoSpan = document.getElementById('showPaymentCouponInfoSpan');
	showPaymentCouponInfoSpan.innerText = '????????????';
	
	var showPaymentCouponPriceSpan = document.getElementById('showPaymentCouponPriceSpan');
	showPaymentCouponPriceSpan.innerText = '-';
	
	var showPaymentResultPriceSpan = document.getElementById('showPaymentResultPriceSpan');
	showPaymentResultPriceSpan.innerText = document.getElementById('showPaymentFreepPriceSpan').innerText;
	
	
}



function joinStep1() {
	
	//?????? ?????? ????????? ??????
	document.getElementById("icon-step1").style.display="none";
	document.getElementById("icon-step1-fill").style.display="inline";
	document.getElementById("icon-step2").style.display="inline";
	document.getElementById("icon-step2-fill").style.display="none";
	document.getElementById("icon-step3").style.display="inline";
	document.getElementById("icon-step3-fill").style.display="none";
	
	//??????,???????????? ?????? ??? ?????? ??????
	document.getElementById("joinPreBtn").style.display="none";//??????????????? ????????????
	document.getElementById("joinNextBtn").style.width="70%"; //???????????? ?????? 70%???
	document.getElementById("joinNextBtn").setAttribute('onClick','joinStep2()');//???????????? ????????? ??????2???
	
	var modalContentsDiv = document.getElementById("modalContentsDiv");
	modalContentsDiv.innerHTML="";
	
	var datepickerDiv = document.createElement('div');
	datepickerDiv.id='datepicker';
	
	var datepickTextDiv = document.createElement('div');
	
	var tempDiv1 = document.createElement('div');
	tempDiv1.innerText="?????? ???????????? ????????? ????????? ??????????????????.";
	tempDiv1.classList.add("text-center");
	tempDiv1.style.fontSize='10pt';
	tempDiv1.style.color='red';
	datepickTextDiv.appendChild(tempDiv1);
	
	var tempDiv2 = document.createElement('div');
	tempDiv2.style.marginTop='3%';
	
	var tempSpan2 = document.createElement('span');
	tempSpan2.innerText="???????????? : ";
	tempSpan2.style.fontSize='17pt';
	tempDiv2.appendChild(tempSpan2);
	
	var datepickTextInput = document.createElement('input');
	datepickTextInput.type='text';
	datepickTextInput.id='datepickText';
	datepickTextInput.disabled='disabled';
	datepickTextInput.style='width: 30%';
	datepickTextInput.style.fontSize='17pt';
	tempDiv2.appendChild(datepickTextInput);
	
	datepickTextDiv.appendChild(tempDiv2);
	
	var tempDiv3 = document.createElement('div');
	tempDiv3.style.fontSize='17pt';
	tempDiv3.innerText='???????????? : ${fp_FreepVo.freep_time}';
	datepickTextDiv.appendChild(tempDiv3);
	
	modalContentsDiv.appendChild(datepickerDiv);
	modalContentsDiv.appendChild(datepickTextDiv);

	$("#datepicker").datepicker({
        dateFormat: 'yy-mm-dd' //?????? ?????? ??????
        ,showMonthAfterYear:true // ??? - ??? ??????????????? ?????? - ??? ??????
        ,showOtherMonths: false //??? ????????? ???????????? ???????????? ????????? ??????
        ,selectOtherMonths: false // ?????? ??? ???????????? ?????? ??????.
        ,changeYear: false //option??? ??? ?????? ??????
        ,changeMonth: false //option??? ??? ?????? ??????                
        ,showOn: "both" //button:????????? ????????????,????????? ???????????? ?????? ?????? ^ both:????????? ????????????,????????? ???????????? input??? ???????????? ?????? ??????  
        ,buttonText: "??????" //?????? ?????? ?????????              
        ,yearSuffix: "???" //????????? ?????? ?????? ??? ?????????
        ,monthNamesShort: ['1???','2???','3???','4???','5???','6???','7???','8???','9???','10???','11???','12???'] //????????? ??? ?????? ?????????
        ,monthNames: ['1???','2???','3???','4???','5???','6???','7???','8???','9???','10???','11???','12???'] //????????? ??? ?????? Tooltip
        ,dayNamesMin: ['???','???','???','???','???','???','???'] //????????? ?????? ?????????
        ,dayNames: ['?????????','?????????','?????????','?????????','?????????','?????????','?????????'] //????????? ?????? Tooltip
        ,minDate: "+1D" //?????? ????????????(-1D:?????????, -1M:?????????, -1Y:?????????)
        ,maxDate: new Date("<fmt:formatDate value='${fp_FreepVo.freep_sale_end_date}' pattern='yyyy-MM-dd' />")  //?????? ????????????(+1D:?????????, -1M:?????????, -1Y:?????????)
		,beforeShowDay: disableSomeDay
    });                  
	
    //????????? ??????
    $('#datepicker').datepicker('setDate', payment_freepJoin_date);

    
    //?????? ????????? ???????????? ??? ????????? ?????????????????????.
    //??????????????? [true]??? ????????????
    //??????????????? [false]??? ???????????????
    function disableSomeDay(date) {
		var month = date.getMonth();
		var dates = date.getDate();
		var year = date.getFullYear();
		
		for(var i=0 ; i<disabledDays.length; i++){
	    	if($.inArray(year+'-'+(month+1)+'-'+dates,disabledDays) != -1){
	    		return [false];
	    	}
	    }		
		return [true];
	}
    
    //?????? ?????????????????? ??????(?????????????????? ?????? ?????? ????????? ?????? ????????????)
    if(payment_freepJoin_date!=0){
    	var dateBeforeFormat=payment_freepJoin_date;
    	var dateAfterFormat=
	    	dateBeforeFormat.split('-')[0]+'??? '+
	    	dateBeforeFormat.split('-')[1]+'??? '+
	    	dateBeforeFormat.split('-')[2]+'???';
    	$('#datepickText').val(dateAfterFormat);
    }
    
    //?????? ????????? ??????????????? ????????? ??????text?????? ?????? ??????
    $("#datepicker").on("change",function(){
    	payment_freepJoin_date=$(this).val();
    	
    	var dateBeforeFormat=payment_freepJoin_date;
    	var dateAfterFormat=
	    	dateBeforeFormat.split('-')[0]+'??? '+
	    	dateBeforeFormat.split('-')[1]+'??? '+
	    	dateBeforeFormat.split('-')[2]+'???';
    	$('#datepickText').val(dateAfterFormat);
    	//$('#datepickText').val($(this).val());
    });
    
}

function tempJoinStep1() {
	if(document.getElementById('paymentMethodRadioBtn1').checked){
		payment_method=document.getElementById('paymentMethodRadioBtn1').value;
	}else if(document.getElementById('paymentMethodRadioBtn2').checked){
		payment_method=document.getElementById('paymentMethodRadioBtn2').value;
	}else if(document.getElementById('paymentMethodRadioBtn3').checked){
		payment_method=document.getElementById('paymentMethodRadioBtn3').value;
	}else if(document.getElementById('paymentMethodRadioBtn4').checked){
		payment_method=document.getElementById('paymentMethodRadioBtn4').value;
	}else if(document.getElementById('paymentMethodRadioBtn5').checked){
		payment_method=document.getElementById('paymentMethodRadioBtn5').value;
	}else if(document.getElementById('paymentMethodRadioBtn6').checked){
		payment_method=document.getElementById('paymentMethodRadioBtn6').value;
	}
	
	joinStep1();
}
function tempJoinStep3() {
	var radioFlag = false;
	
	if(document.getElementById('paymentMethodRadioBtn1').checked){
		radioFlag=true;
		payment_method=document.getElementById('paymentMethodRadioBtn1').value;
	}else if(document.getElementById('paymentMethodRadioBtn2').checked){
		radioFlag=true;
		payment_method=document.getElementById('paymentMethodRadioBtn2').value;
	}else if(document.getElementById('paymentMethodRadioBtn3').checked){
		radioFlag=true;
		payment_method=document.getElementById('paymentMethodRadioBtn3').value;
	}else if(document.getElementById('paymentMethodRadioBtn4').checked){
		radioFlag=true;
		payment_method=document.getElementById('paymentMethodRadioBtn4').value;
	}else if(document.getElementById('paymentMethodRadioBtn5').checked){
		radioFlag=true;
		payment_method=document.getElementById('paymentMethodRadioBtn5').value;
	}else if(document.getElementById('paymentMethodRadioBtn6').checked){
		radioFlag=true;
		payment_method=document.getElementById('paymentMethodRadioBtn6').value;
	}
	
	if(radioFlag == false) {
		swal("?????? ????????? ??????????????????","", "warning");
		return;
	}
	
	joinStep3();
}

function joinStep2() {
	
	if(payment_freepJoin_date == 0){
		swal("?????? ????????? ??????????????????","", "warning");
		return;
	}
	
	getCouponList();//??????????????? ???????????? ajax????????????
	
	
	document.getElementById("icon-step1").style.display="inline";
	document.getElementById("icon-step1-fill").style.display="none";
	document.getElementById("icon-step2").style.display="none";
	document.getElementById("icon-step2-fill").style.display="inline";
	document.getElementById("icon-step3").style.display="inline";
	document.getElementById("icon-step3-fill").style.display="none";
	
	document.getElementById("joinPreBtn").style.display="inline";
	document.getElementById("joinPreBtn").setAttribute('onClick','tempJoinStep1()')
	document.getElementById("joinNextBtn").style.width="55%";
	document.getElementById("joinNextBtn").innerText = '??????';
	document.getElementById("joinNextBtn").setAttribute('onClick','tempJoinStep3()')
	
	
	
	var modalContentsDiv = document.getElementById("modalContentsDiv");
	modalContentsDiv.innerHTML="";
	
	//?????? ???????????? + ???????????? + ??????????????????
	var paymentMethodDiv = document.createElement('div');
	
	
	//?????? ????????????
	var freepInfoDiv =  document.createElement('div');
	freepInfoDiv.style.fontSize = '13pt';
	freepInfoDiv.style.border = '1px solid #cfc1d9';
	freepInfoDiv.style.padding = '5%';
	
	var freepInfoHeaderDiv1 = document.createElement('div');
	
	var freepInfoHeaderDiv1_1 = document.createElement('div');
	freepInfoHeaderDiv1_1.innerText = '???????????? : ${fp_FreepVo.freep_title}';
	freepInfoHeaderDiv1_1.style.fontWeight = 'bold';
	freepInfoHeaderDiv1_1.style.fontSize = '15pt';
	
	var freepInfoHeaderToggleButton = document.createElement('button');
	freepInfoHeaderToggleButton.style.border=0;
	freepInfoHeaderToggleButton.style.backgroundColor='white';
	freepInfoHeaderToggleButton.setAttribute('id','freepInfoHeaderToggleButton');
	freepInfoHeaderToggleButton.style.float='right';

	
	
	var freepInfoHeaderIcon = document.createElement('i');
	freepInfoHeaderIcon.classList.add('bi');
	freepInfoHeaderIcon.classList.add('bi-caret-down');
	freepInfoHeaderIcon.setAttribute('id','freepInfoHeaderIcon');
	freepInfoHeaderToggleButton.appendChild(freepInfoHeaderIcon);
	
	freepInfoHeaderDiv1_1.appendChild(freepInfoHeaderToggleButton);
	
	freepInfoHeaderDiv1.appendChild(freepInfoHeaderDiv1_1);
	
	freepInfoDiv.appendChild(freepInfoHeaderDiv1);
	
	//???????????? ?????????
	var collapseDiv1 = document.createElement('div');
	collapseDiv1.setAttribute('id','collapseDiv1');
	collapseDiv1.classList.add('collapseDiv1');
	collapseDiv1.classList.add('collapseUp');
	
	var hr1 = document.createElement('hr');
	hr1.style.height='2px';
	hr1.style.backgroundColor='#cfc1d9';
	collapseDiv1.appendChild(hr1);
	
	var freepInfoTitleDiv = document.createElement('div');
	freepInfoTitleDiv.innerText = '${fp_FreepVo.freep_title}';
	freepInfoTitleDiv.style.fontSize = '16pt';
	freepInfoTitleDiv.style.marginTop = '5%';
	collapseDiv1.appendChild(freepInfoTitleDiv);
	
	var tempRowDiv1 = document.createElement('div');
	tempRowDiv1.style.marginTop = '2%';

	var tempColDiv1 = document.createElement('div');
	tempColDiv1.style.width='60%';
	tempColDiv1.style.display='inline-block';
	
	var tempDiv1 = document.createElement('div');
	tempDiv1.innerText = '???????????? : ${fp_FreepVo.freep_onoff}';
	tempColDiv1.appendChild(tempDiv1);
	
	var dateAfterFormat=
		payment_freepJoin_date.split('-')[0]+'??? '+
		payment_freepJoin_date.split('-')[1]+'??? '+
		payment_freepJoin_date.split('-')[2]+'???';
	
	var tempDiv2 = document.createElement('div');
	tempDiv2.innerText = '???????????? : '+dateAfterFormat+' ${fp_FreepVo.freep_time}';
	tempColDiv1.appendChild(tempDiv2);
	
	var tempColDiv2 = document.createElement('div');
	tempColDiv2.style.width='40%';
	tempColDiv2.style.display='inline-block';
	
	var tempDiv3 = document.createElement('div');
	tempDiv3.innerText = '???????????? : 1??? / ?????? 1???';
	tempColDiv2.appendChild(tempDiv3);
	
	var tempDiv4 = document.createElement('div');
	tempDiv4.innerText = '???????????? : ${priceStringFormat}???';
	tempColDiv2.appendChild(tempDiv4);
	
	tempRowDiv1.appendChild(tempColDiv1);
	tempRowDiv1.appendChild(tempColDiv2);
	
	collapseDiv1.appendChild(tempRowDiv1);
	freepInfoDiv.appendChild(collapseDiv1);
	paymentMethodDiv.appendChild(freepInfoDiv);
	
	
	//????????????
	var couponDiv = document.createElement('div');
	couponDiv.style.marginTop = '2%';
	couponDiv.style.fontSize = '13pt';
	couponDiv.style.border = '1px solid #cfc1d9';
	couponDiv.style.padding = '5%';
	
	var couponHeaderDiv = document.createElement('div');
	
	var couponHeaderDiv1_1 = document.createElement('div');
	couponHeaderDiv1_1.style.fontSize = '15pt';
	couponHeaderDiv1_1.style.fontWeight = 'bold';
	couponHeaderDiv1_1.innerText = '???????????? : ';
	
	var couponInfoSpan0 = document.createElement('span');
	couponInfoSpan0.setAttribute('id','couponInfoSpan0');
	
	if(coupon_no>0){
		couponInfoSpan0.innerHTML='';
		
		var xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function(){
			if(xhr.readyState  == 4 && xhr.status == 200){
				var jsonObj = JSON.parse(xhr.responseText);
				
				couponInfoSpan0.innerText=jsonObj.fp_MemberCouponVo.coupon_expiration;
			
				var couponPriceSpan2 = document.createElement('span');
				couponPriceSpan2.innerText='-'+jsonObj.couponPriceStringFormat+"???";
				couponPriceSpan2.style.marginLeft='5%';
				couponInfoSpan0.appendChild(couponPriceSpan2);
				
				var couponSelectCancelBtn = document.createElement('button');
				couponSelectCancelBtn.style.marginLeft='1%';
				couponSelectCancelBtn.style.border=0;
				couponSelectCancelBtn.style.fontSize='11pt';
				couponSelectCancelBtn.style.fontWeight='normal';
				couponSelectCancelBtn.style.color='#615d63';
				couponSelectCancelBtn.style.backgroundColor='#faedf0';
				couponSelectCancelBtn.innerText='????????????';
				couponSelectCancelBtn.setAttribute('onclick','couponSelectCancel()');
				
				couponInfoSpan0.appendChild(couponSelectCancelBtn);
				
			}
		};	
		xhr.open("get","./getOneCoupon?coupon_no="+coupon_no);
		xhr.send();
	}else{
		coupon_no=0;
		
		var couponInfoSpan1 = document.createElement('span');
		couponInfoSpan1.innerText = '???????????? ?????? '
		couponInfoSpan0.appendChild(couponInfoSpan1);
		
		var xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function(){
			if(xhr.readyState  == 4 && xhr.status == 200){
				var jsonObj = JSON.parse(xhr.responseText);
				
				var couponListSize = jsonObj.couponListSize;
				var couponInfoSpan2 = document.createElement('span');
				couponInfoSpan2.innerText = couponListSize+'???';
				couponInfoSpan2.style.color='#8719b3';
				couponInfoSpan0.appendChild(couponInfoSpan2);
			}
		};
		xhr.open("get","./getCouponList");
		xhr.send();	
	}
	
	couponHeaderDiv1_1.appendChild(couponInfoSpan0);	

	var couponHeaderToggleButton = document.createElement('button');
	couponHeaderToggleButton.style.border=0;
	couponHeaderToggleButton.style.backgroundColor='white';
	couponHeaderToggleButton.setAttribute('id','couponHeaderToggleButton');
	couponHeaderToggleButton.style.float='right';
	
	var couponHeaderIcon = document.createElement('i');
	couponHeaderIcon.classList.add('bi');
	couponHeaderIcon.classList.add('bi-caret-down');
	couponHeaderIcon.setAttribute('id','couponHeaderIcon');
	couponHeaderToggleButton.appendChild(couponHeaderIcon);
	
	couponHeaderDiv1_1.appendChild(couponHeaderToggleButton);
	couponHeaderDiv.appendChild(couponHeaderDiv1_1);
	couponDiv.appendChild(couponHeaderDiv);

	//?????? ?????????
	var collapseDiv2 = document.createElement('div');
	collapseDiv2.setAttribute('id','collapseDiv2');
	collapseDiv2.classList.add('collapseDiv2');
	collapseDiv2.classList.add('collapseUp');
			
	var couponHr2 = document.createElement('hr');
	couponHr2.style.height='2px';
	couponHr2.style.backgroundColor='#cfc1d9';
	collapseDiv2.appendChild(couponHr2);
	
	function getCouponList() {
		var xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function(){
			if(xhr.readyState  == 4 && xhr.status == 200){
				var jsonObj = JSON.parse(xhr.responseText);
				
				if(jsonObj.couponListSize==0){//????????? ?????????
					var noCouponDiv = document.createElement('div');
					noCouponDiv.innerText="??????????????? ????????? ????????????.";
					collapseDiv2.appendChild(noCouponDiv);
				}else{//?????? ?????????
					var couponList = jsonObj.couponList;
					
					var existCouponListDiv = document.createElement('div');
					
					for(var map of couponList){
						var couponDiv1 = document.createElement('div');
						couponDiv1.style.cursor='pointer';
						couponDiv1.setAttribute('id','couponDiv1');
						couponDiv1.setAttribute('onclick','applyCoupon(this)');
						couponDiv1.style.margin='2%';
						
						var couponHiddenDiv = document.createElement('div');
						couponHiddenDiv.style.display='none';
						couponHiddenDiv.innerText=map.fp_MemberCouponVo.coupon_no;
						couponDiv1.appendChild(couponHiddenDiv);
						
						var couponExpirationDiv = document.createElement('div');
						couponExpirationDiv.innerText = map.fp_MemberCouponVo.coupon_expiration;
						couponExpirationDiv.style.width='60%';
						couponExpirationDiv.style.display='inline-block';
						couponDiv1.appendChild(couponExpirationDiv);
						
						var couponPriceDiv = document.createElement('div');
						couponPriceDiv.innerText = "-"+map.couponPriceStringFormat+"???";
						couponPriceDiv.style.width='20%';
						couponPriceDiv.style.display='inline-block';
						couponPriceDiv.style.float='right';
						couponDiv1.appendChild(couponPriceDiv);
						
						existCouponListDiv.appendChild(couponDiv1);
					}
										
					collapseDiv2.appendChild(existCouponListDiv);
					
				}
				
			}
		};	
		xhr.open("get","./getCouponList");
		xhr.send();
	}
	
	couponDiv.appendChild(collapseDiv2);
	
	paymentMethodDiv.appendChild(couponDiv);
	
	
	var showPaymentDiv = document.createElement('div');
	showPaymentDiv.style.marginBottom='2%';
	showPaymentDiv.style.marginLeft='2%';
	showPaymentDiv.style.marginRight='2%';
	showPaymentDiv.style.marginTop='4%';
	showPaymentDiv.style.fontSize='13pt';
	
	
	var showPaymentTitleDiv = document.createElement('div');
	showPaymentTitleDiv.innerText='????????????';
	showPaymentTitleDiv.style.fontSize='15pt';
	showPaymentTitleDiv.style.fontWeight='bold';
	showPaymentDiv.appendChild(showPaymentTitleDiv);
	
	var showPaymentFreepDiv = document.createElement('div');
	showPaymentFreepDiv.style.marginTop='8%';
	showPaymentFreepDiv.style.marginLeft='15%';
	showPaymentFreepDiv.style.marginRight='20%';
	
	var showPaymentFreepInfoSpan = document.createElement('span');
	showPaymentFreepInfoSpan.innerText='1???/?????? 1??? ????????????';
	showPaymentFreepDiv.appendChild(showPaymentFreepInfoSpan);
	
	var showPaymentFreepPriceSpan = document.createElement('span');
	showPaymentFreepPriceSpan.innerText='${priceStringFormat}???';
	showPaymentFreepPriceSpan.setAttribute('id','showPaymentFreepPriceSpan');
	showPaymentFreepPriceSpan.style.float='right';
	showPaymentFreepDiv.appendChild(showPaymentFreepPriceSpan);
	
	showPaymentDiv.appendChild(showPaymentFreepDiv);
	
	var showPaymentCoupon = document.createElement('div');
	showPaymentCoupon.style.marginTop='1%';
	showPaymentCoupon.style.marginLeft='15%';
	showPaymentCoupon.style.marginRight='20%';
	
	var showPaymentCouponInfoSpan = document.createElement('span');
	showPaymentCouponInfoSpan.innerText = '????????????';
	
	showPaymentCouponInfoSpan.setAttribute('id','showPaymentCouponInfoSpan');
	showPaymentCoupon.appendChild(showPaymentCouponInfoSpan);
	
	var showPaymentCouponPriceSpan = document.createElement('span');
	showPaymentCouponPriceSpan.innerText = '-';
		
	showPaymentCouponPriceSpan.style.float = 'right';
	showPaymentCouponPriceSpan.setAttribute('id','showPaymentCouponPriceSpan');
	showPaymentCoupon.appendChild(showPaymentCouponPriceSpan);
	
	showPaymentDiv.appendChild(showPaymentCoupon);
	
	var paymentMethodHr1 = document.createElement('hr');
	paymentMethodHr1.style.backgroundColor='#828282';
	paymentMethodHr1.style.margin='auto';
	paymentMethodHr1.style.marginTop='5%';
	paymentMethodHr1.style.width='80%';
	paymentMethodHr1.style.height='1px';
	showPaymentDiv.appendChild(paymentMethodHr1);
	
	var showPaymentResult = document.createElement('div');
	showPaymentResult.style.marginTop='1%';
	showPaymentResult.style.marginLeft='15%';
	showPaymentResult.style.marginRight='20%';
	
	var showPaymentResultInfoSpan = document.createElement('span');
	showPaymentResultInfoSpan.innerText = '??? ?????? ??????';
	showPaymentResult.appendChild(showPaymentResultInfoSpan);
	
	var showPaymentResultPriceSpan = document.createElement('span');
	showPaymentResultPriceSpan.innerText = showPaymentFreepPriceSpan.innerText;

	showPaymentResultPriceSpan.style.float = 'right';
	showPaymentResultPriceSpan.setAttribute('id','showPaymentResultPriceSpan');
	showPaymentResultPriceSpan.style.fontWeight='bold';
	showPaymentResult.appendChild(showPaymentResultPriceSpan);
	
	showPaymentDiv.appendChild(showPaymentResult);
	paymentMethodDiv.appendChild(showPaymentDiv);
	
	var paymentMethodHr2 = document.createElement('hr');
	paymentMethodHr2.style.backgroundColor='#cfc1d9';
	paymentMethodHr2.style.height='4px';
	paymentMethodHr2.style.marginTop='10%';
	paymentMethodDiv.appendChild(paymentMethodHr2);
	
	//???????????? ??????
	var paymentMethodInnerDiv = document.createElement('div');
	paymentMethodInnerDiv.style.margin='2%';
	paymentMethodInnerDiv.style.paddingBottom='15%';
	
	var paymentMethodHeaderDiv = document.createElement('div');
	paymentMethodHeaderDiv.innerText = '????????????';
	paymentMethodHeaderDiv.style.fontSize='15pt';
	paymentMethodHeaderDiv.style.fontWeight='bold';
	paymentMethodInnerDiv.appendChild(paymentMethodHeaderDiv);
	
	var paymentMethodRealDiv = document.createElement('div');
	paymentMethodRealDiv.style.fontSize='13pt';
	paymentMethodRealDiv.style.fontWeight='';
	paymentMethodRealDiv.style.marginTop='2%';
	
	
	var paymentMethodBigSpan1=document.createElement('span');
	paymentMethodBigSpan1.style.width='33.33%';
	paymentMethodBigSpan1.style.display='inline-block';
	
	var radioBtn1 = document.createElement('input');
	radioBtn1.type='radio';
	radioBtn1.name='payment_method';
	radioBtn1.value='??????/????????????';
	radioBtn1.style.width='17px';
	radioBtn1.style.height='17px';
	radioBtn1.setAttribute('id','paymentMethodRadioBtn1');
	paymentMethodBigSpan1.appendChild(radioBtn1);
	
	var paymentMethodSpan1 = document.createElement('span');
	paymentMethodSpan1.innerText='??????/????????????';
	paymentMethodBigSpan1.appendChild(paymentMethodSpan1);
	
	paymentMethodRealDiv.appendChild(paymentMethodBigSpan1);
	
	var paymentMethodBigSpan2=document.createElement('span');
	paymentMethodBigSpan2.style.width='33.33%';
	paymentMethodBigSpan2.style.display='inline-block';
	
	var radioBtn2 = document.createElement('input');
	radioBtn2.type='radio';
	radioBtn2.name='payment_method';
	radioBtn2.value='?????????????????????';
	radioBtn2.style.width='17px';
	radioBtn2.style.height='17px';
	radioBtn2.setAttribute('id','paymentMethodRadioBtn2');
	paymentMethodBigSpan2.appendChild(radioBtn2);
	
	var paymentMethodSpan2 = document.createElement('span');
	paymentMethodSpan2.innerText='?????????????????????';
	paymentMethodBigSpan2.appendChild(paymentMethodSpan2);
	
	paymentMethodRealDiv.appendChild(paymentMethodBigSpan2);
	
	var paymentMethodBigSpan3=document.createElement('span');
	paymentMethodBigSpan3.style.width='33.33%';
	paymentMethodBigSpan3.style.display='inline-block';
	
	var radioBtn3 = document.createElement('input');
	radioBtn3.type='radio';
	radioBtn3.name='payment_method';
	radioBtn3.value='???????????????';
	radioBtn3.style.width='17px';
	radioBtn3.style.height='17px';
	radioBtn3.setAttribute('id','paymentMethodRadioBtn3');
	paymentMethodBigSpan3.appendChild(radioBtn3);
	
	var paymentMethodSpan3 = document.createElement('span');
	paymentMethodSpan3.innerText='???????????????';
	paymentMethodBigSpan3.appendChild(paymentMethodSpan3);
	
	paymentMethodRealDiv.appendChild(paymentMethodBigSpan3);
	
	var paymentMethodBigSpan4=document.createElement('span');
	paymentMethodBigSpan4.style.width='33.33%';
	paymentMethodBigSpan4.style.display='inline-block';
	
	var radioBtn4 = document.createElement('input');
	radioBtn4.type='radio';
	radioBtn4.name='payment_method';
	radioBtn4.value='???????????????';
	radioBtn4.style.width='17px';
	radioBtn4.style.height='17px';
	radioBtn4.setAttribute('id','paymentMethodRadioBtn4');
	paymentMethodBigSpan4.appendChild(radioBtn4);
	
	var paymentMethodSpan4 = document.createElement('span');
	paymentMethodSpan4.innerText='???????????????';
	paymentMethodBigSpan4.appendChild(paymentMethodSpan4);
	
	paymentMethodRealDiv.appendChild(paymentMethodBigSpan4);
	
	var paymentMethodBigSpan5=document.createElement('span');
	paymentMethodBigSpan5.style.width='33.33%';
	paymentMethodBigSpan5.style.display='inline-block';
	
	var radioBtn5 = document.createElement('input');
	radioBtn5.type='radio';
	radioBtn5.name='payment_method';
	radioBtn5.value='??????';
	radioBtn5.style.width='17px';
	radioBtn5.style.height='17px';
	radioBtn5.setAttribute('id','paymentMethodRadioBtn5');
	paymentMethodBigSpan5.appendChild(radioBtn5);
	
	var paymentMethodSpan5 = document.createElement('span');
	paymentMethodSpan5.innerText='??????';
	paymentMethodBigSpan5.appendChild(paymentMethodSpan5);
	
	paymentMethodRealDiv.appendChild(paymentMethodBigSpan5);

	var paymentMethodBigSpan6=document.createElement('span');
	paymentMethodBigSpan6.style.width='33.33%';
	paymentMethodBigSpan6.style.display='inline-block';
	
	var radioBtn6 = document.createElement('input');
	radioBtn6.type='radio';
	radioBtn6.name='payment_method';
	radioBtn6.value='???????????????';
	radioBtn6.style.width='17px';
	radioBtn6.style.height='17px';
	radioBtn6.setAttribute('id','paymentMethodRadioBtn6');
	paymentMethodBigSpan6.appendChild(radioBtn6);
	
	var paymentMethodSpan6 = document.createElement('span');
	paymentMethodSpan6.innerText='???????????????';
	paymentMethodBigSpan6.appendChild(paymentMethodSpan6);
	
	paymentMethodRealDiv.appendChild(paymentMethodBigSpan6);
	
	paymentMethodInnerDiv.appendChild(paymentMethodRealDiv);
	
	paymentMethodDiv.appendChild(paymentMethodInnerDiv);
	
	
	
	modalContentsDiv.appendChild(paymentMethodDiv);
	
	var radioBtnArray = document.getElementsByName('payment_method');
	
	for(var i=0;i<radioBtnArray.length;i++){
		if(radioBtnArray[i].value==payment_method){
			radioBtnArray[i].checked=true;
		}
	}
	
	
	//???????????? ?????? ??????
	document.getElementById("freepInfoHeaderToggleButton").addEventListener("click",function (){
		document.getElementById('collapseDiv1').classList.toggle('collapseUp');//????????? ????????????
		document.getElementById('freepInfoHeaderIcon').classList.toggle('bi-caret-up');//????????? ?????? ???????????????
	});
	
	//???????????? ?????? ??????
	document.getElementById("couponHeaderToggleButton").addEventListener("click",function (){
		document.getElementById('collapseDiv2').classList.toggle('collapseUp');//????????? ????????????
		document.getElementById('couponHeaderIcon').classList.toggle('bi-caret-up');//????????? ?????? ???????????????
	});
	
	if(coupon_no!=0) selectCouponExist();
	
}

function joinStep3() {

	
	document.getElementById("icon-step1").style.display="inline";
	document.getElementById("icon-step1-fill").style.display="none";
	document.getElementById("icon-step2").style.display="inline";
	document.getElementById("icon-step2-fill").style.display="none";
	document.getElementById("icon-step3").style.display="none";
	document.getElementById("icon-step3-fill").style.display="inline";
	
	document.getElementById("joinPreBtn").style.display="inline";
	document.getElementById("joinPreBtn").setAttribute('onClick','joinStep2()')
	document.getElementById("joinNextBtn").style.width="55%";
	document.getElementById("joinNextBtn").innerText = '????????????';
	document.getElementById("joinNextBtn").setAttribute('onClick','goMyReservedFreepPage()')

	var modalContentsDiv = document.getElementById("modalContentsDiv");
	modalContentsDiv.innerHTML='';
	
	var finalCheckDiv = document.createElement('div');
	finalCheckDiv.style.margin='2%';
	finalCheckDiv.style.marginTop='0';
	finalCheckDiv.style.fontSize='13pt';
	
	var finalCheckHeader = document.createElement('div');
	finalCheckHeader.innerText = '??????????????????';
	finalCheckHeader.style.fontSize='15pt';
	finalCheckHeader.style.fontWeight='bold';
	finalCheckHeader.style.marginLeft='2%';
	finalCheckDiv.appendChild(finalCheckHeader);
	
	var finalCheckHr1 = document.createElement('hr');
	finalCheckHr1.style.backgroundColor='#cfc1d9';
	finalCheckHr1.style.height='4px';
	finalCheckDiv.appendChild(finalCheckHr1);
	
	var finalCheckFreepInfoDiv = document.createElement('div');
	finalCheckFreepInfoDiv.style.marginLeft='5%';
	finalCheckFreepInfoDiv.style.marginRight='5%';
	
	
	var finalCheckFreepInfoHeaderDiv = document.createElement('div');
	finalCheckFreepInfoHeaderDiv.style.fontWeight='bold';
	finalCheckFreepInfoHeaderDiv.style.marginTop='5%';
	finalCheckFreepInfoHeaderDiv.style.marginBottom='2%';
	finalCheckFreepInfoHeaderDiv.style.marginLeft='2%';
	finalCheckFreepInfoDiv.appendChild(finalCheckFreepInfoHeaderDiv);
	
	var finalCheckFreepTitleDiv = document.createElement('div');
	finalCheckFreepTitleDiv.innerText = '????????? : ';
	
	var finalCheckFreepTitleInnerSpan = document.createElement('span');
	finalCheckFreepTitleInnerSpan.innerText = '${fp_FreepVo.freep_title}';
	finalCheckFreepTitleDiv.appendChild(finalCheckFreepTitleInnerSpan);
	finalCheckFreepInfoDiv.appendChild(finalCheckFreepTitleDiv);
	
	var finalCheckFreepDateDiv = document.createElement('div');
	finalCheckFreepDateDiv.innerText = '???????????? : ';
	
	var dateBeforeFormat=payment_freepJoin_date;
	var dateAfterFormat=											
    	dateBeforeFormat.split('-')[0]+'??? '+
    	dateBeforeFormat.split('-')[1]+'??? '+
    	dateBeforeFormat.split('-')[2]+'???';
	
	var finalCheckFreepDateInnerSpan = document.createElement('span');
	finalCheckFreepDateInnerSpan.innerText = dateAfterFormat+' ${fp_FreepVo.freep_time}';
	finalCheckFreepDateDiv.appendChild(finalCheckFreepDateInnerSpan);
	
	finalCheckFreepInfoDiv.appendChild(finalCheckFreepDateDiv);
	
	var finalCheckFreepOnOffDiv = document.createElement('div');
	finalCheckFreepOnOffDiv.innerText = '???????????? : ';
	
	var finalCheckFreepOnOffInnerSpan = document.createElement('span');
	finalCheckFreepOnOffInnerSpan.innerText = '${fp_FreepVo.freep_onoff}';
	finalCheckFreepOnOffDiv.appendChild(finalCheckFreepOnOffInnerSpan);
	
	finalCheckFreepInfoDiv.appendChild(finalCheckFreepOnOffDiv);
	
	var finalCheckFreepOptionDiv = document.createElement('div');
	finalCheckFreepOptionDiv.innerText = '???????????? : 1??? / ?????? 1???';
	finalCheckFreepInfoDiv.appendChild(finalCheckFreepOptionDiv);
	
	var finalCheckPayMethodDiv = document.createElement('div');
	finalCheckPayMethodDiv.innerText = '???????????? : '+payment_method;
	finalCheckFreepInfoDiv.appendChild(finalCheckPayMethodDiv);
	
	finalCheckDiv.appendChild(finalCheckFreepInfoDiv);
	
	var finalCheckHr2 = document.createElement('hr');
	finalCheckHr2.style.backgroundColor='#cfc1d9';
	finalCheckHr2.style.height='4px';
	finalCheckDiv.appendChild(finalCheckHr2);
	
	
	
	var showPaymentDiv = document.createElement('div');
	showPaymentDiv.style.marginBottom='2%';
	showPaymentDiv.style.marginLeft='2%';
	showPaymentDiv.style.marginRight='2%';
	showPaymentDiv.style.marginTop='4%';
	showPaymentDiv.style.fontSize='13pt';
	
	
	var showPaymentTitleDiv = document.createElement('div');
	showPaymentTitleDiv.innerText='????????????';
	showPaymentTitleDiv.style.fontSize='15pt';
	showPaymentTitleDiv.style.fontWeight='bold';
	showPaymentDiv.appendChild(showPaymentTitleDiv);
	
	var showPaymentFreepDiv = document.createElement('div');
	showPaymentFreepDiv.style.marginTop='5%';
	showPaymentFreepDiv.style.marginLeft='15%';
	showPaymentFreepDiv.style.marginRight='20%';
	
	var showPaymentFreepInfoSpan = document.createElement('span');
	showPaymentFreepInfoSpan.innerText='1???/?????? 1??? ????????????';
	showPaymentFreepDiv.appendChild(showPaymentFreepInfoSpan);
	
	var showPaymentFreepPriceSpan = document.createElement('span');
	showPaymentFreepPriceSpan.innerText='${priceStringFormat}???';
	showPaymentFreepPriceSpan.setAttribute('id','showPaymentFreepPriceSpan');
	showPaymentFreepPriceSpan.style.float='right';
	showPaymentFreepDiv.appendChild(showPaymentFreepPriceSpan);
	
	showPaymentDiv.appendChild(showPaymentFreepDiv);
	
	var showPaymentCoupon = document.createElement('div');
	showPaymentCoupon.style.marginTop='1%';
	showPaymentCoupon.style.marginLeft='15%';
	showPaymentCoupon.style.marginRight='20%';
	
	var showPaymentCouponInfoSpan = document.createElement('span');
	showPaymentCouponInfoSpan.innerText = '????????????';
	
	showPaymentCouponInfoSpan.setAttribute('id','showPaymentCouponInfoSpan');
	showPaymentCoupon.appendChild(showPaymentCouponInfoSpan);
	
	var showPaymentCouponPriceSpan = document.createElement('span');
	showPaymentCouponPriceSpan.innerText = '-';
		
	showPaymentCouponPriceSpan.style.float = 'right';
	showPaymentCouponPriceSpan.setAttribute('id','showPaymentCouponPriceSpan');
	showPaymentCoupon.appendChild(showPaymentCouponPriceSpan);
	
	showPaymentDiv.appendChild(showPaymentCoupon);
	
	var paymentMethodHr1 = document.createElement('hr');
	paymentMethodHr1.style.backgroundColor='#828282';
	paymentMethodHr1.style.margin='auto';
	paymentMethodHr1.style.marginTop='5%';
	paymentMethodHr1.style.width='80%';
	paymentMethodHr1.style.height='1px';
	showPaymentDiv.appendChild(paymentMethodHr1);
	
	var showPaymentResult = document.createElement('div');
	showPaymentResult.style.marginTop='1%';
	showPaymentResult.style.marginLeft='15%';
	showPaymentResult.style.marginRight='20%';
	
	var showPaymentResultInfoSpan = document.createElement('span');
	showPaymentResultInfoSpan.innerText = '??? ?????? ??????';
	showPaymentResult.appendChild(showPaymentResultInfoSpan);
	
	var showPaymentResultPriceSpan = document.createElement('span');
	showPaymentResultPriceSpan.innerText = showPaymentFreepPriceSpan.innerText;

	showPaymentResultPriceSpan.style.float = 'right';
	showPaymentResultPriceSpan.setAttribute('id','showPaymentResultPriceSpan');
	showPaymentResultPriceSpan.style.fontWeight='bold';
	showPaymentResult.appendChild(showPaymentResultPriceSpan);
	
	showPaymentDiv.appendChild(showPaymentResult);
	finalCheckDiv.appendChild(showPaymentDiv);
	
	
	modalContentsDiv.appendChild(finalCheckDiv);
	
	if(coupon_no!=0) selectCouponExist();

}

function goMyReservedFreepPage() {
	location.href="../freep/reserveFreepProcess"
			+"?payment_freepJoin_date="+payment_freepJoin_date
			+"&coupon_no="+coupon_no
			+"&payment_method="+payment_method
			+"&freep_no=${fp_FreepVo.freep_no}";
}

window.addEventListener("DOMContentLoaded",function(){
	getReservationDates();
	document.getElementById("joinWindow-backgroud").addEventListener("click",joinWindowClose);

});
</script>

</head>
<body>

<div id="joinWindow-backgroud" style="visibility: hidden;"></div>	
<div id="joinWindow-joinWindowShow" style="visibility: hidden; color: #300057">
	<div style="width: 100%; height: 100%; padding: 2%; font-size: 20pt">		
		<div class="row" style="height:10%; padding-top:2%; padding-left:3%; padding-right:3%; border-bottom: 1px solid black;">
			<div class="col">
				<span style="font-weight: bold">????????????</span>
				<i class="bi bi-x-lg fs-4" style="cursor: pointer; float: right;" onclick="joinWindowClose()"></i>
			</div>
		</div>
		<div class="row" style="height:10%">
			<div class="col" style="color: #8851db; font-size: 25pt; width: auto">
				<div class="row" style="padding-top: 1%">
					<div class="col"></div>
					<div class="col-1 text-center" style="width: auto;">
						<i class="bi bi-1-square" id="icon-step1" style="display: none"></i>
						<i class="bi bi-1-square-fill" id="icon-step1-fill" style="display: none;"></i>
						<div style="font-size: 10pt">????????????</div>
					</div>
					<div class="col-2">
						<hr style="height: 1px; background-color: #8851db; margin-top: 20%">
					</div>
					<div class="col-1 text-center" style="width: auto;">
						<i class="bi bi-2-square" id="icon-step2" style="display: none;"></i>
						<i class="bi bi-2-square-fill" id="icon-step2-fill" style="display: none;"></i>
						<div style="font-size: 10pt">????????????</div>
					</div>
					<div class="col-2">
						<hr style="height: 1px; background-color: #8851db; margin-top: 20%">
					</div>
					<div class="col-1 text-center" style="width: auto;">
						<i class="bi bi-3-square" id="icon-step3" style="display: none;"></i>
						<i class="bi bi-3-square-fill" id="icon-step3-fill" style="display: none;"></i>
						<div style="font-size: 10pt">????????????</div>
					</div>
					<div class="col"></div>
				</div>
			</div>
		</div>
		<div class="row" style="height:69%; padding-top:2%; padding-left:3%; padding-right:3%; overflow-y: scroll auto; overflow-x: hidden;">
			<div class="col" id="modalContentsDiv">			
				<!-- ?????? ??????. ?????? ????????????. ???????????????????????? ?????????. ???????????? ??????????????? -->
			</div>
		</div>
		
		
		<div class="row" style="height: 13%">
			<div class="col text-center" style="padding-top:2%;">
				<button style="width: 15%;height: 70%; font-size: 17pt; background-color: #8851db; color: white" class="btn" onclick="joinWindowClose()">??????</button>
				<button style="width: 15%;height: 70%; font-size: 17pt; background-color: #8851db; color: white; display: none;" class="btn" id="joinPreBtn">??????</button>
				<button style="width: 70%;height: 70%; font-size: 17pt; background-color: #8851db; color: white" class="btn" id="joinNextBtn">??????</button>
			</div>
		</div>

	</div>
</div>


</body>

