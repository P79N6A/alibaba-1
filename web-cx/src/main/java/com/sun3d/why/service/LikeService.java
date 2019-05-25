package com.sun3d.why.service;

import com.sun3d.why.common.Result;
import com.sun3d.why.model.bean.yket.YketLikeKey;

public interface LikeService {
	Result like(YketLikeKey record);
}
