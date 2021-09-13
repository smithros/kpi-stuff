package lab1;

import org.apache.commons.collections4.MultiValuedMap;
import org.apache.commons.collections4.multimap.ArrayListValuedHashMap;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Objects;

public class Shuffler {

    public void mapOutput(final MultiValuedMap<String, Integer> data) {
        data.entries().forEach(System.out::println);
    }

    public MultiValuedMap<String, Integer> readFile(final String path) {
        final Path fPath = Paths.get(path);
        String s = null;
        try {
            s = Files.readString(fPath);
        } catch (IOException e) {
            e.printStackTrace();
        }
        final String[] split = Objects.requireNonNull(s).split("\\R");
        final MultiValuedMap<String, Integer> map = new ArrayListValuedHashMap<>();
        for (final String el : split) {
            final String[] split1 = el.split(",");
            map.put(split1[0], Integer.valueOf(split1[1]));
        }
        System.out.printf("%s file mapped values: \n", path);
        mapOutput(map);
        return map;
    }
}
