package com.sun3d.why.controller.volunteer;


import com.sun3d.why.model.volunteer.Volunteer;
import com.sun3d.why.service.volunteer.VolunteerService;
import com.sun3d.why.util.Pagination;
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


@RequestMapping("newVolunteer")
@Controller
public class NewVolunteerController {
    private Logger logger = LoggerFactory.getLogger(NewVolunteerController.class);

    @Autowired
    private HttpSession session;
    @Autowired
    private VolunteerService volunteerService;

    /**
     * 志愿者新增
     * @param volunteer
     * @return
     */
    @RequestMapping("/addNewVolunteer")
    @ResponseBody
    public String addNewVolunteer(@RequestBody Volunteer volunteer){
            String result = "";
        try {
           /* SysUser loginUser = (SysUser)session.getAttribute("user");
            //CmsTerminalUser loginUser = (CmsTerminalUser)session.getAttribute("user");
            if (loginUser == null) {
               return "user";
            }*/
            //判断用户是否已注册
            List<Volunteer> volunteers = volunteerService.queryNewVolunteer(volunteer.getUserId(), volunteer.getType());
            if(volunteers !=null && volunteers.size()!= 0){
                System.out.println("chongx");
                logger.info("addNewVolunteer进来了");
                result = "exist";
            }else {
                volunteerService.SaveVolunteer(volunteer, volunteer.getUserId());
                result = "success";
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            result = "error";
        }
    return  result;
    }

    /**
     * 志愿者列表查询，根据组织id查询成员要用到
     * @return
     */
    @RequestMapping("/queryNewVolunteerList")
    @ResponseBody
    public  List<Volunteer> queryNewVolunteerList(Pagination page){

        List<Volunteer> volunteers = null;
        try{
            page.setRows(15);
            volunteers  = volunteerService.queryNewVolunteerList(page);

        }catch (Exception e){
            logger.error("queryNewVolunteerList error {}",e);
        }

        return volunteers;
    }

    /**
     * 志愿者详情查询
     * @param uuid
     * @return
     */
    @RequestMapping("/queryNewVolunteerById")
    @ResponseBody
    public Volunteer queryNewVolunteerById(String uuid){

        return volunteerService.queryNewVolunteerById(uuid);


    }

    /**
     * 志愿者修改
     * @param volunteer
     * @return
     */
    @RequestMapping("/updateNewVolunteer")
    @ResponseBody
    public String updateNewVolunteer(Volunteer volunteer){
       try {
       /* //从session中获取用户信息
        SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser == null) {
                return "user";
            }*/
            if(volunteer.getUserId().equals(volunteer.getUserId())){
                volunteerService.UpdateVolunteer(volunteer,volunteer.getUserId());
            }
             return "success";
        } catch (Exception ex) {
            ex.printStackTrace();
            return "error";
        }

    }

    /**
     * 志愿者审核
     * @return
     */
    @RequestMapping("/auditNewVolunteer")
    @ResponseBody
    public String auditNewVolunteer(Volunteer volunteer){

        return  volunteerService.auditNewVolunteer(volunteer);
    }

    /**
     * 删除志愿者
     * @param volunteer
     * @return
     */
    @RequestMapping("deleteNewVolunteer")
    @ResponseBody
    public String deleteNewVolunteer(Volunteer volunteer){
        try {
           /* //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser == null) {
                return "user";
            }*/
            if(volunteer.getUserId().equals(volunteer.getUserId())){
                volunteerService.deleteNewVolunteer(volunteer,volunteer.getUserId());
            }
            return "success";
        } catch (Exception ex) {
            ex.printStackTrace();
            return "error";
        }

    }
    @RequestMapping("queryNewVolunteerListByUserId")
    @ResponseBody
    public List<Volunteer> queryNewVolunteerListByUserId(String userId){
        try {
            //从session中获取用户信息
            return  volunteerService.queryNewVolunteerListByUserId(userId);

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
   }

}
