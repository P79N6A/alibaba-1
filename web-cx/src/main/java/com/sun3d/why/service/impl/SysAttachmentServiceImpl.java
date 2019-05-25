package com.sun3d.why.service.impl;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.*;
import com.sun3d.why.service.ISysAttachmentService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.IOUtil;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.util.UUIDUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;

@Service
public class SysAttachmentServiceImpl implements ISysAttachmentService {

	private Logger logger = Logger.getLogger(this.getClass());

	@Autowired
	private BasePath basePath;

	@Autowired
	private HttpSession session;
	@Override
	public AttFile addFile(String strUrl) throws Exception {
		String fileName=this.getFileName(strUrl);
		AttFile attFile=this.addFile(strUrl, fileName);
		return attFile;
	}
	
	public AttFile addFile(String strUrl,String fileName) throws Exception {
		
		InputStream in =this.getUrlStream(strUrl);
		AttFile attFile=this.createFile(in, fileName);
		return attFile;
	}
	
	public InputStream getUrlStream(String strUrl) throws Exception{
//		System.setProperty("sun.net.client.defaultConnectTimeout", "5000");
//		System.setProperty("sun.net.client.defaultReadTimeout", "10000");
		/*URL url = new URL(strUrl);
		URLConnection conn = url.openConnection();
		conn.setConnectTimeout(5000);
		conn.setReadTimeout(10000);
		InputStream in = conn.getInputStream();*/

		URL url = new URL(strUrl);
		String imgPath = url.getPath();
		File file = new File(basePath.getBasePath()+imgPath);
		InputStream in = new FileInputStream(file);
		return in;
	}
	
	@Override
	public void addComprassImage(String filePath) throws Exception {

	}

	@Override
	public AttFile addFile(MultipartFile multiFile) throws Exception {
		AttFile attFile = this.createFile(multiFile);
		return attFile;
	}

	@Override
	public String upload(HttpServletRequest request) throws Exception {
		return null;
	}

	
	private void createFile(String path) throws Exception {
		File file = new File(path);
		File pfile = file.getParentFile();
		if (!pfile.exists()) {
			pfile.mkdirs();
		}
		if (file.exists()) {
			file.delete();
		}
		file.createNewFile();
	}

	@Override
	public ImageFile addImage(MultipartFile multiFile) throws Exception {
		AttFile attFile = this.createFile(multiFile);
		ImageFile imgFile = new ImageFile();
		imgFile.setFileName(attFile.getFileName());
		imgFile.setFilePath(attFile.getFilePath());
		imgFile.setUrl(attFile.getUrl());
		imgFile.setFileSize(attFile.getFileSize());
		String imgSuffix = this.getImgSuffix(imgFile.getFileName());

		if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG")
				|| imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG")
				|| imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP")
				|| imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF")
				|| imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
			ImageSize imgSize = this.getImageSize(attFile.getFilePath());
			imgFile.setWidth(imgSize.getWidth());
			imgFile.setHeight(imgSize.getHeight());

		}
		return imgFile;
	}

	public AttFile createFile(MultipartFile multiFile) throws Exception {
		AttFile attFile = new AttFile();
		ByteArrayInputStream byteArrayInputStream = null;
		InputStream in = null;
		FileOutputStream out = null;
		if (multiFile != null) {
			// String fileName=multiFile.getName();
			String fileName = multiFile.getOriginalFilename();
			String fileType=this.getImgSuffix(fileName);
			
			String dir = this.formatPath();
			String newImgName=UUIDUtils.createUUId();
			String file = dir + "/" + newImgName+fileType;
			this.createFile(file);
			out = new FileOutputStream(file);
			in = multiFile.getInputStream();
			attFile=this.createFile(in, newImgName+fileType);
		}

		IOUtil.close(in);
		IOUtil.close(byteArrayInputStream);
		IOUtil.close(out);
		return attFile;

	}

	public AttFile createFile(InputStream in,String fileName) throws Exception {
		AttFile attFile = new AttFile();
		ByteArrayInputStream byteArrayInputStream = null;
		FileOutputStream out = null;
		String dir = this.formatPath();
		String file = dir + "/" + fileName;
		this.createFile(file);
		out = new FileOutputStream(file);
		
		int fileSize = IOUtil.write(in, out);
		String url = this.getStaticUrl() + fileName;
		attFile.setFileName(fileName);
		attFile.setFilePath(file);
		attFile.setFileSize(fileSize);
		attFile.setUrl(url);

		IOUtil.close(in);
		IOUtil.close(byteArrayInputStream);
		IOUtil.close(out);
		return attFile;

	}

	public ImageSize getImageSize(String imagePath) {
		ImageSize imageFile = new ImageSize();
		InputStream is;
		int width = 0, height = 0;
		try {
			is = new FileInputStream(imagePath);
			BufferedImage buff;
			buff = ImageIO.read(is);
			width = buff.getWidth();// 得到图片的宽度
			height = buff.getHeight(); // 得到图片的高度
			imageFile.setWidth(width);
			imageFile.setHeight(height);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			System.out.println("错误:" + e.toString());
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("错误:" + e.toString());
		}
		return imageFile;

	}

	public String getImgSuffix(String filePath) {
		String fileName = filePath;
		int imgSuffix = fileName.lastIndexOf(".");
		return fileName.substring(imgSuffix);
	}
	public String getImageType(String filePath) {
		String fileName = filePath;
		int imgPos = fileName.lastIndexOf(".");
		return fileName.substring(imgPos+1);
	}
	@Override
	public ImageFile sliceImage(CropImage cropImage) {
		ImageFile imgFile=new ImageFile();
		try {
			//开始创建压缩图片
			imgFile=this.createImageFile(cropImage);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return imgFile;
	}
	
	public ImageFile createImageFile(CropImage cropImage) throws Exception{
		
		//根据图片获取文件
		ImageFile imgFile = new ImageFile();
		String url = cropImage.getUrl();
		//拼接裁剪图片的名称750_500.jpg
		StringBuffer buffName = new StringBuffer();
		buffName.append("_");
		buffName.append(cropImage.getCropWidth());
		buffName.append("_");
		buffName.append(cropImage.getCropHeight());
		String fileName=this.getFileName(url, buffName.toString());
		String imgType=this.getImageType(url);//获取图片类型

		String dir = this.formatPath();
		String filePath ="";
		//如果url中包含front说明是前台页面上传的图片
		if(url.indexOf("front")!=-1){
			//filePath =dir+ url.substring(url.indexOf("/",12),url.lastIndexOf("/")+1)+fileName;
			System.out.println(url.indexOf("front"));
			filePath =dir+ url.substring(url.indexOf("front"),url.lastIndexOf("/")+1)+fileName;
		}else {

			SimpleDateFormat sdff = new SimpleDateFormat("yyyyMM");
			SysUser user = (SysUser) session.getAttribute("user");
			String imageDir = Constant.type_admin + "/" + user.getUserCounty().split(",")[0] + "/" + sdff.format(new Date()) + "/" + Constant.IMG;
			filePath = dir + imageDir + "/" + fileName;
		}
		String zoomFilePath = filePath.substring(0,filePath.indexOf("_")+1)+cropImage.getInitWidth()+"_"+cropImage.getInitHeight()+"."+imgType;
		this.createFile(filePath);
		System.out.println("filePath:" + filePath);
		System.out.println("cropWidth:"+cropImage.getCropWidth());
		System.out.println("cropHeight:"+cropImage.getCropHeight());


		System.out.println("==================读取文件流url:"+url);
		InputStream source=this.getUrlStream(url);
		BufferedImage sources = ImageIO.read(source);
		FileOutputStream fos = null;
		try {
			BufferedImage buf = new BufferedImage(Integer.parseInt(cropImage.getInitWidth()),Integer.parseInt(cropImage.getInitHeight()), BufferedImage.TYPE_INT_RGB);
			// 绘制缩小后的图片
			buf.getGraphics().drawImage(sources, 0, 0, Integer.parseInt(cropImage.getInitWidth()),Integer.parseInt(cropImage.getInitHeight()), null);
			fos = new FileOutputStream(zoomFilePath);
			JPEGEncodeParam jep =   JPEGCodec.getDefaultJPEGEncodeParam(buf);
			jep.setQuality(1f, true);
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(fos,jep);
			encoder.encode(buf);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fos != null) {
				fos.close();
				source.close();
			}
		}

		//对图片进行截取
		FileInputStream fis = new FileInputStream(zoomFilePath);
		Iterator readers = ImageIO.getImageReadersByFormatName(imgType);
		ImageReader reader = (ImageReader) readers.next();
		ImageInputStream iis = ImageIO.createImageInputStream(fis);
		reader.setInput(iis, true);
		ImageReadParam param = reader.getDefaultReadParam();
		int x=0,y=0,w=750,h=500;
		String x1=cropImage.getX();
		String y1=cropImage.getY();
		String w1=cropImage.getCropWidth();
		String h1=cropImage.getCropHeight();
		if(!StringUtils.isNaN(x1)){
			x=Integer.valueOf(x1);
		}
		if(!StringUtils.isNaN(y1)){
			y=Integer.valueOf(y1);
		}
		if(!StringUtils.isNaN(w1)){
			w=Integer.valueOf(w1);
		}
		if(!StringUtils.isNaN(h1)){
			h=Integer.valueOf(h1);
		}
		Rectangle rect = new Rectangle(x, y, w, h);
		param.setSourceRegion(rect);
		BufferedImage bi = reader.read(0, param);


		File file=new File(filePath);
		//将裁切的图片输出到本地磁盘保存
		ImageIO.write(bi, imgType, file);

		//以下代码是在裁切之后的图片基础上压缩图片300*300，用于前台展示
		//读取裁剪后的图片信息
		BufferedImage src = ImageIO.read(file);
		String suffxs =this.getImgSuffix(filePath);
		String fontImgPathName =filePath.substring(0,filePath.indexOf("_"))+"_300_300"+suffxs;

		//计算图片压缩比例
		float scale = (float)300/(float)w;
		//计算压缩图片的高度
		float scaleHeight =  scale*h;
		FileOutputStream out = null;
		try {
			BufferedImage tag = new BufferedImage(300,(int)scaleHeight, BufferedImage.TYPE_INT_RGB);
			// 绘制缩小后的图片
			tag.getGraphics().drawImage(src, 0, 0, 300,(int)scaleHeight, null);
			out = new FileOutputStream(fontImgPathName);
			JPEGEncodeParam jep =   JPEGCodec.getDefaultJPEGEncodeParam(tag);
			jep.setQuality(1f, true);
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out,jep);
			encoder.encode(tag);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				out.close();
			}
		}

		String fontImgPathName133_100 =filePath.substring(0,filePath.indexOf("_"))+"_133_100"+suffxs;
		//计算图片压缩比例
		float scale133_100 = (float)133/(float)w;
		//计算压缩图片的高度
		float scaleHeight133_100 =  scale133_100*h;
		FileOutputStream foStream = null;
		try {
			BufferedImage tag = new BufferedImage(133,(int)scaleHeight133_100, BufferedImage.TYPE_INT_RGB);
			// 绘制缩小后的图片
			tag.getGraphics().drawImage(src, 0, 0, 133,(int)scaleHeight133_100, null);
			foStream = new FileOutputStream(fontImgPathName133_100);
			JPEGEncodeParam jep =   JPEGCodec.getDefaultJPEGEncodeParam(tag);
			jep.setQuality(1f, true);
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(foStream,jep);
			encoder.encode(tag);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (foStream != null) {
				foStream.close();
			}
		}

		iis.close();
		fis.close();

		imgFile.setFileName(fileName);
		imgFile.setFilePath(filePath);
		imgFile.setFileSize(Long.valueOf(file.length()).intValue());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		sdf.applyPattern("yyyyMM");
		imgFile.setUrl(url.substring(0,url.lastIndexOf("/"))+"/"+fileName);
		imgFile.setWidth(w);
		imgFile.setHeight(h);
		return imgFile;
	}
	
	public String getFileName(String strUrl) {
		StringBuffer newFileName=new StringBuffer();
		if(strUrl!=null&&strUrl.length()>0){
			int filePos=strUrl.lastIndexOf("/");
			int dotPos=strUrl.lastIndexOf(".");
			String fileName=strUrl.substring(filePos+1,dotPos);
			String fileExt=strUrl.substring(dotPos);
			newFileName.append(fileName).append(fileExt);
		}
		return newFileName.toString();
	}
	
	public String getFileName(String strUrl,String preName) {
		StringBuffer newFileName=new StringBuffer();
		if(strUrl!=null&&strUrl.length()>0){
			int filePos=strUrl.lastIndexOf("/");
			int dotPos=strUrl.lastIndexOf(".");
			String fileName=strUrl.substring(filePos+1,dotPos);
			String fileExt=strUrl.substring(dotPos);
			newFileName.append(fileName).append(preName).append(fileExt);
		}
		return newFileName.toString();
	}
	
	private String formatPath() {
		return basePath.getBasePath();
	}

	private String getStaticUrl() {

		return basePath.getBaseUrl();

	}


}
