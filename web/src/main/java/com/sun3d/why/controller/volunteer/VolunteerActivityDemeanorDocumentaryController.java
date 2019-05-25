package com.sun3d.why.controller.volunteer;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.volunteer.VolunteerActivityDemeanorDocumentary;
import com.sun3d.why.service.volunteer.VolunteerActivityDemeanorDocumentaryService;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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

    public String addVolunteerActivityDemeanorDocumentary(@RequestBody VolunteerActivityDemeanorDocumentary documentary){
        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");

            if (loginUser == null) {
                return "user";
            }

            //保存时确定关联招募活动或者志愿者
            if(documentary !=null&&StringUtils.isBlank(documentary.getOwnerId())){
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

    public String editVolunteerActivityDemeanorDocumentary(@RequestBody  VolunteerActivityDemeanorDocumentary documentary){
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
     * 删除风采
     * @param documentary
     * @return
     */
    @RequestMapping("/deleteVolunteerActivityDemeanorDocumentary")
    public String deleteVolunteerActivityDemeanorDocumentary( @RequestBody VolunteerActivityDemeanorDocumentary documentary){

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
     * 风采列表
     * @return
     */
    @RequestMapping("Documentarylist")
    @ResponseBody
    public List<VolunteerActivityDemeanorDocumentary> Documentarylist(String  ownerId){
            return  VADdocumentaryService.Documentarylist(ownerId);

    }

    @RequestMapping("getDetail")
    @ResponseBody
    public VolunteerActivityDemeanorDocumentary getDetailByownerId(String  uuid){
        return  VADdocumentaryService.getDetailByownerId(uuid);

    }



}
