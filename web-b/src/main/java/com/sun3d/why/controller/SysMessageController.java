package com.sun3d.why.controller;

import com.sun3d.why.model.MessageTemplet;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.MessageTempletService;
import com.sun3d.why.service.SysDictService;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@RequestMapping("/message")
@Controller
public class SysMessageController {
    private Logger logger = LoggerFactory.getLogger(SysMessageController.class);


    @Autowired
    private MessageTempletService messageTempletService;
    @Autowired
    private HttpSession session;
    @Autowired
    private SysDictService sysDictService;


    @RequestMapping("/messageIndex")
    public ModelAndView messageIndex(MessageTemplet messageTemplet, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<MessageTemplet> messageList = messageTempletService.queryMessageTempletByCondition(messageTemplet, page, sysUser);
            model.setViewName("admin/message/messageIndex");
            model.addObject("messageList", messageList);
            model.addObject("page", page);
            model.addObject("messageTemplet", messageTemplet);
        } catch (Exception e) {
            logger.info("messageIndex error" + e);
        }
        return model;
    }

    @RequestMapping(value = "/preAddMessage")
    public String preAddMessage(HttpServletRequest request) {
        //数据字典
        SysDict sysDict = new SysDict();
        sysDict.setDictCode(Constant.MESSAGE_TYPE);
        List<SysDict> messageTypeList = sysDictService.querySysDictByByCondition(sysDict);
        request.setAttribute("messageTypeList", messageTypeList);
        request.setAttribute("user", session.getAttribute("user"));
        return "admin/message/addMessage";
    }

    @RequestMapping(value = "/addMessage", method = RequestMethod.POST)
    @ResponseBody
    public String addMessage(MessageTemplet messageTemplet, String activityMood, String activityTheme, String activityCrowd) {
        try {
            if (messageTemplet != null) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                return messageTempletService.addMessageTemplet(messageTemplet, sysUser);
            }
        } catch (Exception e) {
            logger.info("saveActivity error" + e.getMessage());
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;

    }

    @RequestMapping(value = "/preEditMessage", method = RequestMethod.GET)
    public String preEditActivity(HttpServletRequest request, String id) {
        SysDict sysDict = new SysDict();
        sysDict.setDictCode(Constant.MESSAGE_TYPE);
        List<SysDict> messageTypeList = sysDictService.querySysDictByByCondition(sysDict);

        MessageTemplet messageTemplet = messageTempletService.queryMessageById(id);
        request.setAttribute("mt", messageTemplet);
        request.setAttribute("messageTypeList", messageTypeList);

        return "admin/message/addMessage";
    }

    //更新
    @RequestMapping(value = "/editMessage", method = RequestMethod.POST)
    @ResponseBody
    public String editMessage(MessageTemplet messageTemplet) {
        try {
            if (messageTemplet != null) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                return messageTempletService.editMessageTemplet(messageTemplet, sysUser);
            }
        } catch (Exception e) {
            logger.info("updateMessage error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    @RequestMapping(value = "/deleteMessage", method = RequestMethod.GET)
    @ResponseBody
    public String deleteMessage(String id) {
        try {
            return messageTempletService.deleteMessageById(id);
        } catch (Exception e) {
            logger.info("updateMessage error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
    }


}
