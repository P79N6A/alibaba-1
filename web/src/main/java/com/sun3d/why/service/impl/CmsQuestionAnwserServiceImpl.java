package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsQuestionAnwserMapper;
import com.sun3d.why.model.CmsQuestionAnwser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsQuestionAnwserService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CmsQuestionAnwserServiceImpl implements CmsQuestionAnwserService {

    
    @Autowired
    private CmsQuestionAnwserMapper cmsQuestionAnwserMapper;

    //log4j日志
    private Logger logger = Logger.getLogger(CmsQuestionAnwserServiceImpl.class);

    /**
     * 获取互动管理列表
     * @param cmsQuestionAnwser
     * @param page   
     * @return
     */
	@Override
	public List<CmsQuestionAnwser> queryQuestionAnwserByCondition(CmsQuestionAnwser cmsQuestionAnwser, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
        if (cmsQuestionAnwser != null && StringUtils.isNotBlank(cmsQuestionAnwser.getAnwserQuestion())) {
            map.put("searchKey", "%" + cmsQuestionAnwser.getAnwserQuestion() + "%");
        }
        
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        int total = cmsQuestionAnwserMapper.queryQuestionAnwserByCount(map);
        //设置分页的总条数来获取总页数
        page.setTotal(total);
        return cmsQuestionAnwserMapper.queryQuestionAnwserByContent(map);
	}

    /**
     * 文化云3.1前端首页互动天地查询数据
     * @param page
     * @return
     */
    @Override
    public List<CmsQuestionAnwser> queryQuestionAnswer(Pagination page){
        Map<String, Object> map = new HashMap<String, Object>();
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            //设置分页的总条数来获取总页数
            page.setTotal(queryQuestionAnswerCount(map));
        }
        return cmsQuestionAnwserMapper.queryQuestionAnswer(map);
    }

    /**
     * 文化云3.1前端首页互动天地查询个数
     * @param map
     * @return
     */
    @Override
    public int queryQuestionAnswerCount(Map<String, Object> map){
        return cmsQuestionAnwserMapper.queryQuestionAnswerCount(map);
    }
    
    /**
	 * 删除互动
	 * @param anwserId
	 * @return
	 */
    @Override
	public String deleteQuestionAnwser(String anwserId) {
		int result = cmsQuestionAnwserMapper.deleteQuestionAnwser(anwserId);
		if(result == 1){
            return  "success";
 		}else{
            return  "false";
 		}
	}
    
    /**
	 * 添加互动
	 * @param cmsQuestionAnwser
	 * @return
	 */
    @Override
	public String addQuestionAnwser(CmsQuestionAnwser cmsQuestionAnwser,SysUser sysUser) {
    	cmsQuestionAnwser.setAnwserId(UUIDUtils.createUUId());
    	cmsQuestionAnwser.setAnwserCreateTime(new Date());
    	cmsQuestionAnwser.setAnwserCreateUser(sysUser.getUserId());
    	cmsQuestionAnwser.setAnwserUpdateTime(new Date());
    	cmsQuestionAnwser.setAnwserUpdateUser(sysUser.getUserId());
		int result = cmsQuestionAnwserMapper.addQuestionAnwser(cmsQuestionAnwser);
		if(result == 1){
            return  "success";
 		}else{
            return  "false";
 		}
	}
    
    /**
	 * 编辑互动
	 * @param cmsQuestionAnwser
	 * @return
	 */
    @Override
	public String editQuestionAnwser(CmsQuestionAnwser cmsQuestionAnwser,SysUser sysUser) {
    	if(cmsQuestionAnwser!=null){
    		CmsQuestionAnwser qa = cmsQuestionAnwserMapper.queryQuestionAnwserById(cmsQuestionAnwser.getAnwserId());
    		if (qa != null && StringUtils.isNotBlank(cmsQuestionAnwser.getAnwserImgUrl())){
    			qa.setAnwserImgUrl(cmsQuestionAnwser.getAnwserImgUrl());
    		}
    		if (qa != null && StringUtils.isNotBlank(cmsQuestionAnwser.getAnwserQuestion())){
    			qa.setAnwserQuestion(cmsQuestionAnwser.getAnwserQuestion());
    		}
    		if (qa != null && StringUtils.isNotBlank(cmsQuestionAnwser.getAnwserAllCode())){
    			qa.setAnwserAllCode(cmsQuestionAnwser.getAnwserAllCode());
    		}
    		if (qa != null && StringUtils.isNotBlank(cmsQuestionAnwser.getAnwserCode())){
    			qa.setAnwserCode(cmsQuestionAnwser.getAnwserCode());
    		}
        	qa.setAnwserUpdateTime(new Date());
        	qa.setAnwserUpdateUser(sysUser.getUserId());
    		int result = cmsQuestionAnwserMapper.editQuestionAnwser(qa);
    		if(result == 1){
                return  "success";
     		}else{
                return  "false";
     		}
    	}else{
    		return  "false";
    	}
	}

	/**
	 * 根据ID查询互动
	 * @param anwserId
	 * @return
	 */
	@Override
	public CmsQuestionAnwser queryQuestionAnwserById(String anwserId) {
		return cmsQuestionAnwserMapper.queryQuestionAnwserById(anwserId);
	}
}
