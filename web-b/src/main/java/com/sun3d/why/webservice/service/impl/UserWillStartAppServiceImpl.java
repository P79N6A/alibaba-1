package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.dao.CmsUserWillStartMapper;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsUserWillStart;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.service.CommentAppService;
import com.sun3d.why.webservice.service.UserWillStartAppService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 某一类型评论
 */
@Service
@Transactional
public class UserWillStartAppServiceImpl implements UserWillStartAppService {

    private Logger logger = Logger.getLogger(UserWillStartAppServiceImpl.class);

    @Autowired
    private CmsUserWillStartMapper userWillStartMapper;

    /**
     * 根据用户id查询
     * @param map
     * @return
     */
    @Override
    public CmsUserWillStart queryUserWillStartByUserId(Map<String, Object> map){
        return userWillStartMapper.queryUserWillStartByUserId(map);
    }

    /**
     * app端点击即将开始时的活动数目
     * @param map
     * @return
     */
    @Override
    public int queryAppWillStartActivityCount(Map<String, Object> map){
        return userWillStartMapper.queryAppWillStartActivityCount(map);
    }

    /**
     * app端点击即将开始时新增数据
     * @param userWillStart
     * @return
     */
    @Override
    public int addAppWillStart(CmsUserWillStart userWillStart){
        return userWillStartMapper.addAppWillStart(userWillStart);
    }

    /**
     * app端点击即将开始时新增数据编辑
     * @param userWillStart
     * @return
     */
    @Override
    public int editAppWillStartByUserId(CmsUserWillStart userWillStart){
        return userWillStartMapper.editAppWillStartByUserId(userWillStart);
    }

    /**
     * 根据用户id查询数量
     * @param map
     * @return
     */
    @Override
    public int queryUserWillStartCountByUserId(Map<String, Object> map){
        return userWillStartMapper.queryUserWillStartCountByUserId(map);
    }
}
