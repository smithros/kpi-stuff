package lab1;

import org.apache.commons.collections4.MultiValuedMap;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

public class ShufflerTest {

    private MultiValuedMap<String, Integer> data;
    private Shuffler shuffler;
    private String file1;
    private String file2;

    @Before
    public void setUp() {
        this.file1 = "src/main/resources/file1.txt";
        this.file2 = "src/main/resources/file2.txt";
        this.shuffler = new Shuffler();
        this.data = shuffler.readFile(file1);
        this.data.putAll(shuffler.readFile(file2));
    }

    @Test
    public void readFileTest() {
        final MultiValuedMap<String, Integer> f1 = this.shuffler.readFile(this.file1);
        final MultiValuedMap<String, Integer> f2 = this.shuffler.readFile(this.file2);

        Assert.assertEquals(5, f1.size());
        Assert.assertEquals(5, f2.size());
    }

    @Test
    public void shuffleTest() {
        this.shuffler.mapOutput(this.data);
        Assert.assertNotEquals(5, this.data.entries().size());
    }
}