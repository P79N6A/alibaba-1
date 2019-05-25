package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.dao.ccp.CcpCityImgMapper;
import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.model.ccp.CcpCityImg;
import com.sun3d.why.service.CcpCityImgService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@RequestMapping("/city")
@Controller
public class CcpCityImgController {

	@Autowired
	private CcpCityImgService ccpCityImgService;
	@Autowired
	private CcpCityImgMapper ccpCityImgMapper;
	@Autowired
    private CmsCulturalSquareMapper cmsCulturalSquareMapper;
	@Autowired
	private HttpSession session;

	@RequestMapping("/cityImgIndex")
	public ModelAndView cityImgIndex(CcpCityImg ccpCityImg, Pagination page) {
		ModelAndView model = new ModelAndView();
		List<CcpCityImg> list = ccpCityImgService.queryCityImgByCondition(ccpCityImg, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", ccpCityImg);
		model.setViewName("admin/city/cityImgIndex");
		return model;
	}

	/**
     * 删除图片
     * @param request
     * @return
     */
    @RequestMapping(value = "/deleteCityImg")
    @ResponseBody
    public String deleteCityImg(String cityImgId, String cityImgUrls) {
    	return ccpCityImgService.deleteCityImg(cityImgId, cityImgUrls);
    }
    
    /**
     * 审核通过
     * @param sceneImgId
     * @return
     */
    @RequestMapping("/checkPass")
    @ResponseBody
    public String checkPass(String cityImgId){
    	try {
			String[] ImgId = cityImgId.split(",");
			int rs=0;
			for (String id : ImgId) {
				CcpCityImg ccpCityImg = ccpCityImgMapper.selectCityImgList(new CcpCityImg(id)).get(0);
				if(ccpCityImg.getCityStatus() == 0 || ccpCityImg.getCityStatus() == 2){
					ccpCityImg.setCityStatus(1);
					rs=ccpCityImgService.update(ccpCityImg);
					if(rs>0){
						CmsCulturalSquare cmsCulturalSquare = new CmsCulturalSquare();
						cmsCulturalSquare.setSquareId(UUIDUtils.createUUId());
						cmsCulturalSquare.setHeadUrl(ccpCityImg.getUserHeadImgUrl());
						cmsCulturalSquare.setUserName(ccpCityImg.getUserName());
						cmsCulturalSquare.setContextDec("参与了一个<span style='color: #c49123;font-size: 24px;'># 活动 #</span>");
						cmsCulturalSquare.setPublishTime(ccpCityImg.getCreateTime());
						cmsCulturalSquare.setOutId(ccpCityImg.getCityImgId());
						cmsCulturalSquare.setType(2);
						cmsCulturalSquare.setExt0(ccpCityImg.getCityImgUrl());
						cmsCulturalSquare.setExt1(ccpCityImg.getCityImgContent());
						cmsCulturalSquare.setExt2("1");
						cmsCulturalSquareMapper.insert(cmsCulturalSquare);
			    	}
				}
			}
			return "200";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
    }
    
    /**
     * 审核不通过
     * @param sceneImgId
     * @return
     */
    @RequestMapping("/checkNoPass")
    @ResponseBody
    public String checkNoPass(String cityImgId){
    	try {
			String[] ImgId = cityImgId.split(",");
			int rs=0;
			for (String id : ImgId) {
				CcpCityImg ccpCityImg = ccpCityImgService.queryCityImgById(id);
				ccpCityImg.setCityStatus(2);
				rs = ccpCityImgService.update(ccpCityImg);
				
				if(rs>0){
					//删除广场信息
			    	cmsCulturalSquareMapper.deleteByOutId(cityImgId);
				}
			}
			return "200";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
    }
    
}
