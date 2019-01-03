<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E19Disaster.*" %>
<%@ page import="hris.E.E19Disaster.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%
	WebUserData user = (WebUserData)session.getValue("user");
	//E19CongcondData  e19CongcondData      = (E19CongcondData)request.getAttribute("e19CongcondData");
    /* 재해피해신고서 입력된 vector를 받는다*/
    Vector          E19DisasterData_vt    = (Vector)request.getAttribute("E19DisasterData_vt");
    Vector          AppLineData_vt        = (Vector)request.getAttribute("AppLineData_vt");
    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    Vector          AccountData_pers_vt   = (Vector)request.getAttribute("AccountData_pers_vt");
    AccountData     AccountData_hidden    = (AccountData)request.getAttribute("AccountData_hidden");
    E19CongcondData e19CongcondData		  = (E19CongcondData)request.getAttribute("e19CongcondData");
    
    Vector          E19DisasterData_rate = (Vector)request.getAttribute("E19DisasterData_rate");
    //Vector          E19DisasterData_rat2 = (Vector)request.getAttribute("E19DisasterData_rat2");
    
    Vector          E19DisasterData_opt = (new E19DisaRelaRFC()).getDisaRela(user.companyCode);    
%>
  

		<!-- contents start -->

			<!-- innerContent start -->

			
				<!--// Page Title start -->
				<div class="title">
					<h1>재해</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">My Info</a></span></li>
							<li><span><a href="#">복리후생</a></span></li>
							<li class="lastLocation"><span><a href="#">재해</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->	
				
				<!--------------- layout body start --------------->				
				<!--// Table start -->	
				<div class="tableArea">
					<h2 class="subtitle">재해신청</h2>
					<!-- 
					<div class="buttonArea">
						<ul class="btn_mdl">
							<!-- 재해피해 신고서 입력 페이지는 popupLayer.html 작업되어 있음
							<li><span class="colorRed">※ 재해피해 신고서를 반드시 입력해 주세요.</span> <a href="#"><span>재해피해 신고서 입력</span></a></li>							
						</ul>
					</div>
					 -->
					<div class="clear"> </div>

					<div class="table">
							<form id="form1" name="form1" method="post" action="">
							<table class="tableGeneral">
							<caption>재해신청</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
							<th><label for="inputText01-1">신청일</label></th>
							<td class="tdDate">
								<input class="readOnly" type="text"  value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" id="BEGDA" name="BEGDA" readonly />
							</td>
							<th><span class="textPink">*</span><label for="inputDate01">재해발생일자</label></th>
							<td class="tdDate">
                            	<input type="text" class="datepicker" id="CONG_DATE" name="CONG_DATE" required vname="재해발생일자"/>
                            </td>
                        </tr>	
							<tr>
								<th><label for="inputText02-1">통상임금</label></th>
								<td colspan="3">
									<input class="inputMoney w120 readOnly" type="text" id="WAGE_WONX" name="WAGE_WONX" value="<%=WebUtil.printNumFormat(e19CongcondData.WAGE_WONX)%>" readonly /> 원
																    <input type="hidden" name="COUNT_NO" id="COUNT_NO" value=""  >
      								<input type="hidden" name="CONG_CODE"  id="CONG_CODE"     value="0005">									
              						<input type="hidden" name="AINF_SEQN" id="AINF_SEQN"      value="<%= e19CongcondData.AINF_SEQN %>">
								</td>
							</tr>
							<tr>
								<th><label for="inputText02-2">지급율</label></th>
								<td colspan="3">
									<input class="alignRight w120 readOnly" type="text" name="CONG_RATE" id="CONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" readonly required vname="지급율" /> %
									<input type="hidden" name="xCONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" >
                                </td>
                            </tr>
                            <tr>
								<th><label for="inputText02-3">재해위로금액</label></th>
								<td colspan="3">
									<input class="inputMoney w120 readOnly" type="text" id="CONG_WONX" name="CONG_WONX" value="<%=e19CongcondData.CONG_WONX.equals("") ? "" : WebUtil.printNumFormat(e19CongcondData.CONG_WONX)%>" readonly required vname="재해위로금액"/> 원
	                                <input type="hidden" name="xCONG_WONX" value="<%=e19CongcondData.CONG_WONX.equals("") ? "" : WebUtil.printNumFormat(e19CongcondData.CONG_WONX)%>">
								</td>
							</tr>
							<tr>
								<th><label for="inputText02-4">이체은행명</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="BANK_NAME" name="BANK_NAME" value="<%=e19CongcondData.BANK_NAME %>" readonly required vname="이체은행명"/>
								</td>
								<th><label for="inputText02-5">은행계좌번호</label></th>
								<td>
									<input class="w120 readOnly" type="text" name="BANKN" value="<%=e19CongcondData.BANKN %>" id="BANKN" readonly required vname="은행계좌번호"/>
								</td>
							</tr>
							<tr>
								<th><label for="inputText02-7">근속년수</label></th>
								<td colspan="3">
                                   <input class="alignRight w50 readOnly" type="text"  value="<%= ( e19CongcondData.WORK_YEAR.equals("") || e19CongcondData.WORK_YEAR.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>" id="WORK_YEAR" name="WORK_YEAR" readonly /> 년
                                   <input class="alignRight w50 readOnly" type="text"  value="<%= ( e19CongcondData.WORK_MNTH.equals("") || e19CongcondData.WORK_MNTH.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>" id="WORK_MNTH" name="WORK_MNTH" readonly /> 개월
                                </td>
							</tr>						
							</tbody>
							</table>
							</form>
						</div>
						
				</div>	
				<!--// Table end -->	
				<!--// list start -->
				<div class="listArea">	
					<h2 class="subtitle withButtons">재해피해 신고서</h2>
						<div class="buttonArea">
							<ul class="btn_mdl">
								<li><a href="#popLayerDisaster" class="popLayerDisaster_open darken"><span>등록</span></a></li>
								<li><a href="#" id="updateDisasterItem"><span>수정</span></a></li>
								<li><a href="#" id="deleteDisasterItem"><span>삭제</span></a></li>
							</ul>
						</div>
					<div id="disasterList" class="thSpan">
					</div>
				</div>	
						<input type="hidden" id="disaster_count" name="disaster_count" />
						<input type="hidden" id="RowCount_report" name="RowCount_report" value="" />
				<!--// list end -->					
				<!--// list start -->
				<div class="listArea" id="decisioner"></div>
				<!--// list end -->					
				<div class="buttonArea">
					<ul class="btn_crud">
						<c:if test="${selfApprovalEnable == 'Y'}">
							<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
						</c:if>
						<li><a class="darken" id="requestDisasterBtn" name="requestDisasterBtn" href="#"><span>신청</span></a></li>
					</ul>
				</div>		
				<!--------------- layout body end --------------->
			<!-- innerContent end -->
		<!--// contents end -->	

<!-- popup : 재해피해 신고서 start -->
<div class="layerWrapper layerSizeL" id="popLayerDisaster">
<form id="form2" name="form2" method="post" action="">	
	<div class="layerHeader">
		<strong>재해피해 신고서</strong>
		<a href="#" class="btnClose popLayerDisaster_close">창닫기</a>
	</div>
	<div class="layerContainer">		
		<div class="layerContent">			
			<!--// Content start  -->
			<!--// Content start  -->
			<div class="tableArea tablePopup">
				<div class="table">
					<table class="tableGeneral">
					<caption>재해피해 신고서  입력</caption>
					<colgroup>
						<col class="col_5p" />
						<col class="col_16p" />
						<col class="col_78p" />
					</colgroup>
					<tbody>
						<tr>
							<th colspan="2"><span class="textPink">*</span><label for="label-01">재해내역</label></th>
							<td>
								<select id="xDISA_RESN" name="xDISA_RESN" class="clearTarget" required vname="재해내역"> 
									<option value="">-----선택-----</option>
									<!-- 재해내역 option -->
									<%= WebUtil.printOption((new E19DisaResnRFC()).getDisaResn(user.companyCode)) %>
									<!-- 재해내역 option -->
								</select>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span class="textPink">*</span><label for="label-02">재해구분 </label></th>
							<td>
								<select id="xDISA_CODE" name="xDISA_CODE" class="clearTarget" required vname="재해구분"> 
									<option value="">-----선택-----</option>
									<!-- 재해구분 option -->
									<%= WebUtil.printOption((new E19DisaCodeRFC()).getDisaCode(user.companyCode)) %>
									<!-- 재해구분 option -->
								</select>
							</td>
						</tr>
						<tr>
							<th rowspan="4">재<br>해<br>피<br>해<br>자</th>
							<th><span class="textPink">*</span><label for="label-03">구분</label></th>
							<td>
								<select id="xDREL_CODE" name="xDREL_CODE" class="clearTarget" required vname="구분"> 
									<option value="">-----선택-----</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="label-04">성명</label></th>
							<td>
								<input type="text" id="xEREL_NAME" name="xEREL_NAME" value="" class="clearTarget" required vname="성명"/> 
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="label-05">생년월일</label></th>
							<td class="tdDate">
								<input class="w80" type="text" value="" id="xGBDAT" name="xGBDAT" required vname="생년월일"/> (YYYY.MM.DD)
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="PSTLZ">주소</label></th>
							<td>
								<input id="addrsPSTLZ" name="PSTLZ" type="text" value="" class="w50" placeholder="우편번호"  readonly/>
								<a class="inlineBtn" href="javascript:sample4_execDaumPostcode('addrsPSTLZ','addrsSTRAS','addrsLOCAT');"><span>우편번호 검색</span></a>				
								<div class="br">											
									<input id="addrsSTRAS" name="STRAS" type="text" class="wPer" readonly required vname="주소"/>
								</div>
								<div class="br">
									<input id="addrsLOCAT" name="LOCAT" type="text" class="wPer" placeholder="상세주소 입력" required vname="상세주소"/>
								</div>
								<p class="noteItem font11">세부 주소 입력 부탁드립니다. <br/>(아파트 : 동, 호수까지 기입, 주택 및 기타 : 층수까지 상세 주소 기입)</p>
							</td>
						</tr>
						
						<tr>
							<th colspan="2"><label for="label-06">재해내용</label></th>
							<td>
								<div class="br">
									<input id="xDISA_DESC1" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
								<div class="br">
									<input id="xDISA_DESC2" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
								<div class="br">
									<input id="xDISA_DESC3" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
								<div class="br">
									<input id="xDISA_DESC4" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
								<div class="br">
									<input id="xDISA_DESC5" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
              						<input type="hidden" name="xDISA_RATE" id="xDISA_RATE" value="" class="clearTarget" >
              						<input type="hidden" name="xDISA_NAME" id="xDISA_NAME" value="" class="clearTarget" >
              						<input type="hidden" name="xRESN_NAME" id="xRESN_NAME" value="" class="clearTarget" >
              						<input type="hidden" name="xDREL_NAME" id="xDREL_NAME" value="" class="clearTarget" >
							</td>
						</tr>
					</tbody>
					</table>
				</div>
			</div>
			<div class="buttonArea buttonCenter">
				<ul class="btn_crud">
					<li><a class="darken" id="addDamage" href="#"><span>확인</span></a></li>
					<li><a href="#" id="cancleDamage" ><span>취소</span></a></li>
					<input type="hidden" id ="registMode" name ="registMode" vlaue="">					
				</ul>
			</div>
			<!--// Content end  -->							
		</div>		
	</div>		
</form>
</div>
<!-- //팝업: 재해피해 신고서 end -->

  <script type="text/javascript">
	var orgItem;
  var E19DisasterData_rat2;
  var hideFlag = true;
  	
		jQuery.ajax({
    		type : "POST",
    		url : "/supp/readDisterData_rat2.json",
    		cache : false,
    		dataType : "json",
    		async :false,
    		success : function(response) {
    			if(response.success){
    				E19DisasterData_rat2 = response.storeData;
    			}
    			else{
    				alert(response.message);
    			}
    		}
		});
	 
	 
     $(document).ready(function(){
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=09&gridDivId=decisionerGrid');
		if($("#popLayerDisaster").length){
			
			$("#registMode").val("create")
			// 재해피해 신고서 팝업
			$('#popLayerDisaster').popup();
		};
		
		$("#registerDisasterReport").click(function(){
			$("#popLayerDisaster").popup('show');
		});
		$("#cancleDamage").click(function(){
			$("#popLayerDisaster").popup('hide');
		});
		//##deleteDisasterItem
		$("#deleteDisasterItem").click(function(){
			if( !$("input:radio[name='chk']").is(":checked")) {
				alert("삭제 대상을 선택하세요.");
				return false;
			}
		
			deleteDisasterItem();
			calCONG_WONX();
		});

		$("#updateDisasterItem").click(function(){
			if( !$("input:radio[name='chk']").is(":checked")) {
				alert("수정 대상을 선택하세요.");
				return false;
			}	
		
			$("#popLayerDisaster").popup('show');
			$("#registMode").val("update");
		});
		
		$("#addDamage").click(function(){
			//alert("11" +$("#registMode").val() + ";" );
			if($("#registMode").val() == "create"){
				saveClient();
			}else if($("#registMode").val() == "update"){
				updateClient();
			}
			calCONG_WONX();
			if(hideFlag){			
	        	$("#popLayerDisaster").popup('hide');
			}
		});
		
		$("#requestDisasterBtn").click(function(){
			requestDisaster(false);
		});
		$("#requestNapprovalBtn").click(function(){
			requestDisaster(true);
		});
     
		$("#xDISA_CODE").change(function(){
			view_DisaRela();
		});
		$("#xDREL_CODE").change(function(){
			rate_action();
		});
		$("#xDISA_DESC1, #xDISA_DESC2, #xDISA_DESC3, #xDISA_DESC4, #xDISA_DESC5").keyup(function(event){
		    val = $(this).val();
		    nam = this.id;
		    len = checkLength($(this).val());
		    
		    if (event.keyCode ==13 ){
				if(nam=="xDISA_DESC1"){
				    $('#xDISA_DESC2').focus();
		        }else if(nam=="xDISA_DESC2"){
		        	$('#xDISA_DESC3').focus();
		        }else if(nam=="xDISA_DESC3"){
		        	$('#xDISA_DESC4').focus();
		        }else if(nam=="xDISA_DESC4"){
		        	$('#xDISA_DESC5').focus();
		        }else if(nam=="xDISA_DESC5"){
		            this.blur();
		        }
			  }
		    if(len > 59){
		        vala = limitKoText(val,59);
		        this.blur();
		        $(this).val(vala);
		        $(this).focus();
		    }
		
		});
		
	});

	function checkLength(text){
		  val = text;
		  var leng = 0;
		    for( i = 0; i<val.length; i++ ){
		        codeChr = val.charCodeAt(i);
		        if( codeChr>255 ){
		            leng = leng+2;
		        } else {
		            leng = leng+1;
		        }
		   }
		   return leng;
		}

	
	var requestDisaster =  function(self){
		
		if( !requestCheck1() ) {
			return;
		}
		decisionerGridChangeAppLine(self);
		//RowCount_report 재해피해신고서 length
		//RowCount  결재 length
		$("#RowCount").val($("#decisionerGrid").jsGrid("dataCount"));
		$("#RowCount_report").val($("#disasterList").jsGrid("dataCount"));
		//console.log($("#RowCount").val()  +  ":: " + $("#RowCount_report").val());
		
		$("#WAGE_WONX").val(removeComma($("#WAGE_WONX").val()));
		
		var param = $("#form1").serializeArray();
		
		$("#decisionerGrid").jsGrid("serialize", param);
		$("#disasterList").jsGrid("serialize", param);
		param.push({"name":"selfAppr", "value" : self});
		//console.log(param);
		
		//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
		var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
		if(confirm(msg + "재해피해 신청 하시겠습니까?")){
			$("#requestDisasterBtn").prop("disabled", true);	
			$("#requestNapprovalBtn").prop("disabled", true);	
		
			jQuery.ajax({
				type : 'POST',
				url : '/supp/requestDisaster.json',
				cache : false,
				dataType : 'json',
				data : param,
				async :false,
				success : function(response) {
		  			if(response.success){
		  				alert("신청 되었습니다.");
		  				$("#form1").each(function() {
	    					this.reset();
	    					$("#disasterList").jsGrid({data: []});
	    				});
		  			}else{
		  				alert("신청시 오류가 발생하였습니다. " + response.message);
		  			}
		  			$("#requestDisasterBtn").prop("disabled", false);
		  			$("#requestNapprovalBtn").prop("disabled", false);
		  		}
			});
		} else {
			decisionerGridChangeAppLine(false);
		}
	}
	
    $(function() {
    	var clients = [];
        $("#disasterList").jsGrid({
            height: "auto",
            width: "100%",
            sorting: false,
            paging: false,
            autoload: true,
            data: clients,
   			rowClick: function(args){
   				
   				//$('input:radio[name=chk]').eq(args.itemIndex).prop("checked",true);
   				//$('#controlDisasterListRow').val(args.itemIndex);
   				
   				//console.log($('#controlDisasterListRow').val());
   			
   			},
            headerRowRenderer: function() {
                var $result = $("<tr>").height(0)
                	.append($("<th width='6%'>"))
                	.append($("<th width='8%'>"))
                	.append($("<th width='24%'>"))
                	.append($("<th width='17%'>"))
                	.append($("<th width='17%'>"))
                	.append($("<th width='18%'>"))
        	        .append($("<th width='10%'>"));

                $result = $result.add($("<tr>")
                	.append($("<th>").attr("rowspan", 2).text("선택"))
                	.append($("<th>").attr("rowspan", 2).text("No."))
                	.append($("<th>").attr("rowspan", 2).text("재해구분"))
                	.append($("<th>").attr("colspan", 3).text("재해피해자"))
                	.append($("<th>").attr("rowspan", 2).text("지급율")));
                
                var $tr = $("<tr>");
                
                var grid = this;
                
                grid._eachField(function(field, index) {
                    if (index>2 && index<6) {
                    var $th = $("<th>").text(field.title).width(field.width).appendTo($tr);
                    
                    if(grid.sorting && field.sorting) {
                		$th.on("click", function() {
//                        	grid.sort(index);
                    	});
                    }
                    }
                });
                
                return $result.add($tr);
            },
            fields: [
            	{
                	title: "선택",
                	name: "CHECK_ITEM",
                    itemTemplate: function(_, item) {
                        return $("<input name='chk'>")
						.attr("type", "radio")
						.on("click", function(e) {
							orgItem = item;
/*
 * DISA_CODE:"1000"
	 DISA_DESC1:""
		 DISA_DESC2:""
		 DISA_DESC3:""
		 DISA_DESC4:""
		 DISA_DESC5:""
		 DISA_NAME:"가옥(완파)"
		 DISA_RATE:"100.0"
		 DISA_RESN:"0005"
		 DREL_CODE:"0001"
		 DREL_NAME:"본인"
		 EREL_NAME:"ㅇㅇㅇㅇ"
		 LOCAT:undefined
		 NO:1
		 GBDAT:"1111"
		 RESN_NAME:"전답피해"
		 STRAS:
 */
					  		$("#xDISA_CODE").val(item.DISA_CODE);
							$("#xDISA_DESC1").val(item.DISA_DESC1);
							$("#xDISA_DESC2").val(item.DISA_DESC2);
							$("#xDISA_DESC3").val(item.DISA_DESC3);
							$("#xDISA_DESC4").val(item.DISA_DESC4);
							$("#xDISA_DESC5").val(item.DISA_DESC5);
							$("#xDISA_NAME").val(item.DISA_NAME);
							$("#xDISA_RATE").val(item.DISA_RATE);
							$("#xDISA_RESN").val(item.DISA_RESN);
							$("#xDREL_CODE").val(item.DREL_CODE);
							$("#xDREL_NAME").val(item.DREL_NAME);
							$("#xEREL_NAME").val(item.EREL_NAME);
							$("#addrsLOCAT").val(item.LOCAT);
							$("#xGBDAT").val(item.GBDAT);
							$("#xRESN_NAME").val(item.RESN_NAME);
							$("#addrsSTRAS").val(item.STRAS);
		       		
				   		});
                    },
                    align: "center",
                    width: "6%"
                },
            	{ title: "No.", name: "NO", type: "text", align: "center", width: "8%" },
            	{ title: "재해구분", name: "DISA_NAME", type: "text", align: "center", width: "24%" },
            	{ title: "구분", name: "DREL_NAME", type: "text", align: "center", width: "17%" },
                { title: "성명", name: "EREL_NAME", type: "text", align: "center", width: "17%" },
                { title: "생년월일", name: "GBDAT", type: "number", align: "center", width: "18%" },				                    
                { title: "지급율", name: "DISA_RATE", type: "number", align: "center", width: "10%",
                	itemTemplate: function(val, item) {
                		return val + " %";
                	}
                },
            	{ title: "재해내역(code)", name: "DISA_RESN", type: "text", align: "center", visible:false },
            	{ title: "재해내역", name: "RESN_NAME", type: "text", align: "center", visible:false },
            	{ title: "구분(code)", name: "DREL_CODE", type: "text", align: "center", visible:false },
            	{ title: "재해구분(code)", name: "DISA_CODE", type: "text", align: "center", visible:false },
                { title: "주소", name: "STRAS", type: "text", align: "center", visible: false},
                { title: "상세주소", name: "LOCAT", type: "text", align: "center", visible: false},
                { title: "재해내용1", name: "DISA_DESC1", type: "text", align: "center", visible: false},
                { title: "재해내용2", name: "DISA_DESC2", type: "text", align: "center", visible: false},
                { title: "재해내용3", name: "DISA_DESC3", type: "text", align: "center", visible: false},
                { title: "재해내용4", name: "DISA_DESC4", type: "text", align: "center", visible: false},
                { title: "재해내용5", name: "DISA_DESC5", type: "text", align: "center", visible: false},
                { title: "경조발생일", name: "CONG_DATE", type: "text", align: "center", visible: false}
            ]
        });
    });
    
	var requestCheck1 = function(){
		//필수값 체크
		if(!checkNullField("form1")){
			return false;
		}
		
		return true;
	};	

	var requestCheck2 = function(){
		//필수값 체크
		if(!checkNullField("form2") || !checkdate($("#xGBDAT"))) {
			
			hideFlag = false;
			return false;
		}
		
		return true;
	};	
	
  	var count_no = 0; //Number($('COUNT_NO').val());
    
  	//재해피해 신고서 입력
  	var saveClient = function() {
  		
  		if( !requestCheck2() ) return;	
  	
  		hideFlag = true;
    	//alert("1");
    	if($('#COUNT_NO').val()==""){
    		count_no = 1; 
    		$('#COUNT_NO').val(count_no);
    	}else{
    		count_no = count_no+1;
    		$('#COUNT_NO').val(count_no);
    	}
        $("#disasterList").jsGrid( "insertItem", 
        		{ "CHECK_ITEM": "", 
        		  "NO": count_no, 
        		  "DISA_CODE": $('#xDISA_CODE').val(), 
        		  "DREL_CODE": $('#xDREL_CODE').val(), 
        		  "EREL_NAME": $('#xEREL_NAME').val(), 
        		  "GBDAT": $('#xGBDAT').val(), 
        		  "DISA_RATE": $('#xDISA_RATE').val(),
        		  "STRAS" : $('#addrsSTRAS').val(), //주소
        		  "LOCAT" : $('#addrsLOCAT').val(),  //상세주소
        		  "DISA_RESN": $('#xDISA_RESN').val(),
        		  "RESN_NAME": $('#xDISA_RESN option:selected').text(),
        		  "DISA_NAME": $('#xDISA_CODE option:selected').text(),
        		  "DREL_NAME": $('#xDREL_CODE option:selected').text(),
          		  "DISA_DESC1": $('#xDISA_DESC1').val(),
          		  "DISA_DESC2": $('#xDISA_DESC2').val(),
          		  "DISA_DESC3": $('#xDISA_DESC3').val(),
          		  "DISA_DESC4": $('#xDISA_DESC4').val(),
          		  "DISA_DESC5": $('#xDISA_DESC5').val()
        		  });
        $('#xGBDAT').val("");
        $('#addrsSTRAS').val("");
        $('#addrsLOCAT').val("");
        $('#addrsPSTLZ').val("");
        $('#xDISA_DESC1').val("");
        $('#xDISA_DESC2').val("");
        $('#xDISA_DESC3').val("");
        $('#xDISA_DESC4').val("");
        $('#xDISA_DESC5').val("");
        
        $('.clearTarget').val("");
    };


  	//재해피해 신고서 입력
  	var updateClient = function() {
    	
  		if( !requestCheck2() ) return;
  		
  		hideFlag = true;
  		
    	if($('#COUNT_NO').val()==""){
    		count_no = 1; 
    		$('#COUNT_NO').val(count_no);
    	}else{
    		count_no = count_no+1;
    		$('#COUNT_NO').val(count_no);
    	}
    	
        $("#disasterList").jsGrid( "updateItem", orgItem, 
        		{ "CHECK_ITEM": "", 
        		  "NO": count_no, 
        		  "DISA_CODE": $('#xDISA_CODE').val(), 
        		  "DREL_CODE": $('#xDREL_CODE').val(), 
        		  "EREL_NAME": $('#xEREL_NAME').val(), 
        		  "GBDAT": $('#xGBDAT').val(), 
        		  "DISA_RATE": $('#xDISA_RATE').val(),
        		  "STRAS" : $('#addrsSTRAS').val(), //주소
        		  "LOCAT" : $('#addrsLOCAT').val(),  //상세주소
        		  "DISA_RESN": $('#xDISA_RESN').val(),
        		  "RESN_NAME": $('#xDISA_RESN option:selected').text(),
        		  "DISA_NAME": $('#xDISA_CODE option:selected').text(),
        		  "DREL_NAME": $('#xDREL_CODE option:selected').text(),
          		  "DISA_DESC1": $('#xDISA_DESC1').val(),
          		  "DISA_DESC2": $('#xDISA_DESC2').val(),
          		  "DISA_DESC3": $('#xDISA_DESC3').val(),
          		  "DISA_DESC4": $('#xDISA_DESC4').val(),
          		  "DISA_DESC5": $('#xDISA_DESC5').val()
        		  });
        $('#xGBDAT').val("");
        $('#addrsSTRAS').val("");
        $('#addrsLOCAT').val("");
        $('#addrsPSTLZ').val("");
        $('#xDISA_DESC1').val("");
        $('#xDISA_DESC2').val("");
        $('#xDISA_DESC3').val("");
        $('#xDISA_DESC4').val("");
        $('#xDISA_DESC5').val("");
        
        $('.clearTarget').val("");
    };    
    
  	//지급율, 재해위로금액 계산
    var calCONG_WONX = function() {

  	    var rate = 0 ;
  	    var rat2 = 0 ;
  	    var flag = 'Y' ; 
  	    var flag2 = 'Y' ;
		var cong_rate = 0;
	
		var gridArray = $("#disasterList").jsGrid("option", "data");
		$.each(gridArray, function(i, data){
			
				for(var j=0; j<E19DisasterData_rat2.length; j++){
					var item = E19DisasterData_rat2[j];
		  	    	
		  	    	if(item.DISA_RESN != '' && flag2 == 'Y'){
		  	    		if(data['DISA_RESN'] == item.DISA_RESN){
		  	    			rat2 = Number(item.DISA_RATE)+Number(data['DISA_RATE']);
		  	    			if(rat2 > 100){
		  	    				 rate = rate + (100 - Number(item.DISA_RATE) );
			    				 flag2 = 'N';
		  	    			}else{
		  	    				rate = rate + Number(data['DISA_RATE']);  
		  	    			}
		  	    			flag = 'N';
		  	    		}
		  	    	}
				}
				if(flag == 'Y'){
					 rate = rate + Number(data['DISA_RATE']);
				}
				flag = 'Y';
		}); 

		flag = '';
		if(rate > 100){
			rate = 100;
		}
		
		if(rate > 0){
			$('#CONG_RATE').val(rate);
			cal_money_val = cal_money();
	        if(cal_money_val < 100000){//최소 10만원
	            cal_money_val = 100000;
	          }
	        $('#CONG_WONX').val(cal_money_val);
		}
		
		if(gridArray.length == 0){
			$('#CONG_RATE').val('');
			$('#CONG_WONX').val('');
		}
  	    
    };  
    
    var cal_money = function(){

        var rate = 0;
        var wage = 0;
        var money = 0 ;

        rate = Number($('#CONG_RATE').val());
        wage = Number("<%=e19CongcondData.WAGE_WONX%>");
        money = ( rate * wage ) / 100;
        money = money_olim(money);

        return money;
    }
  //LG MMA 1000 미만 단수절상
   var money_olim =  function money_olim(val_int){
        var money = 0;
        var compCode = 0;
        var rate = 0;
        compCode = "<%=user.companyCode%>";
        money = olim(val_int, -3);

        return money;
    }    
    
  //재해구분&대상자관계에 따른 재해위로금 Action
   
  var rate_action = function() {

	  var money = 0;
      var rate  = 0;
   	  var disa = $('#xDISA_CODE').val();
   	  var rela = $('#xDREL_CODE').val();//xDREL_CODE 
     	  
    <%
        for( int i = 0 ; i < E19DisasterData_rate.size() ; i++ ) {
          E19DisasterData data_rate = (E19DisasterData)E19DisasterData_rate.get(i);
    %>    
          if( rela == "<%=data_rate.DREL_CODE%>" && disa == "<%=data_rate.DISA_CODE%>" ){
            $('#xDISA_RATE').val("<%=data_rate.DISA_RATE%>");
            rate = Number($('#xDISA_RATE').val());
//          2002.11.13. 지급율을 계산할때 근속년수를 적용한다. 재해피해신고서
            compCode = "<%=user.companyCode%>";
            WORK_YEAR = Number($('#WORK_YEAR').val());
            WORK_MNTH = Number($('#WORK_MNTH').val());

            if(WORK_YEAR < 1 ){//LG MMA-1년미만
                rate  = rate  * 0.5 ;
                $('#xDISA_RATE').val(rate);
            
            }
//          2002.11.13. 지급율을 계산할때 근속년수를 적용한다. 재해피해신고서
          }
    <%
        } 
    %>
  
  };   

  
   var view_DisaRela = function(){ 	
	  // var val1 = obj[obj.selectedIndex].value;
	   var val = $("#xDISA_CODE").val();//DISA_CODE 값
	   $('#xDREL_CODE').find("option").remove().end();
 	$('#xDREL_CODE').append('<option value="">-----선택-----</option>');
 	  
 <%
      E19DisasterData data1 = (E19DisasterData)E19DisasterData_opt.get(0);
   	  int inx = 0;
      String before = "";
      for( int i = 0 ; i < E19DisasterData_opt.size() ; i++ ) {
          E19DisasterData data = (E19DisasterData)E19DisasterData_opt.get(i);
 %>
 
 if(val=='<%=data.DISA_CODE%>'){
  		$('#xDREL_CODE').append('<option value=' + '<%=data.DREL_CODE%>' + '>' + '<%=data.DREL_NAME%>' + '</option>');
	}
 
 <%  }  %>
};

//재해신고서 row 삭제

var deleteDisasterItem = function() {
     $("#disasterList").jsGrid( "deleteItem", orgItem);
};   
  </script>