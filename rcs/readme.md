##Інструкція до запуску ЛР1
1. Скачати та встановити jdk11: https://www.oracle.com/java/technologies/javase-jdk11-downloads.html
2. Відредагувати змінну середовища в консолі:<br>
Windows:<br>
`setx -m JAVA_HOME "<yourPath>\jdk-11.0.7"`
<br>
`setx -m PATH "%JAVA_HOME%\bin;%PATH%"` 
<br>
Linux:<br>
`export JAVA_HOME=<yourPath>`
<br>
`export PATH=$JAVA_HOME/bin:$PATH`
3. Перевірити, що все встановлено і налаштовано:<br>
`java -version`
<br>
`javac -version`
4. Зклонувати репозиторій:<br>
`git clone https://github.com/smithros/kpi-stuff.git`
5. Перейти в директорію:<br>
Windows:<br>
`cd kpi-stuff\rcs\src\main\java\ua\com\kpi\rcs`
<br>
Linux:<br>
`cd kpi-stuff/rcs/src/main/java/ua/com/kpi/rcs`
6. Запустити програму:<br>
`java Lab1.java`
7. Ввести потрібні значення.
