package lab2;

public class Block {
    private int state;
    private int size;
    private String info;

    public Block(String info) {
        this.info = info;
        this.state = compareBlockInfo(info);
        this.size = 4;
    }

    public Block() {
    }

    public int compareBlockInfo(String value) {
        return value != null ? 1 : 0;
    }

    public void setInfo(String info) {
        this.info = info;
        this.state = compareBlockInfo(info);
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public String getInfo() {
        return info;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    @Override
    public String toString() {
        return "Block{" +
                "state=" + state +
                ", info='" + info + '\'' +
                ", size='" + size + '\'' +
                '}';
    }
}

