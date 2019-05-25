package com.sun3d.why.controller.front;
import com.sun3d.why.model.CmsFeedback;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.webservice.service.CmsFeedbackService;
import com.sun3d.why.webservice.service.TerminalUserAppService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletResponse;
import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.jms.client.ActivityBookClient;
import com.sun3d.why.jms.model.JmsResult;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.service.*;
import com.sun3d.why.util.CmsSensitive;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.model.CmsApiOrder;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

@RequestMapping("/frontFeedBack")
@Controller
public class FrontFeedBackController {
    private org.slf4j.Logger logger = LoggerFactory.getLogger(FrontFeedBackController.class);


    @Autowired
    private CmsFeedbackService cmsFeedbackService;




    /**
     *web用户反馈信息
     *@param cmsFeedback 反馈对象
     * return json 0.添加成功
     */
    @RequestMapping(value = "/webFeedBack")
    public void webFeedBack(HttpServletResponse response,CmsFeedback cmsFeedback) throws Exception {
        int count=0;

        if(cmsFeedback!=null){
            count=cmsFeedbackService.insertFeedInformation(cmsFeedback);

        }else {
            response.getWriter().print("error");
        }
        if(count>0){
            response.getWriter().print("success");

        }else {
            response.getWriter().print("fail");
        }

    }



}
