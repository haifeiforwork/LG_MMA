<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="detailForm">
<div class="tableArea">
    <h2 class="subtitle">초과근무(OT/특근) 신청 상세내역</h2>
    <div class="table">
        <table class="tableGeneral table-layout-fixed">
        <caption>초과근무(OT/특근) 신청</caption>
        <colgroup>
            <col class="col_15p" />
            <col class="col_35p" />
            <col class="col_15p" />
            <col class="col_35p" />
        </colgroup>
        <tbody>
        <tr>
            <th>신청일</th>
            <td name="BEGDA"></td>
            <th>결재일</th>
            <td>${fn:escapeXml( APPR_DATE )}</td>
        </tr>
        </tbody>
        </table>
        <table class="tableGeneral table-layout-fixed">
        <colgroup>
            <col class="col_15p" />
            <col />
            <c:if test="${TPGUB_CD}"><col /></c:if>
        </colgroup>
        <tbody>
        <tr>
            <th>초과근무일</th>
            <td class="tdDate">
                <span name="WORK_DATE"></span>
                <input type="checkbox" name="VTKEN" class="checkbox-large" disabled="disabled" /> 前日 근태에 포함
            </td>
            <%-- [WorkTime52] 시작 : 지정일자 근무시간현황 --%>
            <c:if test="${TPGUB_CD}">
            <jsp:include page="/WEB-INF/views/pages/work/include/realWorkTimeReportTable.jsp">
                <jsp:param name="rowspan" value="3" />
            </jsp:include>
            </c:if>
            <%-- [WorkTime52] 종료 : 지정일자 근무시간현황 --%>
        </tr>
        <tr>
            <th>신청시간</th>
            <td><span name="BEGUZ" format="time"></span> ~ <span name="ENDUZ" format="time"></span> / <span name="STDAZ"></span> 시간</td>
        </tr>
        <tr>
            <th class="ot-reason ${TPGUB_CD ? fn:escapeXml( STYLE_TPGUB ) : ''} approval">신청사유</th>
            <td class="align-top"><span name="OVTM_CODE" id="OVTM_TEXT"></span> <span name="REASON"></span></td>
        </tr>
        </tbody>
        </table>
    </div>
</div>
<!--// Table end -->

<!-- Table start -->
<div class="listArea">
    <h2 class="subtitle">선택사항</h2>
    <div class="table">
        <table class="listTable borderBottom">
        <caption>휴게시간 작성</caption>
        <colgroup>
            <col class="col_16p"/>
            <col class="col_24p"/>
            <col class="col_24p"/>
            <col class="col_18p"/>
            <col class="col_18p"/>
        </colgroup>
        <thead>
        <tr>
            <th></th>
            <th class="thAlignCenter">시작시간</th>
            <th class="thAlignCenter">종료시간</th>
            <th class="thAlignCenter">무급</th>
            <th class="thAlignCenter tdBorder">유급</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <th>휴게시간 1</th>
            <td name="PBEG1" format="time"></td>
            <td name="PEND1" format="time"></td>
            <td name="PUNB1"></td>
            <td class="tdBorder" name="PBEZ1"></td>
        </tr>
        <tr>
            <th>휴게시간 2</th>
            <td name="PBEG2" format="time"></td>
            <td name="PEND2" format="time"></td>
            <td name="PUNB2"></td>
            <td class="tdBorder" name="PBEZ2"></td>
        </tr>
        </tbody>
        </table>
    </div>
</div>    
</form>

<%@include file="/WEB-INF/views/tiles/template/javascriptOverTime.jsp"%>
<script type="text/javascript">
function clearZeroData(data, index) {

    var PBEG = Number(data['PBEG' + index] || 0),
    PEND = Number(data['PEND' + index] || 0),
    PUNB = Number(data['PUNB' + index] || 0),
    PBEZ = Number(data['PBEZ' + index] || 0);
    if (PBEG + PEND + PUNB + PBEZ === 0) {
        $.each(['PBEG', 'PEND', 'PUNB', 'PBEZ'], function(i, v) {
            $('[name="' + v + index + '"]').text('');
        });
    }
}

$(document).ready(function() {

    $.ajax({
        url : '/appr/getWorkDetail.json',
        data : {
            AINF_SEQN: '${fn:escapeXml( AINF_SEQN )}',
            PERNR: '${fn:escapeXml( PERNR )}'
        },
        dataType: 'json',
        type: 'POST'
    }).done(function(response) {
        $.LOGGER.debug('DOM ready', response);

        if (!response.success) {
            alert('상세정보 조회시 오류가 발생하였습니다.\n\n' + response.message);
            return;
        }

        var storeData = response.storeData || {};
        if (storeData.BEGUZ) storeData.BEGUZ = OverTimeUtils.transformTime(storeData.BEGUZ);<%-- 24시 -> 00시 --%>
        if (storeData.ENDUZ) storeData.ENDUZ = OverTimeUtils.transformTime(storeData.ENDUZ);<%-- 24시 -> 00시 --%>
        if (storeData.STDAZ) storeData.STDAZ = OverTimeUtils.getNelim(storeData.STDAZ, 2);
        storeData.PUNB1 = Number(storeData.PUNB1 || 0) + '';
        storeData.PBEZ1 = Number(storeData.PBEZ1 || 0) + '';
        storeData.PUNB2 = Number(storeData.PUNB2 || 0) + '';
        storeData.PBEZ2 = Number(storeData.PBEZ2 || 0) + '';

        setTableText(storeData, 'detailForm');
        clearZeroData(storeData, 1);
        clearZeroData(storeData, 2);
        $('#rejectTxt').css('background', 'white');

        var code = storeData.OVTM_CODE;
        if (code) {
            var map = {};
            $.each(response.reasonCodeList || [], function(i, o) {
                map[o.SCODE] = o.STEXT;
            });
            $("#OVTM_TEXT").text(map[code] || '');
        }

        // 사무직-선택근무제 or 현장직-탄력근무제 실근무시간 현황
        renderRealWorktimeReport(response.reportData || {});
    });
});
</script>