package lab2;

import java.util.*;

public class Lab2 {
    static int maxBlocks = 40;
    static int numDescriptor = 0;
    static int maxDescriptor = 16;
    static boolean isMounted = false;
    static int currBlocks = 0;
    static int fileId = 0;
    static int blockId = 0;
    static int fdId = 0;
    static Map<Integer, String> fdMap = new HashMap<>();

    public static void main(String[] args) {
        labTest();
    }

    public static void fileCreationEnc() {
        numDescriptor += 1;
        currBlocks += 5;
        fileId += 1;
        blockId += 5;
    }

    public static <T, E> Set<T> getKeysByValue(Map<T, E> map, E value) {
        HashSet<T> keys = new HashSet<T>();
        for (Map.Entry<T, E> entry : map.entrySet()) {
            if (Objects.equals(value, entry.getValue())) {
                keys.add(entry.getKey());
            }
        }
        return keys;
    }

    public static void labTest() {
        Directory directory = new Directory();
        System.out.println("Enter fs command: ");
        Scanner scanner = new Scanner(System.in);
        while (true) {
            String input = scanner.nextLine().toLowerCase();

            if (input.equals("exit")) {
                System.out.println("Exiting the program");
                break;
            } else if (input.equals("mount")) {
                System.out.println("Mounted the FS");
                isMounted = true;
            } else if (input.equals("unmount")) {
                System.out.println("Unmounted the FS");
                isMounted = true;
            } else if (input.contains("create") && isMounted) {
                String[] splited = input.split(" ");
                if (splited.length != 2) {
                    System.out.println("Invalid command syntax (create <name>)");
                } else if (!splited[1].matches("[A-Za-z0-9]+")) {
                    System.out.println("Name is invalid");
                } else {
                    if (numDescriptor < maxDescriptor) {
                        directory.addNewFile(fileId, splited[1], blockId);
                        fileCreationEnc();
                        System.out.println("File " + splited[1] + " created!");
                    } else {
                        System.out.println("There are no available descriptors");
                    }
                }
            } else if (input.equals("ls") && isMounted) {
                Map<String, Integer> files = directory.ls();
                if (files.size() != 0) {
                    for (String value : files.keySet()) {
                        for (Integer integer : files.values()) {
                            System.out.println("File name: " + value + " descriptor id = " + integer);
                        }
                    }
                } else {
                    System.out.println("Directory is empty");
                }
            } else if (input.contains("filestat") && isMounted) {
                boolean flag = true;
                String[] splited = input.split(" ");
                if (splited.length != 2) {
                    System.out.println("Invalid command syntax (filestat <id>)");
                } else if (!splited[1].matches("[0-9]+")) {
                    System.out.println("Invalid id");
                } else {
                    for (Integer str : directory.getLinks().values()) {
                        for (Integer integer : directory.getFileMap().keySet()) {
                            if (splited[1].equals(str.toString())) {
                                System.out.println(directory.getFileMap().get(integer).getDescriptor().toString());
                                flag = false;
                                break;
                            }
                            if (flag) {
                                System.out.println("No file with id: " + splited[1]);
                            }
                        }

                    }
                }
            } else if (input.contains("open") && isMounted) {
                boolean flag = true;
                String[] splited = input.split(" ");
                if (splited.length != 2) {
                    System.out.println("Invalid command syntax (open <name>)");
                } else if (!splited[1].matches("[A-Za-z0-9]+")) {
                    System.out.println("Invalid name");
                } else {
                    for (String string : directory.getLinks().keySet()) {
                        if (splited[1].equals(string)) {
                            fdMap.put(fdId, splited[1]);
                            fdId += 1;
                            System.out.println("File " + splited[1] + " opened");
                            flag = false;
                        }
                    }
                    if (flag) {
                        System.out.println("No file with name " + splited[1]);
                    }
                }
            } else if (input.contains("close") && isMounted) {
                boolean flag = true;
                String[] splited = input.split(" ");
                if (splited.length != 2) {
                    System.out.println("Invalid command syntax (close <fd>)");
                } else if (!splited[1].matches("[0-9]+")) {
                    System.out.println("Invalid fd");
                } else {
                    for (Integer integer : fdMap.keySet()) {
                        if (splited[1].equals(integer.toString())) {
                            fdMap.remove(integer);
                            System.out.println("File with fd " + splited[1] + " closed");
                            flag = false;
                            break;
                        }
                    }
                    if (flag) {
                        System.out.println("No opened file with fd " + splited[1]);
                    }
                }
            } else if (input.contains("read") && isMounted) {
                boolean flag = true;
                String[] splited = input.split(" ");
                if (splited.length != 4) {
                    System.out.println("Invalid command syntax (read <fd> <tap> <size>)");
                } else if (!splited[1].matches("[0-9]+") ||
                        !splited[2].matches("[0-9]+") ||
                        !splited[3].matches("[0-9]+")) {
                    System.out.println("Invalid options");
                } else {
                    for (Integer integer : fdMap.keySet()) {
                        if (splited[1].equals(integer.toString())) {
                            int toReadFileId = directory.getLinks().get(fdMap.get(integer));
                            File file = directory.getFileMap().get(toReadFileId);
                            String res = file.read(Integer.parseInt(splited[2]), Integer.parseInt(splited[3]));
                            flag = false;
                            System.out.println(res);
                        }
                    }
                    if (flag) {
                        System.out.println("No opened file with fd " + splited[1]);
                    }
                }
            } else if (input.contains("write") && isMounted) {
                boolean flag = true;
                String toWrite = "";
                String[] splited = input.split(" ");
                for (int i = 4; i < splited.length; i++) {
                    if (i != splited.length - 1) {
                        toWrite += splited[i] + " ";
                    } else {
                        toWrite += splited[i];
                    }
                }
                if (splited.length < 4) {
                    System.out.println("Invalid command syntax (write <fd> <tap> <size>)");
                } else if (!splited[1].matches("[0-9]+") ||
                        !splited[2].matches("[0-9]+") ||
                        !splited[3].matches("[0-9]+")) {
                    System.out.println("Invalid options");
                } else {
                    for (Integer integer : fdMap.keySet()) {
                        if (splited[1].equals(integer.toString())) {
                            int toReadFileId = directory.getLinks().get(fdMap.get(integer));
                            File file = directory.getFileMap().get(toReadFileId);
                            String res = file.write(Integer.parseInt(splited[2]), Integer.parseInt(splited[3]), toWrite);
                            flag = false;
                            System.out.println(res);
                        }
                    }
                    if (flag) {
                        System.out.println("No opened file with fd " + splited[1]);
                    }
                }
            } else if (input.startsWith("link") && isMounted) {
                boolean flag = true;
                String[] splited = input.split(" ");
                if (splited.length != 3) {
                    System.out.println("Invalid command syntax (link <name1> <name2>)");
                } else if (!splited[1].matches("[A-Za-z0-9]+") ||
                        !splited[2].matches("[A-Za-z0-9]+")) {
                    System.out.println("Invalid name");
                } else {
                    for (String str : directory.getLinks().keySet()) {
                        if (splited[1].equals(str)) {
                            directory.getLinks().put(splited[2], directory.getLinks().get(splited[1]));
                            directory.getFileMap().get(directory.getLinks().get(splited[1])).getDescriptor().inc();
                            flag = false;
                            System.out.println("Created link");
                            break;
                        }
                    }
                    if (flag) {
                        System.out.println("No file with name " + splited[1]);
                    }
                }
            } else if (input.startsWith("unlink") && isMounted) {
                System.out.println("start");
                boolean flag = true;
                String[] splited = input.split(" ");
                if (splited.length != 2) {
                    System.out.println("Invalid command syntax (unlink <name>)");
                } else if (!splited[1].matches("[A-Za-z0-9]+")) {
                    System.out.println("Invalid name of file");
                } else {
                    System.out.println("start 2");
                    for (String str : directory.getLinks().keySet()) {
                        System.out.println("start 3");
                        if (splited[1].equals(str)) {
                            System.out.println("start 4");
                            directory.getFileMap().get(directory.getLinks().get(splited[1])).getDescriptor().dec();
                            if (directory.getFileMap().get(directory.getLinks().get(splited[1])).getDescriptor().getCounter() == 0) {
                                System.out.println("start 5");
                                currBlocks -= directory.getFileMap().get(directory.getLinks().get(splited[1])).getSizeValue();
                                directory.getFileMap().remove(directory.getLinks().get(splited[1]));
                                directory.getLinks().remove(splited[1]);
                                numDescriptor -= 1;
                                System.out.println("Link and file deleted");
                            }
                            System.out.println("start 6");
                            flag = false;
                            break;
                        }
                    }
                    if (flag) {
                        System.out.println("No file with name " + splited[1]);
                    }
                }
            } else if (input.contains("truncate") && isMounted) {
                boolean flag = true;
                String[] splited = input.split(" ");
                if (splited.length != 3) {
                    System.out.println("Invalid command syntax (truncate <name> <size>)");
                } else if (!splited[1].matches("[A-Za-z0-9]+") ||
                        !splited[2].matches("[A-Za-z0-9]+")
                ) {
                    System.out.println("Invalid name of file");
                } else {
                    for (String str : directory.getLinks().keySet()) {
                        if (splited[1].equals(str)) {
                            String res = directory.getFileMap().get(directory.getLinks().get(splited[1]))
                                    .changeSize(Integer.parseInt(splited[2]), blockId, maxBlocks, currBlocks);
                            blockId += Integer.parseInt(res.substring(res.lastIndexOf(" ")+1));
                            flag = false;
                            System.out.println(res);
                            break;
                        }
                    }
                    if (flag) {
                        System.out.println("No file with name " + splited[1]);
                    }
                }
            } else {
                System.out.println("Not a command");
            }
        }
    }
}
