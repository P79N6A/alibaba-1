package com.culturecloud.service.rs.platformservice.live;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.bean.BaseRequest;
import com.culturecloud.coreutils.CryptUtils;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.dto.live.CmsCulturalSquareLiveImgDTO;
import com.culturecloud.dao.live.CcpLiveActivityMapper;
import com.culturecloud.model.bean.live.CcpLiveActivity;
import com.culturecloud.model.bean.square.CmsCulturalSquare;
import com.culturecloud.model.request.common.SysUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveActivityDetailVO;
import com.culturecloud.model.request.live.CcpLiveActivityPageVO;
import com.culturecloud.model.request.live.CcpRecommendLiveListVO;
import com.culturecloud.model.request.live.SaveCcpLiveActivityVO;
import com.culturecloud.model.request.live.UpdateCcpLiveActivityVO;
import com.culturecloud.model.response.live.CcpLiveActivityVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.live.CcpLiveActivityService;

@Component
@Path("/liveActivity")
public class CcpLiveActivityResource {

	@Autowired
	private BaseService baseService;
	@Autowired
	private CcpLiveActivityService ccpLiveActivityService;
	@Autowired
	private CcpLiveActivityMapper ccpLiveActivityMapper;

	@POST
	@Path("/createUserInfo")
	@SysBusinessLog(remark = "创建直播活动用户信息")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpLiveActivityVO createUserInfo(SysUserDetailVO request) {

		CcpLiveActivityVO vo = ccpLiveActivityService.queryUserInfo(request);

		return vo;
	}

	@POST
	@Path("/create")
	@SysBusinessLog(remark = "创建直播活动")
	@Produces(MediaType.APPLICATION_JSON)
	public String create(SaveCcpLiveActivityVO request) {

		CcpLiveActivity live = new CcpLiveActivity();
		live.setLiveActivityId(UUIDUtils.createUUId());
		live.setLiveCoverImg(request.getLiveCoverImg());
		live.setLiveCreateTime(new Date());
		live.setLiveCreateUser(request.getLiveCreateUser());
		live.setLiveStartTime(request.getLiveStartTime());
		live.setLiveStatus(0);
		live.setLiveTitle(request.getLiveTitle());
		live.setLiveIsDel(1);
		live.setLiveType(request.getLiveType());
		live.setLiveCheck(1);
		live.setLiveWatermarkImg(request.getLiveWatermarkImg());
		live.setLiveWatermarkImgPosition(request.getLiveWatermarkImgPosition());
		live.setLiveWatermarkText(request.getLiveWatermarkText());
		live.setLiveBackgroudCover(request.getLiveBackgroudCover());
		live.setLiveBackgroudMusic(request.getLiveBackgroudMusic());
		baseService.create(live);

		String liveActivityId = live.getLiveActivityId();

		return liveActivityId;
	}

	@POST
	@Path("/update")
	@SysBusinessLog(remark = "更新直播活动")
	@Produces(MediaType.APPLICATION_JSON)
	public int update(UpdateCcpLiveActivityVO request) throws Exception {

		CcpLiveActivity live = new CcpLiveActivity();

		Integer liveStatus = request.getLiveStatus();
		Integer liveCheck = request.getLiveCheck();

		live.setLiveActivityId(request.getLiveActivityId());
		live.setLiveTitle(request.getLiveTitle());
		live.setLiveTopText(request.getLiveTopText());
		live.setLiveStatus(liveStatus);
		live.setLiveCoverImg(request.getLiveCoverImg());
		live.setLiveStartTime(request.getLiveStartTime());
		live.setLiveCheck(liveCheck);
		live.setLiveWatermarkImg(request.getLiveWatermarkImg());
		live.setLiveWatermarkImgPosition(request.getLiveWatermarkImgPosition());
		live.setLiveWatermarkText(request.getLiveWatermarkText());
		live.setLiveBackgroudCover(request.getLiveBackgroudCover());
		live.setLiveBackgroudMusic(request.getLiveBackgroudMusic());
		live.setLiveIsDel(request.getLiveIsDel());

		if (liveStatus != null && liveStatus == 2) {
			live.setLiveEndTime(new Date());
		}

		if (liveCheck != null && liveCheck == 2) {
			live.setLiveCheckTime(new Date());
		}

		baseService.update(live, " where live_activity_id='" + request.getLiveActivityId() + "'");

		// 同步广场
		if (liveCheck != null && liveCheck == 2) {
			List<CmsCulturalSquareLiveImgDTO> ss = ccpLiveActivityMapper.getLive(request.getLiveActivityId());
			if (ss != null && ss.size() > 0) {
				CmsCulturalSquare ccs = new CmsCulturalSquare();
				ccs.setSquareId(com.culturecloud.utils.StringUtils.getUUID());
				ccs.setType(6);
				ccs.setContextDec("发布了一个<span style=\"color: #c49123;font-size: 24px;\"># 直播  #</span>");
				ccs.setOutId(ss.get(0).getLiveImgId());
				ccs.setExt1(ss.get(0).getLiveContent());
				ccs.setExt0(ss.get(0).getLiveUrl());
				SimpleDateFormat myFmt3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date sa = myFmt3.parse(ss.get(0).getStartTime());
				// ccs.setPublishTime(myFmt2.format(s));
				ccs.setExt2(myFmt3.format(sa));

				SimpleDateFormat myFmt2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date s = myFmt2.parse(ss.get(0).getCreateTime());
				ccs.setPublishTime(myFmt2.format(s));
				// ccs.setPublishTime(ss.get(0).getCreateTime());
				if (ss.get(0).getUserNickName() != null) {
					ccs.setUserName(ss.get(0).getUserNickName());
				}
				if (ss.get(0).getHeadUrl() != null) {
					ccs.setHeadUrl(ss.get(0).getHeadUrl());
				}
				baseService.create(ccs);
			}
		}

		return 1;
	}

	@POST
	@Path("/toDetail")
	@SysBusinessLog(remark = "直播活动详情")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpLiveActivityVO toDetail(CcpLiveActivityDetailVO vo) {

		String liveActivityId = vo.getLiveActivityId();

		CcpLiveActivityVO result = ccpLiveActivityService.queryByLiveActivityId(liveActivityId);

		String liveWatermarkImg = result.getLiveWatermarkImg();
		
		Integer liveWatermarkImgPosition= result.getLiveWatermarkImgPosition();
		
		String watermarkHtml="";
		
		String watermarkHtml2="";
		
		// 水印位置 	
		// 取值范围：[nw,north,ne,west,center,east,ne,south]
		// http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/pic/44957/cn_zh/1484279670183/%E6%B0%B4%E5%8D%B0%E4%BD%8D%E7%BD%AE.png?x-oss-process=image/resize,w_400
		String g="g_se";

		if(liveWatermarkImgPosition!=null){
			switch (liveWatermarkImgPosition) {
			case 1:
				g="g_se";
				break;
			case 2:
				g="g_south";
				break;
			case 3:
				g="g_center";
				break;
			default:
				break;
			}
		}

		if (StringUtils.isNotBlank(liveWatermarkImg)) {

			LinkedHashMap<String, String> watermarkMap = getWatermarkList();

			String waterImg = watermarkMap.get(liveWatermarkImg);

			if (StringUtils.isNotBlank(waterImg)) {
				
				watermarkHtml="/watermark,image_"+waterImg+","+g;
				
				watermarkHtml2="/watermark,image_"+waterImg+","+g;
			}
		}

		String liveBackgroudMusic = result.getLiveBackgroudMusic();

		if (StringUtils.isNotBlank(liveBackgroudMusic)) {

			LinkedHashMap<String, String> backgroundMusicMap = getBackgroundMusicList();

			String backgroudMusic = backgroundMusicMap.get(liveBackgroudMusic);

			result.setBackgroudMusic(backgroudMusic);
		}
		
		String liveWatermarkText=result.getLiveWatermarkText();
		
		if (StringUtils.isNotBlank(liveWatermarkText)) {
			

			String watermarkText=this.bytesToBase64(liveWatermarkText);
			
			if(StringUtils.isNotBlank(watermarkHtml)){
				
				watermarkHtml+=",y_30,voffset_60/watermark,text_"+watermarkText+",color_FFFFFF,size_18"+",order_1,"+g;
				
				watermarkHtml2+=",y_30,voffset_60/watermark,text_"+watermarkText+",color_FFFFFF,size_22"+",order_1,"+g;
			}
			else {
				watermarkHtml="/watermark,text_"+watermarkText+",color_FFFFFF,size_25"+",order_1,"+g;
				watermarkHtml2="/watermark,text_"+watermarkText+",color_FFFFFF,size_50"+",order_1,"+g;
			}
		}
		result.setWatermarkHtml(watermarkHtml);result.setWatermarkHtml2(watermarkHtml2);
		return result;
	}

	@POST
	@Path("/liveActivityList")
	@SysBusinessLog(remark = "直播活动列表")
	@Produces(MediaType.APPLICATION_JSON)
	public BasePageResultListVO<CcpLiveActivityVO> liveActivityList(CcpLiveActivityPageVO request) {

		return ccpLiveActivityService.getLiveActivityList(request);
	}

	@POST
	@Path("/liveActivityHotList")
	@SysBusinessLog(remark = "热门直播活动列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpLiveActivityVO> liveActivityHotList(BaseRequest request) {

		return ccpLiveActivityService.getLiveActivityHotList();
	}

	@POST
	@Path("/selectIndexNum")
	@SysBusinessLog(remark = "直播用户详情")
	@Produces(MediaType.APPLICATION_JSON)
	public Integer selectIndexNum(CcpLiveActivityPageVO request) {

		Integer result = null;

		result = ccpLiveActivityService.selectIndexNum(request);

		return result;
	}

	@POST
	@Path("/watermarkList")
	@SysBusinessLog(remark = "直播水印图片列表")
	@Produces(MediaType.APPLICATION_JSON)
	public JSONArray watermarkList(BaseRequest request) {

		JSONArray array = new JSONArray();

		String[] imgArray = new String[] {
				// 水印1
				"http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017329104132M8GDczDk2aqZEzmYucDaIq3ISJeEaj.png",
				// 水印2
				"http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017329143448cjrC6TyYG7cF5idPo3WO7YjQY0MkIO.png",
				// 水印3
				"http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017329143513sJeymobYgsjqXQDwEkMvN6Sl0KeMXI.png",
				// 水印4
				"http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017329143533MohesNV15gIU4DPgY8XMq0Nkj4Vloj.png" };

		int i = 0;

		LinkedHashMap<String, String> map = getWatermarkList();

		for (Entry<String, String> entry : map.entrySet()) {

			JSONObject water = new JSONObject();

			String key = entry.getKey();
			String value = entry.getValue();

			water.put("value", value);
			water.put("name", key);
			water.put("url", imgArray[i]);

			array.add(water);
			
			i++;
		}

		return array;

	}

	@POST
	@Path("/backgroundMusicList")
	@SysBusinessLog(remark = "直播背景音乐列表")
	@Produces(MediaType.APPLICATION_JSON)
	public JSONArray backgroundMusicList(BaseRequest request) {

		LinkedHashMap<String, String> map = getBackgroundMusicList();

		JSONArray array = new JSONArray();

		for (Entry<String, String> entry : map.entrySet()) {

			JSONObject music = new JSONObject();

			String key = entry.getKey();
			String value = entry.getValue();

			music.put("name", value);
			music.put("url", key);

			array.add(music);
		}

		return array;

	}

	@POST
	@Path("/userLiveTotalInfo")
	@SysBusinessLog(remark = "直播用户信息统计")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> userLiveTotalInfo(SysUserDetailVO request) {

		String userId = request.getUserId();

		Map<String, Object> map = ccpLiveActivityService.userLiveTotalInfo(userId);

		return map;
	}
	
	@POST
	@Path("/recommendLiveList")
	@SysBusinessLog(remark = "推荐活动列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpLiveActivityVO> recommendLiveList(CcpRecommendLiveListVO request){
		
		return ccpLiveActivityService.getLiveActivityRecommendList(request);
	}

	private LinkedHashMap<String, String> getBackgroundMusicList() {

		LinkedHashMap<String, String> set = new LinkedHashMap<String, String>();

		set.put("http://m.wenhuayun.cn/STATIC/live/audio/river+waltz.mp3", "背景音乐一");
		set.put("http://m.wenhuayun.cn/STATIC/live/audio/We+Are+One+-+Vexento.mp3", "背景音乐二");

		return set;
	}

	private LinkedHashMap<String, String> getWatermarkList() {

		LinkedHashMap<String, String> set = new LinkedHashMap<String, String>();

		// 水印1
		// http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017329104132M8GDczDk2aqZEzmYucDaIq3ISJeEaj.png
		// 水印2
		// http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017329143448cjrC6TyYG7cF5idPo3WO7YjQY0MkIO.png
		// 水印3
		// http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017329143513sJeymobYgsjqXQDwEkMvN6Sl0KeMXI.png
		// 水印4
		// http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017329143533MohesNV15gIU4DPgY8XMq0Nkj4Vloj.png

		set.put("水印一",
				"SDUvMjAxNzMyOTEwNDEzMk04R0RjekRrMmFxWkV6bVl1Y0RhSXEzSVNKZUVhai5wbmc_eC1vc3MtcHJvY2Vzcz1pbWFnZS9yZXNpemUsUF8zMA");
		set.put("水印二",
				"SDUvMjAxNzMyOTE0MzQ0OGNqckM2VHlZRzdjRjVpZFBvM1dPN1lqUVkwTWtJTy5wbmc_eC1vc3MtcHJvY2Vzcz1pbWFnZS9yZXNpemUsUF8zMA");
		set.put("水印三",
				"SDUvMjAxNzMyOTE0MzUxM3NKZXltb2JZZ3NqcVhRRHdFa012TjZTbDBLZU1YSS5wbmc_eC1vc3MtcHJvY2Vzcz1pbWFnZS9yZXNpemUsUF8zMA");
		set.put("水印四",
				"SDUvMjAxNzMyOTE0MzUzM01vaGVzTlYxNWdJVTREUGdZOFhNcTBOa2o0Vmxvai5wbmc_eC1vc3MtcHJvY2Vzcz1pbWFnZS9yZXNpemUsUF8zMA");

		return set;

	}

	private String bytesToBase64(String str){
		
		String c = CryptUtils.bytesToBase64(str.getBytes());
		//
		String encodeForUrl = c;
		// 转成针对url的base64编码
		encodeForUrl = encodeForUrl.replace("=", "");
		encodeForUrl = encodeForUrl.replace("+", "-");
		encodeForUrl = encodeForUrl.replace("/", "_");
		// 去除换行
		encodeForUrl = encodeForUrl.replace("\n", "");
		encodeForUrl = encodeForUrl.replace("\r", "");

		// 转换*号为 -x-
		// 防止有违反协议的字符

		encodeForUrl = encodeForUrl.replace("-x", "-xx");
		encodeForUrl = encodeForUrl.replace("*", "-x-");

		return encodeForUrl;
		
	}
	
	public static void main(String[] args) {
		
		String s=new CcpLiveActivityResource().bytesToBase64("H5/2017329143533MohesNV15gIU4DPgY8XMq0Nkj4Vloj.png?x-oss-process=image/resize,P_30");

		System.out.println(s);
	}
}
