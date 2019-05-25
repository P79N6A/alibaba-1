package com.sun3d.why.service;

import java.util.List;


import java.util.Map;

import com.sun3d.why.model.DcFrontUser;
import com.sun3d.why.model.DcVideo;
import com.sun3d.why.model.DcVote;
import com.sun3d.why.util.Pagination;

public interface DcVideoService {

	List<DcVideo> queryDcVideoByCondition(DcVideo dcVideo, Pagination page);
	
	DcVideo queryDcVideoByVideoId(String videoId);
	
	String editDcVideo(DcVideo dcVideo);
	
	String saveDcVideo(DcVideo dcVideo, DcFrontUser loginUser);
	
	String deleteDcVideo(String videoId);
	
	Map<String, Object> queryStatisticsIndex();
	
	List<DcVideo> queryWcDcVideoByCondition(DcVideo dcVideo);
	
	String saveDcVote(DcVote dcVote);
	
	String scoreDcVideo();
}
