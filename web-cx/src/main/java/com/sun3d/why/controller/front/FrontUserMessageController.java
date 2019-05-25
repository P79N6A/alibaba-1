package com.sun3d.why.controller.front;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserMessage;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.service.MessageTempletService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

@RequestMapping("/userMessage")
@Controller
public class FrontUserMessageController {
    private Logger logger = LoggerFactory.getLogger(FrontUserMessageController.class);

    @Autowired
    private CmsUserMessageService userMessageService;

    @Autowired
    private HttpSession session;
    @Autowired
    private MessageTempletService service;

    @RequestMapping(value = "/userMessageIndex")
    public ModelAndView userMessageIndex() {
        CmsTerminalUser sysUser =(CmsTerminalUser)session.getAttribute(Constant.terminalUser);
        if(sysUser==null){
            return new ModelAndView("redirect:/frontTerminalUser/userLogin.do");
        }
        return new ModelAndView("index/userCenter/userMessageIndex");
    }

    @RequestMapping(value = "/userMessageLoad",method = RequestMethod.POST)
    public ModelAndView userMessageLoad(CmsUserMessage cmsUserMessage, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            CmsTerminalUser sysUser =(CmsTerminalUser)session.getAttribute(Constant.terminalUser);
            List<CmsUserMessage> messageList = userMessageService.queryByUserId(cmsUserMessage,page,sysUser);
            model.setViewName("index/userCenter/userMessageLoad");
            model.addObject("messageList", messageList);
            model.addObject("page", page);
            model.addObject("cmsUserMessage", cmsUserMessage);
        } catch (Exception e) {
            logger.info("userMessageLoad error" + e);
        }
        return model;
    }


    @RequestMapping(value = "/deleteUserMessage", method = RequestMethod.POST)
    @ResponseBody
    public String deleteUserMessage(String[] id) {
        try {
            String msg = "";
            for (String ids : id) {
                msg = userMessageService.deleteById(ids);
            }
            return msg;
        } catch (Exception e) {
            logger.info("deleteUserMessage error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
    }



}
