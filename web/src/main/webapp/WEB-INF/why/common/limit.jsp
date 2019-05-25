<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<%
	/*首页*/
	boolean whyIndex = false;

    /*数据统计按钮控制*/
    boolean whyStatistics = false;

    boolean countyStatistics =  false;
    /*活动采编按钮控制*/
    boolean activityEditorial = false;
    boolean addActivityEditorial = false;
    boolean activityEditorialIndex = false;
    boolean activityEditorialReturnRecycleButton = false;
    boolean activityEditorialPublishButton = false;
    boolean activityEditorialDeleteButton = false;
    boolean activityEditorialRating = false;
    boolean activityEditorialEditRating = false;

	/*联系我们管理权限按钮控制*/
    boolean contactIndexButton = false;

	/*联系我们管理权限按钮控制*/
    boolean Information = false;
	/*评论管理权限按钮控制*/
    boolean commentIndexButton = false;
    boolean commentDeleteButton = false;
    boolean commentViewButton = false;

	/*会员管理权限按钮控制*/
    boolean terminalIndexButton = false;
    boolean terminalAddButton = false;
    boolean terminalEditWaiteActiveButton = false;
    boolean teamPreEditButton = false;
    boolean teamPreWaiteEditButton = false;
    boolean teamActiveButton = false;
    boolean terminalEditButton = false;
    boolean terminalFreezeButton = false;
    boolean terminalWaiteActiveButton = false;
    boolean teamViewButton = false;
    boolean teamViewWaiteButton = false;
    boolean terminalDisableCommentButton = false;
    boolean teamWaiteActiveIndexButton = false;
    boolean teamPreAddButton = false;
    boolean teamFreezeButton = false;
    boolean terminalViewButton = false;
    boolean terminalViewWaitButton = false;
    boolean terminalActiveButton = false;
    boolean teamIndexButton = false;

	/*活动权限管理*/
    boolean activityIndexButton = false;
    boolean activityRecommendCancelButton = false;
    boolean activityOrderIndexButton = false;
    boolean activityOrderIndexListButton = false;
    boolean activityDraftButton = false;
    boolean activityRecycleButton = false;
    boolean activityPreEditButton = false;
    boolean activityOrderDetailButton = false;
    boolean activityOrderSendSmsButton = false;
    boolean activityOrderDraftIndexButton = false;
    boolean activityPublishDraftButton = false;
    boolean activityReturnRecycleButton = false;
    boolean activityPublishButton = false;
    boolean activityDeleteButton = false;
    boolean activityOrderCancelButton = false;
    boolean activityPreEditDraftButton = false;
    boolean activityRecycleIndexButton = false;
    boolean activityPersonalIndexButton = false;
    boolean apprecommendButton = false;
    boolean RatingsInfoButton = false;
    boolean updateRatingsInfoButton = false;
    boolean activityTicketSettings=false;
    boolean activityTicketSpick=false;
    boolean activityPublisherButton=false;
    boolean activityCopy=false;
    boolean activityTemplateIndexButton=false;
    boolean functionIndexButton=false;

	/*敏感词管理*/
    boolean sensitiveWordsIndexButton = false;
    boolean sensitiveWordsPreAddButton = false;
    boolean sensitiveWordsPreEditButton = false;
    boolean sensitiveWordsFreezeButton = false;

	/*藏品管理权限按钮控制*/
    boolean antiqueIndexButton = false;    //藏品管理
    boolean antiquePreAddButton = false;    //添加藏品
    boolean antiquePreEditButtonT1 = false;        //编辑藏品
    boolean antiqueDeleteButtonT1 = false;        //删除藏品
    boolean antiqueIndexButtonA1 = false;        //查看藏品草稿箱
    boolean antiquePreEditButtonT2 = false;        //编辑草稿箱
    boolean antiqueUpdateButton = false;        //发布草稿箱
    boolean antiqueDeleteButtonT2 = false;        //删除草稿箱
    boolean antiqueIndexButtonA5 = false;        //查看藏品回收站
    boolean antiquePhysicalDeleteButton = false;        //删除回收站
    boolean antiqueRecoverButton = false;        //还原回收站

    boolean antiqueTypeIndexButton = false;        //藏品类型管理
    boolean antiqueTypePreAddButton = false;        //添加藏品类型
    boolean antiqueTypePreEditButton = false;        //编辑藏品类型
	
	/*轮播图管理权限按钮控制*/
    boolean webAdvertIndexButton = false;        //查看轮播图
    boolean appAdvertIndexButton = false;
    boolean appAdvertRecommendIndexButton = false;  //广告位管理
    boolean advertEditButton = false;        //编辑轮播图
    boolean advertAddButton = false;        //添加轮播图
    boolean advertRecoveryButton = false;        //下线轮播图
    boolean advertDeleteButton = false;        //删除轮播图
    boolean recoveryAdvertButton = false;  //上线轮播图
	
	/*标签管理权限按钮控制*/
    boolean tagListButton = false;        //查看标签
    boolean tagPreAddButton = false;        //添加标签
    boolean tagPreEditButton = false;        //编辑标签

    //场馆管理
    boolean selectVenueListButton = false; //场馆列表
    boolean addVenueButton = false; //新建场馆
    boolean venueDraftListButton = false; //场馆草稿箱
    boolean venueRecycleListButton = false; //场馆场馆回收站
    boolean venueCommentIndexButton = false; //场馆评论管理

    boolean preEditVenueButton = false; //编辑场馆
    boolean preDeleteVenueButton = false; //删除场馆                 有问题
    boolean venueSeatTemplateIndexButton = false; //选座模板
    boolean recommendVenueButton = false; //推荐场馆
    boolean notRecommendVenueButton = false; //取消推荐场馆
    boolean selectVenueButton = false; //取消推荐场馆
	/* boolean addVenueDraftListButton = false; //保存场馆到草稿箱 */
    boolean deleteRecycleButton = false; //删除回收站
    boolean preEditDrafButton = false; //编辑草稿箱  backVenueButton
    boolean backVenueButton = false; //还原回收站
	/* boolean preAssignManagerButton = false;//分配管理员 */
	/* boolean preViewAssignButton = false;//查看管理员 */
    boolean commentTopTrueButton = false; //场馆评论置顶
    boolean commentTopFalseButton = false;//场馆评论置顶
    boolean commentDelButton = false;//删除场馆评论
    boolean preDelDrafButton = false;//删除草稿箱
    boolean publishVenueDrafButton = false; //从草稿箱发布
    boolean venueExtensionButton = false; //场馆推广

	/*字典管理*/
    boolean dictIndexButton = false;//字典管理
    boolean preSaveSysDictButton = false;//添加字典
    boolean deleteDictButton = false;//删掉字典
    boolean editDictButton = false;//编辑字典
	
	/*活动室管理权限按钮控制*/
    boolean activityRoomIndexButton = false;
    boolean activityRoomAddButton = false;
    boolean activityRoomEditButton = false;
    boolean activityRoomMoveButton = false;// 活动室上下架
    boolean activityRoomDeleteButton = false; //删除活动室
    boolean activityRoomSaveToDraftButton = false; //发布草稿箱
    boolean activityRoomDraftIndexButton = false; //查看草稿箱
    boolean activityRoomDraftEditButton = false; //编辑草稿箱
    boolean activityRoomDraftDeleteButton = false; //删除草稿箱
    boolean activityRoomRecycleIndexButton = false; //查看回收站
    boolean activityRoomRecycleDeleteButton = false; //删除回收站
    boolean activityRoomRecycleBackButton = false; //还原回收站
    boolean activityRoomOrderIndexButton = false; //活动室预订列表
    boolean activityRoomOrderCancleButton = false; //取消活动室预订
    boolean activityRoomOrderDeleteButton = false; //删除活动室预订
    boolean activityRoomOrderSendSmsButton = false; //发送消息
	
	/*推荐管理权限按钮控制*/
    boolean recommendIndexButton = false;
    boolean recommendCancleButton = false; //取消推荐

    boolean cmsListRecommendTagButton = false;//app端活动列表页推荐
    boolean activityHomeRecommendIndexButton = false;//app端首页栏目推荐
    boolean webHomeNavigationRecommendButton = false;
    boolean webHomeNavigationRecommendActivityButton = false;//web端首页栏目推荐置顶
    boolean webCancleRecommendActivityButton = false;//web端首页栏目推荐取消置顶
    boolean appHomeNavigationRecommendActivityButton = false;//web端首页栏目推荐置顶
    boolean appCancleRecommendActivityButton = false;//web端首页栏目推荐取消置顶
    boolean apprecommendRelateButton = false;//活动推荐
    boolean apprecommendRelateTopButton = false;//活动标签置顶


    boolean homeHotRecommendButton = false;
    boolean homeHotAdd = false;
    boolean homeHotDelete = false;
    boolean homeVenueRecommendIndexButton = false;

	
	/*站点管理权限控制按钮*/
    boolean sysUserIndexButton = false;
    boolean sysUserAddButton = false;
    boolean sysUserEditButton = false;
    boolean sysUserDeleteButton = false; //冻结/解冻管理员
    boolean sysUserViewButton = false;
    boolean sysUserAllRoleButton = false; //分配管理员角色

    boolean roleIndexButton = false; //角色列表
    boolean roleAddButton = false; //新增角色
    boolean roleDeleteButton = false;//删除角色
    boolean rolePreEditButton = false;//修改角色
    boolean roleViewButton = false;//查看角色
    boolean moduleIndexButton = false;//角色分配权限

    boolean departmentIndexButton = false;
    /* boolean departmentEditButton = false; */

    boolean preInitModuleButton = false; //权限初始化
    boolean userFanKuiButton = false; //用户反馈

    boolean messageIndexButton = false;
    boolean messageAddButton = false;
    boolean messageEditButton = false;
    
    boolean appSettingIndexButton = false;
    
    boolean activityVoteIndexButton = false;
    
    /*手机版本管理*/
    boolean androidVersionIndexButton = false;
    boolean androidVersionAddButton = false;
    boolean androidVersionEditButton = false;
    
    /*互动管理*/
    boolean questionAnwserIndexButton = false;
    boolean questionAnwserPreAddButton = false;
    boolean questionAnwserPreEditButton = false;
    boolean questionAnwserDeleteButton = false;
    
    /*知识问答*/
  	boolean contestQuizIndex= false;
    /*线上投票*/
   	boolean voteIndex = false;
    
  	/*展览管理*/
    boolean exhibitionIndexButton = false;
  	
  	/*应用大赛配置*/
  	boolean applicationContestConfigIndexButton = false;

    
    /*信息共享*/
    boolean shareDeptIndexButton = false;
    boolean shareDeptPreAddButton = false;
    boolean shareDeptCancelButton = false;
    
    /*MC管理*/
    boolean mcVideoButton = false;
    boolean mcShowButton = false;
    boolean mcNewsButton = false;
    
    /*培训管理*/
    boolean trainButton = false;
    boolean courseButton = false;
    boolean courseOrderButton = false;
    boolean trianUserListButton = false;
    boolean courseUpDown = false;
    
    /*配送中心*/
    boolean dcStatisticsIndexButton = false;
    boolean dcVideoIndex1Button = false;
    boolean dcVideoIndex2wButton = false;
    boolean dcVideoIndex2hButton = false;
    boolean dcVideoIndex2sButton = false;
    boolean dcVideoIndex2xButton = false;
    boolean dcVideoIndex3Button = false;
    boolean dcVideoIndex4wButton = false;
    boolean dcVideoIndex4hButton = false;
    boolean dcVideoIndex4sButton = false;
    boolean dcVideoIndex4xButton = false;
    boolean dcVideoIndex5Button = false;
    
    /*浦东文化社团评选*/
    boolean cultureTeamIndexButton = false;
    /* 舞蹈大赛 */
    boolean cnwdEntryformButton = false;
    boolean viewCnwdEntryformButton = false;
    boolean checkCnwdEntryformButton = false;
%>

<%
    if (session.getAttribute("user") != null) {
%>
<c:forEach items="${sessionScope.user.sysModuleList}" var="module">

	<c:if test="${module.moduleUrl == '${path}/right.do'}">
        <% whyIndex = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityStatistics/activityAreaStatisticsIndex.do'}">
        <% whyStatistics = true;%>
    </c:if>
    
    
    <c:if test="${module.moduleUrl == '${path}/countyStatistics/countyStatisticsPage.do'}">
        <% countyStatistics = true;%>
    </c:if>
    
    
    
    <c:if test="${module.moduleUrl == '${path}/activityEditorial/activityEditorialIndex.do'}">
        <% activityEditorial = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityEditorial/addActivityEditorial.do'}">
        <% addActivityEditorial = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityEditorial/activityEditorialIndex.do?activityState=1'}">
        <% activityEditorialIndex = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityEditorial/returnActivity.do'}">
        <% activityEditorialReturnRecycleButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityEditorial/publishActivity.do'}">
        <% activityEditorialPublishButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityEditorial/deleteActivity.do'}">
        <% activityEditorialDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/toEditRatingsInfo.do'}">
        <% activityEditorialRating = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/editRatingsInfo.do'}">
        <% activityEditorialEditRating = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/information/informationIndex.do'}">
        <% Information = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/contact/contactPage.do'}">
        <% contactIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/comment/commentIndex.do'}">
        <% commentIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/comment/deleteComment.do'}">
        <% commentDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/comment/viewComment.do'}">
        <% commentViewButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/activity/ticketSettings.do'}">
        <% activityTicketSettings = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/spick.do'}">
        <% activityTicketSpick = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityPublisher/preActivityPublisher.do'}">
        <% activityPublisherButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/copyActivity.do'}">
        <% activityCopy= true; %>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityTemplate/activityTemplateIndex.do'}">
        <% activityTemplateIndexButton= true; %>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/function/functionIndex.do'}">
        <% functionIndexButton= true; %>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/terminalUserIndex.do?userIsDisable=1'}">
        <% terminalIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/preAddTerminalUser.do'}">
        <% terminalAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/preEditTerminalUser.do'}">
        <% terminalEditWaiteActiveButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/teamUser/preEditTeamUser.do?tuserIsDisplay=1'}">
        <% teamPreEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/teamUser/preEditTeamUser.do'}">
        <% teamPreWaiteEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/teamUser/activeTeamUser.do'}">
        <% teamActiveButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/preEditTerminalUser.do?userIsDisable=1'}">
        <% terminalEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/freezeTerminalUser.do'}">
        <% terminalFreezeButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/terminalUserIndex.do'}">
        <% terminalWaiteActiveButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/teamUser/viewTeamUser.do?tuserIsDisplay=1'}">
        <% teamViewButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/teamUser/viewTeamUser.do'}">
        <% teamViewWaiteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/disableTerminalUserComment.do'}">
        <% terminalDisableCommentButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/teamUser/teamUserIndex.do'}">
        <% teamWaiteActiveIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/teamUser/preAddTeamUser.do'}">
        <% teamPreAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/teamUser/freezeTeamUser.do'}">
        <% teamFreezeButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/viewTerminalUser.do?userIsDisable=1'}">
        <% terminalViewButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/viewTerminalUser.do'}">
        <% terminalViewWaitButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/activeTerminalUser.do'}">
        <% terminalActiveButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/teamUser/teamUserIndex.do?tuserIsDisplay=1'}">
        <% teamIndexButton = true;%>
    </c:if>


    <c:if test="${module.moduleUrl == '${path}/activity/activityIndex.do?activityState=6'}">
        <% activityIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/recommendActivity.do'}">
        <% activityRecommendCancelButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/order/queryAllUserOrderIndex.do'}">
        <% activityOrderIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/order/orderList.do'}">
        <% activityOrderIndexListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/deleteActivity.do?activityState=1'}">
        <% activityDraftButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/deleteActivity.do?activityState=5'}">
        <% activityRecycleButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/preEditActivity.do?activityState=6'}">
        <% activityPreEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/order/viewOrderDetail.do'}">
        <% activityOrderDetailButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/order/sendSmsMessage.do'}">
        <% activityOrderSendSmsButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/activityIndex.do?activityState=1'}">
        <% activityOrderDraftIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/publishActivity.do'}">
        <% activityPublishDraftButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/returnActivity.do'}">
        <% activityReturnRecycleButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/addActivity.do'}">
        <% activityPublishButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/deleteActivity.do?activityState=6'}">
        <% activityDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/order/updateOrderByActivityOrderId.do'}">
        <% activityOrderCancelButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/preEditActivity.do?activityState=1'}">
        <% activityPreEditDraftButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/activityIndex.do?activityState=5'}">
        <% activityRecycleIndexButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/activity/activityPersonalIndex.do?activityPersonal=1'}">
        <% activityPersonalIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/recommendRelate/recommendActivity.do'}">
        <% apprecommendButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/sensitiveWords/sensitiveWordsIndex.do'}">
        <% sensitiveWordsIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/sensitiveWords/preAddSensitiveWords.do'}">
        <% sensitiveWordsPreAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/sensitiveWords/preEditSensitiveWords.do'}">
        <% sensitiveWordsPreEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/sensitiveWords/deleteSensitiveWords.do'}">
        <% sensitiveWordsFreezeButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/RatingsInfo.do'}">
        <% RatingsInfoButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/sensitiveWords/editRatingsInfo.do'}">
        <% updateRatingsInfoButton = true;%>
    </c:if>

    <%--<!--藏品权限-->--%>
    <c:if test="${module.moduleUrl == '${path}/antique/antiqueIndex.do'}">
        <% antiqueIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/preAddAntique.do'}">
        <% antiquePreAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/preEditAntique.do?type=1'}">
        <% antiquePreEditButtonT1 = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/deleteAntique.do?type=1'}">
        <% antiqueDeleteButtonT1 = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/antiqueIndex.do?antiqueState=1'}">
        <% antiqueIndexButtonA1 = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/preEditAntique.do?type=2'}">
        <% antiquePreEditButtonT2 = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/updateState.do'}">
        <% antiqueUpdateButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/deleteAntique.do?type=2'}">
        <% antiqueDeleteButtonT2 = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/antiqueIndex.do?antiqueState=5'}">
        <% antiqueIndexButtonA5 = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/physicalDelete.do'}">
        <% antiquePhysicalDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antique/recoverAntique.do'}">
        <% antiqueRecoverButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/antiqueType/index.do'}">
        <% antiqueTypeIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antiqueType/preAddAntiqueType.do'}">
        <% antiqueTypePreAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/antiqueType/preEditAntiqueType.do'}">
        <% antiqueTypePreEditButton = true;%>
    </c:if>

    <%--<!--轮播图权限-->--%>

    <c:if test="${module.moduleUrl == '${path}/advert/advertIndex.do'}">
        <% webAdvertIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/advert/appRecommendadvertlist.do'}">
        <% appAdvertIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/advertRecommend/appAdvertRecommendIndex.do'}">
        <% appAdvertRecommendIndexButton = true;%>
    </c:if>


    <c:if test="${module.moduleUrl == '${path}/advert/editAdvertShow.do'}">
        <% advertEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/advert/addAdvertShow.do'}">
        <% advertAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/advert/recovery.do'}">
        <% advertRecoveryButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/advert/recovery.do'}">
        <% recoveryAdvertButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/advert/delete.do'}">
        <% advertDeleteButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/recommend/preCmsListRecommendTag.do'}">
        <% cmsListRecommendTagButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/recommend/activityHomeRecommendIndex.do?platform=APP'}">
        <% activityHomeRecommendIndexButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/recommend/homeNavigationRecommendActivity.do'}">
        <% webHomeNavigationRecommendActivityButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activity/cancelHomeNavigationRecommendActivity.do'}">
        <% webCancleRecommendActivityButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/recommend/appHomeNavigationRecommendActivity.do'}">
        <% appHomeNavigationRecommendActivityButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/recommend/cancelAppHomeNavigationRecommendActivity.do'}">
        <% appCancleRecommendActivityButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/recommendRelate/recommendIndex.do'}">
        <% apprecommendRelateButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/recommendRelate/appHomeNavigationRecommendActivity.do'}">
        <% apprecommendRelateTopButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/recommend/activityHomeRecommendIndex.do?platform=Web'}">
        <% webHomeNavigationRecommendButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/recommend/homeHotRecommendIndex.do'}">
        <% homeHotRecommendButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/recommend/addHomeRecommend.do'}">
        <% homeHotAdd = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/advert/upateIsRecommendAdvert.do'}">
        <% homeHotDelete = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/recommend/homeVenueRecommendIndex.do'}">
        <% homeVenueRecommendIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/recommendVenue.do'}">
        <% recommendVenueButton = true;%>
    </c:if>


    <%--<!--标签权限-->--%>

    <c:if test="${module.moduleUrl == '${path}/tag/tagList.do'}">
        <% tagListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/tag/preTagAdd.do'}">
        <% tagPreAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/tag/preEditTags.do'}">
        <% tagPreEditButton = true;%>
    </c:if>

    <%--<!--hucheng-->--%>

    <c:if test="${module.moduleUrl == '${path}/venue/venueIndex.do'}">
        <% selectVenueListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/preAddVenue.do'}">
        <% addVenueButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/venueDraftList.do'}">
        <% venueDraftListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/venueRecycleList.do'}">
        <% venueRecycleListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/venueCommentIndex.do'}">
        <% venueCommentIndexButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/venue/preEditVenue.do'}">
        <% preEditVenueButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/preDeleteVenue.do'}">
        <% preDeleteVenueButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/venueSeatTemplate/venueSeatTemplateIndex.do'}">
        <% venueSeatTemplateIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/recommendVenue.do?type=yes'}">
        <% recommendVenueButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/recommendVenue.do?type=no'}">
        <% notRecommendVenueButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/venueIndex.do'}">
        <% selectVenueButton = true;%>
    </c:if>
    <%-- <c:if test="${module.moduleUrl == '${path}/venue/addVenue.do?type=Draft'}">
        <% addVenueDraftListButton = true;%>
    </c:if> --%>

    <c:if test="${module.moduleUrl == '${path}/venue/totalDeleteVenue.do'}">
        <% deleteRecycleButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/venue/preEditVenue.do?type=Draf'}">
        <% preEditDrafButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/venue/backVenue.do'}">
        <% backVenueButton = true;%>
    </c:if>
    <%-- <c:if test="${module.moduleUrl == '${path}/venue/preAssignManager.do'}">
        <% preAssignManagerButton = true;%>
    </c:if> --%>
    <%-- <c:if test="${module.moduleUrl == '${path}/venue/preViewAssign.do'}">
        <% preViewAssignButton = true;%>
    </c:if> --%>
    <c:if test="${module.moduleUrl =='${path}/comment/commentTopTrue.do'}">
        <% commentTopTrueButton = true; %>
    </c:if>
    <c:if test="${module.moduleUrl =='${path}/comment/commentTopFalse.do'}">
        <% commentTopFalseButton = true; %>
    </c:if>
    <c:if test="${module.moduleUrl =='${path}/comment/deleteComment.do?commentType=1'}">
        <% commentDelButton = true; %>
    </c:if>
    <c:if test="${module.moduleUrl =='${path}/venue/deleteVenue.do'}">
        <% preDelDrafButton = true; %>
    </c:if>
    <c:if test="${module.moduleUrl =='${path}/venue/publishVenue.do'}">
        <% publishVenueDrafButton = true; %>
    </c:if>
    <c:if test="${module.moduleUrl =='${path}/venue/preExtension.do'}">
        <% venueExtensionButton = true; %>
    </c:if>


    <c:if test="${module.moduleUrl == '${path}/sysdict/dictIndex.do'}">
        <% dictIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/sysdict/preSaveSysDict.do'}">
        <% preSaveSysDictButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/sysdict/dictDel.do'}">
        <% deleteDictButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/sysdict/updateEdit.do'}">
        <% editDictButton = true;%>
    </c:if>

    <%--<!-- 活动室权限管理列表  begin  -->--%>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/activityRoomIndex.do'}">
        <% activityRoomIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/preAddActivityRoom.do'}">
        <% activityRoomAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/preEditActivityRoom.do'}">
        <% activityRoomEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/preDeleteActivityRoom.do'}">
        <% activityRoomDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/moveActivityRoom.do'}">
        <% activityRoomMoveButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/addActivityRoom.do?type=draft'}">
        <% activityRoomSaveToDraftButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/roomDraftList.do'}">
        <% activityRoomDraftIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/preEditActivityRoom.do?type=draft'}">
        <% activityRoomDraftEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/deleteActivityRoom.do'}">
        <% activityRoomDraftDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/roomRecycleList.do'}">
        <% activityRoomRecycleIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/deleteRoomRecycle.do'}">
        <% activityRoomRecycleDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityRoom/backActivityRoom.do'}">
        <% activityRoomRecycleBackButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/cmsRoomOrder/queryAllRoomOrderList.do'}">
        <% activityRoomOrderIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/cmsRoomOrder/cancelRoomOrder.do'}">
        <% activityRoomOrderCancleButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/cmsRoomOrder/deleteRoomOrder.do'}">
        <% activityRoomOrderDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/cmsRoomOrder/sendSmsMessage.do'}">
        <% activityRoomOrderSendSmsButton = true;%>
    </c:if>
    <%--<!-- 活动室权限管理列表  end  -->--%>

    <c:if test="${module.moduleUrl == '${path}/recommend/recommendIndex.do'}">
        <% recommendIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/recommend/cancelRecommend.do'}">
        <% recommendCancleButton = true;%>
    </c:if>

    <%--<!-- 站点管理权限列表 begin  -->--%>
    <c:if test="${module.moduleUrl == '${path}/user/sysUserIndex.do'}">
        <% sysUserIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/user/preAddSysUser.do'}">
        <% sysUserAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/user/preEditSysUser.do'}">
        <% sysUserEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/user/deleteSysUser.do'}">
        <% sysUserDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/user/viewSysUser.do'}">
        <% sysUserViewButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/role/allRole.do'}">
        <% sysUserAllRoleButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/role/roleIndex.do'}">
        <% roleIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/role/preAddRole.do'}">
        <% roleAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/role/deleteRole.do'}">
        <% roleDeleteButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/role/preEditRole.do'}">
        <% rolePreEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/role/viewRole.do'}">
        <% roleViewButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/module/moduleIndex.do'}">
        <% moduleIndexButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/dept/deptIndex.do'}">
        <% departmentIndexButton = true;%>
    </c:if>
    <%-- <c:if test="${module.moduleUrl == '${path}/module/moduleIndex.do'}">
        <% departmentEditButton=true;%>
    </c:if> --%>

    <c:if test="${module.moduleUrl == '${path}/module/preInitModule.do'}">
        <% preInitModuleButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/feedInformation/feedIndex.do'}">
        <% userFanKuiButton = true;%>
    </c:if>
    <%--<!-- 站点管理权限列表 end  -->--%>

    <c:if test="${module.moduleUrl == '${path}/message/messageIndex.do'}">
        <% messageIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/message/preAddMessage.do'}">
        <% messageAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/message/preEditMessage.do'}">
        <% messageEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/appSetting/appSettingIndex.do'}">
        <% appSettingIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/vote/activityVoteIndex.do'}">
        <% activityVoteIndexButton = true;%>
    </c:if>

    <%--<!-- 手机版本管理  -->--%>
    <c:if test="${module.moduleUrl == '${path}/androidVersion/androidVersionIndex.do'}">
        <% androidVersionIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/androidVersion/preAddAndroidVersion.do'}">
        <% androidVersionAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/androidVersion/preEditAndroidVersion.do'}">
        <% androidVersionEditButton = true;%>
    </c:if>

    <%--<!-- 互动管理  -->--%>
    <c:if test="${module.moduleUrl == '${path}/questionAnwser/questionAnwserIndex.do'}">
        <% questionAnwserIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/questionAnwser/preAddQuestionAnwser.do'}">
        <% questionAnwserPreAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/questionAnwser/preEditQuestionAnwser.do'}">
        <% questionAnwserPreEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/questionAnwser/deleteQuestionAnwser.do'}">
        <% questionAnwserDeleteButton = true;%>
    </c:if>
    
    
    <%-- 知识问答 --%>
    <c:if test="">
    	 <% questionAnwserDeleteButton = true;%>
    </c:if>
    
     <%--<!-- 展览管理  -->--%>
    <c:if test="${module.moduleUrl == '${path}/exhibition/exhibitionIndex.do'}">
        <% exhibitionIndexButton = true;%>
    </c:if>
    
    <%-- 应用大赛配置 --%>
    <c:if test="${module.moduleUrl == '${path}/applicationContestConfig/index.do'}">
    	<% applicationContestConfigIndexButton= true; %>
    </c:if>

    <%--<!-- 信息共享 -->--%>
    <c:if test="${module.moduleUrl == '${path}/shareDept/shareDeptIndex.do'}">
        <% shareDeptIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/shareDept/preAddShareDept.do'}">
        <% shareDeptPreAddButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/shareDept/cancelShareDept.do'}">
        <% shareDeptCancelButton = true;%>
    </c:if>

    <%--<!-- MC管理 -->--%>
    <c:if test="${module.moduleUrl == '${path}/mcVideo/AddMcVideo.do'}">
        <% mcVideoButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/mcShow/backList.do'}">
        <% mcShowButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/mcNews/mcNewsIndex.do'}">
        <% mcNewsButton = true;%>
    </c:if>

    <%--<!-- 培训管理 -->--%>
    <c:if test="${module.moduleUrl == '${path}/peopleTrain/courseList.do'}">
        <% trainButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/peopleTrain/courseList.do'}">
        <% courseButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/peopleTrain/peopleTrainList.do'}">
        <% trianUserListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/peopleTrain/applyList.do'}">
        <% courseOrderButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/peopleTrain/editState.do'}">
        <% courseUpDown = true;%>
    </c:if>
    
    <%--<!-- 配送中心 -->--%>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcStatisticsIndex.do'}">
        <% dcStatisticsIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=1'}">
        <% dcVideoIndex1Button = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=2videoType=舞蹈'}">
        <% dcVideoIndex2wButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=2videoType=合唱'}">
        <% dcVideoIndex2hButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=2videoType=时装'}">
        <% dcVideoIndex2sButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=2videoType=戏曲/曲艺'}">
        <% dcVideoIndex2xButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=3'}">
        <% dcVideoIndex3Button = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=4videoType=舞蹈'}">
        <% dcVideoIndex4wButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=4videoType=合唱'}">
        <% dcVideoIndex4hButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=4videoType=时装'}">
        <% dcVideoIndex4sButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=4videoType=戏曲/曲艺'}">
        <% dcVideoIndex4xButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/dcVideo/dcVideoIndex.do?reviewType=5'}">
        <% dcVideoIndex5Button = true;%>
    </c:if>
    
    <%-- 知识问答 --%>
  	<c:if test="${module.moduleUrl == '${path}/contestTopic/contestQuizIndex.do'}">
  	
  		<% contestQuizIndex=true; %>
  	</c:if>
  	
  	<%-- 线上投票 --%>
  	<c:if test="${module.moduleUrl == '${path}/vote/voteIndex.do'}">
  		<% voteIndex=true;%>
  	</c:if>
  	
  	<%-- 浦东文化社团评选 --%>
  	<c:if test="${module.moduleUrl == '${path}/cultureTeam/cultureTeamIndex.do'}">
  		<% cultureTeamIndexButton=true;%>
  	</c:if>
  	<%-- 舞蹈大赛 --%>
  	<c:if test="${module.moduleUrl == '${path}/cnwdEntryform/cnwdEntryformList.do'}">
  		<% cnwdEntryformButton=true;%>
  	</c:if>
  	<c:if test="${module.moduleUrl == '${path }/cnwdEntryform/viewCnwdEntryform.do'}">
  		<% viewCnwdEntryformButton=true;%>
  	</c:if>
  	<c:if test="${module.moduleUrl == '${path}/cnwdEntryform/check.do'}">
  		<% checkCnwdEntryformButton=true;%>
  	</c:if>
</c:forEach>
<%
    }
%>
