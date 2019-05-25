package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.dao.dto.CmsCulturalSquareDto;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsCulturalSquareService;
import com.sun3d.why.util.PaginationApp;

@Service
@Transactional
public class CmsCulturalSquareServiceImpl implements CmsCulturalSquareService{
    
	@Autowired
	private CmsCulturalSquareMapper cmsCulturalSquareMapper;
	@Autowired
    private CmsCommentMapper commentMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    
	/**
     * 广场列表（时间降序+评论列表+点赞）
     * @param pageApp
     * @return
     */
	@Override
	public List<CmsCulturalSquareDto> getCultureSquareList(PaginationApp pageApp,String userId) {
		Map<String,Object> map=new HashMap<String, Object>();
		if(userId != null){
			map.put("userId", userId);
		}
		if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsCulturalSquareDto> list = cmsCulturalSquareMapper.queryCulturalSquareByCondition(map);
        for(CmsCulturalSquareDto cmsCulturalSquare:list){
        	map=new HashMap<String, Object>();
            map.put("commentRkId", cmsCulturalSquare.getOutId());
            map.put("firstResult", 0);
            map.put("rows", 5);
            int count = commentMapper.queryCmsCommentCount(map);
            List<CmsComment> commentList= commentMapper.queryCommentByCondition(map);
            cmsCulturalSquare.setCommentCount(count);
            cmsCulturalSquare.setCommentList(commentList);
        }
        return list;
	}

}
