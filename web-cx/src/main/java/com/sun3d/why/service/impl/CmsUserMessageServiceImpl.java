package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsUserMessageMapper;
import com.sun3d.why.dao.MessageTempletMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserMessage;
import com.sun3d.why.model.MessageTemplet;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import freemarker.cache.StringTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.StringWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/6/27.
 */
@Service
@Transactional
public class CmsUserMessageServiceImpl implements CmsUserMessageService {

    private Logger logger = LoggerFactory.getLogger(CmsUserMessageServiceImpl.class);

    @Autowired
    private CmsUserMessageMapper cmsUserMessageMapper;

    @Autowired
    private MessageTempletMapper messageTempletMapper;




    @Override
    public List<CmsUserMessage> queryByUserId(CmsUserMessage cmsUserMessage, Pagination page, CmsTerminalUser terminalUser) {

        Map<String, Object> params = new HashMap<String, Object>();
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            params.put("firstResult", page.getFirstResult());
            params.put("rows", page.getRows());
            int total = cmsUserMessageMapper.countUserMessage(terminalUser.getUserId());
            page.setTotal(total);
        }
        params.put("userId",terminalUser.getUserId());
        return cmsUserMessageMapper.queryByUserId(params);

    }
    //删除消息
    @Override
    public String deleteById(String userMessageId) {
        cmsUserMessageMapper.deleteById(userMessageId);
        return Constant.RESULT_STR_SUCCESS;
    }
    //发送消息
    @Override
    public String addUserMessage(MessageTemplet message,Map<String,Object> params,CmsTerminalUser user) {
        CmsUserMessage userMessage = new CmsUserMessage();
        userMessage.setUserMessageContent(FreemarkerProcess(params,message.getMessageContent()));
        userMessage.setUserMessageId(UUIDUtils.createUUId());
        userMessage.setUserMessageCreateTime(new Date());
        userMessage.setUserMessageAcceptUser(user.getUserId());
        userMessage.setUserMessageType(message.getMessageType());
        cmsUserMessageMapper.addUserMessage(userMessage);
        return Constant.RESULT_STR_SUCCESS;
    }

    @Override
    public String sendSystemMessage(String type, Map<String, Object> params,String userId) {
        if(StringUtils.isBlank(type)||params==null||StringUtils.isBlank(userId)){
            return Constant.RESULT_STR_FAILURE;
        }
        try {
            //根据类型按名称查找模板
            MessageTemplet templet = new MessageTemplet();
            templet.setMessageType(type);
            //获取模板 测试数据
            MessageTemplet message =messageTempletMapper.queryMessageTemplet(templet);
            //处理消息模板 保存消息
            CmsUserMessage userMessage = new CmsUserMessage();
            userMessage.setUserMessageContent(FreemarkerProcess(params, message.getMessageContent()));
            userMessage.setUserMessageId(UUIDUtils.createUUId());
            userMessage.setUserMessageCreateTime(new Date());
            userMessage.setUserMessageAcceptUser(userId);
            userMessage.setUserMessageType(message.getMessageType());
            userMessage.setUserMessageStatus(Constant.USER_MESSAGE_STATUS);
            //发送消息
            cmsUserMessageMapper.addUserMessage(userMessage);
            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            logger.error(type+"------>sendSystemMessageError"+e);
            e.printStackTrace();
        }
        return Constant.RESULT_STR_FAILURE;
    }

    //短信模板
    @Override
    public String getSmsTemplate(String type, Map<String, Object> params){
        //根据类型按名称查找模板
        MessageTemplet templet = new MessageTemplet();
        templet.setMessageType(type);
        //获取模板 测试数据
        MessageTemplet message =messageTempletMapper.queryMessageTemplet(templet);
        return FreemarkerProcess(params, message.getMessageContent());


    }

    //消息模板处理
    private static String FreemarkerProcess(Map<String,Object> input, String templateStr) {
       StringTemplateLoader stringLoader = new StringTemplateLoader();
        String template = "template";
        stringLoader.putTemplate(template, templateStr);
        Configuration cfg =  new Configuration(Configuration.VERSION_2_3_22);
        cfg.setTemplateLoader(stringLoader);
        try {
            Template templateCon =cfg.getTemplate(template);
            StringWriter writer = new StringWriter();
            templateCon.process(input,writer);
            return writer.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }


    /**
     * 根据用户消息查询消息信息
     * @para userMessageId
     * @return CmsUserMessage
     * @authours hucheng
     * @date 2016/2/22
     * */
    public CmsUserMessage queryCmsUserMessageById(String userMessageId){

        return cmsUserMessageMapper.queryCmsUserMessageById(userMessageId);
    }
}
