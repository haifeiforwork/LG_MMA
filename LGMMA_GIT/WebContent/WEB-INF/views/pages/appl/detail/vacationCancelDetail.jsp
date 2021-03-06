<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<form id="detailForm">
	<!--// Table start -->
	<div class="tableArea">
		<h2 class="subtitle">휴가신청</h2>
	<div class="table">
		<table class="tableGeneral">
		<caption>휴가신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_85p"/>
		</colgroup>
		<tbody>
		<tr>
			<th>신청일</th>
			<td name="BEGDA"></td>
		</tr>
		<tr id="cancelVocaType" style="display:none;">
			<th>휴가유형</th>
			<td name="cancelVocaTypeTxt"></td>
		</tr>
		<tr>
			<th>휴가구분</th>
			<td name="AWART" format="replace" code="AWART" codeNm="ATEXT"></td>
		</tr>
		<tr>
			<th>신청사유</th>
			<td><span id="c_ovtm_code"></span><span name="REASON"></span></td>
		</tr>
		<tr>
			<th>대근자</th>
			<td name="OVTM_NAME"></td>
		</tr>
		<tr>
			<th>잔여휴가일수</th>
			<td id="cancelRemainTxt"></td>
		</tr>
		<tr>
			<th>휴가기간</th>
			<td><span name="APPL_FROM"></span> ~ <span name="APPL_TO"></span></td>
		</tr>
		<tr>
			<th>신청시간</th>
			<td><span name="BEGUZ" format="time"></span> ~ <span name="ENDUZ" format="time"></span></td>
		</tr>
		<tr>
			<th>휴가공제일수</th>
			<td><span name="DEDUCT_DATE" format="currency"></span> 일</td>
		</tr>
		</tbody>
		</table>
	</div>
	</div>
	<!--// Table start -->	
	<div class="tableArea" id="cancelDiv">
		<h2 class="subtitle">취소신청사유</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>취소신청사유</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_85p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="inputText01-1">취소 신청일</label></th>
				<td id="CBEGDA">
				</td>
			</tr>
			<tr>
				<th>취소사유</th>
				<td id="CREASON">
				</td>
			</tr>
			</tbody>
			</table>

		</div>
	</div>
	
</form>

<script type="text/javascript">

	$(document).ready(function(){
		$.ajax({
			type : "get",
			url : "/appl/getVacationCancelDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				var eAuth = response.eAuth
					, iMode = response.iMode
					, vacationData = response.storeData[0]
					, remainData = response.d03RemainVocationData;
				var arr = $.makeArray({"AWART":response.code_vt});
				
				if(eAuth == 'Y') {
					var vocaTypeTxt = (vacationData.AWART == '0111' || vacationData.AWART == '0112' || vacationData.AWART == '0113') ? '보상휴가' : '휴가(연차,경조,공가 등)';
					$('[name=cancelVocaTypeTxt]').text(vocaTypeTxt);
					$('#cancelVocaType').show();
					
					var E_REMAIN = remainData.E_REMAIN == 0 ? 0 : parseFloat(remainData.E_REMAIN).toFixed(2);
					var VACATION = remainData.VACATION == 0 ? 0 : parseFloat(remainData.VACATION).toFixed(1);
					if(iMode == 'A') {
						$('#cancelRemainTxt').text(E_REMAIN + "/" + VACATION + " 일");
					} else {
						$('#cancelRemainTxt').text(E_REMAIN + "일" + remainData.ZKVRBTX);
					}
				} else {
					var P_REMAIN = remainData.P_REMAIN == 0 ? 0 : parseFloat(remainData.P_REMAIN).toFixed(2);
					var P_VACATION = remainData.P_VACATION == 0 ? 0 : parseFloat(remainData.P_VACATION).toFixed(1);
					$('#cancelRemainTxt').text(P_REMAIN + "/" + P_VACATION + " 일");
				}
				
				setTableText(response.storeData, "detailForm", arr);
				//setTableText(response.d03RemainVocationData, "detailForm");
				
				$("#CBEGDA").text(response.cancelData[0].BEGDA);
				$("#CREASON").text(response.cancelData[0].CREASON);
				
				if(response.storeData.AWART == "0130"){// 경조공가
					if(response.storeData.CONG_CODE!=""){
						var codeList = getCongCode();
						$.each(codeList, function(i, codes){
							if(codes.code == response.storeData.OVTM_CODE) {
								$("#c_ovtm_code").html(codes.value);
								return false;
							}
						});
					}
				} else if(response.storeData.AWART == "0170" || response.storeData.AWART == "0180"){// 전일공가 시간공가
					if(response.storeData.OVTM_CODE!=""){
						var codeList = getEduWorkCode(response.storeData.AWART);
						$.each(codeList, function(i, codes){
							if(codes.SCODE == response.storeData.OVTM_CODE) {
								$("#c_ovtm_code").html(codes.STEXT);
								return false;
							}
						});
					}
				}
			}else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
	});
	
	var getEduWorkCode = function(AWART) {
	 	jQuery.ajax({
	 		type : 'POST',
	 		url : '/work/getEduWorkCode.json',
	 		cache : false,
	 		dataType : 'json',
	 		data : {
    		    "AWART" : AWART,
	 		    "PERNR" : $("#PERNR").val()
				},
	 		async :false,
	 		success : function(response) {
	 			if(response.success){
	 				return response.storeData;
	 				
	 			}else{
	 				alert("신청사유코드 조회시 오류가 발생하였습니다. " + response.message);
	 			}
	 		}
	 	});
	 };
	 
	 var getCongCode = function(AWART) {
	 	jQuery.ajax({
	 		type : 'POST',
	 		url : '/work/getCongCode.json',
	 		cache : false,
	 		dataType : 'json',
	 		async :false,
	 		success : function(response) {
	 			if(response.success){
	 				return response.storeData;
	 				
	 			}else{
	 				alert("신청사유코드 조회시 오류가 발생하였습니다. " + response.message);
	 			}
	 		}
	 	});
	 };
	 
    //삭제
	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			param.push({name:"AINF_SEQN", value:'<c:out value="${AINF_SEQN}"/>'});
			param.push({name:"UPMU_TYPE", value:'<c:out value="${UPMU_TYPE}"/>'});
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteCancelWork',
				cache : false,
				dataType : 'json',
				data : param,
				async : false,
				success : function(response) {
					if (response.success) {
						alert("삭제 되었습니다.");
						$('#applDetailArea').html('');
						$("#reqApplGrid").jsGrid("search");
					} else {
						alert("삭제시 오류가 발생하였습니다. " + response.message);
					}
					$("#reqDeleteBtn").prop("disabled", false);
				}
			});
		}
	}

</script>