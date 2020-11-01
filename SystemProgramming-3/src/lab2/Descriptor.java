package lab2;

import java.util.List;

public class Descriptor {
    private int uuid;
    private int length;
    private String name;
    private List<Integer> blocksList;
    private int counter = 0;

    public Descriptor(int uuid, int length, String name, List<Integer> blocksList) {
        this.uuid = uuid;
        this.length = length;
        this.name = name;
        this.blocksList = blocksList;
        this.counter = 1;
    }

    public void inc(){
        this.counter += 1;
    }

    public void dec(){
        this.counter -= 1;
    }

    public Descriptor() {
    }

    public int getUuid() {
        return uuid;
    }

    public void setUuid(int uuid) {
        this.uuid = uuid;
    }

    public int getLength() {
        return length;
    }

    public void setLength(int length) {
        this.length = length;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Integer> getBlocksList() {
        return blocksList;
    }

    public void setBlocksList(List<Integer> blocksList) {
        this.blocksList = blocksList;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    @Override
    public String toString() {
        return "Descriptor{" +
                "uuid=" + uuid +
                ", length=" + length +
                ", name='" + name + '\'' +
                ", blocksList=" + blocksList +
                ", counter=" + counter +
                '}';
    }
}
