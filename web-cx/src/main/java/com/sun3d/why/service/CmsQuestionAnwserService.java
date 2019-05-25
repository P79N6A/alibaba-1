package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsQuestionAnwser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CmsQuestionAnwserService {

    /**
     * 获取互动管理列表
     * @param cmsQuestionAnwser
     * @param page   
     * @return
     */
	List<CmsQuestionAnwser> queryQuestionAnwserByCondition(CmsQuestionAnwser cmsQuestionAnwser,Pagination page);

    /**
     * 文化云3.1前端首页互动天地查询数据
     * @param page
     * @return
     */
    List<CmsQuestionAnwser> queryQuestionAnswer(Pagination page);

    /**
     * 文化云3.1前端首页互动天地查询个数
     * @param map
     * @return
     */
    int queryQuestionAnswerCount(Map<String, Object> map);
    
    /**
	 * 删除互动
	 * @param anwserId
	 * @return
	 */
	String deleteQuestionAnwser(String anwserId);
	
	/**
	 * 添加互动
	 * @param cmsQuestionAnwser
	 * @param sysUser
	 * @return
	 */
	String addQuestionAnwser(CmsQuestionAnwser cmsQuestionAnwser,SysUser sysUser);
	
	/**
	 * 编辑互动
	 * @param cmsQuestionAnwser
	 * @param sysUser
	 * @return
	 */
	String editQuestionAnwser(CmsQuestionAnwser cmsQuestionAnwser,SysUser sysUser);
	
	/**
	 * 根据ID查询互动
	 * @param anwserId
	 * @return
	 */
	CmsQuestionAnwser queryQuestionAnwserById(String anwserId);
}

