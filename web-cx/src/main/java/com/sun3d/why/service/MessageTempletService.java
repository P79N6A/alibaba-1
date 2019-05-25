package com.sun3d.why.service;

import com.sun3d.why.model.MessageTemplet;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

public interface MessageTempletService {


    /**
     * 保存活动信息
     *
     * @return 0 失败, 1成功
     */
    String addMessageTemplet(MessageTemplet messageTemplet,SysUser sysUser);

    /**
     * 修改活动信息
     *
     * @return 0 失败, 1成功
     */
    String editMessageTemplet(MessageTemplet messageTemplet,SysUser sysUser);

    /**
     * 根据传入的map查询活动列表信息
     *
     * @return 活动列表信息
     */
    public List<MessageTemplet> queryMessageTempletByCondition(MessageTemplet messageTemplet, Pagination page, SysUser sysUser);

    /**
     * 根据传入的map查询活动的总条数
     *
     * @return 活动总条数
     */
    int queryMessageTempletCountByCondition(Map<String, Object> map);

    MessageTemplet queryMessageById(String messageId);

    String deleteMessageById(String messageId);
}
