package com.sun3d.why.controller.volunteer;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.volunteer.VolunteerActivityDemeanorDocumentary;
import com.sun3d.why.service.volunteer.VolunteerActivityDemeanorDocumentaryService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 风采纪实
 */
@RequestMapping("/VolunteerActivityDemeanorDocumentary")
@Controller
public class VolunteerActivityDemeanorDocumentaryController {

    private Logger logger = LoggerFactory.getLogger(VolunteerActivityDemeanorDocumentaryController.class);
    @Autowired
    private HttpSession session;
    @Autowired
    private VolunteerActivityDemeanorDocumentaryService VADdocumentaryService;

    /**
     * 新增活动风采
     * @param documentary
     * @return
     */
    @RequestMapping("addVolunteerActivityDemeanorDocumentary")
    @ResponseBody
    public String addVolunteerActivityDemeanorDocumentary( VolunteerActivityDemeanorDocumentary documentary){
        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");


            if (loginUser == null) {
                return "user";
            }
            //保存时确定关联招募活动或者志愿者
            if(documentary !=null&&StringUtils.isBlank(documentary.getUuid())){
                VADdocumentaryService.addDocumentary(documentary,loginUser.getUserId());
            }

         return "success";
        } catch (Exception ex) {
            ex.printStackTrace();
            return "error";
        }

    }

    /**
     * 编辑风采
     * @param documentary
     * @return
     */
    @RequestMapping("editVolunteerActivityDemeanorDocumentary")
    @ResponseBody
    public String editVolunteerActivityDemeanorDocumentary(@RequestBody VolunteerActivityDemeanorDocumentary documentary){
        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");

            if (loginUser == null) {
                return "user";
            }
            if(documentary !=null){
                VADdocumentaryService.editDocumentary(documentary,loginUser.getUserId());
            }

            return "success";
        } catch (Exception ex) {
            ex.printStackTrace();
            return "error";
        }


    }

    /**
     * 跳转至风采纪实修改页面
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/preEditDoc")
    public ModelAndView preEditDoc(String uuid, String activityId) {
        logger.info("preEditDoc");
        VolunteerActivityDemeanorDocumentary documentary = null; //VADdocumentaryService.queryDocumentaryById(uuid);
        ModelAndView model = new ModelAndView();
        model.addObject("activityId", activityId );
        model.addObject("documentary", documentary );
        model.setViewName("admin/volunteer/activity/preEditDoc");

        return model;
    }



    /**
     * 删除风采
     * @param documentary
     * @return
     */
    @RequestMapping("/deleteVolunteerActivityDemeanorDocumentary")
    public String deleteVolunteerActivityDemeanorDocumentary(@RequestBody VolunteerActivityDemeanorDocumentary documentary){

        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");

            if (loginUser == null) {
                return "user";
            }
            if(documentary !=null){
                VADdocumentaryService.deleteDocumentary(documentary,loginUser.getUserId());
            }

            return "success";
        } catch (Exception ex) {
            ex.printStackTrace();
            return "error";
        }
    }

    /**
     * 跳转至风采纪实列表页面
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/documentaryList")
    @ResponseBody
    public ModelAndView documentaryList(VolunteerActivityDemeanorDocumentary docModel, Pagination page, String activityId) {
        String ownerId = activityId;
        List<VolunteerActivityDemeanorDocumentary> list = VADdocumentaryService.Documentarylist(ownerId);
        ModelAndView model = new ModelAndView();
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("model", docModel);
        model.addObject("activityId", activityId);
        model.setViewName("admin/volunteer/activity/documentaryList");
        return model;
    }

    /**
     * 风采列表
     * @return
     */
    @RequestMapping("Documentarylist")
    @ResponseBody
    public List<VolunteerActivityDemeanorDocumentary> Documentarylist(String  ownerId){

            return  VADdocumentaryService.Documentarylist(ownerId);

    }


}
