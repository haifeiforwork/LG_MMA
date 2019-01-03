<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<form id="detailForm">
	<div class="tableArea">
	<h2 class="subtitle">교육/출장 신청 조회</h2>
	<div class="table">
		<table class="tableGeneral">
		<caption>교육,출장 신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_85p"/>
		</colgroup>
		<tbody>
		<tr>
			<th>신청일</th>
			<td name="BEGDA">
			</td>
		</tr>	
		<tr>
			<th>신청구분</th>
			<td name="AWART" format="replace" code="code" codeNm="value"></td>
		</tr>
		<tr>
			<th>구분</th>
			<td name="OVTM_CODE" format="replace" code="SCODE" codeNm="STEXT"></td>
		</tr>
		<tr>
			<th>신청사유</th>
			<td name="REASON"></td>
		</tr>
		<tr>
			<th>대근자</th>
			<td name="OVTM_NAME"></td>
		</tr>
		<tr>
			<th>신청기간</th>
			<td>
				<span name="APPL_FROM"></span>
				~
				<span name="APPL_TO"></span>
			</td>
		</tr>
		<tr id="cancleInputTimeArea" style="display:none;">
			<th>신청시간</th>
			<td>
				<span name="CANCLE_BEGUZ"></span>
				~
				<span name="CANCLE_ENDUZ"></span>
			</td>
		</tr>
		</tbody>
		</table>
	</div>
	</div>
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
				<th>취소 신청일</th>
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
			url : "/appl/getEduTripCancelDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				var tabFlag = response.tabFlag;
	            var awart = response.storeData[0].AWART;
	            
	            var gubunArr = $.makeArray({'code':'0020','value':'출장'});
	            if(tabFlag == 'Y' && (awart == '0010' || awart == '0011')) {
	            	gubunArr.push({'code':'0010','value':'필수교육'});
	            	gubunArr.push({'code':'0011','value':'선택교육'});
	            	
	            	$('[name=CANCLE_BEGUZ]').text(response.storeData[0].BEGUZ.substring(0, 2) + ":" + response.storeData[0].BEGUZ.substring(2, 4));
	            	$('[name=CANCLE_ENDUZ]').text(response.storeData[0].ENDUZ.substring(0, 2) + ":" + response.storeData[0].ENDUZ.substring(2, 4));
	            	
					$('#cancleInputTimeArea').show();
				} else {
					gubunArr.push({'code':'0010','value':'교육'});
					
					$('#cancleInputTimeArea').hide();
				}
				
				var arr = $.makeArray({"AWART":gubunArr, "OVTM_CODE":response.code_vt});
				
				setTableText(response.storeData, "detailForm", arr);
				$("#CBEGDA").text(response.cancelData[0].BEGDA);
				$("#CREASON").text(response.cancelData[0].CREASON);
				
			}else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
	});
	
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