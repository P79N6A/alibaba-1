package com.culturecloud.model.bean.pdfengcai;

public class PdOfferWithBLOBs extends PdOffer {
    private String legalManQualificationCertificateUrls;

    private String exhibitionContent;

    public String getLegalManQualificationCertificateUrls() {
        return legalManQualificationCertificateUrls;
    }

    public void setLegalManQualificationCertificateUrls(String legalManQualificationCertificateUrls) {
        this.legalManQualificationCertificateUrls = legalManQualificationCertificateUrls == null ? null : legalManQualificationCertificateUrls.trim();
    }

    public String getExhibitionContent() {
        return exhibitionContent;
    }

    public void setExhibitionContent(String exhibitionContent) {
        this.exhibitionContent = exhibitionContent == null ? null : exhibitionContent.trim();
    }
}