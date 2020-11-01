package lab2;

import java.util.HashMap;
import java.util.Map;

public class Directory {
    private Map<String, Integer> links = new HashMap<>();
    private Map<Integer, File> fileMap = new HashMap<>();

    public Directory(Map<String, Integer> links, Map<Integer, File> fileMap) {
        this.links = links;
        this.fileMap = fileMap;
    }

    public Directory() {
    }

    public Map<String, Integer> ls() {
        return links;
    }

    public void addNewFile(int uuid, String name, int blockId) {
        this.links.put(name, blockId);
        this.fileMap.put(uuid, new File(uuid, blockId));
    }

    public void createNewFile(int id, String name, int blockId) {
        this.links.put(name, id);
        this.fileMap.put(id, new File(id, blockId));
    }

    public Map<String, Integer> getLinks() {
        return links;
    }

    public void setLinks(Map<String, Integer> links) {
        this.links = links;
    }

    public Map<Integer, File> getFileMap() {
        return fileMap;
    }

    public void setFileMap(Map<Integer, File> fileMap) {
        this.fileMap = fileMap;
    }
}
