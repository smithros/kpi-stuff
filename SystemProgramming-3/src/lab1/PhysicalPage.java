package lab1;

import java.util.concurrent.atomic.AtomicInteger;

public class PhysicalPage {

    private int pagePhysicalId;
    private String counter;
    private int pageVirtualId;
    private int processId;

    private static final AtomicInteger idGenerator = new AtomicInteger(0);

    public PhysicalPage(int pageVirtualId, int processId, String counter) {
        pagePhysicalId = idGenerator.getAndIncrement();
        this.pageVirtualId = pageVirtualId;
        this.processId = processId;
        this.counter = counter;
    }

    public String getCounter() {
        return counter;
    }

    public void setCounter(String counter) {
        this.counter = counter;
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

    public int getProcessId() {
        return processId;
    }

    public void setProcessId(int processId) {
        this.processId = processId;
    }

    @Override
    public String toString() {
        return "PhysicalPage {" +
                "counter=" + counter +
                ", pageVirtualId=" + pageVirtualId +
                ", pagePhysicalId=" + pagePhysicalId +
                ", processId=" + processId +
                "}\n";
    }
}
