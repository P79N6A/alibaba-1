package com.sun3d.why.webservice.controller;


import com.sun3d.why.model.ContactUs;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.UploadFile;
import com.sun3d.why.webservice.service.ContactUsService;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;


@RequestMapping("/contactUs")
@Controller
public class AppContactUsController {
    @Autowired
    private ContactUsService contactUsService;

    /**
     * 联系我们，传入接口。
     *
     * @param contactName :称呼
     * @param corporation :公司团体名称
     * @param contact     :联系方式
     * @return
     */
    @RequestMapping(value = "/saveContact")
    private String saveContact(HttpServletResponse response, String contactName, String corporation, String contact) throws Exception {
        //返回前台页面json格式
        String json = "";
        try {
            if (StringUtils.isNotBlank(contactName) && StringUtils.isNotBlank(contact) && StringUtils.isNotBlank(corporation)) {
                ContactUs contactus = new ContactUs();
                contactus.setContactName(EmojiFilter.filterEmoji(contactName));
                contactus.setCorporation(EmojiFilter.filterEmoji(corporation));
                contactus.setContact(EmojiFilter.filterEmoji(contact));
                String result = contactUsService.saveContact(contactus);
                if (Constant.RESULT_STR_SUCCESS.equals(result)) {
                    json = UploadFile.toResultFormat(200, "已保存成功!");
                }else {
                    json = UploadFile.toResultFormat(403, "已有相同信息!");
                }
            } else {
                json = UploadFile.toResultFormat(401, "信息缺省!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


}
