package com.sun3d.why.controller;

import com.sun3d.why.model.ContactUs;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.webservice.service.ContactUsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@RequestMapping("/contact")
@Controller
public class ContactUsController {
    @Autowired
    private ContactUsService contactUsService;
    /**
     * 后台进入联系我们页面
     *
     * @return
     */
    @RequestMapping("/contactPage")
    public ModelAndView contactPage(Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<ContactUs> contactus =contactUsService.selectContact(page);
            model.addObject("contactusList", contactus);
            model.addObject("page", page);
            model.setViewName("admin/contactUs/contactIndex");
        } catch (Exception e) {

        }
        return model;
    }


}
