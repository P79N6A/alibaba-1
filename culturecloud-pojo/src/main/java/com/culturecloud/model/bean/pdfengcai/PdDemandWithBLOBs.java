package com.culturecloud.model.bean.pdfengcai;

public class PdDemandWithBLOBs extends PdDemand {
    private String qualificationCertificateUrls;

    private String purchasingContent;

    public String getQualificationCertificateUrls() {
        return qualificationCertificateUrls;
    }

    public void setQualificationCertificateUrls(String qualificationCertificateUrls) {
        this.qualificationCertificateUrls = qualificationCertificateUrls == null ? null : qualificationCertificateUrls.trim();
    }

    public String getPurchasingContent() {
        return purchasingContent;
    }

    public void setPurchasingContent(String purchasingContent) {
        this.purchasingContent = purchasingContent == null ? null : purchasingContent.trim();
    }
}