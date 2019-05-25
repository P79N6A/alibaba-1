package com.culturecloud.test.platform.training;


import com.culturecloud.model.request.training.CcpTrainingVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;
import org.junit.Test;

public class TestTraining extends TestRestService {
    @Test
    public void tralist() {

        CcpTrainingVO vo = new CcpTrainingVO();


        System.out.println(HttpRequest.sendPost(BASE_URL + "/training/list", vo));

    }

    @Test
    public void traAdd() {

        CcpTrainingVO vo = new CcpTrainingVO();
        vo.setCreateUser("1");
        vo.setSpeakerId("1");
        vo.setSpeakerName("1");
        vo.setSpeakerIntroduce("132");
        vo.setTrainingIntroduce("wer");
        vo.setTrainingStatus(1);
        System.out.println(HttpRequest.sendPost(BASE_URL + "/training/change", vo));

    }
}
