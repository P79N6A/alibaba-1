package com.sun3d.why.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.common.Result;
import com.sun3d.why.dao.YketLikeMapper;
import com.sun3d.why.exception.UserReadableException;
import com.sun3d.why.model.bean.yket.YketLikeKey;
import com.sun3d.why.service.LikeService;

@Service
public class LikeServiceImpl implements LikeService {

	@Autowired
	private YketLikeMapper likeMapper;

	/**
	 * 点赞、取消点赞
	 */
	@Override
	public Result like(YketLikeKey record) {
		YketLikeKey exist = this.likeMapper.selectById(record);
		try {
			if (exist == null) {
				this.likeMapper.insert(record);
			} else {
				this.likeMapper.deleteByPrimaryKey(record);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new UserReadableException("点赞失败");
		}
		return Result.Ok();
	}

}
