package lab1;

import org.apache.commons.collections4.MultiValuedMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Reducer {

    final MultiValuedMap<String, Integer> data;

    public Reducer(final MultiValuedMap<String, Integer> data) {
        this.data = data;
    }

    public List<Map<String, Integer>> reduce() {
        List<Map<String, Integer>> reduced = new ArrayList<>();
        for (final String s : this.data.keySet()) {
            Map<String, Integer> map = new HashMap<>();
            map.put(s, data.get(s).stream().reduce(0, Integer::sum));
            reduced.add(map);
        }
        return reduced;
    }

    public void reduceOut() {
        this.reduce().forEach(el -> el.entrySet().forEach(System.out::println));
    }
}
