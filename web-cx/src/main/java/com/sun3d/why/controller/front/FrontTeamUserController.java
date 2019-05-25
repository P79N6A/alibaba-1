package com.sun3d.why.controller.front;

import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.service.*;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.CmsSensitive;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 团队会员前台请求处理控制层
 * 负责跟页面数据的交互以及对下层的数据方法的调用
 * <p/>
 * Created by cj on 2015/4/24.
 */
@Controller
@RequestMapping(value = "/frontTeamUser")
public class FrontTeamUserController {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(FrontTeamUserController.class);
    /**
     * 自动注入团体业务层service实例
     */
    @Autowired
    private CmsTeamUserService cmsTeamUserService;
    /**
     * 自动注入数据字典业务层service实例
     */


    @Autowired
    private SysDictService sysDictService;

    @Autowired
    private CmsTagService tagService;

    @Autowired
    private SysDictService dictService;

    @Autowired
    private StatisticService statisticService;

    @Autowired
    private CmsCommentService commentService;

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private CmsApplyJoinTeamService applyJoinTeamService;



    @Autowired
    private HttpSession session;
    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;
    /**
     * 团体前台页面首页
     *
     * @author qww
     * @date 2015-05-05
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/groupIndex")
    public ModelAndView groupIndex(CmsTeamUser user,Pagination page) {
        //创建一个ModelAndView对象，代表了MVC Web程序中Model与View的对象
        //view代表跳转的页面，model代表传到前台的数据
        ModelAndView model = new ModelAndView();
        try{
            // 推荐标签


            model.addObject("tuserName", user.getTuserName());
        }catch (Exception e){
            logger.info("groupIndex error"+ e);
        }
        model.addObject("page", page);
        model.setViewName("index/group/groupIndex");
        return model;
    }

    /**
     * 前端2.0团体首页
     * @param user
     * @return
     */
    @RequestMapping(value = "/teamUserList")
    public ModelAndView teamUserList(CmsTeamUser user) {
        //创建一个ModelAndView对象，代表了MVC Web程序中Model与View的对象
        //view代表跳转的页面，model代表传到前台的数据
        ModelAndView model = new ModelAndView();
        try{
            SysDict sysDict = new SysDict();
            sysDict.setDictCode(Constant.TAG_TYPE);
            sysDict.setDictName("团体");
            SysDict dict = sysDictService.querySysDict(sysDict);
            List<CmsTag> list = tagService.queryCmsTagByCondition(dict.getDictId(), 20);
            model.addObject("tagList", list);
            model.addObject("tuserName", user.getTuserName());
        }catch (Exception e){
            logger.info("teamUserList error"+ e);
        }
        model.setViewName("index/group/groupList");
        return model;
    }

    /**
     * 前端2.0团体首页
     *
     * @author qww
     * @date 2015-05-05
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/teamUserLoadList")
    public String teamUserLoadList(CmsTeamUser user,Pagination page,String tagId,Integer sortType,HttpServletRequest request) {
        try {
            page.setRows(20);
            List<CmsTeamUser> list = cmsTeamUserService.queryFrontTeamUserByCondition(user,tagId,page, null);
            request.setAttribute("list", list);
            request.setAttribute("page", page);
        } catch (Exception e) {
            logger.error("teamUserLoadList error", e);
        }
        return "index/group/groupListLoad";
    }

    /**
     * 前端2.0团体列表
     *
     * @author qww
     * @date 2015-05-05
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/teamUserListLoadList")
    public String teamUserListLoadList(CmsTeamUser user,Integer sortType,Pagination page,HttpServletRequest request) {
        try {
            page.setRows(20);
            List<CmsTeamUser> list = cmsTeamUserService.queryFrontTeamUserListByCondition(user,sortType,page,null);
            request.setAttribute("list", list);
            request.setAttribute("page", page);
        } catch (Exception e) {
            logger.error("teamUserListLoadList error", e);
        }
        return "index/group/groupListLoad";
    }

    /**
     * 前端2.0团体详情页
     *
     * @author qww
     * @date 2015-05-05
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/groupDetail")
    public String groupDetail(String tuserId,HttpServletRequest request) {
        try{
            CmsTeamUser user = cmsTeamUserService.queryTeamUserById(tuserId);
            // 得到标签
            String tuserCrowdTag = "";
            String tuserPropertyTag = "";
            String tuserSiteTag = "";
            if(StringUtils.isNotBlank(user.getTuserCrowdTag())){
                tuserCrowdTag = user.getTuserCrowdTag();
            }
            if(StringUtils.isNotBlank(user.getTuserPropertyTag())){
                tuserPropertyTag = user.getTuserPropertyTag();
            }
            if(StringUtils.isNotBlank(user.getTuserSiteTag())){
                tuserSiteTag = user.getTuserSiteTag();
            }
            List<CmsTag> tagList = tagService.queryTeamTags(tuserCrowdTag+tuserPropertyTag+tuserSiteTag);
            // 得到字典(位置)
            SysDict dict = dictService.querySysDictByDictId(user.getTuserLocationDict());

            CmsStatistics statistics = statisticService.queryStatistics(tuserId, Constant.COLLECT_TEAMUSER);


            // 推荐团体
            Pagination page = new Pagination();
            page.setRows(3);
            List<CmsTeamUser> list = cmsTeamUserService.queryRecommentTeamUser(user,page);

            // 前端2.0已审核评论数
            CmsComment comment = new CmsComment();
            comment.setCommentRkId(user.getTuserId());
            comment.setCommentType(Constant.TYPE_TEAM_USER);
            int count = commentService.queryCommentCountByCondition(comment);

            int applyJoinCount = 0;
            if(session.getAttribute(Constant.terminalUser) != null){
                CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
                CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
                applyJoinTeam.setTuserId(tuserId);
                applyJoinTeam.setUserId(terminalUser.getUserId());
                applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_PASS);
                // 已经加入个数(已审核通过的个数)
                applyJoinCount = applyJoinTeamService.queryApplyJoinTeamCount(applyJoinTeam);
            }

            // 已加入该团体的个数
            CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
            applyJoinTeam.setTuserId(tuserId);
            applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_PASS);
            int alreadyApplyCount = applyJoinTeamService.queryApplyJoinTeamCount(applyJoinTeam);

            // 管理人
            String userNickName = terminalUserService.queryUserNickNameByTuserId(tuserId);

            request.setAttribute("userNickName", userNickName);
            request.setAttribute("alreadyApplyCount", alreadyApplyCount);
            request.setAttribute("applyJoinCount", applyJoinCount);
            request.setAttribute("commentCount",count);
            request.setAttribute("teamUser",user);
            request.setAttribute("statistics", statistics);
            request.setAttribute("tagList", tagList);
            request.setAttribute("dict", dict);
            request.setAttribute("list",list);
        }catch (Exception e){
            e.printStackTrace();
           logger.info("groupDetail error", e);
        }
        return "index/group/groupDetail";
    }

    /**
     * 验证是否已经申请过了
     * @param applyJoinTeam
     * @return
     */
    @RequestMapping(value = "/checkIsApply")
    @ResponseBody
    public boolean checkIsApply(CmsApplyJoinTeam applyJoinTeam) {
        int count = applyJoinTeamService.queryApplyJoinTeamCount(applyJoinTeam);
        return count > 0 ? true : false;
    }

    //前端2.0 评论列表
    @RequestMapping(value = "/commentList")
    @ResponseBody
    public List<CmsComment> commentList(String tuserId,Integer pageNum) {
        //评论列表
        CmsComment cmsComment = new CmsComment();
        cmsComment.setCommentRkId(tuserId);
        cmsComment.setCommentType(Constant.TYPE_TEAM_USER);
        Pagination page = new Pagination();
        page.setRows(10);
        page.setPage(pageNum);
        List<CmsComment> commentList = commentService.queryCommentByCondition(cmsComment, page,null);
        return commentList;
    }

    /**
     * 前端2.0 添加评论
     * @param comment
     * @param tuserId
     * @return
     */
    @RequestMapping(value = "/addComment")
    @ResponseBody
    public String addComment(CmsComment comment,String tuserId) {
        try{
            if(session.getAttribute("terminalUser") != null){
                String sensitiveWords= CmsSensitive.sensitiveWords(comment, cmsSensitiveWordsMapper);
                if(StringUtils.isNotBlank(sensitiveWords) && sensitiveWords.equals("sensitiveWords")){
                    return  Constant.SensitiveWords_EXIST;
                }

                CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
                comment.setCommentUserId(user.getUserId());
                comment.setCommentType(Constant.TYPE_TEAM_USER);
                comment.setCommentRkId(tuserId);
                return commentService.addComment(comment);
            }
        }catch (Exception e){
            logger.info("addComment error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 前端2.0 团体申请弹出框
     * @return
     */
    @RequestMapping(value = "/groupJoin")
    public String groupJoin(HttpServletRequest request, String tuserId) {
        try {
            if(session.getAttribute("terminalUser") != null){
                CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
                CmsTerminalUser teaminalUser = terminalUserService.queryTerminalUserById(user.getUserId());
                request.setAttribute("terminalUser", teaminalUser);
            }
        }catch (Exception e){
            logger.info("groupJoin error", e);
        }

        request.setAttribute("tuserId", tuserId);
        return "index/group/groupJoin";
    }

    /**
     * 前端2.0 我管理的团体
     * @return
     */
    @RequestMapping(value = "/userGroupIndex")
    public String userGroupIndex() {
        return "index/userCenter/userGroupIndex";
    }

    /**
     * 前端2.0 我管理的团体
     * @return
     */
    @RequestMapping(value = "/userGroupIndexLoad")
    public String userGroupIndexLoad(CmsApplyJoinTeam applyJoinTeam, Pagination page,HttpServletRequest request) {
        try{
            page.setRows(6);
            List<CmsTeamUser> teamUsers = cmsTeamUserService.queryMyManagerTeamUser(applyJoinTeam, page, null);
            request.setAttribute("teamUsers", teamUsers);
            request.setAttribute("page", page);
        }catch (Exception e){
            logger.info("userGroupIndexLoad error", e);
        }
        return "index/userCenter/userGroupIndexLoad";
    }

    /**
     * 前端2.0 我管理的团体 --> 得到该团体下的标签
     * @return
     */
    @RequestMapping(value = "/getTagName")
    @ResponseBody
    public List<CmsTag> getTagName(String tagIds) {
        return tagService.queryTeamTags(tagIds);
    }

    /**
     * 前端2.0 我管理的团体 --> 得到该团体下的标签
     * @return
     */
    @RequestMapping(value = "/getDictName")
    @ResponseBody
    public SysDict getDictName(String dictId) {
        return dictService.querySysDictByDictId(dictId);
    }

    /**
     * 前端2.0 编辑我管理的团体
     * @return
     */
    @RequestMapping(value = "/userGroupEdit")
    public String userGroupEdit(String tuserId, HttpServletRequest request) {
        try{
            CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
            applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_PASS);
            applyJoinTeam.setTuserId(tuserId);
            // 得到该团体下的会员个数
            int count = applyJoinTeamService.queryApplyJoinTeamCount(applyJoinTeam);
            // 得到团体
            CmsTeamUser teamUser = cmsTeamUserService.queryTeamUserById(tuserId);
            // 得到所有标签


            request.setAttribute("count", count);
            request.setAttribute("teamUser", teamUser);
            //request.setAttribute("list", list);
        }catch (Exception e){
            logger.info("userGroupEdit error", e);
        }
        return "index/userCenter/userGroupEdit";
    }

    /**
     * 前端2.0 编辑我管理的团体
     * @return
     */
    @RequestMapping(value = "/saveUserGroupEdit")
    public String saveUserGroupEdit(CmsTeamUser teamUser) {
        try{
            cmsTeamUserService.editFrontTeamUser(teamUser);
        }catch (Exception e){
            logger.info("saveUserGroupEdit error", e);
        }
        return "index/userCenter/userGroupIndex";
    }

    /**
     * 前端2.0 成员管理
     * @return
     */
    @RequestMapping(value = "/userGroupManager")
    public String userGroupManager(String tuserId,HttpServletRequest request) {
        request.setAttribute("tuserId", tuserId);
        return "index/userCenter/userGroupManager";
    }

    /**
     * 前端2.0 成员管理
     * @return
     */
    @RequestMapping(value = "/userGroupManagerLoad")
    public String userGroupManagerLoad(CmsApplyJoinTeam applyJoinTeam, Pagination page,HttpServletRequest request) {
        try{
            List<CmsTeamUser> teamUsers = cmsTeamUserService.queryMyManagerTeamUser(applyJoinTeam, page, null);
            request.setAttribute("teamUsers", teamUsers);
            request.setAttribute("page", page);
        }catch (Exception e){
            logger.info("userGroupManagerLoad error", e);
        }
        return "index/userCenter/userGroupManagerLoad";
    }

    /**
     * 前端2.0 我管理的团体 --> 拒绝加入
     * @return
     */
    @RequestMapping(value = "/refuseApplyJoinTeam")
    @ResponseBody
    public String refuseApplyJoinTeam(CmsApplyJoinTeam applyJoinTeam) {
        try{
            if(applyJoinTeam != null){
                return cmsTeamUserService.refuseApplyJoinTeam(applyJoinTeam);
            }
        }catch (Exception e){
            logger.info("refuseApplyJoinTeam error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 前端2.0 我管理的团体 --> 通过审核
     * @return
     */
    @RequestMapping(value = "/checkApplyJoinTeamPass")
    @ResponseBody
    public String checkApplyJoinTeamPass(CmsApplyJoinTeam applyJoinTeam) {
        try{
            if(applyJoinTeam != null){
                return cmsTeamUserService.checkApplyJoinTeamPass(applyJoinTeam);
            }
        }catch (Exception e){
            logger.info("checkApplyJoinTeamPass error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 前端2.0 我管理的团体 --> 退出团体
     * @return
     */
    @RequestMapping(value = "/quitApplyJoinTeam")
    @ResponseBody
    public String quitApplyJoinTeam(CmsApplyJoinTeam applyJoinTeam) {
        try{
            if(applyJoinTeam != null){
                return cmsTeamUserService.quitApplyJoinTeam(applyJoinTeam);
            }
        }catch (Exception e){
            logger.info("quitApplyJoinTeam error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 前端2.0 消息审核
     * @return
     */
    @RequestMapping(value = "/userGroupAuditing")
    public String userGroupAuditing(String tuserId,HttpServletRequest request) {
        request.setAttribute("tuserId", tuserId);
        return "index/userCenter/userGroupAuditing";
    }

    /**
     * 前端2.0 消息审核
     * @return
     */
    @RequestMapping(value = "/userGroupAuditingLoad")
    public String userGroupAuditingLoad(CmsApplyJoinTeam applyJoinTeam, Pagination page,HttpServletRequest request) {
        try{
            List<CmsTerminalUser> terminalUsers = terminalUserService.queryCheckTerminalUser(applyJoinTeam, page, null);
            request.setAttribute("terminalUsers", terminalUsers);
            request.setAttribute("page", page);
        }catch (Exception e){
            logger.info("userGroupAuditingLoad error", e);
        }
        return "index/userCenter/userGroupAuditingLoad";
    }

    /**
     * 前端2.0 我加入的团体
     * @return
     */
    @RequestMapping(value = "/userGroupJoin")
    public String userGroupJoin() {
        return "index/userCenter/userGroupJoin";
    }

    /**
     * 前端2.0 我加入的团体
     * @return
     */
    @RequestMapping(value = "/userGroupJoinLoad")
    public String userGroupJoinLoad(CmsApplyJoinTeam applyJoinTeam, Pagination page,HttpServletRequest request) {
        try{
            page.setRows(8);
            List<CmsTeamUser> teamUsers = cmsTeamUserService.queryMyManagerTeamUser(applyJoinTeam, page, null);
            request.setAttribute("teamUsers", teamUsers);
            request.setAttribute("page", page);
        }catch (Exception e){
            logger.info("userGroupJoinLoad error", e);
        }
        return "index/userCenter/userGroupJoinLoad";
    }

    /**
     * 前端2.0 历史记录
     * @return
     */
    @RequestMapping(value = "/userGroupHistory")
    public String userGroupHistory() {
        return "index/userCenter/userGroupHistory";
    }

    /**
     * 前端2.0 历史记录
     * @return
     */
    @RequestMapping(value = "/userGroupHistoryLoad")
    public String userGroupHistoryLoad(CmsApplyJoinTeam applyJoinTeam, Pagination page,HttpServletRequest request) {
        try{
            page.setRows(8);
            List<CmsTeamUser> teamUsers = cmsTeamUserService.queryMyManagerTeamUser(applyJoinTeam, page, null);
            request.setAttribute("teamUsers", teamUsers);
            request.setAttribute("page", page);
        }catch (Exception e){
            logger.info("userGroupJoinLoad error", e);
        }
        return "index/userCenter/userGroupHistoryLoad";
    }

    /**
     * 判断登录用户是团体用户还是普通用户
     * @return
     */
    @RequestMapping(value = "/getTeamUserCount")
    @ResponseBody
    public int getTeamUserCount(){
        if(session.getAttribute("terminalUser") != null){
            CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
            CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
            applyJoinTeam.setUserId(user.getUserId());
            applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_PASS);
            return cmsTeamUserService.queryMyManagerTeamUserCount(applyJoinTeam,null,null);
        }
        return 0;
    }

}