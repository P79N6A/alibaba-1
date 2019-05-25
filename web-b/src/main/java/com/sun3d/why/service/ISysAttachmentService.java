package com.sun3d.why.service;

import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import com.sun3d.why.model.extmodel.AttFile;
import com.sun3d.why.model.extmodel.CropImage;
import com.sun3d.why.model.extmodel.ImageFile;
import com.sun3d.why.model.extmodel.ImageSize;


public interface ISysAttachmentService {
	public String upload(HttpServletRequest request) throws Exception;
	public AttFile addFile(MultipartFile multiFile) throws Exception;
	public AttFile addFile(String url) throws Exception;
	public ImageFile addImage(MultipartFile multiFile) throws Exception;
	public void addComprassImage(String filePath) throws Exception;
	public ImageFile sliceImage(CropImage croppicImage);

}
