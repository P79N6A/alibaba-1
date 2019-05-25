package com.sun3d.why.controller.front;

import java.io.PrintStream;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.extmodel.AttFile;
import com.sun3d.why.model.extmodel.CropImage;
import com.sun3d.why.model.extmodel.ImageFile;
import com.sun3d.why.service.ISysAttachmentService;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/att")
public class FrontUploaderController {
	@Autowired
	private ISysAttachmentService sysAttachmentService;
	
	@RequestMapping(value = "/upload")
	public void upload(HttpServletRequest request, HttpServletResponse response) {
		//System.out.println("test");
		JSONObject json=new JSONObject();
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		try{
			Map<String,MultipartFile> filesMap=multipartRequest.getFileMap();
			for(String key:filesMap.keySet()){
				//System.out.println("key:"+key);
				MultipartFile multiFile=filesMap.get(key);
				AttFile attFile=this.sysAttachmentService.addFile(multiFile);
				//System.out.println("mfile:"+filesMap.get(key));
				//System.out.println("key:"+multiFile.getName());
				//System.out.println("key:"+multiFile.getOriginalFilename());
				json.put("status", "success");
				json.put("url", attFile.getUrl());
				//System.out.println("url:"+attFile.getUrl());
				json.put("width", "1000");
				json.put("height", "800");
				
			}
			
			
			response.getWriter().print(json.toJSONString());
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("错误:"+e.toString());
		}
		
	}
	
	@RequestMapping(value = "/sliceImg", method=RequestMethod.POST)
	public void cut(HttpServletRequest request, HttpServletResponse response) {

		System.out.println("对图片开始切片");
		String url=request.getParameter("imageUrl");//图片路径
		String cuttWidth=request.getParameter("cutWidth").trim();//需要裁切的宽度
		String cutHeight=request.getParameter("cutHeight").trim();//高度
		String  coords = request.getParameter("cut_pos");//String里面拼接是xy坐标及放大后的图片尺寸
		String cropWidth = cuttWidth;
		String cropHeight= cutHeight;
		String x="";
		String y="";
		String initWidth ="";
		String initHeight ="";
		if(StringUtils.isNotBlank(coords)){
			String[] point = coords.split(",");
			x=point[0];
			y=point[1];
			initWidth=point[2];
			initHeight=point[3];
		}

		JSONObject json=new JSONObject();
		System.out.println("imgUrl:"+url);
		System.out.println("图片放大后的宽度imgInitW:"+initWidth);
		System.out.println("图片放大后的高度imgInitH:"+initHeight);
		System.out.println("imgX1:"+x);
		System.out.println("imgY1:"+y);
		System.out.println("裁剪的宽度cropW:"+cropWidth);
		System.out.println("裁剪的高度cropH:"+cropHeight);
		CropImage cImage=new CropImage();
		cImage.setUrl(url);
		cImage.setInitWidth(initWidth);
		cImage.setInitHeight(initHeight);
		cImage.setX(x);
		cImage.setY(y);
		cImage.setCropWidth(cropWidth);
		cImage.setCropHeight(cropHeight);
		try{
			ImageFile imgFile=this.sysAttachmentService.sliceImage(cImage);
			json.put("status", "success");
			json.put("url", imgFile.getUrl());
			System.out.println("url:"+imgFile.getUrl());
			json.put("width", imgFile.getWidth());
			json.put("height", imgFile.getHeight());
			System.out.println(json.toString());

			PrintWriter out = response.getWriter();
			out.print(json);
			out.flush();
			out.close();
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("错误:"+e.toString());
		}
	}

	@RequestMapping(value = "/uploadtest")
	public void uploadtest() {
		System.out.println("test");
	}


	/**跳转到裁剪jsp页面*/
	@RequestMapping(value="/toCutImgJsp", method = RequestMethod.GET)
	public ModelAndView toCutImg(HttpServletRequest request ){

		ModelAndView model = new ModelAndView();
		//图片的路径
//		String url = request.getParameter("imageURL");
////		//需要裁剪图片的大小  宽和高 以*号分隔
//		String cutImageWidht = request.getParameter("cutImageWidth");
//		String cutImageHeigth = request.getParameter("cutImageHeigth");
//
//		model.addObject("imageURL",url);
//		model.addObject("cutImageWidht",cutImageWidht);
//		model.addObject("cutImageHeigth",cutImageHeigth);
		model.setViewName("common/cutImage");
		return model;
	}
}
