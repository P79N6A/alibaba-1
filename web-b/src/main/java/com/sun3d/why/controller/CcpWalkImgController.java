package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.dao.ccp.CcpWalkImgMapper;
import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.model.ccp.CcpWalkImg;
import com.sun3d.why.service.CcpWalkImgService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@RequestMapping("/walk")
@Controller
public class CcpWalkImgController {

	@Autowired
	private CcpWalkImgService ccpWalkImgService;
	@Autowired
	private CcpWalkImgMapper ccpWalkImgMapper;
	@Autowired
    private CmsCulturalSquareMapper cmsCulturalSquareMapper;
	@Autowired
	private HttpSession session;

	@RequestMapping("/walkImgIndex")
	public ModelAndView walkImgIndex(CcpWalkImg ccpWalkImg, Pagination page) {
		ModelAndView model = new ModelAndView();
		List<CcpWalkImg> list = ccpWalkImgService.queryWalkImgByCondition(ccpWalkImg, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", ccpWalkImg);
		model.setViewName("admin/walk/walkImgIndex");
		return model;
	}

	/**
     * 删除图片
     * @param request
     * @return
     */
    @RequestMapping(value = "/deleteWalkImg")
    @ResponseBody
    public String deleteWalkImg(String walkImgId, String walkImgUrls) {
    	return ccpWalkImgService.deleteWalkImg(walkImgId, walkImgUrls);
    }
    
    /**
     * 审核通过
     * @param sceneImgId
     * @return
     */
    @RequestMapping("/checkPass")
    @ResponseBody
    public String checkPass(String walkImgId){
    	try {
			String[] ImgId = walkImgId.split(",");
			int rs=0;
			for (String id : ImgId) {
				CcpWalkImg ccpWalkImg = ccpWalkImgMapper.selectWalkImgList(new CcpWalkImg(id)).get(0);
				if(ccpWalkImg.getWalkStatus() == 0 || ccpWalkImg.getWalkStatus() == 2){
					ccpWalkImg.setWalkStatus(1);
					rs=ccpWalkImgService.update(ccpWalkImg);
					if(rs>0){
						CmsCulturalSquare cmsCulturalSquare = new CmsCulturalSquare();
						cmsCulturalSquare.setSquareId(UUIDUtils.createUUId());
						cmsCulturalSquare.setHeadUrl(ccpWalkImg.getUserHeadImgUrl());
						cmsCulturalSquare.setUserName(ccpWalkImg.getUserName());
						cmsCulturalSquare.setContextDec("参与了一个<span style='color: #c49123;font-size: 24px;'># 活动 #</span>");
						cmsCulturalSquare.setPublishTime(ccpWalkImg.getCreateTime());
						cmsCulturalSquare.setOutId(ccpWalkImg.getWalkImgId());
						cmsCulturalSquare.setType(2);
						cmsCulturalSquare.setExt0(ccpWalkImg.getWalkImgUrl());
						cmsCulturalSquare.setExt1(ccpWalkImg.getWalkImgName());
						cmsCulturalSquare.setExt2("4");
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
    public String checkNoPass(String walkImgId){
    	try {
			String[] ImgId = walkImgId.split(",");
			int rs=0;
			for (String id : ImgId) {
				CcpWalkImg ccpWalkImg = ccpWalkImgService.queryWalkImgById(id);
				ccpWalkImg.setWalkStatus(2);
				rs = ccpWalkImgService.update(ccpWalkImg);
				
				if(rs>0){
					//删除广场信息
			    	cmsCulturalSquareMapper.deleteByOutId(walkImgId);
				}
			}
			return "200";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
    }
    
    /**
     * 刷票
     * @param request
     * @return
     */
    @RequestMapping(value = "/brushWalkVote")
    @ResponseBody
    public String brushWalkVote(String walkImgId, Integer count) {
    	return ccpWalkImgService.brushWalkVote(walkImgId, count);
    }
}
