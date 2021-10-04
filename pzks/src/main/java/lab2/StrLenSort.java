package lab2;

import java.util.Comparator;

public class StrLenSort implements Comparator<String> {
    @Override
    public int compare(final String s1, final String s2) {
        return s1.length() - s2.length();
    }
}