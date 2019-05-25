package com.sun3d.why.service;

import com.sun3d.why.common.Result;
import com.sun3d.why.model.bean.yket.YketFavoriteKey;

public interface FavoriteService {
	Result favorite(YketFavoriteKey record);
	Result listFavoriteByUserId(String userId);

}
