package lab1;

import org.apache.commons.collections4.MultiValuedMap;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

public class ReducerTest {

    private MultiValuedMap<String, Integer> data;
    private Shuffler shuffler;
    private Reducer reducer;
    private String file1;
    private String file2;

    @Before
    public void setUp() {
        this.file1 = "src/main/resources/file1.txt";
        this.file2 = "src/main/resources/file2.txt";
        this.shuffler = new Shuffler();
        this.data = this.shuffler.readFile(this.file1);
        this.data.putAll(this.shuffler.readFile(this.file2));
        this.reducer = new Reducer(this.data);
    }

    @Test
    public void reduceTest() {
        Assert.assertEquals(5, this.reducer.reduce().size());
    }
}
