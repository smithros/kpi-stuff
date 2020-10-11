package lab1;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

public class AgingAlgorithm {

    public static void main(String[] args) {
        HashMap<Integer, List<VirtualPage>> map = new HashMap<>();
        List<Process> processList = new ArrayList<>(5);

        // init processes
        for (int i = 0; i < 10; i++) {
            processList.add(new Process(i, 10, true));
        }

        List<PhysicalPage> memory = new ArrayList<>(20); // page table

        // init physical pages
        for (int i = 0; i < 20; i++) {
            memory.add(new PhysicalPage(0, 0, "00000000"));
        }

        int iteration = 0;
        while (iteration < 20) {
            PhysicalPage physicalPage = memory.get(iteration);
            Process process = processList.get(randInt(0, 4));
            VirtualPage virtualPage = process.getVirtualPages().get(randInt(0, 9));

            if (virtualPage.getBitP() == 0) {
                physicalPage.setPageVirtualId(virtualPage.getPageVirtualId());
                physicalPage.setProcessId(process.getProcessId());
                virtualPage.setPagePhysicalId(physicalPage.getPagePhysicalId());
                virtualPage.setBitP(1);
                iteration++;
            }

        }
        //System.out.println(memory);

        for (int i = 0; i < 20; i++) {
            PhysicalPage physicalPage = memory.get(i);
            physicalPage.setCounter(randBinaryNumber(8));
            Process process = processList.get(physicalPage.getProcessId());
            VirtualPage virtualPage = process.getVirtualPages().get(physicalPage.getPageVirtualId());
            virtualPage.setBitR(randInt(0, 1));
        }

        for (Process process : processList) {
            map.put(process.getProcessId(), process.getVirtualPages());
        }

        for (int i = 0; i < 5; i++) {
            Process process = processList.get(randInt(0, processList.size() - 1));
            VirtualPage vp = process.getVirtualPages().get(randInt(0, 9));

            int randNum = randInt(0, 10);
            int randNum2 = randInt(0, 10);
            if (process.getState()) {
                if (vp.getBitP() == 0) {
                    // calling aging algorithm
                    aging(vp, process.getProcessId(), map, memory, processList);
                } else {
                    if (randNum <= 5) {
                        vp.setBitR(1);
                        PhysicalPage page = memory.get(vp.getPagePhysicalId());
                        int int10 = Integer.parseInt(page.getCounter(), 2) + 1;
                        String bin = Integer.toBinaryString(int10);

                        if (bin.length() < 8) {
                            page.setCounter("0".repeat(8 - bin.length()) + bin);
                        }
                    } else if (randNum2 <= 2) {
                        process.setState(false);
                    } else if (randNum >= 8) {
                        Process newProc = new Process(processList.size() + 1, 10, true);
                        processList.add(newProc);
                    }
                }
                System.out.println("Pages in Memory:\n" + memory);
            }
        }
        //  System.out.println("Processes List:\n" + processList);
    }

    public static int randInt(int min, int max) {
        Random rand = new Random();
        return rand.nextInt((max - min) + 1) + min;
    }

    public static String randBinaryNumber(int length) {
        StringBuilder str = new StringBuilder();
        for (int i = 0; i < length; i++) {
            str.append(randInt(0, 1));
        }
        return str.toString();
    }

    public static void aging(VirtualPage virtualPage,
                             int processId,
                             HashMap<Integer, List<VirtualPage>> map,
                             List<PhysicalPage> memory,
                             List<Process> processList) {

        int suitablePP = 0;
        String minCounter = "11111111";
        Integer suitableProcPP = null;

        for (PhysicalPage page : memory) {
            List<VirtualPage> vpList = map.get(page.getProcessId());
            VirtualPage vp = vpList.get(page.getPageVirtualId());

            if (vp.getBitR() == 1) {
                page.setCounter("1" + page.getCounter().substring(0, page.getCounter().length() - 1));
                vp.setBitR(0);
            } else {
                page.setCounter("0" + page.getCounter().substring(0, page.getCounter().length() - 1));
            }
            if (!processList.get(page.getProcessId()).getState()) {
                suitableProcPP = page.getPagePhysicalId();
            }
            if (Integer.parseInt(page.getCounter(), 2) <= Integer.parseInt(minCounter, 2)) {
                minCounter = page.getCounter();
                suitablePP = page.getPagePhysicalId();
            }
        }
        if (suitableProcPP != null) {
            suitablePP = suitableProcPP;
        }
        PhysicalPage tempPP = memory.get(suitablePP);

        List<VirtualPage> tempVpList = map.get(tempPP.getProcessId());
        VirtualPage tempVp = tempVpList.get(tempPP.getPageVirtualId());

        tempVp.setPagePhysicalId(0);
        tempVp.setBitP(0);

        tempPP.setPageVirtualId(virtualPage.getPageVirtualId());
        tempPP.setProcessId(processId);
        tempPP.setCounter("00000000");

        virtualPage.setPagePhysicalId(tempPP.getPagePhysicalId());
        virtualPage.setBitP(1);
    }
}
