package com.sun3d.why.service.impl;


import com.sun3d.why.dao.CmsUserMessageMapper;
import com.sun3d.why.dao.MessageTempletMapper;
import com.sun3d.why.model.MessageTemplet;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.MessageTempletService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class MessageTempletServiceImpl implements MessageTempletService {


    @Autowired
    private MessageTempletMapper messageTempletMapper;

    @Autowired
    private CmsUserMessageMapper cmsUserMessageMapper;

    private Logger logger = Logger.getLogger(MessageTempletServiceImpl.class);

    //保存消息
    @Override
    public String  addMessageTemplet(MessageTemplet messageTemplet,SysUser sysUser) {
        messageTemplet.setMessageId(UUIDUtils.createUUId());
        messageTemplet.setMessageCreateTime(new Date());
        messageTemplet.setMessageCreateUser(sysUser.getUserId());
        messageTemplet.setMessageState(1);
        messageTempletMapper.addMessageTemplet(messageTemplet);
        return Constant.RESULT_STR_SUCCESS;
    }
    //更新消息
    @Override
    public String editMessageTemplet(MessageTemplet messageTemplet,SysUser sysUser) {
        messageTemplet.setMessageUpdateUser(sysUser.getUserId());
        messageTemplet.setMessageUpdateTime(new Date());
        messageTempletMapper.editMessageTemplet(messageTemplet);
        return Constant.RESULT_STR_SUCCESS;
    }

    @Override
    public List<MessageTemplet> queryMessageTempletByCondition(MessageTemplet messageTemplet, Pagination page, SysUser sysUser) {

        Map<String, Object> params = new HashMap<String, Object>();
        //权限验证
        if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserDeptPath())){
            params.put("venueDept", sysUser.getUserDeptPath() + "%");
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            params.put("firstResult", page.getFirstResult());
            params.put("rows", page.getRows());
            int total = messageTempletMapper.queryMessageTempletCountByCondition(params);
            page.setTotal(total);
        }

        return messageTempletMapper.queryMessageTempletByCondition(params);

    }
    //总条数
    @Override
    public int queryMessageTempletCountByCondition(Map<String, Object> map) {
        return messageTempletMapper.queryMessageTempletCountByCondition(map);
    }

    @Override
    public MessageTemplet queryMessageById(String messageId) {
        return messageTempletMapper.queryMessageById(messageId);
    }

    @Override
    public String deleteMessageById(String messageId) {
        messageTempletMapper.deleteMessageById(messageId);
        return Constant.RESULT_STR_SUCCESS;
    }
}
