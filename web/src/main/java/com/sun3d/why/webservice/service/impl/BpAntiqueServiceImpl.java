package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.dao.CmsUserWantgoMapper;
import com.sun3d.why.dao.WechatBpAntiqueMapper;
import com.sun3d.why.model.BpAntique;
import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.CmsAntiqueType;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsUserWantgo;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.service.impl.CmsAntiqueServiceImpl;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.BpAntiqueService;

import net.sf.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class BpAntiqueServiceImpl implements BpAntiqueService {
	 //log4j日志
    private Logger logger = Logger.getLogger(BpAntiqueServiceImpl.class);
	@Autowired
	WechatBpAntiqueMapper wechatBpAntiqueMapper;
	@Autowired
    private CmsCommentMapper commentMapper;
	@Override
	public String queryBpAntiqueList(PaginationApp pageApp) {
		Map<String,Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
		List<BpAntique> antiqueList = new ArrayList<BpAntique>();
        map.put("antiqueIsDel", Constant.NORMAL);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        int count = wechatBpAntiqueMapper.queryBpAntiqueListCount(map);
        try {
	        antiqueList = wechatBpAntiqueMapper.queryBpAntiqueList(map);
	        if(CollectionUtils.isNotEmpty(antiqueList)){
                for(BpAntique antique:antiqueList){
                    Map<String, Object> antiqueMap = new HashMap<String, Object>();
                    antiqueMap.put("antiqueId", antique.getAntiqueId()!=null?antique.getAntiqueId():"");
                    antiqueMap.put("antiqueName",antique.getAntiqueName()!=null?antique.getAntiqueName():"");
                    antiqueMap.put("antiqueImgUrl",antique.getAntiqueImgUrl()!=null?antique.getAntiqueImgUrl():"");
                    antiqueMap.put("antiqueInfo",antique.getAntiqueInfo()!=null?antique.getAntiqueInfo():"");
                    antiqueMap.put("antiqueType",antique.getAntiqueType()!=null?antique.getAntiqueType():"");
                    antiqueMap.put("antiqueDynasty",antique.getAntiqueDynasty()!=null?antique.getAntiqueDynasty():"");
                    listMap.add(antiqueMap);
                }
            }
        } catch (Exception e) {
            logger.error("查询文物信息出错!",e);
        }
        return JSONResponse.toAppActivityResultFormat(0, listMap, count);
	}
	@Override
	public BpAntique queryBpAntiqueById(String antiqueId,String userId) {
		Map<String,Object> map = new HashMap<String,Object>();
		if (antiqueId != null && StringUtils.isNotBlank(antiqueId)) {
            map.put("antiqueId", antiqueId);
        }
		if (userId != null && StringUtils.isNotBlank(userId)) {
            map.put("userId", userId);
        }
		BpAntique bpAntique = wechatBpAntiqueMapper.queryBpAntiqueById(map);
		map=new HashMap<String, Object>();
        map.put("commentRkId", bpAntique.getAntiqueId());
        map.put("firstResult", 0);
        map.put("rows", 5);
        int count = commentMapper.queryCmsCommentCount(map);
        List<CmsComment> commentList= commentMapper.queryCommentByCondition(map);
        bpAntique.setCommentCount(count);
        bpAntique.setCommentList(commentList);
		return bpAntique;
	}
}
