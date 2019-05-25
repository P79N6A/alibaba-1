package com.culturecloud.dao.square;

import java.util.List;

import com.culturecloud.dao.dto.CmsCulturalSquareActivityDTO;
import com.culturecloud.dao.dto.CmsCulturalSquareCityImgDTO;
import com.culturecloud.dao.dto.CmsCulturalSquareLiveImgDTO;
import com.culturecloud.dao.dto.CmsCulturalSquareNyImgDTO;
import com.culturecloud.dao.dto.CmsCulturalSquareSceneImgDTO;

public interface CmsCulturalSquareMapper {

	List<CmsCulturalSquareActivityDTO> getActivity(String activityId);
	
	List<CmsCulturalSquareActivityDTO> getActivityByImg(String activityImg);
	
	List<CmsCulturalSquareCityImgDTO> getCityImg(String cityImgUrl);
	
	List<CmsCulturalSquareSceneImgDTO> getSceneImg(String sceneImgUrl);
	
	List<CmsCulturalSquareActivityDTO> getActivityById(String activityId);
	
	List<CmsCulturalSquareNyImgDTO> getNyImg(String nyImgUrl);
	
	List<CmsCulturalSquareLiveImgDTO> getLive(String liveActivityId);
}
