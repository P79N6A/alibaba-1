package com.sun3d.why.controller.volunteer;


import com.sun3d.why.model.SysUser;
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

    public String addNewVolunteer(@RequestBody  Volunteer volunteer ){

        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");

            if (loginUser == null) {
                return "user";
            }
            //判断用户是否已注册
            List<Volunteer> volunteers = volunteerService.queryNewVolunteer(loginUser.getUserId(), volunteer.getType());
            if(volunteers !=null){
                return "volunteer Already exists";
            }
            volunteerService.SaveVolunteer(volunteer, loginUser.getUserId());
            return "success";
        } catch (Exception ex) {
            ex.printStackTrace();
            return "error";
        }

    }

    /**
     * 跳转至志愿者管理页面
     * @param uuid
     * @return
     */
    @RequestMapping("/volunteerManager")
    public ModelAndView volunteerManager(Pagination page){

        List<Volunteer> list = null;
        try{
            list  = volunteerService.queryNewVolunteerList(page);

        }catch (Exception e){
            logger.error("volunteerManager error {}",e);
        }
        ModelAndView model = new ModelAndView();
        model.addObject("list", list);
        model.addObject("page", page);
        model.setViewName("admin/volunteer/volunteerManager");
        return model;

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
     * 跳转至志愿者查看页面
     * @param uuid
     * @return
     */
    @RequestMapping("/viewVolunteer")
    public ModelAndView viewVolunteer(String uuid){
        Volunteer volunteer = volunteerService.queryNewVolunteerById(uuid);
        ModelAndView model = new ModelAndView();
        model.addObject("model", volunteer);
        model.setViewName("admin/volunteer/viewVolunteer");
        return model;

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

    public String updateNewVolunteer(@RequestBody Volunteer volunteer){
       try {
        //从session中获取用户信息
        SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser == null) {
                return "user";
            }
            if(volunteer.getUserId().equals(sysUser.getUserId())){
                volunteerService.UpdateVolunteer(volunteer,sysUser.getUserId());
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

    public String auditNewVolunteer(@RequestBody Volunteer volunteer){

        return  volunteerService.auditNewVolunteer(volunteer);
    }

    /**
     * 删除志愿者
     * @param volunteer
     * @return
     */
    @RequestMapping("deleteNewVolunteer")
    @ResponseBody
    public String deleteNewVolunteer(@RequestBody Volunteer volunteer){
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser == null) {
                return "user";
            }
            if(volunteer.getUserId().equals(sysUser.getUserId())){
                volunteerService.deleteNewVolunteer(volunteer,sysUser.getUserId());
            }
            return "success";
        } catch (Exception ex) {
            ex.printStackTrace();
            return "error";
        }

    }
    @RequestMapping("queryNewVolunteerListByUserId")
    @ResponseBody
    public List<Volunteer> queryNewVolunteerListByUserId(){
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            return  volunteerService.queryNewVolunteerListByUserId(sysUser.getUserId());

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }



    }



}
