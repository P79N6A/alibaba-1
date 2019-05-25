package com.sun3d.why.webservice.api.service.impl;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.model.CmsApiFile;
import com.sun3d.why.webservice.api.service.CmsApiAttachmenetService;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Date;

@Service
public class CmsApiAttachmenetServiceImpl implements CmsApiAttachmenetService {
	private Logger logger = Logger.getLogger(CmsApiAttachmenetServiceImpl.class);
	@Autowired
	private BasePath basePath;
	@Autowired
	private StaticServer staticServer;

	@Override
	public String uploadImage(String strUrl, SysUser sysUser, String type) throws Exception {
		String imageUrl = "";
		try {
			String imgSuffix = this.getImgSuffix(strUrl);
			String dirPath = this.getFilePath(sysUser);
			imageUrl=this.upload(strUrl, imgSuffix, dirPath, type);

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("上传图片时发生错误：" + e.toString());
		}
		return imageUrl;
	}

	public String getFilePath(SysUser sysUser) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		sdf.applyPattern("yyyyMM");
		String uploadCode = sysUser.getUserCounty().split(",")[0] + "/" + sdf.format(new Date());
		StringBuffer fileUrl = new StringBuffer();
		fileUrl.append(uploadCode + "/" + Constant.IMG);
		/*********** 位置请不要挪动 *************/
		String dirPath = fileUrl.toString();
		return dirPath;
	}

	public String upload(String strUrl, String imgSuffix, String dirPath, String type) {
		String newImgName = Constant.IMG + UUIDUtils.createUUId();
		
		String imagePath = basePath.getBasePath() + dirPath;
		StringBuffer filePath = new StringBuffer();
		StringBuffer fullFilePath = new StringBuffer();
		StringBuffer uploadPath=new StringBuffer();
		filePath.append(basePath.getBasePath());
		filePath.append(dirPath);
		filePath.append(File.separator);
		fullFilePath.append(filePath.toString());
		fullFilePath.append(newImgName);
		fullFilePath.append(imgSuffix);
		
		uploadPath.append(dirPath);
		uploadPath.append("/");
		uploadPath.append(newImgName);
		uploadPath.append(imgSuffix);
		

		BufferedOutputStream stream = null;
		InputStream in = null;
		try {
			// 判断是否存在0*0文件夹，如果没有就创建
			File file = new File(filePath.toString());
			if (!file.exists()) {
				file.mkdirs();
			}

			stream = new BufferedOutputStream(new FileOutputStream(new File(fullFilePath.toString())));
			byte[] buf = new byte[1024];
			URL url = new URL(strUrl);
			URLConnection conn = url.openConnection();
			in = conn.getInputStream();
			int length = 0;
			while ((length = in.read(buf, 0, buf.length)) > 0) {
				stream.write(buf, 0, length);
			}
			stream.close();
			// 处理上传图片进行缩放,其他的格式不进行处理
			if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG")
					|| imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG")
					|| imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP")
					|| imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF")
					|| imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
				this.zoomFile(imagePath+"/"+newImgName,imgSuffix, type);
			}
		} catch (Exception e) {
			e.getStackTrace();
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

		}
		return uploadPath.toString();
	}

	public String getImgSuffix(String filePath) {
		String fileName = filePath;
		int imgSuffix = fileName.lastIndexOf(".");
		return fileName.substring(imgSuffix);
	}

	public void zoomFile(String imagePath, String imgSuffix, String type) throws IOException {

		// 拼接图片绝对路径
		String imageNewPath = imagePath+imgSuffix;
		InputStream is = new FileInputStream(imageNewPath);
		BufferedImage buff = ImageIO.read(is);
		int width = buff.getWidth();// 得到图片的宽度
		int height = buff.getHeight(); // 得到图片的高度
		// type 1代表切割广告图
		if (type != null && Integer.valueOf(type) == 1) {
			String fileNameSmall = imagePath + "_750_520" + imgSuffix;
			String fileNameBig = imagePath + "_1200_530" + imgSuffix;
			/*
			 *
			 * 将图片进行750*520,1200*530缩放；
			 */
			// 根据宽度的比例进行修改高度
			float blSmall = (float) 750 / (float) width;
			float newSmallHeight = (float) (blSmall * (float) height);
			float blBig = (float) 1200 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			is.close();
			String imgPathSmall = resizeImage(buff, fileNameSmall, 750, newSmallHeight);
			String imgPathBig = resizeImage(buff, fileNameBig, 1200, newBigHeight);
		}
		// 2代表切割活动图
		else if (type != null && Integer.valueOf(type) == 2) {
			String fileNameSmall = imagePath + "_300_300" + imgSuffix;
			String fileNameBig = imagePath + "_750_500" + imgSuffix;
			String fileNameMiddle = imagePath + "_150_100" + imgSuffix;
			/*
			 *
			 * 将图片进行300*300,750*500缩放；
			 */
			// 根据宽度的比例进行修改高度
			float blSmall = (float) 300 / (float) width;
			float newSmallHeight = (float) (blSmall * (float) height);
			float blBig = (float) 750 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			float blMiddle = (float)150/(float)width;
			float newMiddleHeight = (float)(blMiddle*(float)height);
			is.close();
			String imgPathSmall = resizeImage(buff, fileNameSmall, 300, newSmallHeight);
			String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
			String imgPathMiddle = resizeImage(buff, fileNameMiddle, 150, newMiddleHeight);
		}
		// 3代表切割展馆图
		else if (type != null && Integer.valueOf(type) == 3) {
			String fileNameSmall = imagePath + "_300_300" + imgSuffix;
			String fileNameBig = imagePath + "_750_500" + imgSuffix;
			/*
			 *
			 * 将图片进行300*300,750*500缩放；
			 */
			// 根据宽度的比例进行修改高度
			float blSmall = (float) 300 / (float) width;
			float newSmallHeight = (float) (blSmall * (float) height);
			float blBig = (float) 750 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			is.close();
			String imgPathSmall = resizeImage(buff, fileNameSmall, 300, newSmallHeight);
			String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
		}
		// 4代表切割团体图
		else if (type != null && Integer.valueOf(type) == 4) {
			String fileNameSmall = imagePath + "_300_300" + imgSuffix;
			String fileNameBig = imagePath + "_750_500" + imgSuffix;
			/*
			 *
			 * 将图片进行300*300,750*500缩放；
			 */
			// 根据宽度的比例进行修改高度
			float blSmall = (float) 300 / (float) width;
			float newSmallHeight = (float) (blSmall * (float) height);
			float blBig = (float) 750 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			is.close();
			String imgPathSmall = resizeImage(buff, fileNameSmall, 300, newSmallHeight);
			String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
		}
		// 5代表切割活动室图片
		else if (type != null && Integer.valueOf(type) == 5) {
			String fileNameSmall = imagePath + "_300_300" + imgSuffix;
			String fileNameBig = imagePath + "_750_500" + imgSuffix;
			/*
			 *
			 * 将图片进行300*300,750*500缩放；
			 */
			// 根据宽度的比例进行修改高度
			float blSmall = (float) 300 / (float) width;
			float newSmallHeight = (float) (blSmall * (float) height);
			float blBig = (float) 750 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			is.close();
			String imgPathSmall = resizeImage(buff, fileNameSmall, 300, newSmallHeight);
			String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
		}
		// 6代表切割藏品图片
		else if (type != null && Integer.valueOf(type) == 6) {
			String fileNameSmall = imagePath + "_300_300" + imgSuffix;
			String fileNameBig = imagePath + "_750_500" + imgSuffix;
			/*
			 *
			 * 将图片进行300*300,750*500缩放；
			 */
			// 根据宽度的比例进行修改高度
			float blSmall = (float) 300 / (float) width;
			float newSmallHeight = (float) (blSmall * (float) height);
			float blBig = (float) 750 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			is.close();
			String imgPathSmall = resizeImage(buff, fileNameSmall, 300, newSmallHeight);
			String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
		}
		// 7代表切割app图片
		else if (type != null && Integer.valueOf(type) == 7) {
			String fileNameSmall = imagePath + "_300_300" + imgSuffix;
			String fileNameBig = imagePath + "_750_500" + imgSuffix;
			/*
			 *
			 * 将图片进行300*300,750*500缩放；
			 */
			// 根据宽度的比例进行修改高度
			float blSmall = (float) 300 / (float) width;
			float newSmallHeight = (float) (blSmall * (float) height);
			float blBig = (float) 750 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			is.close();
			String imgPathSmall = resizeImage(buff, fileNameSmall, 300, newSmallHeight);
			String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
		}
		// 8代表切割会员图片
		else if (type != null && Integer.valueOf(type) == 8) {
			String fileNameSmall = imagePath + "_300_300" + imgSuffix;
			String fileNameBig = imagePath + "_750_500" + imgSuffix;
			/*
			 *
			 * 将图片进行300*300,750*500缩放；
			 */
			// 根据宽度的比例进行修改高度
			float blSmall = (float) 300 / (float) width;
			float newSmallHeight = (float) (blSmall * (float) height);
			float blBig = (float) 750 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			is.close();
			String imgPathSmall = resizeImage(buff, fileNameSmall, 300, newSmallHeight);
			String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
		}
		// 9代表ckeditor插件里的上传图片
		else if (type != null && Integer.valueOf(type) == 9) {
			String fileNameBig = imagePath + "_750_500" + imgSuffix;
			/*
			 *
			 * 将图片进行300*300,750*500缩放；
			 */
			float blBig = (float) 750 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			is.close();
			String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
		}
		// 10代表切割头像
		else if (type != null && Integer.valueOf(type) == 10) {
			String fileNameSmall = imagePath + "_300_300" + imgSuffix;
			String fileNameBig = imagePath + "_750_500" + imgSuffix;
			/*
			 *
			 * 将图片进行300*300,750*500缩放；
			 */
			// 根据宽度的比例进行修改高度
			float blSmall = (float) 300 / (float) width;
			float newSmallHeight = (float) (blSmall * (float) height);
			float blBig = (float) 750 / (float) width;
			float newBigHeight = (float) (blBig * (float) height);
			is.close();
			String imgPathSmall = resizeImage(buff, fileNameSmall, 300, newSmallHeight);
			String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
		}
	}

	public static String resizeImage(BufferedImage src, String toImagePath, int width, float height)
			throws IOException {
		FileOutputStream out = null;
		try {
			// 放大边长
			BufferedImage tag = new BufferedImage(width, (int) height, BufferedImage.TYPE_INT_RGB);
			// 绘制放大后的图片
			tag.getGraphics().drawImage(src, 0, 0, width, (int) height, null);
			out = new FileOutputStream(toImagePath);
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
			encoder.encode(tag);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				out.close();
			}
		}
		return toImagePath;
	}

	@Override
	public CmsApiFile checkImage(String strUrl) {
		InputStream in = null;
		CmsApiFile cmsApiFile=new CmsApiFile();
		try{
			String imgSuffix = this.getImgSuffix(strUrl);
			if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG")
					|| imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG")
					|| imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP")
					|| imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF")){
				URL url = new URL(strUrl);
				URLConnection conn = (URLConnection)url.openConnection();
				conn.setConnectTimeout(6*1000);
				int size=conn.getContentLength();
				if(size>0&&size<=CmsApiStatusConstant.ATT_MAX_SIZE){
//					in = conn.getInputStream();
//					BufferedImage buff = ImageIO.read(in);
//					int width = buff.getWidth();// 得到图片的宽度
//					int height = buff.getHeight(); // 得到图片的高度
//
//					if(width>=CmsApiStatusConstant.IMG_SMALL_SIZE){
//						cmsApiFile.setWidth(width);
//						cmsApiFile.setHeight(height);
//						cmsApiFile.setSize(size);
//						cmsApiFile.setSuccess(1);
//						cmsApiFile.setMsg("校验成功 ！");
//					}
//					else{
//						cmsApiFile.setSuccess(0);
//						cmsApiFile.setMsg("图片宽度低于"+CmsApiStatusConstant.IMG_SMALL_SIZE+" 像素不能上传!");
//					}
					cmsApiFile.setWidth(0);
					cmsApiFile.setHeight(0);
					cmsApiFile.setSize(size);
					cmsApiFile.setSuccess(1);
					cmsApiFile.setMsg("校验成功 ！");
				}
				else{
					cmsApiFile.setSuccess(0);
					cmsApiFile.setMsg("图片链接地址错误或图片大小超过2M，无法上传!");
				}
				
				
			}
			else{
				cmsApiFile.setSuccess(0);
				cmsApiFile.setMsg("上传的不是图片，无法上传到系统中!");
				//不是图片
			}
			
		}
		catch(Exception e){
			e.printStackTrace();
			cmsApiFile.setSuccess(0);
			cmsApiFile.setMsg("错误!"+e.toString());
		}
		finally{

			if(in!=null){
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		
		return cmsApiFile;
	}

}
