package lab2;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ParallelTree {

    public void constructTree(final List<String> tokens, final List<String> types) {
        this.changeTokens(tokens);
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

    private void changeTokens(final List<String> tokens) {
        System.out.println(tokens);
        List<Token> operations = new ArrayList<>();
        for (int i = 0; i < tokens.size(); i++) {
            if (tokens.get(i).matches("[-+*/]")) {
                operations.add(new Token(i, tokens.get(i)));
            }
        }
        System.out.println(operations);
        Map<String, Integer> map = new HashMap<>();
        if (operations.size() >= 3) {
            for (int i = 0; i < 3; i++) {
                String key = operations.get(i).getOp();
                if (map.containsKey(key)) {
                    map.put(key, map.get(key) + 1);
                }
                else {
                    map.put(key, 1);
                }
            }
        }
        for (int i = 2; i < operations.size()-1; i++) {
            System.out.println(i);
            String key_prev = operations.get(i-2).getOp();
            String key_next = operations.get(i+1).getOp();
            String key_curr = operations.get(i).getOp();
            for (final String s : map.keySet()) {
                // If we have 3 sequential operations we should change the
                // operation on the last index, and update the map with our
                // new operation.
                if (map.get(s) == 3) {
                    operations.get(i).setOp(swapOperation(operations.get(i)));
                    System.out.println("3+ ops: ");
                    System.out.println(map);
                    String key_curr_swapped = operations.get(i).getOp();
                    map.put(key_curr, map.get(key_curr) - 1);
                    if (map.containsKey(key_curr_swapped)) {
                        map.put(key_curr_swapped, map.get(key_curr_swapped) + 1);
                    } else {
                        map.put(key_curr_swapped, 1);
                    }
                }
            }
            // In any case we move on and decrement previous op
            // and increment next operation in our map
            System.out.println("Before step: ");
            System.out.println(map);
            map.put(key_prev, map.get(key_prev) - 1);
            map.put(key_next, map.get(key_next) + 1);
            System.out.println("After: ");
            System.out.println(map);
        }

        for (Token operation : operations) {
            System.out.println(operation);
        }

        for (final Token operation : operations) {
            int i = operation.getIndex();
            tokens.set(i, operation.getOp());
        }
        System.out.println(tokens);
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

    private String swapOperation(final Token operation) {
        return switch (operation.getOp()) {
            case "+" -> "-";
            case "-" -> "+";
            case "/" -> "*";
            case "*" -> "/";
            default -> "?";
        };
    }
}
