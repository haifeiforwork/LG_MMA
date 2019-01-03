<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<link type="text/css" rel="stylesheet" href="/web-resource/js/jQuery/dynatree/ui.fancytree.min.css" />
<style>
<!--
.tableInquiry input, select {width:auto !important;}
.tableBtnSearch button {position:static;}

.scroll-body {max-height: 410px !important;}
.tableInquiry {margin: 0 0 0 0;}

.listTable td {border-bottom:0;}
-->
</style>
<script type="text/javascript" src="/web-resource/js/jQuery/dynatree/jquery.dynatree.min.js"></script>
<script type="text/javascript" src="/web-resource/js/worktime52/search-popup.js?v=${CACHE_VERSION}"></script>
<script type="text/javascript">

$(function() {
	
	$.fetchOrgehData();
	
	$.bindSearchOptionRadioHandler();
	$.bindDeptNameKeydownHandler();
	$.bindEmpNameKeydownHandler();
	$.bindIncludeSubOrgCheckboxHandler();
	$.bindSearchOrgInTreeHandler();
	$.bindButtonSearchDeptHandler();
	$.bindSearchEmpHandler();
	
	$.bindButtonSearchHandler();
	$.bindEmpGubunRadioChangeHandler();
	$.bindTabClickHandler();
	
	$.toggleSearchLabel('<c:out value="${SEARCH_EMPGUBN}" />');
	$.setSearchDatepicker();
	
	$.buttonExcelHandler();
	$.bindNameClickPopup();
	
	$('.headerTable > thead').find('th').each(function() {
		$(this).css('border-bottom', '0');
	});
	
});

$.bindSearchOptionRadioHandler = function() {
    $('input[type="radio"][name="searchOption"]').click(function() {

        var v = $(this).val();
        $('div[data-name="search#Wrapper"]'.replace(/#/, v)).show().siblings().hide();
        $('div.searchOrg_ment').css('visibility', v === 'Org' ? 'visible' : 'hidden');
    });
}

$.setSearchDatepicker = function() {
	var param_search_date = "<c:out value='${SEARCH_DATE}' />";
	var obj_search_date;
	
	if(param_search_date.length == 8) {
		obj_search_date = new Date(param_search_date.substr(0, 4) + '-' + param_search_date.substr(4, 2) + '-' + param_search_date.substr(6, 2));
	} else if(param_search_date.indexOf('.') > -1) {
		obj_search_date = new Date(param_search_date.split('.').join('-'));
	} else {
		obj_search_date = new Date();
	}
	
	$('#SEARCH_DATE').datepicker().datepicker("setDate", obj_search_date);
}

$.buttonExcelHandler = function() {
	$('#excelButton').click(function(e) {
		e.preventDefault();
		
		$('[name=urlForm]')
			.attr('action', '/excel/workTimeLeaderReportExcel')
			.attr('target', '_self')
			.submit();
	});
}

$.bindNameClickPopup = function() {
	$('#reportContents').find('a').each(function() {
		$(this).click(function(e) {
			e.preventDefault();
			
			var empGubun = $('[name=SEARCH_EMPGUBUN]').val();
			var gubun = $('[name=SEARCH_GUBUN]').val();
			var datum = $('[name=SEARCH_DATE]').val();
			if(datum.indexOf('.') > -1) {
				datum = datum.split('.').join('');
			}
			var year = datum.substring(0, 4);
			var month = datum.substring(4, 6);
			var day = datum.substring(6, 8);
			
			var paramObj = {};
		    paramObj.isPop = 'Y';
		    paramObj.PARAM_ENAME = $(this).data('ename');
		    paramObj.PARAM_PERNR = $(this).data('pernr');
		    paramObj.PARAM_ORGTX = $(this).data('orgtx');
		    paramObj.SEARCH_GUBUN = gubun;
		    paramObj.SEARCH_DATE = datum;
	    	paramObj.SEARCH_YEAR = year;
	    	paramObj.SEARCH_MONTH = month;
		    
		    $.callReportPopup(paramObj);
		});
	});
}

$.callReportPopup = function(paramsObj){
	$("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
	
   	// 타이틀 셋팅
    $('#reportPopupTitle').text(paramsObj.PARAM_ENAME + '(' + paramsObj.PARAM_PERNR + ') ' + paramsObj.PARAM_ORGTX);
   	
   	// parameter string
   	var paramString = $.param(paramsObj);
   	
   	// 레포트 호출
    $("#reportPopup").attr("src","/work/workTimeReport?" + paramString);
    $("#reportPopup").load(function(){
        $('#popLayerWorkReport').popup("show");
        $("body").loader('hide');
    });
}

$.toggleSearchLabel = function(emp_gubun) {
	if(emp_gubun == 'S') {
		$('#labelSInfo').show();
		$('#labelHInfo').hide();
	} else {
		$('#labelSInfo').hide();
		$('#labelHInfo').hide();
	}
}

$.bindEmpGubunRadioChangeHandler = function() {
	$('#SEARCH_EMPGUBUN').change(function() {
		$.toggleSearchLabel($(this).val());
	});
}

$.bindButtonSearchHandler = function() {
	$('#searchButton').click(function(e) {
		e.preventDefault();
		
		$("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
		
		$.tabMove($('.tab a.selected').eq(0));
	});
}

$.bindTabClickHandler = function() {
	$('.tabArea').find('a').each(function() {
		$(this).click(function(e) {
			e.preventDefault();
			$.tabMove($(this));
		});
	});
}

$.tabMove = function(tabObj) {
    var searchOption = $('[name=searchOption]:checked').val();
    
	$('[name=SEARCH_EMPGUBUN]').val($('#SEARCH_EMPGUBUN').val());
	$('[name=SEARCH_DATE]').val($('#SEARCH_DATE').val());
	$('[name=SEARCH_OPTION]').val(searchOption);
	if(searchOption == 'Org') {
		$('[name=SEARCH_PERNR]').val('');
		$('[name=SEARCH_JOBID]').val('');
		$('[name=SEARCH_VALUE1]').val('');
		$('[name=SEARCH_RETIR_CHK]').val('');
		
		$('[name=SEARCH_DEPTID]').val($('[name=DEPTID]').val());
		$('[name=SEARCH_DEPTNM]').val($('[name=txt_deptNm]').val());
		if($('[name=includeSubOrg]').is(':checked')) {
			$('[name=SEARCH_INCLUDE_SUBDEPT]').val($('[name=includeSubOrg]').val());
		} else {
			$('[name=SEARCH_INCLUDE_SUBDEPT]').val('');
		}
	} else {
		$('[name=SEARCH_DEPTID]').val('');
		$('[name=SEARCH_DEPTNM]').val('');
		$('[name=SEARCH_INCLUDE_SUBDEPT]').val('');
		
		$('[name=SEARCH_JOBID]').val($('[name=jobid]').val());
		$('[name=SEARCH_PERNR]').val($('[name=PERNR]').val());
		$('[name=SEARCH_VALUE1]').val($('[name=I_VALUE1]').val());
		if($('[name=retir_chk]').is(':checked')) {
			$('[name=SEARCH_RETIR_CHK]').val($('[name=retir_chk]').val());
		} else {
			$('[name=SEARCH_RETIR_CHK]').val('');
		}
	}
	
	$('#urlForm')
		.attr('target', '_self')
		.attr('action', '/dept/workTimeLeaderReport')
		.submit();
}

function setDeptID(deptId, deptNm) {

    var form = $('form[name="searchOrg"]');
    form.find('input[type="hidden"][name="DEPTID"]').val(function() {
        return deptId ? deptId : $(this).data('init');
    });
    form.find('input[type="text"][name="txt_deptNm"]').val(function() {
        return deptNm ? deptNm : $(this).data('init');
    });

    $.tabMove($('.tab a.selected').eq(0));
}

function setPersInfo(pernr, ename) {
    var form = $('form[name="searchEmp"]');
    form.find('input[type="hidden"][name="PERNR"]').val(pernr);
    form.find('input[type="text"][name="I_VALUE1"]').val(ename);

    $.tabMove($('.tab a.selected').eq(0));
}

</script>

<!--// Page Title start -->
<div class="title">
	<h1>근무 실적현황</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">조직관리</a></span></li>
			<li><span><a href="#">부서 인사정보</a></span></li>
			<li class="lastLocation"><span><a href="#">근무 실적현황</a></span></li>
		</ul>						
	</div>
</div>
<!--// Page Title end -->

<div class="contentBody" style="min-width:1000px">

<form id="urlForm" name="urlForm" target="listFrame" method="POST">
   <input type="hidden" name="unblock" value="true" />
   <input type="hidden" name="subView" value="Y" />
   <input type="hidden" name="SEARCH_EMPGUBUN" value="<c:out value="${SEARCH_EMPGUBUN}" />" />
   <input type="hidden" name="SEARCH_DEPTID" value="<c:out value="${SEARCH_DEPTID}" />" />
   <input type="hidden" name="SEARCH_DEPTNM" value="<c:out value="${SEARCH_DEPTNM}" />" />
   <input type="hidden" name="SEARCH_INCLUDE_SUBDEPT" value="<c:out value="${SEARCH_INCLUDE_SUBDEPT}" />" />
   <input type="hidden" name="SEARCH_PERNR" value="<c:out value="${SEARCH_PERNR}" />" />
   <input type="hidden" name="SEARCH_DATE" value="<c:out value="${SEARCH_DATE}" />" />
   <input type="hidden" name="SEARCH_OPTION" value="<c:out value="${SEARCH_OPTION}" />" />
   <input type="hidden" name="SEARCH_JOBID" value="<c:out value="${SEARCH_JOBID}" />" />
   <input type="hidden" name="SEARCH_VALUE1" value="<c:out value="${SEARCH_VALUE1}" />" />
   <input type="hidden" name="SEARCH_RETIR_CHK" value="<c:out value="${SEARCH_RETIR_CHK}" />" />
   <input type="hidden" name="FROM_ESS_OFW_WORK_TIME" value="<c:out value="${FROM_ESS_OFW_WORK_TIME}" />" />
</form>

    <div class="tableInquiry">
        <table class="worktime" style="min-width:1000px;">
            <colgroup>
                <col style="width:8%" />
                <col style="width:8%" />
                <col style="width:12%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th rowspan="2">
                        <img class="searchTitle" src="/web-resource/images/top_box_search.gif" />
                    </th>
                    <th style="text-align:right;">
                        <label class="bold">사원구분</label>
                    </th>
                    <th style="text-align:left;">
                    	<select id="SEARCH_EMPGUBUN" style="margin-left:-1px;">
                        	<c:if test="${E_AUTH ne 'N'}">
                        	<option value="S" <c:if test="${SEARCH_EMPGUBUN eq 'S'}">selected</c:if>>사무직</option>
                        	</c:if>	
                        	<option value="H" <c:if test="${SEARCH_EMPGUBUN eq 'H'}">selected</c:if>>현장직</option>	
                        </select>
                    </th>
                   	<th rowspan="2">
                        <div class="tableBtnSearch"><a class="search" href="#" id="searchButton"><span class="icon-magnify"></span><span>조회</span></a></div>
                    </th>
                    <th rowspan="2" class="divider">
                    	<div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Org" <c:if test="${SEARCH_OPTION eq 'Org'}">checked="checked"</c:if> /> 부서검색</label></div>
                        <div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Emp" <c:if test="${SEARCH_OPTION eq 'Emp'}">checked="checked"</c:if> /> 사원검색</label></div>
                    </th>
                    <th rowspan="2" class="align-left" style="padding-left:10px">
                    	<div data-name="searchOrgWrapper" <c:if test="${SEARCH_OPTION eq 'Emp'}">style="display:none"</c:if>>
                            <form name="searchOrg" method="POST">
                                <div style="float:left; margin-right:20px;">
                                    <input type="hidden" name="DEPTID" data-init="" value="<c:out value='${SEARCH_DEPTID}' />" />
                                    <input type="text" name="txt_deptNm" maxlength="10" onfocus="this.select()" data-follow="ORGEH" style="width:200px; ime-mode:active" data-init="" value="<c:out value='${SEARCH_DEPTNM}' />" />
                                    <a class="icoSearch" href="javascript:;" data-name="searchOrg"><img alt="검색" src="/web-resource/images/ico/ico_magnify.png"></a>
                                </div>
                                <div class="divider" style="margin-left:10px; padding-left:10px;">
                                    <img class="searchIcon" src="/web-resource/images/icon_map_g.gif" />
                                    <label>하위조직포함 <input type="checkbox" name="includeSubOrg" value="Y" <c:if test="${SEARCH_INCLUDE_SUBDEPT eq 'Y'}">checked</c:if> /></label>
                                    <div class="tableBtnSearch"><a class="search" href="#" data-name="searchOrgInTree"><span class="icon-magnify"></span><span>조직도로 부서찾기</span></a></div>
                                </div>
                            </form>
                        </div>
                        <div data-name="searchEmpWrapper" <c:if test="${SEARCH_OPTION eq 'Org'}">style="display:none"</c:if>>
                            <form name="searchEmp" method="POST">
                                <div style="float:left; margin-right:5px;">
                                    <label>퇴직자조회 <input type="checkbox" name="retir_chk" value="X" <c:if test="${SEARCH_RETIR_CHK eq 'X'}">checked</c:if> /></label>
                                </div>
                                <div style="margin-left:15px;">
                                    <select name="jobid">
                                        <option value="ename" <c:if test="${SEARCH_JOBID eq 'ename'}">selected</c:if>>성명별</option>
                                        <option value="pernr" <c:if test="${SEARCH_JOBID eq 'pernr'}">selected</c:if>>사번별</option>
                                    </select>
                                    <input type="hidden" name="PERNR" value="<c:out value='${SEARCH_PERNR}' />" />
                                    <input type="text" name="I_VALUE1" maxlength="10" onfocus="this.select()" style="width:103px; ime-mode:active" value="<c:out value='${SEARCH_VALUE1}' />" />
                                    <a class="icoSearch" href="javascript:;" data-name="searchEmp"><img alt="검색" src="/web-resource/images/ico/ico_magnify.png"></a>
                                </div>
                            </form>
                        </div>
                    </th>
                </tr>
                <tr>
                	<th style="text-align:right;">
                        <label class="bold">조회기준일</label>
                    </th>
                	<th style="text-align:left;">
                        <input type="text" id="SEARCH_DATE" class="date required" size="10" value="<c:out value='${SEARCH_DATE}' />" />
                    </th>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="tableComment" style="margin:-5px 0 0 0">
        <p class="float-left" id="labelSInfo"><span class="bold">조회기준일의 1일~말일 데이터를 조회합니다.</span></p>
        <p class="float-left" id="labelHInfo"><span class="bold">조회기준일이 속한 탄력근무 기간 데이터를 조회합니다.</span></p>
        <p class="float-right"><span class="bold">하위조직포함을 선택하면 하위조직까지 조회됩니다.</span></p>
    </div>

    <div class="noTabArea" style="padding:0;height:31px;"></div>

    <div class="frameWrapper">
		<c:if test="${not empty T_RESULT}">
			<div class="buttonArea" style="float:right;">
				<ul class="btn_mdl displayInline">
					<li>
					<a href="#" id="excelButton">
						<span>엑셀다운로드</span>
						</a>
					</li>
				</ul>
			</div>
		</c:if>
		
		<h2 class="subtitle">해당 사번을 클릭하면, 세부 현황이 조회됩니다.</h2>
		<br/>
		<div class="listArea" style="margin-bottom:0px;">
			<div class="table scroll-table scroll-head">
				<table class="listTable worktime headerTable">
					<colgroup>
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="25%" />
		        		<col width="16%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        	</colgroup>
					<thead>
						<tr>
							<th class="th02" rowspan="2">사번</th>
							<th class="th02" rowspan="2">이름</th>
							<th class="th02" rowspan="2">소속</th>
							<th class="th02" rowspan="2">주당 실근무시간<br/>${not empty T_RESULT ? T_RESULT[0].WTEXT : ""}</th>
							<th class="th02" colspan="4">기간별 주 평균시간</th>
						</tr>
						<tr>
							<th class="th02 border-left">기간</th>
							<th class="th02">기준시간<br/>(52*주)</th>
							<th class="th02">실 근무시간</th>
							<th class="th02">주 평균시간</th>
						</tr>
					</thead>
				</table>
			</div>
			<div class="scroll-table scroll-body">
				<table class="listTable worktime">
					<colgroup>
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="25%" />
		        		<col width="16%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        	</colgroup>
					<tbody id="reportContents">
						<c:choose>
							<c:when test="${empty T_RESULT}">
								<tr class="oddRow">
									<%-- <td class="lastCol align_center" colspan="11">해당하는 데이터가 존재하지 않습니다.</td> --%>
									<td class="lastCol align_center" colspan="8">해당하는 데이터가 존재하지 않습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<fmt:parseNumber var="limitNumber" value="52" /><!-- 실근무시간 비교에 사용되는 변수 -->
								<c:forEach var="result" items="${T_RESULT}" varStatus="status">
									<c:set var="convertPernr" value="${fn:length(result.PERNR) == 8 ? fn:substring(result.PERNR,3,8) : result.PERNR}" />
									<tr class="borderRow">
										<td><a href="#" style="color:blue;" data-ename="${result.ENAME}" data-pernr="${convertPernr}" data-orgtx="${result.ORGEHTX}">${convertPernr}</a></td>
										<td>${result.ENAME}</td>
										<td>${result.ORGEHTX}</td>
										<td>
											<fmt:formatNumber var="decimalPoint" value="${(result.WRWKTM % 1) % 0.1}" />
		         							<fmt:formatNumber value="${result.WRWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" /><!-- 소숫점 두자리를 한자리로 표현(버림 표현식) -->
										</td>
										<td>${result.ADJUNTTX}</td>
										<td>
											<c:choose>
				            					<c:when test="${result.RMAXTM eq '0'}">${result.RMAXTM}</c:when>
				            					<c:otherwise><fmt:formatNumber value="${result.RMAXTM}" pattern="#,##0.00" /></c:otherwise>
				            				</c:choose>
										</td>
										<td>
											<c:choose>
				            					<c:when test="${result.RRWKTM eq '0'}">${result.RRWKTM}</c:when>
				            					<c:otherwise>
				            						<fmt:formatNumber var="decimalPoint" value="${(result.RRWKTM % 1) % 0.1}" />
		         									<fmt:formatNumber value="${result.RRWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="#,##0.0" /><!-- 소숫점 두자리를 한자리로 표현(버림 표현식) -->
				            					</c:otherwise>
				            				</c:choose>
										</td>
										<fmt:parseNumber var="convertRAVRTM" value="${result.RAVRTM}" />
										<td <c:if test="${convertRAVRTM ge limitNumber}">style="background-color:#FFB6C1;"</c:if>><!-- 기준시간보다 클 경우 Red로 표시 -->
											<fmt:formatNumber var="decimalPoint" value="${(result.RAVRTM % 1) % 0.1}" />
		            						<fmt:formatNumber value="${result.RAVRTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" /><!-- 소숫점 두자리를 한자리로 표현(버림 표현식) -->
										</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>
    </div>
</div>

<!-- 부서검색, 사원검색, 조직도검색 영역 팝업 -->
<%@ include file="include/searchPopupLayers.jsp" %>
<!--// 부서검색, 사원검색, 조직도검색 영역 팝업 -->

<!-- 개인Report 영역 팝업 -->
<div class="layerWrapper layerSizeP" id="popLayerWorkReport" style="display:none;width:1060px;">
	<div class="layerHeader">
		<strong id="reportPopupTitle"></strong>
		<a href="#" class="btnClose popLayerWorkReport_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<iframe name="reportPopup" id="reportPopup" src="" frameborder="0" scrolling="auto" style="width:100%;height:800px;"></iframe>
	</div>
</div>
<!-- END 개인Report 영역 팝업 -->