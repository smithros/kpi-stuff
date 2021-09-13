package lab1;

import org.apache.commons.collections4.MultiValuedMap;

public class Example {
    public static void main(String[] args) {
        final String file1 = "src/main/resources/file1.txt";
        final String file2 = "src/main/resources/file2.txt";

        Shuffler shuffler = new Shuffler();
        final MultiValuedMap<String, Integer> data = shuffler.readFile(file1);
        data.putAll(shuffler.readFile(file2));

        System.out.println("\nShuffled data: \n");
        shuffler.mapOutput(data);
        System.out.println("\nReduced data: \n");
        new Reducer(data).reduceOut();
    }
}
