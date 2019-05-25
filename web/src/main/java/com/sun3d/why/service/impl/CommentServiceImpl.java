package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.model.CmsComment;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.model.bean.square.CmsCulturalSquare;
import com.sun3d.why.common.Result;
import com.sun3d.why.dao.YketCommentMapper;
import com.sun3d.why.enumeration.CommentTypeEnum;
import com.sun3d.why.enumeration.RSKeyEnum;
import com.sun3d.why.exception.UserReadableException;
import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketComment;
import com.sun3d.why.model.vo.yket.CommentListVo;
import com.sun3d.why.service.CommentService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
@Service
public class CommentServiceImpl implements CommentService {

	@Autowired
	private YketCommentMapper commentMapper;
	@Autowired
	private CmsCommentMapper cmsCommentMapper;
	
	@Override
	public Result comment(YketComment comment) {
		try{
		this.commentMapper.insert(comment);
		}catch(Exception e){
			e.printStackTrace();
			throw new UserReadableException("评论失败");
		}
		return Result.Ok();
	}

	@Override
	public List<YketComment> queryCommentByCondition(YketComment comment,
			Integer firstResult, Integer rows) {
        Map<String, Object> map = new HashMap<String, Object>();
		
		if(comment != null){
			if (StringUtils.isNotBlank(comment.getObjectId())){
                map.put("objectId", comment.getObjectId());
            }
            if (StringUtils.isNotBlank(comment.getUserId())){
            	map.put("userId", comment.getUserId());
            }
		}
		
		//分页
        if (firstResult != null && rows != null) {
            map.put("firstResult", firstResult);
            map.put("rows", rows);
        }
		return this.commentMapper.queryCommentByCondition(map);
	}

	@Override
	public List<YketComment> queryCommentList(String courseId, Pagination page, String commentType) {
		Map<String, Object> conds = new HashMap<String, Object>();
		
		if(!StringUtils.isEmpty(courseId)){
			conds.put("objectId", courseId);
		}
		
		if(!StringUtils.isEmpty(commentType)){
			conds.put("commentType", CommentTypeEnum.valueOf(commentType).getIndex());
		}
		
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			conds.put("firstResult", page.getFirstResult());
			conds.put("rows", page.getRows());
			Integer total = this.commentMapper.countComment(conds);
			page.setTotal(total);
		}
		return this.commentMapper.queryCommentList(conds);
	}

	@Override
	public Result handPick(String commentId) {
         try {
        	 YketComment comment = this.commentMapper.selectByPrimaryKey(commentId);
			if(comment.getTopFlag()!=null&&comment.getTopFlag()==0)
			{
				comment.setTopFlag((byte)1);
				if(comment.getTopFlag() == 1){
					comment.setTopFlag((byte)0);
					commentMapper.update(comment);
				}
				comment.setTopFlag((byte)1);
				commentMapper.updateByPrimaryKeySelective(comment);
				return Result.Ok();
			}
			
			if(comment.getTopFlag()!=null&&comment.getTopFlag()==1)
			{
				comment.setTopFlag((byte)0);
				commentMapper.updateByPrimaryKeySelective(comment);
				return Result.Ok();
			}
		} catch (Exception e) {
			e.printStackTrace();
			return Result.Error().setVal(RSKeyEnum.msg, "操作失败！");
		} 
		return null;
	}

	@Override
	public Result deleteComment(String commentId, SysUser user) {
		if(StringUtils.isEmpty(commentId)){
			return Result.Error().setVal(RSKeyEnum.msg, "评论不存在！");
		}
		YketComment comment = this.commentMapper.selectByPrimaryKey(commentId);
		if(comment==null){
			return Result.Error().setVal(RSKeyEnum.msg, "评论不存在！");
		}
		comment.setCheckStatus(1);
		comment.setUpdateTime(new Date());
		comment.setUpdateUser(user.getUserId());
		int rs = this.commentMapper.updateByPrimaryKeySelective(comment);
		return Result.Ok();
	}
	
	@Override
	public List<CommentListVo> queryCommentByCondition(String commentType, String objectId, Integer firstResult,
			Integer rows) {
        Map<String, Object> map = new HashMap<String, Object>();
        
    	if (!StringUtils.isEmpty(commentType)){
            map.put("commentType", CommentTypeEnum.valueOf(commentType).getIndex());
        }
    	if (!StringUtils.isEmpty(objectId)){
            map.put("objectId", objectId);
        }

		//分页
        if (firstResult != null && rows != null) {
            map.put("firstResult", firstResult);
            map.put("rows", rows);
        }
	 	return this.commentMapper.queryCommentByCondition4Front(map);
	}
}
