package com.sun3d.why.dao;

import com.sun3d.why.model.CmsUserMessage;

import java.util.List;
import java.util.Map;


public interface CmsUserMessageMapper {

    int deleteById(String userMessageId);
    public List<CmsUserMessage> queryByUserId(Map<String,Object> map);
    int countUserMessage(String userId);
    int addUserMessage(CmsUserMessage message);

    /**
     * app查询用户消息列表
     * @param userId
     * @return
     */
    List<CmsUserMessage> queryUserMessageById(String userId);

    /**
     * app更新用户消息状态
     * @param message
     * @return
     */
    int updateUserMessageById(CmsUserMessage message);

    /**
     * 根据用户消息查询消息信息
     * @para userMessageId
     * @return CmsUserMessage
     * @authours hucheng
     * @date 2016/2/22
     * */
    public CmsUserMessage queryCmsUserMessageById(String userMessageId);
}