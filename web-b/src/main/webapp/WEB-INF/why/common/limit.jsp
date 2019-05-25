<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<%
    /*数据统计按钮控制*/
    boolean whyStatistics = false;

	/*联系我们管理权限按钮控制*/
    boolean contactIndexButton = false;
    boolean templateTopicButton = false;

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
    boolean activityOrderRefundSuccessButton = false;
    boolean activityPublishDraftButton = false;
    boolean activityReturnRecycleButton = false;
    boolean activityPublishButton = false;
    boolean activityDeleteButton = false;
    boolean activityOrderCancelButton = false;
    boolean activityPreEditDraftButton = false;
    boolean activityRecycleIndexButton = false;
    boolean apprecommendButton = false;
    boolean RatingsInfoButton = false;
    boolean updateRatingsInfoButton = false;
    boolean activityTicketSettings=false;
    boolean activityTicketSpick=false;
    boolean activityPublisherButton=false;
    boolean activityCopy=false;

    /*培训*/
    boolean addTrainButton = false;
    boolean trainListButton = false;
    boolean trainDraftButton = false;
    boolean trainOrderButton = false;
    boolean trainCommentPreListButton = false;
    boolean allTrainOrderListButton = false;
    /*boolean trainEnrolmentButton = false;*/


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
    boolean moveVenueButton = false;// 场馆上下架
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

    boolean preInitModuleButton = false; //权限初始化
    boolean userFanKuiButton = false; //用户反馈

    boolean messageIndexButton = false;
    boolean messageAddButton = false;
    boolean messageEditButton = false;

    /*  增减资讯模块用 */
    boolean informationModuleButton = false;

    /*非遗管理*/
    boolean heritageIndexButton=false;
    
    /*文化志愿者管理*/
    boolean volunteerIndexButton=false;
    
    // 用户行为分析
    boolean userbehaviorAnalysisButton=false;
    
    /*信息共享*/
    boolean shareDeptIndexButton = false;
    boolean shareDeptPreAddButton = false;
    boolean shareDeptCancelButton = false;
    
    /*上传近义词*/
    boolean importNearSynonym=false;
    
  	/*社团管理*/
  	boolean assnIndexButton = false;
  	boolean assnApplyIndexButton = false;
    boolean assnExamineIndexButton = false;
    boolean distributionButton = false;
    boolean assnMemberIndexButton = false;
    boolean recruitApplyIndexButton = false;

  	/*取票机管理*/
  	boolean ticketMachineIndex=false;
  	
  	/*后台发送短信*/
  	boolean sendSMSIndex=false;
  	
  	/*志愿者场馆管理*/
  	boolean volunteerVenueManageIndex=false;
  	
  	/*艺术鉴赏管理*/
    boolean virtuosityIndex=false;

    /*知识问答*/
    boolean contestQuizIndex= false;
    /*线上投票*/
    boolean voteIndex = false;
    /*展览管理*/
    boolean exhibitionIndexButton = false;
    /*应用大赛配置*/
    boolean applicationContestConfigIndexButton = false;
  	     
    /*文化文物*/
    boolean bpAntiqueIndexButton = false;    //文化文物管理
    boolean bpAntiquePrePublishButton = false;    //发布文化文物
    boolean bpAntiqueListButton = false;    	//文化文物列表
    boolean bpAntiquePreEditButtonT1 = false;      //编辑文化文物
    boolean bpAntiqueDeleteButtonT1 = false;        //删除文化文物
    
    /*文化商城*/
    boolean bpProductIndexButton = false;    //文化商城
    boolean bpProductPrePublishButton = false;    //发布文化商城
    boolean bpProductListButton = false;    	//文化商城列表
    boolean bpProductPreEditButton = false;      //编辑文化商城
    boolean bpProductDeleteButton = false;        //删除文化商城
    
    /*人文佛山*/
    boolean beipiaoInfoListButton=false;
    boolean beipiaoInfoAddButton=false;
    boolean beipiaoCarouselListButton=false;
    boolean beipiaoInfoTagListButton=false;
    boolean beipiaoReportListButton=false;

    /*艺术鉴赏*/
    boolean ysjsButton = false ;

    /*影视天地*/
    boolean ystdButton = false ;

    /*文化创意*/
    boolean whcyButton = false ;

    boolean infoPutawayButton=false;
    boolean infoSoldoutButton=false;
    
    /*文化联盟*/
    boolean leagueCarouselButton=false;
    boolean leagueListButton=false;
    boolean memberListButton=false;
    boolean leagueTypeListButton=false;
    
    /* 文化点单 */
    boolean orderAttendListBtn = false;
    boolean orderAttendOrderListBtn = false;
    boolean orderInviteListBtn = false;
    boolean orderInviteOrderListBtn = false;
    
    boolean orderPutawayButton=false;
    boolean orderSoldoutButton=false;
%>

<%
    if (session.getAttribute("user") != null) {
%>
<c:forEach items="${sessionScope.user.sysModuleList}" var="module">

    <c:if test="${module.moduleUrl == '${path}/activityStatistics/activityAreaStatisticsIndex.do'}">
        <% whyStatistics = true;%>
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
    <c:if test="${module.moduleUrl == '${path}/order/refundSuccess.do'}">
    	<% activityOrderRefundSuccessButton= true; %>
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
    <c:if test="${module.moduleUrl == '${path}/activity/copyActivity.do'}">
    	<% activityCopy= true; %>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/activityPublisher/preActivityPublisher.do'}">
        <% activityPublisherButton = true;%>
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
    <c:if test="${module.moduleUrl == '${path}/ccpInformationModule/informationModuleIndex.do'}"><% informationModuleButton=true; %></c:if>
    
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
    <c:if test="${module.moduleUrl == '${path}/venue/moveVenue.do'}">
    	<% moveVenueButton = true; %>
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
       
    <%-- 非遗管理 --%>
    <c:if test="${module.moduleUrl == '${path}/heritage/heritageIndex.do'}">
    	<% heritageIndexButton=true; %>
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

    <%-- 社团管理 --%>
    <%--<c:if test="${module.moduleUrl == '${path}/association/assnIndex.do'}">--%>
        <%--<% assnIndexButton = true;%>--%>
    <%--</c:if>--%>
    <%--<c:if test="${module.moduleUrl == '${path}/association/associationApplyIndex.do'}">--%>
        <%--<% assnApplyIndexButton = true;%>--%>
    <%--</c:if>--%>
    <%-- 社团管理 --%>
    <c:if test="${module.moduleUrl == '${path}/association/assnIndex.do'}">
        <% assnIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/association/associationApplyIndex.do'}">
        <% assnApplyIndexButton = true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/association/examine.do'}">
        <% assnExamineIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == 'association/user/preAddSysUser.do'}">
        <% distributionButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/association/assnIndex.do?userId='}">
        <% assnMemberIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/association/recruitApplyIndex.do'}">
        <% recruitApplyIndexButton = true;%>
    </c:if>
      
    <%-- 文化志愿者管理 --%>
    <c:if test="${module.moduleUrl == '${path}/volunteer/volunteerApplyIndex.do'}">
    	<% volunteerIndexButton=true; %>
    </c:if>
    
    <%-- 上传近义词 --%>
    <c:if test="${module.moduleUrl == '${path}/nearSynonym/nearSynonymIndex.do'}">
    	<% importNearSynonym= true; %>
    </c:if>
    
    <%-- 用户行为分析 --%>
    <c:if test="${module.moduleUrl == '${path}/terminalUser/userbehaviorAnalysisIndex.do'}">
    	<% userbehaviorAnalysisButton= true; %>
    </c:if>
  
  <%-- 取票机管理 --%>
  	<c:if test="${module.moduleUrl == '${path}/ticketMachine/list.do'}">
  	
  		<% ticketMachineIndex=true; %>
  	</c:if>  	  	
  	
  	<%-- 后台发送短信 --%>
  	<c:if test="${module.moduleUrl == '${path}/sendSMS/sendSMSIndex.do'}">
  		<% sendSMSIndex=true; %>
  	</c:if>
  	
  	<%-- 志愿者场馆管理--%>
  	<c:if test="${module.moduleUrl == '${path}/volunteerVenueManage/volunteerVenueManageIndex.do'}">
  		<% volunteerVenueManageIndex=true; %>
  	</c:if>
  	
  	<%-- 艺术鉴赏管理 --%>
    <c:if test="${module.moduleUrl == '${path}/virtuosity/virtuosityIndex.do'}">
    	<% virtuosityIndex=true; %>
    </c:if>

    <%-- 文化文物--%>
    <c:if test="${module.moduleUrl == '${path}/bpAntique/antiqueIndex.do'}">
        <% bpAntiqueIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/bpAntique/prePublishAntique.do'}">
        <% bpAntiquePrePublishButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/bpAntique/antiqueList.do'}">
        <% bpAntiqueListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/bpAntique/preEditAntique.do'}">
        <% bpAntiquePreEditButtonT1 = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/bpAntique/deleteAntique.do'}">
        <% bpAntiqueDeleteButtonT1 = true;%>
    </c:if>
    
    <%-- 文化商城--%>
    <c:if test="${module.moduleUrl == '${path}/bpProduct/productIndex.do'}">
        <% bpProductIndexButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/bpProduct/prePublishProduct.do'}">
        <% bpProductPrePublishButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/bpProduct/productList.do'}">
        <% bpProductListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/bpProduct/preEditProduct.do'}">
        <% bpProductPreEditButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/bpProduct/deleteProduct.do'}">
        <% bpProductDeleteButton = true;%>
    </c:if>
    
    <%-- 动态资讯 --%>
    <c:if test="${module.moduleUrl == '${path}/beipiaoInfo/addPage.do'}">
      	<% beipiaoInfoListButton=true; %>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/beipiaoInfo/infoList.do'}">
      <% beipiaoInfoAddButton=true; %>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/beipiaoInfo/infoList.do'}">
      <% beipiaoCarouselListButton=true; %>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/beipiaoInfoTag/tagList.do'}">
      <% beipiaoInfoTagListButton=true; %>
    </c:if>  
    <c:if test="${module.moduleUrl == '${path}/beipiaoInfoReport/reportList.do'}">
      <% beipiaoReportListButton=true; %>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/beipiaoInfo/infoList.do?module=YSJS'}">
        <% ysjsButton=true; %>
    </c:if>

<%--    <c:if test="${module.moduleUrl == '${path}/beipiaoInfo/infoList.do?module=YSTD'}">
        <% ystdButton=true; %>
    </c:if>--%>

    <c:if test="${module.moduleUrl == '${path}/beipiaoInfo/infoList.do?module=WHCY'}">
        <% whcyButton=true; %>
    </c:if>
    
    <c:if test="${module.moduleUrl == '${path}/beipiaoInfo/changeInfoStatus.do?infoStatus=1'}">
      <% infoPutawayButton=true; %>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/beipiaoInfo/changeInfoStatus.do?infoStatus=0'}">
      <% infoSoldoutButton=true; %>
    </c:if>

    <%-- 知识问答 --%>
    <c:if test="${module.moduleUrl == '/contestTopic/contestQuizIndex.do'}">
        <% contestQuizIndex=true; %>
    </c:if>
    <%-- 线上投票 --%>
    <c:if test="${module.moduleUrl == '/vote/voteIndex.do'}">
        <% voteIndex=true;%>
    </c:if>
    <%--<!-- 展览管理  -->--%>
    <c:if test="${module.moduleUrl == '/exhibition/exhibitionIndex.do'}">
        <% exhibitionIndexButton = true;%>
    </c:if>
    <%-- 应用大赛配置 --%>
    <c:if test="${module.moduleUrl == '/applicationContestConfig/index.do'}">
        <% applicationContestConfigIndexButton= true; %>
    </c:if>
    <%-- 专题模板管理 --%>
    <c:if test="${module.moduleUrl == '${path}/template/templateIndex.do'}">
        <% templateTopicButton = true;%>
    </c:if>
     <%-- 文化联盟 --%>
    <c:if test="${module.moduleUrl == '${path}/beipiaoCarousel/carouselList.do?carouselType=2'}">
        <% leagueCarouselButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/league/list.do'}">
        <% leagueListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/member/list.do'}">
        <% memberListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/tag/tagList.do?tagType=7'}">
        <% leagueTypeListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/culturalOrder/culturalOrderList.do?culturalOrderLargeType=1'}"><% orderAttendListBtn = true;%></c:if>
    <c:if test="${module.moduleUrl == '${path}/culturalOrderOrder/culturalOrderOrderList.do?culturalOrderLargeType=1'}"><% orderAttendOrderListBtn = true;%></c:if>
    <c:if test="${module.moduleUrl == '${path}/culturalOrder/culturalOrderList.do?culturalOrderLargeType=2'}"><% orderInviteListBtn = true;%></c:if>
    <c:if test="${module.moduleUrl == '${path}/culturalOrderOrder/culturalOrderOrderList.do?culturalOrderLargeType=2'}"><% orderInviteOrderListBtn = true;%></c:if>
    <c:if test="${module.moduleUrl == '${path}/culturalOrder/setCulturalOrderStatus.do?status=1'}">
      <% orderPutawayButton=true; %>
    </c:if>
    <c:if test="${module.moduleUrl == '${path}/culturalOrder/setCulturalOrderStatus.do?status=0'}">
      <% orderSoldoutButton=true; %>
    </c:if>

    <%-- 培训管理 start--%>
    <%-- 发布培训 --%>
    <c:if test="${module.moduleUrl == '/train/add.do'}">
        <% addTrainButton = true;%>
    </c:if>
    <%-- 培训列表 --%>
    <c:if test="${module.moduleUrl == '/train/trainList.do?trainStatus=1'}">
        <% trainListButton = true;%>
    </c:if>
    <%-- 培训草稿箱 --%>
    <c:if test="${module.moduleUrl == '/train/trainList.do?trainStatus=2'}">
        <% trainDraftButton = true;%>
    </c:if>
    <%-- 报名管理 --%>
    <c:if test="${module.moduleUrl == '/train/trainOrderList.do'}">
        <% trainOrderButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '/train/trainCommentPreList.do'}">
        <% trainCommentPreListButton = true;%>
    </c:if>
    <c:if test="${module.moduleUrl == '/train/allTrainOrderList.do'}">
        <% allTrainOrderListButton = true;%>
    </c:if>
    <%--    <c:if test="${module.moduleUrl == '/train/trainEnrolment.do'}">
            <% trainEnrolmentButton = true;%>
        </c:if>--%>
    <%-- 培训管理 end--%>
</c:forEach>
<%
    }
%>
