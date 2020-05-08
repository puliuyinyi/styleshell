package org.plyy.java2.tools;

import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import java.io.File;
import java.util.List;

public class DependenciesAnalyser {

    // 1. 从各个微服务获取实际使用的三方件
    // 2. 解析pom工程的EffectivePom.xml，找到这些三方件的版本号，保存
    // 3. 升级pom工程的cloudSop底座版本，然后再执行一次2步骤，找到变更后这些三方件的版本号
    // 4. 前后对比
    public static void main(String[] args) throws DocumentException {
        File.separator
        SAXReader reader = new SAXReader();
        File pomXmlFile = new File("pom.xml");
        Document document = reader.read(pomXmlFile);
        List<Element> dependencies = document.getRootElement().element("dependencies").elements("dependency");
        Table<String, String, String> aTable = HashBasedTable.create();
        Table<String, String, String> bTable = HashBasedTable.create();
        for (Element dependency : dependencies) {
            String groupId = dependency.element("groupId").getStringValue();
            String artifactId = dependency.element("artifactId").getStringValue();
            String version = dependency.element("version").getStringValue();
            aTable.put(groupId, artifactId, version);
            bTable.put(groupId, artifactId, version);
        }
        StringBuilder sb = new StringBuilder();
        for (Table.Cell<String, String, String> cell : aTable.cellSet()) {
            String aVersion = cell.getValue();
            String bVersion = bTable.get(cell.getRowKey(), cell.getColumnKey());
            String mark;
            if (aVersion.equals(bVersion)) {
                mark = "matched";
            } else {
                mark = "not matched";
            }
            sb.append(cell.getRowKey() + "," + cell.getColumnKey() + "," + aVersion + "," + bVersion + "," + mark + "\n");
        }
        System.out.println(sb.toString());
    }

}
