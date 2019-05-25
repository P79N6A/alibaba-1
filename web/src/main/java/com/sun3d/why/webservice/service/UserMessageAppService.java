package com.sun3d.why.webservice.service;

/**
 * 用户消息
 */
public interface UserMessageAppService {
    /**
     * app根据用户id查询消息列表
     * @param userId 用户id
     * @return
     */
     public String queryUserMessageById(String userId);

    /**
     * app删除系统消息
     * @param userMessageId 消息id
     * @return
     */
     public String deleteUserMessageById(String userMessageId);

}
