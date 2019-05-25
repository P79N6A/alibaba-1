package com.sun3d.why.dao;


import com.sun3d.why.model.MessageTemplet;

import java.util.List;
import java.util.Map;

public interface MessageTempletMapper {
    /**
     * 保存系统消息模板
     * @return 0 失败, 1成功
     */
    int addMessageTemplet(MessageTemplet messageTemplet);

    /**
     * 修改系统消息模板*
     * @return 0 失败, 1成功
     */
    int editMessageTemplet(MessageTemplet messageTemplet);

    /**
     * 根据传入的map查询系统消息模板
     * @param map  查询条件
     * @return 活动列表信息
     */
    public List<MessageTemplet> queryMessageTempletByCondition(Map<String, Object> map);

    /**
     * 根据传入的map查询系统消息模板的总条数
     * @param map 查询条件
     * @return 活动总条数
     */
    int queryMessageTempletCountByCondition(Map<String, Object> map);

    MessageTemplet queryMessageById(String messageId);

    int deleteMessageById(String messageId);

    MessageTemplet queryMessageTemplet(MessageTemplet messageTemplet);
}