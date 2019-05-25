package com.sun3d.why.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.common.Result;
import com.sun3d.why.dao.YketFavoriteMapper;
import com.sun3d.why.enumeration.RSKeyEnum;
import com.sun3d.why.exception.UserReadableException;
import com.sun3d.why.model.bean.yket.YketFavoriteKey;
import com.sun3d.why.service.FavoriteService;

@Service
public class FavoriteServiceImpl implements FavoriteService {

	@Autowired
	YketFavoriteMapper favoriteMapper;

	@Override
	public Result favorite(YketFavoriteKey record) {
		YketFavoriteKey exist = this.favoriteMapper.selectById(record);
		try {
			if (exist == null) {
				this.favoriteMapper.insert(record);
			} else {
				this.favoriteMapper.deleteByPrimaryKey(record);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new UserReadableException("收藏失败");
		}
		return Result.Ok();
	}

	@Override
	public Result listFavoriteByUserId(String userId) {
 		return Result.Ok().setVal(RSKeyEnum.data, this.favoriteMapper.listFavoriteByUserId(userId));
	}
}
