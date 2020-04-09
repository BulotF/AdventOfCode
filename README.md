# AdventOfCode
My solutions for AOC (XSLT for 2019) : https://adventofcode.com/

J'ai écrit le programme d'appel avec ant.
Il est possible de faire la même chose avec Java.
Exemples dans : Eno\src\main\java\fr\insee\eno\transform\xsl\XslTransformation.java

Chaque programme a la même structure :
- un fichier build.xml permet de définir un pipeline XSLT (enchaînement de transformations xslt)
- les transformations xslt sont dans le répertoire xslt
- le fichier texte est dans le répertoire in
- les fichiers xml créés aux étapes intermédiaires sont stockés dans le répertoire temp, ce qui permet de suivre le comportement des programmes sans les lancer
- les fichiers finaux sont dans le répertoire out

Les commentaires sont destinés à comprendre le langage et la démarche.

## Getting Started
 
### Prior for Ant usage: 
 
 * Apache Ant. You can download Ant from Apache, see also : [Ant Apache](http://ant.apache.org/)
 
 * Source code from github.com.
 
Then you have to donwload Java Libraries : 

* Ant-Contrib 0.6 or higher (collection of tasks for Apache Ant), see also : [Ant contrib](http://ant-contrib.sourceforge.net/)
* Saxon HE 9.X or higher (The XSLT and XQuery Processor), see also : [Saxon](https://mvnrepository.com/artifact/net.sf.saxon/Saxon-HE)
* Saxon-unpack, included as standard in each Saxon edition
* Common lang 3 or higher (for the non regression test only), see also : [Apache Commons lang](https://commons.apache.org/proper/commons-lang/)

Paste the ".jar" file in a "/lib/" folder at the Eno project root.
