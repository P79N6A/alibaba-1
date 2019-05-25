package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.CmsUserMessageMapper;
import com.sun3d.why.model.CmsUserMessage;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.webservice.service.UserMessageAppService;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 用户消息
 */
@Service
@Transactional
public class UserMessageAppServiceImpl implements UserMessageAppService{
    @Autowired
    private CmsUserMessageMapper cmsUserMessageMapper;
    /**
     * app查询用户消息列表
     * @param userId 用户id
     * @return
     */
    @Override
    public String queryUserMessageById(String userId) {
        List<Map<String, Object>> listMapMessage= new ArrayList<Map<String, Object>>();
        List<CmsUserMessage> messageList=cmsUserMessageMapper.queryUserMessageById(userId);
        if(CollectionUtils.isNotEmpty(messageList)){
            for(CmsUserMessage message:messageList){
               int flag=cmsUserMessageMapper.updateUserMessageById(message);
                if(flag>0) {
                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("messageContent", message.getUserMessageContent() != null ? message.getUserMessageContent() : "");
                    map.put("messageType", message.getUserMessageType() != null ? message.getUserMessageType() : "");
                    map.put("userMessageId", message.getUserMessageId() != null ? message.getUserMessageId() : "");
                    listMapMessage.add(map);
                }
            }
        }
        return JSONResponse.toAppResultFormat(0, listMapMessage);
    }

    /**
     * app删除系统消息
     * @param userMessageId 消息id
     * @return
     */
    @Override
    public String deleteUserMessageById(String userMessageId) {
        int status=0;
        status=cmsUserMessageMapper.deleteById(userMessageId);
        if(status>0){
          return  JSONResponse.commonResultFormat(0,"删除用户消息成功!",null);
        }else {
            return JSONResponse.commonResultFormat(1,"删除用户消息失败!",null);
        }
    }
}
