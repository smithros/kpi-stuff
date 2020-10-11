package lab1;

import java.util.ArrayList;
import java.util.List;

public class Process {

    private int processId;
    private int pagesAmount;
    private boolean state;
    private List<VirtualPage> virtualPages = new ArrayList<>(pagesAmount); // table of pages

    public Process(int processId, int pagesAmount, boolean state) {
        this.processId = processId;
        this.pagesAmount = pagesAmount;
        this.state = state;

        for (int i = 0; i < pagesAmount; i++) {
            virtualPages.add(new VirtualPage(i,0,0,0,0));
        }
    }

    public int getProcessId() {
        return processId;
    }

    public void setProcessId(int processId) {
        this.processId = processId;
    }

    public int getPagesAmount() {
        return pagesAmount;
    }

    public void setPagesAmount(int pagesAmount) {
        this.pagesAmount = pagesAmount;
    }

    public boolean getState() {
        return state;
    }

    public void setState(boolean state) {
        this.state = state;
    }

    public List<VirtualPage> getVirtualPages() {
        return virtualPages;
    }

    public void setVirtualPages(List<VirtualPage> virtualPages) {
        this.virtualPages = virtualPages;
    }

    @Override
    public String toString() {
        return "Process = {" +
                "processId=" + processId +
                ", pagesAmount=" + pagesAmount +
                ", state=" + state +
                ", \nvirtualPages=" + virtualPages +
                "}\n";
    }
}
