package lab2;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

class File {
    private int SIZE_VALUE = 16;
    private int blockId;
    private int uuid;
    private Map<Integer, Block> blocksMap = new HashMap<>();
    private List<Integer> blocksCard = new ArrayList<>();
    private Descriptor descriptor;

    public File(int uuid, int blockId) {
        this.uuid = uuid;
        for (int i = 0; i < SIZE_VALUE; i++) {
            this.blocksMap.put(blockId, new Block(null));
            this.blocksCard.add(blockId);
            blockId += 1;
        }
        this.descriptor = new Descriptor(uuid, SIZE_VALUE, "File", blocksCard);
    }

    public String read(int tap, int inputSize) {
        int len = this.blocksMap.get(this.blocksCard.get(0)).getSize();
        int startTap = tap % len;
        int blockNum = tap / len;
        int toRead = (inputSize - (len - startTap))
                / len;
        int endTap = (inputSize - (len - startTap))
                % len;

        if (blockNum + toRead + 2 > SIZE_VALUE) {
            return "The size is too big to read";
        } else {
            String res = "";
            for (int i = blockNum; i < blockNum + toRead + 2; i++) {
                if (this.blocksMap.get(this.blocksCard.get(i)).getInfo() == null) {
                    res += "    ";
                } else {
                    if (i != blockNum + toRead + 1 && i != blockNum) {
                        res += this.blocksMap.get(this.blocksCard.get(i)).getInfo();
                    } else if (i == blockNum + toRead + 1) {
                        res += this.blocksMap.get(this.blocksCard.get(i)).getInfo().substring(0, endTap + 1);
                    } else if (i == blockNum) {
                        res += this.blocksMap.get(this.blocksCard.get(i)).getInfo().substring(startTap);
                    }
                }
            }
            return res;
        }
    }

    public String write(int tap, int inputSize, String info) {
        if (inputSize != info.length()) {
            return "Input string length is not equal to to the size";
        }
        int len = this.blocksMap.get(this.blocksCard.get(0)).getSize();
        int startTap = tap % len;
        int blockNum = tap / len;
        int toRead = (inputSize - (len - startTap))
                / len;
        int endTap = (inputSize - (len - startTap))
                % len;

        if (blockNum + toRead + 2 > SIZE_VALUE) {
            return "The size is too big to write";
        } else {
            if (toRead == 0) {
                String part1 = info.substring(0, len - startTap);
                String part2 = info.substring(len - startTap);

                for (int i = blockNum; i < blockNum + 2; i++) {
                    if (i == blockNum + 1) {
                        String res = " ".repeat(len - endTap);
                        this.blocksMap.get(this.blocksCard.get(i)).setInfo(part2 + res);
                    } else if (i == blockNum) {
                        String res = " ".repeat(startTap);
                        this.blocksMap.get(this.blocksCard.get(i)).setInfo(res + part1);
                    }
                }
            } else if (endTap == 0) {
                String part1 = info.substring(0, len - startTap);
                String part2 = info.substring(len - startTap);

                for (int i = blockNum; i < blockNum + toRead + 1; i++) {
                    if (i != blockNum) {
                        this.blocksMap.get(this.blocksCard.get(i)).setInfo(part2.substring(0, len));
                        part2 = part2.substring(len);
                    } else if (i == blockNum) {
                        String res = " ".repeat(startTap);
                        this.blocksMap.get(this.blocksCard.get(i)).setInfo(res + part1);
                    }
                }
            } else if (toRead == 0 && endTap == 0) {
                String res = " ".repeat(startTap);
                this.blocksMap.get(this.blocksCard.get(blockNum)).setInfo(res + info);
            } else {
                String part1 = info.substring(0, len - startTap);
                String part2 = info.substring((len - startTap), toRead * len);
                String part3 = info.substring(toRead * len);
                for (int i = blockNum; i < blockNum + toRead + 2; i++) {
                    if (i != blockNum + toRead + 1 && i != blockNum) {
                        this.blocksMap.get(this.blocksCard.get(i)).setInfo(part2.substring(0, len));
                        part2 = part2.substring(len);
                    } else if (i == blockNum + toRead + 1) {
                        String res = " ".repeat(len - endTap);
                        this.blocksMap.get(this.blocksCard.get(i)).setInfo(part3 + res);
                    } else if (i == blockNum) {
                        String res = " ".repeat(startTap);
                        this.blocksMap.get(this.blocksCard.get(i)).setInfo(res + part1);
                    }
                }
            }
            return "Info was written to file";
        }
    }

    public synchronized String changeSize(int inputSize, int blockId, int maxBlocks, int currBlocksAmount) {
        if (inputSize < SIZE_VALUE) {
            Map<Integer, Block> blocksMapTwo = new ConcurrentHashMap<Integer, Block>(blocksMap);
            int sizeDiff = SIZE_VALUE - inputSize;
            currBlocksAmount -= sizeDiff;
            this.SIZE_VALUE = inputSize;
            for (Map.Entry<Integer, Block> entry : blocksMapTwo.entrySet()) {
                if (entry.getValue().getInfo() == null) {
                    blocksMapTwo.remove(entry.getKey());
                    this.blocksMap.remove(entry.getKey());
                    sizeDiff -= 1;
                    if (sizeDiff == 0) {
                        break;
                    }
                }
            }
            if (sizeDiff != 0) {
                for (Integer integer : blocksMapTwo.keySet()) {
                    blocksMapTwo.remove(integer);
                    this.blocksMap.remove(integer);
                    sizeDiff -= 1;
                    if (sizeDiff == 0) {
                        break;
                    }
                }
            }
            this.descriptor.setLength(inputSize);
            this.descriptor.setBlocksList(this.blocksCard);
            return "File size was reduced " + 0;
        } else if (inputSize > SIZE_VALUE) {
            int sizeDiff = inputSize - SIZE_VALUE;

            if (currBlocksAmount + sizeDiff < maxBlocks) {
                this.SIZE_VALUE = inputSize;
                for (int i = 0; i < sizeDiff; i++) {
                    this.blocksMap.put(i, new Block(null));
                    this.blocksCard.add(blockId);
                    blockId += 1;
                }
                this.descriptor.setLength(inputSize);
                this.descriptor.setBlocksList(this.blocksCard);
                return "File size was increased " + sizeDiff;
            } else {
                return "Not enough blocks for file";
            }
        } else {
            return "Size wasn't changed, size is the same as in current file";
        }
    }

    public int getSizeValue() {
        return this.SIZE_VALUE;
    }

    public int getUuid() {
        return uuid;
    }

    public void setUuid(int uuid) {
        this.uuid = uuid;
    }

    public Map<Integer, Block> getBlocksMap() {
        return blocksMap;
    }

    public void setBlocksMap(Map<Integer, Block> blocksMap) {
        this.blocksMap = blocksMap;
    }

    public List<Integer> getBlocksCard() {
        return blocksCard;
    }

    public void setBlocksCard(List<Integer> blocksCard) {
        this.blocksCard = blocksCard;
    }

    public Descriptor getDescriptor() {
        return descriptor;
    }

    public void setDescriptor(Descriptor descriptor) {
        this.descriptor = descriptor;
    }
}
