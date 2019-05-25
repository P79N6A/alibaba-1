<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 更多 -->
<div class="right">
    <h1 class="title">精彩推荐</h1>
    <ul>
        <c:forEach items="${recommendList}" var="info">
            <li>
                <div class="img"><a href="${path}/zxInformation/informationDetail.do?informationId=${info.informationId}" class="img"><img src="${info.informationIconUrl}" width="100%" height="149"></img></a></div>
                <div class="p">${info.informationTitle }</div>
            </li>
        </c:forEach>
    </ul>
</div>

<!--  评论 -->
<div class="left the_two">
    <div class="comment mt20 clearfix" id="divActivityComment" style="display: block;">
        <a name="comment"></a>
        <div class="comment-tit">
            <h3>我要评论</h3><span id="commentCount">${info.commentCount }条评论</span>
        </div>
        <form id="commentForm">
            <input type="hidden" value="${pageContext.session.id}" id="sessionId"/>
            <%
                String userMobileNo = "";
                if(session.getAttribute("terminalUser") != null){
                    CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
                    if(StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
                        userMobileNo = terminalUser.getUserMobileNo();
                    }else{
                        userMobileNo = "0000000";
                    }
                }
            %>
            <input type="hidden" id="userMobileNo" value="<%=userMobileNo%>"/>
            <textarea class="text" name="commentRemark" id="commentRemark" maxLength="200"></textarea>
            <div class="tips">
                <div class="fl wimg">
                    <input type="hidden" name="commentImgUrl" id="headImgUrl" value=""/>
                    <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                    <div id="imgHeadPrev" style="position: relative; overflow: hidden;  float: left;">
                    </div>
                    <div style="float: left; margin-top: 0px;">
                        <div>
                            <input type="file" name="file" id="file"/>
                        </div>
                        <div class="comment_message" style="display: none">(最多三张图片)</div>
                        <div id="fileContainer" style="display: none;"></div>
                        <div id="btnContainer" style="display: none;"></div>
                    </div>
                </div>
                <div class="fr r_p">
                    <p style="color:#999999;">文明上网理性发言，请遵守新闻评论服务协议</p>
                    <input type="button" class="btn" value="发表评论" id="commentButton" onclick="addComment(20)"/>
                </div>
                <div class="clear"></div>
            </div>
        </form>
        <div class="comment-list" id="comment-list-div">
            <ul id="commentUl">

            </ul>
            <c:if test="${commentCount >= 5}">
                <a href="javascript:;" class="load-more" onclick="moreComment(20)" id="viewMore">查看更多...</a>
                <input type="hidden" id="commentPageNum" value="1"/>
            </c:if>
        </div>
    </div>
</div>
</div>