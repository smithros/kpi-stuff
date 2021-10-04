package lab2;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ParallelTree {

    public void constructTree(final List<String> tokens, final List<String> types) {
        int ind = 0;
        int priority = 0;
        final List<String> priors = this.getPriors(tokens, types, ind, priority);
        final List<String> indexes = this.getIndexes(ind, priors);
        final List<Integer> nums = this.getPriorityOpNums(priors, indexes);
        Collections.reverse(indexes);
        Collections.reverse(nums);
        this.handleBraces(tokens, types, priors);
        final List<String> result = new ArrayList<>();
        prepareData(tokens, types, priors, indexes, nums, result);
        getResultTree(result);
    }

    private void prepareData(final List<String> tokens,
                             final List<String> types,
                             final List<String> priors,
                             final List<String> indexes,
                             final List<Integer> nums,
                             final List<String> result
    ) {
        int ind;
        int mn = 0;
        while (mn < indexes.size()) {
            int mult = nums.get(mn);
            while (mult != 0) {
                ind = 0;
                while (ind < tokens.size()) {
                    if (priors.get(ind).equals(indexes.get(mn))) {
                        tokens.set(ind - 1, "(" + tokens.get(ind - 1) + tokens.get(ind) + tokens.get(ind + 1) + ")");
                        types.set(ind - 1, "Res");
                        result.add(tokens.get(ind - 1));
                        priors.set(ind, "0");
                        priors.remove(ind + 1);
                        priors.remove(ind - 1);
                        tokens.remove(ind + 1);
                        tokens.remove(ind);
                        types.remove(ind + 1);
                        types.remove(ind);
                        mult--;
                    }
                    ind++;
                }
            }
            mn++;
        }
        result.sort(new StrLenSort());
        result.add(" ");
    }

    private void getResultTree(final List<String> result) {
        int ind = 0;
        StringBuilder buf = new StringBuilder();
        List<String> tree = new ArrayList<>();
        while (ind < result.size()) {
            if (result.get(ind).equals(" ")) {
                break;
            }
            if (Math.abs(result.get(ind).length() - result.get(ind + 1).length()) > 3) {
                buf.append("----").append(result.get(ind));
                tree.add(buf.toString());
                buf = new StringBuilder();
            } else {
                buf.append("----").append(result.get(ind));
            }
            ind++;
        }
        System.out.println("Automatic generated parallel tree:");
        tree.forEach(System.out::println);
    }

    private void handleBraces(final List<String> tokens, final List<String> types,
                              final List<String> priors) {
        int ind = 0;
        int tknInd = 0;
        for (final String token : tokens) {
            if (token.equals("(") || token.equals(")")) {
                tknInd++;
            }
        }
        while (tknInd != 0) {
            while (ind < tokens.size()) {
                if (types.get(ind).equals("(")) {
                    tokens.remove(ind);
                    priors.remove(ind);
                    types.remove(ind);
                    tknInd--;
                }
                if (types.get(ind).equals(")")) {
                    tokens.remove(ind);
                    priors.remove(ind);
                    types.remove(ind);
                    tknInd--;
                }
                ind++;
            }
        }
    }

    private List<String> getIndexes(int ind, final List<String> priors) {
        List<String> indexes = new ArrayList<>();
        boolean flag;
        while (ind < priors.size()) {
            flag = true;
            if (!priors.get(ind).equals(" ") && indexes.size() == 0) {
                indexes.add(priors.get(ind));
            }
            if (!priors.get(ind).equals(" ")) {
                for (final String index : indexes) {
                    if (priors.get(ind).equals(index)) {
                        flag = false;
                        break;
                    }
                }
                if (flag) {
                    indexes.add(priors.get(ind));
                }
            }
            ind++;
        }
        Collections.sort(indexes);
        return indexes;
    }

    private List<Integer> getPriorityOpNums(final List<String> prior, final List<String> indexes) {
        List<Integer> res = new ArrayList<>();
        int ind = 0;
        for (final String index : indexes) {
            for (final String s : prior) {
                if (index.equals(s)) {
                    ind++;
                }
            }
            if (ind > 0) {
                res.add(ind);
                ind = 0;
            }
        }
        return res;
    }

    private List<String> getPriors(final List<String> tkn, final List<String> tp, int i, int p) {
        List<String> priors = new ArrayList<>();
        while (i < tkn.size()) {
            if (tp.get(i).equals("(")) {
                p += 3;
                priors.add(" ");
            }
            if (tp.get(i).equals(")")) {
                p -= 3;
                priors.add(" ");
            }
            if (tp.get(i).equals("Op")) {
                if (tkn.get(i).equals("*") || tkn.get(i).equals("/")) {
                    priors.add(Integer.toString(p + 2));
                }
                if (tkn.get(i).equals("+") || tkn.get(i).equals(("-"))) {
                    priors.add(Integer.toString(p + 1));
                }
            }
            if (tp.get(i).equals("Num") || tp.get(i).equals("Var")) {
                priors.add(" ");
            }
            i++;
        }
        return priors;
    }
}
