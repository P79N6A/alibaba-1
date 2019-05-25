package com.sun3d.why.service;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserMessage;
import com.sun3d.why.model.MessageTemplet;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

public interface CmsUserMessageService {

    public List<CmsUserMessage> queryByUserId(CmsUserMessage cmsUserMessage, Pagination page, CmsTerminalUser sysUser);

    String deleteById(String userMessageId);

    /**
     *
     * @param message
     * @param params
     * @param user
     * @return
     */
    String addUserMessage(MessageTemplet message,Map<String,Object> params,CmsTerminalUser user);


    /**
     * 发送系统消息
     * @param type 发送消息类型(具体参考Constant类系统消息类型)
     * @param params 传入此参数由type决定 如 key ${用户名!} value 当前发送目标用户名
     * @param userId 用户ID
     * @return success 发送成功,failure 发送失败
     */
    String sendSystemMessage(String type,Map<String,Object> params,String userId);

    public String getSmsTemplate(String type, Map<String, Object> params);

    /**
     * 根据用户消息查询消息信息
     * @para userMessageId
     * @return CmsUserMessage
     * @authours hucheng
     * @date 2016/2/22
     * */
    public CmsUserMessage queryCmsUserMessageById(String userMessageId);

}
