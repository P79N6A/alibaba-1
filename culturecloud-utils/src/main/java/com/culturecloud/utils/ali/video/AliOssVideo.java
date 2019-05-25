package com.culturecloud.utils.ali.video;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.aliyun.oss.OSSClient;
import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.exceptions.ServerException;
import com.aliyuncs.mts.model.v20140618.QueryAnalysisJobListRequest;
import com.aliyuncs.mts.model.v20140618.QueryAnalysisJobListResponse;
import com.aliyuncs.mts.model.v20140618.QueryAnalysisJobListResponse.AnalysisJob;
import com.aliyuncs.mts.model.v20140618.QueryAnalysisJobListResponse.AnalysisJob.Template;
import com.aliyuncs.mts.model.v20140618.QueryJobListRequest;
import com.aliyuncs.mts.model.v20140618.QueryJobListResponse;
import com.aliyuncs.mts.model.v20140618.QueryJobListResponse.Job;
import com.aliyuncs.mts.model.v20140618.SubmitAnalysisJobRequest;
import com.aliyuncs.mts.model.v20140618.SubmitAnalysisJobResponse;
import com.aliyuncs.mts.model.v20140618.SubmitJobsRequest;
import com.aliyuncs.mts.model.v20140618.SubmitJobsResponse;
import com.aliyuncs.profile.DefaultProfile;
import com.culturecloud.utils.ali.OSSFileDO;

public class AliOssVideo {
    
	//mts-service-pipeline
	private static final String MTS_REGION = "cn-hangzhou";
    private static final String OSS_REGION = "oss-cn-hangzhou";

    private static final String mtsEndpoint = "mts.cn-hangzhou.aliyuncs.com";
    private static final String ossEndPoint = "http://oss-cn-hangzhou.aliyuncs.com";

    private static String accessKeyId = "g71YwJtSB2zq8EgJ";
    private static String accessKeySecret = "9PJFP214P7vt5SjFWnxBNwPxkoqYJr";
    private static String pipelineId = "158c89561be647bd9ba8122e95a2eda7";

    private static String transcodeTemplateId = "6726e2900d0e92dcdbb414f2b05489ff";

    private static String inputBucket = "culturecloud";
    private static String outputBucket = "culturecloud";
    
    private static DefaultAcsClient aliyunClient;
	
    
    public static void main(String[] args) throws ClientException {
    	transvideo("qyg","20161220143568xfA6VZc72ZGbicBreRjzc2Ra2c8FH.avi","20161220143568xfA6VZc72ZGbicBreRjzc2Ra2c8FH.mp4");
    }
    
    public static void transvideo(String path,String videoName,String outvideoName) throws ClientException
    {
    	DefaultProfile.addEndpoint(MTS_REGION, MTS_REGION, "Mts", mtsEndpoint);
        aliyunClient = new DefaultAcsClient(DefaultProfile.getProfile(MTS_REGION, accessKeyId, accessKeySecret));
        
        OSSFileDO inputFile = uploadVideoFile(path,videoName);
        
        transcodeJobFlow(inputFile,inputFile,path,outvideoName);
    }
    
    public static String getVideoNewName(String videoVideoUrl){
    	
    	int index=videoVideoUrl.lastIndexOf("/");
		
		final String videoName=videoVideoUrl.substring(index+1, videoVideoUrl.length());
		
		int index3=videoName.lastIndexOf(".");
		
		final String videoNewName=videoName.substring(0,index3);
		
		return videoNewName+".mp4";
    }
    
    
    
    private static void transcodeJobFlow(OSSFileDO inputFile, OSSFileDO watermarkFile,String path,String outvideoName) {
       // systemTemplateJobFlow(inputFile, watermarkFile,path,outvideoName); 
        userCustomTemplateJobFlow(inputFile, watermarkFile,path,outvideoName);
    }
    
    // videoName带后缀
    private static OSSFileDO uploadVideoFile(String path,String videoName) {
    	 return uploadLocalFile(inputBucket, path+"/" + videoName, null);
    }

    
    public static OSSFileDO uploadLocalFile(String bucket, String object, String filePath){
        try {

            String encodedObjectName = URLEncoder.encode(object, "utf-8");
            return new OSSFileDO(OSS_REGION, bucket, encodedObjectName);
        } 

        catch (UnsupportedEncodingException e) {
            throw new RuntimeException("fail@uploadLocalFile URLEncoder");
        }
    }
    
    
    
    private static void systemTemplateJobFlow(OSSFileDO inputFile, OSSFileDO watermarkFile,String path,String outvideoName) {
        String analysisJobId = submitAnalysisJob(inputFile, pipelineId);

        AnalysisJob analysisJob = waitAnalysisJobComplete(analysisJobId);

        List<String> templateIds = getSupportTemplateIds(analysisJob);

        // 可能会有多个系统模板，这里采用推荐的第一个系统模板进行转码
        String transcodeJobId = submitTranscodeJob(inputFile, watermarkFile, templateIds.get(2),path,outvideoName);

        Job transcodeJob = waitTranscodeJobComplete(transcodeJobId);

        String outputBucket  = transcodeJob.getOutput().getOutputFile().getBucket();
        String outputObject  = transcodeJob.getOutput().getOutputFile().getObject();
        String outputFileOSSUrl = getOSSUrl(outputBucket, outputObject);
        System.out.println("Transcode success, the target file url is " + outputFileOSSUrl);
    }
    
    
    private static void userCustomTemplateJobFlow(OSSFileDO inputFile, OSSFileDO watermarkFile,String path,String outvideoName) {
        String transcodeJobId = submitTranscodeJob(inputFile, watermarkFile, transcodeTemplateId,path,outvideoName);

        Job transcodeJob = waitTranscodeJobComplete(transcodeJobId);

        String outputBucket  = transcodeJob.getOutput().getOutputFile().getBucket();
        String outputObject  = transcodeJob.getOutput().getOutputFile().getObject();
        String outputFileOSSUrl = getOSSUrl(outputBucket, outputObject);
        System.out.println("Transcode success, the target file url is " + outputFileOSSUrl);
    }
    
    
    
    private static List<String> getSupportTemplateIds(AnalysisJob analysisJob) {
        List<String> templateIds = new ArrayList<String>(analysisJob.getTemplateList().size());
        for (Template template : analysisJob.getTemplateList()) {
            templateIds.add(template.getId());
        }
        return templateIds;
    }
    
    private static String submitAnalysisJob(OSSFileDO inputFile, String pipelineId) {
        SubmitAnalysisJobRequest request = new SubmitAnalysisJobRequest();

        request.setInput(inputFile.toJsonString());
        request.setPipelineId(pipelineId);
        SubmitAnalysisJobResponse response = null;
        try {
            response = aliyunClient.getAcsResponse(request);
        } catch (ServerException e) {
            throw new RuntimeException("SubmitAnalysisJobRequest Server failed");
        } catch (ClientException e) {
            throw new RuntimeException("SubmitAnalysisJobRequest Client failed");
        }
        return response.getAnalysisJob().getId();
    }
    
    
    private static AnalysisJob waitAnalysisJobComplete(String analysisJobId) {
        QueryAnalysisJobListRequest request = new QueryAnalysisJobListRequest();
        request.setAnalysisJobIds(analysisJobId);
        QueryAnalysisJobListResponse response = null;
        try{
            while (true) {
                response = aliyunClient.getAcsResponse(request);

                AnalysisJob analysisJob = response.getAnalysisJobList().get(0);
                String status = analysisJob.getState();
                if ("Fail".equals(status)) {
                    throw new RuntimeException("analysisJob state Failed");
                }
                if ("Success".equals(status)) {
                    return analysisJob;
                }

                Thread.sleep(5 * 1000);
            }
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } catch (ServerException e) {
            throw new RuntimeException("waitAnalysisJobComplete Server failed");
        } catch (ClientException e) {
            throw new RuntimeException("waitAnalysisJobComplete Client failed");
        }
    }
    
    private static String submitTranscodeJob(OSSFileDO inputFile,OSSFileDO watermarkFile,String templateId,String path,String outvideoName) {

        String outputOSSObjectKey;
        try {

        	outputOSSObjectKey = URLEncoder.encode(path+"/"+ outvideoName,
                 "utf-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("submitTranscodeJob URL encode failed");
        }
        JSONObject jobConfig = new JSONObject();
        jobConfig.put("OutputObject", outputOSSObjectKey);
        jobConfig.put("TemplateId", templateId);

        JSONArray jobConfigArray = new JSONArray();
        jobConfigArray.add(jobConfig);

        SubmitJobsRequest request = new SubmitJobsRequest();
        request.setInput(inputFile.toJsonString());
        request.setOutputBucket(outputBucket);
        request.setOutputs(jobConfigArray.toJSONString());
        request.setPipelineId(pipelineId);
        request.setOutputLocation(OSS_REGION);

        Integer outputJobCount = 1;

        SubmitJobsResponse response = null;
        try {
            response = aliyunClient.getAcsResponse(request);
            if(response.getJobResultList().size() != outputJobCount) {
                throw new RuntimeException("SubmitJobsRequest Size failed");
            }

            return response.getJobResultList().get(0).getJob().getJobId();
        } catch (ServerException e) {
            throw new RuntimeException("submitTranscodeJob Server failed");
        } catch (ClientException e) {
            throw new RuntimeException("submitTranscodeJob Client failed");
        }
    }
    
    


    
    private static Job waitTranscodeJobComplete(String transcodeJobId) {
        QueryJobListRequest request = new QueryJobListRequest();
        request.setJobIds(transcodeJobId);

        QueryJobListResponse response = null;
        try {
            while (true) {
                response = aliyunClient.getAcsResponse(request);

                Job transcodeJob = response.getJobList().get(0);
                String status = transcodeJob.getState();

                if ("TranscodeFail".equals(status)) {
                    throw new RuntimeException("transcodeJob state Failed");
                }

                if ("TranscodeSuccess".equals(status)) {
                    return transcodeJob;
                }

                Thread.sleep(5 * 1000);
            }
        } catch (ServerException e) {
            throw new RuntimeException("waitTranscodeJobComplete Server failed");
        } catch (ClientException e) {
            throw new RuntimeException("waitTranscodeJobComplete Client failed");
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
    
    private static String getOSSUrl(String bucket, String object) {
        try {
            return "http://" + bucket + "." + OSS_REGION + ".aliyuncs.com/" + URLDecoder.decode(object, "utf-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("getOSSUrl URL decode failed");
        }
    }
    
}
