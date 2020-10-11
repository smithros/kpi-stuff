package lab1;

public class VirtualPage {

    private int pageVirtualId;
    private int pagePhysicalId;
    private int bitP;
    private int bitR;
    private int bitM;

    public VirtualPage(int pageVirtualId, int pagePhysicalId, int bitP, int bitR, int bitM) {
        this.pageVirtualId = pageVirtualId;
        this.pagePhysicalId = pagePhysicalId;
        this.bitP = bitP;
        this.bitR = bitR;
        this.bitM = bitM;
    }

    public int getPageVirtualId() {
        return pageVirtualId;
    }

    public void setPageVirtualId(int pageVirtualId) {
        this.pageVirtualId = pageVirtualId;
    }

    public int getPagePhysicalId() {
        return pagePhysicalId;
    }

    public void setPagePhysicalId(int pagePhysicalId) {
        this.pagePhysicalId = pagePhysicalId;
    }

    public int getBitP() {
        return bitP;
    }

    public void setBitP(int bitP) {
        this.bitP = bitP;
    }

    public int getBitR() {
        return bitR;
    }

    public void setBitR(int bitR) {
        this.bitR = bitR;
    }

    public int getBitM() {
        return bitM;
    }

    public void setBitM(int bitM) {
        this.bitM = bitM;
    }

    @Override
    public String toString() {
        return "VirtualPage = {" +
                "pageVirtualId=" + pageVirtualId +
                ", pagePhysicalId=" + pagePhysicalId +
                ", bitP=" + bitP +
                ", bitR=" + bitR +
                ", bitM=" + bitM +
                "}\n";
    }
}
