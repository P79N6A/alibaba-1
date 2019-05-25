package com.sun3d.why.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.dao.ccp.CcpSceneImgMapper;
import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.model.ccp.CcpSceneImg;
import com.sun3d.why.service.CcpSceneImgService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@RequestMapping("/scene")
@Controller
public class CcpSceneImgController {

	@Autowired
	private CcpSceneImgService ccpSceneImgService;
	@Resource
    private CcpSceneImgMapper ccpSceneImgMapper;
	@Autowired
    private CmsCulturalSquareMapper cmsCulturalSquareMapper;
	@Autowired
	private HttpSession session;

	@RequestMapping("/sceneImgIndex")
	public ModelAndView sceneImgIndex(CcpSceneImg ccpSceneImg, Pagination page) {
		ModelAndView model = new ModelAndView();
		List<CcpSceneImg> list = ccpSceneImgService.querySceneImgByCondition(ccpSceneImg, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", ccpSceneImg);
		model.setViewName("admin/scene/sceneImgIndex");
		return model;
	}

	/**
     * 删除图片
     * @param request
     * @return
     */
    @RequestMapping(value = "/deleteSceneImg")
    @ResponseBody
    public String deleteSceneImg(String sceneImgId) {
    	return ccpSceneImgService.deleteSceneImg(sceneImgId);
    }
    
    /**
     * 审核通过
     * @param sceneImgId
     * @return
     */
    @RequestMapping("/checkPass")
    @ResponseBody
    public String checkPass(String sceneImgId){
    	try {
			String[] ImgId = sceneImgId.split(",");
			int rs=0;
			for (String id : ImgId) {
				CcpSceneImg ccpSceneImg = ccpSceneImgMapper.selectSceneImgList(new CcpSceneImg(id)).get(0);
				if(ccpSceneImg.getSceneStatus() == 0 || ccpSceneImg.getSceneStatus() == 2){
					ccpSceneImg.setSceneStatus(1);
					rs=ccpSceneImgService.update(ccpSceneImg);
					if(rs>0){
						CmsCulturalSquare cmsCulturalSquare = new CmsCulturalSquare();
						cmsCulturalSquare.setSquareId(UUIDUtils.createUUId());
						cmsCulturalSquare.setHeadUrl(ccpSceneImg.getUserHeadImgUrl());
						cmsCulturalSquare.setUserName(ccpSceneImg.getUserName());
						cmsCulturalSquare.setContextDec("参与了一个<span style='color: #c49123;font-size: 24px;'># 活动 #</span>");
						cmsCulturalSquare.setPublishTime(ccpSceneImg.getCreateTime());
						cmsCulturalSquare.setOutId(ccpSceneImg.getSceneImgId());
						cmsCulturalSquare.setType(2);
						cmsCulturalSquare.setExt0(ccpSceneImg.getSceneImgUrl());
						cmsCulturalSquare.setExt1(ccpSceneImg.getSceneImgContent());
						cmsCulturalSquare.setExt2("2");
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
    public String checkNoPass(String sceneImgId){
    	try {
			String[] ImgId = sceneImgId.split(",");
			int rs=0;
			for (String id : ImgId) {
				CcpSceneImg ccpSceneImg = ccpSceneImgService.querySceneImgById(id);
				ccpSceneImg.setSceneStatus(2);
				rs = ccpSceneImgService.update(ccpSceneImg);
				
				if(rs>0){
					//删除广场信息
			    	cmsCulturalSquareMapper.deleteByOutId(sceneImgId);
				}
			}
			return "200";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
    }
    
}
